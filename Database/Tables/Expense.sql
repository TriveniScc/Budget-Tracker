-- Expense Table
-- Stores expenses recorded against budget categories
-- E-001-F-002: Expense Recording

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Expense]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Expense] (
        [ID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        [BudgetCategoryID] UNIQUEIDENTIFIER NOT NULL,
        [Amount] DECIMAL(18, 2) NOT NULL,
        [ExpenseDate] DATETIME2(7) NOT NULL,
        [Description] NVARCHAR(MAX) NULL,
        [Vendor] NVARCHAR(200) NULL,
        [ReceiptNumber] NVARCHAR(100) NULL,
        [CreatedAt] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2(7) NULL,
        [CreatedBy] NVARCHAR(100) NOT NULL,
        [UpdatedBy] NVARCHAR(100) NULL,
        CONSTRAINT [PK_Expense] PRIMARY KEY CLUSTERED ([ID] ASC),
        CONSTRAINT [FK_Expense_BudgetCategory] FOREIGN KEY ([BudgetCategoryID]) REFERENCES [dbo].[BudgetCategory]([ID]) ON DELETE CASCADE,
        CONSTRAINT [CK_Expense_Amount] CHECK ([Amount] > 0)
    );

    CREATE NONCLUSTERED INDEX [IX_Expense_BudgetCategoryId] ON [dbo].[Expense] ([BudgetCategoryID]);
    CREATE NONCLUSTERED INDEX [IX_Expense_ExpenseDate] ON [dbo].[Expense] ([ExpenseDate] DESC);
    CREATE NONCLUSTERED INDEX [IX_Expense_CreatedAt] ON [dbo].[Expense] ([CreatedAt] DESC);
    CREATE NONCLUSTERED INDEX [IX_Expense_ReceiptNumber] ON [dbo].[Expense] ([ReceiptNumber]);
END
GO

GO
