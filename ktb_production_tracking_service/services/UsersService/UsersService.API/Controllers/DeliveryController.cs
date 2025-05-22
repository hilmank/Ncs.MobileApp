using System.Security.Claims;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UsersService.Application.Auth.Commands.Delivery;
using UsersService.Application.Auth.DTOs;
using UsersService.Application.Auth.Queries.Delivery;

namespace UsersService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DeliveryController : ControllerBase
    {
        private readonly IMediator _mediator;

        public DeliveryController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [Authorize]
        [HttpGet("transaction")]
        [ProducesResponseType(typeof(List<DeliveryDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<DeliveryDto>>> GetTransactionDelivery()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userId))
                return BadRequest("Invalid token: missing user ID.");
            var result = await _mediator.Send(new DeliveryQuery
            {
                UserId = userId,
                Date = DateTime.Now
            });

            return Ok(result);
        }
        [Authorize]
        [HttpGet("summary")]
        [ProducesResponseType(typeof(List<DeliverySummaryDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<DeliverySummaryDto>>> GetSummaryDelivery()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userId))
                return BadRequest("Invalid token: missing user ID.");
            var (summary, grandTotal) = await _mediator.Send(new DeliverySummaryQuery
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
        public async Task<IActionResult> UpdateStatus([FromQuery] string chassisNo)
        {
            if (string.IsNullOrWhiteSpace(chassisNo))
                return BadRequest("Nomor chassis wajib diisi.");

            var delivery = await _mediator.Send(new DeliceryByChassisNoQuery
            {
                ChassisNo = chassisNo
            });

            if (delivery == null)
                return NotFound($"Data pengiriman dengan nomor chassis '{chassisNo}' tidak ditemukan.");

            if (delivery.Status == "Delivered")
                return BadRequest($"Duplikasi data, data ini sudah terdaftar di sistem!");

            var updatedDelivery = await _mediator.Send(new UpdateDeliveryStatusCommand(chassisNo));

            if (updatedDelivery == null)
                return NotFound($"Gagal memperbarui status. Data pengiriman dengan nomor chassis '{chassisNo}' tidak ditemukan.");

            return Ok(new
            {
                message = "Status berhasil diperbarui.",
                delivery = updatedDelivery
            });
        }


    }
}
