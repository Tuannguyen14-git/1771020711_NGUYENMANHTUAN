using Pcm.Api.Enums;

namespace Pcm.Api.Models;

public class _177_Matches
{
    public int Id { get; set; }

    public int? TournamentId { get; set; }
    public string RoundName { get; set; }

    public DateTime MatchDate { get; set; }

    public int Score1 { get; set; }
    public int Score2 { get; set; }

    public MatchStatus Status { get; set; }
    public bool IsRanked { get; set; }
}
