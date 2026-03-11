-- CostCenter Table
-- Stores cost center information for budget allocation

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CostCenter]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[CostCenter] (
        [ID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        [CostCenterCode] NVARCHAR(50) NOT NULL,
        [CostCenterName] NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(MAX) NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedAt] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_CostCenter] PRIMARY KEY CLUSTERED ([ID] ASC),
        CONSTRAINT [UK_CostCenter_CostCenterCode] UNIQUE NONCLUSTERED ([CostCenterCode] ASC)
    );

    CREATE NONCLUSTERED INDEX [IX_CostCenter_IsActive] ON [dbo].[CostCenter] ([IsActive]);
    CREATE NONCLUSTERED INDEX [IX_CostCenter_CostCenterCode] ON [dbo].[CostCenter] ([CostCenterCode]);
END
GO
