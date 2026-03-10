namespace BudgetManagement.Api.Models;

public class BudgetCategory
{
    public Guid ID { get; set; }
    public Guid BudgetID { get; set; }
    public string CategoryName { get; set; } = string.Empty;
    public decimal AllocatedAmount { get; set; }
    public decimal SpentAmount { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    
    // Navigation properties
    public Budget? Budget { get; set; }
    public List<Expense>? Expenses { get; set; }
    
    // Calculated properties
    public decimal RemainingAmount => AllocatedAmount - SpentAmount;
    public decimal PercentageUsed => AllocatedAmount > 0 ? (SpentAmount / AllocatedAmount) * 100 : 0;
}

}
