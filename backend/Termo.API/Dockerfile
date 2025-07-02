# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /src

# Copy csproj files and restore dependencies
COPY ["Termo.API/Termo.API.csproj", "Termo.API/"]
COPY ["Termo.Core/Termo.Core.csproj", "Termo.Core/"]
COPY ["Termo.Infrastructure/Termo.Infrastructure.csproj", "Termo.Infrastructure/"]

RUN dotnet restore "Termo.API/Termo.API.csproj"

# Copy all source code
COPY . .

# Build the application
WORKDIR "/src/Termo.API"
RUN dotnet build "Termo.API.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "Termo.API.csproj" -c Release -o /app/publish

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
ENTRYPOINT ["dotnet", "Termo.API.dll"]
