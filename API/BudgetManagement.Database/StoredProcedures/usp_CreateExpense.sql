-- Stored Procedure: usp_CreateExpense
-- Creates a new expense record
-- Parameters: Expense details including category, amount, date, and description

CREATE PROCEDURE [dbo].[usp_CreateExpense]
    @BudgetCategoryID UNIQUEIDENTIFIER,
    @ExpenseDate DATE,
    @Amount DECIMAL(18, 2),
    @Description NVARCHAR(500),
    @Vendor NVARCHAR(200) = NULL,
    @InvoiceNumber NVARCHAR(100) = NULL,
    @Status NVARCHAR(50) = 'Pending',
    @ExpenseID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Generate new GUID for ExpenseID
        SET @ExpenseID = NEWID();
        
        -- Validate budget category exists and is active
        IF NOT EXISTS (
            SELECT 1 
            FROM [dbo].[BudgetCategory] bc
            INNER JOIN [dbo].[Budget] b ON bc.[BudgetID] = b.[BudgetID]
            WHERE bc.[BudgetCategoryID] = @BudgetCategoryID 
              AND bc.[IsActive] = 1 
              AND b.[IsActive] = 1
        )
        BEGIN
            THROW 50001, 'Invalid or inactive budget category', 1;
        END
        
        -- Validate amount
        IF @Amount <= 0
        BEGIN
            THROW 50002, 'Amount must be greater than zero', 1;
        END
        
        -- Validate status
        IF @Status NOT IN ('Pending', 'Approved', 'Rejected', 'Paid')
        BEGIN
            THROW 50003, 'Invalid status value', 1;
        END
        
        -- Check if expense date is within budget date range
        DECLARE @BudgetStartDate DATE, @BudgetEndDate DATE;
        
        SELECT 
            @BudgetStartDate = b.[StartDate],
            @BudgetEndDate = b.[EndDate]
        FROM [dbo].[BudgetCategory] bc
        INNER JOIN [dbo].[Budget] b ON bc.[BudgetID] = b.[BudgetID]
        WHERE bc.[BudgetCategoryID] = @BudgetCategoryID;
        
        IF @ExpenseDate < @BudgetStartDate OR @ExpenseDate > @BudgetEndDate
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(500);
            SET @ErrorMessage = 'Expense date must be within budget date range (' + 
                CONVERT(NVARCHAR, @BudgetStartDate, 120) + ' to ' + 
                CONVERT(NVARCHAR, @BudgetEndDate, 120) + ')';
            THROW 50004, @ErrorMessage, 1;
        END
        
        -- Insert expense
        INSERT INTO [dbo].[Expense] (
            [ExpenseID],
            [BudgetCategoryID],
            [ExpenseDate],
            [Amount],
            [Description],
            [Vendor],
            [InvoiceNumber],
            [Status],
            [CreatedDate]
        )
        VALUES (
            @ExpenseID,
            @BudgetCategoryID,
            @ExpenseDate,
            @Amount,
            @Description,
            @Vendor,
            @InvoiceNumber,
            @Status,
            GETUTCDATE()
        );
        
        COMMIT TRANSACTION;
        
        -- Return the created expense
        SELECT 
            e.[ExpenseID],
            e.[BudgetCategoryID],
            bc.[CategoryName],
            bc.[BudgetID],
            b.[BudgetName],
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
        WHERE e.[ExpenseID] = @ExpenseID;
        
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
