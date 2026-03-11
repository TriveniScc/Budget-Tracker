/*
Post-Deployment Script Template					
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.			
 Example:      :setvar TableName MyTable								
               SELECT * FROM [$(TableName)]							
--------------------------------------------------------------------------------------
*/

-- Insert reference data after database schema is created
-- This script runs after all tables and objects are created

PRINT 'Starting post-deployment data seeding...';
GO

-- Seed Project data
IF NOT EXISTS (SELECT 1 FROM [dbo].[Project])
BEGIN
    PRINT 'Seeding Project table...';
    
    INSERT INTO [dbo].[Project] ([ProjectCode], [ProjectName], [Description], [StartDate], [EndDate], [IsActive])
    VALUES 
        ('PROJ-001', 'Digital Transformation Initiative', 'Company-wide digital transformation project', '2024-01-01', '2024-12-31', 1),
        ('PROJ-002', 'Cloud Migration', 'Migrate on-premise infrastructure to cloud', '2024-03-01', '2024-09-30', 1),
        ('PROJ-003', 'Mobile App Development', 'Develop mobile application for customers', '2024-02-01', '2024-08-31', 1),
        ('PROJ-004', 'Data Analytics Platform', 'Build enterprise data analytics platform', '2024-01-15', '2024-12-31', 1),
        ('PROJ-005', 'Security Enhancement', 'Upgrade security infrastructure', '2024-04-01', '2024-10-31', 1);
    
    PRINT 'Project table seeded successfully.';
END
GO

-- Seed CostCenter data
IF NOT EXISTS (SELECT 1 FROM [dbo].[CostCenter])
BEGIN
    PRINT 'Seeding CostCenter table...';
    
    INSERT INTO [dbo].[CostCenter] ([CostCenterCode], [CostCenterName], [Description], [IsActive])
    VALUES 
        ('CC-IT-001', 'Information Technology', 'IT Department cost center', 1),
        ('CC-HR-001', 'Human Resources', 'HR Department cost center', 1),
        ('CC-FIN-001', 'Finance', 'Finance Department cost center', 1),
        ('CC-OPS-001', 'Operations', 'Operations Department cost center', 1),
        ('CC-MKT-001', 'Marketing', 'Marketing Department cost center', 1),
        ('CC-RD-001', 'Research & Development', 'R&D Department cost center', 1);
    
    PRINT 'CostCenter table seeded successfully.';
END
GO

-- Seed Budget data (sample budgets)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Budget])
BEGIN
    PRINT 'Seeding Budget table with sample data...';
    
    DECLARE @Project1ID INT, @Project2ID INT, @Project3ID INT;
    DECLARE @CostCenter1ID INT, @CostCenter2ID INT;
    
    SELECT @Project1ID = [ProjectID] FROM [dbo].[Project] WHERE [ProjectCode] = 'PROJ-001';
    SELECT @Project2ID = [ProjectID] FROM [dbo].[Project] WHERE [ProjectCode] = 'PROJ-002';
    SELECT @Project3ID = [ProjectID] FROM [dbo].[Project] WHERE [ProjectCode] = 'PROJ-003';
    SELECT @CostCenter1ID = [CostCenterID] FROM [dbo].[CostCenter] WHERE [CostCenterCode] = 'CC-IT-001';
    SELECT @CostCenter2ID = [CostCenterID] FROM [dbo].[CostCenter] WHERE [CostCenterCode] = 'CC-MKT-001';
    
    INSERT INTO [dbo].[Budget] ([BudgetName], [ProjectID], [CostCenterID], [AllocatedAmount], [StartDate], [EndDate], [Description], [IsActive])
    VALUES 
        ('Q1 2024 IT Budget', @Project1ID, @CostCenter1ID, 500000.00, '2024-01-01', '2024-03-31', 'First quarter IT budget for digital transformation', 1),
        ('Q2 2024 Cloud Migration', @Project2ID, @CostCenter1ID, 750000.00, '2024-04-01', '2024-06-30', 'Second quarter cloud migration budget', 1),
        ('2024 Mobile App Development', @Project3ID, @CostCenter2ID, 300000.00, '2024-02-01', '2024-08-31', 'Mobile app development budget', 1);
    
    PRINT 'Budget table seeded successfully.';
