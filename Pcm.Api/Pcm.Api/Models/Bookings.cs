using Pcm.Api.Enums;

public class _177_Bookings
{
    public int Id { get; set; }

    public int CourtId { get; set; }
    public int MemberId { get; set; }

    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }

    public decimal TotalPrice { get; set; }
    public BookingStatus Status { get; set; }

    public DateTime? HoldExpiredAt { get; set; }   

    public bool IsRecurring { get; set; }
    public string? RecurrenceRule { get; set; }
    public int? ParentBookingId { get; set; }
}
