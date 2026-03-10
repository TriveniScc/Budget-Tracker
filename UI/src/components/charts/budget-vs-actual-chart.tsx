import React, { useEffect, useState } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import { BudgetCategory } from '../../types/budget';
import { expenseService } from '../../services/expense-service';
import { ExpenseSummary } from '../../types/expense';
import './budget-vs-actual-chart.css';

interface BudgetVsActualChartProps {
  budgetId: string;
  categories: BudgetCategory[];
}

interface ChartData {
  categoryName: string;
  allocated: number;
  spent: number;
  remaining: number;
}

/**
 * Budget vs Actual Visualization Component
 * Epic: E-001 - Budget Management
 * Displays budget allocation vs actual spending by category using charts
 */
export const BudgetVsActualChart: React.FC<BudgetVsActualChartProps> = ({
  budgetId,
  categories,
}) => {
  const [chartData, setChartData] = useState<ChartData[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [summaries, setSummaries] = useState<ExpenseSummary[]>([]);

  useEffect(() => {
    loadExpenseData();
  }, [budgetId, categories]);

  const loadExpenseData = async () => {
    try {
      setLoading(true);
      setError(null);

      const expenseSummaries: ExpenseSummary[] = [];
      const data: ChartData[] = [];

      for (const category of categories) {
        try {
          const expenses = await expenseService.getExpensesByCategory(category.id);
          const totalSpent = expenses.reduce((sum, exp) => sum + exp.amount, 0);
          const remaining = category.allocatedAmount - totalSpent;
          const percentageUsed = category.allocatedAmount > 0
            ? (totalSpent / category.allocatedAmount) * 100
            : 0;

          expenseSummaries.push({
            categoryID: category.id,
            categoryName: category.categoryName,
            totalExpenses: totalSpent,
            allocatedAmount: category.allocatedAmount,
            remainingAmount: remaining,
            percentageUsed,
          });

          data.push({
            categoryName: category.categoryName,
            allocated: category.allocatedAmount,
            spent: totalSpent,
            remaining: Math.max(0, remaining),
          });
        } catch (err) {
          console.error(`Error loading expenses for category ${category.id}:`, err);
        }
      }

      setSummaries(expenseSummaries);
      setChartData(data);
    } catch (err) {
      setError('Failed to load expense data');
      console.error('Error loading expense data:', err);
    } finally {
      setLoading(false);
    }
  };

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(value);
  };

  const CustomTooltip = ({ active, payload }: any) => {
    if (active && payload && payload.length) {
      return (
        <div className="custom-tooltip">
          <p className="tooltip-label">{payload[0].payload.categoryName}</p>
          <p className="tooltip-allocated">
            Allocated: {formatCurrency(payload[0].payload.allocated)}
          </p>
          <p className="tooltip-spent">
            Spent: {formatCurrency(payload[0].payload.spent)}
          </p>
          <p className="tooltip-remaining">
            Remaining: {formatCurrency(payload[0].payload.remaining)}
          </p>
        </div>
      );
    }
    return null;
  };

  if (loading) {
    return <div className="chart-loading">Loading chart data...</div>;
  }

  if (error) {
    return (
      <div className="chart-error">
        <p>{error}</p>
        <button onClick={loadExpenseData} className="btn-retry">
          Retry
        </button>
      </div>
    );
  }

  const totalAllocated = summaries.reduce((sum, s) => sum + s.allocatedAmount, 0);
  const totalSpent = summaries.reduce((sum, s) => sum + s.totalExpenses, 0);
  const totalRemaining = totalAllocated - totalSpent;
  const overallPercentage = totalAllocated > 0 ? (totalSpent / totalAllocated) * 100 : 0;

  return (
    <div className="budget-vs-actual-container">
      <h2>Budget vs Actual Spending</h2>

      <div className="summary-cards">
        <div className="summary-card allocated">
          <div className="card-label">Total Allocated</div>
          <div className="card-value">{formatCurrency(totalAllocated)}</div>
        </div>
        <div className="summary-card spent">
          <div className="card-label">Total Spent</div>
          <div className="card-value">{formatCurrency(totalSpent)}</div>
          <div className="card-percentage">{overallPercentage.toFixed(1)}% of budget</div>
        </div>
        <div className={`summary-card remaining ${totalRemaining < 0 ? 'negative' : ''}`}>
          <div className="card-label">{totalRemaining >= 0 ? 'Remaining' : 'Over Budget'}</div>
          <div className="card-value">{formatCurrency(Math.abs(totalRemaining))}</div>
        </div>
      </div>

      <div className="chart-container">
        <ResponsiveContainer width="100%" height={400}>
          <BarChart data={chartData} margin={{ top: 20, right: 30, left: 20, bottom: 5 }}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="categoryName" />
            <YAxis tickFormatter={formatCurrency} />
            <Tooltip content={<CustomTooltip />} />
            <Legend />
            <Bar dataKey="allocated" fill="#3b82f6" name="Allocated" />
            <Bar dataKey="spent" fill="#ef4444" name="Spent" />
          </BarChart>
        </ResponsiveContainer>
      </div>

      <div className="category-details">
        <h3>Category Breakdown</h3>
        <div className="category-table">
          <div className="table-header">
            <div className="col-category">Category</div>
            <div className="col-allocated">Allocated</div>
            <div className="col-spent">Spent</div>
            <div className="col-remaining">Remaining</div>
            <div className="col-percentage">% Used</div>
          </div>
          {summaries.map((summary) => (
            <div key={summary.categoryID} className="table-row">
              <div className="col-category">{summary.categoryName}</div>
              <div className="col-allocated">{formatCurrency(summary.allocatedAmount)}</div>
              <div className="col-spent">{formatCurrency(summary.totalExpenses)}</div>
              <div className={`col-remaining ${summary.remainingAmount < 0 ? 'negative' : ''}`}>
                {formatCurrency(summary.remainingAmount)}
              </div>
              <div className="col-percentage">
                <div className="percentage-bar">
                  <div
                    className="percentage-fill"
                    style={{
                      width: `${Math.min(100, summary.percentageUsed)}%`,
                      backgroundColor: summary.percentageUsed > 100 ? '#dc2626' : '#10b981',
                    }}
                  />
                </div>
                <span>{summary.percentageUsed.toFixed(1)}%</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};