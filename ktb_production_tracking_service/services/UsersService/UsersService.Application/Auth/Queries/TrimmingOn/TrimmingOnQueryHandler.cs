using MediatR;
using UsersService.Application.Auth.DTOs;
using UsersService.Domain.Interfaces;
using UsersService.Domain.Entities;

namespace UsersService.Application.Auth.Queries.TrimmingOn
{
    public class TrimmingOnQueryHandler : IRequestHandler<TrimmingOnQuery, List<TrimmingOnDto>>
    {
        private readonly ITrimmingOnRepository _trimmingOnRepository;

        public TrimmingOnQueryHandler(ITrimmingOnRepository trimmingOnRepository)
        {
            _trimmingOnRepository = trimmingOnRepository;
        }

        public async Task<List<TrimmingOnDto>> Handle(TrimmingOnQuery request, CancellationToken cancellationToken)
        {
            var entities = await _trimmingOnRepository.GetAllAsync();

            var result = entities.Select(entity => new TrimmingOnDto
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
            }).ToList();

            return result;
        }
    }
}
