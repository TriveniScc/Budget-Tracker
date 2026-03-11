-- Stored Procedure: usp_DeleteExpense
-- Deletes an expense record (soft delete by marking as inactive could be added)
-- Parameters: ExpenseID

CREATE PROCEDURE [dbo].[usp_DeleteExpense]
    @ExpenseID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validate expense exists
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Expense] WHERE [ExpenseID] = @ExpenseID)
        BEGIN
            THROW 50001, 'Expense not found', 1;
        END
        
        -- Check if expense is already paid (optional business rule)
        DECLARE @ExpenseStatus NVARCHAR(50);
        SELECT @ExpenseStatus = [Status] FROM [dbo].[Expense] WHERE [ExpenseID] = @ExpenseID;
        
        IF @ExpenseStatus = 'Paid'
        BEGIN
            THROW 50002, 'Cannot delete paid expenses', 1;
        END
        
        -- Delete the expense
        DELETE FROM [dbo].[Expense]
        WHERE [ExpenseID] = @ExpenseID;
        
        COMMIT TRANSACTION;
        
        -- Return success indicator
        SELECT 1 AS [Success], 'Expense deleted successfully' AS [Message];
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Return error details
        SELECT 
            0 AS [Success],
            ERROR_MESSAGE() AS [Message],
            ERROR_NUMBER() AS [ErrorNumber],
            ERROR_STATE() AS [ErrorState];
    END CATCH
END
GO

            ERROR_STATE() AS [ErrorState];
    END CATCH
END
GO
