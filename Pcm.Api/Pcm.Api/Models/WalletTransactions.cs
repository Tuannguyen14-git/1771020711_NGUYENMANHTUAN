using Pcm.Api.Enums;

namespace Pcm.Api.Models;

public class _177_WalletTransactions
{
    public int Id { get; set; }

    public int MemberId { get; set; }
    public decimal Amount { get; set; }

    public WalletTransactionType Type { get; set; }
    public WalletTransactionStatus Status { get; set; }

    public string? RelatedId { get; set; }
    public string? Description { get; set; }
    public DateTime CreatedDate { get; set; }
}

