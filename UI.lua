local Library = {}

-- Utility Functions
function Library:SafeCallback(func, ...)
    if func then
        local success, result = pcall(func, ...)
        if not success then
            warn("Callback error: ", result)
        end
        return result
    end
end

function Library:GetPlayersString()
    local players = game:GetService('Players')
    local playerNames = {}
    for _, player in pairs(players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    return table.concat(playerNames, ", ")
end

function Library:GetTeamsString()
    local teams = game:GetService('Teams')
    local teamNames = {}
    for _, team in pairs(teams:GetTeams()) do
        table.insert(teamNames, team.Name)
    end
    return table.concat(teamNames, ", ")
end

function Library:MakeDraggable(frame)
    -- Implementation of draggable frame
end

function Library:ApplyTextStroke(textObject)
    -- Implementation of text stroke application
end

function Library:AddToolTip(object, text)
    -- Implementation of tooltip
end

function Library:GetDarkerColor(color)
    -- Implementation to get darker color
end

function Library:MapValue(value, inMin, inMax, outMin, outMax)
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

-- Toggles Class
Library.Toggles = {}
Library.Toggles.__index = Library.Toggles

-- Options Class
Library.Options = {}
Library.Options.__index = Library.Options

-- Library Class
Library.Library = {}
Library.Library.__index = Library.Library

-- Example Toggle Implementation
Library.Toggles.Toggle = {}
Library.Toggles.Toggle.__index = Library.Toggles.Toggle

function Library.Toggles.Toggle.new(parent, text, callback)
    local self = setmetatable({}, Library.Toggles.Toggle)
    self.Frame = Instance.new("Frame", parent)
    self.Frame.Size = UDim2.new(0, 100, 0, 50)
    self.Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    
    self.Button = Instance.new("TextButton", self.Frame)
    self.Button.Size = UDim2.new(1, -4, 1, -4)
    self.Button.Position = UDim2.new(0, 2, 0, 2)
    self.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Button.Text = text
    
    self.Button.MouseButton1Click:Connect(function()
        self.Value = not self.Value
        self.Button.BackgroundColor3 = self.Value and Color3.fromRGB(0, 85, 255) or Color3.fromRGB(20, 20, 20)
        Library:SafeCallback(callback, self.Value)
    end)
    
    return self
end

-- More class implementations would follow the same pattern...

-- CreateWindow example function
function Library:CreateWindow(title)
    local window = {}
    window.Frame = Instance.new("Frame", game:GetService("CoreGui"))
    window.Frame.Size = UDim2.new(0, 300, 0, 400)
    window.Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    
    window.Title = Instance.new("TextLabel", window.Frame)
    window.Title.Size = UDim2.new(1, 0, 0, 30)
    window.Title.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
    window.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.Title.Text = title
    window.Title.TextScaled = true
    
    Library:MakeDraggable(window.Frame)
    
    return window
end

-- Example use
local mainWindow = Library:CreateWindow("Main Window")

local toggle = Library.Toggles.Toggle.new(mainWindow.Frame, "Feature Toggle", function(state)
    print("Toggle state:", state)
end)

return Library
