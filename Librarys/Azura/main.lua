--[[
    Azura UI Library (Fixed & Improved)
    Features: Sidebar, Tabs, Notifications, Toggles, Sliders, Dropdowns, Keybinds, ColorPicker, and more.
    Smooth animations and modern design.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ─────────────────────────────────────────────────────────────────────────────
-- SERVICES & UTILITIES
-- ─────────────────────────────────────────────────────────────────────────────

local Utility = {}

-- Smooth tweening function
function Utility.Tween(Object, Time, Properties)
    local Tween = TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), Properties)
    Tween:Play()
    return Tween
end

-- Rounding numbers for sliders
function Utility.Round(Number, DecimalPlaces)
    local Multiplier = 10 ^ (DecimalPlaces or 0)
    return math.floor(Number * Multiplier + 0.5) / Multiplier
end

-- Helper to create instances quickly
function Utility.Create(ClassName, Properties, Children)
    local Object = Instance.new(ClassName)
    
    for Property, Value in pairs(Properties or {}) do
        Object[Property] = Value
    end
    
    for _, Child in pairs(Children or {}) do
        Child.Parent = Object
    end
    
    return Object
end

-- ─────────────────────────────────────────────────────────────────────────────
-- COLOR THEME
-- ─────────────────────────────────────────────────────────────────────────────

local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(15, 15, 20),
    TabBackground = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(100, 120, 255),
    AccentHover = Color3.fromRGB(120, 140, 255),
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
-- NOTIFICATION SYSTEM
-- ─────────────────────────────────────────────────────────────────────────────

local NotificationHolder = nil

