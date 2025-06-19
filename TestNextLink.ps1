# Define variables
$clientId = "ClientIDHere"
$clientSecret = "ClientSecretHere"
$tenantId = "tenantIdHere"
$scope = "https://api.businesscentral.dynamics.com/.default" 
$apiUrl = "URLHere"

# Get OAuth2.0 token
$tokenResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" `
    -Body @{
        client_id     = $clientId
        scope         = $scope
        client_secret = $clientSecret
        grant_type    = "client_credentials"
    } -ContentType "application/x-www-form-urlencoded"

$accessToken = $tokenResponse.access_token
Write-Host 'Retrieved Token ' 
Get-Date -Format HH:mm:ss

# Function to get data and follow OData.nextLink
function Get-ODataAllPages {
    param (
        [string]$InitialUrl,
        [string]$AccessToken
    )
    $results = @()
    $url = $InitialUrl
    do {
        $response = Invoke-RestMethod -Uri $url -Headers @{Authorization = "Bearer $AccessToken"}
        $results += $response.value
        $url = $response.'@odata.nextLink'
        $currentTime = Get-Date -Format HH:mm:ss
        Write-Host "Time: $currentTime Calling page: $url"
        
    } while ($url)
    return $results
}

# Call the function
$data = Get-ODataAllPages -InitialUrl $apiUrl -AccessToken $accessToken
Write-Host "Calls completed:"  
Get-Date -Format HH:mm:ss

# Output results
$data | ConvertTo-Json | Out-File "ApiResults.json"