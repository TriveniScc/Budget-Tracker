-- Stored Procedure: usp_GetExpensesByBudgetCategoryId
-- Retrieves all expenses for a specific budget category
-- Parameters: BudgetCategoryID

CREATE PROCEDURE [dbo].[usp_GetExpensesByBudgetCategoryId]
    @BudgetCategoryID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Return expenses with category and budget information
    SELECT 
        e.[ExpenseID],
        e.[BudgetCategoryID],
        bc.[CategoryName],
        bc.[BudgetID],
        b.[BudgetName],
        b.[ProjectID],
        p.[ProjectName],
        b.[CostCenterID],
        cc.[CostCenterName],
        e.[ExpenseDate],
        e.[Amount],
        e.[Description],
        e.[Vendor],
        e.[InvoiceNumber],
        e.[ApprovedBy],
        e.[ApprovedDate],
        e.[Status],
        e.[CreatedDate],
        e.[ModifiedDate]
    FROM [dbo].[Expense] e
    INNER JOIN [dbo].[BudgetCategory] bc ON e.[BudgetCategoryID] = bc.[BudgetCategoryID]
    INNER JOIN [dbo].[Budget] b ON bc.[BudgetID] = b.[BudgetID]
    INNER JOIN [dbo].[Project] p ON b.[ProjectID] = p.[ProjectID]
    INNER JOIN [dbo].[CostCenter] cc ON b.[CostCenterID] = cc.[CostCenterID]
    WHERE e.[BudgetCategoryID] = @BudgetCategoryID
    ORDER BY e.[ExpenseDate] DESC, e.[CreatedDate] DESC;
    
    -- Return summary statistics
    SELECT 
        bc.[BudgetCategoryID],
        bc.[CategoryName],
        bc.[AllocatedAmount],
        COUNT(e.[ExpenseID]) AS [TotalExpenseCount],
        ISNULL(SUM(CASE WHEN e.[Status] = 'Pending' THEN e.[Amount] ELSE 0 END), 0) AS [PendingAmount],
        ISNULL(SUM(CASE WHEN e.[Status] = 'Approved' THEN e.[Amount] ELSE 0 END), 0) AS [ApprovedAmount],
        ISNULL(SUM(CASE WHEN e.[Status] = 'Paid' THEN e.[Amount] ELSE 0 END), 0) AS [PaidAmount],
        ISNULL(SUM(CASE WHEN e.[Status] IN ('Approved', 'Paid') THEN e.[Amount] ELSE 0 END), 0) AS [TotalSpent],
        bc.[AllocatedAmount] - ISNULL(SUM(CASE WHEN e.[Status] IN ('Approved', 'Paid') THEN e.[Amount] ELSE 0 END), 0) AS [RemainingAmount]
    FROM [dbo].[BudgetCategory] bc
    LEFT JOIN [dbo].[Expense] e ON bc.[BudgetCategoryID] = e.[BudgetCategoryID]
    WHERE bc.[BudgetCategoryID] = @BudgetCategoryID
    GROUP BY 
        bc.[BudgetCategoryID],
        bc.[CategoryName],
        bc.[AllocatedAmount];
END
GO

GO
