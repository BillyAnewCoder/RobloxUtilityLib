local NezurLib = {}

function NezurLib:CreateWindow(Keybind, Name)
    local window = {}
    window.keybind = Keybind or Enum.KeyCode.RightShift
    window.name = Name or "Nezur"

    -- Create main UI elements
    window.ScreenGui = Instance.new("ScreenGui")
    window.ScreenGui.Parent = game.CoreGui
    window.ScreenGui.ResetOnSpawn = false

    window.Main = Instance.new("Frame", window.ScreenGui)
    window.Main.Size = UDim2.new(0, 500, 0, 400)
    window.Main.Position = UDim2.new(0.5, -250, 0.5, -200)
    window.Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    window.Main.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner", window.Main)
    UICorner.CornerRadius = UDim.new(0, 12)

    window.Tabs = {}

    function window:CreateTab(Name)
        local tab = {}
        tab.Name = Name or "Tab"

        tab.TabButton = Instance.new("TextButton", window.Main)
        tab.TabButton.Size = UDim2.new(0, 100, 0, 30)
        tab.TabButton.Position = UDim2.new(#window.Tabs * 0.2, 0, 0, 0)
        tab.TabButton.Text = Name
        tab.TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tab.TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab.TabButton.BorderSizePixel = 0

        tab.Content = Instance.new("Frame", window.Main)
        tab.Content.Size = UDim2.new(1, 0, 1, -30)
        tab.Content.Position = UDim2.new(0, 0, 0, 30)
        tab.Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tab.Content.Visible = false
        tab.Content.BorderSizePixel = 0

        tab.TabButton.MouseButton1Click:Connect(function()
            for _, otherTab in ipairs(window.Tabs) do
                otherTab.Content.Visible = false
            end
            tab.Content.Visible = true
        end)

        table.insert(window.Tabs, tab)
        return tab
    end

    function window:CreateToggle(tab, Name, Default, Callback)
        local toggle = {}
        toggle.Name = Name or "Toggle"
        toggle.State = Default or false
        toggle.Callback = Callback or function() end

        toggle.Button = Instance.new("TextButton", tab.Content)
        toggle.Button.Size = UDim2.new(0, 200, 0, 30)
        toggle.Button.Position = UDim2.new(0, 10, 0, #tab.Content:GetChildren() * 35)
        toggle.Button.Text = Name
        toggle.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        toggle.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.Button.BorderSizePixel = 0

        toggle.Button.MouseButton1Click:Connect(function()
            toggle.State = not toggle.State
            toggle.Callback(toggle.State)
        end)

        return toggle
    end

    return window
end

-- Usage Example
local Window = NezurLib:CreateWindow(Enum.KeyCode.RightShift, "Nezur Example")

local AimbotTab = Window:CreateTab("Aimbot")
local SettingsTab = Window:CreateTab("Settings")

local toggle = Window:CreateToggle(AimbotTab, "Enable Aimbot", false, function(state)
    print("Aimbot Enabled: ", state)
end)

return NezurLib
