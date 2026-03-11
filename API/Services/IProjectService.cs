using BudgetManagement.Api.Models;

namespace BudgetManagement.Api.Services;

public interface IProjectService
{
    Task<IEnumerable<Project>> GetAllProjectsAsync();
    Task<Project?> GetProjectByIdAsync(Guid projectId);
    Task<IEnumerable<Project>> GetActiveProjectsAsync();
}
