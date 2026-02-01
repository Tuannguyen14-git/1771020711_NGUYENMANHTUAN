namespace Pcm.Api.DTOs;

public class DepositRequestDto
{
    public int MemberId { get; set; }
    public decimal Amount { get; set; }
    public string? Description { get; set; }
}
