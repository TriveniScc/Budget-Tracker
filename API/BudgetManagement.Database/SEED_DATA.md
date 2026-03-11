# Seed Data Documentation

## Overview

This document describes the comprehensive seed data that is automatically deployed with the BudgetManagement database schema. The seed data provides a realistic starting dataset for development, testing, and demonstrations.

## Seed Data Location

Seed data is defined in:
```
API/BudgetManagement.Database/Scripts/PostDeployment/Script.PostDeployment.sql
```

This script runs automatically after schema deployment and populates all tables with initial reference and sample data.

## Seeded Data Summary

### 1. Projects (5 Records)

Sample projects representing different organizational initiatives:

| Project Code | Project Name | Description | Start Date | End Date | Status |
|-------------|--------------|-------------|------------|----------|--------|
| PROJ-001 | Digital Transformation Initiative | Company-wide digital transformation project | 2024-01-01 | 2024-12-31 | Active |
| PROJ-002 | Cloud Migration | Migrate on-premise infrastructure to cloud | 2024-03-01 | 2024-09-30 | Active |
| PROJ-003 | Mobile App Development | Develop mobile application for customers | 2024-02-01 | 2024-08-31 | Active |
| PROJ-004 | Data Analytics Platform | Build enterprise data analytics platform | 2024-01-15 | 2024-12-31 | Active |
| PROJ-005 | Security Enhancement | Upgrade security infrastructure | 2024-04-01 | 2024-10-31 | Active |

### 2. Cost Centers (6 Records)

Departmental cost centers for budget allocation:

| Cost Center Code | Cost Center Name | Description | Status |
|-----------------|------------------|-------------|--------|
| CC-IT-001 | Information Technology | IT Department cost center | Active |
| CC-HR-001 | Human Resources | HR Department cost center | Active |
| CC-FIN-001 | Finance | Finance Department cost center | Active |
| CC-OPS-001 | Operations | Operations Department cost center | Active |
| CC-MKT-001 | Marketing | Marketing Department cost center | Active |
| CC-RD-001 | Research & Development | R&D Department cost center | Active |

### 3. Budgets (3 Records)

Quarterly and annual budgets linked to projects and cost centers:

| Budget Name | Project | Cost Center | Allocated Amount | Period | Status |
|-------------|---------|-------------|------------------|--------|--------|
| Q1 2024 IT Budget | PROJ-001 | CC-IT-001 | $500,000 | Q1 2024 | Active |
| Q2 2024 Cloud Migration | PROJ-002 | CC-IT-001 | $750,000 | Q2 2024 | Active |
| 2024 Mobile App Development | PROJ-003 | CC-MKT-001 | $300,000 | Feb-Aug 2024 | Active |

### 4. Budget Categories (10 Records)

Detailed categories within each budget:

#### Q1 2024 IT Budget Categories:
- **Hardware**: $150,000 - Hardware and equipment purchases
- **Software Licenses**: $200,000 - Software licenses and subscriptions
- **Consulting Services**: $100,000 - External consulting and professional services
- **Training**: $50,000 - Staff training and development

#### Q2 2024 Cloud Migration Categories:
- **Cloud Infrastructure**: $400,000 - Cloud hosting and infrastructure costs
- **Migration Tools**: $150,000 - Tools and software for migration
- **Professional Services**: $200,000 - Cloud migration consulting

#### 2024 Mobile App Development Categories:
- **Development**: $180,000 - App development costs
- **Design**: $60,000 - UI/UX design services
- **Testing**: $60,000 - QA and testing services

### 5. Expenses (25+ Records)

Realistic sample expenses across all budget categories with various statuses:

#### Expense Status Distribution:
- **Paid**: Expenses that have been fully processed and paid
- **Approved**: Expenses approved for payment but not yet paid
- **Pending**: Expenses awaiting approval

#### Sample Expenses by Category:

**Hardware Expenses:**
- Dell PowerEdge Server R750 - $45,000 (Paid)
- HP Workstations (10 units) - $32,500 (Approved)
- Network Switches and Routers - $18,750 (Pending)

**Software Licenses Expenses:**
- Microsoft 365 Enterprise Licenses (Annual) - $85,000 (Paid)
- Adobe Creative Cloud Enterprise - $42,000 (Paid)
- Atlassian Suite (Jira, Confluence) - $28,500 (Approved)
- GitHub Enterprise Subscription - $15,000 (Pending)

**Consulting Services Expenses:**
- IT Strategy Consultation (Q1) - $35,000 (Paid)
- Security Assessment and Audit - $42,000 (Approved)

**Training Expenses:**
- AWS Certification Training (5 employees) - $12,500 (Paid)
- Agile Scrum Master Workshop - $8,500 (Approved)
- Cybersecurity Awareness Training - $6,500 (Pending)

**Cloud Infrastructure Expenses:**
- AWS EC2 and S3 Services (Q2) - $125,000 (Approved)
- Azure Virtual Machines and Storage - $95,000 (Pending)

