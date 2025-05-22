using System.Collections.Generic;
using System.Threading.Tasks;
using UsersService.Domain.Entities;

namespace UsersService.Domain.Interfaces
{
    public interface ITrimmingOnRepository
    {
        Task<Trimming?> GetByIdAsync(string id);
        Task<Trimming?> GetByCabinNoAsync(string cabinNo);
        Task<IEnumerable<Trimming>> GetAllAsync();
        Task<IEnumerable<Trimming>> GetByCreatorIdAsync(string userId);
        Task AddAsync(Trimming trimming);
        Task UpdateAsync(Trimming trimming);
        Task DeleteAsync(string id);
    }
}
