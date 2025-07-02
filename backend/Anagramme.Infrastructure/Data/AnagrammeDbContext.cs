using Microsoft.EntityFrameworkCore;
using Anagramme.Core.Models;

namespace Anagramme.Infrastructure.Data;

public class AnagrammeDbContext : DbContext
{
    public AnagrammeDbContext(DbContextOptions<AnagrammeDbContext> options) : base(options)
    {
    }

    public DbSet<Word> Words { get; set; }
    public DbSet<GameSession> GameSessions { get; set; }
    public DbSet<GameGuess> GameGuesses { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Word configuration
        modelBuilder.Entity<Word>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.WordText)
                .IsRequired()
                .HasMaxLength(5);
            entity.HasIndex(e => e.WordText)
                .IsUnique();
            entity.HasIndex(e => e.IsValid);
        });

        // GameSession configuration
        modelBuilder.Entity<GameSession>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.SessionId)
                .IsRequired()
                .HasMaxLength(50);
            entity.HasIndex(e => e.SessionId);
            
            // Relationship with Word
            entity.HasOne(e => e.TargetWord)
                .WithMany()
                .HasForeignKey(e => e.TargetWordId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // GameGuess configuration
        modelBuilder.Entity<GameGuess>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.GuessWord)
                .IsRequired()
                .HasMaxLength(5);
            entity.Property(e => e.Result)
                .IsRequired()
                .HasMaxLength(15);
            
            // Relationship with GameSession
            entity.HasOne(e => e.Session)
                .WithMany(gs => gs.Guesses)
                .HasForeignKey(e => e.SessionId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}
