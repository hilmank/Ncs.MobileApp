using MediatR;
using UsersService.Application.Auth.DTOs;

namespace UsersService.Application.Auth.Queries.Delivery
{
    public class DeliverySummaryQuery : IRequest<(List<DeliverySummaryDto> Summary, int GrandTotal)>
    {
        public string UserId { get; set; } = default!;
        public DateTime Date { get; set; }
    }
}
