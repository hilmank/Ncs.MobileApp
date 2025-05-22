namespace UsersService.Application.Auth.DTOs
{
    public class AuthResultDto
    {
        public string Id { get; set; } = default!;
        public string Username { get; set; } = default!;
        public string Role { get; set; } = default!;
        public string? FullName { get; set; }
        public string? Token { get; set; }
        public string? RefreshToken { get; set; }
        public int Shift { get; set; } = default!;
    }
}
