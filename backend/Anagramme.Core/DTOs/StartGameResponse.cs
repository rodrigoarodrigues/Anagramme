namespace Anagramme.Core.DTOs;

public class StartGameResponse
{
    public string SessionId { get; set; } = string.Empty;
    public DateTime StartTime { get; set; }
    public int MaxGuesses { get; set; } = 6;
    public int WordLength { get; set; } = 5;
    public string Message { get; set; } = "Game started successfully!";
}
