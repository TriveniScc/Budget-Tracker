using BudgetManagement.Api.Models;
using Dapper;
using System.Data;

namespace BudgetManagement.Api.Repositories;

public class ExpenseRepository : IExpenseRepository
{
    private readonly IDbConnection _connection;

    public ExpenseRepository(IDbConnection connection)
    {
        _connection = connection;
    }

    public async Task<IEnumerable<Expense>> GetAllAsync()
    {
        const string sql = @"
            SELECT * FROM Expense
            ORDER BY ExpenseDate DESC";
        
        return await _connection.QueryAsync<Expense>(sql);
    }

    public async Task<Expense?> GetByIdAsync(Guid expenseId)
    {
        const string sql = @"
            SELECT * FROM Expense
            WHERE ID = @ID";
        
        return await _connection.QuerySingleOrDefaultAsync<Expense>(sql, new { ID = expenseId });
    }

    public async Task<IEnumerable<Expense>> GetByCategoryIdAsync(Guid categoryId)
    {
        const string sql = @"
            SELECT * FROM Expense
            WHERE BudgetCategoryID = @CategoryID
            ORDER BY ExpenseDate DESC";
        
        return await _connection.QueryAsync<Expense>(sql, new { CategoryID = categoryId });
    }

    public async Task<Expense> CreateAsync(Expense expense)
    {
        const string sql = @"
            INSERT INTO Expense (ID, BudgetCategoryID, Amount, ExpenseDate, Description, Vendor, ReceiptNumber, CreatedAt, CreatedBy)
            VALUES (@ID, @BudgetCategoryID, @Amount, @ExpenseDate, @Description, @Vendor, @ReceiptNumber, @CreatedAt, @CreatedBy)";
        
        if (expense.ID == Guid.Empty)
        {
            expense.ID = Guid.NewGuid();
        }
        
        await _connection.ExecuteAsync(sql, expense);
        return expense;
    }

    public async Task<bool> UpdateAsync(Expense expense)
    {
        const string sql = @"
            UPDATE Expense
            SET BudgetCategoryID = @BudgetCategoryID,
                Amount = @Amount,
                ExpenseDate = @ExpenseDate,
                Description = @Description,
                Vendor = @Vendor,
                ReceiptNumber = @ReceiptNumber,
                UpdatedAt = @UpdatedAt,
                UpdatedBy = @UpdatedBy
            WHERE ID = @ID";
        
        var rowsAffected = await _connection.ExecuteAsync(sql, expense);
        return rowsAffected > 0;
    }

    public async Task<bool> DeleteAsync(Guid expenseId)
    {
        const string sql = "DELETE FROM Expense WHERE ID = @ID";
        var rowsAffected = await _connection.ExecuteAsync(sql, new { ID = expenseId });
        return rowsAffected > 0;
    }
}

}
