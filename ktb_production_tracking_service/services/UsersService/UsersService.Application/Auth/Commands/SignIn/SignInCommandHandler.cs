using MediatR;
using UsersService.Application.Auth.DTOs;
using UsersService.Application.Auth.Services;
using UsersService.Domain.Interfaces;

namespace UsersService.Application.Auth.Commands.SignIn
{
    public class SignInCommandHandler : IRequestHandler<SignInCommand, AuthResultDto?>
    {
        private readonly IUserRepository _userRepository;
        private readonly IJwtTokenGenerator _tokenGenerator;

        public SignInCommandHandler(IUserRepository userRepository, IJwtTokenGenerator tokenGenerator)
        {
            _userRepository = userRepository;
            _tokenGenerator = tokenGenerator;
        }

        public async Task<AuthResultDto?> Handle(SignInCommand request, CancellationToken cancellationToken)
        {
            // Get user by username
            var user = await _userRepository.GetByUsernameAsync(request.Username);
            if (user == null)
                return null;

            // Validate password (you may want to hash/verify instead)
            if (user.Password != request.Password)
                return null;

            // Generate JWT and refresh token
            var jwtToken = _tokenGenerator.GenerateToken(user.Id, user.Username, user.Role);
            var refreshToken = Guid.NewGuid().ToString(); // Replace with real refresh token mechanism if needed

            return new AuthResultDto
            {
                Id = user.Id,
                Username = user.Username,
                FullName = user.FullName,
                Token = jwtToken,
                RefreshToken = refreshToken,
                Role = user.Role,
                Shift = request.Shift
            };
        }
    }
}
