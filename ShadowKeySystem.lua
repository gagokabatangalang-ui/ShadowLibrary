-- ShadowKeySystem.lua v2.0
-- Key system for Shadow Library

local ShadowKeySystem = {}

function ShadowKeySystem:Create(options, Config, Utility)
    options = options or {}
    local title = options.Title or "Shadow Key System"
    local description = options.Description or "Enter your key to continue"
    local keyLink = options.KeyLink or ""
    local keys = options.Keys or {}
    local keyCheckCallback = options.KeyCheck or nil
    local onSuccess = options.OnSuccess or function() end
    local logo = options.Logo or Config.Logo

    local UserInputService = game:GetService("UserInputService")
    local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local screenSize = workspace.CurrentCamera.ViewportSize

    local frameWidth = math.min(380, screenSize.X - 40)
    local frameHeight = IS_MOBILE and 340 or 300

    local screenGui = Utility:Create("ScreenGui", {
        Name = "ShadowKeySystem",
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Blur background
    local blur = Utility:Create("Frame", {
        Name = "Blur",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = screenGui
    })

    local keyFrame = Utility:Create("Frame", {
        Name = "KeyFrame",
        BackgroundColor3 = Config.Theme.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Size = UDim2.new(0, frameWidth, 0, frameHeight),
        Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2),
        Parent = screenGui
    })
    Utility:RoundCorner(keyFrame, 16)
    Utility:Stroke(keyFrame, Config.Theme.GlassBorder, 1.5, 0.4)
    Utility:Shadow(keyFrame, 0.6, 24)

    -- Logo
    local logoImg = Utility:Create("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Image = logo,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 55, 0, 55),
        Position = UDim2.new(0.5, -27, 0, 18),
        Parent = keyFrame
    })
    Utility:RoundCorner(logoImg, 12)

    -- Title
    local titleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 26),
        Position = UDim2.new(0, 0, 0, 78),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 18,
        Parent = keyFrame
    })

    -- Description
    local descLabel = Utility:Create("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 0, 32),
        Position = UDim2.new(0, 15, 0, 104),
        Font = Enum.Font.Gotham,
        Text = description,
        TextColor3 = Config.Theme.TextSecondary,
        TextSize = 12,
        TextWrapped = true,
        Parent = keyFrame
    })

    -- Key input
    local inputFrame = Utility:Create("Frame", {
        Name = "InputFrame",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -30, 0, 42),
        Position = UDim2.new(0, 15, 0, 148),
        Parent = keyFrame
    })
    Utility:RoundCorner(inputFrame, 10)
    Utility:Stroke(inputFrame, Config.Theme.GlassBorder, 1, 0.5)

    local keyInput = Utility:Create("TextBox", {
        Name = "KeyInput",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = "Enter key here...",
        TextColor3 = Config.Theme.TextPrimary,
        PlaceholderColor3 = Config.Theme.TextDark,
        TextSize = 13,
        ClearTextOnFocus = false,
        Parent = inputFrame
    })

    -- Status
    local statusLabel = Utility:Create("TextLabel", {
        Name = "Status",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 196),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = Config.Theme.Error,
        TextSize = 11,
        Parent = keyFrame
    })

    -- Submit button
    local submitBtn = Utility:Create("TextButton", {
        Name = "Submit",
        BackgroundColor3 = Config.Theme.Accent,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -30, 0, 38),
        Position = UDim2.new(0, 15, 0, 222),
        Font = Enum.Font.GothamBold,
        Text = "Submit Key",
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 14,
        Parent = keyFrame
    })
    Utility:RoundCorner(submitBtn, 10)
    Utility:Gradient(submitBtn, Config.Theme.Accent, Config.Theme.AccentLight, 90)

    -- Get key button
    if keyLink ~= "" then
        local getKeyBtn = Utility:Create("TextButton", {
            Name = "GetKey",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -30, 0, 22),
            Position = UDim2.new(0, 15, 0, 266),
            Font = Enum.Font.Gotham,
            Text = "Get Key",
            TextColor3 = Config.Theme.Accent,
            TextSize = 11,
            Parent = keyFrame
        })
        getKeyBtn.MouseButton1Click:Connect(function()
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Key Link",
                    Text = keyLink,
                    Duration = 10
                })
            end)
        end)
    end

    -- Validation
    local function validateKey(inputKey)
        if keyCheckCallback then
            return keyCheckCallback(inputKey)
        end
        for _, validKey in ipairs(keys) do
            if inputKey == validKey then
                return true
            end
        end
        return false
    end

    local function submit()
        local inputKey = keyInput.Text
        if inputKey == "" then
            statusLabel.Text = "Please enter a key"
            statusLabel.TextColor3 = Config.Theme.Warning
            Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 20, 0, 148)}, 0.2)
            task.delay(0.1, function()
                Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 10, 0, 148)}, 0.2)
                task.delay(0.1, function()
                    Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 15, 0, 148)}, 0.2)
                end)
            end)
            return
        end

        if validateKey(inputKey) then
            statusLabel.Text = "Key valid! Loading..."
            statusLabel.TextColor3 = Config.Theme.Success
            Utility:Tween(submitBtn, {BackgroundTransparency = 0.5}, 0.2)
            task.delay(0.5, function()
                Utility:Tween(keyFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.35)
                Utility:Tween(blur, {BackgroundTransparency = 1}, 0.35)
                task.delay(0.35, function()
                    screenGui:Destroy()
                    onSuccess()
                end)
            end)
        else
            statusLabel.Text = "Invalid key! Try again."
            statusLabel.TextColor3 = Config.Theme.Error
            Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 20, 0, 148)}, 0.2)
            task.delay(0.1, function()
                Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 10, 0, 148)}, 0.2)
                task.delay(0.1, function()
                    Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 15, 0, 148)}, 0.2)
                end)
            end)
        end
    end

    submitBtn.MouseButton1Click:Connect(submit)
    keyInput.FocusLost:Connect(function(entered)
        if entered then submit() end
    end)

    submitBtn.MouseEnter:Connect(function()
        Utility:Tween(submitBtn, {BackgroundTransparency = 0.05}, 0.2)
    end)
    submitBtn.MouseLeave:Connect(function()
        Utility:Tween(submitBtn, {BackgroundTransparency = 0.15}, 0.2)
    end)

    -- Entrance
    keyFrame.Size = UDim2.new(0, 0, 0, 0)
    keyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Utility:SpringTween(keyFrame, {Size = UDim2.new(0, frameWidth, 0, frameHeight), Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)}, 0.5)

    return {Frame = keyFrame, ScreenGui = screenGui, Validate = validateKey}
end

return ShadowKeySystem
