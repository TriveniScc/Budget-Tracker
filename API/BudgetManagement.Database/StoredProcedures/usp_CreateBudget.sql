-- Stored Procedure: usp_CreateBudget
-- Creates a new budget record
-- Parameters: Budget details including project, cost center, amounts, and date range

CREATE PROCEDURE [dbo].[usp_CreateBudget]
    @BudgetName NVARCHAR(200),
    @ProjectID UNIQUEIDENTIFIER,
    @CostCenterID UNIQUEIDENTIFIER,
    @AllocatedAmount DECIMAL(18, 2),
    @StartDate DATE,
    @EndDate DATE,
    @Description NVARCHAR(MAX) = NULL,
    @BudgetID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Generate new GUID for BudgetID
        SET @BudgetID = NEWID();
        
        -- Validate project exists and is active
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Project] WHERE [ProjectID] = @ProjectID AND [IsActive] = 1)
        BEGIN
            THROW 50001, 'Invalid or inactive project', 1;
        END
        
        -- Validate cost center exists and is active
        IF NOT EXISTS (SELECT 1 FROM [dbo].[CostCenter] WHERE [CostCenterID] = @CostCenterID AND [IsActive] = 1)
        BEGIN
            THROW 50002, 'Invalid or inactive cost center', 1;
        END
        
        -- Validate date range
        IF @EndDate < @StartDate
        BEGIN
            THROW 50003, 'End date must be greater than or equal to start date', 1;
        END
        
        -- Validate allocated amount
        IF @AllocatedAmount < 0
        BEGIN
            THROW 50004, 'Allocated amount must be greater than or equal to zero', 1;
        END
        
        -- Insert budget
        INSERT INTO [dbo].[Budget] (
            [BudgetID],
            [BudgetName],
            [ProjectID],
            [CostCenterID],
            [AllocatedAmount],
            [StartDate],
            [EndDate],
            [Description],
            [IsActive],
            [CreatedDate]
        )
        VALUES (
            @BudgetID,
            @BudgetName,
            @ProjectID,
            @CostCenterID,
            @AllocatedAmount,
            @StartDate,
            @EndDate,
            @Description,
            1,
            GETUTCDATE()
        );
        
        COMMIT TRANSACTION;
        
        -- Return the created budget
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
            b.[Description],
            b.[IsActive],
            b.[CreatedDate],
            b.[ModifiedDate]
        FROM [dbo].[Budget] b
        INNER JOIN [dbo].[Project] p ON b.[ProjectID] = p.[ProjectID]
        INNER JOIN [dbo].[CostCenter] cc ON b.[CostCenterID] = cc.[CostCenterID]
        WHERE b.[BudgetID] = @BudgetID;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END
GO

            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END
GO
