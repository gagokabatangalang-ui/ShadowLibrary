-- ShadowExample.lua
-- Example usage of Shadow Library
-- Created by ShadowDeath23

local Shadow = loadstring(game:HttpGet("https://raw.githubusercontent.com/ShadowDeath23/shadow-library/main/ShadowLibrary.lua"))()
-- Or if local: local Shadow = require(path.to.ShadowLibrary)

-- Initialize
Shadow:Init()

-- KEY SYSTEM (Optional - remove if you don't want it)
local KeySystem = Shadow:CreateKeySystem({
    Title = "Shadow Library",
    Description = "Enter your key to access Shadow Library",
    Logo = "rbxassetid://115418924219428",
    KeyLink = "https://discord.gg/yourserver", -- Link to get key
    Keys = {"SHADOW-1234-ABCD", "FREE-KEY-2026"}, -- Valid keys
    -- Or use custom validation:
    -- KeyCheck = function(key) return key == "secret" end,
    OnSuccess = function()
        -- This runs after key is validated
        loadMainUI()
    end
})

-- Main UI function (called after key validation)
function loadMainUI()
    -- Create window
    local Window = Shadow:CreateWindow({
        Name = "Shadow Library",
        Credit = "Created by ShadowDeath23",
        Theme = "Shadow", -- Shadow, Midnight, Crimson, Ocean, Emerald
        Logo = "rbxassetid://115418924219428"
    })

    -- Create tabs
    local MainTab = Window:CreateTab({Name = "Main", Icon = "🏠"})
    local VisualsTab = Window:CreateTab({Name = "Visuals", Icon = "👁"})
    local SettingsTab = Window:CreateTab({Name = "Settings", Icon = "⚙"})
    local ColorsTab = Window:CreateTab({Name = "Colors", Icon = "🎨"})

    -- Main Tab Elements
    MainTab:CreateSection({Text = "Features"})

    MainTab:CreateButton({
        Name = "Click Me!",
        Callback = function()
            Shadow:Notify({
                Title = "Button Clicked",
                Message = "You clicked the button!",
                Type = "Success",
                Duration = 3
            })
        end
    })

    MainTab:CreateToggle({
        Name = "Auto Farm",
        Default = false,
        Callback = function(state)
            Shadow:Notify({
                Title = "Auto Farm",
                Message = state and "Auto Farm Enabled" or "Auto Farm Disabled",
                Type = state and "Success" or "Info",
                Duration = 2
            })
        end
    })

    MainTab:CreateSlider({
        Name = "Speed Multiplier",
        Min = 1,
        Max = 10,
        Default = 1,
        Callback = function(value)
            print("Speed set to:", value)
        end
    })

    MainTab:CreateDropdown({
        Name = "Select Mode",
        Options = {"Legit", "Rage", "Silent"},
        Callback = function(option)
            Shadow:Notify({
                Title = "Mode Changed",
                Message = "Selected mode: " .. option,
                Type = "Info",
                Duration = 2
            })
        end
    })

    MainTab:CreateLabel({
        Text = "Welcome to Shadow Library v1.0.0",
        Color = Color3.fromRGB(200, 200, 200)
    })

    -- Visuals Tab
    VisualsTab:CreateSection({Text = "Visual Options"})

    VisualsTab:CreateToggle({
        Name = "ESP Enabled",
        Default = false,
        Callback = function(state)
            print("ESP:", state)
        end
    })

    VisualsTab:CreateDropdown({
        Name = "ESP Style",
        Options = {"Boxes", "Chams", "Skeleton", "Glow"},
        Callback = function(option)
            print("ESP Style:", option)
        end
    })

    VisualsTab:CreateSlider({
        Name = "ESP Range",
        Min = 100,
        Max = 5000,
        Default = 1000,
        Callback = function(value)
            print("ESP Range:", value)
        end
    })

    -- Settings Tab
    SettingsTab:CreateSection({Text = "Configuration"})

    SettingsTab:CreateToggle({
        Name = "Show FPS",
        Default = true,
        Callback = function(state)
            print("FPS Counter:", state)
        end
    })

    SettingsTab:CreateToggle({
        Name = "Anti-AFK",
        Default = false,
        Callback = function(state)
            print("Anti-AFK:", state)
        end
    })

    SettingsTab:CreateSlider({
        Name = "UI Transparency",
        Min = 0,
        Max = 100,
        Default = 85,
        Callback = function(value)
            print("Transparency:", value .. "%")
        end
    })

    -- Colors Tab - Color Picker Demo
    ColorsTab:CreateSection({Text = "Color Customization"})

    ColorsTab:CreateColorPicker({
        Name = "Accent Color",
        Default = Color3.fromRGB(120, 80, 200),
        Callback = function(color)
            print("Selected accent color:", color)
            -- You can apply this to your UI elements
        end
    })

    ColorsTab:CreateColorPicker({
        Name = "ESP Color",
        Default = Color3.fromRGB(255, 0, 0),
        Callback = function(color)
            print("Selected ESP color:", color)
        end
    })

    ColorsTab:CreateColorPicker({
        Name = "Chams Color",
        Default = Color3.fromRGB(0, 255, 255),
        Callback = function(color)
            print("Selected chams color:", color)
        end
    })

    -- Initial notification
    Shadow:Notify({
        Title = "Shadow Library Loaded",
        Message = "Welcome ShadowDeath23 | Shadow Library v1.0.0",
        Type = "Success",
        Duration = 5
    })

    print("[Shadow Library] Loaded successfully by ShadowDeath23!")
end

-- If not using key system, uncomment below:
-- loadMainUI()
