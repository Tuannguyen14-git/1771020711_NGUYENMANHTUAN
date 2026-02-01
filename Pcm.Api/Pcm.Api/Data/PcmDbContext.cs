using Microsoft.EntityFrameworkCore;
using Pcm.Api.Models;

namespace Pcm.Api.Data;

public class PcmDbContext : DbContext
{
    public PcmDbContext(DbContextOptions<PcmDbContext> options)
        : base(options) { }

    public DbSet<_177_Members> Members { get; set; }
    public DbSet<_177_WalletTransactions> WalletTransactions { get; set; }
    public DbSet<_177_Courts> Courts { get; set; }
    public DbSet<_177_Bookings> Bookings { get; set; }
    public DbSet<_177_Tournaments> Tournaments { get; set; }
    public DbSet<_177_TournamentParticipants> TournamentParticipants { get; set; }
    public DbSet<_177_Matches> Matches { get; set; }
    public DbSet<_177_Notifications> Notifications { get; set; }
    public DbSet<_177_News> News { get; set; }
    public DbSet<AppUser> AppUsers { get; set; }

}
