using MediatR;
using UsersService.Application.Auth.DTOs;
using UsersService.Domain.Interfaces;

namespace UsersService.Application.Auth.Commands.TrimmingOn
{
    public class UpdateTrimmingOnStatusCommandHandler : IRequestHandler<UpdateTrimmingOnStatusCommand, TrimmingOnDto?>
    {
        private readonly ITrimmingOnRepository _trimmingOnRepository;

        public UpdateTrimmingOnStatusCommandHandler(ITrimmingOnRepository trimmingOnRepository)
        {
            _trimmingOnRepository = trimmingOnRepository;
        }

        public async Task<TrimmingOnDto?> Handle(UpdateTrimmingOnStatusCommand request, CancellationToken cancellationToken)
        {
            // Get the data asynchronously
            var entity = await _trimmingOnRepository.GetByCabinNoAsync(request.CabinNo);

            if (entity != null)
            {
                // Simulate updating the status
                entity.Status = "trimmed"; // <- update the status as needed
                entity.UpdatedAt = DateTime.UtcNow; // <- update the timestamp

                // Optionally update in repository (if implemented)
                await _trimmingOnRepository.UpdateAsync(entity); // <- implement this method if needed
                var dto = new TrimmingOnDto
                {
                    Id = entity.Id,
                    CabinNo = entity.CabinNo,
                    Color = entity.Color,
                    ProductionDate = entity.ProductionDate,
                    ShiftNo = entity.ShiftNo,
                    Line = entity.Line,
                    Current = entity.Current,
                    ProcessId = entity.ProcessId,
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
