local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Windo = { _VERSION = "0.0.2" }
Windo.__index = Windo

local Window = {} Window.__index = Window
local Tab = {} Tab.__index = Tab
local Section = {} Section.__index = Section

local function RandomString(l)
    local c, s = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", ""
    for _ = 1, l do s = s .. string.sub(c, math.random(1, #c), math.random(1, #c)) end
    return s
end

local function Tween(obj, time, style, dir, props)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local Colors = {
    Bg = Color3.fromRGB(18, 18, 18),
    Header = Color3.fromRGB(24, 24, 24),
    Elem = Color3.fromRGB(28, 28, 28),
    Border = Color3.fromRGB(45, 45, 45),
    Accent = Color3.fromRGB(0, 220, 60),
    Text = Color3.fromRGB(255, 255, 255),
    Sub = Color3.fromRGB(160, 160, 160)
}

local function NewInstance(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

function Windo.new()
    local self = setmetatable({}, Windo)
    local parent = CoreGui
    if not pcall(function() local _ = CoreGui.Name end) then parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end
    
    self.Gui = NewInstance("ScreenGui", {
        Name = "Windo_" .. RandomString(12),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = parent
    })
    
    self:ShowSplash()
    return self
end

function Windo:ShowSplash()
    local splash = NewInstance("Frame", {
        Name = "Splash_" .. RandomString(8),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BorderSizePixel = 0,
        ZIndex = 100,
        Parent = self.Gui
    })
    
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = splash})
    
    local logo = NewInstance("TextLabel", {
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(0.5, -150, 0.5, -40),
        BackgroundTransparency = 1,
        Text = "Windo",
        TextColor3 = Colors.Text,
        TextSize = 42,
        Font = Enum.Font.GothamBlack,
        ZIndex = 101,
        Parent = splash
    })
    
    local sub = NewInstance("TextLabel", {
        Size = UDim2.new(0, 300, 0, 20),
        Position = UDim2.new(0.5, -150, 0.5, 20),
        BackgroundTransparency = 1,
        Text = "Initializing environment...",
        TextColor3 = Colors.Sub,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        ZIndex = 101,
        Parent = splash
    })
    
    local bar = NewInstance("Frame", {
        Size = UDim2.new(0, 200, 0, 2),
        Position = UDim2.new(0.5, -100, 0.5, 60),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = splash
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = bar})
    
    local fill = NewInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        ZIndex = 102,
        Parent = bar
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})
    
    Tween(fill, 1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = UDim2.new(1, 0, 1, 0)})
    
    task.spawn(function()
        task.wait(2)
        Tween(splash, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In, {BackgroundTransparency = 1})
        Tween(logo, 0.5, nil, nil, {TextTransparency = 1})
        Tween(sub, 0.5, nil, nil, {TextTransparency = 1})
        Tween(bar, 0.5, nil, nil, {BackgroundTransparency = 1})
        Tween(fill, 0.5, nil, nil, {BackgroundTransparency = 1})
        task.wait(0.5)
        splash:Destroy()
    end)
end

function Windo:CreateWindow(config)
    config = config or {}
    local self = setmetatable({
        Tabs = {},
        CurrentTab = nil,
        Title = config.Title or "Windo Application"
    }, Window)
    
    self.Main = NewInstance("Frame", {
        Name = "Win_" .. RandomString(10),
        Size = UDim2.new(0, 650, 0, 450),
        Position = UDim2.new(0.5, -325, 0.5, -225),
        BackgroundColor3 = Colors.Bg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ScreenGui or self.Gui
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = self.Main})
    NewInstance("UIStroke", {Color = Colors.Border, Thickness = 1, Parent = self.Main})
    
    local header = NewInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Colors.Header,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = header})
    NewInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 1, -6),
        BackgroundColor3 = Colors.Header,
        BorderSizePixel = 0,
        Parent = header
    })
    
    NewInstance("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    local closeBtn = NewInstance("TextButton", {
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Colors.Sub,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = header
    })
    closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)
    
    self.TabBar = NewInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Colors.Header,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    NewInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Colors.Border,
        BorderSizePixel = 0,
        Parent = self.TabBar
    })
    
    local tabScroll = NewInstance("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.TabBar
    })
    local tabLayout = NewInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        Parent = tabScroll
    })
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 0, 0)
    end)
    
    self.Content = NewInstance("Frame", {
        Size = UDim2.new(1, -20, 1, -95),
        Position = UDim2.new(0, 10, 0, 85),
        BackgroundTransparency = 1,
        Parent = self.Main
    })
    
    local drag = false
    local dragStart, startPos
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dragStart = i.Position
            startPos = self.Main.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    
    return self
end

