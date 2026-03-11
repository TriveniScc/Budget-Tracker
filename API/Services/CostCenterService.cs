using BudgetManagement.Api.Models;
using BudgetManagement.Api.Repositories;

namespace BudgetManagement.Api.Services;

public class CostCenterService : ICostCenterService
{
    private readonly ICostCenterRepository _costCenterRepository;
    private readonly ILogger<CostCenterService> _logger;

    public CostCenterService(ICostCenterRepository costCenterRepository, ILogger<CostCenterService> logger)
    {
        _costCenterRepository = costCenterRepository;
        _logger = logger;
    }

    public async Task<IEnumerable<CostCenter>> GetAllCostCentersAsync()
    {
        _logger.LogInformation("Retrieving all cost centers");
        return await _costCenterRepository.GetAllAsync();
    }

    public async Task<CostCenter?> GetCostCenterByIdAsync(Guid costCenterId)
    {
        _logger.LogInformation("Retrieving cost center with ID: {CostCenterId}", costCenterId);
        return await _costCenterRepository.GetByIdAsync(costCenterId);
    }

    public async Task<IEnumerable<CostCenter>> GetActiveCostCentersAsync()
    {
        _logger.LogInformation("Retrieving active cost centers");
        return await _costCenterRepository.GetActiveCostCentersAsync();
    }
}
