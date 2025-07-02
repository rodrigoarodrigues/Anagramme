using Microsoft.EntityFrameworkCore;
using Anagramme.Core.DTOs;
using Anagramme.Core.Interfaces;
using Anagramme.Core.Models;
using Anagramme.Infrastructure.Data;

namespace Anagramme.Infrastructure.Services;

public class GameService : IGameService
{
    private readonly AnagrammeDbContext _context;

    public GameService(AnagrammeDbContext context)
    {
        _context = context;
    }

    public async Task<StartGameResponse> StartNewGameAsync()
    {
        var word = await _context.Words.FirstOrDefaultAsync(w => w.IsValid);
        if (word == null)
        {
            return new StartGameResponse { Message = "No valid words available to start a game." };
        }

        var session = new GameSession
        {
            SessionId = Guid.NewGuid().ToString(),
            TargetWordId = word.Id,
            TargetWord = word,
        };

        _context.GameSessions.Add(session);
        await _context.SaveChangesAsync();

        return new StartGameResponse
        {
            SessionId = session.SessionId,
            StartTime = session.StartTime,
        };
    }

    public async Task<GameSession?> GetGameSessionAsync(string sessionId)
    {
        return await _context
            .GameSessions.Include(gs => gs.Guesses)
            .FirstOrDefaultAsync(gs => gs.SessionId == sessionId);
    }
}
