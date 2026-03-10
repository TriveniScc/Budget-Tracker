# Budget Management API

## Overview
.NET 10 Web API for E-001: Budget Management epic.

## Features

### E-001-F-001: Budget Creation
- Create budgets with project, cost center, start/end dates
- Define spending categories with allocated amounts
- Associate budgets with projects and cost centers

### E-001-F-002: Expense Recording
- Record expenses against budget categories
- Track vendor and receipt information
- Automatic update of category spent amounts

## Technology Stack

- **.NET 10** - Latest .NET framework
- **ASP.NET Core Web API** - REST API framework
- **Dapper** - Lightweight ORM for database access
- **SQL Server** - Database backend
- **Swagger/OpenAPI** - API documentation

## Project Structure

```
API/
├── Controllers/           # API endpoints
│   ├── BudgetsController.cs
│   └── ExpensesController.cs
├── Models/               # Domain entities
│   ├── Budget.cs
│   ├── BudgetCategory.cs
│   ├── CostCenter.cs
│   ├── Expense.cs
│   └── Project.cs
├── Services/             # Business logic layer
│   ├── IBudgetService.cs
│   ├── BudgetService.cs
│   ├── IExpenseService.cs
│   └── ExpenseService.cs
├── Repositories/         # Data access layer
│   ├── IBudgetRepository.cs
│   ├── BudgetRepository.cs
│   ├── IExpenseRepository.cs
│   └── ExpenseRepository.cs
├── Program.cs            # Application entry point
├── appsettings.json      # Configuration
└── BudgetManagement.Api.csproj
```

## Getting Started

### Prerequisites

- .NET 10 SDK or later
- SQL Server 2019 or later (or SQL Server Express)
- Visual Studio 2022+ or VS Code

### Database Setup

1. Create the database:
   ```sql
   CREATE DATABASE BudgetManagement;
   ```

2. Run the database scripts from the `Database` folder:
   ```bash
   sqlcmd -S localhost -d BudgetManagement -E -i "../Database/Scripts/001_InitialSchema.sql"
   ```

3. Update connection string in `appsettings.json` or `appsettings.Development.json`:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=localhost;Database=BudgetManagement;Trusted_Connection=True;TrustServerCertificate=True;"
   }
   ```

### Running the API

#### Using .NET CLI
```bash
cd API
dotnet restore
dotnet build
dotnet run
```

#### Using Visual Studio
1. Open `BudgetManagement.Api.csproj`
2. Press F5 to run with debugging

The API will be available at:
- HTTPS: `https://localhost:5001`
- HTTP: `http://localhost:5000`
- Swagger UI: `https://localhost:5001/swagger`

## API Endpoints

### Budgets

- **GET** `/api/budgets` - Get all budgets
- **GET** `/api/budgets/{id}` - Get budget by ID
- **POST** `/api/budgets` - Create new budget
- **PUT** `/api/budgets/{id}` - Update budget
- **DELETE** `/api/budgets/{id}` - Delete budget

### Expenses

- **GET** `/api/expenses` - Get all expenses
- **GET** `/api/expenses/{id}` - Get expense by ID
- **GET** `/api/expenses/by-category/{categoryId}` - Get expenses by category
- **POST** `/api/expenses` - Create new expense
- **PUT** `/api/expenses/{id}` - Update expense
- **DELETE** `/api/expenses/{id}` - Delete expense

## Example Requests

### Create Budget

```http
POST /api/budgets
Content-Type: application/json

{
  "projectId": 1,
  "costCenterId": 1,
  "startDate": "2026-01-01T00:00:00",
  "endDate": "2026-12-31T23:59:59",
  "totalAmount": 100000.00,
  "description": "Annual IT Budget 2026",
  "createdBy": "john.doe@company.com"
}
```

### Create Expense

```http
POST /api/expenses
Content-Type: application/json

{
  "budgetCategoryId": 1,
  "amount": 1500.00,
  "expenseDate": "2026-03-10T00:00:00",
  "description": "Software licenses",
  "vendor": "Microsoft",
  "receiptNumber": "INV-2026-001",
  "createdBy": "jane.smith@company.com"
}
```

## Architecture

### Layered Architecture

```
┌─────────────────────────────────┐
│       Controllers Layer         │  ← HTTP Endpoints
├─────────────────────────────────┤
│       Services Layer            │  ← Business Logic
├─────────────────────────────────┤
│       Repository Layer          │  ← Data Access
├─────────────────────────────────┤
│       Database (SQL Server)     │  ← Data Storage
└─────────────────────────────────┘
```

### Design Patterns

- **Repository Pattern** - Data access abstraction
- **Dependency Injection** - Loose coupling and testability
- **Service Layer** - Business logic separation
- **Async/Await** - Asynchronous programming for scalability

## Configuration

### appsettings.json

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=BudgetManagement;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

## Development

### Adding New Endpoints

1. Create/update model in `Models/`
2. Create repository interface and implementation in `Repositories/`
3. Create service interface and implementation in `Services/`
4. Create controller in `Controllers/`
5. Register dependencies in `Program.cs`

### Testing

Use Swagger UI at `/swagger` to test API endpoints interactively.

### Code Standards

- **Naming Conventions**: PascalCase for classes, methods, properties
- **Async Methods**: Suffix with "Async"
- **Interfaces**: Prefix with "I"
- **Error Handling**: Try-catch in controllers, custom exceptions in services
- **Logging**: Use ILogger for all logging

## Security Considerations

- [ ] Add authentication (JWT/OAuth)
- [ ] Add authorization (role-based access control)
- [ ] Input validation
- [ ] SQL injection protection (using parameterized queries)
- [ ] CORS configuration
- [ ] Rate limiting

## Future Enhancements

- [ ] Add Entity Framework Core for ORM
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Add health checks
- [ ] Add API versioning
- [ ] Add response caching
- [ ] Add pagination for list endpoints
- [ ] Add filtering and sorting
- [ ] Add Docker support

## Support

For issues or questions, please refer to the project documentation or contact the development team.

## License

Internal use only.
