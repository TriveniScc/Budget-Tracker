using BudgetManagement.Api.Models;
using BudgetManagement.Api.Repositories;

namespace BudgetManagement.Api.Services;

public class ExpenseService : IExpenseService
{
    private readonly IExpenseRepository _expenseRepository;
    private readonly ILogger<ExpenseService> _logger;

    public ExpenseService(IExpenseRepository expenseRepository, ILogger<ExpenseService> logger)
    {
        _expenseRepository = expenseRepository;
        _logger = logger;
    }

    public async Task<IEnumerable<Expense>> GetAllExpensesAsync()
    {
        _logger.LogInformation("Retrieving all expenses");
        return await _expenseRepository.GetAllAsync();
    }

    public async Task<Expense?> GetExpenseByIdAsync(Guid expenseId)
    {
        _logger.LogInformation("Retrieving expense with ID: {ExpenseId}", expenseId);
        return await _expenseRepository.GetByIdAsync(expenseId);
    }

    public async Task<IEnumerable<Expense>> GetExpensesByCategoryAsync(Guid categoryId)
    {
        _logger.LogInformation("Retrieving expenses for category ID: {CategoryId}", categoryId);
        return await _expenseRepository.GetByCategoryIdAsync(categoryId);
    }

    public async Task<Expense> CreateExpenseAsync(Expense expense)
    {
        _logger.LogInformation("Creating new expense for category: {CategoryId}", expense.BudgetCategoryID);
        
        // Business validation
        if (expense.Amount <= 0)
            throw new ArgumentException("Expense amount must be greater than zero");
        
        if (expense.ExpenseDate > DateTime.UtcNow)
            throw new ArgumentException("Expense date cannot be in the future");
        
        expense.CreatedAt = DateTime.UtcNow;
        return await _expenseRepository.CreateAsync(expense);
    }

    public async Task<bool> UpdateExpenseAsync(Expense expense)
    {
        _logger.LogInformation("Updating expense with ID: {ExpenseId}", expense.ID);
        
        // Business validation
        if (expense.Amount <= 0)
            throw new ArgumentException("Expense amount must be greater than zero");
        
        if (expense.ExpenseDate > DateTime.UtcNow)
            throw new ArgumentException("Expense date cannot be in the future");
        
        expense.UpdatedAt = DateTime.UtcNow;
        return await _expenseRepository.UpdateAsync(expense);
    }

    public async Task<bool> DeleteExpenseAsync(Guid expenseId)
    {
        _logger.LogInformation("Deleting expense with ID: {ExpenseId}", expenseId);
        return await _expenseRepository.DeleteAsync(expenseId);
    }
}

    }
}
