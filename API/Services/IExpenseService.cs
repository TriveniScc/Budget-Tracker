using BudgetManagement.Api.Models;

namespace BudgetManagement.Api.Services;

public interface IExpenseService
{
    Task<IEnumerable<Expense>> GetAllExpensesAsync();
    Task<Expense?> GetExpenseByIdAsync(Guid expenseId);
    Task<IEnumerable<Expense>> GetExpensesByCategoryAsync(Guid categoryId);
    Task<Expense> CreateExpenseAsync(Expense expense);
    Task<bool> UpdateExpenseAsync(Expense expense);
    Task<bool> DeleteExpenseAsync(Guid expenseId);
}

