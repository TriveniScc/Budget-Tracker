import React, { useEffect, useState } from 'react';
import { Budget } from '../../types/budget';
import { budgetService } from '../../services/budget-service';
import { format } from 'date-fns';
import './budget-list.css';

interface BudgetListProps {
  onSelectBudget?: (budget: Budget) => void;
  onCreateNew?: () => void;
}

/**
 * Budget List Component
 * Displays all budgets with filtering options
 */
export const BudgetList: React.FC<BudgetListProps> = ({ onSelectBudget, onCreateNew }) => {
  const [budgets, setBudgets] = useState<Budget[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    loadBudgets();
  }, []);

  const loadBudgets = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await budgetService.getAllBudgets();
      setBudgets(data);
    } catch (err) {
      setError('Failed to load budgets');
      console.error('Error loading budgets:', err);
    } finally {
      setLoading(false);
    }
  };

  const filteredBudgets = budgets.filter((budget) =>
    budget.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const formatDate = (dateString: string) => {
    try {
      return format(new Date(dateString), 'MMM dd, yyyy');
    } catch {
      return dateString;
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  if (loading) {
    return <div className="budget-list-loading">Loading budgets...</div>;
  }

  if (error) {
    return (
      <div className="budget-list-error">
        <p>{error}</p>
        <button onClick={loadBudgets} className="btn-retry">
          Retry
        </button>
      </div>
    );
  }

  return (
    <div className="budget-list-container">
      <div className="budget-list-header">
        <h2>Budgets</h2>
        {onCreateNew && (
          <button onClick={onCreateNew} className="btn-create">
            + Create New Budget
          </button>
        )}
      </div>

      <div className="search-bar">
        <input
          type="text"
          placeholder="Search budgets by name..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="search-input"
        />
      </div>

      {filteredBudgets.length === 0 ? (
        <div className="empty-state">
          <p>No budgets found</p>
          {searchTerm && <p className="empty-hint">Try adjusting your search</p>}
        </div>
      ) : (
        <div className="budget-grid">
          {filteredBudgets.map((budget) => (
            <div
              key={budget.id}
              className="budget-card"
              onClick={() => onSelectBudget && onSelectBudget(budget)}
            >
              <div className="budget-card-header">
                <h3>{budget.name}</h3>
              </div>
              <div className="budget-card-body">
                <div className="budget-info-row">
                  <span className="label">Period:</span>
                  <span className="value">
                    {formatDate(budget.startDate)} - {formatDate(budget.endDate)}
                  </span>
                </div>
                <div className="budget-info-row">
                  <span className="label">Total Amount:</span>
                  <span className="value amount">{formatCurrency(budget.totalAmount)}</span>
                </div>
                <div className="budget-info-row">
                  <span className="label">Project ID:</span>
                  <span className="value id">{budget.projectID.substring(0, 8)}...</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};