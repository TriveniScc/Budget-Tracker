-- Stored Procedure: Create Budget
-- E-001-F-001: Budget Creation
-- Creates a new budget with validation

CREATE OR ALTER PROCEDURE [dbo].[usp_CreateBudget]
    @ProjectID UNIQUEIDENTIFIER,
    @CostCenterID UNIQUEIDENTIFIER,
    @StartDate DATETIME2(7),
    @EndDate DATETIME2(7),
    @TotalAmount DECIMAL(18, 2),
    @Description NVARCHAR(MAX) = NULL,
    @CreatedBy NVARCHAR(100),
    @BudgetID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validate project exists and is active
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Project] WHERE [ID] = @ProjectID AND [IsActive] = 1)
        BEGIN
            THROW 50001, 'Invalid or inactive project', 1;
        END
        
        -- Validate cost center exists and is active
        IF NOT EXISTS (SELECT 1 FROM [dbo].[CostCenter] WHERE [ID] = @CostCenterID AND [IsActive] = 1)
        BEGIN
            THROW 50002, 'Invalid or inactive cost center', 1;
        END
        
        -- Validate date range
        IF @EndDate <= @StartDate
        BEGIN
            THROW 50003, 'End date must be after start date', 1;
        END
        
        -- Validate amount
        IF @TotalAmount <= 0
        BEGIN
            THROW 50004, 'Total amount must be greater than zero', 1;
        END
        
        -- Generate new ID
        SET @BudgetID = NEWID();
        
        -- Insert budget
        INSERT INTO [dbo].[Budget] (
            [ID],
            [ProjectID],
            [CostCenterID],
            [StartDate],
            [EndDate],
            [TotalAmount],
            [Description],
            [CreatedBy],
            [CreatedAt]
        )
        VALUES (
            @BudgetID,
            @ProjectID,
            @CostCenterID,
            @StartDate,
            @EndDate,
            @TotalAmount,
            @Description,
            @CreatedBy,
            GETUTCDATE()
        );
        
        COMMIT TRANSACTION;
        
        -- Return the created budget
        SELECT * FROM [dbo].[Budget] WHERE [ID] = @BudgetID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END
GO

GO
