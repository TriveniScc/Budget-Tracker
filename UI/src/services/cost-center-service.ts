import { apiClient } from './api-client';
import { CostCenter } from '../types/budget';

/**
 * Service for cost center-related API calls
 */
export const costCenterService = {
  /**
   * Get all active cost centers
   */
  getAllCostCenters: async (): Promise<CostCenter[]> => {
    return apiClient.get<CostCenter[]>('/costcenters');
  },

  /**
   * Get cost center by ID
   */
  getCostCenterById: async (id: string): Promise<CostCenter> => {
    return apiClient.get<CostCenter>(`/costcenters/${id}`);
  },
};
