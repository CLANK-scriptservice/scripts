local player = game.Players.LocalPlayer
local ME = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local tycoonColor
local humanoid = character:WaitForChild("Humanoid")
local tycoonsFolder = workspace:WaitForChild("Zednov's Tycoon Kit"):WaitForChild("Tycoons")

print(ME)
for _, tycoon in pairs(workspace["Zednov's Tycoon Kit"].Tycoons:GetChildren()) do
    if tycoon:FindFirstChild("Owner") and tycoon.Owner.Value == player then
        tycoonColor = tycoon.Name
        break
    end
end

function CollectMoney()
    firetouchinterest(tycoonsFolder[tycoonColor]:WaitForChild("Essentials"):WaitForChild("Giver"), humanoidRootPart, 0)
    Wait(1)
    firetouchinterest(tycoonsFolder[tycoonColor]:WaitForChild("Essentials"):WaitForChild("Giver"), humanoidRootPart, 1)
end

local flying = false
local flySpeed = 50
local flyConnection

local function Fly()
    if flying then return end
    flying = true

    flyConnection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
        if not flying then return end
        local moveDirection = Vector3.zero
        local userInputService = game:GetService("UserInputService")

        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection += humanoidRootPart.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection -= humanoidRootPart.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection -= humanoidRootPart.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection += humanoidRootPart.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection += Vector3.new(0, 1, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection -= Vector3.new(0, 1, 0)
        end

        if moveDirection.Magnitude > 0 then
            humanoidRootPart.Velocity = moveDirection.Unit * flySpeed
        else
            humanoidRootPart.Velocity = Vector3.zero
        end
    end)
end

local function Unfly()
    if not flying then return end
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    humanoidRootPart.Velocity = Vector3.zero
end

local function setFlySpeed(speed)
    flySpeed = speed
end

function setSpeed(speed)
    humanoid.WalkSpeed = speed
end

local runService = game:GetService("RunService")

local noclipConnection
local noclipActive = false

function noclip()
    if noclipActive then return end
    noclipActive = true
    noclipConnection = runService.Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

function clip()
    if not noclipActive then return end
    noclipActive = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Mega Mansion Tycoon - V1.1",
   LoadingTitle = "loading...",
   LoadingSubtitle = "by nutsforbolts on Discord",
   Theme = "Default",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false,
    Discord = {
    Enabled = false,
    Invite = "",
    RememberJoins = true
   },
})

local playerSettingsTab = Window:CreateTab("Player Settings", "person-standing")
local gameTab = Window:CreateTab("Autofarm", "gamepad-2")
local teleportTab = Window:CreateTab("Teleport", "move")
local settingsTab = Window:CreateTab("Settings", "wrench")

local aboutParagraph = settingsTab:CreateParagraph({Title = "Info", Content = "Version 1.1\nNOTICE: These scripts are free of charge and require NO key.\nIf you had to use a key or pay for this you were SCAMMED\nIf so, please contact nutsforbolts on Discord.\nhttps://discord.gg/JTmVwtRW3D\nCREDITS: nutsforbolts, .vfvo"})

local killMenuButton = settingsTab:CreateButton({
    Name = "Kill Menu",
    Callback = function()
        Rayfield:Destroy()
    end,
})

local collectMoneyButton = gameTab:CreateButton({
   Name = "Collect Money",
   Callback = function()
        CollectMoney()
   end,
})

local flyToggle = playerSettingsTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        if Value == true then
            Fly()
        elseif Value == false then
            Unfly()
        end
    end
 })

