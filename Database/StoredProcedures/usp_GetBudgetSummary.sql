-- Stored Procedure: Get Budget Summary
-- E-002-F-001: Budget vs Actual View
-- Returns budget vs actual spending comparison

CREATE OR ALTER PROCEDURE [dbo].[usp_GetBudgetSummary]
    @BudgetID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Budget header information
    SELECT 
        b.[ID],
        b.[ProjectID],
        p.[ProjectCode],
        p.[ProjectName],
        b.[CostCenterID],
        cc.[CostCenterCode],
        cc.[CostCenterName],
        b.[StartDate],
        b.[EndDate],
        b.[TotalAmount] AS [BudgetedAmount],
        ISNULL(SUM(bc.[SpentAmount]), 0) AS [ActualAmount],
        b.[TotalAmount] - ISNULL(SUM(bc.[SpentAmount]), 0) AS [Variance],
        CASE 
            WHEN b.[TotalAmount] > 0 
            THEN (ISNULL(SUM(bc.[SpentAmount]), 0) / b.[TotalAmount]) * 100 
            ELSE 0 
        END AS [PercentageUsed]
    FROM [dbo].[Budget] b
    INNER JOIN [dbo].[Project] p ON b.[ProjectID] = p.[ID]
    INNER JOIN [dbo].[CostCenter] cc ON b.[CostCenterID] = cc.[ID]
    LEFT JOIN [dbo].[BudgetCategory] bc ON b.[ID] = bc.[BudgetID]
    WHERE b.[ID] = @BudgetID
    GROUP BY 
        b.[ID],
        b.[ProjectID],
        p.[ProjectCode],
        p.[ProjectName],
        b.[CostCenterID],
        cc.[CostCenterCode],
        cc.[CostCenterName],
        b.[StartDate],
        b.[EndDate],
        b.[TotalAmount];
    
    -- Category breakdown
    SELECT 
        bc.[ID],
        bc.[CategoryName],
        bc.[AllocatedAmount] AS [BudgetedAmount],
        bc.[SpentAmount] AS [ActualAmount],
        bc.[AllocatedAmount] - bc.[SpentAmount] AS [Variance],
        CASE 
            WHEN bc.[AllocatedAmount] > 0 
            THEN (bc.[SpentAmount] / bc.[AllocatedAmount]) * 100 
            ELSE 0 
        END AS [PercentageUsed],
        COUNT(e.[ID]) AS [ExpenseCount]
    FROM [dbo].[BudgetCategory] bc
    LEFT JOIN [dbo].[Expense] e ON bc.[ID] = e.[BudgetCategoryID]
    WHERE bc.[BudgetID] = @BudgetID
    GROUP BY 
        bc.[ID],
        bc.[CategoryName],
        bc.[AllocatedAmount],
        bc.[SpentAmount]
    ORDER BY bc.[CategoryName];
END
GO

GO