END
GO

-- Seed BudgetCategory data (sample categories)
IF NOT EXISTS (SELECT 1 FROM [dbo].[BudgetCategory])
BEGIN
    PRINT 'Seeding BudgetCategory table with sample data...';
    
    DECLARE @Budget1ID INT, @Budget2ID INT, @Budget3ID INT;
    
    SELECT TOP 1 @Budget1ID = [BudgetID] FROM [dbo].[Budget] WHERE [BudgetName] LIKE '%Q1 2024 IT Budget%';
    SELECT TOP 1 @Budget2ID = [BudgetID] FROM [dbo].[Budget] WHERE [BudgetName] LIKE '%Q2 2024 Cloud Migration%';
    SELECT TOP 1 @Budget3ID = [BudgetID] FROM [dbo].[Budget] WHERE [BudgetName] LIKE '%2024 Mobile App Development%';
    
    IF @Budget1ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[BudgetCategory] ([BudgetID], [CategoryName], [AllocatedAmount], [Description], [IsActive])
        VALUES 
            (@Budget1ID, 'Hardware', 150000.00, 'Hardware and equipment purchases', 1),
            (@Budget1ID, 'Software Licenses', 200000.00, 'Software licenses and subscriptions', 1),
            (@Budget1ID, 'Consulting Services', 100000.00, 'External consulting and professional services', 1),
            (@Budget1ID, 'Training', 50000.00, 'Staff training and development', 1);
    END
    
    IF @Budget2ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[BudgetCategory] ([BudgetID], [CategoryName], [AllocatedAmount], [Description], [IsActive])
        VALUES 
            (@Budget2ID, 'Cloud Infrastructure', 400000.00, 'Cloud hosting and infrastructure costs', 1),
            (@Budget2ID, 'Migration Tools', 150000.00, 'Tools and software for migration', 1),
            (@Budget2ID, 'Professional Services', 200000.00, 'Cloud migration consulting', 1);
    END
    
    IF @Budget3ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[BudgetCategory] ([BudgetID], [CategoryName], [AllocatedAmount], [Description], [IsActive])
        VALUES 
            (@Budget3ID, 'Development', 180000.00, 'App development costs', 1),
            (@Budget3ID, 'Design', 60000.00, 'UI/UX design services', 1),
            (@Budget3ID, 'Testing', 60000.00, 'QA and testing services', 1);
    END
    
    PRINT 'BudgetCategory table seeded successfully.';
END
GO
GO

