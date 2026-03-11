using BudgetManagement.Api.Models;

namespace BudgetManagement.Api.Services;

public interface ICostCenterService
{
    Task<IEnumerable<CostCenter>> GetAllCostCentersAsync();
    Task<CostCenter?> GetCostCenterByIdAsync(Guid costCenterId);
    Task<IEnumerable<CostCenter>> GetActiveCostCentersAsync();
}
