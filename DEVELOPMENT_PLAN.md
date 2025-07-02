# Anagramme Clone - Development Plan

## Project Overview

A Brazilian Wordle clone called "Anagramme" using .NET 9, React with TypeScript (Vite), Docker, and SQL Server.

**Anagramme** is a Brazilian word-guessing game where players have 6 attempts to guess a 5-letter Portuguese word, with color-coded feedback after each guess.

## Tech Stack

- **Backend**: .NET 9 Web API
- **Frontend**: React with TypeScript (Vite)
- **Database**: SQL Server
- **Containerization**: Docker & Docker Compose
- **Word Data**: Brazilian Portuguese dictionary

---

## Project Structure

```folder
termo-game/
├── backend/
│   ├── Anagramme.API/              # Web API project
│   ├── Anagramme.Core/             # Domain models, interfaces
│   ├── Anagramme.Infrastructure/   # Data access, external services
│   └── Anagramme.Tests/            # Unit tests
├── frontend/                   # React + TypeScript (Vite)
├── database/
│   ├── scripts/               # SQL scripts
│   └── seed-data/             # Word data files
├── docker-compose.yml         # Container orchestration
└── DEVELOPMENT_PLAN.md        # This file
```

---

## Phase 1: Project Setup & Infrastructure ✅

### 1.1 Project Structure Setup ✅

- [x] Created .NET solution with proper architecture
- [x] Set up React app with Vite and TypeScript
- [x] Configured project references

### 1.2 Development Environment (Next Steps)

- [ ] Set up Docker Desktop
- [ ] Create Docker Compose configuration
- [ ] Set up SQL Server container
- [ ] Configure development certificates

---

## Phase 2: Database Design & Word Population

### 2.1 Database Schema

```sql
-- Core tables needed
Words (
    Id INT IDENTITY PRIMARY KEY,
    Word NVARCHAR(5) NOT NULL,
    IsValid BIT DEFAULT 1,
    Difficulty INT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETDATE(),
    INDEX IX_Words_Word (Word),
    INDEX IX_Words_IsValid (IsValid)
)

GameSessions (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    SessionId NVARCHAR(50) NOT NULL,
    TargetWordId INT FOREIGN KEY REFERENCES Words(Id),
    StartTime DATETIME2 DEFAULT GETDATE(),
    EndTime DATETIME2 NULL,
    IsCompleted BIT DEFAULT 0,
    IsWon BIT DEFAULT 0,
    GuessCount INT DEFAULT 0
)

GameGuesses (
    Id INT IDENTITY PRIMARY KEY,
    SessionId UNIQUEIDENTIFIER FOREIGN KEY REFERENCES GameSessions(Id),
    GuessNumber INT NOT NULL,
    GuessWord NVARCHAR(5) NOT NULL,
    Result NVARCHAR(15) NOT NULL, -- JSON: ["correct","wrong_position","not_in_word"]
    Timestamp DATETIME2 DEFAULT GETDATE()
)

DailyWords (
    Id INT IDENTITY PRIMARY KEY,
    Date DATE NOT NULL UNIQUE,
    WordId INT FOREIGN KEY REFERENCES Words(Id),
    IsActive BIT DEFAULT 1
)
```

### 2.2 Word Data Population Strategy

**Data Sources for Brazilian Portuguese words:**

- **Primary**: Portuguese word lists from open sources
- **NLTK Portuguese corpus** - Natural Language Toolkit
- **OpenTaal Brazilian Portuguese word list**
- **Custom web scraping** (if needed)

**Filtering Criteria:**

- Exactly 5 letters
- No proper nouns
- No words with special characters (ç, ã, etc. - need to decide)
- Common Brazilian Portuguese words
- Remove offensive words

**Implementation Steps:**

1. Download Portuguese word corpus
2. Filter for 5-letter words
3. Manual curation for game-appropriate words
4. Difficulty scoring based on letter frequency
5. Daily word algorithm implementation

### 2.3 Data Validation Process

- [ ] Create word validation service
- [ ] Implement letter frequency analysis
- [ ] Set up difficulty categorization
- [ ] Build word verification against dictionary

---

## Phase 3: Backend Development (.NET 9 Web API)

### 3.1 Core Architecture

