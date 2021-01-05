FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["angularMVC/angularMVC.csproj", "angularMVC/"]

RUN dotnet restore "angularMVC/angularMVC.csproj"
COPY . .
WORKDIR "/src/angularMVC"
RUN dotnet build "angularMVC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "angularMVC.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "angularMVC.dll"]