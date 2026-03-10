-- Budget Table
-- Stores budget information with project, cost center, and date ranges
-- E-001-F-001: Budget Creation

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Budget]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Budget] (
        [ID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        [ProjectID] UNIQUEIDENTIFIER NOT NULL,
        [CostCenterID] UNIQUEIDENTIFIER NOT NULL,
        [StartDate] DATETIME2(7) NOT NULL,
        [EndDate] DATETIME2(7) NOT NULL,
        [TotalAmount] DECIMAL(18, 2) NOT NULL,
        [Description] NVARCHAR(MAX) NULL,
        [CreatedAt] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2(7) NULL,
        [CreatedBy] NVARCHAR(100) NOT NULL,
        [UpdatedBy] NVARCHAR(100) NULL,
        CONSTRAINT [PK_Budget] PRIMARY KEY CLUSTERED ([ID] ASC),
        CONSTRAINT [FK_Budget_Project] FOREIGN KEY ([ProjectID]) REFERENCES [dbo].[Project]([ID]),
        CONSTRAINT [FK_Budget_CostCenter] FOREIGN KEY ([CostCenterID]) REFERENCES [dbo].[CostCenter]([ID]),
        CONSTRAINT [CK_Budget_DateRange] CHECK ([EndDate] > [StartDate]),
        CONSTRAINT [CK_Budget_TotalAmount] CHECK ([TotalAmount] > 0)
    );

    CREATE NONCLUSTERED INDEX [IX_Budget_ProjectId] ON [dbo].[Budget] ([ProjectID]);
    CREATE NONCLUSTERED INDEX [IX_Budget_CostCenterId] ON [dbo].[Budget] ([CostCenterID]);
    CREATE NONCLUSTERED INDEX [IX_Budget_DateRange] ON [dbo].[Budget] ([StartDate], [EndDate]);
    CREATE NONCLUSTERED INDEX [IX_Budget_CreatedAt] ON [dbo].[Budget] ([CreatedAt] DESC);
END
GO

    CREATE NONCLUSTERED INDEX [IX_Budget_CreatedAt] ON [dbo].[Budget] ([CreatedAt] DESC);
END
GO
