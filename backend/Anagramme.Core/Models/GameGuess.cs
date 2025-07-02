namespace Anagramme.Core.Models;

public class GameGuess
{
    public int Id { get; set; }
    public Guid SessionId { get; set; }
    public GameSession? Session { get; set; }
    public int GuessNumber { get; set; }
    public string GuessWord { get; set; } = string.Empty;
    public string Result { get; set; } = string.Empty; // JSON array of letter statuses
    public bool IsCorrect { get; set; } = false;
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}
