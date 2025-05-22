using MediatR;
using UsersService.Application.Auth.DTOs;
using UsersService.Domain.Interfaces;

namespace UsersService.Application.Auth.Queries.Delivery
{
    public class DeliceryByChassisNoQueryHandler : IRequestHandler<DeliceryByChassisNoQuery, DeliveryDto?>
    {
        private readonly IDeliveryRepository _deliveryRepository;

        public DeliceryByChassisNoQueryHandler(IDeliveryRepository deliveryRepository)
        {
            _deliveryRepository = deliveryRepository;
        }

        public async Task<DeliveryDto?> Handle(DeliceryByChassisNoQuery request, CancellationToken cancellationToken)
        {
            var entity = await _deliveryRepository.GetByChassisNoAsync(request.ChassisNo);
            if (entity == null)
            {
                return null; // or throw new NotFoundException("Delivery not found for chassis no: " + request.ChassisNo);
            }

            return new DeliveryDto
            {
                Id = entity.Id,
                ChassisNo = entity.ChassisNo,
                Color = entity.Color,
                Quantity = entity.Quantity,
                ShiftNo = entity.ShiftNo,
                Variant = entity.Variant,
                Status = entity.Status,
                CreatedAt = entity.CreatedAt,
                CreatedBy = entity.CreatedBy,
                UpdatedAt = entity.UpdatedAt,
                UpdatedBy = entity.UpdatedBy
            };
        }

    }
}
