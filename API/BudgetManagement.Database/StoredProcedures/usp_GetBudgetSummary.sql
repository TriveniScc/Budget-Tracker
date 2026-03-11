-- Stored Procedure: usp_GetBudgetSummary
-- Returns budget summary with spending details by category
-- Parameters: BudgetID

CREATE PROCEDURE [dbo].[usp_GetBudgetSummary]
    @BudgetID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Return budget header summary
    SELECT 
        b.[BudgetID],
        b.[BudgetName],
        b.[ProjectID],
        p.[ProjectName],
        b.[CostCenterID],
        cc.[CostCenterName],
        b.[AllocatedAmount],
        b.[StartDate],
        b.[EndDate],
        ISNULL(SUM(e.[Amount]), 0) AS [TotalSpent],
        b.[AllocatedAmount] - ISNULL(SUM(e.[Amount]), 0) AS [RemainingAmount],
        CASE 
            WHEN b.[AllocatedAmount] > 0 
            THEN CAST(ISNULL(SUM(e.[Amount]), 0) * 100.0 / b.[AllocatedAmount] AS DECIMAL(5,2))
            ELSE 0 
        END AS [PercentageSpent]
    FROM [dbo].[Budget] b
    INNER JOIN [dbo].[Project] p ON b.[ProjectID] = p.[ProjectID]
    INNER JOIN [dbo].[CostCenter] cc ON b.[CostCenterID] = cc.[CostCenterID]
    LEFT JOIN [dbo].[BudgetCategory] bc ON b.[BudgetID] = bc.[BudgetID]
    LEFT JOIN [dbo].[Expense] e ON bc.[BudgetCategoryID] = e.[BudgetCategoryID] 
        AND e.[Status] IN ('Approved', 'Paid')
    WHERE b.[BudgetID] = @BudgetID
    GROUP BY 
        b.[BudgetID],
        b.[BudgetName],
        b.[ProjectID],
        p.[ProjectName],
        b.[CostCenterID],
        cc.[CostCenterName],
        b.[AllocatedAmount],
        b.[StartDate],
        b.[EndDate];
    
    -- Return category-level summary
    SELECT 
        bc.[BudgetCategoryID],
        bc.[CategoryName],
        bc.[AllocatedAmount],
        ISNULL(SUM(e.[Amount]), 0) AS [TotalSpent],
        bc.[AllocatedAmount] - ISNULL(SUM(e.[Amount]), 0) AS [RemainingAmount],
        CASE 
            WHEN bc.[AllocatedAmount] > 0 
            THEN CAST(ISNULL(SUM(e.[Amount]), 0) * 100.0 / bc.[AllocatedAmount] AS DECIMAL(5,2))
            ELSE 0 
        END AS [PercentageSpent],
        COUNT(e.[ExpenseID]) AS [ExpenseCount]
    FROM [dbo].[BudgetCategory] bc
    LEFT JOIN [dbo].[Expense] e ON bc.[BudgetCategoryID] = e.[BudgetCategoryID] 
        AND e.[Status] IN ('Approved', 'Paid')
    WHERE bc.[BudgetID] = @BudgetID
    GROUP BY 
        bc.[BudgetCategoryID],
        bc.[CategoryName],
        bc.[AllocatedAmount]
    ORDER BY bc.[CategoryName];
    
    -- Return recent expenses (top 10)
    SELECT TOP 10
        e.[ExpenseID],
        e.[BudgetCategoryID],
        bc.[CategoryName],
        e.[ExpenseDate],
        e.[Amount],
        e.[Description],
        e.[Vendor],
        e.[InvoiceNumber],
        e.[Status]
    FROM [dbo].[Expense] e
    INNER JOIN [dbo].[BudgetCategory] bc ON e.[BudgetCategoryID] = bc.[BudgetCategoryID]
    WHERE bc.[BudgetID] = @BudgetID
    ORDER BY e.[ExpenseDate] DESC, e.[CreatedDate] DESC;
END
GO

        e.[InvoiceNumber],
        e.[Status]
    FROM [dbo].[Expense] e
    INNER JOIN [dbo].[BudgetCategory] bc ON e.[BudgetCategoryID] = bc.[BudgetCategoryID]
    WHERE bc.[BudgetID] = @BudgetID
    ORDER BY e.[ExpenseDate] DESC, e.[CreatedDate] DESC;
END
GO
