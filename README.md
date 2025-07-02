# Anagramme - Brazilian Word Game Clone

A modern implementation of the popular Brazilian word-guessing game "Termo" (inspired by Wordle), built with .NET 9, React, TypeScript, and SQL Server.

## 🎮 Game Description

**Anagramme** is a daily word puzzle game where players have 6 attempts to guess a 5-letter Portuguese word. After each guess, the tiles change color to show how close your guess was to the word:

- 🟩 **Green**: Letter is in the word and in the correct position
- 🟨 **Yellow**: Letter is in the word but in the wrong position
- ⬜ **Gray**: Letter is not in the word at all

## 🚀 Tech Stack

- **Backend**: .NET 9 Web API with Entity Framework Core
- **Frontend**: React 18 with TypeScript and Vite
- **Database**: SQL Server 2022
- **Containerization**: Docker & Docker Compose
- **Word Data**: Brazilian Portuguese dictionary

## 📁 Project Structure

```folder
anagramme-game/
├── backend/                    # .NET 9 Backend
│   ├── Anagramme.API/         # Web API project
│   ├── Anagramme.Core/        # Domain models, interfaces
│   ├── Anagramme.Infrastructure/  # Data access, services
│   └── Anagramme.Tests/       # Unit tests
├── frontend/                  # React Frontend
│   ├── src/                  # Source code
│   ├── public/               # Static assets
│   └── package.json          # Dependencies
├── database/                  # Database scripts
│   ├── scripts/              # SQL migration scripts
│   └── seed-data/            # Sample data
├── docker-compose.yml        # Container orchestration
├── DEVELOPMENT_PLAN.md       # Detailed development roadmap
└── README.md                 # This file
```

## 🛠️ Getting Started

### Prerequisites

- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- [Node.js 18+](https://nodejs.org/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/)

### Local Development Setup

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd anagramme-game
   ```

2. **Start the database with Docker**

   ```bash
   docker-compose up sqlserver -d
   ```

3. **Run the backend**

   ```bash
   cd backend
   dotnet restore
   dotnet run --project Anagramme.API
   ```

4. **Run the frontend**

   ```bash
   cd frontend
   npm install
   npm run dev
   ```

5. **Access the application**
   - Frontend: <http://localhost:3000>
   - Backend API: <http://localhost:5000>
   - API Documentation: <http://localhost:5000/openapi>

### Docker Development (Full Stack)

```bash
# Start all services
docker-compose up --build

# Start only specific services
docker-compose up sqlserver anagramme-api

# View logs
docker-compose logs -f anagramme-api

# Stop all services
docker-compose down
```

## 🗄️ Database Setup

The database is automatically created when running with Docker Compose. For manual setup:

1. **Create the database**

   ```bash
   sqlcmd -S localhost -U sa -P AnagrammePassword123! -i database/scripts/01_create_schema.sql
   ```

2. **Seed sample data**

   ```bash
   sqlcmd -S localhost -U sa -P AnagrammePassword123! -i database/scripts/02_seed_sample_words.sql
   ```

## 🎯 Features

### ✅ Implemented

- [x] Project structure with .NET 9 and React+Vite
- [x] Docker containerization setup
- [x] Database schema design
- [x] Sample Portuguese word data

### 🚧 In Progress

- [ ] Core game logic implementation
- [ ] API endpoints for game operations
- [ ] React game interface
- [ ] Word validation system

### 📋 Planned Features

- [ ] Daily word challenges
- [ ] Game statistics tracking
- [ ] Share functionality
- [ ] Dark/light theme toggle
- [ ] Mobile-responsive design
- [ ] Comprehensive Portuguese word database
- [ ] Performance optimizations

## 🎮 How to Play

1. **Start a new game** - A random 5-letter Portuguese word is selected
2. **Make your guess** - Type a valid 5-letter Portuguese word
3. **Check the feedback** - Colors indicate how close you are
4. **Keep guessing** - You have 6 attempts to find the word
5. **Win or learn** - Either guess correctly or see the answer!

## 🛠️ Development

### Backend Development

```bash
cd backend

# Run tests
dotnet test

# Generate database migration
dotnet ef migrations add MigrationName --project Anagramme.Infrastructure --startup-project Anagramme.API

# Apply migrations
dotnet ef database update --project Anagramme.Infrastructure --startup-project Anagramme.API
```

### Frontend Development

```bash
cd frontend

# Run in development mode
npm run dev

# Build for production
npm run build

# Run tests
npm test

# Lint code
npm run lint
```

### Database Management

```bash
# Connect to SQL Server
docker exec -it anagramme-sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P AnagrammePassword123!

# Backup database
docker exec anagramme-sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P AnagrammePassword123! -Q "BACKUP DATABASE AnagrammeDB TO DISK = '/tmp/anagramme-backup.bak'"
```

## 📊 API Endpoints

### Game Operations

- `POST /api/game/start` - Start a new game session
- `POST /api/game/guess` - Submit a word guess
- `GET /api/game/status/{sessionId}` - Get current game state
- `GET /api/game/daily` - Get today's daily challenge

### Word Operations

- `GET /api/words/validate/{word}` - Check if word is valid
- `GET /api/words/random` - Get a random word for practice

### Statistics

- `GET /api/statistics/{playerId}` - Get player statistics
- `POST /api/statistics` - Update player statistics

## 🌐 Environment Variables

### Backend (.NET)

```env
ASPNETCORE_ENVIRONMENT=Development
ConnectionStrings__DefaultConnection=Server=localhost;Database=AnagrammeDB;User Id=sa;Password=AnagrammePassword123!;TrustServerCertificate=true;
```

### Frontend (React)

```env
VITE_API_URL=http://localhost:5000
VITE_API_URL_HTTPS=https://localhost:5001
```

## 🧪 Testing

### Backend Tests

```bash
cd backend
dotnet test --verbosity normal
```

### Frontend Tests

```bash
cd frontend
npm test
```

### Integration Tests

```bash
# Start test environment
docker-compose -f docker-compose.test.yml up --build

# Run integration tests
dotnet test backend/Anagramme.Tests.Integration
```

## 📈 Performance Considerations

- **Database Indexing**: Optimized indexes on word lookups and game queries
- **Caching**: Redis caching for frequent word validations (planned)
- **API Rate Limiting**: Prevent abuse of guess endpoints
- **Frontend Optimization**: Code splitting and lazy loading

## 🚀 Deployment

### Production Docker Build

```bash
# Build production images
docker-compose -f docker-compose.prod.yml build

# Deploy to production
docker-compose -f docker-compose.prod.yml up -d
```

### Environment Setup

1. Configure production database connection strings
2. Set up SSL certificates for HTTPS
3. Configure reverse proxy (Nginx)
4. Set up monitoring and logging

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the original [Wordle](https://www.nytimes.com/games/wordle/index.html) by Josh Wardle
- Brazilian Portuguese word lists from various open-source dictionaries
- React community for excellent tooling and libraries
- .NET team for the amazing framework

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Development Plan](DEVELOPMENT_PLAN.md) for detailed implementation notes
2. Look through existing [GitHub Issues](../../issues)
3. Create a new issue with detailed information about your problem

---

## **Happy word guessing! 🎯🇧🇷**
