using Pcm.Api.Enums;

namespace Pcm.Api.Models;

public class _177_Tournaments
{
    public int Id { get; set; }

    public string Name { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }

    public TournamentFormat Format { get; set; }
    public TournamentStatus Status { get; set; }

    public decimal EntryFee { get; set; }
    public decimal PrizePool { get; set; }

    public string? Settings { get; set; }
}
