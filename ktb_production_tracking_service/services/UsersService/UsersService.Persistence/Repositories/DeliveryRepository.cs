using Dapper;
using Microsoft.Data.SqlClient;
using UsersService.Domain.Entities;
using UsersService.Domain.Interfaces;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace UsersService.Persistence.Repositories
{
    public class DeliveryRepository : IDeliveryRepository
    {
        private readonly SqlConnection _connection;

        public DeliveryRepository(SqlConnection connection)
        {
            _connection = connection;
        }

        public async Task<Delivery?> GetByIdAsync(string id)
        {
            const string sql = @"SELECT * FROM Delivery WHERE Id = @Id";
            return await _connection.QueryFirstOrDefaultAsync<Delivery>(sql, new { Id = id });
        }
        public Task<Delivery?> GetByChassisNoAsync(string chassisNo)
        {
            const string sql = @"SELECT * FROM Delivery WHERE ChassisNo = @ChassisNo";
            return _connection.QueryFirstOrDefaultAsync<Delivery>(sql, new { ChassisNo = chassisNo });
        }
        public async Task<IEnumerable<Delivery>> GetAllAsync()
        {
            const string sql = @"SELECT * FROM Delivery WHERE status = 'Delivered'";
            return await _connection.QueryAsync<Delivery>(sql);
        }

        public async Task<IEnumerable<Delivery>> GetByCreatorIdAsync(string userId)
        {
            const string sql = @"SELECT * FROM Delivery WHERE CreatedBy = @UserId";
            return await _connection.QueryAsync<Delivery>(sql, new { UserId = userId });
        }

        public async Task AddAsync(Delivery delivery)
        {
            const string sql = @"
                INSERT INTO Delivery (Id, ChassisNo, Color, Quantity, ShiftNo, Status, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
                VALUES (@Id, @ChassisNo, @Color, @Quantity, @ShiftNo, @Status, @CreatedAt, @CreatedBy, @UpdatedAt, @UpdatedBy)";
            await _connection.ExecuteAsync(sql, delivery);
        }

        public async Task UpdateAsync(Delivery delivery)
        {
            const string sql = @"
                UPDATE Delivery SET 
                    ChassisNo = @ChassisNo,
                    Color = @Color,
                    Quantity = @Quantity,
                    ShiftNo = @ShiftNo,
                    Status = @Status,
                    UpdatedAt = @UpdatedAt,
                    UpdatedBy = @UpdatedBy
                WHERE Id = @Id";
            await _connection.ExecuteAsync(sql, delivery);
        }

        public async Task DeleteAsync(string id)
        {
            const string sql = @"DELETE FROM Delivery WHERE Id = @Id";
            await _connection.ExecuteAsync(sql, new { Id = id });
        }
    }
}
