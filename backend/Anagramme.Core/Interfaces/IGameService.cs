using Anagramme.Core.DTOs;
using Anagramme.Core.Models;

namespace Anagramme.Core.Interfaces;

public interface IGameService
{
    Task<StartGameResponse> StartNewGameAsync();
    Task<GameSession?> GetGameSessionAsync(string sessionId);
}
