using System.Collections.Generic;
using System.Threading.Tasks;
using UsersService.Domain.Entities;

namespace UsersService.Domain.Interfaces
{
    public interface IDeliveryRepository
    {
        Task<Delivery?> GetByIdAsync(string id);
        Task<Delivery?> GetByChassisNoAsync(string chassisNo);
        Task<IEnumerable<Delivery>> GetAllAsync();
        Task<IEnumerable<Delivery>> GetByCreatorIdAsync(string userId);
        Task AddAsync(Delivery delivery);
        Task UpdateAsync(Delivery delivery);
        Task DeleteAsync(string id);
    }
}
