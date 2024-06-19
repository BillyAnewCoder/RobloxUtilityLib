local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local silentAimEnabled = false
local wallbangEnabled = false
local teamCheckEnabled = false
local flyEnabled = false
local noclipEnabled = false

local function createDraggableFrame()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = frame
    
    frame.Parent = game.CoreGui
    return frame
end

local function createToggleButton(frame, text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 280, 0, 50)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.Parent = frame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = button

    button.MouseButton1Click:Connect(callback)
    return button
end

local function enableSilentAim()
    silentAimEnabled = not silentAimEnabled
    print("Silent Aim:", silentAimEnabled)
end

local function enableWallbang()
    wallbangEnabled = not wallbangEnabled
    print("Wallbang:", wallbangEnabled)
end

local function enableTeamCheck()
    teamCheckEnabled = not teamCheckEnabled
    print("Team Check:", teamCheckEnabled)
end

local function enableFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    else
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    print("Fly:", flyEnabled)
end

local function enableNoclip()
    noclipEnabled = not noclipEnabled
    print("Noclip:", noclipEnabled)
end

local function isPlayerOnTeam(player)
    return LocalPlayer.Team == player.Team
end

local function getClosestToCrosshair()
    local closestPlayer
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            if teamCheckEnabled and isPlayerOnTeam(player) then
                continue
            end
            local pos, onScreen = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

local function shootAt(target)
    if wallbangEnabled then
        local args = {
            [1] = target.Character.HumanoidRootPart.Position,
            [2] = LocalPlayer.Character.HumanoidRootPart.Position,
            [3] = Vector3.new(1, 0, 0)
        }
        workspace.RemoteEvent:FireServer(unpack(args))
    else
        -- Normal shooting logic
    end
end

local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if silentAimEnabled then
            local target = getClosestToCrosshair()
            if target then
                shootAt(target)
            end
        end
    end
end

local function main()
    local frame = createDraggableFrame()
    
    createToggleButton(frame, "Enable Silent Aim", UDim2.new(0, 10, 0, 10), enableSilentAim)
    createToggleButton(frame, "Enable Wallbang", UDim2.new(0, 10, 0, 70), enableWallbang)
    createToggleButton(frame, "Enable Team Check", UDim2.new(0, 10, 0, 130), enableTeamCheck)
    createToggleButton(frame, "Enable Fly", UDim2.new(0, 10, 0, 190), enableFly)
    createToggleButton(frame, "Enable Noclip", UDim2.new(0, 10, 0, 250), enableNoclip)

    UserInputService.InputBegan:Connect(onInputBegan)

    RunService.Stepped:Connect(function()
        if noclipEnabled then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        if flyEnabled then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
        end
    end)
end

main()
