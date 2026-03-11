-- Budget Table
-- Main budget table linking projects and cost centers with allocated amounts and date ranges

CREATE TABLE [dbo].[Budget] (
    [BudgetID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [BudgetName] NVARCHAR(200) NOT NULL,
    [ProjectID] UNIQUEIDENTIFIER NOT NULL,
    [CostCenterID] UNIQUEIDENTIFIER NOT NULL,
    [AllocatedAmount] DECIMAL(18, 2) NOT NULL,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NOT NULL,
    [Description] NVARCHAR(MAX) NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [CreatedDate] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2(7) NULL,
    
    CONSTRAINT [PK_Budget] PRIMARY KEY CLUSTERED ([BudgetID] ASC),
    CONSTRAINT [FK_Budget_Project] FOREIGN KEY ([ProjectID]) 
        REFERENCES [dbo].[Project]([ProjectID]) ON DELETE CASCADE,
    CONSTRAINT [FK_Budget_CostCenter] FOREIGN KEY ([CostCenterID]) 
        REFERENCES [dbo].[CostCenter]([CostCenterID]) ON DELETE CASCADE,
    CONSTRAINT [CK_Budget_AllocatedAmount] CHECK ([AllocatedAmount] >= 0),
    CONSTRAINT [CK_Budget_DateRange] CHECK ([EndDate] >= [StartDate])
);
GO

-- Index for project-based budget lookup
CREATE NONCLUSTERED INDEX [IX_Budget_ProjectID]
    ON [dbo].[Budget]([ProjectID] ASC)
    INCLUDE ([BudgetName], [AllocatedAmount], [StartDate], [EndDate]);
GO

-- Index for cost center-based budget lookup
CREATE NONCLUSTERED INDEX [IX_Budget_CostCenterID]
    ON [dbo].[Budget]([CostCenterID] ASC)
    INCLUDE ([BudgetName], [AllocatedAmount], [StartDate], [EndDate]);
GO

-- Index for active budgets in date range
CREATE NONCLUSTERED INDEX [IX_Budget_DateRange_IsActive]
    ON [dbo].[Budget]([IsActive] ASC, [StartDate] ASC, [EndDate] ASC)
    INCLUDE ([BudgetID], [BudgetName], [AllocatedAmount]);
GO
