import { apiClient } from './api-client';
import { Expense, CreateExpenseRequest } from '../types/expense';

/**
 * Service for expense-related API calls
 */
export const expenseService = {
  /**
   * Get all expenses
   */
  getAllExpenses: async (): Promise<Expense[]> => {
    return apiClient.get<Expense[]>('/expenses');
  },

  /**
   * Get expense by ID
   */
  getExpenseById: async (id: string): Promise<Expense> => {
    return apiClient.get<Expense>(`/expenses/${id}`);
  },

  /**
   * Get expenses by category ID
   */
  getExpensesByCategory: async (categoryId: string): Promise<Expense[]> => {
    return apiClient.get<Expense[]>(`/expenses/category/${categoryId}`);
  },

  /**
   * Create a new expense
   */
  createExpense: async (expense: CreateExpenseRequest): Promise<Expense> => {
    return apiClient.post<Expense>('/expenses', expense);
  },

  /**
   * Update an existing expense
   */
  updateExpense: async (id: string, expense: Partial<Expense>): Promise<void> => {
    return apiClient.put<void>(`/expenses/${id}`, expense);
  },

  /**
   * Delete an expense
   */
  deleteExpense: async (id: string): Promise<void> => {
    return apiClient.delete<void>(`/expenses/${id}`);
  },
};