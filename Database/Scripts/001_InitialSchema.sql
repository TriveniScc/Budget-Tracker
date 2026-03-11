-- Initial Database Schema for E-001: Budget Management
-- Creates all tables and stored procedures for budget management functionality
-- Date: 2026-03-10

PRINT 'Starting E-001 Budget Management Schema Creation...';
GO

-- =============================================
-- Step 1: Create Tables
-- =============================================

PRINT 'Creating Project table...';
:r ../Tables/Project.sql

PRINT 'Creating CostCenter table...';
:r ../Tables/CostCenter.sql

PRINT 'Creating Budget table...';
:r ../Tables/Budget.sql

PRINT 'Creating BudgetCategory table...';
:r ../Tables/BudgetCategory.sql

PRINT 'Creating Expense table...';
:r ../Tables/Expense.sql

-- =============================================
-- Step 2: Create Stored Procedures
-- =============================================

PRINT 'Creating stored procedures...';
:r ../StoredProcedures/usp_CreateBudget.sql
:r ../StoredProcedures/usp_GetBudgetById.sql
:r ../StoredProcedures/usp_CreateExpense.sql
:r ../StoredProcedures/usp_GetExpensesByBudgetCategoryId.sql
:r ../StoredProcedures/usp_GetBudgetSummary.sql
:r ../StoredProcedures/usp_DeleteExpense.sql

-- =============================================
-- Step 3: Insert Sample Data (Optional)
-- =============================================

PRINT 'Inserting sample data...';

-- Sample Projects
IF NOT EXISTS (SELECT 1 FROM [dbo].[Project])
BEGIN
    INSERT INTO [dbo].[Project] ([ID], [ProjectCode], [ProjectName], [Description], [IsActive])
    VALUES 
        (NEWID(), 'PRJ-001', 'Website Redesign', 'Complete redesign of company website', 1),
        (NEWID(), 'PRJ-002', 'Mobile App Development', 'New mobile application for iOS and Android', 1),
        (NEWID(), 'PRJ-003', 'Infrastructure Upgrade', 'Server and network infrastructure improvements', 1);
    
    PRINT '  - Inserted sample projects';
END

-- Sample Cost Centers
IF NOT EXISTS (SELECT 1 FROM [dbo].[CostCenter])
BEGIN
    INSERT INTO [dbo].[CostCenter] ([ID], [CostCenterCode], [CostCenterName], [Description], [IsActive])
    VALUES 
        (NEWID(), 'CC-IT', 'Information Technology', 'IT department cost center', 1),
        (NEWID(), 'CC-MKT', 'Marketing', 'Marketing department cost center', 1),
        (NEWID(), 'CC-OPS', 'Operations', 'Operations department cost center', 1);
    
    PRINT '  - Inserted sample cost centers';
END

PRINT 'E-001 Budget Management Schema Creation Completed Successfully!';
GO

GO
