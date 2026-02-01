# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["Pcm.Api/Pcm.Api.csproj", "Pcm.Api/"]
RUN dotnet restore "Pcm.Api/Pcm.Api.csproj"

# Copy everything else and build
COPY . .
WORKDIR "/src/Pcm.Api"
RUN dotnet build "Pcm.Api.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "Pcm.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080

# Copy published app
COPY --from=publish /app/publish .

# Run the app
ENTRYPOINT ["dotnet", "Pcm.Api.dll"]
