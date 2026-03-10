using BudgetManagement.Api.Models;

namespace BudgetManagement.Api.Services;

public interface IBudgetService
{
    Task<IEnumerable<Budget>> GetAllBudgetsAsync();
    Task<Budget?> GetBudgetByIdAsync(Guid budgetId);
    Task<Budget> CreateBudgetAsync(Budget budget);
    Task<bool> UpdateBudgetAsync(Budget budget);
    Task<bool> DeleteBudgetAsync(Guid budgetId);
    Task<IEnumerable<Budget>> GetBudgetsByProjectIdAsync(Guid projectId);
    Task<IEnumerable<Budget>> GetBudgetsByCostCenterIdAsync(Guid costCenterId);
}

