using MediatR;
using UsersService.Application.Auth.DTOs;

namespace UsersService.Application.Auth.Commands.Delivery
{
    public class UpdateDeliveryStatusCommand : IRequest<DeliveryDto?>
    {
        public string ChassisNo { get; set; }

        public UpdateDeliveryStatusCommand(string chassisNo)
        {
            ChassisNo = chassisNo;
        }
    }
}
