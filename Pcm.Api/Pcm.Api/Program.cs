using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Pcm.Api.Data;
using Pcm.Api.BackgroundServices;
using Pcm.Api.Hubs;
using Pcm.Api.Models;
using Pcm.Api.Enums;

var builder = WebApplication.CreateBuilder(args);

#region CORS (CHO FLUTTER WEB + DEV)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});
#endregion

#region CONTROLLERS + SIGNALR
builder.Services.AddControllers();
builder.Services.AddSignalR();
#endregion

#region DATABASE
// Support both SQL Server (local) and PostgreSQL (production)
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
var usePostgres = builder.Configuration.GetValue<bool>("UsePostgreSQL");

// Check for Render DATABASE_URL environment variable
var databaseUrl = Environment.GetEnvironmentVariable("DATABASE_URL");
if (!string.IsNullOrEmpty(databaseUrl))
{
    // Parse DATABASE_URL from Render (postgres://user:pass@host:port/db)
    // Handle both postgres:// and postgresql:// and provide default port if missing
    // Use tcp:// instead of http:// to avoid defaulting to port 80
    var formattedUrl = databaseUrl.Replace("postgresql://", "tcp://").Replace("postgres://", "tcp://");
    var databaseUri = new Uri(formattedUrl);
    var userInfo = databaseUri.UserInfo.Split(':');
    
    var host = databaseUri.Host;
    var port = databaseUri.Port > 0 ? databaseUri.Port : 5432;
    var database = databaseUri.AbsolutePath.Trim('/');
    var user = userInfo[0];
    var password = userInfo.Length > 1 ? userInfo[1] : "";
    
    connectionString = $"Host={host};Port={port};Database={database};Username={user};Password={password};SSL Mode=Require;Trust Server Certificate=true";
    usePostgres = true;
}

if (usePostgres)
{
    builder.Services.AddDbContext<PcmDbContext>(options =>
        options.UseNpgsql(connectionString)
    );
}
else
{
    builder.Services.AddDbContext<PcmDbContext>(options =>
        options.UseSqlServer(connectionString)
    );
}
#endregion

#region JWT AUTHENTICATION
var jwtSettings = builder.Configuration.GetSection("Jwt");
var key = Encoding.UTF8.GetBytes(jwtSettings["Key"]!);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,

        ValidIssuer = jwtSettings["Issuer"],
        ValidAudience = jwtSettings["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(key)
    };
});
#endregion

#region BACKGROUND SERVICE
builder.Services.AddHostedService<AutoCancelBookingService>();
#endregion

#region SWAGGER
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
#endregion

var app = builder.Build();

// Auto-apply migrations on startup (for production deployment)
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<PcmDbContext>();
        context.Database.Migrate(); // Apply pending migrations
        
        // Seed default admin account if not exists
        var adminUser = context.AppUsers.FirstOrDefault(u => u.Username == "admin");
        if (adminUser == null)
        {
            adminUser = new AppUser
            {
                Username = "admin",
                Password = "123", 
                Role = "Admin"
            };
            context.AppUsers.Add(adminUser);
            context.SaveChanges();
        }
        else
        {
            // Ensure password is correct
            adminUser.Password = "123";
            context.SaveChanges();
        }
            
        // Link to a Member record
        if (!context.Members.Any(m => m.AppUserId == adminUser.Id))
        {
            context.Members.Add(new _177_Members
            {
                AppUserId = adminUser.Id,
                FullName = "Administrator",
                JoinDate = DateTime.Now,
                RankLevel = 5.0,
                IsActive = true,
                WalletBalance = 1000000m,
                TotalSpent = 0m,
                Tier = MemberTier.Diamond,
                AvatarUrl = ""
            });
            context.SaveChanges();
        }

        // Seed default member account if not exists
        var regularUser = context.AppUsers.FirstOrDefault(u => u.Username == "user");
        if (regularUser == null)
        {
            regularUser = new AppUser
            {
                Username = "user",
                Password = "123",
                Role = "Member"
            };
            context.AppUsers.Add(regularUser);
            context.SaveChanges();
        }
        else
        {
            // Ensure password is correct
            regularUser.Password = "123";
            context.SaveChanges();
        }
            
        if (!context.Members.Any(m => m.AppUserId == regularUser.Id))
        {
            context.Members.Add(new _177_Members
            {
                AppUserId = regularUser.Id,
                FullName = "Thành Viên Mẫu",
                JoinDate = DateTime.Now,
                RankLevel = 3.5,
                IsActive = true,
                WalletBalance = 500000m,
                TotalSpent = 0m,
                Tier = MemberTier.Gold,
                AvatarUrl = ""
            });
            context.SaveChanges();
        }
    }
    catch (Exception ex)
    {
        var logger = services.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "An error occurred while migrating the database.");
    }
}


#region MIDDLEWARE PIPELINE
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("AllowAll");      // ⚠️ CORS PHẢI TRƯỚC AUTH
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapHub<PcmHub>("/pcmHub");

// Root endpoint for simple health check
app.MapGet("/", () => "PCM API is running on Render!");

#endregion

app.Run();
