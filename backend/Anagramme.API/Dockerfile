# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /src

# Copy csproj files and restore dependencies
COPY ["Anagramme.API/Anagramme.API.csproj", "Anagramme.API/"]
COPY ["Anagramme.Core/Anagramme.Core.csproj", "Anagramme.Core/"]
COPY ["Anagramme.Infrastructure/Anagramme.Infrastructure.csproj", "Anagramme.Infrastructure/"]

RUN dotnet restore "Anagramme.API/Anagramme.API.csproj"

# Copy all source code
COPY . .

# Build the application
WORKDIR "/src/Anagramme.API"
RUN dotnet build "Anagramme.API.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "Anagramme.API.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

WORKDIR /app

# Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy published application
COPY --from=publish /app/publish .

# Change ownership of the application directory
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose ports
EXPOSE 5000
EXPOSE 5001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Set environment variables
ENV ASPNETCORE_URLS=http://+:5000;https://+:5001
ENV ASPNETCORE_ENVIRONMENT=Production

# Start the application
ENTRYPOINT ["dotnet", "Anagramme.API.dll"]
