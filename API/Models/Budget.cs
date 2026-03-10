namespace BudgetManagement.Api.Models;

public class Budget
{
    public Guid ID { get; set; }
    public Guid ProjectID { get; set; }
    public Guid CostCenterID { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public decimal TotalAmount { get; set; }
    public string? Description { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string CreatedBy { get; set; } = string.Empty;
    public string? UpdatedBy { get; set; }
    
    // Navigation properties
    public Project? Project { get; set; }
    public CostCenter? CostCenter { get; set; }
    public List<BudgetCategory>? Categories { get; set; }
}

