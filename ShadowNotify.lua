-- ShadowNotify.lua v2.0
-- Notification system for Shadow Library

local ShadowNotify = {}

function ShadowNotify:Show(options, Config, Utility)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 4
    local notifType = options.Type or "Info"

    local screenGui = game:GetService("CoreGui")
    local notifyContainer = screenGui:FindFirstChild("ShadowNotifyContainer")

    if not notifyContainer then
        notifyContainer = Utility:Create("ScreenGui", {
            Name = "ShadowNotifyContainer",
            Parent = screenGui,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        })

        local layout = Utility:Create("Frame", {
            Name = "Layout",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 300, 1, -20),
            Position = UDim2.new(1, -320, 0, 10),
            Parent = notifyContainer
        })

        Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Parent = layout
        })
    end

    local layout = notifyContainer:FindFirstChild("Layout")

    local accentColor = Config.Theme.Accent
    local icon = "ℹ"
    if notifType == "Success" then
        accentColor = Config.Theme.Success
        icon = "✓"
    elseif notifType == "Warning" then
        accentColor = Config.Theme.Warning
        icon = "⚠"
    elseif notifType == "Error" then
        accentColor = Config.Theme.Error
        icon = "✕"
    end

    local notifFrame = Utility:Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = layout
    })
    Utility:RoundCorner(notifFrame, 10)
    Utility:Stroke(notifFrame, Config.Theme.GlassBorder, 1, 0.4)
    Utility:Shadow(notifFrame, 0.5, 12)

    local accentBar = Utility:Create("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 3, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = notifFrame
    })
    Utility:RoundCorner(accentBar, 2)

    local iconLabel = Utility:Create("TextLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 10, 0, 8),
        Font = Enum.Font.GothamBold,
        Text = icon,
        TextColor3 = accentColor,
        TextSize = 16,
        Parent = notifFrame
    })

    local titleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 0, 22),
        Position = UDim2.new(0, 40, 0, 6),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notifFrame
    })

    local messageLabel = Utility:Create("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 0, 0),
        Position = UDim2.new(0, 40, 0, 26),
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = Config.Theme.TextSecondary,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = notifFrame
    })

    Utility:Create("UIPadding", {
        PaddingBottom = UDim.new(0, 10),
        Parent = notifFrame
    })

    local progressBar = Utility:Create("Frame", {
        Name = "Progress",
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        Parent = notifFrame
    })

    notifFrame.Size = UDim2.new(1, 0, 0, 0)
    notifFrame.Visible = false
    notifFrame.Visible = true

    Utility:SpringTween(notifFrame, {Size = UDim2.new(1, 0, 0, notifFrame.AbsoluteSize.Y + 40)}, 0.4)
    Utility:Tween(progressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration)

    local closeArea = Utility:Create("TextButton", {
        Name = "Close",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = notifFrame
    })

    local closed = false
    local function closeNotif()
        if closed then return end
        closed = true
        Utility:Tween(notifFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
        task.delay(0.25, function()
            notifFrame:Destroy()
        end)
    end

    closeArea.MouseButton1Click:Connect(closeNotif)
    task.delay(duration, closeNotif)

    return notifFrame
end

return ShadowNotify
