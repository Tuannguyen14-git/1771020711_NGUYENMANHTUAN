using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pcm.Api.Data;
using Pcm.Api.DTOs;
using Pcm.Api.Enums;
using Pcm.Api.Models;
namespace Pcm.Api.Controllers;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Pcm.Api.Hubs;

[ApiController]
[Route("api/[controller]")]
public class BookingsController : ControllerBase
{

    private readonly PcmDbContext _context;
    private readonly IHubContext<PcmHub> _hub;

    
    public BookingsController(
    PcmDbContext context,
    IHubContext<PcmHub> hub)
    {
        _context = context;
        _hub = hub;
    }


    // POST: api/bookings
    [HttpPost]
    public async Task<IActionResult> Create(BookingCreateDto dto)
    {
        // 1) Validate thời gian
        if (dto.EndTime <= dto.StartTime)
            return BadRequest("Thời gian kết thúc phải sau thời gian bắt đầu");

        // 2) Kiểm tra member
        var member = await _context.Members.FindAsync(dto.MemberId);
        if (member == null)
            return NotFound("Không tìm thấy hội viên");

        // 3) Kiểm tra sân
        var court = await _context.Courts.FindAsync(dto.CourtId);
        if (court == null || !court.IsActive)
            return NotFound("Sân không tồn tại hoặc đang ngưng hoạt động");

        // 4) Chặn trùng lịch (OVERLAP)
        bool isOverlapped = await _context.Bookings.AnyAsync(b =>
            b.CourtId == dto.CourtId &&
            b.Status != BookingStatus.Cancelled &&
            dto.StartTime < b.EndTime &&
            dto.EndTime > b.StartTime
        );

        if (isOverlapped)
            return BadRequest("Khung giờ đã có người đặt");

        // 5) Tính tiền
        var hours = (decimal)(dto.EndTime - dto.StartTime).TotalHours;
        if (hours <= 0)
            return BadRequest("Thời lượng đặt không hợp lệ");

        var totalPrice = Math.Ceiling(hours) * court.PricePerHour;

        // 6) Kiểm tra số dư ví
        if (member.WalletBalance < totalPrice)
            return BadRequest("Số dư ví không đủ");

        // 7) Trừ tiền + tạo booking + ghi transaction (atomic)
        using var transaction = await _context.Database.BeginTransactionAsync();

        try
        {
            member.WalletBalance -= totalPrice;
            member.TotalSpent += totalPrice;

            var booking = new _177_Bookings
            {
                CourtId = dto.CourtId,
                MemberId = dto.MemberId,
                StartTime = dto.StartTime,
                EndTime = dto.EndTime,
                TotalPrice = totalPrice,
                Status = BookingStatus.Confirmed,
                IsRecurring = false
            };

            _context.Bookings.Add(booking);

            var walletTx = new _177_WalletTransactions
            {
                MemberId = dto.MemberId,
                Amount = -totalPrice,
                Type = WalletTransactionType.Payment,
                Status = WalletTransactionStatus.Completed,
                Description = $"Thanh toán đặt sân #{dto.CourtId}",
                CreatedDate = DateTime.Now
            };

            _context.WalletTransactions.Add(walletTx);

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return Ok(new
            {
                Message = "Đặt sân thành công",
                BookingId = booking.Id,
                TotalPrice = totalPrice,
                WalletBalance = member.WalletBalance
            });
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    // GET: api/bookings/calendar?from=...&to=...
    [HttpGet("calendar")]
    public async Task<IActionResult> GetCalendar(DateTime from, DateTime to)
    {
        var bookings = await _context.Bookings
            .Where(b => b.StartTime >= from && b.EndTime <= to)
            .ToListAsync();

        return Ok(bookings);
    }
    // POST: api/bookings/cancel/5
    [HttpPost("cancel/{id}")]
    public async Task<IActionResult> Cancel(int id)
    {
        // 1) Tìm booking
        var booking = await _context.Bookings.FindAsync(id);
        if (booking == null)
            return NotFound("Không tìm thấy booking");

        if (booking.Status == BookingStatus.Cancelled)
            return BadRequest("Booking đã bị huỷ trước đó");

        if (booking.Status == BookingStatus.Completed)
            return BadRequest("Booking đã hoàn thành, không thể huỷ");

        // 2) Tìm hội viên
        var member = await _context.Members.FindAsync(booking.MemberId);
        if (member == null)
            return NotFound("Không tìm thấy hội viên");

        // 3) Tính thời gian còn lại
        var hoursBefore = (booking.StartTime - DateTime.Now).TotalHours;
        if (hoursBefore <= 0)
            return BadRequest("Đã quá giờ bắt đầu, không thể huỷ");

        // 4) Xác định % hoàn tiền
        decimal refundRate = 0;
        if (hoursBefore >= 24)
            refundRate = 1.0m;        // 100%
        else if (hoursBefore >= 6)
            refundRate = 0.5m;        // 50%
        else
            refundRate = 0.0m;        // 0%

        var refundAmount = booking.TotalPrice * refundRate;

        // 5) Thực hiện huỷ + hoàn tiền (atomic)
        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            booking.Status = BookingStatus.Cancelled;

            if (refundAmount > 0)
            {
                member.WalletBalance += refundAmount;

                var refundTx = new _177_WalletTransactions
                {
                    MemberId = booking.MemberId,
                    Amount = refundAmount,
                    Type = WalletTransactionType.Refund,
                    Status = WalletTransactionStatus.Completed,
                    Description = $"Hoàn tiền huỷ booking #{booking.Id}",
                    CreatedDate = DateTime.Now
                };

                _context.WalletTransactions.Add(refundTx);
            }

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return Ok(new
            {
                Message = "Huỷ booking thành công",
                RefundRate = refundRate,
                RefundAmount = refundAmount,
                WalletBalance = member.WalletBalance
            });
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }
    // POST: api/bookings/hold
    [HttpPost("hold")]
    public async Task<IActionResult> HoldSlot(BookingCreateDto dto)
    {
        // 1) Validate thời gian
        if (dto.EndTime <= dto.StartTime)
            return BadRequest("Thời gian không hợp lệ");

        // 2) Kiểm tra sân
        var court = await _context.Courts.FindAsync(dto.CourtId);
        if (court == null || !court.IsActive)
            return NotFound("Sân không tồn tại hoặc ngưng hoạt động");

        // 3) Chặn trùng (kể cả HOLD chưa hết hạn)
        var now = DateTime.Now;
        bool isOverlapped = await _context.Bookings.AnyAsync(b =>
            b.CourtId == dto.CourtId &&
            b.Status != BookingStatus.Cancelled &&
            (
                b.Status != BookingStatus.Holding ||
                b.HoldExpiredAt > now
            ) &&
            dto.StartTime < b.EndTime &&
            dto.EndTime > b.StartTime
        );

        if (isOverlapped)
            return BadRequest("Khung giờ đang được giữ hoặc đã đặt");

        // 4) Tạo HOLD booking
        var holdBooking = new _177_Bookings
        {
            CourtId = dto.CourtId,
            MemberId = dto.MemberId,
            StartTime = dto.StartTime,
            EndTime = dto.EndTime,
            Status = BookingStatus.Holding,
            HoldExpiredAt = now.AddMinutes(5),
            TotalPrice = 0,
            IsRecurring = false
        };

        _context.Bookings.Add(holdBooking);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            Message = "Đã giữ chỗ trong 5 phút",
            BookingId = holdBooking.Id,
            HoldExpiredAt = holdBooking.HoldExpiredAt
        });
    }
    // POST: api/bookings/confirm
    [Authorize]
    [HttpPost("confirm")]
    public async Task<IActionResult> ConfirmHold(BookingConfirmDto dto)
    {
        // 1️⃣ Lấy booking HOLD
        var booking = await _context.Bookings.FindAsync(dto.BookingId);
        if (booking == null)
            return NotFound("Không tìm thấy booking");

        if (booking.Status != BookingStatus.Holding)
            return BadRequest("Booking không ở trạng thái HOLD");

        // 2️⃣ Kiểm tra hết hạn HOLD
        if (booking.HoldExpiredAt == null || booking.HoldExpiredAt < DateTime.Now)
            return BadRequest("Thời gian giữ chỗ đã hết");

        // 3️⃣ Kiểm tra hội viên
        var member = await _context.Members.FindAsync(dto.MemberId);
        if (member == null)
            return NotFound("Không tìm thấy hội viên");

        // 4️⃣ Tính tiền
        var court = await _context.Courts.FindAsync(booking.CourtId);
        if (court == null)
            return NotFound("Không tìm thấy sân");

        var hours = (decimal)(booking.EndTime - booking.StartTime).TotalHours;
        var totalPrice = Math.Ceiling(hours) * court.PricePerHour;

        // 5️⃣ Kiểm tra ví
        if (member.WalletBalance < totalPrice)
            return BadRequest("Số dư ví không đủ");

        // 6️⃣ Transaction DB
        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            // Trừ tiền ví
            member.WalletBalance -= totalPrice;
            member.TotalSpent += totalPrice;

            // Cập nhật booking
            booking.TotalPrice = totalPrice;
            booking.Status = BookingStatus.Confirmed;
            booking.HoldExpiredAt = null;

            // Ghi lịch sử ví
            var walletTx = new _177_WalletTransactions
            {
                MemberId = member.Id,
                Amount = -totalPrice,
                Type = WalletTransactionType.Payment,
                Status = WalletTransactionStatus.Completed,
                Description = $"Thanh toán booking #{booking.Id}",
                CreatedDate = DateTime.Now
            };

            _context.WalletTransactions.Add(walletTx);

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            // 7️⃣ SignalR realtime
            await _hub.Clients.All.SendAsync("UpdateCalendar", new
            {
                Action = "CONFIRMED",
                CourtId = booking.CourtId,
                StartTime = booking.StartTime,
                EndTime = booking.EndTime
            });

            return Ok(new
            {
                Message = "Thanh toán thành công",
                BookingId = booking.Id,
                TotalPrice = totalPrice,
                WalletBalance = member.WalletBalance
            });
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }



}
