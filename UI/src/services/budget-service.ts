import { apiClient } from './api-client';
import { Budget, CreateBudgetRequest } from '../types/budget';

/**
 * Service for budget-related API calls
 */
export const budgetService = {
  /**
   * Get all budgets
   */
  getAllBudgets: async (): Promise<Budget[]> => {
    return apiClient.get<Budget[]>('/budgets');
  },

  /**
   * Get budget by ID
   */
  getBudgetById: async (id: string): Promise<Budget> => {
    return apiClient.get<Budget>(`/budgets/${id}`);
  },

  /**
   * Get budgets by project ID
   */
  getBudgetsByProject: async (projectId: string): Promise<Budget[]> => {
    return apiClient.get<Budget[]>(`/budgets/project/${projectId}`);
  },

  /**
   * Get budgets by cost center ID
   */
  getBudgetsByCostCenter: async (costCenterId: string): Promise<Budget[]> => {
    return apiClient.get<Budget[]>(`/budgets/costcenter/${costCenterId}`);
  },

  /**
   * Create a new budget
   */
  createBudget: async (budget: CreateBudgetRequest): Promise<Budget> => {
    return apiClient.post<Budget>('/budgets', budget);
  },

  /**
   * Update an existing budget
   */
  updateBudget: async (id: string, budget: Partial<Budget>): Promise<void> => {
    return apiClient.put<void>(`/budgets/${id}`, budget);
  },

  /**
   * Delete a budget
   */
  deleteBudget: async (id: string): Promise<void> => {
    return apiClient.delete<void>(`/budgets/${id}`);
  },
};