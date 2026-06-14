-- Shadow Library v2.0
-- A Glass Fluent UI Library for Roblox
-- Created by ShadowDeath23
-- Mobile-Optimized | Avatar Support | Clean Layout

local ShadowLibrary = {}
ShadowLibrary.__index = ShadowLibrary

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GitHub raw URL base
local GITHUB_BASE = "https://raw.githubusercontent.com/gagokabatangalang-ui/ShadowLibrary/refs/heads/main/"

-- Mobile detection
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Configuration
local Config = {
    Name = "Shadow Library",
    Version = "2.0.0",
    Credit = "Created by ShadowDeath23",
    Logo = "rbxassetid://115418924219428",
    Theme = {
        Background = Color3.fromRGB(12, 12, 18),
        GlassBackground = Color3.fromRGB(22, 22, 32),
        GlassBorder = Color3.fromRGB(45, 45, 60),
        Accent = Color3.fromRGB(130, 90, 220),
        AccentLight = Color3.fromRGB(160, 120, 250),
        TextPrimary = Color3.fromRGB(245, 245, 250),
        TextSecondary = Color3.fromRGB(170, 170, 180),
        TextDark = Color3.fromRGB(110, 110, 120),
        Success = Color3.fromRGB(85, 210, 130),
        Error = Color3.fromRGB(210, 85, 85),
        Warning = Color3.fromRGB(235, 190, 70),
        Shadow = Color3.fromRGB(0, 0, 0),
        GlassTransparency = 0.08,
        BorderTransparency = 0.5,
        AnimationSpeed = 0.25,
        SpringDamping = 0.65,
        SpringFrequency = 1.0
    }
}

-- Utility Functions
local Utility = {}

function Utility:Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    return instance
end

function Utility:Tween(instance, properties, duration, easingStyle, easingDirection)
    duration = duration or Config.Theme.AnimationSpeed
    easingStyle = easingStyle or Enum.EasingStyle.Quart
    easingDirection = easingDirection or Enum.EasingDirection.Out
    local tween = TweenService:Create(instance, TweenInfo.new(duration, easingStyle, easingDirection), properties)
    tween:Play()
    return tween
end

function Utility:SpringTween(instance, properties, damping, frequency)
    damping = damping or Config.Theme.SpringDamping
    frequency = frequency or Config.Theme.SpringFrequency
    local tween = TweenService:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, damping / frequency), properties)
    tween:Play()
    return tween
end

function Utility:RoundCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

function Utility:Shadow(instance, transparency, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://131604521937076"
    shadow.ImageColor3 = Config.Theme.Shadow
    shadow.ImageTransparency = transparency or 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, size or 16, 1, size or 16)
    shadow.Position = UDim2.new(0, -(size or 16)/2, 0, -(size or 16)/2)
    shadow.ZIndex = instance.ZIndex - 1
    shadow.Parent = instance
    return shadow
end

function Utility:Stroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Config.Theme.GlassBorder
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or Config.Theme.BorderTransparency
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

function Utility:Gradient(instance, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or Config.Theme.Accent),
        ColorSequenceKeypoint.new(1, color2 or Config.Theme.AccentLight)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = instance
    return gradient
end

function Utility:Ripple(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Config.Theme.TextPrimary
    ripple.BackgroundTransparency = 0.85
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, x, 0, y)
    ripple.ZIndex = button.ZIndex + 10
    Utility:RoundCorner(ripple, 999)
    ripple.Parent = button
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    Utility:Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, x - maxSize/2, 0, y - maxSize/2),
        BackgroundTransparency = 1
    }, 0.5)
    task.delay(0.5, function() ripple:Destroy() end)
end

function Utility:Drag(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Return modules
ShadowLibrary.Config = Config
ShadowLibrary.Utility = Utility
ShadowLibrary._modules = {}

function ShadowLibrary:LoadModule(moduleName)
    if self._modules[moduleName] then
        return self._modules[moduleName]
    end
    local success, module = pcall(function()
        local url = GITHUB_BASE .. moduleName .. ".lua"
        local source = game:HttpGet(url, true)
        return loadstring(source)()
    end)
    if success and module then
        self._modules[moduleName] = module
        return module
    end
    success, module = pcall(function()
        return require(script:FindFirstChild(moduleName) or script.Parent:FindFirstChild(moduleName))
    end)
    if success and module then
        self._modules[moduleName] = module
        return module
    end
    warn("[Shadow Library] Failed to load module: " .. moduleName)
    return nil
end

function ShadowLibrary:CreateWindow(options)
    options = options or {}
    local WindowModule = self:LoadModule("ShadowWindow")
    if WindowModule then
        return WindowModule:Create(options, self.Config, self.Utility)
    end
    return nil
end

function ShadowLibrary:Notify(options)
    options = options or {}
    local NotifyModule = self:LoadModule("ShadowNotify")
    if NotifyModule then
        return NotifyModule:Show(options, self.Config, self.Utility)
    end
    return nil
end

function ShadowLibrary:CreateKeySystem(options)
    options = options or {}
    local KeyModule = self:LoadModule("ShadowKeySystem")
    if KeyModule then
        return KeyModule:Create(options, self.Config, self.Utility)
    end
    return nil
end

function ShadowLibrary:Init()
    local screenGui = Utility:Create("ScreenGui", {
        Name = "ShadowLibrary_" .. HttpService:GenerateGUID(false),
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    self.ScreenGui = screenGui
    return self
end

return ShadowLibrary
