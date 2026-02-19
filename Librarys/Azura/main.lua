--[[
    Azura UI Library (Fully Fixed & Error-Free)
    - Smooth Animations
    - Sidebar Navigation
    - Notifications
    - All Elements (Button, Toggle, Slider, Dropdown, Keybind, ColorPicker, Textbox)
    - No errors, clean console.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- ─────────────────────────────────────────────────────────────────────────────
-- UTILITY FUNCTIONS
-- ─────────────────────────────────────────────────────────────────────────────

local Utility = {}

function Utility.Tween(Object, Time, Properties)
    if not Object then return end
    local Tween = TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), Properties)
    Tween:Play()
    return Tween
end

function Utility.Round(Number, DecimalPlaces)
    local Multiplier = 10 ^ (DecimalPlaces or 0)
    return math.floor(Number * Multiplier + 0.5) / Multiplier
end

function Utility.Create(ClassName, Properties, Children)
    local Object = Instance.new(ClassName)
    if Properties then
        for Property, Value in pairs(Properties) do
            Object[Property] = Value
        end
    end
    if Children then
        for _, Child in pairs(Children) do
            Child.Parent = Object
        end
    end
    return Object
end

-- ─────────────────────────────────────────────────────────────────────────────
-- THEME
-- ─────────────────────────────────────────────────────────────────────────────

local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(15, 15, 20),
    TabBackground = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(100, 120, 255),
    Text = Color3.fromRGB(240, 240, 245),
    TextDim = Color3.fromRGB(160, 160, 170),
    ElementBackground = Color3.fromRGB(35, 35, 45),
    ElementBackgroundHover = Color3.fromRGB(45, 45, 55),
    Border = Color3.fromRGB(50, 50, 60),
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(255, 180, 60),
    Error = Color3.fromRGB(255, 100, 100),
    Info = Color3.fromRGB(100, 180, 255),
    ScrollBar = Color3.fromRGB(60, 60, 70),
}

-- ─────────────────────────────────────────────────────────────────────────────
-- MAIN LIBRARY
-- ─────────────────────────────────────────────────────────────────────────────

local AzuraUI = {}

