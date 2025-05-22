using Dapper;
using Microsoft.Data.SqlClient;
using UsersService.Domain.Entities;
using UsersService.Domain.Interfaces;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace UsersService.Persistence.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly SqlConnection _connection;

        public UserRepository(SqlConnection connection)
        {
            _connection = connection;
        }

        public async Task<User?> GetByIdAsync(string id)
        {
            const string sql = @"SELECT * FROM Users WHERE Id = @Id";
            return await _connection.QueryFirstOrDefaultAsync<User>(sql, new { Id = id });
        }

        public async Task<User?> GetByUsernameAsync(string username)
        {
            const string sql = @"SELECT * FROM Users WHERE Username = @Username";
            return await _connection.QueryFirstOrDefaultAsync<User>(sql, new { Username = username });
        }

        public async Task<IEnumerable<User>> GetAllAsync()
        {
            const string sql = @"SELECT * FROM Users";
            return await _connection.QueryAsync<User>(sql);
        }

        public async Task AddAsync(User user)
        {
            const string sql = @"
                INSERT INTO Users (Id, Username, Password, Role, FullName, Token, RefreshToken, Shift)
                VALUES (@Id, @Username, @Password, @Role, @FullName, @Token, @RefreshToken, @Shift)";
            await _connection.ExecuteAsync(sql, user);
        }

        public async Task UpdateAsync(User user)
        {
            const string sql = @"
                UPDATE Users SET 
                    Username = @Username,
                    Password = @Password,
                    Role = @Role,
                    FullName = @FullName,
                    Token = @Token,
                    RefreshToken = @RefreshToken,
                    Shift = @Shift
                WHERE Id = @Id";
            await _connection.ExecuteAsync(sql, user);
        }

        public async Task DeleteAsync(string id)
        {
            const string sql = @"DELETE FROM Users WHERE Id = @Id";
            await _connection.ExecuteAsync(sql, new { Id = id });
        }
    }
}
