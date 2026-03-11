-- BudgetCategory Table
-- Subcategories within a budget for detailed expense tracking

CREATE TABLE [dbo].[BudgetCategory] (
    [BudgetCategoryID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [BudgetID] UNIQUEIDENTIFIER NOT NULL,
    [CategoryName] NVARCHAR(200) NOT NULL,
    [AllocatedAmount] DECIMAL(18, 2) NOT NULL,
    [Description] NVARCHAR(MAX) NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [CreatedDate] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2(7) NULL,
    
    CONSTRAINT [PK_BudgetCategory] PRIMARY KEY CLUSTERED ([BudgetCategoryID] ASC),
    CONSTRAINT [FK_BudgetCategory_Budget] FOREIGN KEY ([BudgetID]) 
        REFERENCES [dbo].[Budget]([BudgetID]) ON DELETE CASCADE,
    CONSTRAINT [CK_BudgetCategory_AllocatedAmount] CHECK ([AllocatedAmount] >= 0),
    CONSTRAINT [UQ_BudgetCategory_BudgetID_CategoryName] UNIQUE NONCLUSTERED ([BudgetID] ASC, [CategoryName] ASC)
);
GO

-- Index for budget-based category lookup
CREATE NONCLUSTERED INDEX [IX_BudgetCategory_BudgetID]
    ON [dbo].[BudgetCategory]([BudgetID] ASC)
    INCLUDE ([CategoryName], [AllocatedAmount], [IsActive]);
GO

-- Index for active categories
CREATE NONCLUSTERED INDEX [IX_BudgetCategory_IsActive]
    ON [dbo].[BudgetCategory]([IsActive] ASC)
    INCLUDE ([BudgetID], [CategoryName], [AllocatedAmount]);
GO
