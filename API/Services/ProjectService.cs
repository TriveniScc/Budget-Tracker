using BudgetManagement.Api.Models;
using BudgetManagement.Api.Repositories;

namespace BudgetManagement.Api.Services;

public class ProjectService : IProjectService
{
    private readonly IProjectRepository _projectRepository;
    private readonly ILogger<ProjectService> _logger;

    public ProjectService(IProjectRepository projectRepository, ILogger<ProjectService> logger)
    {
        _projectRepository = projectRepository;
        _logger = logger;
    }

    public async Task<IEnumerable<Project>> GetAllProjectsAsync()
    {
        _logger.LogInformation("Retrieving all projects");
        return await _projectRepository.GetAllAsync();
    }

    public async Task<Project?> GetProjectByIdAsync(Guid projectId)
    {
        _logger.LogInformation("Retrieving project with ID: {ProjectId}", projectId);
        return await _projectRepository.GetByIdAsync(projectId);
    }

    public async Task<IEnumerable<Project>> GetActiveProjectsAsync()
    {
        _logger.LogInformation("Retrieving active projects");
        return await _projectRepository.GetActiveProjectsAsync();
    }
}
