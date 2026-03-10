-- BudgetCategory Table
-- Stores spending categories within a budget
-- E-001-F-001: Budget Creation - spending categories

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetCategory]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[BudgetCategory] (
        [ID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        [BudgetID] UNIQUEIDENTIFIER NOT NULL,
        [CategoryName] NVARCHAR(200) NOT NULL,
        [AllocatedAmount] DECIMAL(18, 2) NOT NULL,
        [SpentAmount] DECIMAL(18, 2) NOT NULL DEFAULT 0,
        [CreatedAt] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_BudgetCategory] PRIMARY KEY CLUSTERED ([ID] ASC),
        CONSTRAINT [FK_BudgetCategory_Budget] FOREIGN KEY ([BudgetID]) REFERENCES [dbo].[Budget]([ID]) ON DELETE CASCADE,
        CONSTRAINT [CK_BudgetCategory_AllocatedAmount] CHECK ([AllocatedAmount] >= 0),
        CONSTRAINT [CK_BudgetCategory_SpentAmount] CHECK ([SpentAmount] >= 0)
    );

    CREATE NONCLUSTERED INDEX [IX_BudgetCategory_BudgetId] ON [dbo].[BudgetCategory] ([BudgetID]);
    CREATE NONCLUSTERED INDEX [IX_BudgetCategory_CategoryName] ON [dbo].[BudgetCategory] ([CategoryName]);
END
GO

END
GO
