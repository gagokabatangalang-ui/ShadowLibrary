# Shadow Library

A Glass Fluent UI Library for Roblox, inspired by Luna Library.

## Created by ShadowDeath23

## Features

- **Glass Fluent Design** - Modern, sleek UI with glass morphism effects
- **Smooth Animations** - Spring physics and tween-based animations
- **5 Built-in Themes** - Shadow, Midnight, Crimson, Ocean, Emerald
- **Mobile Support** - Touch-friendly with drag support
- **Modular System** - Clean, separated module files
- **Custom Elements** - Buttons, Toggles, Sliders, Dropdowns, Labels, Sections, Color Pickers
- **Notification System** - Beautiful toast notifications with progress bars
- **Key System** - Built-in key validation with custom callbacks
- **Minimize Icon** - Your logo shows as floating icon when minimized
- **Webhook Ready** - Built-in webhook integration support

## Files

| File | Description |
|------|-------------|
| `ShadowLibrary.lua` | Main loader and utility functions |
| `ShadowWindow.lua` | Window, tabs, logo, minimize icon, all UI elements |
| `ShadowNotify.lua` | Notification/toast system |
| `ShadowTheme.lua` | Theme presets and manager |
| `ShadowKeySystem.lua` | Key validation system |
| `ShadowExample.lua` | Example usage with all features |

## Key System Usage

```lua
local Shadow = require(path.to.ShadowLibrary)
Shadow:Init()

local KeySystem = Shadow:CreateKeySystem({
    Title = "Your Script",
    Description = "Enter key to continue",
    Logo = "rbxassetid://115418924219428",
    KeyLink = "https://discord.gg/yourserver",
    Keys = {"KEY-1234-ABCD", "FREE-KEY"},
    OnSuccess = function()
        -- Load your main UI here
        local Window = Shadow:CreateWindow({...})
    end
})
```

## Color Picker Usage

```lua
Tab:CreateColorPicker({
    Name = "Pick Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Selected:", color)
    end
})
```

## Logo / Minimize Icon

Set your logo in window options:
```lua
local Window = Shadow:CreateWindow({
    Name = "Your Script",
    Logo = "rbxassetid://115418924219428", -- Your logo asset ID
    Credit = "Created by ShadowDeath23"
})
```

When minimized, your logo appears as a floating draggable icon.

## Themes

- **Shadow** (Default) - Purple accent, dark background
- **Midnight** - Blue accent, deep dark
- **Crimson** - Red accent, warm dark
- **Ocean** - Cyan accent, cool dark
- **Emerald** - Green accent, nature dark

## Credits

Created by ShadowDeath23
Logo by ShadowDeath23

Version 1.0.0
