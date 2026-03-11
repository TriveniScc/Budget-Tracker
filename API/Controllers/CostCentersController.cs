using BudgetManagement.Api.Models;
using BudgetManagement.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace BudgetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CostCentersController : ControllerBase
{
    private readonly ICostCenterService _costCenterService;
    private readonly ILogger<CostCentersController> _logger;

    public CostCentersController(ICostCenterService costCenterService, ILogger<CostCentersController> logger)
    {
        _costCenterService = costCenterService;
        _logger = logger;
    }

    /// <summary>
    /// Get all cost centers
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<CostCenter>>> GetCostCenters()
    {
        try
        {
            var costCenters = await _costCenterService.GetAllCostCentersAsync();
            return Ok(costCenters);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving cost centers");
            return StatusCode(500, "An error occurred while retrieving cost centers");
        }
    }

    /// <summary>
    /// Get cost center by ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<ActionResult<CostCenter>> GetCostCenter(Guid id)
    {
        try
        {
            var costCenter = await _costCenterService.GetCostCenterByIdAsync(id);
            if (costCenter == null)
                return NotFound($"Cost center with ID {id} not found");

            return Ok(costCenter);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving cost center {CostCenterId}", id);
            return StatusCode(500, "An error occurred while retrieving the cost center");
        }
    }

    /// <summary>
    /// Get active cost centers only
    /// </summary>
    [HttpGet("active")]
    public async Task<ActionResult<IEnumerable<CostCenter>>> GetActiveCostCenters()
    {
        try
        {
            var costCenters = await _costCenterService.GetActiveCostCentersAsync();
            return Ok(costCenters);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving active cost centers");
            return StatusCode(500, "An error occurred while retrieving active cost centers");
        }
    }
}
