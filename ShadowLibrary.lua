-- Shadow Library
-- A Glass Fluent UI Library for Roblox
-- Created by ShadowDeath23
-- Version: 1.0.0

local ShadowLibrary = {}
ShadowLibrary.__index = ShadowLibrary

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configuration
local Config = {
    Name = "Shadow Library",
    Version = "1.0.0",
    Credit = "Created by ShadowDeath23",
    Logo = "rbxassetid://115418924219428",
    Theme = {
        Background = Color3.fromRGB(15, 15, 20),
        BackgroundTransparent = Color3.fromRGB(15, 15, 20),
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
        BorderTransparency = 0.6,
        AnimationSpeed = 0.3,
        SpringDamping = 0.7,
        SpringFrequency = 1.2
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
    shadow.ImageTransparency = transparency or 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, size or 20, 1, size or 20)
    shadow.Position = UDim2.new(0, -(size or 20)/2, 0, -(size or 20)/2)
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

function Utility:GlassEffect(instance, transparency)
    local glass = Instance.new("Frame")
    glass.Name = "Glass"
    glass.BackgroundColor3 = Config.Theme.GlassBackground
    glass.BackgroundTransparency = transparency or Config.Theme.GlassTransparency
    glass.BorderSizePixel = 0
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.ZIndex = instance.ZIndex + 1
    glass.Parent = instance
    Utility:RoundCorner(glass, 8)
    return glass
end

function Utility:Ripple(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Config.Theme.TextPrimary
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, x, 0, y)
    ripple.ZIndex = button.ZIndex + 10
    Utility:RoundCorner(ripple, 999)
    ripple.Parent = button

    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2

    Utility:Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, x - maxSize/2, 0, y - maxSize/2),
        BackgroundTransparency = 1
    }, 0.6)

    task.delay(0.6, function()
        ripple:Destroy()
    end)
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
