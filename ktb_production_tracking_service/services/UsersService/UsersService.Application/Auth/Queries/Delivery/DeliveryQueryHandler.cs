using MediatR;
using UsersService.Application.Auth.DTOs;
using UsersService.Domain.Interfaces;

namespace UsersService.Application.Auth.Queries.Delivery
{
    public class DeliveryQueryHandler : IRequestHandler<DeliveryQuery, List<DeliveryDto>>
    {
        private readonly IDeliveryRepository _deliveryRepository;

        public DeliveryQueryHandler(IDeliveryRepository deliveryRepository)
        {
            _deliveryRepository = deliveryRepository;
        }

        public async Task<List<DeliveryDto>> Handle(DeliveryQuery request, CancellationToken cancellationToken)
        {
            var entities = await _deliveryRepository.GetAllAsync();

            var result = entities.Select(e => new DeliveryDto
            {
                Id = e.Id,
                ChassisNo = e.ChassisNo,
                Color = e.Color,
                Quantity = e.Quantity,
                ShiftNo = e.ShiftNo,
                Variant = e.Variant,         // Mapping Variant (entity uses Varian, DTO uses Variant)
                Status = e.Status,
                CreatedAt = e.CreatedAt,
                CreatedBy = e.CreatedBy,
                UpdatedAt = e.UpdatedAt,
                UpdatedBy = e.UpdatedBy
            }).ToList();

            return result;
        }
    }
}