```folder
Anagramme.Core/              # Domain layer
├── Models/
│   ├── Word.cs
│   ├── GameSession.cs
│   ├── GameGuess.cs
│   └── GuessResult.cs
├── Interfaces/
│   ├── IWordRepository.cs
│   ├── IGameService.cs
│   └── IWordService.cs
└── Enums/
    └── LetterStatus.cs

Anagramme.Infrastructure/     # Data layer
├── Data/
│   ├── AnagrammeDbContext.cs
│   └── Repositories/
├── Services/
│   ├── WordService.cs
│   └── GameService.cs
└── Migrations/

Anagramme.API/               # Presentation layer
├── Controllers/
│   ├── GameController.cs
│   └── WordController.cs
├── DTOs/
├── Middleware/
└── Program.cs
```

### 3.2 Core Models

```csharp
// Core domain models
public class Word
{
    public int Id { get; set; }
    public string WordText { get; set; } = string.Empty;
    public bool IsValid { get; set; } = true;
    public int Difficulty { get; set; } = 1;
    public DateTime CreatedAt { get; set; }
}

public class GameSession
{
    public Guid Id { get; set; }
    public string SessionId { get; set; } = string.Empty;
    public int TargetWordId { get; set; }
    public Word TargetWord { get; set; } = null!;
    public DateTime StartTime { get; set; }
    public DateTime? EndTime { get; set; }
    public bool IsCompleted { get; set; }
    public bool IsWon { get; set; }
    public int GuessCount { get; set; }
    public List<GameGuess> Guesses { get; set; } = new();
}

public class GuessResult
{
    public string GuessWord { get; set; } = string.Empty;
    public LetterStatus[] LetterStatuses { get; set; } = new LetterStatus[5];
    public bool IsCorrect { get; set; }
    public bool IsValidWord { get; set; }
}

public enum LetterStatus
{
    NotInWord = 0,    // Gray
    WrongPosition = 1, // Yellow
    Correct = 2       // Green
}
```

### 3.3 API Endpoints

```csharp
// Game endpoints
POST   /api/game/start           # Start new game session
POST   /api/game/guess           # Submit a guess
GET    /api/game/status/{sessionId} # Get current game state
POST   /api/game/daily           # Start daily challenge
GET    /api/game/statistics      # Get player statistics

// Word endpoints
GET    /api/words/validate/{word} # Validate if word exists
GET    /api/words/daily          # Get current daily word info
```

### 3.4 Key Services Implementation

- [ ] **WordService**: Word validation, daily word selection
- [ ] **GameService**: Game logic, guess evaluation, state management
- [ ] **StatisticsService**: Track wins, streaks, guess distribution

---

## Phase 4: Frontend Development (React + TypeScript)

### 4.1 Component Structure

```typescript
src/
├── components/
│   ├── Game/
│   │   ├── GameBoard.tsx        # Main game grid
│   │   ├── GuessRow.tsx         # Individual guess row
│   │   ├── LetterTile.tsx       # Individual letter tile
│   │   ├── Keyboard.tsx         # Virtual keyboard
│   │   └── GameStatus.tsx       # Win/lose messages
│   ├── UI/
│   │   ├── Header.tsx           # App header with title
│   │   ├── Modal.tsx            # Reusable modal component
│   │   ├── Button.tsx           # Styled button component
│   │   └── LoadingSpinner.tsx   # Loading indicator
│   └── Layout/
│       ├── Layout.tsx           # Main app layout
│       └── Navigation.tsx       # App navigation
├── hooks/
│   ├── useGame.ts              # Game state management
│   ├── useKeyboard.ts          # Keyboard input handling
│   ├── useLocalStorage.ts      # Local storage utilities
│   └── useStatistics.ts        # Statistics tracking
├── services/
│   ├── api.ts                  # API client
│   ├── gameService.ts          # Game-related API calls
│   └── localStorage.ts         # Local storage service
├── types/
│   ├── game.ts                 # Game-related types
│   ├── api.ts                  # API response types
│   └── statistics.ts           # Statistics types
├── utils/
│   ├── gameLogic.ts            # Client-side game utilities
│   ├── validation.ts           # Input validation
│   └── constants.ts            # App constants
└── styles/
    ├── globals.css             # Global styles
    └── components/             # Component-specific styles
```