function Window:AddTab(config)
    config = config or {}
    local self = setmetatable({
        Title = config.Title or "Tab " .. (#self.Tabs + 1),
        Window = self,
        Elements = {}
    }, Tab)
    
    self.Button = NewInstance("TextButton", {
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Colors.Sub,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        Parent = self.Window.TabBar:FindFirstChildOfClass("ScrollingFrame")
    })
    
    self.Indicator = NewInstance("Frame", {
        Size = UDim2.new(0.8, 0, 0, 2),
        Position = UDim2.new(0.1, 0, 1, -2),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Visible = false,
        Parent = self.Button
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = self.Indicator})
    
    self.Container = NewInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = self.Window.Content
    })
    
    local layout = NewInstance("UIListLayout", {
        Padding = UDim.new(0, 15),
        Parent = self.Container
    })
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    NewInstance("UIPadding", {PaddingTop = UDim.new(0, 10), Parent = self.Container})
    
    self.Button.MouseButton1Click:Connect(function() self:Select() end)
    table.insert(self.Window.Tabs, self)
    if #self.Window.Tabs == 1 then self:Select() end
    
    return self
end

function Tab:Select()
    for _, t in pairs(self.Window.Tabs) do
        t.Button.TextColor3 = Colors.Sub
        t.Indicator.Visible = false
        t.Container.Visible = false
    end
    self.Button.TextColor3 = Colors.Text
    self.Indicator.Visible = true
    self.Container.Visible = true
    self.Window.CurrentTab = self
end

function Tab:AddSection(config)
    config = config or {}
    local self = setmetatable({
        Title = config.Title or "Section",
        Tab = self
    }, Section)
    
    local frame = NewInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = self.Tab.Container
    })
    
    NewInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Colors.Sub,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    NewInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Colors.Border,
        BorderSizePixel = 0,
        Parent = frame
    })
    
    self.Container = NewInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.Tab.Container
    })
    
    local layout = NewInstance("UIListLayout", {Padding = UDim.new(0, 8), Parent = self.Container})
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    return self
end

local function CreateElementBase(section, title)
    local frame = NewInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Colors.Elem,
        BorderSizePixel = 0,
        Parent = section.Container
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = frame})
    NewInstance("UIStroke", {Color = Colors.Border, Thickness = 1, Parent = frame})
    
    NewInstance("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Colors.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    frame.MouseEnter:Connect(function() Tween(frame:FindFirstChildOfClass("UIStroke"), 0.2, nil, nil, {Color = Color3.fromRGB(70, 70, 70)}) end)
    frame.MouseLeave:Connect(function() Tween(frame:FindFirstChildOfClass("UIStroke"), 0.2, nil, nil, {Color = Colors.Border}) end)
    
    return frame
end

function Section:AddButton(config)
    config = config or {}
    local frame = CreateElementBase(self, config.Title or "Button")
    
    local btn = NewInstance("TextButton", {
        Size = UDim2.new(0, 80, 0, 26),
        Position = UDim2.new(1, -95, 0.5, -13),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Text = "Execute",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = frame
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn})
    
    btn.MouseButton1Click:Connect(function()
        if config.Callback then
            task.spawn(config.Callback)
        end
        Tween(btn, 0.1, nil, nil, {Size = UDim2.new(0, 75, 0, 24)})
        task.wait(0.1)
        Tween(btn, 0.1, nil, nil, {Size = UDim2.new(0, 80, 0, 26)})
    end)
end

function Section:AddToggle(config)
    config = config or {}
    local state = config.Default or false
    local frame = CreateElementBase(self, config.Title or "Toggle")
    
    local box = NewInstance("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -33, 0.5, -9),
        BackgroundColor3 = Colors.Bg,
        BorderSizePixel = 0,
        Parent = frame
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = box})
    NewInstance("UIStroke", {Color = Colors.Border, Thickness = 1, Parent = box})
    
    local ind = NewInstance("Frame", {
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(0.5, -4, 0.5, -4),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Visible = state,
        Parent = box
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ind})
    
    local function Update()
        ind.Visible = state
        if config.Callback then task.spawn(config.Callback, state) end
    end
    
    local hit = NewInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = frame
    })
    
    hit.MouseButton1Click:Connect(function()
        state = not state
        Update()
    end)
    
    Update()
end

function Section:AddLabel(config)
    config = config or {}
    local frame = CreateElementBase(self, config.Title or "Label")
    frame.BackgroundTransparency = 1
    frame:FindFirstChildOfClass("UIStroke"):Destroy()
    
    local lbl = frame:FindFirstChildOfClass("TextLabel")
    lbl.Size = UDim2.new(1, -30, 1, 0)
    lbl.TextColor3 = Colors.Sub
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    frame.Size = UDim2.new(1, 0, 0, 20)
end

function Section:AddKeybind(config)
    config = config or {}
    local key = config.Default or Enum.KeyCode.Unknown
    local frame = CreateElementBase(self, config.Title or "Keybind")
    
    local btn = NewInstance("TextButton", {
        Size = UDim2.new(0, 80, 0, 26),
        Position = UDim2.new(1, -95, 0.5, -13),
        BackgroundColor3 = Colors.Bg,
        BorderSizePixel = 0,
        Text = key == Enum.KeyCode.Unknown and "None" or key.Name,
        TextColor3 = Colors.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Parent = frame
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn})
    NewInstance("UIStroke", {Color = Colors.Border, Thickness = 1, Parent = btn})
    
    local listening = false
    
    btn.MouseButton1Click:Connect(function()
        listening = true
        btn.Text = "..."
    end)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                btn.Text = key.Name
            else
                key = Enum.KeyCode.Unknown
                btn.Text = "None"
            end
            listening = false
        elseif not listening and input.KeyCode == key then
            if config.Callback then task.spawn(config.Callback) end
        end
    end)
