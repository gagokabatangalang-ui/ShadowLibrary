-- ShadowWindow.lua v2.0
-- Window and Tab management for Shadow Library
-- Mobile-Optimized | Avatar Display | Credits Footer

local ShadowWindow = {}

function ShadowWindow:Create(options, Config, Utility)
    options = options or {}
    local windowName = options.Name or "Shadow Window"
    local credit = options.Credit or Config.Credit
    local description = options.Description or "Shadow Library - Premium UI"
    local theme = options.Theme or "Shadow"
    local logo = options.Logo or Config.Logo
    local showAvatar = options.ShowAvatar ~= false

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local UserInputService = game:GetService("UserInputService")
    local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    -- Screen size detection
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isSmallScreen = screenSize.X < 700 or IS_MOBILE

    -- Window sizing based on device
    local winWidth = isSmallScreen and math.min(screenSize.X - 20, 500) or 550
    local winHeight = isSmallScreen and math.min(screenSize.Y - 40, 600) or 450
    local tabWidth = isSmallScreen and 110 or 130

    -- Main container
    local screenGui = Utility:Create("ScreenGui", {
        Name = "ShadowWindow_" .. windowName,
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Main frame
    local mainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Config.Theme.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Size = UDim2.new(0, winWidth, 0, winHeight),
        Position = UDim2.new(0.5, -winWidth/2, 0.5, -winHeight/2),
        Parent = screenGui
    })
    Utility:RoundCorner(mainFrame, 14)
    Utility:Stroke(mainFrame, Config.Theme.GlassBorder, 1.5, 0.4)
    Utility:Shadow(mainFrame, 0.6, 20)

    -- Title bar (compact)
    local titleBar = Utility:Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = mainFrame
    })
    Utility:RoundCorner(titleBar, 14)

    -- Logo icon (properly sized)
    local logoIcon = Utility:Create("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Image = logo,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 10, 0, 6),
        Parent = titleBar
    })
    Utility:RoundCorner(logoIcon, 6)

    -- Title text
    local titleText = Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = windowName,
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- Close button
    local closeBtn = Utility:Create("ImageButton", {
        Name = "Close",
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(284, 4),
        ImageRectSize = Vector2.new(24, 24),
        ImageColor3 = Config.Theme.Error,
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -30, 0, 7),
        Parent = titleBar
    })

    closeBtn.MouseButton1Click:Connect(function()
        Utility:Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.35)
        task.delay(0.35, function()
            screenGui:Destroy()
        end)
    end)

    -- Minimize button
    local minBtn = Utility:Create("ImageButton", {
        Name = "Minimize",
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(804, 124),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = Config.Theme.TextSecondary,
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -56, 0, 7),
        Parent = titleBar
    })

    -- Minimized floating icon (your logo)
    local minimizedIcon = Utility:Create("ImageButton", {
        Name = "MinimizedIcon",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Image = logo,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 45, 0, 45),
        Position = UDim2.new(0.85, 0, 0.85, 0),
        Visible = false,
        Parent = screenGui
    })
    Utility:RoundCorner(minimizedIcon, 12)
    Utility:Stroke(minimizedIcon, Config.Theme.GlassBorder, 1.5, 0.4)
    Utility:Shadow(minimizedIcon, 0.5, 12)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Utility:Tween(mainFrame, {Size = UDim2.new(0, winWidth, 0, 36)}, 0.25)
            task.delay(0.25, function()
                mainFrame.Visible = false
                minimizedIcon.Visible = true
                Utility:SpringTween(minimizedIcon, {Size = UDim2.new(0, 45, 0, 45)}, 0.4)
            end)
        else
            minimizedIcon.Visible = false
            mainFrame.Visible = true
            Utility:Tween(mainFrame, {Size = UDim2.new(0, winWidth, 0, winHeight)}, 0.25)
        end
    end)

    minimizedIcon.MouseButton1Click:Connect(function()
        minimized = false
        minimizedIcon.Visible = false
        mainFrame.Visible = true
        Utility:Tween(mainFrame, {Size = UDim2.new(0, winWidth, 0, winHeight)}, 0.25)
    end)
    Utility:Drag(minimizedIcon)

    -- Tab container (left side)
    local tabContainer = Utility:Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(0, tabWidth, 1, -120),
        Position = UDim2.new(0, 8, 0, 42),
        Parent = mainFrame
    })
    Utility:RoundCorner(tabContainer, 10)
    Utility:Stroke(tabContainer, Config.Theme.GlassBorder, 1, 0.6)

    local tabList = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = tabContainer
    })

    Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        Parent = tabContainer
    })

    -- Content container (right side)
    local contentContainer = Utility:Create("Frame", {
        Name = "ContentContainer",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -tabWidth - 20, 1, -120),
        Position = UDim2.new(0, tabWidth + 14, 0, 42),
        Parent = mainFrame
    })
    Utility:RoundCorner(contentContainer, 10)
    Utility:Stroke(contentContainer, Config.Theme.GlassBorder, 1, 0.6)

    Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = contentContainer
    })

    -- Scroll frame
    local scrollFrame = Utility:Create("ScrollingFrame", {
        Name = "ScrollFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Config.Theme.Accent,
        ScrollBarImageTransparency = 0.4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = contentContainer
    })

    Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = scrollFrame
    })

    -- BOTTOM FOOTER (Avatar + Credits + Description)
    local footerFrame = Utility:Create("Frame", {
        Name = "Footer",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -16, 0, 68),
        Position = UDim2.new(0, 8, 1, -74),
        Parent = mainFrame
    })
    Utility:RoundCorner(footerFrame, 10)
    Utility:Stroke(footerFrame, Config.Theme.GlassBorder, 1, 0.5)

    -- Avatar viewport (3D side view)
    local avatarFrame = Utility:Create("Frame", {
        Name = "AvatarFrame",
        BackgroundColor3 = Config.Theme.Background,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 8, 0, 9),
        Parent = footerFrame
    })
    Utility:RoundCorner(avatarFrame, 10)
    Utility:Stroke(avatarFrame, Config.Theme.Accent, 1.5, 0.3)

    local avatarViewport = Utility:Create("ViewportFrame", {
        Name = "AvatarViewport",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = avatarFrame
    })

    -- Load avatar
    if showAvatar and LocalPlayer.Character then
        local char = LocalPlayer.Character:Clone()
        char:BreakJoints()
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Anchored = true
            elseif part:IsA("Humanoid") then
                part.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            end
        end
        char.Parent = avatarViewport

        local cam = Instance.new("Camera")
        cam.Parent = avatarViewport
        avatarViewport.CurrentCamera = cam

        -- Side view camera position
        local head = char:FindFirstChild("Head")
        if head then
            cam.CFrame = CFrame.new(head.Position + Vector3.new(4, 0.5, 0), head.Position)
        end
    else
        -- Fallback: show logo if no avatar
        local fallbackLogo = Utility:Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = logo,
            ImageColor3 = Config.Theme.Accent,
            Size = UDim2.new(0.8, 0, 0.8, 0),
            Position = UDim2.new(0.1, 0, 0.1, 0),
            Parent = avatarViewport
        })
    end

    -- Credits text
    local creditsText = Utility:Create("TextLabel", {
        Name = "Credits",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -70, 0, 22),
        Position = UDim2.new(0, 64, 0, 6),
        Font = Enum.Font.GothamBold,
        Text = credit,
        TextColor3 = Config.Theme.Accent,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = footerFrame
    })

    -- Description text
    local descText = Utility:Create("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -70, 0, 28),
        Position = UDim2.new(0, 64, 0, 28),
        Font = Enum.Font.Gotham,
        Text = description,
        TextColor3 = Config.Theme.TextDark,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = footerFrame
    })

    -- Drag functionality
    Utility:Drag(mainFrame, titleBar)

    -- Tab management
    local tabs = {}
    local activeTab = nil

    local window = {}
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.ContentContainer = contentContainer
    window.ScrollFrame = scrollFrame
    window.Tabs = tabs
    window.MinimizedIcon = minimizedIcon

    function window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or ""

        local tabBtn = Utility:Create("TextButton", {
            Name = tabName .. "_Tab",
            BackgroundColor3 = Config.Theme.GlassBackground,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 32),
            Font = Enum.Font.GothamSemibold,
            Text = tabIcon ~= "" and (tabIcon .. " " .. tabName) or tabName,
            TextColor3 = Config.Theme.TextSecondary,
            TextSize = 12,
            Parent = tabContainer
        })
        Utility:RoundCorner(tabBtn, 8)

        local tabContent = Utility:Create("Frame", {
            Name = tabName .. "_Content",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = scrollFrame,
            Visible = false
        })

        Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = tabContent
        })

        local tabData = {Button = tabBtn, Content = tabContent, Name = tabName}
        table.insert(tabs, tabData)

        tabBtn.MouseButton1Click:Connect(function()
            self:SelectTab(tabData)
        end)

        tabBtn.MouseEnter:Connect(function()
            if activeTab ~= tabData then
                Utility:Tween(tabBtn, {BackgroundTransparency = 0.4}, 0.2)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if activeTab ~= tabData then
                Utility:Tween(tabBtn, {BackgroundTransparency = 0.7}, 0.2)
            end
        end)

        if #tabs == 1 then
            self:SelectTab(tabData)
        end

        local tab = {}
        tab.Content = tabContent
        tab.Name = tabName

        function tab:CreateButton(btnOptions)
            btnOptions = btnOptions or {}
            local btnText = btnOptions.Name or "Button"
            local btnCallback = btnOptions.Callback or function() end

            local btn = Utility:Create("TextButton", {
                Name = btnText .. "_Button",
                BackgroundColor3 = Config.Theme.Accent,
                BackgroundTransparency = 0.15,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                Font = Enum.Font.GothamSemibold,
                Text = btnText,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 13,
                Parent = tabContent
            })
            Utility:RoundCorner(btn, 10)
            Utility:Gradient(btn, Config.Theme.Accent, Config.Theme.AccentLight, 90)

            btn.MouseButton1Click:Connect(function()
                Utility:Ripple(btn, Mouse.X - btn.AbsolutePosition.X, Mouse.Y - btn.AbsolutePosition.Y)
                btnCallback()
            end)
            btn.MouseEnter:Connect(function()
                Utility:Tween(btn, {BackgroundTransparency = 0.05}, 0.2)
            end)
            btn.MouseLeave:Connect(function()
                Utility:Tween(btn, {BackgroundTransparency = 0.15}, 0.2)
            end)
            return btn
        end

        function tab:CreateToggle(toggleOptions)
            toggleOptions = toggleOptions or {}
            local toggleName = toggleOptions.Name or "Toggle"
            local toggleCallback = toggleOptions.Callback or function() end
            local defaultState = toggleOptions.Default or false

            local toggleFrame = Utility:Create("Frame", {
                Name = toggleName .. "_Toggle",
                BackgroundColor3 = Config.Theme.GlassBackground,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = tabContent
            })
            Utility:RoundCorner(toggleFrame, 10)
            Utility:Stroke(toggleFrame, Config.Theme.GlassBorder, 1, 0.6)

            local label = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.65, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.Gotham,
                Text = toggleName,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleFrame
            })

            local toggleBtn = Utility:Create("TextButton", {
                Name = "ToggleButton",
                BackgroundColor3 = defaultState and Config.Theme.Success or Config.Theme.Error,
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 42, 0, 22),
                Position = UDim2.new(1, -54, 0.5, -11),
                Text = "",
                Parent = toggleFrame
            })
            Utility:RoundCorner(toggleBtn, 11)

            local toggleCircle = Utility:Create("Frame", {
                Name = "Circle",
                BackgroundColor3 = Config.Theme.TextPrimary,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 16, 0, 16),
                Position = defaultState and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8),
                Parent = toggleBtn
            })
            Utility:RoundCorner(toggleCircle, 8)

            local state = defaultState
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                Utility:Tween(toggleBtn, {BackgroundColor3 = state and Config.Theme.Success or Config.Theme.Error}, 0.2)
                Utility:Tween(toggleCircle, {Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)}, 0.2)
                toggleCallback(state)
            end)
            return toggleFrame
        end

        function tab:CreateSlider(sliderOptions)
            sliderOptions = sliderOptions or {}
            local sliderName = sliderOptions.Name or "Slider"
            local min = sliderOptions.Min or 0
            local max = sliderOptions.Max or 100
            local default = sliderOptions.Default or min
            local sliderCallback = sliderOptions.Callback or function() end

            local sliderFrame = Utility:Create("Frame", {
                Name = sliderName .. "_Slider",
                BackgroundColor3 = Config.Theme.GlassBackground,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 56),
                Parent = tabContent
            })
            Utility:RoundCorner(sliderFrame, 10)
            Utility:Stroke(sliderFrame, Config.Theme.GlassBorder, 1, 0.6)

            local label = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 0, 22),
                Position = UDim2.new(0, 12, 0, 4),
                Font = Enum.Font.Gotham,
                Text = sliderName,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame
            })

            local valueLabel = Utility:Create("TextLabel", {
                Name = "Value",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.4, 0, 0, 22),
                Position = UDim2.new(0.6, -12, 0, 4),
                Font = Enum.Font.GothamBold,
                Text = tostring(default),
                TextColor3 = Config.Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sliderFrame
            })

            local track = Utility:Create("Frame", {
                Name = "Track",
                BackgroundColor3 = Config.Theme.GlassBorder,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 5),
                Position = UDim2.new(0, 10, 0, 36),
                Parent = sliderFrame
            })
            Utility:RoundCorner(track, 3)

            local fill = Utility:Create("Frame", {
                Name = "Fill",
                BackgroundColor3 = Config.Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                Parent = track
            })
            Utility:RoundCorner(fill, 3)
            Utility:Gradient(fill, Config.Theme.Accent, Config.Theme.AccentLight, 0)

            local knob = Utility:Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Config.Theme.TextPrimary,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6),
                Parent = track
            })
            Utility:RoundCorner(knob, 6)
            Utility:Shadow(knob, 0.3, 6)

            local dragging = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                valueLabel.Text = tostring(value)
                Utility:Tween(fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                Utility:Tween(knob, {Position = UDim2.new(pos, -6, 0.5, -6)}, 0.1)
                sliderCallback(value)
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            return sliderFrame
        end

        function tab:CreateDropdown(dropdownOptions)
            dropdownOptions = dropdownOptions or {}
            local dropdownName = dropdownOptions.Name or "Dropdown"
            local options = dropdownOptions.Options or {}
            local dropdownCallback = dropdownOptions.Callback or function() end

            local dropdownFrame = Utility:Create("Frame", {
                Name = dropdownName .. "_Dropdown",
                BackgroundColor3 = Config.Theme.GlassBackground,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = tabContent
            })
            Utility:RoundCorner(dropdownFrame, 10)
            Utility:Stroke(dropdownFrame, Config.Theme.GlassBorder, 1, 0.6)

            local label = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.55, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.Gotham,
                Text = dropdownName,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownFrame
            })

            local dropdownBtn = Utility:Create("TextButton", {
                Name = "DropdownButton",
                BackgroundColor3 = Config.Theme.Accent,
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                Size = UDim2.new(0.4, 0, 0, 30),
                Position = UDim2.new(0.58, 0, 0.5, -15),
                Font = Enum.Font.Gotham,
                Text = "Select...",
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 11,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = dropdownFrame
            })
            Utility:RoundCorner(dropdownBtn, 8)

            local optionsFrame = Utility:Create("Frame", {
                Name = "Options",
                BackgroundColor3 = Config.Theme.GlassBackground,
                BackgroundTransparency = 0.05,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 4),
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 10,
                Parent = dropdownBtn
            })
            Utility:RoundCorner(optionsFrame, 8)
            Utility:Shadow(optionsFrame, 0.4, 12)
            Utility:Stroke(optionsFrame, Config.Theme.GlassBorder, 1, 0.4)

            Utility:Create("UIListLayout", {
                Padding = UDim.new(0, 2),
                FillDirection = Enum.FillDirection.Vertical,
                Parent = optionsFrame
            })

            Utility:Create("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
                Parent = optionsFrame
            })

            local open = false
            for _, option in ipairs(options) do
                local optionBtn = Utility:Create("TextButton", {
                    Name = option,
                    BackgroundColor3 = Config.Theme.GlassBackground,
                    BackgroundTransparency = 0.8,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 28),
                    Font = Enum.Font.Gotham,
                    Text = option,
                    TextColor3 = Config.Theme.TextSecondary,
                    TextSize = 11,
                    ZIndex = 11,
                    Parent = optionsFrame
                })
                Utility:RoundCorner(optionBtn, 6)

                optionBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = option
                    dropdownCallback(option)
                    open = false
                    Utility:Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    task.delay(0.2, function() optionsFrame.Visible = false end)
                end)
                optionBtn.MouseEnter:Connect(function()
                    Utility:Tween(optionBtn, {BackgroundTransparency = 0.4, TextColor3 = Config.Theme.TextPrimary}, 0.15)
                end)
                optionBtn.MouseLeave:Connect(function()
                    Utility:Tween(optionBtn, {BackgroundTransparency = 0.8, TextColor3 = Config.Theme.TextSecondary}, 0.15)
                end)
            end

            dropdownBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    optionsFrame.Visible = true
                    local totalHeight = math.min(#options * 30 + 8, 180)
                    Utility:Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.2)
                else
                    Utility:Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    task.delay(0.2, function() optionsFrame.Visible = false end)
                end
            end)
            return dropdownFrame
        end

        function tab:CreateColorPicker(pickerOptions)
            pickerOptions = pickerOptions or {}
            local pickerName = pickerOptions.Name or "Color Picker"
            local defaultColor = pickerOptions.Default or Color3.fromRGB(120, 80, 200)
            local pickerCallback = pickerOptions.Callback or function() end

            local pickerFrame = Utility:Create("Frame", {
                Name = pickerName .. "_ColorPicker",
                BackgroundColor3 = Config.Theme.GlassBackground,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 110),
                Parent = tabContent
            })
            Utility:RoundCorner(pickerFrame, 10)
            Utility:Stroke(pickerFrame, Config.Theme.GlassBorder, 1, 0.6)

            local label = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 0, 22),
                Position = UDim2.new(0, 12, 0, 4),
                Font = Enum.Font.Gotham,
                Text = pickerName,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = pickerFrame
            })

            local preview = Utility:Create("Frame", {
                Name = "Preview",
                BackgroundColor3 = defaultColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 36, 0, 36),
                Position = UDim2.new(1, -48, 0, 4),
                Parent = pickerFrame
            })
            Utility:RoundCorner(preview, 8)
            Utility:Stroke(preview, Config.Theme.GlassBorder, 2, 0.3)

            local rgbLabel = Utility:Create("TextLabel", {
                Name = "RGB",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 0, 18),
                Position = UDim2.new(0, 12, 0, 26),
                Font = Enum.Font.Gotham,
                Text = string.format("R:%d G:%d B:%d", defaultColor.R * 255, defaultColor.G * 255, defaultColor.B * 255),
                TextColor3 = Config.Theme.TextSecondary,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = pickerFrame
            })

            local hueFrame = Utility:Create("Frame", {
                Name = "Hue",
                BackgroundColor3 = Config.Theme.GlassBackground,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 18),
                Position = UDim2.new(0, 10, 0, 50),
                Parent = pickerFrame
            })
            Utility:RoundCorner(hueFrame, 9)

            Utility:Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }),
                Parent = hueFrame
            })

            local hueKnob = Utility:Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Config.Theme.TextPrimary,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(0.5, -5, 0.5, -5),
                Parent = hueFrame
            })
            Utility:RoundCorner(hueKnob, 5)
            Utility:Stroke(hueKnob, Config.Theme.TextPrimary, 2, 0)

            local sbFrame = Utility:Create("Frame", {
                Name = "SatBright",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 26),
                Position = UDim2.new(0, 10, 0, 74),
                Parent = pickerFrame
            })
            Utility:RoundCorner(sbFrame, 6)

            Utility:Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                }),
                Rotation = 90,
                Parent = sbFrame
            })

            local sbKnob = Utility:Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Config.Theme.TextPrimary,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 8, 0, 8),
                Position = UDim2.new(0.5, -4, 0.5, -4),
                Parent = sbFrame
            })
            Utility:RoundCorner(sbKnob, 4)
            Utility:Stroke(sbKnob, Config.Theme.TextPrimary, 2, 0)

            local currentH, currentS, currentV = defaultColor:ToHSV()
            local function updateColor()
                local newColor = Color3.fromHSV(currentH, currentS, currentV)
                preview.BackgroundColor3 = newColor
                rgbLabel.Text = string.format("R:%d G:%d B:%d", math.floor(newColor.R * 255), math.floor(newColor.G * 255), math.floor(newColor.B * 255))
                pickerCallback(newColor)
            end

            local hueDragging = false
            hueFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                    local pos = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
                    currentH = pos
                    hueKnob.Position = UDim2.new(pos, -5, 0.5, -5)
                    updateColor()
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
                    currentH = pos
                    hueKnob.Position = UDim2.new(pos, -5, 0.5, -5)
                    updateColor()
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = false
                end
            end)

            local sbDragging = false
            sbFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sbDragging = true
                    local x = math.clamp((input.Position.X - sbFrame.AbsolutePosition.X) / sbFrame.AbsoluteSize.X, 0, 1)
                    local y = math.clamp((input.Position.Y - sbFrame.AbsolutePosition.Y) / sbFrame.AbsoluteSize.Y, 0, 1)
                    currentS = x
                    currentV = 1 - y
                    sbKnob.Position = UDim2.new(x, -4, y, -4)
                    updateColor()
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sbDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local x = math.clamp((input.Position.X - sbFrame.AbsolutePosition.X) / sbFrame.AbsoluteSize.X, 0, 1)
                    local y = math.clamp((input.Position.Y - sbFrame.AbsolutePosition.Y) / sbFrame.AbsoluteSize.Y, 0, 1)
                    currentS = x
                    currentV = 1 - y
                    sbKnob.Position = UDim2.new(x, -4, y, -4)
                    updateColor()
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sbDragging = false
                end
            end)
            return pickerFrame
        end

        function tab:CreateLabel(labelOptions)
            labelOptions = labelOptions or {}
            local labelText = labelOptions.Text or "Label"
            local labelColor = labelOptions.Color or Config.Theme.TextPrimary

            local label = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 26),
                Font = Enum.Font.Gotham,
                Text = labelText,
                TextColor3 = labelColor,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = tabContent
            })
            return label
        end

        function tab:CreateSection(sectionOptions)
            sectionOptions = sectionOptions or {}
            local sectionText = sectionOptions.Text or "Section"

            local sectionFrame = Utility:Create("Frame", {
                Name = sectionText .. "_Section",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 26),
                Parent = tabContent
            })

            local sectionLabel = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = sectionText,
                TextColor3 = Config.Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionFrame
            })

            local line = Utility:Create("Frame", {
                Name = "Line",
                BackgroundColor3 = Config.Theme.Accent,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 2),
                Position = UDim2.new(0, 0, 1, -2),
                Parent = sectionFrame
            })
            Utility:Gradient(line, Config.Theme.Accent, Config.Theme.AccentLight, 0)
            return sectionFrame
        end

        return tab
    end

    function window:SelectTab(tabData)
        if activeTab == tabData then return end
        if activeTab then
            Utility:Tween(activeTab.Button, {BackgroundTransparency = 0.7, TextColor3 = Config.Theme.TextSecondary}, 0.2)
            activeTab.Content.Visible = false
        end
        activeTab = tabData
        Utility:Tween(activeTab.Button, {BackgroundTransparency = 0.2, TextColor3 = Config.Theme.TextPrimary}, 0.2)
        activeTab.Content.Visible = true
        Utility:Tween(activeTab.Content, {BackgroundTransparency = 1}, 0)
        Utility:Tween(activeTab.Content, {BackgroundTransparency = 0}, 0.3)
    end

    function window:Destroy()
        screenGui:Destroy()
    end

    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Utility:SpringTween(mainFrame, {
        Size = UDim2.new(0, winWidth, 0, winHeight),
        Position = UDim2.new(0.5, -winWidth/2, 0.5, -winHeight/2)
    })

    return window
end

return ShadowWindow
