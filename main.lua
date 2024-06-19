-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration
local Config = {
    SilentAimEnabled = false,
    WallbangEnabled = false,
    TeamCheckEnabled = false,
    Keybinds = {
        ToggleSilentAim = Enum.KeyCode.Z,
        ToggleWallbang = Enum.KeyCode.X,
        ToggleTeamCheck = Enum.KeyCode.C
    }
}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local DragFrame = Instance.new("Frame")
local EnableSilentAim = Instance.new("TextButton")
local EnableWallbang = Instance.new("TextButton")
local EnableTeamCheck = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
MainFrame.Size = UDim2.new(0, 200, 0, 250)

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

DragFrame.Parent = MainFrame
DragFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DragFrame.Size = UDim2.new(1, 0, 0, 30)

local function createButton(button, text, position)
    button.Parent = MainFrame
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Position = position
    button.Size = UDim2.new(0.8, 0, 0.1, 0)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
end

createButton(EnableSilentAim, "Enable Silent Aim", UDim2.new(0.1, 0, 0.2, 0))
createButton(EnableWallbang, "Enable Wallbang", UDim2.new(0.1, 0, 0.35, 0))
createButton(EnableTeamCheck, "Enable Team Check", UDim2.new(0.1, 0, 0.5, 0))

EnableSilentAim.MouseButton1Click:Connect(function()
    Config.SilentAimEnabled = not Config.SilentAimEnabled
    EnableSilentAim.Text = Config.SilentAimEnabled and "Disable Silent Aim" or "Enable Silent Aim"
end)

EnableWallbang.MouseButton1Click:Connect(function()
    Config.WallbangEnabled = not Config.WallbangEnabled
    EnableWallbang.Text = Config.WallbangEnabled and "Disable Wallbang" or "Enable Wallbang"
end)

EnableTeamCheck.MouseButton1Click:Connect(function()
    Config.TeamCheckEnabled = not Config.TeamCheckEnabled
    EnableTeamCheck.Text = Config.TeamCheckEnabled and "Disable Team Check" or "Enable Team Check"
end)

-- Make GUI draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

DragFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

DragFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Utility function to check if a player is on the same team
local function IsOnSameTeam(player1, player2)
    return player1.Team == player2.Team
end

-- Silent aim function
local function SilentAim()
    if not Config.SilentAimEnabled then return end

    local mouse = LocalPlayer:GetMouse()
    local target = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and (not Config.TeamCheckEnabled or not IsOnSameTeam(LocalPlayer, player)) then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local screenPoint = Camera:WorldToScreenPoint(character.HumanoidRootPart.Position)
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    target = player
                end
            end
        end
    end

    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        -- Manipulate the hit detection to target the selected player's HumanoidRootPart
        mouse.Target = target.Character.HumanoidRootPart
    end
end

-- Wallbang functionality
local function Wallbang()
    if not Config.WallbangEnabled then return end

    -- Custom raycast logic to bypass walls
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}

    Workspace:Raycast = function(origin, direction, ...)
        local result = Workspace:Raycast(origin, direction, raycastParams)
        if result and result.Instance and not result.Instance.CanCollide then
            -- If the hit part is not collidable, continue the raycast
            return Workspace:Raycast(result.Position, direction, ...)
        end
        return result
    end
end

-- Main loop for Silent Aim and Wallbang
RunService.RenderStepped:Connect(function()
    SilentAim()
    Wallbang()
end)

-- Input handling for toggling features
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Config.Keybinds.ToggleSilentAim then
        Config.SilentAimEnabled = not Config.SilentAimEnabled
    elseif input.KeyCode == Config.Keybinds.ToggleWallbang then
        Config.WallbangEnabled = not Config.WallbangEnabled
    elseif input.KeyCode == Config.Keybinds.ToggleTeamCheck then
        Config.TeamCheckEnabled = not Config.TeamCheckEnabled
    end
end)
