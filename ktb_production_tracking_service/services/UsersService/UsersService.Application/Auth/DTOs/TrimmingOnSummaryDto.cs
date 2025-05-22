namespace UsersService.Application.Auth.DTOs
{
    public class TrimmingOnSummaryDto
    {
        public string Cabin { get; set; } = default!;
        public string Color { get; set; } = default!;
        public int Quantity { get; set; }
    }
}
