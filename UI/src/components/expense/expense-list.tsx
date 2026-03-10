import React, { useEffect, useState } from 'react';
import { Expense } from '../../types/expense';
import { expenseService } from '../../services/expense-service';
import { format } from 'date-fns';
import './expense-list.css';

interface ExpenseListProps {
  categoryId?: string;
  onAddExpense?: () => void;
}

/**
 * Expense List Component
 * Displays expenses filtered by category
 */
export const ExpenseList: React.FC<ExpenseListProps> = ({ categoryId, onAddExpense }) => {
  const [expenses, setExpenses] = useState<Expense[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadExpenses();
  }, [categoryId]);

  const loadExpenses = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = categoryId
        ? await expenseService.getExpensesByCategory(categoryId)
        : await expenseService.getAllExpenses();
      setExpenses(data);
    } catch (err) {
      setError('Failed to load expenses');
      console.error('Error loading expenses:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!window.confirm('Are you sure you want to delete this expense?')) {
      return;
    }

    try {
      await expenseService.deleteExpense(id);
      setExpenses((prev) => prev.filter((exp) => exp.id !== id));
    } catch (err) {
      console.error('Error deleting expense:', err);
      alert('Failed to delete expense');
    }
  };

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

  const totalAmount = expenses.reduce((sum, exp) => sum + exp.amount, 0);

  if (loading) {
    return <div className="expense-list-loading">Loading expenses...</div>;
  }

  if (error) {
    return (
      <div className="expense-list-error">
        <p>{error}</p>
        <button onClick={loadExpenses} className="btn-retry">
          Retry
        </button>
      </div>
    );
  }

  return (
    <div className="expense-list-container">
      <div className="expense-list-header">
        <div>
          <h2>Expenses</h2>
          {expenses.length > 0 && (
            <p className="expense-count">
              {expenses.length} expense{expenses.length !== 1 ? 's' : ''} • Total: {formatCurrency(totalAmount)}
            </p>
          )}
        </div>
        {onAddExpense && (
          <button onClick={onAddExpense} className="btn-add">
            + Add Expense
          </button>
        )}
      </div>

      {expenses.length === 0 ? (
        <div className="empty-state">
          <p>No expenses recorded yet</p>
          {onAddExpense && (
            <button onClick={onAddExpense} className="btn-add-empty">
              Add First Expense
            </button>
          )}
        </div>
      ) : (
        <div className="expense-table">
          <div className="table-header">
            <div className="col-date">Date</div>
            <div className="col-description">Description</div>
            <div className="col-vendor">Vendor</div>
            <div className="col-amount">Amount</div>
            <div className="col-actions">Actions</div>
          </div>
          {expenses.map((expense) => (
            <div key={expense.id} className="table-row">
              <div className="col-date">{formatDate(expense.expenseDate)}</div>
              <div className="col-description">{expense.description}</div>
              <div className="col-vendor">{expense.vendor || '—'}</div>
              <div className="col-amount">{formatCurrency(expense.amount)}</div>
              <div className="col-actions">
                <button
                  onClick={() => handleDelete(expense.id)}
                  className="btn-delete"
                  aria-label="Delete expense"
                >
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};