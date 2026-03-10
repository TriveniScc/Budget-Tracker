using BudgetManagement.Api.Models;

namespace BudgetManagement.Api.Repositories;

public interface IExpenseRepository
{
    Task<IEnumerable<Expense>> GetAllAsync();
    Task<Expense?> GetByIdAsync(Guid expenseId);
    Task<IEnumerable<Expense>> GetByCategoryIdAsync(Guid categoryId);
    Task<Expense> CreateAsync(Expense expense);
    Task<bool> UpdateAsync(Expense expense);
    Task<bool> DeleteAsync(Guid expenseId);
}

