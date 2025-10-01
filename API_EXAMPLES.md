# Sample API Calls for GetWeather Function

## Prerequisites
Replace `<function-app-name>` with your actual Azure Function App name
Replace `<function-key>` with your function key (if using function-level auth)

## Local Development (if running locally with `func start`)

### GET request with query parameter
```bash
curl "http://localhost:7071/api/GetWeather?Location=Seattle"
```

### GET request - default location
```bash
curl "http://localhost:7071/api/GetWeather"
```

### POST request with JSON body
```bash
curl -X POST http://localhost:7071/api/GetWeather \
  -H "Content-Type: application/json" \
  -d '{"Location": "London"}'
```

### POST request - different locations
```bash
# New York
curl -X POST http://localhost:7071/api/GetWeather \
  -H "Content-Type: application/json" \
  -d '{"Location": "New York"}'

# Tokyo
curl -X POST http://localhost:7071/api/GetWeather \
  -H "Content-Type: application/json" \
  -d '{"Location": "Tokyo"}'

# Paris
curl -X POST http://localhost:7071/api/GetWeather \
  -H "Content-Type: application/json" \
  -d '{"Location": "Paris"}'
```

## Azure Deployment

### GET request with query parameter
```bash
curl "https://<function-app-name>.azurewebsites.net/api/GetWeather?Location=Seattle"
```

### With function key (if using function-level auth)
```bash
curl "https://<function-app-name>.azurewebsites.net/api/GetWeather?code=<function-key>&Location=Seattle"
```

### POST request with JSON body
```bash
curl -X POST https://<function-app-name>.azurewebsites.net/api/GetWeather \
  -H "Content-Type: application/json" \
  -d '{"Location": "London"}'
```

### POST request with function key
```bash
curl -X POST "https://<function-app-name>.azurewebsites.net/api/GetWeather?code=<function-key>" \
  -H "Content-Type: application/json" \
  -d '{"Location": "London"}'
```

## PowerShell Examples

### Using Invoke-RestMethod (GET)
```powershell
Invoke-RestMethod -Uri "http://localhost:7071/api/GetWeather?Location=Seattle" -Method Get
```

### Using Invoke-RestMethod (POST)
```powershell
$body = @{ Location = "London" } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:7071/api/GetWeather" -Method Post -Body $body -ContentType "application/json"
```

## Expected Response Format

### Success Response (HTTP 200)
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

### Error Response (HTTP 400)
```json
{
  "error": "Weather API key not configured",
  "message": "Please set OPENWEATHER_API_KEY in Application Settings",
  "instructions": "Get a free API key from https://openweathermap.org/api",
  "location": "Seattle"
}
```
