local UILibrary = {}

-- Helper function to create UI elements
local function createUIElement(elementType, properties)
    local element = Instance.new(elementType)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

-- Create a ScreenGui
function UILibrary:CreateScreenGui()
    local screenGui = createUIElement("ScreenGui", {
        Name = "UILibraryScreenGui",
        ResetOnSpawn = false,
        Parent = game.CoreGui
    })
    return screenGui
end

-- Create a Frame
function UILibrary:CreateFrame(parent, title)
    local frame = createUIElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 400, 0, 600),
        Position = UDim2.new(0.5, -200, 0.5, -300),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = parent
    })

    local titleBar = createUIElement("TextLabel", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        Parent = frame
    })

    return frame
end

-- Create a Button
function UILibrary:CreateButton(parent, text, callback)
    local button = createUIElement("TextButton", {
        Name = "UIButton",
        Size = UDim2.new(0, 200, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        BorderSizePixel = 0,
        Parent = parent
    })

    button.MouseButton1Click:Connect(callback)
    return button
end

-- Create a Slider
function UILibrary:CreateSlider(parent, min, max, callback)
    local sliderFrame = createUIElement("Frame", {
        Name = "SliderFrame",
        Size = UDim2.new(0, 200, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Parent = parent
    })

    local slider = createUIElement("TextButton", {
        Name = "Slider",
        Size = UDim2.new(0, 20, 0, 50),
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        BorderSizePixel = 0,
        Parent = sliderFrame
    })

    slider.MouseButton1Down:Connect(function()
        local dragging = true

        local function updateInput(input)
            local scale = (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X
            scale = math.clamp(scale, 0, 1)
            slider.Position = UDim2.new(scale, -10, 0, 0)
            local value = math.floor(min + (max - min) * scale)
            callback(value)
        end

        updateInput(game:GetService("UserInputService"):GetMouseLocation())
        local connection
        connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateInput(input)
            end
        end)

        slider.MouseButton1Up:Connect(function()
            dragging = false
            connection:Disconnect()
        end)
    end)

    return sliderFrame
end

-- Create a Checkbox
function UILibrary:CreateCheckbox(parent, text, callback)
    local checkboxFrame = createUIElement("Frame", {
        Name = "CheckboxFrame",
        Size = UDim2.new(0, 200, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Parent = parent
    })

    local checkbox = createUIElement("TextButton", {
        Name = "Checkbox",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 15, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        BorderSizePixel = 0,
        Parent = checkboxFrame
    })

    local label = createUIElement("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0, 150, 0, 20),
        Position = UDim2.new(0, 45, 0.5, -10),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        Parent = checkboxFrame
    })

    local isChecked = false
    checkbox.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        checkbox.BackgroundColor3 = isChecked and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(100, 100, 100)
        callback(isChecked)
    end)

    return checkboxFrame
end

-- Create a Dropdown
function UILibrary:CreateDropdown(parent, options, callback)
    local dropdownFrame = createUIElement("Frame", {
        Name = "DropdownFrame",
        Size = UDim2.new(0, 200, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Parent = parent
    })

    local dropdownButton = createUIElement("TextButton", {
        Name = "DropdownButton",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Text = "Select...",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        BorderSizePixel = 0,
        Parent = dropdownFrame
    })

    local dropdownList = createUIElement("Frame", {
        Name = "DropdownList",
        Size = UDim2.new(1, 0, 0, #options * 50),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Visible = false,
        Parent = dropdownFrame
    })

    for i, option in ipairs(options) do
        local optionButton = createUIElement("TextButton", {
            Name = "OptionButton",
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Text = option,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.SourceSans,
            TextSize = 18,
            BorderSizePixel = 0,
            Parent = dropdownList
        })

        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            dropdownList.Visible = false
            callback(option)
        end)
    end

    dropdownButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)

    return dropdownFrame
end

return UILibrary
