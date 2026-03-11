-- Expense Table
-- Individual expenses tracked against budget categories

CREATE TABLE [dbo].[Expense] (
    [ExpenseID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [BudgetCategoryID] UNIQUEIDENTIFIER NOT NULL,
    [ExpenseDate] DATE NOT NULL,
    [Amount] DECIMAL(18, 2) NOT NULL,
    [Description] NVARCHAR(500) NOT NULL,
    [Vendor] NVARCHAR(200) NULL,
    [InvoiceNumber] NVARCHAR(100) NULL,
    [ApprovedBy] NVARCHAR(200) NULL,
    [ApprovedDate] DATETIME2(7) NULL,
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    [CreatedDate] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2(7) NULL,
    
    CONSTRAINT [PK_Expense] PRIMARY KEY CLUSTERED ([ExpenseID] ASC),
    CONSTRAINT [FK_Expense_BudgetCategory] FOREIGN KEY ([BudgetCategoryID]) 
        REFERENCES [dbo].[BudgetCategory]([BudgetCategoryID]) ON DELETE CASCADE,
    CONSTRAINT [CK_Expense_Amount] CHECK ([Amount] > 0),
    CONSTRAINT [CK_Expense_Status] CHECK ([Status] IN ('Pending', 'Approved', 'Rejected', 'Paid'))
);
GO

-- Index for budget category-based expense lookup
CREATE NONCLUSTERED INDEX [IX_Expense_BudgetCategoryID]
    ON [dbo].[Expense]([BudgetCategoryID] ASC)
    INCLUDE ([ExpenseDate], [Amount], [Description], [Status]);
GO

-- Index for expense date range queries
CREATE NONCLUSTERED INDEX [IX_Expense_ExpenseDate]
    ON [dbo].[Expense]([ExpenseDate] ASC)
    INCLUDE ([BudgetCategoryID], [Amount], [Status]);
GO

-- Index for status-based queries
CREATE NONCLUSTERED INDEX [IX_Expense_Status]
    ON [dbo].[Expense]([Status] ASC)
    INCLUDE ([BudgetCategoryID], [ExpenseDate], [Amount]);
GO

-- Index for invoice number lookup
CREATE NONCLUSTERED INDEX [IX_Expense_InvoiceNumber]
    ON [dbo].[Expense]([InvoiceNumber] ASC)
    WHERE [InvoiceNumber] IS NOT NULL;
GO
