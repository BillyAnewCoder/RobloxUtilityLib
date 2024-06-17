-- Custom UI Library
local Library = {}
Library.__index = Library

-- Initialize the library
function Library:Init()
    local self = setmetatable({}, Library)
    
    -- Create the main UI screen
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CustomUILib"
    self.ScreenGui.Parent = game.CoreGui
    
    -- Create main frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 800, 0, 600)
    self.MainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.MainFrame.Parent = self.ScreenGui
    
    -- Create title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.Text = "Custom UI Library"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 20
    Title.Parent = self.MainFrame
    
    -- Create tabs frame
    self.TabsFrame = Instance.new("Frame")
    self.TabsFrame.Name = "TabsFrame"
    self.TabsFrame.Size = UDim2.new(0.2, 0, 1, -30)
    self.TabsFrame.Position = UDim2.new(0, 0, 0, 30)
    self.TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.TabsFrame.Parent = self.MainFrame
    
    -- Create content frame
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(0.8, 0, 1, -30)
    self.ContentFrame.Position = UDim2.new(0.2, 0, 0, 30)
    self.ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.ContentFrame.Parent = self.MainFrame
    
    -- Store tabs
    self.Tabs = {}
    return self
end

-- Add a tab
function Library:AddTab(name)
    local Tab = {}
    Tab.Name = name
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = name
    Tab.Button.Size = UDim2.new(1, 0, 0, 30)
    Tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tab.Button.Text = name
    Tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab.Button.Font = Enum.Font.SourceSansBold
    Tab.Button.TextSize = 18
    Tab.Button.Parent = self.TabsFrame
    
    Tab.Content = Instance.new("ScrollingFrame")
    Tab.Content.Name = name
    Tab.Content.Size = UDim2.new(1, 0, 1, 0)
    Tab.Content.CanvasSize = UDim2.new(0, 0, 1, 0)
    Tab.Content.BackgroundTransparency = 1
    Tab.Content.Visible = false
    Tab.Content.Parent = self.ContentFrame
    
    -- Create a UIListLayout for the content
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = Tab.Content
    
    -- Add button click event
    Tab.Button.MouseButton1Click:Connect(function()
        self:ShowTab(name)
    end)
    
    -- Store tab
    self.Tabs[name] = Tab
    return Tab
end

-- Show a tab
function Library:ShowTab(name)
    for _, Tab in pairs(self.Tabs) do
        Tab.Content.Visible = false
    end
    self.Tabs[name].Content.Visible = true
end

-- Add a section to a tab
function Library:AddSection(tabName, sectionName)
    local Section = {}
    Section.Name = sectionName
    Section.Frame = Instance.new("Frame")
    Section.Frame.Name = sectionName
    Section.Frame.Size = UDim2.new(1, 0, 0, 100)
    Section.Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Section.Frame.Parent = self.Tabs[tabName].Content
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = sectionName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.Parent = Section.Frame
    
    -- Create a UIListLayout for the section
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = Section.Frame
    
    -- Store section
    if not self.Tabs[tabName].Sections then
        self.Tabs[tabName].Sections = {}
    end
    self.Tabs[tabName].Sections[sectionName] = Section
    return Section
end

-- Add a toggle button to a section
function Library:AddToggleButton(tabName, sectionName, name, default, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = name
    ToggleButton.Size = UDim2.new(1, 0, 0, 30)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.Text = name
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 18
    ToggleButton.Parent = self.Tabs[tabName].Sections[sectionName].Frame
    
    local enabled = default
    
    local function updateButton()
        if enabled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        callback(enabled)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateButton()
    end)
    
    updateButton()
end

-- Add ESP preview pane
function Library:AddESPPreview()
    local ESPPreview = Instance.new("Frame")
    ESPPreview.Name = "ESPPreview"
    ESPPreview.Size = UDim2.new(0.8, 0, 0, 150)
    ESPPreview.Position = UDim2.new(0.2, 0, 1, -180)
    ESPPreview.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ESPPreview.Parent = self.MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = "ESP Preview"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.Parent = ESPPreview

    -- Placeholder for actual ESP preview
    local ESPBox = Instance.new("Frame")
    ESPBox.Name = "ESPBox"
    ESPBox.Size = UDim2.new(0, 100, 0, 100)
    ESPBox.Position = UDim2.new(0.5, -50, 0.5, -50)
    ESPBox.BackgroundTransparency = 1
    ESPBox.BorderSizePixel = 2
    ESPBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
    ESPBox.Parent = ESPPreview

    -- Example ESP preview (replace with actual drawing logic)
    local function drawPreview()
        -- Clear previous drawings
        for _, child in ipairs(ESPBox:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        -- Example ESP preview
        for i = 1, 4 do
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(0, 2, 0, 50)
            Line.Position = UDim2.new(0.5, -1, 0.5, -25)
            Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Line.Rotation = i * 90
            Line.Parent = ESPBox
        end
    end
    
    drawPreview()
end

-- Initialize library
local UILibrary = Library:Init()

-- Create tabs
local MainTab = UILibrary:AddTab("Main")
local SettingsTab = UILibrary:AddTab("Settings")

-- Create sections
local ESPSection = UILibrary:AddSection("Main", "ESP Settings")
local GeneralSection = UILibrary:AddSection("Settings", "General Settings")

-- Add ESP preview pane
UILibrary:AddESPPreview()

-- Utility function to create ESP boxes
local function createESPBox(player)
    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Create ESP box
    local ESPBox = Drawing.new("Square")
    ESPBox.Visible = true
    ESPBox.Color = Color3.fromRGB(255, 255, 255)
    ESPBox.Thickness = 2
    ESPBox.Transparency = 1

    local function update()
        if not character or not character.Parent then
            ESPBox.Visible = false
            ESPBox:Remove()
            return
        end

        local rootPosition, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
        if onScreen then
            ESPBox.Size = Vector2.new(4, 7) * (workspace.CurrentCamera.ViewportSize.Y / rootPosition.Z)
            ESPBox.Position = Vector2.new(rootPosition.X - ESPBox.Size.X / 2, rootPosition.Y - ESPBox.Size.Y / 2)
            ESPBox.Visible = true
        else
            ESPBox.Visible = false
        end
    end

    game:GetService("RunService").RenderStepped:Connect(update)
end

-- Add a toggle button for ESP
UILibrary:AddToggleButton("Main", "ESP Settings", "Enable ESP", false, function(enabled)
    if enabled then
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createESPBox(player)
            end
        end

        game:GetService("Players").PlayerAdded:Connect(function(player)
            createESPBox(player)
        end)
    end
end)

-- Add another toggle button as an example
UILibrary:AddToggleButton("Settings", "General Settings", "Toggle Option", true, function(value)
    print("Option Toggled:", value)
end)

-- Show the main tab by default
UILibrary:ShowTab("Main")

-- Initialize ESP preview pane
UILibrary:AddESPPreview()

return Library
