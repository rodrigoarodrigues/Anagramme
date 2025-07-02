-- Anagramme Game Database Schema
-- This script creates the initial database schema for the Anagramme word game

USE master;
GO

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'AnagrammeDB')
BEGIN
    CREATE DATABASE AnagrammeDB;
END
GO

USE AnagrammeDB;
GO

-- Create Words table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Words]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Words] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Word] NVARCHAR(5) NOT NULL,
        [IsValid] BIT NOT NULL DEFAULT 1,
        [Difficulty] INT NOT NULL DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [UpdatedAt] DATETIME2 NULL
    );

    -- Create indexes for performance
    CREATE UNIQUE INDEX IX_Words_Word ON [dbo].[Words] ([Word]);
    CREATE INDEX IX_Words_IsValid ON [dbo].[Words] ([IsValid]);
    CREATE INDEX IX_Words_Difficulty ON [dbo].[Words] ([Difficulty]);
END
GO

-- Create GameSessions table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GameSessions]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GameSessions] (
        [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
        [SessionId] NVARCHAR(50) NOT NULL,
        [TargetWordId] INT NOT NULL,
        [StartTime] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [EndTime] DATETIME2 NULL,
        [IsCompleted] BIT NOT NULL DEFAULT 0,
        [IsWon] BIT NOT NULL DEFAULT 0,
        [GuessCount] INT NOT NULL DEFAULT 0,
        [PlayerIpAddress] NVARCHAR(45) NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        
        CONSTRAINT FK_GameSessions_Words FOREIGN KEY ([TargetWordId]) 
            REFERENCES [dbo].[Words]([Id])
    );

    -- Create indexes
    CREATE INDEX IX_GameSessions_SessionId ON [dbo].[GameSessions] ([SessionId]);
    CREATE INDEX IX_GameSessions_StartTime ON [dbo].[GameSessions] ([StartTime]);
    CREATE INDEX IX_GameSessions_IsCompleted ON [dbo].[GameSessions] ([IsCompleted]);
END
GO

-- Create GameGuesses table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GameGuesses]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GameGuesses] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [SessionId] UNIQUEIDENTIFIER NOT NULL,
        [GuessNumber] INT NOT NULL,
        [GuessWord] NVARCHAR(5) NOT NULL,
        [Result] NVARCHAR(15) NOT NULL, -- JSON array: ["correct","wrong_position","not_in_word"]
        [IsCorrect] BIT NOT NULL DEFAULT 0,
        [Timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
        
        CONSTRAINT FK_GameGuesses_GameSessions FOREIGN KEY ([SessionId]) 
            REFERENCES [dbo].[GameSessions]([Id]) ON DELETE CASCADE
    );

    -- Create indexes
    CREATE INDEX IX_GameGuesses_SessionId ON [dbo].[GameGuesses] ([SessionId]);
    CREATE INDEX IX_GameGuesses_GuessNumber ON [dbo].[GameGuesses] ([GuessNumber]);
    CREATE INDEX IX_GameGuesses_Timestamp ON [dbo].[GameGuesses] ([Timestamp]);
END
GO

-- Create DailyWords table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DailyWords]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[DailyWords] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Date] DATE NOT NULL,
        [WordId] INT NOT NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        
        CONSTRAINT FK_DailyWords_Words FOREIGN KEY ([WordId]) 
            REFERENCES [dbo].[Words]([Id])
    );

    -- Create unique constraint for date
    CREATE UNIQUE INDEX IX_DailyWords_Date ON [dbo].[DailyWords] ([Date]);
    CREATE INDEX IX_DailyWords_IsActive ON [dbo].[DailyWords] ([IsActive]);
END
GO

-- Create GameStatistics table (optional - for backend statistics tracking)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GameStatistics]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GameStatistics] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [PlayerId] NVARCHAR(100) NOT NULL, -- Could be IP address or session identifier
        [GamesPlayed] INT NOT NULL DEFAULT 0,
        [GamesWon] INT NOT NULL DEFAULT 0,
        [CurrentStreak] INT NOT NULL DEFAULT 0,
        [MaxStreak] INT NOT NULL DEFAULT 0,
        [GuessDistribution] NVARCHAR(50) NOT NULL DEFAULT '[0,0,0,0,0,0]', -- JSON array for guess distribution
        [LastPlayedDate] DATE NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETDATE()
    );

    -- Create indexes
    CREATE UNIQUE INDEX IX_GameStatistics_PlayerId ON [dbo].[GameStatistics] ([PlayerId]);
    CREATE INDEX IX_GameStatistics_LastPlayedDate ON [dbo].[GameStatistics] ([LastPlayedDate]);
END
GO

PRINT 'Database schema created successfully!';
GO
