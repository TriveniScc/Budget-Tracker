import React, { useState } from 'react';
import { CreateExpenseRequest } from '../../types/expense';
import { expenseService } from '../../services/expense-service';
import './expense-form.css';

interface ExpenseFormProps {
  budgetCategoryID?: string;
  onSuccess?: () => void;
  onCancel?: () => void;
}

/**
 * Expense Recording Form Component
 * Epic: E-001-F-002 - Expense Recording
 * Story: E-001-F-002-S-001 - As an editor, I want to add expenses to categories
 */
export const ExpenseForm: React.FC<ExpenseFormProps> = ({
  budgetCategoryID,
  onSuccess,
  onCancel,
}) => {
  const [formData, setFormData] = useState<CreateExpenseRequest>({
    budgetCategoryID: budgetCategoryID || '',
    amount: 0,
    expenseDate: new Date().toISOString().split('T')[0],
    description: '',
    vendor: '',
  });

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: name === 'amount' ? parseFloat(value) || 0 : value,
    }));
  };

  const validateForm = (): boolean => {
    if (!formData.budgetCategoryID) {
      setError('Please select a budget category');
      return false;
    }

    if (!formData.description) {
      setError('Please enter a description');
      return false;
    }

    if (formData.amount <= 0) {
      setError('Amount must be greater than zero');
      return false;
    }

    if (!formData.expenseDate) {
      setError('Please select an expense date');
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
    setSuccess(null);

    try {
      await expenseService.createExpense(formData);

      setSuccess('Expense recorded successfully!');

      // Reset form
      setFormData({
        budgetCategoryID: budgetCategoryID || '',
        amount: 0,
        expenseDate: new Date().toISOString().split('T')[0],
        description: '',
        vendor: '',
      });

      if (onSuccess) {
        setTimeout(() => {
          onSuccess();
        }, 1500);
      }
    } catch (err) {
      setError('Failed to record expense. Please try again.');
      console.error('Expense creation error:', err);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="expense-form-container">
      <h2>Record Expense</h2>

      {error && <div className="error-message">{error}</div>}
      {success && <div className="success-message">{success}</div>}

      <form onSubmit={handleSubmit} className="expense-form">
        <div className="form-group">
          <label htmlFor="budgetCategoryID">Budget Category ID *</label>
          <input
            type="text"
            id="budgetCategoryID"
            name="budgetCategoryID"
            value={formData.budgetCategoryID}
            onChange={handleInputChange}
            required
            disabled={!!budgetCategoryID}
            placeholder="Category GUID"
          />
          {budgetCategoryID && (
            <small className="help-text">Category is pre-selected</small>
          )}
        </div>

        <div className="form-group">
          <label htmlFor="description">Description *</label>
          <textarea
            id="description"
            name="description"
            value={formData.description}
            onChange={handleInputChange}
            required
            rows={3}
            placeholder="e.g., Office supplies for Q1"
          />
        </div>

        <div className="form-row">
          <div className="form-group">
            <label htmlFor="amount">Amount *</label>
            <input
              type="number"
              id="amount"
              name="amount"
              value={formData.amount}
              onChange={handleInputChange}
              required
              min="0"
              step="0.01"
              placeholder="0.00"
            />
          </div>

          <div className="form-group">
            <label htmlFor="expenseDate">Expense Date *</label>
            <input
              type="date"
              id="expenseDate"
              name="expenseDate"
              value={formData.expenseDate}
              onChange={handleInputChange}
              required
            />
          </div>
        </div>

        <div className="form-group">
          <label htmlFor="vendor">Vendor (Optional)</label>
          <input
            type="text"
            id="vendor"
            name="vendor"
            value={formData.vendor}
            onChange={handleInputChange}
            placeholder="e.g., Amazon, Staples, etc."
          />
        </div>

        <div className="form-actions">
          {onCancel && (
            <button type="button" onClick={onCancel} className="btn-secondary">
              Cancel
            </button>
          )}
          <button type="submit" disabled={isSubmitting} className="btn-primary">
            {isSubmitting ? 'Recording...' : 'Record Expense'}
          </button>
        </div>
      </form>
    </div>
  );
};