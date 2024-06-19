-- UI Library
local UILibrary = {}

function UILibrary:CreateControlDot(color, position)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 15, 0, 15)
    dot.Position = position
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    return dot
end

-- Create Window
function UILibrary:CreateWindow(name, size)
    local window = {}
    window.Name = name
    window.Size = size or UDim2.new(0, 600, 0, 400)
    window.Frame = Instance.new("Frame")
    window.Frame.Size = window.Size
    window.Frame.Position = UDim2.new(0.5, -window.Size.X.Offset / 2, 0.5, -window.Size.Y.Offset / 2)
    window.Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    window.Frame.BackgroundTransparency = 0.1
    window.Frame.BorderSizePixel = 0
    window.Frame.Active = true
    window.Frame.Draggable = true

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window.Frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 60, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local redDot = self:CreateControlDot(Color3.fromRGB(255, 0, 0), UDim2.new(0, 10, 0.5, -7.5))
    redDot.Parent = titleBar

    local orangeDot = self:CreateControlDot(Color3.fromRGB(255, 165, 0), UDim2.new(0, 30, 0.5, -7.5))
    orangeDot.Parent = titleBar

    local greenDot = self:CreateControlDot(Color3.fromRGB(0, 255, 0), UDim2.new(0, 50, 0.5, -7.5))
    greenDot.Parent = titleBar

    window.Tabs = {}
    window.Sectors = {}

    function window:CreateTab(name)
        local tab = {}
        tab.Name = name
        tab.Button = Instance.new("TextButton")
        tab.Button.Size = UDim2.new(1, -10, 0, 40)
        tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tab.Button.Text = ""
        tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab.Button.Font = Enum.Font.SourceSansBold
        tab.Button.TextSize = 20
        tab.Button.BorderSizePixel = 0

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 24, 0, 24)
        icon.Position = UDim2.new(0, 5, 0.5, -12)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://6023426915" -- Placeholder icon
        icon.Parent = tab.Button

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -34, 1, 0)
        label.Position = UDim2.new(0, 34, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 20
        label.Parent = tab.Button

        function tab:SelectTab()
            for _, t in pairs(window.Tabs) do
                t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            tab.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end

        tab.Button.MouseButton1Click:Connect(tab.SelectTab)
        window.Tabs[#window.Tabs + 1] = tab
        return tab
    end

    function window:CreateSector(name)
        local sector = {}
        sector.Name = name
        sector.Frame = Instance.new("Frame")
        sector.Frame.Size = UDim2.new(1, -20, 0, 30)
        sector.Frame.Position = UDim2.new(0, 10, 0, #window.Sectors * 35 + 10)
        sector.Frame.BackgroundTransparency = 1

        local sectorLabel = Instance.new("TextLabel")
        sectorLabel.Size = UDim2.new(0.8, 0, 1, 0)
        sectorLabel.Position = UDim2.new(0, 0, 0, 0)
        sectorLabel.BackgroundTransparency = 1
        sectorLabel.Text = name
        sectorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sectorLabel.Font = Enum.Font.SourceSans
        sectorLabel.TextSize = 18
        sectorLabel.Parent = sector.Frame

        function sector:CreateToggle(name, callback)
            local toggle = {}
            toggle.Name = name
            toggle.Button = Instance.new("TextButton")
            toggle.Button.Size = UDim2.new(0.3, 0, 1, 0)
            toggle.Button.Position = UDim2.new(0.7, 0, 0, 0)
            toggle.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggle.Button.Text = "Off"
            toggle.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Button.Font = Enum.Font.SourceSans
            toggle.Button.TextSize = 18
            toggle.Button.Parent = sector.Frame

            function toggle:Set(value)
                if value then
                    toggle.Button.Text = "On"
                    toggle.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                else
                    toggle.Button.Text = "Off"
                    toggle.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end
                if callback then
                    callback(value)
                end
            end

            toggle.Button.MouseButton1Click:Connect(function()
                if toggle.Button.Text == "Off" then
                    toggle:Set(true)
                else
                    toggle:Set(false)
                end
            end)

            sector.Frame.Size = UDim2.new(1, -20, 0, #sector.Frame:GetChildren() * 35 + 10)
            return toggle
        end

        window.Sectors[#window.Sectors + 1] = sector
        return sector
    end

    return window
end

-- Example Usage
local ui = UILibrary:CreateWindow("ModSys")
ui.Frame.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local tab1 = ui:CreateTab("Silent Aim")
local sector1 = ui:CreateSector("Settings")
sector1:CreateToggle("Enabled")
sector1:CreateToggle("Ignore Friends")
sector1:CreateToggle("Ignore NPC")

local tab2 = ui:CreateTab("AimBot")
local sector2 = ui:CreateSector("Settings")
sector2:CreateToggle("Enabled")
sector2:CreateToggle("Silent Aim")
sector2:CreateToggle("Auto Shoot")

