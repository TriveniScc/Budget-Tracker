# Budget Tracker - UI

Internal Budget & Cost Tracking Tool - React TypeScript Frontend

## Epic E-001: Budget Management

This UI application implements the Budget Management epic with the following features:

### Features Implemented

#### E-001-F-001: Budget Creation
- **Story**: As an editor, I want to create a budget with dates and categories
- **Components**: `BudgetForm`, `BudgetList`
- **Functionality**:
  - Create budgets with project ID, cost center ID, name, and date ranges
  - Add multiple budget categories with allocated amounts
  - Validation ensures category totals don't exceed budget amount
  - Real-time calculation of remaining budget

#### E-001-F-002: Expense Recording
- **Story**: As an editor, I want to add expenses to categories
- **Components**: `ExpenseForm`, `ExpenseList`
- **Functionality**:
  - Record expenses with amount, date, description, and optional vendor
  - Link expenses to specific budget categories
  - View all expenses with filtering options
  - Delete expenses when needed

#### Budget vs Actual Visualization
- **Component**: `BudgetVsActualChart`
- **Functionality**:
  - Interactive bar chart comparing allocated vs spent amounts by category
  - Overall budget summary with total allocated, spent, and remaining
  - Detailed category breakdown with percentage utilization
  - Color-coded indicators for over-budget categories

## Tech Stack

- **Framework**: React 18.2
- **Language**: TypeScript 5.3
- **Build Tool**: Vite 5.0
- **Charts**: Recharts 2.10
- **HTTP Client**: Axios 1.6
- **Date Utilities**: date-fns 3.0
- **Routing**: React Router DOM 6.20

## Project Structure

```
UI/
├── src/
│   ├── components/
│   │   ├── budget/
│   │   │   ├── budget-form.tsx         # Budget creation form
│   │   │   ├── budget-form.css
│   │   │   ├── budget-list.tsx         # Budget listing
│   │   │   └── budget-list.css
│   │   ├── expense/
│   │   │   ├── expense-form.tsx        # Expense recording form
│   │   │   ├── expense-form.css
│   │   │   ├── expense-list.tsx        # Expense listing
│   │   │   └── expense-list.css
│   │   └── charts/
│   │       ├── budget-vs-actual-chart.tsx  # Budget vs actual visualization
│   │       └── budget-vs-actual-chart.css
│   ├── services/
│   │   ├── api-client.ts               # Base API client with interceptors
│   │   ├── budget-service.ts           # Budget API calls
│   │   └── expense-service.ts          # Expense API calls
│   ├── types/
│   │   ├── budget.ts                   # Budget type definitions
│   │   └── expense.ts                  # Expense type definitions
│   ├── App.tsx                         # Main app component with routing
│   ├── App.css
│   ├── main.tsx                        # Application entry point
│   └── index.css                       # Global styles
├── package.json
├── tsconfig.json
├── vite.config.ts
└── README.md
```

## Getting Started

### Prerequisites

- Node.js 18.x or higher
- npm or yarn package manager
- Running Budget Tracker API (see ../API/README.md)

### Installation

1. Install dependencies:

```bash
cd UI
npm install
```

2. Configure environment:

```bash
cp .env.example .env
```

Edit `.env` and set your API URL:

```env
VITE_API_BASE_URL=https://localhost:5001/api
```

### Development

Start the development server:

```bash
npm run dev
```

The application will be available at `http://localhost:3000`

### Building for Production

Build the application:

```bash
npm run build
```

Preview the production build:

```bash
npm run preview
```

## API Integration

The UI connects to the Budget Tracker API with the following endpoints:

### Budget Endpoints

- `GET /api/budgets` - Get all budgets
- `GET /api/budgets/{id}` - Get budget by ID
- `GET /api/budgets/project/{projectId}` - Get budgets by project
- `GET /api/budgets/costcenter/{costCenterId}` - Get budgets by cost center
- `POST /api/budgets` - Create new budget
- `PUT /api/budgets/{id}` - Update budget
- `DELETE /api/budgets/{id}` - Delete budget

### Expense Endpoints

- `GET /api/expenses` - Get all expenses
- `GET /api/expenses/{id}` - Get expense by ID
- `GET /api/expenses/category/{categoryId}` - Get expenses by category
- `POST /api/expenses` - Create new expense
- `PUT /api/expenses/{id}` - Update expense
- `DELETE /api/expenses/{id}` - Delete expense

## Component Usage

### Creating a Budget

```tsx
import { BudgetForm } from './components/budget/budget-form';

<BudgetForm
  onSuccess={() => console.log('Budget created!')}
  onCancel={() => console.log('Cancelled')}
/>
```

### Recording an Expense

```tsx
import { ExpenseForm } from './components/expense/expense-form';

<ExpenseForm
  budgetCategoryID="category-guid"
  onSuccess={() => console.log('Expense recorded!')}
/>
```

### Displaying Budget vs Actual Chart

```tsx
import { BudgetVsActualChart } from './components/charts/budget-vs-actual-chart';

<BudgetVsActualChart
  budgetId="budget-guid"
  categories={budgetCategories}
/>
```

## UI Standards

This project follows the UI naming conventions:

- **Files/Folders**: kebab-case (e.g., `budget-form.tsx`)
- **Components**: PascalCase (e.g., `BudgetForm`)
- **Functions/Variables**: camelCase (e.g., `handleSubmit`)
- **Constants**: UPPER_CASE (e.g., `API_BASE_URL`)
- **CSS Classes**: kebab-case (e.g., `.budget-form-container`)

## Features

### Form Validation

- Required field validation
- Date range validation (end date must be after start date)
- Amount validation (must be greater than zero)
- Budget total validation (categories can't exceed total amount)

### Responsive Design

- Mobile-friendly layouts
- Responsive grid systems
- Touch-friendly interactions
- Adaptive navigation

### Accessibility

- Semantic HTML
- ARIA labels where appropriate
- Keyboard navigation support
- Focus visible indicators
- Screen reader friendly

### Error Handling

- User-friendly error messages
- API error handling
- Loading states
- Retry mechanisms

## Testing

Run tests:

```bash
npm test
```

Run tests with coverage:

```bash
npm test -- --coverage
```

## Linting

Run ESLint:

```bash
npm run lint
```

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Future Enhancements

- User authentication and authorization
- Role-based access control (Epic E-003)
- Advanced filtering and search
- CSV export functionality (Epic E-002-F-002)
- Real-time budget updates
- Audit history tracking (Epic E-003-F-002)
- Budget templates
- Multi-currency support

## Contributing

Please follow the established coding standards and UI conventions when contributing to this project.

## License

Internal use only - TriveniScc Organization