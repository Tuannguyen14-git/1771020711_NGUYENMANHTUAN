namespace Pcm.Api.Models;

public class AppUser
{
    public int Id { get; set; }
    public string Username { get; set; } = null!;
    public string Password { get; set; } = null!;
    public string Role { get; set; } = "Member"; // Admin | Member
}
