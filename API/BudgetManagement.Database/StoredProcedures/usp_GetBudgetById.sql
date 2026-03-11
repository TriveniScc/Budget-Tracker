-- Stored Procedure: usp_GetBudgetById
-- Retrieves a budget by ID with related project and cost center information
-- Parameters: BudgetID

CREATE PROCEDURE [dbo].[usp_GetBudgetById]
    @BudgetID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Return budget with project and cost center details
    SELECT 
        b.[BudgetID],
        b.[BudgetName],
        b.[ProjectID],
        p.[ProjectCode],
        p.[ProjectName],
        b.[CostCenterID],
        cc.[CostCenterCode],
        cc.[CostCenterName],
        b.[AllocatedAmount],
        b.[StartDate],
        b.[EndDate],
        b.[Description],
        b.[IsActive],
        b.[CreatedDate],
        b.[ModifiedDate],
        -- Calculate total spent
        ISNULL((
            SELECT SUM(e.[Amount])
            FROM [dbo].[Expense] e
            INNER JOIN [dbo].[BudgetCategory] bc ON e.[BudgetCategoryID] = bc.[BudgetCategoryID]
            WHERE bc.[BudgetID] = b.[BudgetID]
              AND e.[Status] IN ('Approved', 'Paid')
        ), 0) AS [TotalSpent],
        -- Calculate remaining amount
        b.[AllocatedAmount] - ISNULL((
            SELECT SUM(e.[Amount])
            FROM [dbo].[Expense] e
            INNER JOIN [dbo].[BudgetCategory] bc ON e.[BudgetCategoryID] = bc.[BudgetCategoryID]
            WHERE bc.[BudgetID] = b.[BudgetID]
              AND e.[Status] IN ('Approved', 'Paid')
        ), 0) AS [RemainingAmount]
    FROM [dbo].[Budget] b
    INNER JOIN [dbo].[Project] p ON b.[ProjectID] = p.[ProjectID]
    INNER JOIN [dbo].[CostCenter] cc ON b.[CostCenterID] = cc.[CostCenterID]
    WHERE b.[BudgetID] = @BudgetID;
    
    -- Return budget categories
    SELECT 
        bc.[BudgetCategoryID],
        bc.[BudgetID],
        bc.[CategoryName],
        bc.[AllocatedAmount],
        bc.[Description],
        bc.[IsActive],
        bc.[CreatedDate],
        bc.[ModifiedDate],
        -- Calculate category spent
        ISNULL((
            SELECT SUM(e.[Amount])
            FROM [dbo].[Expense] e
            WHERE e.[BudgetCategoryID] = bc.[BudgetCategoryID]
              AND e.[Status] IN ('Approved', 'Paid')
        ), 0) AS [TotalSpent],
        -- Calculate category remaining
        bc.[AllocatedAmount] - ISNULL((
            SELECT SUM(e.[Amount])
            FROM [dbo].[Expense] e
            WHERE e.[BudgetCategoryID] = bc.[BudgetCategoryID]
              AND e.[Status] IN ('Approved', 'Paid')
        ), 0) AS [RemainingAmount]
    FROM [dbo].[BudgetCategory] bc
    WHERE bc.[BudgetID] = @BudgetID
    ORDER BY bc.[CategoryName];
END
GO

    WHERE bc.[BudgetID] = @BudgetID
    ORDER BY bc.[CategoryName];
END
GO
