using System;
using MediatR;
using UsersService.Application.Auth.DTOs;
using UsersService.Domain.Interfaces;

namespace UsersService.Application.Auth.Queries.TrimmingOn;

public class TrimmingOnByCabinQueryHandler : IRequestHandler<TrimmingOnByCabinQuery, TrimmingOnDto?>
{
    private readonly ITrimmingOnRepository _trimmingOnRepository;

    public TrimmingOnByCabinQueryHandler(ITrimmingOnRepository trimmingOnRepository)
    {
        _trimmingOnRepository = trimmingOnRepository;
    }

    public async Task<TrimmingOnDto?> Handle(TrimmingOnByCabinQuery request, CancellationToken cancellationToken)
    {
        var entity = await _trimmingOnRepository.GetByCabinNoAsync(request.CabinNo);
        if (entity == null)
        {
            return null; // or throw new NotFoundException("Delivery not found for chassis no: " + request.ChassisNo);
        }

        return new TrimmingOnDto
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
    }

}
