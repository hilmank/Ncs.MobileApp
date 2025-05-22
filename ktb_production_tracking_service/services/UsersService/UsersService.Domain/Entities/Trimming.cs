using System;

namespace UsersService.Domain.Entities
{
    public class Trimming
    {
        public string Id { get; set; } = default!;
        public string CabinNo { get; set; } = default!;
        public string Color { get; set; } = default!;
        public DateTime ProductionDate { get; set; }
        public int ShiftNo { get; set; }
        public int Line { get; set; }
        public string Current { get; set; } = default!;
        public string ProcessId { get; set; } = default!;
        public string? Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; } = default!;
        public DateTime? UpdatedAt { get; set; }
        public string? UpdatedBy { get; set; }
    }
}
