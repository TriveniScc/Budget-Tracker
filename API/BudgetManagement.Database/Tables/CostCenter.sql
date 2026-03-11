-- CostCenter Table
-- Stores cost center master data for budget tracking

CREATE TABLE [dbo].[CostCenter] (
    [CostCenterID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [CostCenterCode] NVARCHAR(50) NOT NULL,
    [CostCenterName] NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(MAX) NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [CreatedDate] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2(7) NULL,
    
    CONSTRAINT [PK_CostCenter] PRIMARY KEY CLUSTERED ([CostCenterID] ASC),
    CONSTRAINT [UQ_CostCenter_CostCenterCode] UNIQUE NONCLUSTERED ([CostCenterCode] ASC)
);
GO

-- Index for active cost centers lookup
CREATE NONCLUSTERED INDEX [IX_CostCenter_IsActive]
    ON [dbo].[CostCenter]([IsActive] ASC)
    INCLUDE ([CostCenterCode], [CostCenterName]);
GO
