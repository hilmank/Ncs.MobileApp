using System;
using MediatR;
using UsersService.Application.Auth.DTOs;

namespace UsersService.Application.Auth.Queries.Delivery;

public class DeliceryByChassisNoQuery : IRequest<DeliveryDto?>
{
    public string ChassisNo { get; set; } = default!;
}
