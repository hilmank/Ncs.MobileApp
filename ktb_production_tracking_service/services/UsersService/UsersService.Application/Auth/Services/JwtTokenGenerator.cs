using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace UsersService.Application.Auth.Services;

public interface IJwtTokenGenerator
{
    string GenerateToken(string userId, string username, string role);
}

public class JwtTokenGenerator : IJwtTokenGenerator
{
    private readonly IConfiguration _config;

    public JwtTokenGenerator(IConfiguration config)
    {
        _config = config;
    }

    public string GenerateToken(string userId, string username, string role)
    {
        var jwtSettings = _config.GetSection("JwtSettings");
        var secret = jwtSettings["Secret"] ?? throw new InvalidOperationException("JWT Secret is not configured.");
        var issuer = jwtSettings["Issuer"];
        var audience = jwtSettings["Audience"];
        var expiry = int.Parse(jwtSettings["ExpiryMinutes"] ?? "60");

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));

        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, userId),
            new Claim(ClaimTypes.NameIdentifier, userId), // <- read this
            new Claim(JwtRegisteredClaimNames.UniqueName, username),
            new Claim(ClaimTypes.Role, role)
        };

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(expiry),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
