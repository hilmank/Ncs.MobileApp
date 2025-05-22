using MediatR;
using UsersService.Application.Auth.DTOs;

namespace UsersService.Application.Auth.Commands.SignIn;

public class SignInCommand : IRequest<AuthResultDto?>
{
    public string Username { get; set; } = default!;
    public string Password { get; set; } = default!;
    public int Shift { get; set; } = default!;
}
