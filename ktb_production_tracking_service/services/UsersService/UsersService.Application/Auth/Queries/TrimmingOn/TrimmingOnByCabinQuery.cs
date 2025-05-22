using System;
using MediatR;
using UsersService.Application.Auth.DTOs;

namespace UsersService.Application.Auth.Queries.TrimmingOn;

public class TrimmingOnByCabinQuery : IRequest<TrimmingOnDto?>
{
    public string CabinNo { get; set; } = default!;
}