-- Seed Expense data (sample expenses)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Expense])
BEGIN
    PRINT 'Seeding Expense table with sample data...';
    
    DECLARE @Cat1ID INT, @Cat2ID INT, @Cat3ID INT, @Cat4ID INT;
    DECLARE @Cat5ID INT, @Cat6ID INT, @Cat7ID INT, @Cat8ID INT;
    
    -- Get Budget Category IDs for Q1 2024 IT Budget
    SELECT TOP 1 @Cat1ID = [BudgetCategoryID] FROM [dbo].[BudgetCategory] WHERE [CategoryName] = 'Hardware';
    SELECT TOP 1 @Cat2ID = [BudgetCategoryID] FROM [dbo].[BudgetCategory] WHERE [CategoryName] = 'Software Licenses';
    SELECT TOP 1 @Cat3ID = [BudgetCategoryID] FROM [dbo].[BudgetCategory] WHERE [CategoryName] = 'Consulting Services';
    SELECT TOP 1 @Cat4ID = [BudgetCategoryID] FROM [dbo].[BudgetCategory] WHERE [CategoryName] = 'Training';
    
    -- Get Budget Category IDs for Q2 2024 Cloud Migration
    SELECT TOP 1 @Cat5ID = [BudgetCategoryID] FROM [dbo].[BudgetCategory] WHERE [CategoryName] = 'Cloud Infrastructure';
    SELECT TOP 1 @Cat6ID = [BudgetCategoryID] FROM [dbo].[BudgetCategory] WHERE [CategoryName] = 'Migration Tools';
    
    -- Get Budget Category IDs for Mobile App Development
    SELECT TOP 1 @Cat7ID = [BudgetCategoryID] FROM [dbo].[BudgetCategory] WHERE [CategoryName] = 'Development';
    SELECT TOP 1 @Cat8ID = [BudgetCategoryID] FROM [dbo].[BudgetCategory] WHERE [CategoryName] = 'Design';
    
    -- Insert sample expenses with various statuses
    IF @Cat1ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[Expense] ([BudgetCategoryID], [ExpenseDate], [Amount], [Description], [Vendor], [InvoiceNumber], [Status], [ApprovedBy], [ApprovedDate])
        VALUES 
            (@Cat1ID, '2024-01-15', 45000.00, 'Dell PowerEdge Server R750', 'Dell Technologies', 'INV-2024-001', 'Paid', 'john.manager@company.com', '2024-01-16'),
            (@Cat1ID, '2024-02-01', 32500.00, 'HP Workstations (10 units)', 'HP Inc.', 'INV-2024-045', 'Approved', 'john.manager@company.com', '2024-02-02'),
            (@Cat1ID, '2024-02-20', 18750.00, 'Network Switches and Routers', 'Cisco Systems', 'INV-2024-089', 'Pending', NULL, NULL);
    END
    
    IF @Cat2ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[Expense] ([BudgetCategoryID], [ExpenseDate], [Amount], [Description], [Vendor], [InvoiceNumber], [Status], [ApprovedBy], [ApprovedDate])
        VALUES 
            (@Cat2ID, '2024-01-05', 85000.00, 'Microsoft 365 Enterprise Licenses (Annual)', 'Microsoft Corporation', 'INV-2024-002', 'Paid', 'sarah.cto@company.com', '2024-01-06'),
            (@Cat2ID, '2024-01-20', 42000.00, 'Adobe Creative Cloud Enterprise', 'Adobe Inc.', 'INV-2024-023', 'Paid', 'sarah.cto@company.com', '2024-01-21'),
            (@Cat2ID, '2024-02-10', 28500.00, 'Atlassian Suite (Jira, Confluence)', 'Atlassian', 'INV-2024-067', 'Approved', 'sarah.cto@company.com', '2024-02-11'),
            (@Cat2ID, '2024-03-01', 15000.00, 'GitHub Enterprise Subscription', 'GitHub Inc.', 'INV-2024-112', 'Pending', NULL, NULL);
    END
    
    IF @Cat3ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[Expense] ([BudgetCategoryID], [ExpenseDate], [Amount], [Description], [Vendor], [InvoiceNumber], [Status], [ApprovedBy], [ApprovedDate])
        VALUES 
            (@Cat3ID, '2024-01-10', 35000.00, 'IT Strategy Consultation (Q1)', 'Accenture', 'INV-2024-008', 'Paid', 'john.manager@company.com', '2024-01-12'),
            (@Cat3ID, '2024-02-15', 42000.00, 'Security Assessment and Audit', 'Deloitte', 'INV-2024-078', 'Approved', 'john.manager@company.com', '2024-02-16');
    END
    
    IF @Cat4ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[Expense] ([BudgetCategoryID], [ExpenseDate], [Amount], [Description], [Vendor], [InvoiceNumber], [Status], [ApprovedBy], [ApprovedDate])
        VALUES 
            (@Cat4ID, '2024-01-25', 12500.00, 'AWS Certification Training (5 employees)', 'AWS Training', 'INV-2024-034', 'Paid', 'hr.training@company.com', '2024-01-26'),
            (@Cat4ID, '2024-02-28', 8500.00, 'Agile Scrum Master Workshop', 'Scrum Alliance', 'INV-2024-098', 'Approved', 'hr.training@company.com', '2024-03-01'),
            (@Cat4ID, '2024-03-15', 6500.00, 'Cybersecurity Awareness Training', 'KnowBe4', 'INV-2024-125', 'Pending', NULL, NULL);
    END
    
    IF @Cat5ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[Expense] ([BudgetCategoryID], [ExpenseDate], [Amount], [Description], [Vendor], [InvoiceNumber], [Status], [ApprovedBy], [ApprovedDate])
        VALUES 
            (@Cat5ID, '2024-04-05', 125000.00, 'AWS EC2 and S3 Services (Q2)', 'Amazon Web Services', 'INV-2024-201', 'Approved', 'cloud.admin@company.com', '2024-04-06'),
            (@Cat5ID, '2024-04-20', 95000.00, 'Azure Virtual Machines and Storage', 'Microsoft Azure', 'INV-2024-223', 'Pending', NULL, NULL);
    END
    
    IF @Cat6ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[Expense] ([BudgetCategoryID], [ExpenseDate], [Amount], [Description], [Vendor], [InvoiceNumber], [Status], [ApprovedBy], [ApprovedDate])
        VALUES 
            (@Cat6ID, '2024-04-10', 45000.00, 'CloudEndure Migration Tool', 'AWS Marketplace', 'INV-2024-215', 'Approved', 'cloud.admin@company.com', '2024-04-11'),
            (@Cat6ID, '2024-05-01', 38500.00, 'Terraform Enterprise License', 'HashiCorp', 'INV-2024-267', 'Pending', NULL, NULL);
    END
    
    IF @Cat7ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[Expense] ([BudgetCategoryID], [ExpenseDate], [Amount], [Description], [Vendor], [InvoiceNumber], [Status], [ApprovedBy], [ApprovedDate])
        VALUES 
            (@Cat7ID, '2024-02-15', 55000.00, 'Mobile Development Team (Month 1)', 'TechCorp Solutions', 'INV-2024-075', 'Paid', 'project.lead@company.com', '2024-02-16'),
            (@Cat7ID, '2024-03-15', 55000.00, 'Mobile Development Team (Month 2)', 'TechCorp Solutions', 'INV-2024-134', 'Approved', 'project.lead@company.com', '2024-03-16'),
            (@Cat7ID, '2024-04-15', 55000.00, 'Mobile Development Team (Month 3)', 'TechCorp Solutions', 'INV-2024-234', 'Pending', NULL, NULL);
    END
    
    IF @Cat8ID IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[Expense] ([BudgetCategoryID], [ExpenseDate], [Amount], [Description], [Vendor], [InvoiceNumber], [Status], [ApprovedBy], [ApprovedDate])
        VALUES 
            (@Cat8ID, '2024-02-20', 22000.00, 'UI/UX Design - Initial Mockups', 'DesignPro Agency', 'INV-2024-087', 'Paid', 'project.lead@company.com', '2024-02-21'),
            (@Cat8ID, '2024-03-25', 18500.00, 'UI/UX Design - Final Designs', 'DesignPro Agency', 'INV-2024-147', 'Approved', 'project.lead@company.com', '2024-03-26');
    END
    
    PRINT 'Expense table seeded successfully with ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' records.';
END
GO

PRINT 'Post-deployment script completed successfully!';
PRINT '';
PRINT '===================================================================';
PRINT 'DATABASE SEED DATA SUMMARY:';
PRINT '===================================================================';
PRINT 'Projects: 5 sample projects created';
PRINT 'Cost Centers: 6 department cost centers created';
PRINT 'Budgets: 3 quarterly/annual budgets created';
PRINT 'Budget Categories: 10 categories across all budgets';
PRINT 'Expenses: 25+ sample expenses with various statuses';
PRINT '';
PRINT 'Status Distribution:';
PRINT '  - Paid: Expenses that have been fully processed';
PRINT '  - Approved: Expenses approved but not yet paid';
PRINT '  - Pending: Expenses awaiting approval';
PRINT '';
PRINT 'Database is ready for development and testing!';
PRINT '===================================================================';
GO
