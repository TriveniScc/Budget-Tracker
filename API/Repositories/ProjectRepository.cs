using BudgetManagement.Api.Models;
using Dapper;
using System.Data;

namespace BudgetManagement.Api.Repositories;

public class ProjectRepository : IProjectRepository
{
    private readonly IDbConnection _connection;

    public ProjectRepository(IDbConnection connection)
    {
        _connection = connection;
    }

    public async Task<IEnumerable<Project>> GetAllAsync()
    {
        const string sql = @"
            SELECT * FROM Project
            ORDER BY ProjectName ASC";
        
        return await _connection.QueryAsync<Project>(sql);
    }

    public async Task<Project?> GetByIdAsync(Guid projectId)
    {
        const string sql = @"
            SELECT * FROM Project
            WHERE ID = @ID";
        
        return await _connection.QuerySingleOrDefaultAsync<Project>(sql, new { ID = projectId });
    }

    public async Task<IEnumerable<Project>> GetActiveProjectsAsync()
    {
        const string sql = @"
            SELECT * FROM Project
            WHERE IsActive = 1
            ORDER BY ProjectName ASC";
        
        return await _connection.QueryAsync<Project>(sql);
    }
}
