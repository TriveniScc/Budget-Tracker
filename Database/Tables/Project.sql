-- Project Table
-- Stores project information for budget allocation

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Project]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Project] (
        [ID] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        [ProjectCode] NVARCHAR(50) NOT NULL,
        [ProjectName] NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(MAX) NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedAt] DATETIME2(7) NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED ([ID] ASC),
        CONSTRAINT [UK_Project_ProjectCode] UNIQUE NONCLUSTERED ([ProjectCode] ASC)
    );

    CREATE NONCLUSTERED INDEX [IX_Project_IsActive] ON [dbo].[Project] ([IsActive]);
    CREATE NONCLUSTERED INDEX [IX_Project_ProjectCode] ON [dbo].[Project] ([ProjectCode]);
END
GO
