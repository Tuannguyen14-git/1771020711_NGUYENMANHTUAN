namespace Pcm.Api.Models;

public class _177_TournamentParticipants
{
    public int Id { get; set; }

    public int TournamentId { get; set; }
    public int MemberId { get; set; }

    public string? TeamName { get; set; }
    public bool PaymentStatus { get; set; }
}
