using BudgetManagement.Api.Models;

namespace BudgetManagement.Api.Repositories;

public interface ICostCenterRepository
{
    Task<IEnumerable<CostCenter>> GetAllAsync();
    Task<CostCenter?> GetByIdAsync(Guid costCenterId);
    Task<IEnumerable<CostCenter>> GetActiveCostCentersAsync();
}
