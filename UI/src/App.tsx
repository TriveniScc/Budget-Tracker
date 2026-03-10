import React, { useState } from 'react';
import { BudgetList } from './components/budget/budget-list';
import { BudgetForm } from './components/budget/budget-form';
import { ExpenseForm } from './components/expense/expense-form';
import { ExpenseList } from './components/expense/expense-list';
import { BudgetVsActualChart } from './components/charts/budget-vs-actual-chart';
import { Budget, BudgetCategory } from './types/budget';
import './App.css';

type View = 'list' | 'create-budget' | 'add-expense' | 'view-budget';

/**
 * Main App Component
 * Epic E-001: Budget Management
 * Provides navigation between budget creation, expense recording, and visualization
 */
function App() {
  const [currentView, setCurrentView] = useState<View>('list');
  const [selectedBudget, setSelectedBudget] = useState<Budget | null>(null);
  const [categories] = useState<BudgetCategory[]>([]); // Would be loaded from selected budget

  const handleBudgetCreated = () => {
    setCurrentView('list');
  };

  const handleExpenseCreated = () => {
    setCurrentView('list');
  };

  const handleSelectBudget = (budget: Budget) => {
    setSelectedBudget(budget);
    setCurrentView('view-budget');
  };

  const renderContent = () => {
    switch (currentView) {
      case 'create-budget':
        return (
          <BudgetForm
            onSuccess={handleBudgetCreated}
            onCancel={() => setCurrentView('list')}
          />
        );

      case 'add-expense':
        return (
          <ExpenseForm
            onSuccess={handleExpenseCreated}
            onCancel={() => setCurrentView('list')}
          />
        );

      case 'view-budget':
        return selectedBudget ? (
          <div className="budget-detail-view">
            <div className="detail-header">
              <button onClick={() => setCurrentView('list')} className="btn-back">
                ← Back to Budgets
              </button>
              <h1>{selectedBudget.name}</h1>
            </div>
            <BudgetVsActualChart budgetId={selectedBudget.id} categories={categories} />
            <div className="expense-section">
              <ExpenseList onAddExpense={() => setCurrentView('add-expense')} />
            </div>
          </div>
        ) : null;

      case 'list':
      default:
        return (
          <BudgetList
            onSelectBudget={handleSelectBudget}
            onCreateNew={() => setCurrentView('create-budget')}
          />
        );
    }
  };

  return (
    <div className="app">
      <header className="app-header">
        <div className="header-content">
          <h1 className="app-title">Budget Tracker</h1>
          <p className="app-subtitle">Internal Budget & Cost Tracking Tool</p>
        </div>
        <nav className="app-nav">
          <button
            onClick={() => setCurrentView('list')}
            className={currentView === 'list' ? 'active' : ''}
          >
            Budgets
          </button>
          <button
            onClick={() => setCurrentView('create-budget')}
            className={currentView === 'create-budget' ? 'active' : ''}
          >
            Create Budget
          </button>
          <button
            onClick={() => setCurrentView('add-expense')}
            className={currentView === 'add-expense' ? 'active' : ''}
          >
            Add Expense
          </button>
        </nav>
      </header>

      <main className="app-main">{renderContent()}</main>

      <footer className="app-footer">
        <p>Budget Tracker © 2024 • Epic E-001: Budget Management</p>
      </footer>
    </div>
  );
}

export default App;