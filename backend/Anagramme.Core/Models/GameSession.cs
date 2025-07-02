namespace Anagramme.Core.Models;

public class GameSession
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string SessionId { get; set; } = string.Empty;
    public int TargetWordId { get; set; }
    public Word? TargetWord { get; set; }
    public DateTime StartTime { get; set; } = DateTime.UtcNow;
    public DateTime? EndTime { get; set; }
    public bool IsCompleted { get; set; } = false;
    public bool IsWon { get; set; } = false;
    public int GuessCount { get; set; } = 0;
    public List<GameGuess> Guesses { get; set; } = new();
}
