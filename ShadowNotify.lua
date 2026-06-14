-- ShadowNotify.lua
-- Notification system for Shadow Library

local ShadowNotify = {}

function ShadowNotify:Show(options, Config, Utility)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 4
    local notifType = options.Type or "Info" -- Info, Success, Warning, Error

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
            Size = UDim2.new(0, 320, 1, -20),
            Position = UDim2.new(1, -340, 0, 10),
            Parent = notifyContainer
        })

        local list = Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Parent = layout
        })
    end

    local layout = notifyContainer:FindFirstChild("Layout")

    -- Color based on type
    local accentColor = Config.Theme.Accent
    local icon = ""
    if notifType == "Success" then
        accentColor = Config.Theme.Success
        icon = "✓"
    elseif notifType == "Warning" then
        accentColor = Config.Theme.Warning
        icon = "⚠"
    elseif notifType == "Error" then
        accentColor = Config.Theme.Error
        icon = "✕"
    else
        icon = "ℹ"
    end

    -- Notification frame
    local notifFrame = Utility:Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = layout
    })
    Utility:RoundCorner(notifFrame, 10)
    Utility:Stroke(notifFrame, Config.Theme.GlassBorder, 1, 0.5)
    Utility:Shadow(notifFrame, 0.4, 15)

    -- Accent bar
    local accentBar = Utility:Create("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 4, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = notifFrame
    })
    Utility:RoundCorner(accentBar, 2)

    -- Icon
    local iconLabel = Utility:Create("TextLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 12, 0, 8),
        Font = Enum.Font.GothamBold,
        Text = icon,
        TextColor3 = accentColor,
        TextSize = 18,
        Parent = notifFrame
    })

    -- Title
    local titleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 22),
        Position = UDim2.new(0, 46, 0, 8),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notifFrame
    })

    -- Message
    local messageLabel = Utility:Create("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 0),
        Position = UDim2.new(0, 46, 0, 30),
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = Config.Theme.TextSecondary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = notifFrame
    })

    -- Padding
    local padding = Utility:Create("UIPadding", {
        PaddingBottom = UDim.new(0, 12),
        Parent = notifFrame
    })

    -- Progress bar
    local progressBar = Utility:Create("Frame", {
        Name = "Progress",
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        Parent = notifFrame
    })

    -- Entrance animation
    notifFrame.Size = UDim2.new(1, 0, 0, 0)
    notifFrame.Visible = false
    notifFrame.Visible = true

    Utility:SpringTween(notifFrame, {Size = UDim2.new(1, 0, 0, notifFrame.AbsoluteSize.Y + 50)}, 0.5)

    -- Progress bar animation
    Utility:Tween(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration)

    -- Close button (invisible click area)
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
        Utility:Tween(notifFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        task.delay(0.3, function()
            notifFrame:Destroy()
        end)
    end

    closeArea.MouseButton1Click:Connect(closeNotif)

    task.delay(duration, closeNotif)

    return notifFrame
end

return ShadowNotify
