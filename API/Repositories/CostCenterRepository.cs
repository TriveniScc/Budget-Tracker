using BudgetManagement.Api.Models;
using Dapper;
using System.Data;

namespace BudgetManagement.Api.Repositories;

public class CostCenterRepository : ICostCenterRepository
{
    private readonly IDbConnection _connection;

    public CostCenterRepository(IDbConnection connection)
    {
        _connection = connection;
    }

    public async Task<IEnumerable<CostCenter>> GetAllAsync()
    {
        const string sql = @"
            SELECT * FROM CostCenter
            ORDER BY CostCenterName ASC";
        
        return await _connection.QueryAsync<CostCenter>(sql);
    }

    public async Task<CostCenter?> GetByIdAsync(Guid costCenterId)
    {
        const string sql = @"
            SELECT * FROM CostCenter
            WHERE ID = @ID";
        
        return await _connection.QuerySingleOrDefaultAsync<CostCenter>(sql, new { ID = costCenterId });
    }

    public async Task<IEnumerable<CostCenter>> GetActiveCostCentersAsync()
    {
        const string sql = @"
            SELECT * FROM CostCenter
            WHERE IsActive = 1
            ORDER BY CostCenterName ASC";
        
        return await _connection.QueryAsync<CostCenter>(sql);
    }
}
