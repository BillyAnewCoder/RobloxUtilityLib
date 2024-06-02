local NewLib = {}

function NewLib:CreateWindow(toggleKey, windowName)
    local window = {}
    window.tabs = {}
    window.toggleKey = toggleKey
    window.name = windowName
    
    function window:CreateTab(tabName)
        local tab = {}
        tab.sectors = {}
        tab.name = tabName
        
        function tab:CreateSector(sectorName, position)
            local sector = {}
            sector.elements = {}
            sector.name = sectorName
            sector.position = position
            
            function sector:CreateToggle(toggleName, default, callback)
                table.insert(sector.elements, {type = "Toggle", name = toggleName, default = default, callback = callback})
            end
            
            function sector:CreateButton(buttonName, callback)
                table.insert(sector.elements, {type = "Button", name = buttonName, callback = callback})
            end
            
            function sector:CreateDropDown(dropDownName, options, default, multiSelect, callback)
                table.insert(sector.elements, {type = "DropDown", name = dropDownName, options = options, default = default, multiSelect = multiSelect, callback = callback})
            end
            
            function sector:CreateSlider(sliderName, min, default, max, decimals, callback)
                table.insert(sector.elements, {type = "Slider", name = sliderName, min = min, default = default, max = max, decimals = decimals, callback = callback})
            end
            
            function sector:CreateColorPicker(colorPickerName, default, callback)
                table.insert(sector.elements, {type = "ColorPicker", name = colorPickerName, default = default, callback = callback})
            end
            
            function sector:CreateKeyBind(keyBindName, keyCode, callback)
                table.insert(sector.elements, {type = "KeyBind", name = keyBindName, keyCode = keyCode, callback = callback})
            end
            
            function sector:CreateTextBox(textBoxName, default, callback)
                table.insert(sector.elements, {type = "TextBox", name = textBoxName, default = default, callback = callback})
            end
            
            function sector:CreateLabel(labelText)
                table.insert(sector.elements, {type = "Label", text = labelText})
            end
            
            function sector:CreateCopyText(copyText)
                table.insert(sector.elements, {type = "CopyText", text = copyText})
            end
            
            table.insert(tab.sectors, sector)
            return sector
        end
        
        function tab:CreateConfig(position)
            table.insert(window.tabs, {type = "Config", position = position})
        end
        
        table.insert(window.tabs, tab)
        return tab
    end
    
    return window
end

return NewLib
