-- Load NezurLib
local NezurLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/BillyAnewCoder/RobloxUtilityLib/main/NezurLib"))()

-- Create Main Window
local Window = NezurLib:CreateWindow(Enum.KeyCode.RightShift, "DeleteMob")

-- Create Tabs
local AimbotTab = Window:CreateTab("Aimbot")
local SettingsTab = Window:CreateTab("Settings")

-- Aimbot Settings Sector
local AimbotSettings = AimbotTab:CreateSector("Aimbot Settings", "Left")

AimbotSettings:CreateToggle("Aimbot Enabled", false, function(state)
    print("Aimbot Enabled: ", state)
end)

AimbotSettings:CreateKeyBind("Aimbot Key", Enum.KeyCode.MouseButton2, function(key)
    print("Aimbot Key: ", key)
end)

AimbotSettings:CreateSlider("Aim Smoothness", 0, 0.5, 1, 0.1, function(value)
    print("Aim Smoothness: ", value)
end)

AimbotSettings:CreateToggle("Team Check", false, function(state)
    print("Team Check: ", state)
end)

AimbotSettings:CreateSlider("Velocity Threshold", 0, 39, 100, 1, function(value)
    print("Velocity Threshold: ", value)
end)

AimbotSettings:CreateToggle("Sticky Aim", false, function(state)
    print("Sticky Aim: ", state)
end)

AimbotSettings:CreateToggle("Trigger Bot", false, function(state)
    print("Trigger Bot: ", state)
end)

AimbotSettings:CreateToggle("Trigger Bot Prediction", false, function(state)
    print("Trigger Bot Prediction: ", state)
end)

-- General Settings Sector
local GeneralSettings = SettingsTab:CreateSector("General Settings", "Left")

GeneralSettings:CreateButton("Load Config", function()
    print("Config Loaded")
end)

GeneralSettings:CreateButton("Save Config", function()
    print("Config Saved")
end)

-- Silent Aim Function
local function getClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and (not AimbotSettings:GetValue("Team Check") or player.Team ~= game.Players.LocalPlayer.Team) then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closestEnemy = player
                    shortestDistance = distance
                end
            end
        end
    end

    return closestEnemy
end

-- Render Step for Silent Aim
game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotSettings:GetValue("Aimbot Enabled") then
        local closestEnemy = getClosestEnemy()
        if closestEnemy then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, closestEnemy.Character.HumanoidRootPart.Position)
        end
    end
end)
