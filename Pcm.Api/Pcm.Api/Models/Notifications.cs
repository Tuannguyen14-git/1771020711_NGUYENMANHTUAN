using Pcm.Api.Enums;

namespace Pcm.Api.Models;

public class _177_Notifications
{
    public int Id { get; set; }

    public int ReceiverId { get; set; }
    public string Message { get; set; }

    public NotificationType Type { get; set; }
    public bool IsRead { get; set; }

    public DateTime CreatedDate { get; set; }
}