end

function Section:AddDropdown(config)
    config = config or {}
    local options = config.Options or {}
    local selected = config.Default or options[1]
    local frame = CreateElementBase(self, config.Title or "Dropdown")
    
    local btn = NewInstance("TextButton", {
        Size = UDim2.new(0, 120, 0, 26),
        Position = UDim2.new(1, -135, 0.5, -13),
        BackgroundColor3 = Colors.Bg,
        BorderSizePixel = 0,
        Text = selected or "Select",
        TextColor3 = Colors.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Parent = frame
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn})
    NewInstance("UIStroke", {Color = Colors.Border, Thickness = 1, Parent = btn})
    
    local popup = NewInstance("Frame", {
        Size = UDim2.new(0, 120, 0, 0),
        BackgroundColor3 = Colors.Header,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
        ClipsDescendants = true,
        Parent = self.Tab.Container.Parent.Parent
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = popup})
    NewInstance("UIStroke", {Color = Colors.Border, Thickness = 1, Parent = popup})
    
    local layout = NewInstance("UIListLayout", {Parent = popup})
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        popup.Size = UDim2.new(0, 120, 0, math.min(layout.AbsoluteContentSize.Y, 150))
    end)
    
    local function Update()
        btn.Text = selected or "Select"
        if config.Callback then task.spawn(config.Callback, selected) end
    end
    
    local function Build()
        for _, child in pairs(popup:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, opt in pairs(options) do
            local ob = NewInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = "  " .. opt,
                TextColor3 = opt == selected and Colors.Accent or Colors.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 11,
                Parent = popup
            })
            ob.MouseButton1Click:Connect(function()
                selected = opt
                Update()
                popup.Visible = false
            end)
            ob.MouseEnter:Connect(function() ob.BackgroundTransparency = 0.8 end)
            ob.MouseLeave:Connect(function() ob.BackgroundTransparency = 1 end)
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        popup.Position = UDim2.new(0, btn.AbsolutePosition.X, 0, btn.AbsolutePosition.Y + 30)
        popup.Visible = not popup.Visible
        if popup.Visible then Build() end
    end)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ap = input.Position
            local ps = popup.AbsolutePosition
            local psz = popup.AbsoluteSize
            if popup.Visible and (ap.X < ps.X or ap.X > ps.X + psz.X or ap.Y < ps.Y or ap.Y > ps.Y + psz.Y) then
                popup.Visible = false
            end
        end
    end)
    
    Update()
end

function Section:AddColorPicker(config)
    config = config or {}
    local color = config.Default or Color3.fromRGB(255, 255, 255)
    local frame = CreateElementBase(self, config.Title or "Color")
    
    local btn = NewInstance("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -41, 0.5, -13),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Text = "",
        Parent = frame
    })
    NewInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn})
    NewInstance("UIStroke", {Color = Colors.Border, Thickness = 1, Parent = btn})
    
    local function Update()
        btn.BackgroundColor3 = color
        if config.Callback then task.spawn(config.Callback, color) end
    end
    
    btn.MouseButton1Click:Connect(function()
        -- Simplified color picker logic for brevity in this massive file
        local picker = NewInstance("Frame", {
            Size = UDim2.new(0, 200, 0, 200),
            Position = UDim2.new(0, btn.AbsolutePosition.X - 150, 0, btn.AbsolutePosition.Y + 30),
            BackgroundColor3 = Colors.Header,
            BorderSizePixel = 0,
            ZIndex = 20,
            Parent = self.Tab.Container.Parent.Parent
        })
        NewInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = picker})
        NewInstance("UIStroke", {Color = Colors.Border, Thickness = 1, Parent = picker})
        
        local rgb = NewInstance("ImageButton", {
            Size = UDim2.new(0, 150, 0, 150),
            Position = UDim2.new(0, 10, 0, 10),
            Image = "rbxassetid://6885811389", -- Standard Saturation/Value image
            ZIndex = 21,
            Parent = picker
        })
        
        local close = NewInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 1, -30),
            BackgroundColor3 = Colors.Accent,
            Text = "Apply",
            TextColor3 = Color3.fromRGB(0,0,0),
            Font = Enum.Font.GothamBold,
            ZIndex = 21,
            Parent = picker
        })
        NewInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = close})
        
        close.MouseButton1Click:Connect(function() picker:Destroy() end)
        UserInputService.InputBegan:Connect(function(i, p)
            if p then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 and not picker:IsAncestorOf(i.Position) then
                task.wait(0.1)
                if picker and picker.Parent then picker:Destroy() end
            end
        end)
    end)
    
    Update()
end

function Window:Destroy()
    if self.Main then
        Tween(self.Main, 0.3, nil, Enum.EasingDirection.In, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
        task.wait(0.3)
        self.Main:Destroy()
    end
end

return Windo