### 4.2 Key Types

```typescript
// Game types
interface GameState {
  sessionId: string;
  targetWord: string;
  guesses: Guess[];
  currentGuess: string;
  gameStatus: "playing" | "won" | "lost";
  guessCount: number;
}

interface Guess {
  word: string;
  result: LetterStatus[];
  timestamp: Date;
}

interface GameStatistics {
  gamesPlayed: number;
  gamesWon: number;
  currentStreak: number;
  maxStreak: number;
  guessDistribution: number[]; // Index 0 = 1 guess, Index 5 = 6 guesses
}

enum LetterStatus {
  NotInWord = 0,
  WrongPosition = 1,
  Correct = 2,
}
```

### 4.3 Key Features Implementation

#### 4.3.1 Game Interface

- [ ] 6x5 grid for guesses (6 attempts, 5 letters each)
- [ ] Real-time input handling
- [ ] Color-coded feedback (green, yellow, gray)
- [ ] Virtual keyboard with letter status
- [ ] Smooth animations for tile flips and keyboard updates

#### 4.3.2 User Experience Features

- [ ] Responsive design (mobile-first)
- [ ] Dark/light theme toggle
- [ ] Smooth animations using CSS transitions
- [ ] Share functionality (copy results to clipboard)
- [ ] Local storage for game state persistence
- [ ] Accessibility features (ARIA labels, keyboard navigation)

#### 4.3.3 Game States Management

- [ ] Pre-game state (instructions, daily challenge info)
- [ ] Active game state (accepting input, processing guesses)
- [ ] Win state (celebration animation, statistics)
- [ ] Lose state (reveal answer, statistics)
- [ ] Statistics modal (detailed game statistics)

---

## Phase 5: Integration & Docker Setup

### 5.1 Docker Configuration

```yaml
# docker-compose.yml
version: "3.8"

services:
  termo-api:
    build:
      context: ./backend
      dockerfile: Anagramme.API/Dockerfile
    ports:
      - "5000:5000"
      - "5001:5001"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ConnectionStrings__DefaultConnection=Server=sqlserver;Database=AnagrammeDB;User Id=sa;Password=YourPassword123!;TrustServerCertificate=true;
    depends_on:
      - sqlserver
    networks:
      - termo-network

  termo-frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - VITE_API_URL=http://localhost:5000
    depends_on:
      - termo-api
    networks:
      - termo-network

  sqlserver:
    image: mcr.microsoft.com/mssql/server:2022-latest
    ports:
      - "1433:1433"
    environment:
      - SA_PASSWORD=YourPassword123!
      - ACCEPT_EULA=Y
    volumes:
      - sqlserver_data:/var/opt/mssql
    networks:
      - termo-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - termo-frontend
      - termo-api
    networks:
      - termo-network

volumes:
  sqlserver_data:

networks:
  termo-network:
    driver: bridge
```

### 5.2 Development Workflow

- [ ] Hot reload for both frontend and backend
- [ ] Database migrations and seeding
- [ ] Health checks for all services
- [ ] Centralized logging with Serilog
- [ ] Environment-specific configurations

---

## Phase 6: Advanced Features & Polish

### 6.1 Game Enhancements

- [ ] **Multiple difficulty levels** (common vs. uncommon words)
- [ ] **Daily challenges** (same word for all players per day)
- [ ] **Statistics tracking** (local storage + optional backend)
- [ ] **Streak counting** (consecutive daily wins)
- [ ] **Share results** (Twitter/WhatsApp compatible format)
- [ ] **Word definitions** (show definition after game ends)

### 6.2 Performance & Quality

- [ ] **Input validation** (front-end and back-end)
- [ ] **Rate limiting** (prevent API abuse)
- [ ] **Caching** (Redis for word lists and daily words)
- [ ] **Error handling** (user-friendly error messages)
- [ ] **Unit tests** (backend services and components)
- [ ] **Integration tests** (API endpoints)
- [ ] **E2E tests** (full game flow)

---

## Implementation Timeline (6 Weeks)

### Week 1: Foundation & Setup ✅

- [x] Project structure setup
- [x] .NET 9 solution with proper architecture
- [x] React with Vite and TypeScript setup
- [ ] Docker Compose configuration
- [ ] Database schema creation

