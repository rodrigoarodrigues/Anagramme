using Anagramme.Core.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Anagramme.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class GameController : ControllerBase
{
    private readonly IGameService _gameService;
    private readonly ILogger<GameController> _logger;

    public GameController(IGameService gameService, ILogger<GameController> logger)
    {
        _gameService = gameService;
        _logger = logger;
    }

    /// <summary>
    /// Start a new game session
    /// </summary>
    /// <returns>Game session details</returns>
    [HttpPost("start")]
    public async Task<IActionResult> StartGame()
    {
        try
        {
            _logger.LogInformation("Starting new game");

            var result = await _gameService.StartNewGameAsync();

            _logger.LogInformation("Game started with session ID: {SessionId}", result.SessionId);

            return Ok(result);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error starting game");
            return StatusCode(500, new { message = "An error occurred while starting the game" });
        }
    }

    /// <summary>
    /// Get game session status
    /// </summary>
    /// <param name="sessionId">The game session ID</param>
    /// <returns>Game session details</returns>
    [HttpGet("{sessionId}")]
    public async Task<IActionResult> GetGameSession(string sessionId)
    {
        try
        {
            _logger.LogInformation("Getting game session: {SessionId}", sessionId);

            var session = await _gameService.GetGameSessionAsync(sessionId);

            if (session == null)
            {
                return NotFound(new { message = "Game session not found" });
            }

            return Ok(session);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting game session: {SessionId}", sessionId);
            return StatusCode(
                500,
                new { message = "An error occurred while retrieving the game session" }
            );
        }
    }
}
