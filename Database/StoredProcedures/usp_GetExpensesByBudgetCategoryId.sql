-- Stored Procedure: Get Expenses By Budget Category ID
-- E-001-F-002: Expense Recording
-- Retrieves all expenses for a specific budget category

CREATE OR ALTER PROCEDURE [dbo].[usp_GetExpensesByBudgetCategoryId]
    @BudgetCategoryID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        e.[ID],
        e.[BudgetCategoryID],
        e.[Amount],
        e.[ExpenseDate],
        e.[Description],
        e.[Vendor],
        e.[ReceiptNumber],
        e.[CreatedAt],
        e.[UpdatedAt],
        e.[CreatedBy],
        e.[UpdatedBy],
        bc.[CategoryName],
        bc.[BudgetID]
    FROM [dbo].[Expense] e
    INNER JOIN [dbo].[BudgetCategory] bc ON e.[BudgetCategoryID] = bc.[ID]
    WHERE e.[BudgetCategoryID] = @BudgetCategoryID
    ORDER BY e.[ExpenseDate] DESC, e.[CreatedAt] DESC;
END
GO

END
GO
