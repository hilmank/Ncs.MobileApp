using MediatR;
using UsersService.Application.Auth.DTOs;
using UsersService.Domain.Interfaces;

namespace UsersService.Application.Auth.Queries.TrimmingOn
{
    public class TrimmingOnSummaryQueryHandler : IRequestHandler<TrimmingOnSummaryQuery, (List<TrimmingOnSummaryDto>, int)>
    {
        private readonly ITrimmingOnRepository _trimmingOnRepository;

        public TrimmingOnSummaryQueryHandler(ITrimmingOnRepository trimmingOnRepository)
        {
            _trimmingOnRepository = trimmingOnRepository;
        }

        public async Task<(List<TrimmingOnSummaryDto>, int)> Handle(TrimmingOnSummaryQuery request, CancellationToken cancellationToken)
        {
            var data = await _trimmingOnRepository.GetAllAsync();

            var grouped = data
                .GroupBy(x => new { Cabin = x.CabinNo, x.Color })
                .Select(g => new TrimmingOnSummaryDto
                {
                    Cabin = g.Key.Cabin,
                    Color = g.Key.Color,
                    Quantity = g.Count() // <-- Use count here
                })
                .ToList();

            int grandTotal = grouped.Sum(x => x.Quantity); // Sum of counts

            return (grouped, grandTotal);
        }
    }
}
