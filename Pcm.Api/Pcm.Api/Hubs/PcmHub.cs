using Microsoft.AspNetCore.SignalR;

namespace Pcm.Api.Hubs;

public class PcmHub : Hub
{
    // Broadcast cho toàn bộ client đang xem lịch
    public async Task BroadcastCalendarUpdate(object payload)
    {
        await Clients.All.SendAsync("UpdateCalendar", payload);
    }
}
