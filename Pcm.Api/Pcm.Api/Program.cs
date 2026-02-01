using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Pcm.Api.Data;
using Pcm.Api.BackgroundServices;
using Pcm.Api.Hubs;

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
    // Replace postgres:// with http:// for Uri parsing (Uri class doesn't recognize postgres scheme)
    var databaseUri = new Uri(databaseUrl.Replace("postgres://", "http://"));
    var userInfo = databaseUri.UserInfo.Split(':');
    
    connectionString = $"Host={databaseUri.Host};Port={databaseUri.Port};Database={databaseUri.AbsolutePath.Trim('/')};Username={userInfo[0]};Password={userInfo[1]};SSL Mode=Require;Trust Server Certificate=true";
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

#region MIDDLEWARE PIPELINE
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("AllowAll");      // ⚠️ CORS PHẢI TRƯỚC AUTH
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapHub<PcmHub>("/pcmHub");
#endregion

app.Run();
