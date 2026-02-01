namespace Pcm.Api.DTOs;

public class BookingCreateDto
{
    public int CourtId { get; set; }
    public int MemberId { get; set; }

    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
}
