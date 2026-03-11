# Budget Management Database Project

SQL Server Database Project for Budget Management System.

## Overview

This is a SQL Server Database Project (SQLPROJ) that contains all database schema definitions, stored procedures, and migration scripts for the Budget Management API.

## Project Structure

```
BudgetManagement.Database/
├── Tables/                          # Table definitions
│   ├── Project.sql
│   ├── CostCenter.sql
│   ├── Budget.sql
│   ├── BudgetCategory.sql
│   └── Expense.sql
├── StoredProcedures/                # Stored procedures
│   ├── usp_CreateBudget.sql
│   ├── usp_GetBudgetById.sql
│   ├── usp_GetBudgetSummary.sql
│   ├── usp_CreateExpense.sql
│   ├── usp_DeleteExpense.sql
│   └── usp_GetExpensesByBudgetCategoryId.sql
├── Views/                           # Database views
├── Functions/                       # User-defined functions
├── Scripts/                         # Deployment scripts
│   ├── PreDeployment/
│   └── PostDeployment/
│       └── Script.PostDeployment.sql
└── BudgetManagement.Database.sqlproj
```

## Database Schema

### Tables

- **Project** - Project master data
- **CostCenter** - Cost center master data
- **Budget** - Main budget table with project, cost center, and date ranges
- **BudgetCategory** - Budget categories (subcategories of budgets)
- **Expense** - Individual expenses tracked against budget categories

### Stored Procedures

- **usp_CreateBudget** - Create a new budget
- **usp_GetBudgetById** - Retrieve budget by ID
- **usp_GetBudgetSummary** - Get budget summary with spending
- **usp_CreateExpense** - Create a new expense
- **usp_DeleteExpense** - Delete an expense
- **usp_GetExpensesByBudgetCategoryId** - Get expenses for a category

## Building and Deploying

### Using Visual Studio

1. Open `BudgetManagement.sln`
2. Right-click on `BudgetManagement.Database` project
3. Select **Publish**
4. Configure target database connection
5. Click **Publish**

### Using SQL Server Data Tools (SSDT)

```bash
# Build the project
msbuild BudgetManagement.Database.sqlproj /p:Configuration=Release

# Deploy using SqlPackage
SqlPackage.exe /Action:Publish /SourceFile:"bin\Release\BudgetManagement.Database.dacpac" /TargetConnectionString:"Server=localhost;Database=BudgetManagement;Integrated Security=true;"
```

### Using Command Line

```bash
# Generate DACPAC
dotnet build BudgetManagement.Database.sqlproj

# Publish DACPAC to target database
sqlpackage /Action:Publish /SourceFile:BudgetManagement.Database.dacpac /TargetServerName:localhost /TargetDatabaseName:BudgetManagement
```

## Connection Strings

### Development
```
Server=localhost;Database=BudgetManagement;Integrated Security=true;
```

### Production
```
Server=<server>;Database=BudgetManagement;User Id=<user>;Password=<password>;Encrypt=true;
```

## Schema Changes

All schema changes should be made in this project:

1. Add/modify SQL files in appropriate folders
2. Update `.sqlproj` file to include new files
3. Build project to validate changes
4. Deploy to target environment

## Migration Strategy

- **Pre-Deployment Scripts**: Run before schema deployment (data backup, etc.)
- **Schema Deployment**: Tables, procedures, functions created/updated
- **Post-Deployment Scripts**: Reference data, seed data

## Best Practices

- All tables use IDENTITY for primary keys
- Foreign key constraints are named explicitly
- All objects are in `dbo` schema
- Use stored procedures for complex operations
- Include appropriate indexes for performance
- Add audit columns (CreatedDate, ModifiedDate) where applicable

## Requirements

- SQL Server 2019 or later
- SQL Server Data Tools (SSDT)
- .NET SDK 8.0+
- Visual Studio 2022 (recommended)

## Related Projects

- **BudgetManagement.Api** - REST API project
- **UI** - React frontend application
