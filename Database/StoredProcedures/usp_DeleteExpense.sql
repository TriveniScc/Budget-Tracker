-- Stored Procedure: Delete Expense
-- E-001-F-002: Expense Recording
-- Deletes an expense and updates budget category spent amount

CREATE OR ALTER PROCEDURE [dbo].[usp_DeleteExpense]
    @ExpenseID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @BudgetCategoryID UNIQUEIDENTIFIER;
        DECLARE @Amount DECIMAL(18, 2);
        
        -- Get expense details
        SELECT 
            @BudgetCategoryID = [BudgetCategoryID],
            @Amount = [Amount]
        FROM [dbo].[Expense]
        WHERE [ID] = @ExpenseID;
        
        IF @BudgetCategoryID IS NULL
        BEGIN
            THROW 50008, 'Expense not found', 1;
        END
        
        -- Delete expense
        DELETE FROM [dbo].[Expense]
        WHERE [ID] = @ExpenseID;
        
        -- Update budget category spent amount
        UPDATE [dbo].[BudgetCategory]
        SET [SpentAmount] = [SpentAmount] - @Amount,
            [UpdatedAt] = GETUTCDATE()
        WHERE [ID] = @BudgetCategoryID;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END
GO

GO
