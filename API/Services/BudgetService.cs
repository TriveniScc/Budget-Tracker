using BudgetManagement.Api.Models;
using BudgetManagement.Api.Repositories;

namespace BudgetManagement.Api.Services;

public class BudgetService : IBudgetService
{
    private readonly IBudgetRepository _budgetRepository;
    private readonly ILogger<BudgetService> _logger;

    public BudgetService(IBudgetRepository budgetRepository, ILogger<BudgetService> logger)
    {
        _budgetRepository = budgetRepository;
        _logger = logger;
    }

    public async Task<IEnumerable<Budget>> GetAllBudgetsAsync()
    {
        _logger.LogInformation("Retrieving all budgets");
        return await _budgetRepository.GetAllAsync();
    }

    public async Task<Budget?> GetBudgetByIdAsync(Guid budgetId)
    {
        _logger.LogInformation("Retrieving budget with ID: {BudgetId}", budgetId);
        return await _budgetRepository.GetByIdAsync(budgetId);
    }

    public async Task<Budget> CreateBudgetAsync(Budget budget)
    {
        _logger.LogInformation("Creating new budget for project: {ProjectId}", budget.ProjectID);
        
        // Business validation
        if (budget.StartDate >= budget.EndDate)
            throw new ArgumentException("End date must be after start date");
        
        if (budget.TotalAmount <= 0)
            throw new ArgumentException("Total amount must be greater than zero");
        
        budget.CreatedAt = DateTime.UtcNow;
        return await _budgetRepository.CreateAsync(budget);
    }

    public async Task<bool> UpdateBudgetAsync(Budget budget)
    {
        _logger.LogInformation("Updating budget with ID: {BudgetId}", budget.ID);
        
        // Business validation
        if (budget.StartDate >= budget.EndDate)
            throw new ArgumentException("End date must be after start date");
        
        if (budget.TotalAmount <= 0)
            throw new ArgumentException("Total amount must be greater than zero");
        
        budget.UpdatedAt = DateTime.UtcNow;
        return await _budgetRepository.UpdateAsync(budget);
    }

    public async Task<bool> DeleteBudgetAsync(Guid budgetId)
    {
        _logger.LogInformation("Deleting budget with ID: {BudgetId}", budgetId);
        return await _budgetRepository.DeleteAsync(budgetId);
    }

    public async Task<IEnumerable<Budget>> GetBudgetsByProjectIdAsync(Guid projectId)
    {
        _logger.LogInformation("Retrieving budgets for project ID: {ProjectId}", projectId);
        return await _budgetRepository.GetByProjectIdAsync(projectId);
    }

    public async Task<IEnumerable<Budget>> GetBudgetsByCostCenterIdAsync(Guid costCenterId)
    {
        _logger.LogInformation("Retrieving budgets for cost center ID: {CostCenterId}", costCenterId);
        return await _budgetRepository.GetByCostCenterIdAsync(costCenterId);
    }
}

    }
}
