using Anagramme.Core.Interfaces;
using Anagramme.Infrastructure.Data;
using Anagramme.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

// Add database context
builder.Services.AddDbContext<AnagrammeDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))
);

// Add application services
builder.Services.AddScoped<IGameService, GameService>();

var app = builder.Build();

// Configure middleware
app.UseRouting();
app.UseAuthorization();

// Map endpoints
app.MapControllers();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.Run();
