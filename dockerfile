FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

#Show dotnet version
RUN dotnet --version

# copy csproj and restore as distinct layers
COPY webapp/*.csproj ./
RUN dotnet restore

# copy and publish app and libraries
COPY ./webapp ./
RUN dotnet publish -c Release -o out

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "webapp.dll"]