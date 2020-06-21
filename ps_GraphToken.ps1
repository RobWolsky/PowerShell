# Create a hashtable for the body, the data needed for the token request
# The variables used are explained above
$Body = @{
    'tenant' = 'a2a9bf31-fc44-425c-a6d2-3ae9379573ea'
    'client_id' = '599f2f05-2b85-4d68-93fe-4c46a659479c'
    'scope' = 'https://graph.microsoft.com/.default'
    'client_secret' = '_5E-83iv.2CIV672~6~S2dZS_jKKx.xZOg'
    'grant_type' = 'client_credentials'
}

# Assemble a hashtable for splatting parameters, for readability
# The tenant id is used in the uri of the request as well as the body
$Params = @{
    'Uri' = "https://login.microsoftonline.com/a2a9bf31-fc44-425c-a6d2-3ae9379573ea/oauth2/v2.0/token"
    'Method' = 'Post'
    'Body' = $Body
    'ContentType' = 'application/x-www-form-urlencoded'
}

$AuthResponse = Invoke-RestMethod @Params


$Headers = @{
    'Authorization' = "Bearer $($AuthResponse.access_token)"
}

$Result = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/users' -Headers $Headers