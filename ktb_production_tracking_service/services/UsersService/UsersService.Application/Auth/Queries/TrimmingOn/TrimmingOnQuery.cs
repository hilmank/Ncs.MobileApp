using MediatR;
using System.Collections.Generic;
using UsersService.Application.Auth.DTOs;

namespace UsersService.Application.Auth.Queries.TrimmingOn
{
    public class TrimmingOnQuery : IRequest<List<TrimmingOnDto>>
    {
        public string UserId { get; set; } = default!;
        public DateTime Date { get; set; }
    }
}
