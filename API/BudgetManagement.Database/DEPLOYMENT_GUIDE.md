# Database Deployment Guide

## Overview

This guide explains how to deploy the BudgetManagement.Database SQL Server Database Project.

## Prerequisites

- SQL Server 2019 or later (or Azure SQL Database)
- SQL Server Data Tools (SSDT) or Visual Studio 2022
- .NET SDK 8.0 or later
- SqlPackage CLI tool (optional, for command-line deployment)

## Deployment Methods

### Method 1: Visual Studio (Recommended for Development)

1. **Open Solution**
   - Open `BudgetManagement.sln` in Visual Studio 2022
   - The database project should appear in Solution Explorer

2. **Build the Project**
   - Right-click on `BudgetManagement.Database` project
   - Select **Build**
   - Ensure no build errors

3. **Configure Publish Profile**
   - Right-click on `BudgetManagement.Database` project
   - Select **Publish**
   - Click **Edit** to configure connection
   - Enter your SQL Server connection details:
     - **Server Name**: `localhost` or your SQL Server instance
     - **Authentication**: Windows or SQL Server Authentication
     - **Database Name**: `BudgetManagement`

4. **Publish Database**
   - Review the changes in the preview
   - Click **Publish**
   - Monitor the deployment progress
   - Verify success in the Data Tools Operations window

### Method 2: SqlPackage Command Line

#### Step 1: Build DACPAC

```bash
cd API/BudgetManagement.Database
msbuild BudgetManagement.Database.sqlproj /p:Configuration=Release
```

This creates: `bin/Release/BudgetManagement.Database.dacpac`

#### Step 2: Deploy DACPAC

**Windows Authentication:**
```powershell
SqlPackage.exe /Action:Publish `
  /SourceFile:"bin\Release\BudgetManagement.Database.dacpac" `
  /TargetServerName:"localhost" `
  /TargetDatabaseName:"BudgetManagement" `
  /TargetTrustServerCertificate:True
```

**SQL Server Authentication:**
```powershell
SqlPackage.exe /Action:Publish `
  /SourceFile:"bin\Release\BudgetManagement.Database.dacpac" `
  /TargetServerName:"localhost" `
  /TargetDatabaseName:"BudgetManagement" `
  /TargetUser:"sa" `
  /TargetPassword:"YourPassword" `
  /TargetTrustServerCertificate:True
```

### Method 3: Azure SQL Database

```bash
SqlPackage.exe /Action:Publish `
  /SourceFile:"bin\Release\BudgetManagement.Database.dacpac" `
  /TargetServerName:"your-server.database.windows.net" `
  /TargetDatabaseName:"BudgetManagement" `
  /TargetUser:"your-admin-user" `
  /TargetPassword:"your-password" `
  /TargetEncryptConnection:True
```

### Method 4: Docker SQL Server

#### Start SQL Server Container

```bash
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourStrong@Passw0rd" `
  -p 1433:1433 --name sql-server `
  -d mcr.microsoft.com/mssql/server:2022-latest
```

#### Deploy Database

```bash
SqlPackage.exe /Action:Publish `
  /SourceFile:"bin\Release\BudgetManagement.Database.dacpac" `
  /TargetServerName:"localhost,1433" `
  /TargetDatabaseName:"BudgetManagement" `
  /TargetUser:"sa" `
  /TargetPassword:"YourStrong@Passw0rd" `
  /TargetTrustServerCertificate:True
```

## Post-Deployment Verification

### Verify Tables Created

```sql
USE BudgetManagement;
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
```

Expected tables:
- Budget
- BudgetCategory
- CostCenter
- Expense
- Project

### Verify Stored Procedures Created

```sql
SELECT 
    ROUTINE_SCHEMA,
    ROUTINE_NAME,
    ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
ORDER BY ROUTINE_NAME;
```

Expected procedures:
- usp_CreateBudget
- usp_CreateExpense
- usp_DeleteExpense
- usp_GetBudgetById
- usp_GetBudgetSummary
- usp_GetExpensesByBudgetCategoryId

### Verify Seed Data

