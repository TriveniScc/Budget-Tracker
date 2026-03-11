# Budget Management Database Project

## Overview
Database schema and stored procedures for E-001: Budget Management epic.

## Structure

### Tables
- **Project.sql** - Project information for budget allocation
- **CostCenter.sql** - Cost center information for budget allocation
- **Budget.sql** - Main budget table with project, cost center, and date ranges
- **BudgetCategory.sql** - Spending categories within budgets
- **Expense.sql** - Expense tracking against budget categories

### Stored Procedures
- **usp_CreateBudget.sql** - Create a new budget with validation
- **usp_GetBudgetById.sql** - Retrieve budget with categories
- **usp_CreateExpense.sql** - Create expense and update category totals
- **usp_GetExpensesByBudgetCategoryId.sql** - Get expenses for a category
- **usp_GetBudgetSummary.sql** - Budget vs actual reporting
- **usp_DeleteExpense.sql** - Delete expense and update category totals

### Scripts
- **001_InitialSchema.sql** - Complete schema deployment script

## Deployment

### Using SQL Server Management Studio (SSMS)
1. Open SSMS and connect to your SQL Server instance
2. Create a new database: `CREATE DATABASE BudgetManagement;`
3. Open `Scripts/001_InitialSchema.sql`
4. Enable SQLCMD Mode: Query > SQLCMD Mode
5. Execute the script

### Using Command Line
```bash
sqlcmd -S localhost -d BudgetManagement -E -i "Scripts/001_InitialSchema.sql"
```

## Database Diagram

```
Project (1) ----< (M) Budget
CostCenter (1) ----< (M) Budget
Budget (1) ----< (M) BudgetCategory
BudgetCategory (1) ----< (M) Expense
```

## Key Features

### E-001-F-001: Budget Creation
- Define budgets with start/end dates
- Associate with projects and cost centers
- Create spending categories with allocated amounts
- Validation for date ranges and amounts

### E-001-F-002: Expense Recording
- Record expenses against budget categories
- Automatic update of spent amounts
- Track vendor and receipt information
- Date validation (no future dates)

## Business Rules

1. **Budget Validation**
   - End date must be after start date
   - Total amount must be greater than zero
   - Project and cost center must be active

2. **Expense Validation**
   - Amount must be greater than zero
   - Expense date cannot be in the future
   - Must be associated with a valid budget category

3. **Category Tracking**
   - SpentAmount automatically updated when expenses are added/deleted
   - Calculated fields: RemainingAmount, PercentageUsed

## Sample Data

The initial schema script includes sample data:
- 3 Projects (Website Redesign, Mobile App, Infrastructure)
- 3 Cost Centers (IT, Marketing, Operations)

## Connection String

```
Server=localhost;Database=BudgetManagement;Trusted_Connection=True;TrustServerCertificate=True;
```

## Notes

- All tables use IDENTITY for primary keys
- All datetime fields use DATETIME2(7) for precision
- Monetary values use DECIMAL(18, 2)
- Audit fields included: CreatedAt, UpdatedAt, CreatedBy, UpdatedBy
- Foreign keys use CASCADE delete where appropriate
- Indexes created for common query patterns