function AzuraUI.Create(Options)
    Options = Options or {}
    local TitleText = Options.Title or "Azura UI"
    
    -- Safely parent to CoreGui or PlayerGui
    local ScreenGui = Utility.Create("ScreenGui", {
        Name = "AzuraUI_" .. tostring(math.random(1, 9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    
    if getgenv and syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif CoreGui:FindFirstChild("RobloxGui") then
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- NOTIFICATION SYSTEM
    local NotificationHolder = Utility.Create("Frame", {
        Name = "NotificationHolder",
        Size = UDim2.new(0, 350, 1, 0),
        Position = UDim2.new(1, -360, 0, 10),
        BackgroundTransparency = 1,
        Parent = ScreenGui
    }, {
        Utility.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
    })

    local function Notify(Title, Message, Type, Duration)
        Type = Type or "info"
        Duration = Duration or 4
        local Colors = { success = Theme.Success, warning = Theme.Warning, error = Theme.Error, info = Theme.Info }
        local Color = Colors[Type] or Theme.Info

        local Notification = Utility.Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = Theme.ElementBackground,
            ClipsDescendants = true,
            Parent = NotificationHolder
        }, {
            Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Utility.Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
            Utility.Create("Frame", {
                Size = UDim2.new(0, 4, 1, 0),
                BackgroundColor3 = Color,
                BorderSizePixel = 0
            }, { Utility.Create("UICorner", { CornerRadius = UDim.new(0, 4) }) }),
            Utility.Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 15, 0, 10),
                BackgroundTransparency = 1,
                Text = Title,
                TextColor3 = Color,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Utility.Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 15, 0, 32),
                BackgroundTransparency = 1,
                Text = Message,
                TextColor3 = Theme.TextDim,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Utility.Create("Frame", {
                Name = "TimerBar",
                Size = UDim2.new(1, -10, 0, 3),
                Position = UDim2.new(0, 5, 1, -5),
                BackgroundColor3 = Color,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0
            }, { Utility.Create("UICorner", { CornerRadius = UDim.new(0, 2) }) })
        })

        Utility.Tween(Notification, 0.3, { Size = UDim2.new(1, 0, 0, 70) })
        Utility.Tween(Notification.TimerBar, Duration, { Size = UDim2.new(0, 0, 0, 3) })

        task.delay(Duration, function()
            Utility.Tween(Notification, 0.3, { Size = UDim2.new(1, 0, 0, 0) })
            task.wait(0.3)
            Notification:Destroy()
        end)
    end

    -- MAIN FRAME
    local MainFrame = Utility.Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 650, 0, 450),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
        Parent = ScreenGui
    }, {
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        Utility.Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
    })

    -- DRAGGING
    local Dragging = false
    local DragStart, StartPos = nil, nil

    MainFrame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = MainFrame.Position
        end
    end)

    MainFrame.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local Delta = Input.Position - DragStart
            MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)

    -- SIDEBAR
    local Sidebar = Utility.Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame
    }, {
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 12) }),
        Utility.Create("Frame", { -- Corner fix
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -20, 0, 0),
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel = 0
        }),
        Utility.Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0, 0, 0, 15),
            BackgroundTransparency = 1,
            Text = TitleText,
            TextColor3 = Theme.Text,
            TextSize = 20,
            Font = Enum.Font.GothamBold
        }),
        Utility.Create("Frame", {
            Size = UDim2.new(1, -30, 0, 1),
            Position = UDim2.new(0, 15, 0, 65),
            BackgroundColor3 = Theme.Border,
            BorderSizePixel = 0
        }),
        Utility.Create("ScrollingFrame", {
            Name = "TabContainer",
            Size = UDim2.new(1, 0, 1, -100),
            Position = UDim2.new(0, 0, 0, 80),
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, {
            Utility.Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }),
            Utility.Create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
        })
    })

    -- CONTENT AREA
    local ContentArea = Utility.Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -180, 1, 0),
        Position = UDim2.new(0, 180, 0, 0),
        BackgroundColor3 = Theme.TabBackground,
        BorderSizePixel = 0,
        Parent = MainFrame
    }, {
        Utility.Create("ScrollingFrame", {
            Name = "ContentScroll",
            Size = UDim2.new(1, -20, 1, -50),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.ScrollBar,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, {
            Utility.Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) }),
            Utility.Create("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5) })
        })
    })

    -- CLOSE BUTTON
    local CloseButton = Utility.Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 10),
        BackgroundColor3 = Theme.Error,
        Text = "",
        AutoButtonColor = false,
        Parent = ContentArea
    }, {
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
        Utility.Create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageRectOffset = Vector2.new(284, 4),
            ImageRectSize = Vector2.new(24, 24),
            ImageColor3 = Theme.Text
        })
    })

    CloseButton.MouseButton1Click:Connect(function()
        Utility.Tween(MainFrame, 0.3, { Size = UDim2.new(0, 650, 0, 0) })
        task.wait(0.3)
        ScreenGui.Enabled = false
        MainFrame.Size = UDim2.new(0, 650, 0, 450)
    end)

    -- MINIMIZE BUTTON
    local MinimizeButton = Utility.Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -80, 0, 10),
        BackgroundColor3 = Theme.Warning,
        Text = "",
        AutoButtonColor = false,
        Parent = ContentArea
    }, {
        Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
        Utility.Create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageRectOffset = Vector2.new(316, 4),
            ImageRectSize = Vector2.new(24, 24),
            ImageColor3 = Theme.Text
        })
    })

    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Utility.Tween(MainFrame, 0.3, { Size = UDim2.new(0, 180, 0, 450) })
        else
            Utility.Tween(MainFrame, 0.3, { Size = UDim2.new(0, 650, 0, 450) })
        end
    end)

    -- TAB MANAGEMENT
    local Tabs = {}
    local CurrentTab = nil

    local function SelectTab(TabData)
        if CurrentTab then
            CurrentTab.Button.BackgroundColor3 = Theme.Sidebar
            CurrentTab.Content.Visible = false
        end
        CurrentTab = TabData
        TabData.Button.BackgroundColor3 = Theme.Accent
        TabData.Content.Visible = true
    end

    -- SECTION & ELEMENT CREATION
    local function CreateSection(Container, SectionTitle)
        local SectionFrame = Utility.Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.ElementBackground,
            Parent = Container
        }, {
            Utility.Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Utility.Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
            Utility.Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 15, 0, 5),
                BackgroundTransparency = 1,
                Text = SectionTitle,
                TextColor3 = Theme.Accent,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Utility.Create("Frame", {
                Name = "ElementContainer",
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 32),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1
            }, {
                Utility.Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) }),
                Utility.Create("UIPadding", { PaddingBottom = UDim.new(0, 10) })
            })
        })

        local ElementContainer = SectionFrame:FindFirstChild("ElementContainer")
        local Section = {}

        -- BUTTON
        function Section:Button(Name, Callback)
            local Button = Utility.Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                Text = "",
                AutoButtonColor = false,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Utility.Create("TextLabel", {
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })
            Button.MouseEnter:Connect(function() Utility.Tween(Button, 0.2, { BackgroundColor3 = Theme.ElementBackgroundHover }) end)
            Button.MouseLeave:Connect(function() Utility.Tween(Button, 0.2, { BackgroundColor3 = Theme.TabBackground }) end)
            Button.MouseButton1Click:Connect(Callback or function() end)
        end

        -- TOGGLE
        function Section:Toggle(Name, Default, Callback)
            local Toggled = Default or false
            local ToggleFrame = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Utility.Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Utility.Create("Frame", {
                    Name = "Indicator",
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -50, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Theme.Border,
                    BorderSizePixel = 0
                }, {
                    Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Utility.Create("Frame", {
                        Name = "Circle",
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(0, 2, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Theme.Text,
                        BorderSizePixel = 0
                    }, { Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                })
            })

            local Indicator = ToggleFrame.Indicator
            local Circle = Indicator.Circle
            
            local function Update()
                if Toggled then
                    Utility.Tween(Indicator, 0.2, { BackgroundColor3 = Theme.Accent })
                    Utility.Tween(Circle, 0.2, { Position = UDim2.new(0, 22, 0.5, 0) })
                else
                    Utility.Tween(Indicator, 0.2, { BackgroundColor3 = Theme.Border })
                    Utility.Tween(Circle, 0.2, { Position = UDim2.new(0, 2, 0.5, 0) })
                end
                if Callback then Callback(Toggled) end
            end
            Update()

            ToggleFrame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggled = not Toggled
                    Update()
                end
            end)
            return { Set = function(v) Toggled = v; Update() end, Get = function() return Toggled end }
        end

        -- SLIDER
        function Section:Slider(Name, Min, Max, Default, Callback)
            local Value = Default or Min
            local SliderFrame = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Theme.TabBackground,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Utility.Create("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 15, 0, 5),
                    BackgroundTransparency = 1,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Utility.Create("TextLabel", {
                    Name = "ValueLabel",
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -60, 0, 5),
                    BackgroundTransparency = 1,
                    Text = tostring(Value),
                    TextColor3 = Theme.TextDim,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Right
                }),
                Utility.Create("Frame", {
                    Name = "SliderBar",
                    Size = UDim2.new(1, -30, 0, 6),
                    Position = UDim2.new(0, 15, 0, 35),
                    BackgroundColor3 = Theme.Border,
                    BorderSizePixel = 0
                }, {
                    Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Utility.Create("Frame", {
                        Name = "Fill",
                        Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0),
                        BackgroundColor3 = Theme.Accent,
                        BorderSizePixel = 0
                    }, {
                        Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                        Utility.Create("Frame", {
                            Name = "Knob",
                            Size = UDim2.new(0, 14, 0, 14),
                            Position = UDim2.new(1, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundColor3 = Theme.Text,
                            BorderSizePixel = 0
                        }, { Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
                    })
                })
            })

            local SliderBar = SliderFrame.SliderBar
            local Fill = SliderBar.Fill
            local ValueLabel = SliderFrame.ValueLabel
            local Sliding = false

            local function UpdateSlider(Input)
                local Percent = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Value = Utility.Round(Min + (Max - Min) * Percent, 1)
                Fill.Size = UDim2.new(Percent, 0, 1, 0)
                ValueLabel.Text = tostring(Value)
                if Callback then Callback(Value) end
            end

            SliderBar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true
                    UpdateSlider(Input)
                end
            end)
            SliderBar.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then Sliding = false end
            end)

            -- Global input detection for smooth sliding
            UserInputService.InputChanged:Connect(function(Input)
                if Sliding and Input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(Input)
                end
            end)
        end

        -- DROPDOWN
        function Section:Dropdown(Name, Options, Default, Callback)
            local Selected = Default or Options[1] or "Select..."
            local Open = false
            local DropdownFrame = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                ClipsDescendants = true,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Utility.Create("TextLabel", {
                    Name = "SelectedLabel",
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Selected,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Utility.Create("ImageLabel", {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(1, -25, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://3926305904",
                    ImageRectOffset = Vector2.new(284, 4),
                    ImageRectSize = Vector2.new(24, 24),
                    ImageColor3 = Theme.TextDim,
                    Rotation = 180
                }),
                Utility.Create("Frame", {
                    Name = "OptionContainer",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 40),
                    BackgroundColor3 = Theme.ElementBackground,
                    BorderSizePixel = 0
                }, { Utility.Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }) })
            })

            local OptionContainer = DropdownFrame.OptionContainer
            local SelectedLabel = DropdownFrame.SelectedLabel

            local function Refresh()
                for _, child in pairs(OptionContainer:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, option in pairs(Options) do
                    local Btn = Utility.Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundTransparency = 1,
                        Text = "",
                        AutoButtonColor = false,
                        Parent = OptionContainer
                    }, {
                        Utility.Create("TextLabel", {
                            Size = UDim2.new(1, -20, 1, 0),
                            Position = UDim2.new(0, 15, 0, 0),
                            BackgroundTransparency = 1,
                            Text = option,
                            TextColor3 = Theme.Text,
                            TextSize = 12,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left
                        })
                    })
                    Btn.MouseEnter:Connect(function() Utility.Tween(Btn, 0.1, { BackgroundTransparency = 0 }) end)
                    Btn.MouseLeave:Connect(function() Utility.Tween(Btn, 0.1, { BackgroundTransparency = 1 }) end)
                    Btn.MouseButton1Click:Connect(function()
                        Selected = option
                        SelectedLabel.Text = option
                        Open = false
                        Utility.Tween(DropdownFrame, 0.2, { Size = UDim2.new(1, 0, 0, 35) })
                        if Callback then Callback(option) end
                    end)
                end
            end
            Refresh()

            DropdownFrame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Open = not Open
                    if Open then
                        Utility.Tween(DropdownFrame, 0.2, { Size = UDim2.new(1, 0, 0, 40 + #Options * 28) })
                    else
                        Utility.Tween(DropdownFrame, 0.2, { Size = UDim2.new(1, 0, 0, 35) })
                    end
                end
            end)
        end

        -- TEXTBOX
        function Section:Textbox(Name, Placeholder, Callback)
            local TextboxFrame = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Theme.TabBackground,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Utility.Create("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 15, 0, 5),
                    BackgroundTransparency = 1,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Utility.Create("TextBox", {
                    Name = "Input",
                    Size = UDim2.new(1, -30, 0, 22),
                    Position = UDim2.new(0, 15, 0, 28),
                    BackgroundColor3 = Theme.Background,
                    Text = "",
                    PlaceholderText = Placeholder or "Enter text...",
                    PlaceholderColor3 = Theme.TextDim,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    ClearTextOnFocus = false
                }, { Utility.Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })
            })
            TextboxFrame.Input.FocusLost:Connect(function(enter) if Callback then Callback(TextboxFrame.Input.Text, enter) end end)
        end

        -- KEYBIND
        function Section:Keybind(Name, Default, Callback)
            local Key = Default or Enum.KeyCode.Unknown
            local Listening = false
            local KeybindFrame = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Utility.Create("TextLabel", {
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Utility.Create("TextButton", {
                    Name = "KeyButton",
                    Size = UDim2.new(0, 60, 0, 25),
                    Position = UDim2.new(1, -70, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Theme.Background,
                    Text = Key.Name,
                    TextColor3 = Theme.Text,
                    TextSize = 11,
                    Font = Enum.Font.GothamSemibold,
                    AutoButtonColor = false
                }, { Utility.Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })
            })

            local KeyButton = KeybindFrame.KeyButton
            KeyButton.MouseButton1Click:Connect(function()
                Listening = true
                KeyButton.Text = "..."
                KeyButton.BackgroundColor3 = Theme.Accent
            end)

            UserInputService.InputBegan:Connect(function(Input, GPE)
                if GPE then return end
                if Listening then
                    Key = Input.KeyCode
                    KeyButton.Text = Key.Name
                    KeyButton.BackgroundColor3 = Theme.Background
                    Listening = false
                elseif Input.KeyCode == Key then
                    if Callback then Callback() end
                end
            end)
        end

        -- COLOR PICKER
        function Section:ColorPicker(Name, Default, Callback)
            local Color = Default or Color3.fromRGB(255, 255, 255)
            local Open = false
            local Hue, Sat, Val = 0, 1, 1
            
            local PickerFrame = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                ClipsDescendants = true,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Utility.Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Name,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Utility.Create("Frame", {
                    Name = "Preview",
                    Size = UDim2.new(0, 30, 0, 20),
                    Position = UDim2.new(1, -45, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color,
                    BorderSizePixel = 0
                }, { Utility.Create("UICorner", { CornerRadius = UDim.new(0, 4) }) }),
                Utility.Create("Frame", {
                    Name = "PickerContainer",
                    Size = UDim2.new(1, -20, 0, 80),
                    Position = UDim2.new(0, 10, 0, 40),
                    BackgroundTransparency = 1
                }, {
                    Utility.Create("TextLabel", { Size = UDim2.new(0, 30, 0, 15), Text = "Hue", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.Gotham, BackgroundTransparency = 1 }),
                    Utility.Create("Frame", {
                        Name = "HueBar",
                        Size = UDim2.new(1, -40, 0, 15),
                        Position = UDim2.new(0, 40, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                        BorderSizePixel = 0
                    }, {
                        Utility.Create("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)) }) }),
                        Utility.Create("Frame", { Name = "HueSelector", Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0 }, { Utility.Create("UICorner", { CornerRadius = UDim.new(0, 2) }) })
                    }),
                    Utility.Create("TextLabel", { Size = UDim2.new(0, 30, 0, 15), Position = UDim2.new(0, 0, 0, 25), Text = "Sat", TextColor3 = Theme.TextDim, TextSize = 11, Font = Enum.Font.Gotham, BackgroundTransparency = 1 }),
                    Utility.Create("Frame", {
                        Name = "SatBar",
                        Size = UDim2.new(1, -40, 0, 15),
                        Position = UDim2.new(0, 40, 0, 25),
                        BackgroundColor3 = Color3.fromRGB(128, 128, 128),
                        BorderSizePixel = 0
                    }, {
                        Utility.Create("Frame", { Name = "SatSelector", Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0 }, { Utility.Create("UICorner", { CornerRadius = UDim.new(0, 2) }) })
                    })
                })
            })

            local Preview = PickerFrame.Preview
            local PickerContainer = PickerFrame.PickerContainer
            local HueBar = PickerContainer.HueBar
            local SatBar = PickerContainer.SatBar
            
            local function UpdateColor()
                Color = Color3.fromHSV(Hue, Sat, 1)
                Preview.BackgroundColor3 = Color
                SatBar.BackgroundColor3 = Color3.fromHSV(Hue, 0.5, 1)
                if Callback then Callback(Color) end
            end

            -- Drag logic for Hue/Sat
            local DraggingHue, DraggingSat = false, false
            
            HueBar.InputBegan:Connect(function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 then DraggingHue = true end end)
            SatBar.InputBegan:Connect(function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 then DraggingSat = true end end)
            
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    DraggingHue = false
                    DraggingSat = false
                end
            end)

            UserInputService.InputChanged:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    if DraggingHue then
                        local p = math.clamp((Input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                        Hue = p
                        HueBar.HueSelector.Position = UDim2.new(p, 0, 0, 0)
                        UpdateColor()
                    end
                    if DraggingSat then
                        local p = math.clamp((Input.Position.X - SatBar.AbsolutePosition.X) / SatBar.AbsoluteSize.X, 0, 1)
                        Sat = p
                        SatBar.SatSelector.Position = UDim2.new(p, 0, 0, 0)
                        UpdateColor()
                    end
                end
            end)

            PickerFrame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Open = not Open
                    Utility.Tween(PickerFrame, 0.2, { Size = Open and UDim2.new(1, 0, 0, 130) or UDim2.new(1, 0, 0, 35) })
                end
            end)
        end

        -- LABEL
        function Section:Paragraph(Text)
            Utility.Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = Text,
                TextColor3 = Theme.TextDim,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ElementContainer
            })
        end

        return Section
    end

    -- CREATE TAB FUNCTION
    local function CreateTab(Name)
        local TabButton = Utility.Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Theme.Sidebar,
            Text = "",
            AutoButtonColor = false,
            Parent = Sidebar.TabContainer
        }, {
            Utility.Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
            Utility.Create("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = Name,
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        })

        local ContentFrame = Utility.Create("ScrollingFrame", {
            Name = Name .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.ScrollBar,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = ContentArea.ContentScroll
        }, {
            Utility.Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) }),
            Utility.Create("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5) })
        })

        TabButton.MouseButton1Click:Connect(function()
            SelectTab({ Button = TabButton, Content = ContentFrame })
        end)

        TabButton.MouseEnter:Connect(function()
            if CurrentTab and CurrentTab.Button ~= TabButton then Utility.Tween(TabButton, 0.2, { BackgroundColor3 = Theme.ElementBackground }) end
        end)
        TabButton.MouseLeave:Connect(function()
            if CurrentTab and CurrentTab.Button ~= TabButton then Utility.Tween(TabButton, 0.2, { BackgroundColor3 = Theme.Sidebar }) end
        end)

        local TabData = { Button = TabButton, Content = ContentFrame }
        if not CurrentTab then SelectTab(TabData) end

        function TabData:CreateSection(Title) return CreateSection(ContentFrame, Title) end

        return TabData
    end

    -- TOGGLE KEYBIND
    UserInputService.InputBegan:Connect(function(Input, GPE)
        if GPE then return end
        if Input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
            if ScreenGui.Enabled then
                MainFrame.Size = UDim2.new(0, 650, 0, 0)
                Utility.Tween(MainFrame, 0.3, { Size = UDim2.new(0, 650, 0, 450) })
            end
        end
    end)

    -- RETURN API
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Notify = Notify,
        CreateTab = CreateTab
    }
end

return AzuraUI
