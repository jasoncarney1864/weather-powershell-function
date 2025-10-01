using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$location = $Request.Query.Location
if (-not $location) {
    $location = $Request.Body.Location
}

# Default location if none provided
if (-not $location) {
    $location = "Seattle"
}

# Status code and body for response
$statusCode = [HttpStatusCode]::OK
$body = @{}

try {
    # Azure Maps Weather API requires coordinates
    # For this example, we'll use a simplified approach with predefined coordinates
    # In production, you would geocode the location first or use OpenWeatherMap API
    
    # Using OpenWeatherMap API as it's a widely-used public weather API
    # Note: In production, API key should be stored in Application Settings
    $apiKey = $env:OPENWEATHER_API_KEY
    
    if (-not $apiKey) {
        # For demo purposes, provide instructions if API key is not set
        $statusCode = [HttpStatusCode]::BadRequest
        $body = @{
            error = "Weather API key not configured"
            message = "Please set OPENWEATHER_API_KEY in Application Settings"
            instructions = "Get a free API key from https://openweathermap.org/api"
            location = $location
        }
    }
    else {
        # Call OpenWeatherMap Current Weather API
        $weatherUrl = "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric"
        
        Write-Host "Calling weather API for location: $location"
        
        $weatherResponse = Invoke-RestMethod -Uri $weatherUrl -Method Get
        
        # Parse and format the weather data
        $body = @{
            location = $weatherResponse.name
            country = $weatherResponse.sys.country
            coordinates = @{
                latitude = $weatherResponse.coord.lat
                longitude = $weatherResponse.coord.lon
            }
            weather = @{
                condition = $weatherResponse.weather[0].main
                description = $weatherResponse.weather[0].description
                temperature = @{
                    current = $weatherResponse.main.temp
                    feels_like = $weatherResponse.main.feels_like
                    min = $weatherResponse.main.temp_min
                    max = $weatherResponse.main.temp_max
                }
                pressure = $weatherResponse.main.pressure
                humidity = $weatherResponse.main.humidity
                wind = @{
                    speed = $weatherResponse.wind.speed
                    direction = $weatherResponse.wind.deg
                }
                clouds = $weatherResponse.clouds.all
                visibility = $weatherResponse.visibility
            }
            timestamp = (Get-Date -UnixTimeSeconds $weatherResponse.dt).ToString("yyyy-MM-dd HH:mm:ss")
            sunrise = (Get-Date -UnixTimeSeconds $weatherResponse.sys.sunrise).ToString("yyyy-MM-dd HH:mm:ss")
            sunset = (Get-Date -UnixTimeSeconds $weatherResponse.sys.sunset).ToString("yyyy-MM-dd HH:mm:ss")
        }
        
        Write-Host "Successfully retrieved weather data for $($body.location), $($body.country)"
    }
}
catch {
    Write-Host "Error occurred: $_"
    $statusCode = [HttpStatusCode]::BadRequest
    $body = @{
        error = "Failed to retrieve weather data"
        message = $_.Exception.Message
        location = $location
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $statusCode
    Body = $body
    Headers = @{
        "Content-Type" = "application/json"
    }
})
