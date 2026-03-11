import React, { useState, useEffect } from 'react';
import { CreateBudgetRequest, CreateBudgetCategoryRequest, Project } from '../../types/budget';
import { budgetService } from '../../services/budget-service';
import { projectService } from '../../services/project-service';
import './budget-form.css';


interface BudgetFormProps {
  onSuccess?: () => void;
  onCancel?: () => void;
}

/**
 * Budget Creation Form Component
 * Epic: E-001-F-001 - Budget Creation
 * Story: E-001-F-001-S-001 - As an editor, I want to create a budget with dates and categories
 */
export const BudgetForm: React.FC<BudgetFormProps> = ({ onSuccess, onCancel }) => {
  const [formData, setFormData] = useState({
    name: '',
    projectID: '',
    costCenterID: '',
    startDate: '',
    endDate: '',
    totalAmount: 0,
  });

  const [categories, setCategories] = useState<CreateBudgetCategoryRequest[]>([
    { categoryName: '', allocatedAmount: 0, description: '' },
  ]);

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [projects, setProjects] = useState<Project[]>([]);
  const [loadingProjects, setLoadingProjects] = useState(true);

  // Fetch projects on component mount
  useEffect(() => {
    const fetchProjects = async () => {
      try {
        setLoadingProjects(true);
        const projectList = await projectService.getAllProjects();
        // Filter only active projects
        const activeProjects = projectList.filter(p => p.isActive);
        setProjects(activeProjects);
      } catch (err) {
        console.error('Failed to fetch projects:', err);
        setError('Failed to load projects. Please refresh the page.');
      } finally {
        setLoadingProjects(false);
      }
    };

    fetchProjects();
  }, []);



  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: name === 'totalAmount' ? parseFloat(value) || 0 : value,
    }));
  };

  const handleCategoryChange = (
    index: number,
    field: keyof CreateBudgetCategoryRequest,
    value: string | number
  ) => {
    setCategories((prev) => {
      const updated = [...prev];
      updated[index] = {
        ...updated[index],
        [field]: field === 'allocatedAmount' ? parseFloat(value as string) || 0 : value,
      };
      return updated;
    });
  };
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: name === 'totalAmount' ? parseFloat(value) || 0 : value,
    }));
  };


  const removeCategory = (index: number) => {
    if (categories.length > 1) {
      setCategories((prev) => prev.filter((_, i) => i !== index));
    }
  };

  const validateForm = (): boolean => {
    if (!formData.name || !formData.projectID || !formData.costCenterID) {
      setError('Please fill in all required fields');
      return false;
    }

    if (!formData.startDate || !formData.endDate) {
      setError('Please select start and end dates');
      return false;
    }

    if (new Date(formData.startDate) >= new Date(formData.endDate)) {
      setError('End date must be after start date');
      return false;
    }

    if (formData.totalAmount <= 0) {
      setError('Total amount must be greater than zero');
      return false;
    }

    const totalCategoryAmount = categories.reduce(
      (sum, cat) => sum + cat.allocatedAmount,
      0
    );

    if (totalCategoryAmount > formData.totalAmount) {
      setError('Total category allocation exceeds budget total amount');
      return false;
    }

    const hasEmptyCategory = categories.some(
      (cat) => !cat.categoryName || cat.allocatedAmount <= 0
    );

    if (hasEmptyCategory) {
      setError('All categories must have a name and amount greater than zero');
      return false;
    }

    setError(null);
    return true;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!validateForm()) {
      return;
    }

    setIsSubmitting(true);
    setError(null);

    try {
      const budgetRequest: CreateBudgetRequest = {
        ...formData,
        categories,
      };

      await budgetService.createBudget(budgetRequest);
      
      // Reset form
      setFormData({
        name: '',
        projectID: '',
        costCenterID: '',
        startDate: '',
        endDate: '',
        totalAmount: 0,
      });
      setCategories([{ categoryName: '', allocatedAmount: 0, description: '' }]);

      if (onSuccess) {
        onSuccess();
      }
    } catch (err) {
      setError('Failed to create budget. Please try again.');
      console.error('Budget creation error:', err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const totalCategoryAmount = categories.reduce(
    (sum, cat) => sum + cat.allocatedAmount,
    0
  );

  return (
    <div className="budget-form-container">
      <h2>Create New Budget</h2>
      
      {error && <div className="error-message">{error}</div>}

      <form onSubmit={handleSubmit} className="budget-form">
        <div className="form-section">
          <h3>Budget Information</h3>
          
          <div className="form-group">
            <label htmlFor="name">Budget Name *</label>
            <input
              type="text"
              id="name"
              name="name"
              value={formData.name}
              onChange={handleInputChange}
              required
              placeholder="e.g., Q1 2024 Marketing Budget"
            />
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="projectID">Project ID *</label>
              <input
                type="text"
                id="projectID"
                name="projectID"
                value={formData.projectID}
                onChange={handleInputChange}
                required
                placeholder="Project GUID"
              />
            </div>

            <div className="form-group">
              <label htmlFor="costCenterID">Cost Center ID *</label>
              <input
                type="text"
                id="costCenterID"
                name="costCenterID"
                value={formData.costCenterID}
                onChange={handleInputChange}
                required
                placeholder="Cost Center GUID"
          <div className="form-row">
            <div className="form-group">
              <label htmlFor="projectID">Project *</label>
              <select
                id="projectID"
                name="projectID"
                value={formData.projectID}
                onChange={handleInputChange}
                required
                disabled={loadingProjects}
              >
                <option value="">
                  {loadingProjects ? 'Loading projects...' : 'Select a project'}
                </option>
                {projects.map((project) => (
                  <option key={project.id} value={project.id}>
                    {project.projectName} ({project.projectCode})
                  </option>
                ))}
              </select>
            </div>

                required
              />
            </div>

            <div className="form-group">
              <label htmlFor="endDate">End Date *</label>
              <input
                type="date"
                id="endDate"
                name="endDate"
                value={formData.endDate}
                onChange={handleInputChange}
                required
              />
            </div>
          </div>

          <div className="form-group">
            <label htmlFor="totalAmount">Total Budget Amount *</label>
            <input
              type="number"
              id="totalAmount"
              name="totalAmount"
              value={formData.totalAmount}
              onChange={handleInputChange}
              required
              min="0"
              step="0.01"
              placeholder="0.00"
            />
          </div>
        </div>

        <div className="form-section">
          <div className="section-header">
            <h3>Budget Categories</h3>
            <button type="button" onClick={addCategory} className="btn-add-category">
              + Add Category
            </button>
          </div>

          {categories.map((category, index) => (
            <div key={index} className="category-item">
              <div className="category-header">
                <h4>Category {index + 1}</h4>
                {categories.length > 1 && (
                  <button
                    type="button"
                    onClick={() => removeCategory(index)}
                    className="btn-remove"
                    aria-label="Remove category"
                  >
                    ×
                  </button>
                )}
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label htmlFor={`category-name-${index}`}>Category Name *</label>
                  <input
                    type="text"
                    id={`category-name-${index}`}
                    value={category.categoryName}
                    onChange={(e) =>
                      handleCategoryChange(index, 'categoryName', e.target.value)
                    }
                    required
                    placeholder="e.g., Travel, Software, Marketing"
                  />
                </div>

                <div className="form-group">
                  <label htmlFor={`category-amount-${index}`}>Allocated Amount *</label>
                  <input
                    type="number"
                    id={`category-amount-${index}`}
                    value={category.allocatedAmount}
                    onChange={(e) =>
                      handleCategoryChange(index, 'allocatedAmount', e.target.value)
                    }
                    required
                    min="0"
                    step="0.01"
                    placeholder="0.00"
                  />
                </div>
              </div>

              <div className="form-group">
                <label htmlFor={`category-desc-${index}`}>Description</label>
                <input
                  type="text"
                  id={`category-desc-${index}`}
                  value={category.description || ''}
                  onChange={(e) =>
                    handleCategoryChange(index, 'description', e.target.value)
                  }
                  placeholder="Optional category description"
                />
              </div>
            </div>
          ))}

          <div className="category-summary">
            <div className="summary-row">
              <span>Total Allocated:</span>
              <span className="amount">${totalCategoryAmount.toFixed(2)}</span>
            </div>
            <div className="summary-row">
              <span>Budget Total:</span>
              <span className="amount">${formData.totalAmount.toFixed(2)}</span>
            </div>
            <div className="summary-row">
              <span>Remaining:</span>
              <span className={`amount ${formData.totalAmount - totalCategoryAmount < 0 ? 'negative' : ''}`}>
                ${(formData.totalAmount - totalCategoryAmount).toFixed(2)}
              </span>
            </div>
          </div>
        </div>

        <div className="form-actions">
          {onCancel && (
            <button type="button" onClick={onCancel} className="btn-secondary">
              Cancel
            </button>
          )}
          <button type="submit" disabled={isSubmitting} className="btn-primary">
            {isSubmitting ? 'Creating...' : 'Create Budget'}
          </button>
        </div>
      </form>
    </div>
  );
};