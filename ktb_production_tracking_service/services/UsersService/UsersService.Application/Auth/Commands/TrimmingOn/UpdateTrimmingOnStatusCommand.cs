using MediatR;
using UsersService.Application.Auth.DTOs;

namespace UsersService.Application.Auth.Commands.TrimmingOn
{
    public class UpdateTrimmingOnStatusCommand : IRequest<TrimmingOnDto?>
    {
        public string CabinNo { get; set; }

        public UpdateTrimmingOnStatusCommand(string cabinNo)
        {
            CabinNo = cabinNo;
        }
    }
}