**Migration Tools Expenses:**
- CloudEndure Migration Tool - $45,000 (Approved)
- Terraform Enterprise License - $38,500 (Pending)

**Development Expenses:**
- Mobile Development Team (Month 1) - $55,000 (Paid)
- Mobile Development Team (Month 2) - $55,000 (Approved)
- Mobile Development Team (Month 3) - $55,000 (Pending)

**Design Expenses:**
- UI/UX Design - Initial Mockups - $22,000 (Paid)
- UI/UX Design - Final Designs - $18,500 (Approved)

## Data Characteristics

### Realistic Data
- **Vendor Names**: Real-world vendors (Microsoft, Dell, AWS, Adobe, etc.)
- **Invoice Numbers**: Sequential invoice numbering (INV-2024-XXX)
- **Amounts**: Realistic pricing for enterprise software and services
- **Dates**: Chronological dates spanning Q1-Q2 2024
- **Approvers**: Email addresses representing different roles

### Data Relationships
- All budgets linked to active projects and cost centers
- All categories properly allocated within budget amounts
- All expenses tracked against specific budget categories
- Foreign key relationships maintained throughout

### Variety for Testing
- Multiple expense statuses (Paid, Approved, Pending)
- Different expense amounts (from $6,500 to $125,000)
- Various vendors and invoice numbers
- Different approval patterns and dates
- Mix of one-time and recurring expenses

## Usage Scenarios

### Development
- Test API endpoints with realistic data
- Validate stored procedures with complete datasets
- Debug queries with representative data volumes

### Testing
- Integration testing with known data states
- UI testing with varied expense statuses
- Report testing with multiple budget periods

### Demonstrations
- Show budget vs. actual spending
- Demonstrate approval workflows
- Display spending trends and analytics

## Resetting Seed Data

To reset the database to initial seed data:

1. **Drop the database:**
   ```sql
   DROP DATABASE BudgetManagement;
   ```

2. **Redeploy the database project:**
   - Using Visual Studio: Right-click project → Publish
   - Using SqlPackage: See DEPLOYMENT_GUIDE.md

The post-deployment script will automatically repopulate all seed data.

## Customizing Seed Data

To modify or extend the seed data:

1. Edit the file:
   ```
   API/BudgetManagement.Database/Scripts/PostDeployment/Script.PostDeployment.sql
   ```

2. Modify the INSERT statements within each section

3. Rebuild and republish the database project

4. The modified seed data will be applied on next deployment

## Idempotent Seeding

The seed script is **idempotent** - it checks for existing data before inserting:

```sql
IF NOT EXISTS (SELECT 1 FROM [dbo].[Project])
BEGIN
    -- Insert seed data
END
```

This ensures:
- Safe to run multiple times
- Won't duplicate data on redeployment
- Preserves existing data if present

## Verification Queries

After deployment, verify seed data with these queries:

```sql
-- Check all tables are seeded
SELECT 'Projects' AS TableName, COUNT(*) AS RecordCount FROM [dbo].[Project]
UNION ALL
SELECT 'CostCenters', COUNT(*) FROM [dbo].[CostCenter]
UNION ALL
SELECT 'Budgets', COUNT(*) FROM [dbo].[Budget]
UNION ALL
SELECT 'BudgetCategories', COUNT(*) FROM [dbo].[BudgetCategory]
UNION ALL
SELECT 'Expenses', COUNT(*) FROM [dbo].[Expense];

-- Check expense status distribution
SELECT [Status], COUNT(*) AS Count, SUM([Amount]) AS TotalAmount
FROM [dbo].[Expense]
GROUP BY [Status]
ORDER BY [Status];

-- Check budget utilization
SELECT 
    b.[BudgetName],
    b.[AllocatedAmount],
    ISNULL(SUM(e.[Amount]), 0) AS SpentAmount,
    b.[AllocatedAmount] - ISNULL(SUM(e.[Amount]), 0) AS RemainingAmount
FROM [dbo].[Budget] b
LEFT JOIN [dbo].[BudgetCategory] bc ON b.[BudgetID] = bc.[BudgetID]
LEFT JOIN [dbo].[Expense] e ON bc.[BudgetCategoryID] = e.[BudgetCategoryID]
GROUP BY b.[BudgetName], b.[AllocatedAmount];
```

## Summary

The seed data provides:
- ✅ **5 Projects** across different business initiatives
- ✅ **6 Cost Centers** representing organizational departments
- ✅ **3 Budgets** with realistic quarterly and annual allocations
- ✅ **10 Budget Categories** with detailed spending categories
- ✅ **25+ Expenses** with varied statuses, vendors, and amounts
- ✅ **Complete Relationships** between all entities
- ✅ **Realistic Values** suitable for demos and testing
- ✅ **Idempotent Script** safe for multiple deployments

This comprehensive seed data enables immediate development and testing without manual data creation.
