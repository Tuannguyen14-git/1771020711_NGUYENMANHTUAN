using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Pcm.Api.Data;
using Pcm.Api.Enums;
using System.Globalization;

namespace Pcm.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize] // Should be [Authorize(Roles = "Admin")] in production
public class StatisticsController : ControllerBase
{
    private readonly PcmDbContext _context;

    public StatisticsController(PcmDbContext context)
    {
        _context = context;
    }

    // GET: api/statistics/dashboard
    [HttpGet("dashboard")]
    public async Task<IActionResult> GetDashboardStats()
    {
        // 1. Total Revenue (Completed/Confirmed Bookings)
        var totalRevenue = await _context.Bookings
            .Where(b => b.Status == BookingStatus.Completed || b.Status == BookingStatus.Confirmed)
            .SumAsync(b => b.TotalPrice);

        // 2. Total Bookings (Non-Cancelled)
        var totalBookings = await _context.Bookings
            .CountAsync(b => b.Status != BookingStatus.Cancelled);

        // 3. Total Members
        var totalMembers = await _context.Members.CountAsync();

        // 4. Comparison with previous month (Simple Logic)
        var lastMonth = DateTime.Now.AddMonths(-1);
        var revenueLastMonth = await _context.Bookings
            .Where(b => (b.Status == BookingStatus.Completed || b.Status == BookingStatus.Confirmed) &&
                        b.StartTime.Month == lastMonth.Month &&
                        b.StartTime.Year == lastMonth.Year)
            .SumAsync(b => b.TotalPrice);

        return Ok(new
        {
            TotalRevenue = totalRevenue,
            TotalBookings = totalBookings,
            TotalMembers = totalMembers,
            RevenueLastMonth = revenueLastMonth
        });
    }

    // GET: api/statistics/revenue?year=2024
    [HttpGet("revenue")]
    public async Task<IActionResult> GetRevenueChart([FromQuery] int? year)
    {
        var targetYear = year ?? DateTime.Now.Year;

        var revenueData = await _context.Bookings
            .Where(b => (b.Status == BookingStatus.Completed || b.Status == BookingStatus.Confirmed) &&
                        b.StartTime.Year == targetYear)
            .GroupBy(b => b.StartTime.Month)
            .Select(g => new
            {
                Month = g.Key,
                Revenue = g.Sum(b => b.TotalPrice)
            })
            .ToListAsync();

        // Fill missing months with 0
        var result = Enumerable.Range(1, 12).Select(month => new
        {
            Month = month,
            MonthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(month),
            Revenue = revenueData.FirstOrDefault(r => r.Month == month)?.Revenue ?? 0
        });

        return Ok(result);
    }

    // GET: api/statistics/top-members
    [HttpGet("top-members")]
    public async Task<IActionResult> GetTopMembers()
    {
        var topMembers = await _context.Members
            .OrderByDescending(m => m.TotalSpent)
            .Take(5)
            .Select(m => new
            {
                m.Id,
                m.FullName,
                m.TotalSpent,
                m.RankLevel,
                m.Tier
            })
            .ToListAsync();

        return Ok(topMembers);
    }
}
