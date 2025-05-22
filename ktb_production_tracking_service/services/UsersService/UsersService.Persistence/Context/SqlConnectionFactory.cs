using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace UsersService.Persistence.Context;

public class SqlConnectionFactory
{
    private readonly IConfiguration _configuration;

    public SqlConnectionFactory(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public SqlConnection CreateConnection()
    {
        return new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
    }
}
