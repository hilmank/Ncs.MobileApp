using System;

namespace UsersService.Domain.Entities
{
    public class Delivery
    {
        public string Id { get; set; } = default!;
        public string ChassisNo { get; set; } = default!;
        public string Color { get; set; } = default!;
        public int Quantity { get; set; }
        public int ShiftNo { get; set; }
        public string? Variant { get; set; }
        public string Status { get; set; } = default!;
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; } = default!;
        public DateTime? UpdatedAt { get; set; }
        public string? UpdatedBy { get; set; }
    }
}
