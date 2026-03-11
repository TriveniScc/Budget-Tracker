using BudgetManagement.Api.Models;

namespace BudgetManagement.Api.Repositories;

public interface IProjectRepository
{
    Task<IEnumerable<Project>> GetAllAsync();
    Task<Project?> GetByIdAsync(Guid projectId);
    Task<IEnumerable<Project>> GetActiveProjectsAsync();
}
