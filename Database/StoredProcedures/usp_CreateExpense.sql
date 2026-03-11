-- Stored Procedure: Create Expense
-- E-001-F-002: Expense Recording
-- Creates a new expense and updates budget category spent amount

CREATE OR ALTER PROCEDURE [dbo].[usp_CreateExpense]
    @BudgetCategoryID UNIQUEIDENTIFIER,
    @Amount DECIMAL(18, 2),
    @ExpenseDate DATETIME2(7),
    @Description NVARCHAR(MAX) = NULL,
    @Vendor NVARCHAR(200) = NULL,
    @ReceiptNumber NVARCHAR(100) = NULL,
    @CreatedBy NVARCHAR(100),
    @ExpenseID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validate budget category exists
        IF NOT EXISTS (SELECT 1 FROM [dbo].[BudgetCategory] WHERE [ID] = @BudgetCategoryID)
        BEGIN
            THROW 50005, 'Invalid budget category', 1;
        END
        
        -- Validate amount
        IF @Amount <= 0
        BEGIN
            THROW 50006, 'Expense amount must be greater than zero', 1;
        END
        
        -- Validate expense date is not in the future
        IF @ExpenseDate > GETUTCDATE()
        BEGIN
            THROW 50007, 'Expense date cannot be in the future', 1;
        END
        
        -- Generate new ID
        SET @ExpenseID = NEWID();
        
        -- Insert expense
        INSERT INTO [dbo].[Expense] (
            [ID],
            [BudgetCategoryID],
            [Amount],
            [ExpenseDate],
            [Description],
            [Vendor],
            [ReceiptNumber],
            [CreatedBy],
            [CreatedAt]
        )
        VALUES (
            @ExpenseID,
            @BudgetCategoryID,
            @Amount,
            @ExpenseDate,
            @Description,
            @Vendor,
            @ReceiptNumber,
            @CreatedBy,
            GETUTCDATE()
        );
        
        -- Update budget category spent amount
        -- E-001-F-002-S-001-AC-002: Budget total updates
        UPDATE [dbo].[BudgetCategory]
        SET [SpentAmount] = [SpentAmount] + @Amount,
            [UpdatedAt] = GETUTCDATE()
        WHERE [ID] = @BudgetCategoryID;
        
        COMMIT TRANSACTION;
        
        -- Return the created expense
        SELECT * FROM [dbo].[Expense] WHERE [ID] = @ExpenseID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END
GO

GO
