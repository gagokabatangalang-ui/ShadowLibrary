-- ShadowKeySystem.lua
-- Key system for Shadow Library

local ShadowKeySystem = {}

function ShadowKeySystem:Create(options, Config, Utility)
    options = options or {}
    local title = options.Title or "Shadow Key System"
    local description = options.Description or "Enter your key to continue"
    local keyLink = options.KeyLink or ""
    local keys = options.Keys or {} -- Table of valid keys
    local keyCheckCallback = options.KeyCheck or nil -- Custom key check function
    local onSuccess = options.OnSuccess or function() end
    local logo = options.Logo or Config.Logo

    -- Main screen
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
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = screenGui
    })

    -- Main key frame
    local keyFrame = Utility:Create("Frame", {
        Name = "KeyFrame",
        BackgroundColor3 = Config.Theme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 400, 0, 320),
        Position = UDim2.new(0.5, -200, 0.5, -160),
        Parent = screenGui
    })
    Utility:RoundCorner(keyFrame, 16)
    Utility:Stroke(keyFrame, Config.Theme.GlassBorder, 1.5, 0.5)
    Utility:Shadow(keyFrame, 0.5, 30)

    -- Logo
    local logoImg = Utility:Create("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Image = logo,
        ImageColor3 = Config.Theme.TextPrimary,
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0.5, -30, 0, 20),
        Parent = keyFrame
    })
    Utility:RoundCorner(logoImg, 12)

    -- Title
    local titleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 85),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 20,
        Parent = keyFrame
    })

    -- Description
    local descLabel = Utility:Create("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 115),
        Font = Enum.Font.Gotham,
        Text = description,
        TextColor3 = Config.Theme.TextSecondary,
        TextSize = 13,
        TextWrapped = true,
        Parent = keyFrame
    })

    -- Key input box
    local inputFrame = Utility:Create("Frame", {
        Name = "InputFrame",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -40, 0, 45),
        Position = UDim2.new(0, 20, 0, 165),
        Parent = keyFrame
    })
    Utility:RoundCorner(inputFrame, 10)
    Utility:Stroke(inputFrame, Config.Theme.GlassBorder, 1, 0.6)

    local keyInput = Utility:Create("TextBox", {
        Name = "KeyInput",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = "Enter key here...",
        TextColor3 = Config.Theme.TextPrimary,
        PlaceholderColor3 = Config.Theme.TextDark,
        TextSize = 14,
        ClearTextOnFocus = false,
        Parent = inputFrame
    })

    -- Status label
    local statusLabel = Utility:Create("TextLabel", {
        Name = "Status",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 215),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = Config.Theme.Error,
        TextSize = 12,
        Parent = keyFrame
    })

    -- Submit button
    local submitBtn = Utility:Create("TextButton", {
        Name = "Submit",
        BackgroundColor3 = Config.Theme.Accent,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 240),
        Font = Enum.Font.GothamBold,
        Text = "Submit Key",
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 15,
        Parent = keyFrame
    })
    Utility:RoundCorner(submitBtn, 10)
    Utility:Gradient(submitBtn, Config.Theme.Accent, Config.Theme.AccentLight, 90)

    -- Get key button
    local getKeyBtn = Utility:Create("TextButton", {
        Name = "GetKey",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -40, 0, 25),
        Position = UDim2.new(0, 20, 0, 285),
        Font = Enum.Font.Gotham,
        Text = keyLink ~= "" and "Get Key" or "",
        TextColor3 = Config.Theme.Accent,
        TextSize = 12,
        Parent = keyFrame
    })

    if keyLink ~= "" then
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

    -- Key validation
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

    -- Submit handler
    local function submit()
        local inputKey = keyInput.Text
        if inputKey == "" then
            statusLabel.Text = "Please enter a key"
            statusLabel.TextColor3 = Config.Theme.Warning
            Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 25, 0, 165)}, 0.3)
            task.delay(0.1, function()
                Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 15, 0, 165)}, 0.3)
                task.delay(0.1, function()
                    Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 20, 0, 165)}, 0.3)
                end)
            end)
            return
        end

        if validateKey(inputKey) then
            statusLabel.Text = "Key valid! Loading..."
            statusLabel.TextColor3 = Config.Theme.Success
            Utility:Tween(submitBtn, {BackgroundTransparency = 0.5}, 0.2)

            task.delay(0.5, function()
                Utility:Tween(keyFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4)
                Utility:Tween(blur, {BackgroundTransparency = 1}, 0.4)
                task.delay(0.4, function()
                    screenGui:Destroy()
                    onSuccess()
                end)
            end)
        else
            statusLabel.Text = "Invalid key! Try again."
            statusLabel.TextColor3 = Config.Theme.Error
            Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 25, 0, 165)}, 0.3)
            task.delay(0.1, function()
                Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 15, 0, 165)}, 0.3)
                task.delay(0.1, function()
                    Utility:SpringTween(inputFrame, {Position = UDim2.new(0, 20, 0, 165)}, 0.3)
                end)
            end)
        end
    end

    submitBtn.MouseButton1Click:Connect(submit)
    keyInput.FocusLost:Connect(function(entered)
        if entered then
            submit()
        end
    end)

    -- Hover effects
    submitBtn.MouseEnter:Connect(function()
        Utility:Tween(submitBtn, {BackgroundTransparency = 0.1}, 0.2)
    end)

    submitBtn.MouseLeave:Connect(function()
        Utility:Tween(submitBtn, {BackgroundTransparency = 0.2}, 0.2)
    end)

    -- Entrance animation
    keyFrame.Size = UDim2.new(0, 0, 0, 0)
    keyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Utility:SpringTween(keyFrame, {Size = UDim2.new(0, 400, 0, 320), Position = UDim2.new(0.5, -200, 0.5, -160)}, 0.6)

    return {
        Frame = keyFrame,
        ScreenGui = screenGui,
        Validate = validateKey
    }
end

return ShadowKeySystem
