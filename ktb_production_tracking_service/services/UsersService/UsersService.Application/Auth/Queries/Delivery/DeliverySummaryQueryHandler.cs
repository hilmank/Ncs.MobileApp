using MediatR;
using UsersService.Application.Auth.DTOs;
using UsersService.Domain.Interfaces;

namespace UsersService.Application.Auth.Queries.Delivery
{
    public class DeliverySummaryQueryHandler : IRequestHandler<DeliverySummaryQuery, (List<DeliverySummaryDto>, int)>
    {
        private readonly IDeliveryRepository _deliveryRepository;

        public DeliverySummaryQueryHandler(IDeliveryRepository deliveryRepository)
        {
            _deliveryRepository = deliveryRepository;
        }

        public async Task<(List<DeliverySummaryDto>, int)> Handle(DeliverySummaryQuery request, CancellationToken cancellationToken)
        {
            var data = await _deliveryRepository.GetAllAsync();

            var grouped = data
                .GroupBy(x => x.Variant) // Ensure 'Variant' exists in Delivery entity
                .Select(g => new DeliverySummaryDto
                {
                    Variant = g.Key,
                    Quantity = g.Sum(x => x.Quantity)
                }).ToList();

            int grandTotal = grouped.Sum(x => x.Quantity);

            return (grouped, grandTotal);
        }
    }
}
