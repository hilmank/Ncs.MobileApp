using Dapper;
using Microsoft.Data.SqlClient;
using UsersService.Domain.Entities;
using UsersService.Domain.Interfaces;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace UsersService.Persistence.Repositories
{
    public class TrimmingOnRepository : ITrimmingOnRepository
    {
        private readonly SqlConnection _connection;

        public TrimmingOnRepository(SqlConnection connection)
        {
            _connection = connection;
        }

        public async Task<Trimming?> GetByIdAsync(string id)
        {
            const string sql = @"SELECT * FROM TrimmingOn WHERE Id = @Id";
            return await _connection.QueryFirstOrDefaultAsync<Trimming>(sql, new { Id = id });
        }
        public async Task<Trimming?> GetByCabinNoAsync(string cabinNo)
        {
            const string sql = @"SELECT * FROM TrimmingOn WHERE CabinNo = @CabinNo";
            return await _connection.QueryFirstOrDefaultAsync<Trimming>(sql, new { CabinNo = cabinNo });
        }
        public async Task<IEnumerable<Trimming>> GetAllAsync()
        {
            const string sql = @"SELECT * FROM TrimmingOn WHERE status = 'trimmed'";
            return await _connection.QueryAsync<Trimming>(sql);
        }

        public async Task<IEnumerable<Trimming>> GetByCreatorIdAsync(string userId)
        {
            const string sql = @"SELECT * FROM TrimmingOn WHERE CreatedBy = @UserId";
            return await _connection.QueryAsync<Trimming>(sql, new { UserId = userId });
        }

        public async Task AddAsync(Trimming trimming)
        {
            const string sql = @"
                INSERT INTO TrimmingOn (Id, CabinNo, Color, ProductionDate, ShiftNo, Line, Current, ProcessId, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy)
                VALUES (@Id, @CabinNo, @Color, @ProductionDate, @ShiftNo, @Line, @Current, @ProcessId, @CreatedAt, @CreatedBy, @UpdatedAt, @UpdatedBy)";
            await _connection.ExecuteAsync(sql, trimming);
        }

        public async Task UpdateAsync(Trimming trimming)
        {
            const string sql = @"
                UPDATE TrimmingOn SET 
                    CabinNo = @CabinNo,
                    Color = @Color,
                    ProductionDate = @ProductionDate,
                    ShiftNo = @ShiftNo,
                    Line = @Line,
                    [Current] = @Current,
                    ProcessId = @ProcessId,
                    UpdatedAt = @UpdatedAt,
                    UpdatedBy = @UpdatedBy,
                    Status = @Status
                WHERE Id = @Id";
            await _connection.ExecuteAsync(sql, trimming);
        }

        public async Task DeleteAsync(string id)
        {
            const string sql = @"DELETE FROM TrimmingOn WHERE Id = @Id";
            await _connection.ExecuteAsync(sql, new { Id = id });
        }
    }
}
