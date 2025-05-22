using MediatR;
using UsersService.Application.Auth.DTOs;
using UsersService.Domain.Interfaces;

namespace UsersService.Application.Auth.Commands.Delivery
{
    public class UpdateDeliveryStatusCommandHandler : IRequestHandler<UpdateDeliveryStatusCommand, DeliveryDto?>
    {
        private readonly IDeliveryRepository _deliveryRepository;

        public UpdateDeliveryStatusCommandHandler(IDeliveryRepository deliveryRepository)
        {
            _deliveryRepository = deliveryRepository;
        }

        public async Task<DeliveryDto?> Handle(UpdateDeliveryStatusCommand request, CancellationToken cancellationToken)
        {
            // Get the delivery entity by chassis number
            var entity = await _deliveryRepository.GetByChassisNoAsync(request.ChassisNo);

            if (entity != null)
            {
                if (entity.Status != "Delivered")
                {
                    // Simulate update
                    entity.Status = "Delivered";
                    entity.UpdatedAt = DateTime.UtcNow;

                    // Optional: persist change
                    await _deliveryRepository.UpdateAsync(entity); // implement this in your repository

                }
                var dto = new DeliveryDto
                {
                    Id = entity.Id,
                    ChassisNo = entity.ChassisNo,
                    Color = entity.Color,
                    Quantity = entity.Quantity,
                    ShiftNo = entity.ShiftNo,
                    Variant = entity.Variant,         // Mapping Variant (entity uses Varian, DTO uses Variant)
                    Status = entity.Status,
                    CreatedAt = entity.CreatedAt,
                    CreatedBy = entity.CreatedBy,
                    UpdatedAt = entity.UpdatedAt,
                    UpdatedBy = entity.UpdatedBy
                };
                return dto;
            }

            return null;
        }
    }
}
