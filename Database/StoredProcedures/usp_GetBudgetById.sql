-- Stored Procedure: Get Budget By ID
-- E-001-F-001: Budget Creation
-- Retrieves a budget with all related categories

CREATE OR ALTER PROCEDURE [dbo].[usp_GetBudgetById]
    @BudgetID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get budget details
    SELECT 
        b.[ID],
        b.[ProjectID],
        b.[CostCenterID],
        b.[StartDate],
        b.[EndDate],
        b.[TotalAmount],
        b.[Description],
        b.[CreatedAt],
        b.[UpdatedAt],
        b.[CreatedBy],
        b.[UpdatedBy],
        p.[ProjectCode],
        p.[ProjectName],
        cc.[CostCenterCode],
        cc.[CostCenterName]
    FROM [dbo].[Budget] b
    INNER JOIN [dbo].[Project] p ON b.[ProjectID] = p.[ID]
    INNER JOIN [dbo].[CostCenter] cc ON b.[CostCenterID] = cc.[ID]
    WHERE b.[ID] = @BudgetID;
    
    -- Get budget categories
    SELECT 
        bc.[ID],
        bc.[BudgetID],
        bc.[CategoryName],
        bc.[AllocatedAmount],
        bc.[SpentAmount],
        bc.[AllocatedAmount] - bc.[SpentAmount] AS [RemainingAmount],
        CASE 
            WHEN bc.[AllocatedAmount] > 0 
            THEN (bc.[SpentAmount] / bc.[AllocatedAmount]) * 100 
            ELSE 0 
        END AS [PercentageUsed],
        bc.[CreatedAt],
        bc.[UpdatedAt]
    FROM [dbo].[BudgetCategory] bc
    WHERE bc.[BudgetID] = @BudgetID
    ORDER BY bc.[CategoryName];
END
GO

GO
