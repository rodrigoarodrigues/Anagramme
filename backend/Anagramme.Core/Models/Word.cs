namespace Anagramme.Core.Models;

public class Word
{
    public int Id { get; set; }
    public string WordText { get; set; } = string.Empty;
    public bool IsValid { get; set; } = true;
    public int Difficulty { get; set; } = 1;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
