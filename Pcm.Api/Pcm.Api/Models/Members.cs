using Pcm.Api.Enums;

namespace Pcm.Api.Models;

public class _177_Members
{
    public int Id { get; set; }   // 🔑 BẮT BUỘC – PRIMARY KEY
    public int? AppUserId { get; set; } // Link to AppUser

    public string FullName { get; set; }
    public DateTime JoinDate { get; set; }
    public double RankLevel { get; set; }
    public bool IsActive { get; set; }

    public decimal WalletBalance { get; set; }
    public decimal TotalSpent { get; set; }

    public MemberTier Tier { get; set; }
    public string? AvatarUrl { get; set; }
}