local function SetupNotifications(ScreenGui)
    NotificationHolder = Utility.Create("Frame", {
        Name = "NotificationHolder",
        Size = UDim2.new(0, 350, 1, 0),
        Position = UDim2.new(1, -360, 0, 10),
        AnchorPoint = Vector2.new(0, 0),
        BackgroundTransparency = 1,
        Parent = ScreenGui
    }, {
        Utility.Create("UIListLayout", {
            Name = "Layout",
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
    })
end

local function Notify(Title, Message, Type, Duration)
    if not NotificationHolder then return end
    
    Type = Type or "info"
    Duration = Duration or 4
    
    local Colors = {
        success = Theme.Success,
        warning = Theme.Warning,
        error = Theme.Error,
        info = Theme.Info
    }
    
    local Notification = Utility.Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 0), -- Start collapsed
        BackgroundColor3 = Theme.ElementBackground,
        ClipsDescendants = true,
        Parent = NotificationHolder
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility.Create("UIStroke", {Color = Theme.Border, Thickness = 1}),
        Utility.Create("Frame", {
            Name = "AccentBar",
            Size = UDim2.new(0, 4, 1, 0),
            BackgroundColor3 = Colors[Type] or Theme.Info,
            BorderSizePixel = 0
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)})
        }),
        Utility.Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 15, 0, 10),
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Colors[Type] or Theme.Info,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility.Create("TextLabel", {
            Name = "Message",
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 15, 0, 32),
            BackgroundTransparency = 1,
            Text = Message,
            TextColor3 = Theme.TextDim,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        }),
        Utility.Create("Frame", {
            Name = "TimerBar",
            Size = UDim2.new(1, -10, 0, 3),
            Position = UDim2.new(0, 5, 1, -5),
            BackgroundColor3 = Colors[Type] or Theme.Info,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 2)})
        })
    })
    
    -- Animate In
    Utility.Tween(Notification, 0.3, {Size = UDim2.new(1, 0, 0, 70)})
    
    -- Timer Animation
    local TimerBar = Notification:FindFirstChild("TimerBar")
    if TimerBar then
        Utility.Tween(TimerBar, Duration, {Size = UDim2.new(0, 0, 0, 3)})
    end
    
    -- Animate Out
    task.delay(Duration, function()
        Utility.Tween(Notification, 0.3, {Size = UDim2.new(1, 0, 0, 0)})
        task.wait(0.3)
        Notification:Destroy()
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- MAIN UI CREATION
-- ─────────────────────────────────────────────────────────────────────────────

local AzuraUI = {}

function AzuraUI.Create(Options)
    Options = Options or {}
    local Title = Options.Title or "Azura UI"
    
    -- ScreenGui
    local ScreenGui = Utility.Create("ScreenGui", {
        Name = "AzuraUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = game.CoreGui -- Use game.CoreGui to ensure it stays
    })
    
    -- Setup Notifications
    SetupNotifications(ScreenGui)
    
    -- Main Container
    local MainFrame = Utility.Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 650, 0, 450),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
        Parent = ScreenGui
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Utility.Create("UIStroke", {Color = Theme.Border, Thickness = 1})
    })
    
    -- Draggable functionality
    local Dragging, DragStart, StartPos = false, nil, nil
    
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
    
    -- Sidebar
    local Sidebar = Utility.Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Utility.Create("Frame", { -- Fixes the corner gap
            Name = "CornerFix",
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -20, 0, 0),
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel = 0
        }),
        Utility.Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0, 0, 0, 15),
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Theme.Text,
            TextSize = 20,
            Font = Enum.Font.GothamBold
        }),
        Utility.Create("Frame", {
            Name = "Divider",
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
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, {
            Utility.Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5)
            }),
            Utility.Create("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
        })
    })
    
    -- Tab Content Area
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
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, {
            Utility.Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            }),
            Utility.Create("UIPadding", {
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5)
            })
        })
    })
    
    -- Close Button
    local CloseButton = Utility.Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 10),
        BackgroundColor3 = Theme.Error,
        Text = "",
        AutoButtonColor = false,
        Parent = ContentArea
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
    
    CloseButton.MouseEnter:Connect(function()
        Utility.Tween(CloseButton, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 120, 120)})
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Utility.Tween(CloseButton, 0.2, {BackgroundColor3 = Theme.Error})
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Utility.Tween(MainFrame, 0.3, {Size = UDim2.new(0, 650, 0, 0)})
        task.wait(0.3)
        ScreenGui.Enabled = false
        MainFrame.Size = UDim2.new(0, 650, 0, 450) -- Reset size for next open
    end)
    
    -- Minimize Button
    local MinimizeButton = Utility.Create("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -80, 0, 10),
        BackgroundColor3 = Theme.Warning,
        Text = "",
        AutoButtonColor = false,
        Parent = ContentArea
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
            Utility.Tween(MainFrame, 0.3, {Size = UDim2.new(0, 180, 0, 450)})
        else
            Utility.Tween(MainFrame, 0.3, {Size = UDim2.new(0, 650, 0, 450)})
        end
    end)
    
    -- Tab Management
    local Tabs = {}
    local CurrentTab = nil
    
    local function SelectTab(Tab)
        if CurrentTab then
            CurrentTab.Button.BackgroundColor3 = Theme.Sidebar
            CurrentTab.Content.Visible = false
        end
        CurrentTab = Tab
        Tab.Button.BackgroundColor3 = Theme.Accent
        Tab.Content.Visible = true
    end
    
    -- ─────────────────────────────────────────────────────────────────────────
    -- ELEMENT CREATION FUNCTIONS
    -- ─────────────────────────────────────────────────────────────────────────
    
    local function CreateSection(Container, SectionTitle)
        local SectionFrame = Utility.Create("Frame", {
            Name = "Section",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.ElementBackground,
            Parent = Container
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Utility.Create("UIStroke", {Color = Theme.Border, Thickness = 1}),
            Utility.Create("TextLabel", {
                Name = "SectionTitle",
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
                Utility.Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6)
                }),
                Utility.Create("UIPadding", {
                    PaddingBottom = UDim.new(0, 10)
                })
            })
        })
        
        local ElementContainer = SectionFrame:FindFirstChild("ElementContainer")
        
        local Section = {}
        
        -- BUTTON
        function Section:Button(Name, Callback)
            Callback = Callback or function() end
            
            local Button = Utility.Create("TextButton", {
                Name = Name,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                Text = "",
                AutoButtonColor = false,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
            
            Button.MouseEnter:Connect(function()
                Utility.Tween(Button, 0.2, {BackgroundColor3 = Theme.ElementBackgroundHover})
            end)
            
            Button.MouseLeave:Connect(function()
                Utility.Tween(Button, 0.2, {BackgroundColor3 = Theme.TabBackground})
            end)
            
            Button.MouseButton1Click:Connect(Callback)
            
            return Button
        end
        
        -- TOGGLE
        function Section:Toggle(Name, Default, Callback)
            Callback = Callback or function() end
            local Toggled = Default or false
            
            local ToggleFrame = Utility.Create("Frame", {
                Name = Name,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
                    Name = "ToggleIndicator",
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -50, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Theme.Border,
                    BorderSizePixel = 0
                }, {
                    Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Utility.Create("Frame", {
                        Name = "Circle",
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(0, 2, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Theme.Text,
                        BorderSizePixel = 0
                    }, {
                        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                    })
                })
            })
            
            local Indicator = ToggleFrame:FindFirstChild("ToggleIndicator")
            local Circle = Indicator:FindFirstChild("Circle")
            
            local function Update()
                if Toggled then
                    Utility.Tween(Indicator, 0.2, {BackgroundColor3 = Theme.Accent})
                    Utility.Tween(Circle, 0.2, {Position = UDim2.new(0, 22, 0.5, 0)})
                else
                    Utility.Tween(Indicator, 0.2, {BackgroundColor3 = Theme.Border})
                    Utility.Tween(Circle, 0.2, {Position = UDim2.new(0, 2, 0.5, 0)})
                end
                Callback(Toggled)
            end
            
            Update()
            
            ToggleFrame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggled = not Toggled
                    Update()
                end
            end)
            
            return {
                Set = function(Value)
                    Toggled = Value
                    Update()
                end,
                Get = function()
                    return Toggled
                end
            }
        end
        
        -- SLIDER
        function Section:Slider(Name, Min, Max, Default, Callback)
            Callback = Callback or function() end
            Min = Min or 0
            Max = Max or 100
            Default = Default or Min
            
            local SliderFrame = Utility.Create("Frame", {
                Name = Name,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Theme.TabBackground,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
                    Text = tostring(Default),
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
                    Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Utility.Create("Frame", {
                        Name = "Fill",
                        Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                        BackgroundColor3 = Theme.Accent,
                        BorderSizePixel = 0
                    }, {
                        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                        Utility.Create("Frame", {
                            Name = "Knob",
                            Size = UDim2.new(0, 14, 0, 14),
                            Position = UDim2.new(1, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundColor3 = Theme.Text,
                            BorderSizePixel = 0
                        }, {
                            Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                        })
                    })
                })
            })
            
            local SliderBar = SliderFrame:FindFirstChild("SliderBar")
            local Fill = SliderBar:FindFirstChild("Fill")
            local ValueLabel = SliderFrame:FindFirstChild("ValueLabel")
            
            local Sliding = false
            local Value = Default
            
            local function Update(InputPosition)
                local Percent = math.clamp((InputPosition.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Value = Utility.Round(Min + (Max - Min) * Percent, 1)
                Fill.Size = UDim2.new(Percent, 0, 1, 0)
                ValueLabel.Text = tostring(Value)
                Callback(Value)
            end
            
            SliderBar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true
                    Update(Input.Position)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement and Sliding then
                    Update(Input.Position)
                end
            end)
            
            return {
                Set = function(NewValue)
                    Value = math.clamp(NewValue, Min, Max)
                    local Percent = (Value - Min) / (Max - Min)
                    Fill.Size = UDim2.new(Percent, 0, 1, 0)
                    ValueLabel.Text = tostring(Value)
                    Callback(Value)
                end,
                Get = function()
                    return Value
                end
            }
        end
        
        -- DROPDOWN
        function Section:Dropdown(Name, Options, Default, Callback)
            Callback = Callback or function() end
            Options = Options or {}
            local Selected = Default or Options[1] or "Select..."
            local Open = false
            
            local DropdownFrame = Utility.Create("Frame", {
                Name = Name,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                ClipsDescendants = true,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
                }, {
                    Utility.Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                })
            })
            
            local SelectedLabel = DropdownFrame:FindFirstChild("SelectedLabel")
            local OptionContainer = DropdownFrame:FindFirstChild("OptionContainer")
            
            local function RefreshOptions()
                -- Clear old
                for _, Child in pairs(OptionContainer:GetChildren()) do
                    if Child:IsA("TextButton") then Child:Destroy() end
                end
                
                for _, Option in pairs(Options) do
                    local OptionBtn = Utility.Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = Theme.TabBackground,
                        BackgroundTransparency = 1,
                        Text = "",
                        AutoButtonColor = false,
                        Parent = OptionContainer
                    }, {
                        Utility.Create("TextLabel", {
                            Size = UDim2.new(1, -20, 1, 0),
                            Position = UDim2.new(0, 15, 0, 0),
                            BackgroundTransparency = 1,
                            Text = Option,
                            TextColor3 = Theme.Text,
                            TextSize = 12,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left
                        })
                    })
                    
                    OptionBtn.MouseEnter:Connect(function()
                        Utility.Tween(OptionBtn, 0.1, {BackgroundTransparency = 0})
                    end)
                    OptionBtn.MouseLeave:Connect(function()
                        Utility.Tween(OptionBtn, 0.1, {BackgroundTransparency = 1})
                    end)
                    
                    OptionBtn.MouseButton1Click:Connect(function()
                        Selected = Option
                        SelectedLabel.Text = Selected
                        Callback(Selected)
                        Open = false
                        Utility.Tween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 35)})
                    end)
                end
            end
            
            RefreshOptions()
            
            DropdownFrame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Open = not Open
                    if Open then
                        Utility.Tween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 40 + #Options * 28)})
                    else
                        Utility.Tween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 35)})
                    end
                end
            end)
            
            return {
                Set = function(Value)
                    Selected = Value
                    SelectedLabel.Text = Selected
                    Callback(Selected)
                end,
                Get = function() return Selected end,
                Refresh = function(NewOptions)
                    Options = NewOptions
                    RefreshOptions()
                end
            }
        end
        
        -- TEXTBOX
        function Section:Textbox(Name, Placeholder, Callback)
            Callback = Callback or function() end
            Placeholder = Placeholder or "Enter text..."
            
            local TextboxFrame = Utility.Create("Frame", {
                Name = Name,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Theme.TabBackground,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
                    PlaceholderText = Placeholder,
                    PlaceholderColor3 = Theme.TextDim,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    ClearTextOnFocus = false
                }, {
                    Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)})
                })
            })
            
            local Input = TextboxFrame:FindFirstChild("Input")
            Input.FocusLost:Connect(function(enterPressed)
                Callback(Input.Text, enterPressed)
            end)
            
            return {
                Set = function(Text) Input.Text = Text end,
                Get = function() return Input.Text end
            }
        end
        
        -- KEYBIND
        function Section:Keybind(Name, Default, Callback)
            Callback = Callback or function() end
            local Key = Default or Enum.KeyCode.Unknown
            local Listening = false
            
            local KeybindFrame = Utility.Create("Frame", {
                Name = Name,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
                }, {
                    Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)})
                })
            })
            
            local KeyButton = KeybindFrame:FindFirstChild("KeyButton")
            
            KeyButton.MouseButton1Click:Connect(function()
                Listening = true
                KeyButton.Text = "..."
                KeyButton.BackgroundColor3 = Theme.Accent
            end)
            
            UserInputService.InputBegan:Connect(function(Input, GameProcessed)
                if GameProcessed then return end
                
                if Listening then
                    Key = Input.KeyCode
                    KeyButton.Text = Key.Name
                    KeyButton.BackgroundColor3 = Theme.Background
                    Listening = false
                elseif Key and Input.KeyCode == Key then
                    Callback()
                end
            end)
            
            return {
                Set = function(NewKey)
                    Key = NewKey
                    KeyButton.Text = Key.Name
                end,
                Get = function() return Key end
            }
        end
        
        -- COLOR PICKER
        function Section:ColorPicker(Name, Default, Callback)
            Callback = Callback or function() end
            local Color = Default or Color3.fromRGB(255, 255, 255)
            local Open = false
            
            local PickerFrame = Utility.Create("Frame", {
                Name = Name,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.TabBackground,
                ClipsDescendants = true,
                Parent = ElementContainer
            }, {
                Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
                    Name = "ColorPreview",
                    Size = UDim2.new(0, 30, 0, 20),
                    Position = UDim2.new(1, -45, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color,
                    BorderSizePixel = 0
                }, {
                    Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)})
                }),
                Utility.Create("Frame", {
                    Name = "PickerContainer",
                    Size = UDim2.new(1, -20, 0, 150),
                    Position = UDim2.new(0, 10, 0, 40),
                    BackgroundTransparency = 1
                }, {
                    Utility.Create("TextLabel", {
                        Name = "HueLabel",
                        Size = UDim2.new(0, 40, 0, 15),
                        BackgroundTransparency = 1,
                        Text = "Hue",
                        TextColor3 = Theme.TextDim,
                        TextSize = 11,
                        Font = Enum.Font.Gotham
                    }),
                    Utility.Create("Frame", {
                        Name = "HueBar",
                        Size = UDim2.new(1, -50, 0, 15),
                        Position = UDim2.new(0, 50, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                        BorderSizePixel = 0
                    }, {
                        Utility.Create("UIGradient", {
                            Rotation = 0,
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                            })
                        }),
                        Utility.Create("Frame", {
                            Name = "HueSelector",
                            Size = UDim2.new(0, 4, 1, 0),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BorderSizePixel = 0
                        }, {
                            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 2)})
                        })
                    }),
                    Utility.Create("TextLabel", {
                        Name = "SatLabel",
                        Size = UDim2.new(0, 40, 0, 15),
                        Position = UDim2.new(0, 0, 0, 25),
                        BackgroundTransparency = 1,
                        Text = "Sat",
                        TextColor3 = Theme.TextDim,
                        TextSize = 11,
                        Font = Enum.Font.Gotham
                    }),
                    Utility.Create("Frame", {
                        Name = "SatBar",
                        Size = UDim2.new(1, -50, 0, 15),
                        Position = UDim2.new(0, 50, 0, 25),
                        BackgroundColor3 = Color3.fromRGB(128, 128, 128),
                        BorderSizePixel = 0
                    }, {
                        Utility.Create("Frame", {
                            Name = "SatSelector",
                            Size = UDim2.new(0, 4, 1, 0),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BorderSizePixel = 0
                        }, {
                            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 2)})
                        })
                    })
                })
            })
            
            local ColorPreview = PickerFrame:FindFirstChild("ColorPreview")
            local PickerContainer = PickerFrame:FindFirstChild("PickerContainer")
            local HueBar = PickerContainer:FindFirstChild("HueBar")
            local HueSelector = HueBar:FindFirstChild("HueSelector")
            local SatBar = PickerContainer:FindFirstChild("SatBar")
            local SatSelector = SatBar:FindFirstChild("SatSelector")
            
            local Hue, Sat, Val = 0, 1, 1
            
            local function UpdateColor()
                Color = Color3.fromHSV(Hue, Sat, Val)
                ColorPreview.BackgroundColor3 = Color
                SatBar.BackgroundColor3 = Color3.fromHSV(Hue, 0.5, 1)
                Callback(Color)
            end
            
            -- Hue Logic
            local HueDragging = false
            HueBar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    HueDragging = true
                    local Percent = math.clamp((Input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                    Hue = Percent
                    HueSelector.Position = UDim2.new(Percent, 0, 0, 0)
                    UpdateColor()
                end
            end)
            
            -- Sat Logic
            local SatDragging = false
            SatBar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SatDragging = true
                    local Percent = math.clamp((Input.Position.X - SatBar.AbsolutePosition.X) / SatBar.AbsoluteSize.X, 0, 1)
                    Sat = Percent
                    SatSelector.Position = UDim2.new(Percent, 0, 0, 0)
                    UpdateColor()
                end
            end)
            
            -- Global Input Ended
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    HueDragging = false
                    SatDragging = false
                end
            end)
            
            -- Global Input Changed
            UserInputService.InputChanged:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    if HueDragging then
                        local Percent = math.clamp((Input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                        Hue = Percent
                        HueSelector.Position = UDim2.new(Percent, 0, 0, 0)
                        UpdateColor()
                    end
                    if SatDragging then
                        local Percent = math.clamp((Input.Position.X - SatBar.AbsolutePosition.X) / SatBar.AbsoluteSize.X, 0, 1)
                        Sat = Percent
                        SatSelector.Position = UDim2.new(Percent, 0, 0, 0)
                        UpdateColor()
                    end
                end
            end)
            
            -- Toggle Open
            PickerFrame.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Open then
                    Open = true
                    Utility.Tween(PickerFrame, 0.2, {Size = UDim2.new(1, 0, 0, 200)})
                end
            end)
            
            -- Close on outside click
            UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and Open then
                    local MousePos = UserInputService:GetMouseLocation()
                    local FramePos = PickerFrame.AbsolutePosition
                    local FrameSize = PickerFrame.AbsoluteSize
                    
                    if MousePos.X < FramePos.X or MousePos.X > FramePos.X + FrameSize.X or
                       MousePos.Y < FramePos.Y or MousePos.Y > FramePos.Y + FrameSize.Y then
                        Open = false
                        Utility.Tween(PickerFrame, 0.2, {Size = UDim2.new(1, 0, 0, 35)})
                    end
                end
            end)
            
            return {
                Set = function(NewColor)
                    Color = NewColor
                    Hue, Sat, Val = Color3.toHSV(Color)
                    ColorPreview.BackgroundColor3 = Color
                end,
                Get = function() return Color end
            }
        end
        
        -- PARAGRAPH / LABEL
        function Section:Paragraph(Text)
            local Label = Utility.Create("TextLabel", {
                Name = "Paragraph",
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
            return Label
        end
        
        return Section
    end
    
    -- Tab Creation Function
    local function CreateTab(Name, Icon)
        local TabButton = Utility.Create("TextButton", {
            Name = Name,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Theme.Sidebar,
            Text = "",
            AutoButtonColor = false,
            Parent = Sidebar:FindFirstChild("TabContainer")
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
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
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = ContentArea:FindFirstChild("ContentScroll")
        }, {
            Utility.Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            }),
            Utility.Create("UIPadding", {
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5)
            })
        })
        
        TabButton.MouseButton1Click:Connect(function()
            SelectTab({Button = TabButton, Content = ContentFrame})
        end)
        
        TabButton.MouseEnter:Connect(function()
            if CurrentTab and CurrentTab.Button ~= TabButton then
                Utility.Tween(TabButton, 0.2, {BackgroundColor3 = Theme.ElementBackground})
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab and CurrentTab.Button ~= TabButton then
                Utility.Tween(TabButton, 0.2, {BackgroundColor3 = Theme.Sidebar})
            end
        end)
        
        local Tab = {
            Button = TabButton,
            Content = ContentFrame,
            CreateSection = function(self, Title)
                return CreateSection(self.Content, Title)
            end
        }
        
        -- Auto-select first tab
        if not CurrentTab then
            SelectTab(Tab)
        end
        
        return Tab
    end
    
    -- Toggle UI keybind
    UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if Input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
            if ScreenGui.Enabled then
                MainFrame.Size = UDim2.new(0, 650, 0, 0)
                Utility.Tween(MainFrame, 0.3, {Size = UDim2.new(0, 650, 0, 450)})
            end
        end
    end)
    
    -- Return the API
    local UI = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Notify = Notify,
        CreateTab = CreateTab
    }
    
    -- Global access (optional, commonly used in exploit environments)
    if getgenv then
        getgenv().AzuraUI = UI
    end
    
    return UI
end

return AzuraUI
