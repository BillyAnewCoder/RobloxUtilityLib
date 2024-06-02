local customUILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/BillyAnewCoder/RobloxUtilityLib/main/NewLib.lua"))();

local Window = customUILib:CreateWindow(Enum.KeyCode.RightShift, "CustomUI Example");

local Tab = Window:CreateTab("Main");

local Section = Tab:CreateSector("Controls", "Left");

Section:CreateToggle("Auto Farm", false, function(enabled)
    print("Auto Farm:", enabled)
end)

Section:CreateButton("Load Settings", function()
    print("Settings Loaded")
end)

Section:CreateDropDown("Select Mode", {"Easy", "Medium", "Hard"}, "Easy", false, function(selected)
    print("Selected Mode:", selected)
end)

Section:CreateSlider("Speed", 0, 10, 100, 1, function(value)
    print("Speed:", value)
end)

Section:CreateColorPicker("Theme Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Selected Color:", color)
end)

Section:CreateKeyBind("Toggle UI", Enum.KeyCode.F, function(key)
    print("Key Bind:", key)
end)

Section:CreateTextBox("Player Name", "Enter Name", function(name)
    print("Player Name:", name)
end)

Section:CreateLabel("Custom UI Created by Your Name")

Section:CreateCopyText("https://yourdiscordlink.com")

Tab:CreateConfig("Right")
