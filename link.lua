local HttpService = game:GetService("HttpService")
local code = math.random(100000, 999999)  -- Generate a random 6-digit code
local hwid = game:GetService("Players").LocalPlayer.UserId -- Placeholder for HWID, this is a basic example

-- Format the data
local data = {code = code, hwid = hwid}

-- Send the code and HWID to the server
local url = "http://127.0.0.1:5000/link_code"
local success, response = pcall(function()
    return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
end)

if success then
    print("Verification code sent successfully!")
else
    print("Error sending verification code: " .. response)
end

-- Print the verification code to Roblox console for the user
print("Your 6-digit verification code is: " .. code)
