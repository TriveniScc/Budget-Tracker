/**
 * Expense model matching API structure
 */
export interface Expense {
  id: string; // GUID
  budgetCategoryID: string; // GUID
  amount: number;
  expenseDate: string; // ISO date string
  description: string;
  vendor?: string;
  createdAt?: string;
  updatedAt?: string;
}

/**
 * Request model for creating a new expense
 */
export interface CreateExpenseRequest {
  budgetCategoryID: string;
  amount: number;
  expenseDate: string;
  description: string;
  vendor?: string;
}

/**
 * Expense summary by category
 */
export interface ExpenseSummary {
  categoryID: string;
  categoryName: string;
  totalExpenses: number;
  allocatedAmount: number;
  remainingAmount: number;
  percentageUsed: number;
}