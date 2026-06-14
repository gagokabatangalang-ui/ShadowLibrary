-- ShadowWindow.lua
-- Window and Tab management for Shadow Library

local ShadowWindow = {}

function ShadowWindow:Create(options, Config, Utility)
    options = options or {}
    local windowName = options.Name or "Shadow Window"
    local credit = options.Credit or Config.Credit
    local theme = options.Theme or "Shadow"
    local logo = options.Logo or Config.Logo

    -- Main container
    local screenGui = Utility:Create("ScreenGui", {
        Name = "ShadowWindow_" .. windowName,
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Main frame with glass effect
    local mainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Config.Theme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 550, 0, 400),
        Position = UDim2.new(0.5, -275, 0.5, -200),
        Parent = screenGui
    })
    Utility:RoundCorner(mainFrame, 12)
    Utility:Stroke(mainFrame, Config.Theme.GlassBorder, 1.5, 0.5)
    Utility:Shadow(mainFrame, 0.5, 25)

    -- Title bar
    local titleBar = Utility:Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = mainFrame
    })
    Utility:RoundCorner(titleBar, 12)

    -- Logo icon
    local logoIcon = Utility:Create("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Image = logo,
        ImageColor3 = Config.Theme.TextPrimary,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 8, 0, 6),
        Parent = titleBar
    })
    Utility:RoundCorner(logoIcon, 6)

    -- Title text
    local titleText = Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 42, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = windowName,
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- Credit text
    local creditText = Utility:Create("TextLabel", {
        Name = "Credit",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.3, 0, 0.5, 0),
        Position = UDim2.new(0, 42, 0.5, 0),
        Font = Enum.Font.Gotham,
        Text = credit,
        TextColor3 = Config.Theme.TextDark,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- Close button
    local closeBtn = Utility:Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Config.Theme.Error,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -38, 0, 6),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 14,
        Parent = titleBar
    })
    Utility:RoundCorner(closeBtn, 8)

    closeBtn.MouseButton1Click:Connect(function()
        Utility:Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4)
        task.delay(0.4, function()
            screenGui:Destroy()
        end)
    end)

    -- Minimize button
    local minBtn = Utility:Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Config.Theme.Warning,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -72, 0, 6),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = Config.Theme.TextPrimary,
        TextSize = 16,
        Parent = titleBar
    })
    Utility:RoundCorner(minBtn, 8)

    -- Minimized icon (floating logo when minimized)
    local minimizedIcon = Utility:Create("ImageButton", {
        Name = "MinimizedIcon",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Image = logo,
        ImageColor3 = Config.Theme.TextPrimary,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0.5, -25, 0.9, -25),
        Visible = false,
        Parent = screenGui
    })
    Utility:RoundCorner(minimizedIcon, 12)
    Utility:Stroke(minimizedIcon, Config.Theme.GlassBorder, 1.5, 0.5)
    Utility:Shadow(minimizedIcon, 0.4, 15)

    local minimized = false

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Utility:Tween(mainFrame, {Size = UDim2.new(0, 550, 0, 40)}, 0.3)
            task.delay(0.3, function()
                mainFrame.Visible = false
                minimizedIcon.Visible = true
                Utility:SpringTween(minimizedIcon, {Size = UDim2.new(0, 50, 0, 50)}, 0.5)
            end)
        else
            minimizedIcon.Visible = false
            mainFrame.Visible = true
            Utility:Tween(mainFrame, {Size = UDim2.new(0, 550, 0, 400)}, 0.3)
        end
    end)

    -- Click minimized icon to restore
    minimizedIcon.MouseButton1Click:Connect(function()
        minimized = false
        minimizedIcon.Visible = false
        mainFrame.Visible = true
        Utility:Tween(mainFrame, {Size = UDim2.new(0, 550, 0, 400)}, 0.3)
    end)

    -- Drag minimized icon
    Utility:Drag(minimizedIcon)

    -- Tab container
    local tabContainer = Utility:Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 130, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        Parent = mainFrame
    })
    Utility:RoundCorner(tabContainer, 10)
    Utility:Stroke(tabContainer, Config.Theme.GlassBorder, 1, 0.7)

    -- Tab list layout
    local tabList = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = tabContainer
    })

    local tabPadding = Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = tabContainer
    })

    -- Content container
    local contentContainer = Utility:Create("Frame", {
        Name = "ContentContainer",
        BackgroundColor3 = Config.Theme.GlassBackground,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -155, 1, -50),
        Position = UDim2.new(0, 145, 0, 45),
        Parent = mainFrame
    })
    Utility:RoundCorner(contentContainer, 10)
    Utility:Stroke(contentContainer, Config.Theme.GlassBorder, 1, 0.7)

    -- Content padding
    local contentPadding = Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = contentContainer
    })

    -- Scroll frame for content
    local scrollFrame = Utility:Create("ScrollingFrame", {
        Name = "ScrollFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Config.Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = contentContainer
    })

    local scrollList = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = scrollFrame
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

        -- Tab button
        local tabBtn = Utility:Create("TextButton", {
            Name = tabName .. "_Tab",
            BackgroundColor3 = Config.Theme.GlassBackground,
            BackgroundTransparency = 0.6,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 36),
            Font = Enum.Font.GothamSemibold,
            Text = tabIcon ~= "" and (tabIcon .. " " .. tabName) or tabName,
            TextColor3 = Config.Theme.TextSecondary,
            TextSize = 13,
            Parent = tabContainer
        })
        Utility:RoundCorner(tabBtn, 8)

        -- Tab content frame
        local tabContent = Utility:Create("Frame", {
            Name = tabName .. "_Content",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = scrollFrame,
            Visible = false
        })

        local contentList = Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = tabContent
        })

        local tabData = {
            Button = tabBtn,
            Content = tabContent,
            Name = tabName
        }
        table.insert(tabs, tabData)

        -- Tab click handler
        tabBtn.MouseButton1Click:Connect(function()
            self:SelectTab(tabData)
        end)

        -- Hover effects
        tabBtn.MouseEnter:Connect(function()
            if activeTab ~= tabData then
                Utility:Tween(tabBtn, {BackgroundTransparency = 0.4}, 0.2)
            end
        end)

        tabBtn.MouseLeave:Connect(function()
            if activeTab ~= tabData then
                Utility:Tween(tabBtn, {BackgroundTransparency = 0.6}, 0.2)
            end
        end)

        -- Auto-select first tab
        if #tabs == 1 then
            self:SelectTab(tabData)
        end

        -- Return tab object with element creation methods
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
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 38),
                Font = Enum.Font.GothamSemibold,
                Text = btnText,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 14,
                Parent = tabContent
            })
            Utility:RoundCorner(btn, 10)
            Utility:Gradient(btn, Config.Theme.Accent, Config.Theme.AccentLight, 90)

            btn.MouseButton1Click:Connect(function()
                Utility:Ripple(btn, Mouse.X - btn.AbsolutePosition.X, Mouse.Y - btn.AbsolutePosition.Y)
                btnCallback()
            end)

            btn.MouseEnter:Connect(function()
                Utility:Tween(btn, {BackgroundTransparency = 0.1}, 0.2)
            end)

            btn.MouseLeave:Connect(function()
                Utility:Tween(btn, {BackgroundTransparency = 0.2}, 0.2)
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
                Size = UDim2.new(1, 0, 0, 42),
                Parent = tabContent
            })
            Utility:RoundCorner(toggleFrame, 10)
            Utility:Stroke(toggleFrame, Config.Theme.GlassBorder, 1, 0.7)

            local label = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.Gotham,
                Text = toggleName,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleFrame
            })

            local toggleBtn = Utility:Create("TextButton", {
                Name = "ToggleButton",
                BackgroundColor3 = defaultState and Config.Theme.Success or Config.Theme.Error,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -56, 0.5, -12),
                Text = "",
                Parent = toggleFrame
            })
            Utility:RoundCorner(toggleBtn, 12)

            local toggleCircle = Utility:Create("Frame", {
                Name = "Circle",
                BackgroundColor3 = Config.Theme.TextPrimary,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 18, 0, 18),
                Position = defaultState and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9),
                Parent = toggleBtn
            })
            Utility:RoundCorner(toggleCircle, 9)

            local state = defaultState

            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                Utility:Tween(toggleBtn, {BackgroundColor3 = state and Config.Theme.Success or Config.Theme.Error}, 0.2)
                Utility:Tween(toggleCircle, {Position = state and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)}, 0.2)
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
                Size = UDim2.new(1, 0, 0, 60),
                Parent = tabContent
            })
            Utility:RoundCorner(sliderFrame, 10)
            Utility:Stroke(sliderFrame, Config.Theme.GlassBorder, 1, 0.7)

            local label = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 0, 24),
                Position = UDim2.new(0, 12, 0, 4),
                Font = Enum.Font.Gotham,
                Text = sliderName,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame
            })

            local valueLabel = Utility:Create("TextLabel", {
                Name = "Value",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.3, 0, 0, 24),
                Position = UDim2.new(0.7, -12, 0, 4),
                Font = Enum.Font.GothamBold,
                Text = tostring(default),
                TextColor3 = Config.Theme.Accent,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sliderFrame
            })

            local track = Utility:Create("Frame", {
                Name = "Track",
                BackgroundColor3 = Config.Theme.GlassBorder,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -24, 0, 6),
                Position = UDim2.new(0, 12, 0, 38),
                Parent = sliderFrame
            })
            Utility:RoundCorner(track, 3)

            local fill = Utility:Create("Frame", {
                Name = "Fill",
                BackgroundColor3 = Config.Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Parent = track
            })
            Utility:RoundCorner(fill, 3)
            Utility:Gradient(fill, Config.Theme.Accent, Config.Theme.AccentLight, 0)

            local knob = Utility:Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Config.Theme.TextPrimary,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7),
                Parent = track
            })
            Utility:RoundCorner(knob, 7)
            Utility:Shadow(knob, 0.4, 8)

            local dragging = false
            local currentValue = default

            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                currentValue = value
                valueLabel.Text = tostring(value)
                Utility:Tween(fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                Utility:Tween(knob, {Position = UDim2.new(pos, -7, 0.5, -7)}, 0.1)
                sliderCallback(value)
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)

            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            game:GetService("UserInputService").InputEnded:Connect(function(input)
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
                Size = UDim2.new(1, 0, 0, 42),
                Parent = tabContent
            })
            Utility:RoundCorner(dropdownFrame, 10)
            Utility:Stroke(dropdownFrame, Config.Theme.GlassBorder, 1, 0.7)

            local label = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.Gotham,
                Text = dropdownName,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownFrame
            })

            local dropdownBtn = Utility:Create("TextButton", {
                Name = "DropdownButton",
                BackgroundColor3 = Config.Theme.Accent,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Size = UDim2.new(0.35, 0, 0, 32),
                Position = UDim2.new(0.63, 0, 0.5, -16),
                Font = Enum.Font.Gotham,
                Text = "Select...",
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 12,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = dropdownFrame
            })
            Utility:RoundCorner(dropdownBtn, 8)

            local optionsFrame = Utility:Create("Frame", {
                Name = "Options",
                BackgroundColor3 = Config.Theme.GlassBackground,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 5),
                ClipsDescendants = true,
                Visible = false,
                Parent = dropdownBtn
            })
            Utility:RoundCorner(optionsFrame, 8)
            Utility:Shadow(optionsFrame, 0.4, 15)
            Utility:Stroke(optionsFrame, Config.Theme.GlassBorder, 1, 0.5)

            local optionsList = Utility:Create("UIListLayout", {
                Padding = UDim.new(0, 2),
                FillDirection = Enum.FillDirection.Vertical,
                Parent = optionsFrame
            })

            local optionsPadding = Utility:Create("UIPadding", {
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
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = option,
                    TextColor3 = Config.Theme.TextSecondary,
                    TextSize = 12,
                    Parent = optionsFrame
                })
                Utility:RoundCorner(optionBtn, 6)

                optionBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = option
                    dropdownCallback(option)
                    open = false
                    Utility:Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    task.delay(0.2, function()
                        optionsFrame.Visible = false
                    end)
                end)

                optionBtn.MouseEnter:Connect(function()
                    Utility:Tween(optionBtn, {BackgroundTransparency = 0.5, TextColor3 = Config.Theme.TextPrimary}, 0.15)
                end)

                optionBtn.MouseLeave:Connect(function()
                    Utility:Tween(optionBtn, {BackgroundTransparency = 0.8, TextColor3 = Config.Theme.TextSecondary}, 0.15)
                end)
            end

            dropdownBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    optionsFrame.Visible = true
                    local totalHeight = math.min(#options * 32 + 8, 200)
                    Utility:Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.2)
                else
                    Utility:Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    task.delay(0.2, function()
                        optionsFrame.Visible = false
                    end)
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
                Size = UDim2.new(1, 0, 0, 120),
                Parent = tabContent
            })
            Utility:RoundCorner(pickerFrame, 10)
            Utility:Stroke(pickerFrame, Config.Theme.GlassBorder, 1, 0.7)

            local label = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 0, 24),
                Position = UDim2.new(0, 12, 0, 4),
                Font = Enum.Font.Gotham,
                Text = pickerName,
                TextColor3 = Config.Theme.TextPrimary,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = pickerFrame
            })

            -- Color preview
            local preview = Utility:Create("Frame", {
                Name = "Preview",
                BackgroundColor3 = defaultColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 40, 0, 40),
                Position = UDim2.new(1, -52, 0, 4),
                Parent = pickerFrame
            })
            Utility:RoundCorner(preview, 8)
            Utility:Stroke(preview, Config.Theme.GlassBorder, 2, 0.3)

            -- RGB Values display
            local rgbLabel = Utility:Create("TextLabel", {
                Name = "RGB",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.4, 0, 0, 20),
                Position = UDim2.new(0, 12, 0, 30),
                Font = Enum.Font.Gotham,
                Text = string.format("R:%d G:%d B:%d", defaultColor.R * 255, defaultColor.G * 255, defaultColor.B * 255),
                TextColor3 = Config.Theme.TextSecondary,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = pickerFrame
            })

            -- Hue Slider
            local hueFrame = Utility:Create("Frame", {
                Name = "Hue",
                BackgroundColor3 = Config.Theme.GlassBackground,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -24, 0, 20),
                Position = UDim2.new(0, 12, 0, 55),
                Parent = pickerFrame
            })
            Utility:RoundCorner(hueFrame, 10)

            local hueGradient = Utility:Create("UIGradient", {
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
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0.5, -6, 0.5, -6),
                Parent = hueFrame
            })
            Utility:RoundCorner(hueKnob, 6)
            Utility:Stroke(hueKnob, Config.Theme.TextPrimary, 2, 0)

            -- Saturation/Brightness Box
            local sbFrame = Utility:Create("Frame", {
                Name = "SatBright",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Size = UDim2.new(1, -24, 0, 30),
                Position = UDim2.new(0, 12, 0, 80),
                Parent = pickerFrame
            })
            Utility:RoundCorner(sbFrame, 8)

            local sbGradient = Utility:Create("UIGradient", {
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
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(0.5, -5, 0.5, -5),
                Parent = sbFrame
            })
            Utility:RoundCorner(sbKnob, 5)
            Utility:Stroke(sbKnob, Config.Theme.TextPrimary, 2, 0)

            local currentH, currentS, currentV = defaultColor:ToHSV()

            local function updateColor()
                local newColor = Color3.fromHSV(currentH, currentS, currentV)
                preview.BackgroundColor3 = newColor
                rgbLabel.Text = string.format("R:%d G:%d B:%d", math.floor(newColor.R * 255), math.floor(newColor.G * 255), math.floor(newColor.B * 255))
                pickerCallback(newColor)
            end

            -- Hue dragging
            local hueDragging = false
            hueFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                    local pos = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
                    currentH = pos
                    hueKnob.Position = UDim2.new(pos, -6, 0.5, -6)
                    updateColor()
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
                    currentH = pos
                    hueKnob.Position = UDim2.new(pos, -6, 0.5, -6)
                    updateColor()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = false
                end
            end)

            -- Saturation/Brightness dragging
            local sbDragging = false
            sbFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sbDragging = true
                    local x = math.clamp((input.Position.X - sbFrame.AbsolutePosition.X) / sbFrame.AbsoluteSize.X, 0, 1)
                    local y = math.clamp((input.Position.Y - sbFrame.AbsolutePosition.Y) / sbFrame.AbsoluteSize.Y, 0, 1)
                    currentS = x
                    currentV = 1 - y
                    sbKnob.Position = UDim2.new(x, -5, y, -5)
                    updateColor()
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sbDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local x = math.clamp((input.Position.X - sbFrame.AbsolutePosition.X) / sbFrame.AbsoluteSize.X, 0, 1)
                    local y = math.clamp((input.Position.Y - sbFrame.AbsolutePosition.Y) / sbFrame.AbsoluteSize.Y, 0, 1)
                    currentS = x
                    currentV = 1 - y
                    sbKnob.Position = UDim2.new(x, -5, y, -5)
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
                Size = UDim2.new(1, 0, 0, 28),
                Font = Enum.Font.Gotham,
                Text = labelText,
                TextColor3 = labelColor,
                TextSize = 13,
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
                Size = UDim2.new(1, 0, 0, 30),
                Parent = tabContent
            })

            local sectionLabel = Utility:Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = sectionText,
                TextColor3 = Config.Theme.Accent,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionFrame
            })

            local line = Utility:Create("Frame", {
                Name = "Line",
                BackgroundColor3 = Config.Theme.Accent,
                BackgroundTransparency = 0.5,
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

        -- Deselect current
        if activeTab then
            Utility:Tween(activeTab.Button, {BackgroundTransparency = 0.6, TextColor3 = Config.Theme.TextSecondary}, 0.2)
            activeTab.Content.Visible = false
        end

        -- Select new
        activeTab = tabData
        Utility:Tween(activeTab.Button, {BackgroundTransparency = 0.2, TextColor3 = Config.Theme.TextPrimary}, 0.2)
        activeTab.Content.Visible = true

        -- Animate content in
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
        Size = UDim2.new(0, 550, 0, 400),
        Position = UDim2.new(0.5, -275, 0.5, -200)
    })

    return window
end

return ShadowWindow
