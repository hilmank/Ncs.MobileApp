using MediatR;
using UsersService.Application.Auth.DTOs;

namespace UsersService.Application.Auth.Queries.Delivery
{
    public class DeliveryQuery : IRequest<List<DeliveryDto>>
    {
        public string UserId { get; set; } = default!;
        public DateTime Date { get; set; }
    }
}
