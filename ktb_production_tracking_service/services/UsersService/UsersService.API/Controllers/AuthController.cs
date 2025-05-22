using MediatR;
using Microsoft.AspNetCore.Mvc;
using UsersService.Application.Auth.Commands.SignIn;
using UsersService.Application.Auth.DTOs;

namespace UsersService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IMediator _mediator;

        public AuthController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [ProducesResponseType(typeof(AuthResultDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [HttpPost("signin")]
        public async Task<IActionResult> SignIn([FromBody] SignInCommand command)
        {
            var result = await _mediator.Send(command);

            return result == null
                ? Unauthorized("Invalid username or password.")
                : Ok(result);
        }
    }
}
