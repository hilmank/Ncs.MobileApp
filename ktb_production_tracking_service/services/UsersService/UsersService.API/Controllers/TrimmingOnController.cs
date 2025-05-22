using System.Security.Claims;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UsersService.Application.Auth.Commands.TrimmingOn;
using UsersService.Application.Auth.DTOs;
using UsersService.Application.Auth.Queries.TrimmingOn;

namespace UsersService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TrimmingOnController : ControllerBase
    {
        private readonly IMediator _mediator;

        public TrimmingOnController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [Authorize]
        [HttpGet("transaction")]
        [ProducesResponseType(typeof(List<TrimmingOnDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<TrimmingOnDto>>> GetTransactionTrimmingOn()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userId))
                return BadRequest("Invalid token: missing user ID.");
            var result = await _mediator.Send(new TrimmingOnQuery
            {
                UserId = userId,
                Date = DateTime.Now
            });

            return Ok(result);
        }
        [Authorize]
        [HttpGet("summary")]
        [ProducesResponseType(typeof(List<TrimmingOnSummaryDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<TrimmingOnSummaryDto>>> GetSummaryTrimmingOn()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userId))
                return BadRequest("Invalid token: missing user ID.");
            var (summary, grandTotal) = await _mediator.Send(new TrimmingOnSummaryQuery
            {
                UserId = userId,
                Date = DateTime.Now
            });

            return Ok(new { summary, grandTotal });
        }
        [Authorize]
        [HttpPut("update-status")]
        [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> UpdateTrimmingOnStatus([FromQuery] string cabinNo)
        {
            if (string.IsNullOrWhiteSpace(cabinNo))
                return BadRequest("Nomor kabin wajib diisi.");

            var trimmingOn = await _mediator.Send(new TrimmingOnByCabinQuery
            {
                CabinNo = cabinNo
            });

            if (trimmingOn == null)
                return NotFound($"Data trimming dengan nomor kabin '{cabinNo}' tidak ditemukan.");

            if (trimmingOn.Status == "trimmed")
                return BadRequest("Duplikasi data, data ini sudah terdaftar di sistem!");

            var result = await _mediator.Send(new UpdateTrimmingOnStatusCommand(cabinNo));

            if (result == null)
                return NotFound($"Gagal memperbarui status. Data trimming dengan nomor kabin '{cabinNo}' tidak ditemukan.");

            return Ok(new
            {
                message = "Status berhasil diperbarui.",
                trimming = result
            });
        }
    }
}
