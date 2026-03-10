using BudgetManagement.Api.Models;
using Dapper;
using System.Data;

namespace BudgetManagement.Api.Repositories;

public class BudgetRepository : IBudgetRepository
{
    private readonly IDbConnection _connection;

    public BudgetRepository(IDbConnection connection)
    {
        _connection = connection;
    }

    public async Task<IEnumerable<Budget>> GetAllAsync()
    {
        const string sql = @"
            SELECT * FROM Budget
            ORDER BY CreatedAt DESC";
        
        return await _connection.QueryAsync<Budget>(sql);
    }

    public async Task<Budget?> GetByIdAsync(Guid budgetId)
    {
        const string sql = @"
            SELECT * FROM Budget
            WHERE ID = @ID";
        
        return await _connection.QuerySingleOrDefaultAsync<Budget>(sql, new { ID = budgetId });
    }

    public async Task<Budget> CreateAsync(Budget budget)
    {
        const string sql = @"
            INSERT INTO Budget (ID, ProjectID, CostCenterID, StartDate, EndDate, TotalAmount, Description, CreatedAt, CreatedBy)
            VALUES (@ID, @ProjectID, @CostCenterID, @StartDate, @EndDate, @TotalAmount, @Description, @CreatedAt, @CreatedBy)";
        
        if (budget.ID == Guid.Empty)
        {
            budget.ID = Guid.NewGuid();
        }
        
        await _connection.ExecuteAsync(sql, budget);
        return budget;
    }

    public async Task<bool> UpdateAsync(Budget budget)
    {
        const string sql = @"
            UPDATE Budget
            SET ProjectID = @ProjectID,
                CostCenterID = @CostCenterID,
                StartDate = @StartDate,
                EndDate = @EndDate,
                TotalAmount = @TotalAmount,
                Description = @Description,
                UpdatedAt = @UpdatedAt,
                UpdatedBy = @UpdatedBy
            WHERE ID = @ID";
        
        var rowsAffected = await _connection.ExecuteAsync(sql, budget);
        return rowsAffected > 0;
    }

    public async Task<bool> DeleteAsync(Guid budgetId)
    {
        const string sql = "DELETE FROM Budget WHERE ID = @ID";
        var rowsAffected = await _connection.ExecuteAsync(sql, new { ID = budgetId });
        return rowsAffected > 0;
    }

    public async Task<IEnumerable<Budget>> GetByProjectIdAsync(Guid projectId)
    {
        const string sql = @"
            SELECT * FROM Budget
            WHERE ProjectID = @ProjectID
            ORDER BY StartDate DESC";
        
        return await _connection.QueryAsync<Budget>(sql, new { ProjectID = projectId });
    }

    public async Task<IEnumerable<Budget>> GetByCostCenterIdAsync(Guid costCenterId)
    {
        const string sql = @"
            SELECT * FROM Budget
            WHERE CostCenterID = @CostCenterID
            ORDER BY StartDate DESC";
        
        return await _connection.QueryAsync<Budget>(sql, new { CostCenterID = costCenterId });
    }
}

    }
}
