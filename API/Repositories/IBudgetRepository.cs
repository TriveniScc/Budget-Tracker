using BudgetManagement.Api.Models;

namespace BudgetManagement.Api.Repositories;

public interface IBudgetRepository
{
    Task<IEnumerable<Budget>> GetAllAsync();
    Task<Budget?> GetByIdAsync(Guid budgetId);
    Task<Budget> CreateAsync(Budget budget);
    Task<bool> UpdateAsync(Budget budget);
    Task<bool> DeleteAsync(Guid budgetId);
    Task<IEnumerable<Budget>> GetByProjectIdAsync(Guid projectId);
    Task<IEnumerable<Budget>> GetByCostCenterIdAsync(Guid costCenterId);
}

