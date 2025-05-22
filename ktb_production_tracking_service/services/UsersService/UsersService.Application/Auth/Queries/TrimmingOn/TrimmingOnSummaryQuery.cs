using MediatR;
using UsersService.Application.Auth.DTOs;

namespace UsersService.Application.Auth.Queries.TrimmingOn
{
    public class TrimmingOnSummaryQuery : IRequest<(List<TrimmingOnSummaryDto> Summary, int GrandTotal)>
    {
        public string UserId { get; set; } = default!;
        public DateTime Date { get; set; }
    }
}
