-- Project Table
-- Stores project master data for budget allocation

CREATE TABLE [dbo].[Project] (
    [ProjectID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [ProjectCode] NVARCHAR(50) NOT NULL,
    [ProjectName] NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(MAX) NULL,
    [StartDate] DATE NULL,
    [EndDate] DATE NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [CreatedDate] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2(7) NULL,
    
    CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED ([ProjectID] ASC),
    CONSTRAINT [UQ_Project_ProjectCode] UNIQUE NONCLUSTERED ([ProjectCode] ASC)
);
GO

-- Index for active projects lookup
CREATE NONCLUSTERED INDEX [IX_Project_IsActive]
    ON [dbo].[Project]([IsActive] ASC)
    INCLUDE ([ProjectCode], [ProjectName]);
GO
