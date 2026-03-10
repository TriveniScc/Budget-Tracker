using BudgetManagement.Api.Models;
using BudgetManagement.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace BudgetManagement.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ExpensesController : ControllerBase
{
    private readonly IExpenseService _expenseService;
    private readonly ILogger<ExpensesController> _logger;

    public ExpensesController(IExpenseService expenseService, ILogger<ExpensesController> logger)
    {
        _expenseService = expenseService;
        _logger = logger;
    }

    /// <summary>
    /// Get all expenses
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Expense>>> GetExpenses()
    {
        try
        {
            var expenses = await _expenseService.GetAllExpensesAsync();
            return Ok(expenses);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving expenses");
            return StatusCode(500, "An error occurred while retrieving expenses");
        }
    }

    /// <summary>
    /// Get expenses by budget category ID
    /// </summary>
    [HttpGet("by-category/{categoryId}")]
    public async Task<ActionResult<IEnumerable<Expense>>> GetExpensesByCategory(Guid categoryId)
    {
        try
        {
            var expenses = await _expenseService.GetExpensesByCategoryAsync(categoryId);
            return Ok(expenses);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving expenses for category {CategoryId}", categoryId);
            return StatusCode(500, "An error occurred while retrieving expenses");
        }
    }

    /// <summary>
    /// Get expense by ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<ActionResult<Expense>> GetExpense(Guid id)
    {
        try
        {
            var expense = await _expenseService.GetExpenseByIdAsync(id);
            if (expense == null)
                return NotFound($"Expense with ID {id} not found");

            return Ok(expense);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving expense {ExpenseId}", id);
            return StatusCode(500, "An error occurred while retrieving the expense");
        }
    }

    /// <summary>
    /// Create a new expense
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<Expense>> CreateExpense([FromBody] Expense expense)
    {
        try
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var createdExpense = await _expenseService.CreateExpenseAsync(expense);
            return CreatedAtAction(nameof(GetExpense), new { id = createdExpense.ID }, createdExpense);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating expense");
            return StatusCode(500, "An error occurred while creating the expense");
        }
    }

    /// <summary>
    /// Update an existing expense
    /// </summary>
    [HttpPut("{id}")]
    public async Task<ActionResult> UpdateExpense(Guid id, [FromBody] Expense expense)
    {
        try
        {
            if (id != expense.ID)
                return BadRequest("Expense ID mismatch");

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _expenseService.UpdateExpenseAsync(expense);
            if (!result)
                return NotFound($"Expense with ID {id} not found");

            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating expense {ExpenseId}", id);
            return StatusCode(500, "An error occurred while updating the expense");
        }
    }

    /// <summary>
    /// Delete an expense
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteExpense(Guid id)
    {
        try
        {
            var result = await _expenseService.DeleteExpenseAsync(id);
            if (!result)
                return NotFound($"Expense with ID {id} not found");

            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting expense {ExpenseId}", id);
            return StatusCode(500, "An error occurred while deleting the expense");
        }
    }
}

        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting expense {ExpenseId}", id);
            return StatusCode(500, "An error occurred while deleting the expense");
        }
    }
}
