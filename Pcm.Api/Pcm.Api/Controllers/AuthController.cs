using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authorization;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Pcm.Api.Data;
using Pcm.Api.DTOs;

namespace Pcm.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly PcmDbContext _context;
    private readonly IConfiguration _config;

    public AuthController(PcmDbContext context, IConfiguration config)
    {
        _context = context;
        _config = config;
    }

    [HttpPost("register")]
    public IActionResult Register(RegisterRequestDto dto)
    {
        if (_context.AppUsers.Any(x => x.Username == dto.Username))
            return BadRequest("Tài khoản đã tồn tại");

        var user = new Models._177_AppUsers
        {
            Username = dto.Username,
            Password = dto.Password, // Simple plain text for demo
            Role = "Member",
            Email = dto.Email ?? $"{dto.Username}@example.com"
        };

        _context.AppUsers.Add(user);
        _context.SaveChanges();

        // Auto-login after register? Or just return OK.
        return Ok(new { Message = "Đăng ký thành công" });
    }

    [HttpPost("login")]
    public IActionResult Login(LoginRequestDto dto)
    {
        var user = _context.AppUsers
            .FirstOrDefault(x => x.Username == dto.Username && x.Password == dto.Password);

        if (user == null)
            return Unauthorized("Sai tài khoản hoặc mật khẩu");

        var jwt = _config.GetSection("Jwt");
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwt["Key"]!));

        var claims = new[]
        {
            new Claim(ClaimTypes.Name, user.Username),
            new Claim(ClaimTypes.Role, user.Role)
        };

        var token = new JwtSecurityToken(
            issuer: jwt["Issuer"],
            audience: jwt["Audience"],
            claims: claims,
            expires: DateTime.Now.AddMinutes(120),
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256)
        );

        var member = _context.Members.FirstOrDefault(x => x.AppUserId == user.Id);

        if (member == null)
        {
            member = new Models._177_Members
            {
                AppUserId = user.Id,
                FullName = user.Username,
                JoinDate = DateTime.Now,
                RankLevel = 0,
                IsActive = true,
                WalletBalance = 0,
                TotalSpent = 0,
                Tier = Enums.MemberTier.Standard,
                AvatarUrl = ""
            };
            _context.Members.Add(member);
            _context.SaveChanges();
        }

        return Ok(new
        {
            token = new JwtSecurityTokenHandler().WriteToken(token),
            role = user.Role,
            user = new
            {
                id = member.Id,
                fullName = member.FullName,
                joinDate = member.JoinDate.ToString("yyyy-MM-ddTHH:mm:ss"),
                rankLevel = member.RankLevel,
                isActive = member.IsActive,
                userId = user.Username, // Mapping Username to userId for mobile
                walletBalance = member.WalletBalance,
                tier = member.Tier.ToString(),
                totalSpent = member.TotalSpent,
                avatarUrl = member.AvatarUrl
            }
        });
    }

    [HttpGet("me")]
    [Authorize]
    public IActionResult Me()
    {
        var username = User.Identity?.Name;
        if (string.IsNullOrEmpty(username))
            return Unauthorized();

        var user = _context.AppUsers.FirstOrDefault(x => x.Username == username);
        if (user == null)
            return NotFound();

        var member = _context.Members.FirstOrDefault(x => x.AppUserId == user.Id);
        
        // If member is not found, we might want to return NotFound or just the user data.
        // But Mobile expects Member.fromJson, so we must return Member format.
        // Auto-create Member if not found
        if (member == null)
        {
            member = new Models._177_Members
            {
                AppUserId = user.Id,
                FullName = user.Username,
                JoinDate = DateTime.Now,
                RankLevel = 0,
                IsActive = true,
                WalletBalance = 0,
                TotalSpent = 0,
                Tier = Enums.MemberTier.Standard,
                AvatarUrl = ""
            };
            _context.Members.Add(member);
            _context.SaveChanges();
        }

        return Ok(new
        {
            id = member.Id,
            fullName = member.FullName,
            joinDate = member.JoinDate.ToString("yyyy-MM-ddTHH:mm:ss"),
            rankLevel = member.RankLevel,
            isActive = member.IsActive,
            userId = user.Username, 
            walletBalance = member.WalletBalance,
            tier = member.Tier.ToString(),
            totalSpent = member.TotalSpent,
            avatarUrl = member.AvatarUrl
        });
    }
}
