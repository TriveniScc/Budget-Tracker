namespace BudgetManagement.Api.Models;

public class Expense
{
    public Guid ID { get; set; }
    public Guid BudgetCategoryID { get; set; }
    public decimal Amount { get; set; }
    public DateTime ExpenseDate { get; set; }
    public string? Description { get; set; }
    public string? Vendor { get; set; }
    public string? ReceiptNumber { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string CreatedBy { get; set; } = string.Empty;
    public string? UpdatedBy { get; set; }
    
    // Navigation properties
    public BudgetCategory? BudgetCategory { get; set; }
}