### Week 2: Data & Backend Core

- [ ] Word data collection and population
- [ ] Core game logic implementation
- [ ] Basic API endpoints
- [ ] Entity Framework setup and migrations

### Week 3: Frontend Foundation

- [ ] Basic component structure
- [ ] Game board UI implementation
- [ ] Keyboard component
- [ ] Basic game state management

### Week 4: Integration & Game Logic

- [ ] Frontend-backend integration
- [ ] Guess validation implementation
- [ ] Color-coded feedback system
- [ ] Game state persistence

### Week 5: Polish & Advanced Features

- [ ] Animations and transitions
- [ ] Statistics implementation
- [ ] Share functionality
- [ ] Responsive design and styling
- [ ] Theme switching

### Week 6: Testing & Deployment

- [ ] Comprehensive testing suite
- [ ] Performance optimization
- [ ] Production Docker setup
- [ ] Documentation completion
- [ ] Deployment preparation

---

## Word Database Population Strategy

### Recommended Data Sources

1. **NLTK Portuguese Corpus**

   - Download: `nltk.download('floresta')`
   - Filter for Brazilian Portuguese

2. **OpenTaal Portuguese Word Lists**

   - Public domain Portuguese dictionaries
   - Filter for appropriate content

3. **Custom Word Lists**
   - Manually curated common words
   - Remove inappropriate or offensive terms

### Processing Pipeline

```python
# Example Python script for word processing
def process_portuguese_words():
    # 1. Load raw word lists
    # 2. Filter for exactly 5 letters
    # 3. Remove proper nouns
    # 4. Remove words with accents (decision needed)
    # 5. Score by frequency/difficulty
    # 6. Manual review for appropriateness
    # 7. Export to SQL format
```

### Word Criteria

- **Length**: Exactly 5 letters
- **Language**: Brazilian Portuguese
- **Content**: Family-friendly, no offensive terms
- **Characters**: Decide on accented characters (ç, ã, é, etc.)
- **Frequency**: Include common and uncommon words for variety

---

## Development Notes

### Key Decisions Made

1. **Tech Stack**: .NET 9 for latest features vs. LTS stability
2. **Frontend**: Vite for faster development vs. Create React App
3. **Database**: SQL Server for robust relational data
4. **Architecture**: Clean Architecture with separate concerns

### Key Decisions Pending

1. **Accented Characters**: Allow ç, ã, é, etc. or normalize?
2. **Word Source**: Primary dictionary to use for Brazilian Portuguese
3. **Difficulty Algorithm**: How to score word difficulty
4. **Daily Word**: Algorithm for fair daily word selection
5. **Statistics Storage**: Local only or backend persistence?

### Development Environment Setup

1. Install .NET 9 SDK ✅
2. Install Node.js and npm ✅
3. Install Docker Desktop (pending)
4. Install SQL Server Management Studio (optional)
5. Setup VS Code with extensions:
   - C# Dev Kit
   - ES7+ React/Redux/React-Native snippets
   - Prettier
   - ESLint

---

## Testing Strategy

### Backend Testing

- **Unit Tests**: Core game logic, word validation
- **Integration Tests**: Database operations, API endpoints
- **Performance Tests**: Large word list queries

### Frontend Testing

- **Unit Tests**: Utility functions, hooks
- **Component Tests**: React components with React Testing Library
- **E2E Tests**: Complete game flow with Playwright

### Manual Testing Checklist

- [ ] Complete game flow (start to win/lose)
- [ ] Invalid word handling
- [ ] Keyboard input (physical and virtual)
- [ ] Mobile responsiveness
- [ ] Theme switching
- [ ] Statistics accuracy
- [ ] Share functionality

---

## Deployment Considerations

### Production Environment

- **Backend**: Azure App Service or AWS ECS
- **Frontend**: Netlify, Vercel, or static hosting
- **Database**: Azure SQL Database or AWS RDS
- **CDN**: For static assets and performance

### Monitoring

- **Application Insights** for .NET backend
- **Error tracking** with Sentry or similar
- **Performance monitoring** for database queries
- **User analytics** (optional)

---

This development plan provides a comprehensive roadmap for building the Anagramme clone. Update this document as you progress and make decisions about pending items.
