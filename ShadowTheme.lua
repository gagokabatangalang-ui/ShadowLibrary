-- ShadowTheme.lua
-- Theme manager for Shadow Library

local ShadowTheme = {}

ShadowTheme.Presets = {
    Shadow = {
        Background = Color3.fromRGB(15, 15, 20),
        GlassBackground = Color3.fromRGB(25, 25, 35),
        GlassBorder = Color3.fromRGB(40, 40, 55),
        Accent = Color3.fromRGB(120, 80, 200),
        AccentLight = Color3.fromRGB(150, 110, 230),
        TextPrimary = Color3.fromRGB(240, 240, 245),
        TextSecondary = Color3.fromRGB(160, 160, 170),
        TextDark = Color3.fromRGB(100, 100, 110),
        Success = Color3.fromRGB(80, 200, 120),
        Error = Color3.fromRGB(200, 80, 80),
        Warning = Color3.fromRGB(230, 180, 60),
        Shadow = Color3.fromRGB(0, 0, 0),
        GlassTransparency = 0.15,
        BorderTransparency = 0.6
    },

    Midnight = {
        Background = Color3.fromRGB(10, 10, 18),
        GlassBackground = Color3.fromRGB(20, 20, 30),
        GlassBorder = Color3.fromRGB(35, 35, 50),
        Accent = Color3.fromRGB(80, 120, 220),
        AccentLight = Color3.fromRGB(110, 150, 250),
        TextPrimary = Color3.fromRGB(230, 230, 240),
        TextSecondary = Color3.fromRGB(150, 150, 165),
        TextDark = Color3.fromRGB(90, 90, 105),
        Success = Color3.fromRGB(70, 190, 110),
        Error = Color3.fromRGB(190, 70, 70),
        Warning = Color3.fromRGB(220, 170, 50),
        Shadow = Color3.fromRGB(0, 0, 0),
        GlassTransparency = 0.12,
        BorderTransparency = 0.55
    },

    Crimson = {
        Background = Color3.fromRGB(20, 10, 12),
        GlassBackground = Color3.fromRGB(35, 20, 22),
        GlassBorder = Color3.fromRGB(55, 30, 35),
        Accent = Color3.fromRGB(200, 60, 80),
        AccentLight = Color3.fromRGB(230, 90, 110),
        TextPrimary = Color3.fromRGB(245, 230, 230),
        TextSecondary = Color3.fromRGB(175, 155, 155),
        TextDark = Color3.fromRGB(115, 95, 95),
        Success = Color3.fromRGB(80, 200, 120),
        Error = Color3.fromRGB(220, 60, 60),
        Warning = Color3.fromRGB(230, 180, 60),
        Shadow = Color3.fromRGB(0, 0, 0),
        GlassTransparency = 0.15,
        BorderTransparency = 0.6
    },

    Ocean = {
        Background = Color3.fromRGB(10, 15, 20),
        GlassBackground = Color3.fromRGB(18, 28, 35),
        GlassBorder = Color3.fromRGB(30, 45, 55),
        Accent = Color3.fromRGB(60, 180, 200),
        AccentLight = Color3.fromRGB(90, 210, 230),
        TextPrimary = Color3.fromRGB(230, 240, 245),
        TextSecondary = Color3.fromRGB(150, 165, 175),
        TextDark = Color3.fromRGB(90, 105, 115),
        Success = Color3.fromRGB(80, 200, 120),
        Error = Color3.fromRGB(200, 80, 80),
        Warning = Color3.fromRGB(230, 180, 60),
        Shadow = Color3.fromRGB(0, 0, 0),
        GlassTransparency = 0.12,
        BorderTransparency = 0.55
    },

    Emerald = {
        Background = Color3.fromRGB(10, 18, 12),
        GlassBackground = Color3.fromRGB(18, 32, 22),
        GlassBorder = Color3.fromRGB(28, 50, 35),
        Accent = Color3.fromRGB(60, 200, 120),
        AccentLight = Color3.fromRGB(90, 230, 150),
        TextPrimary = Color3.fromRGB(230, 245, 235),
        TextSecondary = Color3.fromRGB(150, 175, 155),
        TextDark = Color3.fromRGB(90, 115, 95),
        Success = Color3.fromRGB(70, 210, 130),
        Error = Color3.fromRGB(200, 80, 80),
        Warning = Color3.fromRGB(230, 180, 60),
        Shadow = Color3.fromRGB(0, 0, 0),
        GlassTransparency = 0.12,
        BorderTransparency = 0.55
    }
}

function ShadowTheme:Get(name)
    return self.Presets[name] or self.Presets.Shadow
end

function ShadowTheme:List()
    local names = {}
    for name, _ in pairs(self.Presets) do
        table.insert(names, name)
    end
    return names
end

function ShadowTheme:Register(name, themeData)
    self.Presets[name] = themeData
end

return ShadowTheme
