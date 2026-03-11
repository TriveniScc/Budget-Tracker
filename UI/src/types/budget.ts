/**
 * Budget model matching API structure
 */
export interface Budget {
  id: string; // GUID
  projectID: string; // GUID
  costCenterID: string; // GUID
  name: string;
  startDate: string; // ISO date string
  endDate: string; // ISO date string
  totalAmount: number;
  createdAt?: string;
  updatedAt?: string;
}

/**
 * Budget Category model matching API structure
 */
export interface BudgetCategory {
  id: string; // GUID
  budgetID: string; // GUID
  categoryName: string;
  allocatedAmount: number;
  description?: string;
}

/**
 * Project model matching API structure
 */
export interface Project {
  id: string; // GUID
  projectCode: string;
  projectName: string;
  description?: string;
  isActive: boolean;
  createdAt?: string;
  updatedAt?: string;
}

  name: string;
  description?: string;
}

/**
 * Cost Center model
 */
export interface CostCenter {
  id: string; // GUID
  name: string;
  code: string;
  description?: string;
}

/**
 * Request model for creating a new budget
 */
export interface CreateBudgetRequest {
  projectID: string;
  costCenterID: string;
  name: string;
  startDate: string;
  endDate: string;
  totalAmount: number;
  categories: CreateBudgetCategoryRequest[];
}

/**
 * Request model for creating a budget category
 */
export interface CreateBudgetCategoryRequest {
  categoryName: string;
  allocatedAmount: number;
  description?: string;
}