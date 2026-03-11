import { apiClient } from './api-client';
import { Project } from '../types/budget';

/**
 * Service for project-related API calls
 */
export const projectService = {
  /**
   * Get all active projects
   */
  getAllProjects: async (): Promise<Project[]> => {
    return apiClient.get<Project[]>('/projects');
  },

  /**
   * Get project by ID
   */
  getProjectById: async (id: string): Promise<Project> => {
    return apiClient.get<Project>(`/projects/${id}`);
  },
};
