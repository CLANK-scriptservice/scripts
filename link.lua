local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- Generate a random 6-digit verification code
local code = math.random(100000, 999999)

-- Print the code to the Roblox console
print("Your 6-digit verification code is: " .. code)

-- Prepare data to send to the Discord bot (the bot will listen to this)
local botUrl = "http://127.0.0.1:5000/verify_code"  -- Server endpoint for verifying code
local userID = player.UserId
local hwid = gethwid()  -- You may replace with the actual method to get HWID if required

local data = {
    user_id = userID,
    hwid = hwid,
    code = code
}

local jsonData = HttpService:JSONEncode(data)

-- Send the data to the bot server to validate the code
local success, response = pcall(function()
    HttpService:PostAsync(botUrl, jsonData, Enum.HttpContentType.ApplicationJson)
end)

