using Microsoft.EntityFrameworkCore;
using Pcm.Api.Data;
using Pcm.Api.Enums;

namespace Pcm.Api.BackgroundServices;

public class AutoCancelBookingService : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<AutoCancelBookingService> _logger;

    public AutoCancelBookingService(
        IServiceScopeFactory scopeFactory,
        ILogger<AutoCancelBookingService> logger)
    {
        _scopeFactory = scopeFactory;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("AutoCancelBookingService started");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                using var scope = _scopeFactory.CreateScope();
                var context = scope.ServiceProvider.GetRequiredService<PcmDbContext>();

                var now = DateTime.Now;

                var expiredHolds = await context.Bookings
                    .Where(b =>
                        b.Status == BookingStatus.Holding &&
                        b.HoldExpiredAt != null &&
                        b.HoldExpiredAt < now)
                    .ToListAsync(stoppingToken);

                if (expiredHolds.Any())
                {
                    foreach (var booking in expiredHolds)
                    {
                        booking.Status = BookingStatus.Cancelled;
                    }

                    await context.SaveChangesAsync(stoppingToken);

                    _logger.LogInformation(
                        "Auto-cancelled {Count} expired holding bookings",
                        expiredHolds.Count);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in AutoCancelBookingService");
            }

            // ⏱ chạy mỗi 1 phút
            await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
        }
    }
}
