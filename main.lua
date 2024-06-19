-- Load required services
local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService")
}
local Camera = workspace.CurrentCamera

-- Initialize variables
local localPlayer = Services.Players.LocalPlayer
local mouse = localPlayer:GetMouse()
local settings = {
    silentAim = false,
    wallbang = false,
    teamCheck = false
}

-- Obfuscation helper
local function obscure(str)
    return str:gsub(".", function(c)
        return "\\" .. c:byte()
    end)
end

-- Randomized function and variable names
local function createGui()
    local gui = Instance.new(obscure("ScreenGui"))
    gui.Parent = localPlayer:WaitForChild(obscure("PlayerGui"))
    gui.ResetOnSpawn = false

    local frame = Instance.new(obscure("Frame"))
    frame.Size = UDim2.new(0, 200, 0, 300)
    frame.Position = UDim2.new(0.5, -100, 0.5, -150)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new(obscure("UICorner"))
    corner.Parent = frame

    local function createButton(text, position, callback)
        local button = Instance.new(obscure("TextButton"))
        button.Size = UDim2.new(0, 180, 0, 30)
        button.Position = UDim2.new(0, 10, 0, position)
        button.BackgroundTransparency = 0.5
        button.BackgroundColor3 = Color3.new(1, 1, 1)
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Color3.new(0, 0, 0)
        button.Parent = frame
        button.MouseButton1Click:Connect(callback)
        local corner = Instance.new(obscure("UICorner"))
        corner.Parent = button
        return button
    end

    createButton(obscure("Enable Silent Aim"), 10, function()
        settings.silentAim = not settings.silentAim
    end)

    createButton(obscure("Enable Wallbang"), 50, function()
        settings.wallbang = not settings.wallbang
    end)

    createButton(obscure("Enable Team Check"), 90, function()
        settings.teamCheck = not settings.teamCheck
    end)

    createButton(obscure("Enable Fly"), 130, function()
        -- Fly logic here
    end)

    createButton(obscure("Enable Noclip"), 170, function()
        -- Noclip logic here
    end)

    return frame
end

local frame = createGui()

-- Silent Aim logic
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild(obscure("HumanoidRootPart")) then
            if settings.teamCheck and player.Team == localPlayer.Team then
                continue
            end
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    return closestPlayer
end

-- User Input Handling
Services.UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if settings.silentAim then
            local targetPlayer = getClosestPlayer()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(obscure("HumanoidRootPart")) then
                -- Silent Aim Logic
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
            end
        end
        if settings.wallbang then
            -- Wallbang Logic
            local hit = mouse.Target
            if hit and hit.Parent and hit.Parent:FindFirstChild(obscure("Humanoid")) then
                local bullet = Instance.new(obscure("Part"))
                bullet.Size = Vector3.new(0.2, 0.2, 0.2)
                bullet.Position = localPlayer.Character.Head.Position
                bullet.Velocity = (hit.Position - localPlayer.Character.Head.Position).unit * 500
                bullet.Parent = workspace
            end
        end
    end
end)

-- Make the GUI draggable
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

Services.UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
