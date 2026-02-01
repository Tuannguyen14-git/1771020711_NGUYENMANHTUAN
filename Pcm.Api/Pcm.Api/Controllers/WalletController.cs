using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pcm.Api.Data;
using Pcm.Api.DTOs;
using Pcm.Api.Enums;
using Pcm.Api.Models;

namespace Pcm.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class WalletController : ControllerBase
{
    private readonly PcmDbContext _context;

    public WalletController(PcmDbContext context)
    {
        _context = context;
    }

    // POST: api/wallet/deposit
    [HttpPost("deposit")]
    public async Task<IActionResult> Deposit(DepositRequestDto dto)
    {
        if (dto.Amount <= 0)
            return BadRequest("Số tiền phải > 0");

        var member = await _context.Members.FindAsync(dto.MemberId);
        if (member == null)
            return NotFound("Không tìm thấy hội viên");

        // 1. Cộng tiền vào ví
        member.WalletBalance += dto.Amount;

        // 2. Ghi lịch sử giao dịch
        var transaction = new _177_WalletTransactions
        {
            MemberId = dto.MemberId,
            Amount = dto.Amount,
            Type = WalletTransactionType.Deposit,
            Status = WalletTransactionStatus.Completed,
            Description = dto.Description ?? "Nạp tiền",
            CreatedDate = DateTime.Now
        };

        _context.WalletTransactions.Add(transaction);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            Message = "Nạp tiền thành công",
            WalletBalance = member.WalletBalance
        });
    }

    // GET: api/wallet/transactions/{memberId}
    [HttpGet("transactions/{memberId}")]
    public async Task<IActionResult> GetTransactions(int memberId)
    {
        var member = await _context.Members.FindAsync(memberId);
        if (member == null)
            return NotFound("Không tìm thấy hội viên");

        var transactions = await _context.WalletTransactions
            .Where(t => t.MemberId == memberId)
            .OrderByDescending(t => t.CreatedDate)
            .ToListAsync();

        return Ok(transactions);
    }
}
