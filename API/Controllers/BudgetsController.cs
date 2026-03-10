using BudgetManagement.Api.Models;
using BudgetManagement.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace BudgetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BudgetsController : ControllerBase
{
    private readonly IBudgetService _budgetService;
    private readonly ILogger<BudgetsController> _logger;

    public BudgetsController(IBudgetService budgetService, ILogger<BudgetsController> logger)
    {
        _budgetService = budgetService;
        _logger = logger;
    }

    /// <summary>
    /// Get all budgets
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Budget>>> GetBudgets()
    {
        try
        {
            var budgets = await _budgetService.GetAllBudgetsAsync();
            return Ok(budgets);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving budgets");
            return StatusCode(500, "An error occurred while retrieving budgets");
        }
    }

    /// <summary>
    /// Get budget by ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<ActionResult<Budget>> GetBudget(Guid id)
    {
        try
        {
            var budget = await _budgetService.GetBudgetByIdAsync(id);
            if (budget == null)
                return NotFound($"Budget with ID {id} not found");

            return Ok(budget);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving budget {BudgetId}", id);
            return StatusCode(500, "An error occurred while retrieving the budget");
        }
    }

    /// <summary>
    /// Create a new budget
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<Budget>> CreateBudget([FromBody] Budget budget)
    {
        try
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var createdBudget = await _budgetService.CreateBudgetAsync(budget);
            return CreatedAtAction(nameof(GetBudget), new { id = createdBudget.ID }, createdBudget);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating budget");
            return StatusCode(500, "An error occurred while creating the budget");
        }
    }

    /// <summary>
    /// Update an existing budget
    /// </summary>
    [HttpPut("{id}")]
    public async Task<ActionResult> UpdateBudget(Guid id, [FromBody] Budget budget)
    {
        try
        {
            if (id != budget.ID)
                return BadRequest("Budget ID mismatch");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _budgetService.UpdateBudgetAsync(budget);
            if (!result)
                return NotFound($"Budget with ID {id} not found");

            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating budget {BudgetId}", id);
            return StatusCode(500, "An error occurred while updating the budget");
        }
    }

    /// <summary>
    /// Delete a budget
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteBudget(Guid id)
    {
        try
        {
            var result = await _budgetService.DeleteBudgetAsync(id);
            if (!result)
                return NotFound($"Budget with ID {id} not found");

            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting budget {BudgetId}", id);
            return StatusCode(500, "An error occurred while deleting the budget");
        }
    }
}

        {
            _logger.LogError(ex, "Error deleting budget {BudgetId}", id);
            return StatusCode(500, "An error occurred while deleting the budget");
        }
    }
}