```sql
-- Check Projects
SELECT COUNT(*) AS ProjectCount FROM [dbo].[Project];

-- Check Cost Centers
SELECT COUNT(*) AS CostCenterCount FROM [dbo].[CostCenter];

-- Check Budgets
SELECT COUNT(*) AS BudgetCount FROM [dbo].[Budget];

-- Check Budget Categories
SELECT COUNT(*) AS CategoryCount FROM [dbo].[BudgetCategory];
```

## Connection String Configuration

### Update API appsettings.json

```json
{
  "ConnectionStrings": {
    "BudgetManagementDb": "Server=localhost;Database=BudgetManagement;Integrated Security=true;TrustServerCertificate=true;"
  }
}
```

### For Azure SQL Database

```json
{
  "ConnectionStrings": {
    "BudgetManagementDb": "Server=tcp:your-server.database.windows.net,1433;Initial Catalog=BudgetManagement;Persist Security Info=False;User ID=your-user;Password=your-password;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}
```

### For Docker SQL Server

```json
{
  "ConnectionStrings": {
    "BudgetManagementDb": "Server=localhost,1433;Database=BudgetManagement;User ID=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=true;"
  }
}
```

## Troubleshooting

### Error: "Database already exists"

**Solution:** The DACPAC will update the existing database. If you want a fresh start:

```sql
USE master;
GO
DROP DATABASE IF EXISTS BudgetManagement;
GO
```

### Error: "Cannot find SqlPackage.exe"

**Solution:** Install SqlPackage:

```bash
# Windows (via winget)
winget install Microsoft.SqlPackage

# Or download from:
# https://aka.ms/sqlpackage-windows
```

### Error: "Login failed for user"

**Solution:** 
- Verify SQL Server is running
- Check username and password
- Ensure SQL Server Authentication is enabled (if using SQL auth)
- Check firewall rules (especially for Azure SQL)

### Error: "Build failed"

**Solution:**
- Check for syntax errors in SQL files
- Ensure all referenced files exist
- Verify .sqlproj file is valid XML
- Clean and rebuild: `msbuild /t:Clean,Build`

## CI/CD Integration

### Azure DevOps Pipeline

```yaml
- task: VSBuild@1
  displayName: 'Build Database Project'
  inputs:
    solution: 'API/BudgetManagement.Database/BudgetManagement.Database.sqlproj'
    configuration: 'Release'

- task: SqlAzureDacpacDeployment@1
  displayName: 'Deploy to Azure SQL'
  inputs:
    azureSubscription: 'your-subscription'
    ServerName: 'your-server.database.windows.net'
    DatabaseName: 'BudgetManagement'
    SqlUsername: '$(SqlUser)'
    SqlPassword: '$(SqlPassword)'
    DacpacFile: 'API/BudgetManagement.Database/bin/Release/BudgetManagement.Database.dacpac'
```

### GitHub Actions

```yaml
- name: Build Database Project
  run: |
    msbuild API/BudgetManagement.Database/BudgetManagement.Database.sqlproj /p:Configuration=Release

- name: Deploy to SQL Server
  run: |
    SqlPackage /Action:Publish /SourceFile:"API/BudgetManagement.Database/bin/Release/BudgetManagement.Database.dacpac" /TargetServerName:"${{ secrets.SQL_SERVER }}" /TargetDatabaseName:"BudgetManagement" /TargetUser:"${{ secrets.SQL_USER }}" /TargetPassword:"${{ secrets.SQL_PASSWORD }}"
```

## Schema Changes and Updates

### Making Schema Changes

1. Modify SQL files in the project (Tables, StoredProcedures, etc.)
2. Build the project to validate changes
3. Use Schema Compare to review differences
4. Publish to apply changes

### Schema Compare

In Visual Studio:
1. Right-click database project → **Schema Compare**
2. Set Source: Database Project
3. Set Target: Your database
4. Click **Compare**
5. Review differences
6. Click **Update** to apply

## Best Practices

1. **Always backup** production databases before deployment
2. **Test deployments** in dev/staging environments first
3. **Use Schema Compare** to review changes before publishing
4. **Version control** all database objects
5. **Use transactions** in scripts where appropriate
6. **Document breaking changes** in release notes
7. **Plan for rollback** - keep previous DACPAC versions

## Support

For issues or questions:
- Check project README.md
- Review SQL Server error logs
- Contact database team
