# Weather PowerShell Function App

An Azure Functions PowerShell application that retrieves weather data from a public weather API and returns it via HTTP trigger.

## Overview

This function app calls the OpenWeatherMap API to fetch current weather data for a specified location and returns formatted JSON data to the client.

## Features

- HTTP-triggered Azure Function built with PowerShell
- Calls OpenWeatherMap public API for weather data
- Returns comprehensive weather information including:
  - Temperature (current, feels like, min, max)
  - Weather conditions and description
  - Humidity and pressure
  - Wind speed and direction
  - Cloud coverage and visibility
  - Sunrise and sunset times
- Accepts location via query parameters or request body
- Error handling with informative messages

## Prerequisites

- Azure subscription
- Azure Functions Core Tools (for local development)
- PowerShell 7.2 or later
- OpenWeatherMap API key (free tier available at https://openweathermap.org/api)

## Setup

### 1. Get an API Key

1. Visit https://openweathermap.org/api
2. Sign up for a free account
3. Generate an API key from your account dashboard

### 2. Local Development

Create a `local.settings.json` file in the root directory:

```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "powershell",
    "OPENWEATHER_API_KEY": "your-api-key-here"
  }
}
```

### 3. Deploy to Azure

1. Create an Azure Function App:
   ```bash
   az functionapp create --resource-group <resource-group> \
     --consumption-plan-location <region> \
     --runtime powershell \
     --runtime-version 7.2 \
     --functions-version 4 \
     --name <function-app-name> \
     --storage-account <storage-account>
   ```

2. Configure the API key in Application Settings:
   ```bash
   az functionapp config appsettings set \
     --name <function-app-name> \
     --resource-group <resource-group> \
     --settings "OPENWEATHER_API_KEY=your-api-key-here"
   ```

3. Deploy the function:
   ```bash
   func azure functionapp publish <function-app-name>
   ```

## Usage

### Request Format

**GET Request:**
```
https://<function-app-name>.azurewebsites.net/api/GetWeather?Location=Seattle
```

**POST Request:**
```bash
curl -X POST https://<function-app-name>.azurewebsites.net/api/GetWeather \
  -H "Content-Type: application/json" \
  -d '{"Location": "London"}'
```

### Response Format

Success response (HTTP 200):
```json
{
  "location": "Seattle",
  "country": "US",
  "coordinates": {
    "latitude": 47.6062,
    "longitude": -122.3321
  },
  "weather": {
    "condition": "Clouds",
    "description": "scattered clouds",
    "temperature": {
      "current": 15.5,
      "feels_like": 14.8,
      "min": 13.2,
      "max": 17.1
    },
    "pressure": 1013,
    "humidity": 72,
    "wind": {
      "speed": 3.5,
      "direction": 230
    },
    "clouds": 40,
    "visibility": 10000
  },
  "timestamp": "2025-01-15 10:30:00",
  "sunrise": "2025-01-15 07:54:00",
  "sunset": "2025-01-15 16:32:00"
}
```

Error response (HTTP 400):
```json
{
  "error": "Weather API key not configured",
  "message": "Please set OPENWEATHER_API_KEY in Application Settings",
  "instructions": "Get a free API key from https://openweathermap.org/api",
  "location": "Seattle"
}
```

## Project Structure

```
weather-powershell-function/
├── GetWeather/
│   ├── function.json        # HTTP trigger configuration
│   └── run.ps1              # Main function logic
├── host.json                # Function app configuration
├── profile.ps1              # PowerShell profile for Azure
├── requirements.psd1        # PowerShell module dependencies
└── README.md                # This file
```

## Running Locally

1. Install Azure Functions Core Tools
2. Set up `local.settings.json` with your API key
3. Run the function:
   ```bash
   func start
   ```
4. Test the endpoint:
   ```bash
   curl "http://localhost:7071/api/GetWeather?Location=Seattle"
   ```

## License

MIT License - see LICENSE file for details