local flySlider = playerSettingsTab:CreateSlider({
   Name = "Fly Speed",
   Range = {0, 1000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(flyP)
    setFlySpeed(flyP)
   end,
})

local speedSlider = playerSettingsTab:CreateSlider({
   Name = "Walk Speed",
   Range = {20, 200},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(speedP)
    setSpeed(speedP)
   end,
})

local collectToggle = gameTab:CreateToggle({
    Name = "Auto Collect Money",
    CurrentValue = false,
    Callback = function(collectP)
        while collectP == true do
            CollectMoney()
        end
    end
 })

local houseMapping = {
    ["None"] = 0,
    ["Mega Mansion"] = 1,
    ["Beach House"] = 2,
    ["Penthouse"] = 3,
    ["Tropical House"] = 4,
    ["Mega Yacht"] = 5
}

local selectedHouse = 0

local autoBuyDropdown = gameTab:CreateDropdown({
   Name = "Select House to Upgrade",
   Options = {"None", "Mega Mansion","Beach House", "Penthouse", "Tropical House", "Mega Yacht"},
   CurrentOption = {"None"},
   Callback = function(Options)
        selectedHouse = houseMapping[Options[1]] or 0
        print("Selected House Number: " .. selectedHouse)
   end,
})

local Toggle = gameTab:CreateToggle({
    Name = "Auto Buy Buttons",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        OffOn = Value
        local levelName = "Level" .. selectedHouse
        local levelFolder
        while OffOn and task.wait() do
            if selectedHouse == 3 and OffOn then
                levelFolder = workspace.ClientButtons
            else
                levelFolder = workspace["Zednov's Tycoon Kit"].Tycoons[tycoonColor].Buttons:FindFirstChild(levelName)
            end

            if levelFolder then
                for i, v in pairs(levelFolder:GetChildren()) do
                    if v:FindFirstChild('Head') and v.Head:FindFirstChild('TouchInterest') and OffOn then
                        print("Buying", v.Name)
                        firetouchinterest(v.Head, humanoidRootPart, 0)
                        wait(0.2)
                        firetouchinterest(v.Head, humanoidRootPart, 1)
                        wait(0.5)
                    end
                end
            else
                print("Level folder not found for", levelName)
            end
        end
    end,
 })




local antiAFKButton = playerSettingsTab:CreateButton({
   Name = "Enable Anti-Afk",
   Callback = function()
       local ME = game.Players.LocalPlayer
        local GC = getconnections or get_signal_cons
        if GC then
            for _, v in pairs(GC(ME.Idled)) do
                if v["Disable"] then
                    v["Disable"](v)
                elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
            end
            Rayfield:Notify({
            Title = "Anti-Afk",
            Content = "Anti-Afk Enabled!",
            Duration = 3
            })      
        else
            Rayfield:Notify({
            Title = "Anti-Afk",
            Content = "This executor doesn't support anti-afk :(",
            Duration = 3
            })
        end
   end,
})

local noclipToggle = playerSettingsTab:CreateToggle({
   Name = "Toggle Noclip",
   CurrentValue = false,
   Callback = function(Value)
        if Value then
            noclip()
        elseif Value == false then
            clip()
        end
   end,
})

local collectMoneyButton = playerSettingsTab:CreateButton({
   Name = "Execute Infinite Yield",
   Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})


local megaTeleportButton = teleportTab:CreateButton({
   Name = "Teleport To Mega Mansion",
   Callback = function()
        local args = {
            [1] = "Level1"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("LocationTeleport"):FireServer(unpack(args))
   end,
})
local beachTeleportButton = teleportTab:CreateButton({
   Name = "Teleport To Beach House",
   Callback = function()
        local args = {
            [1] = "Level2"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("LocationTeleport"):FireServer(unpack(args))
   end,
})
local pentTeleportButton = teleportTab:CreateButton({
   Name = "Teleport To Penthouse",
   Callback = function()
        local args = {
            [1] = game:GetService("Players").LocalPlayer.Name
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestApt"):FireServer(unpack(args))
   end,
})
local tropicalTeleportButton = teleportTab:CreateButton({
   Name = "Teleport To Tropical House",
   Callback = function()
        local args = {
            [1] = "Level4"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("LocationTeleport"):FireServer(unpack(args))
   end,
})
local yachtTeleportButton = teleportTab:CreateButton({
   Name = "Teleport To Mega Yacht",
   Callback = function()
        local args = {
            [1] = "Level5"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("LocationTeleport"):FireServer(unpack(args))
   end,
})
