local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Windo = {
    _VERSION = "0.0.1"
}
Windo.__index = Windo

local Window = {}
Window.__index = Window

local function RandomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local str = ""
    for _ = 1, length do
        local rand = math.random(1, #chars)
        str = str .. string.sub(chars, rand, rand)
    end
    return str
end

local function AnimateProperty(instance, property, target, time, style)
    local info = TweenInfo.new(time or 0.4, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, {[property] = target})
    tween:Play()
    return tween
end

function Windo.new()
    local self = setmetatable({}, Windo)
    math.randomseed(tick())
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "Windo_" .. RandomString(12)
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = CoreGui
    
    self:ShowSplash()
    
    return self
end

function Windo:ShowSplash()
    local splash = Instance.new("Frame")
    splash.Name = "Splash_" .. RandomString(8)
    splash.Size = UDim2.new(1, 0, 1, 0)
    splash.Position = UDim2.new(0, 0, 0, 0)
    splash.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    splash.BorderSizePixel = 0
    splash.ZIndex = 100
    splash.Parent = self.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = splash

    local logo = Instance.new("TextLabel")
    logo.Name = "Logo_" .. RandomString(6)
    logo.Size = UDim2.new(0, 200, 0, 50)
    logo.Position = UDim2.new(0.5, -100, 0.5, -30)
    logo.BackgroundTransparency = 1
    logo.Text = "Windo"
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.TextSize = 32
    logo.Font = Enum.Font.GothamBold
    logo.ZIndex = 101
    logo.Parent = splash

    local subText = Instance.new("TextLabel")
    subText.Name = "Sub_" .. RandomString(6)
    subText.Size = UDim2.new(0, 200, 0, 20)
    subText.Position = UDim2.new(0.5, -100, 0.5, 10)
    subText.BackgroundTransparency = 1
    subText.Text = "Loading environment..."
    subText.TextColor3 = Color3.fromRGB(150, 150, 150)
    subText.TextSize = 12
    subText.Font = Enum.Font.Gotham
    subText.ZIndex = 101
    subText.Parent = splash

    local barBg = Instance.new("Frame")
    barBg.Name = "BarBg_" .. RandomString(6)
    barBg.Size = UDim2.new(0, 200, 0, 4)
    barBg.Position = UDim2.new(0.5, -100, 0.5, 40)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 101
    barBg.Parent = splash

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Name = "BarFill_" .. RandomString(6)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 50)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 102
    barFill.Parent = barBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = barFill

    local fillTween = TweenService:Create(barFill, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    fillTween:Play()

    fillTween.Completed:Connect(function()
        task.wait(0.3)
        local fadeOut = TweenService:Create(splash, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local logoFade = TweenService:Create(logo, TweenInfo.new(0.5), {TextTransparency = 1})
        local subFade = TweenService:Create(subText, TweenInfo.new(0.5), {TextTransparency = 1})
        local barBgFade = TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        local barFillFade = TweenService:Create(barFill, TweenInfo.new(0.5), {BackgroundTransparency = 1})

        fadeOut:Play()
        logoFade:Play()
        subFade:Play()
        barBgFade:Play()
        barFillFade:Play()

        fadeOut.Completed:Connect(function()
            splash:Destroy()
        end)
    end)
end

function Windo:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Windo"
    local size = config.Size or UDim2.new(0, 550, 0, 400)
    local position = config.Position or UDim2.new(0.5, -275, 0.5, -200)
    local backgroundColor = config.BackgroundColor or Color3.fromRGB(15, 15, 15)
    local borderColor = config.BorderColor or Color3.fromRGB(0, 255, 50)

    local window = setmetatable({}, Window)

    local frame = Instance.new("Frame")
    frame.Name = "Win_" .. RandomString(10)
    frame.Size = UDim2.new(0, 0, 0, 0) -- Start small for animation
    frame.Position = position
    frame.BackgroundColor3 = backgroundColor
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = self.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 2)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = borderColor
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Miter
    stroke.Transparency = 1 -- Start transparent for animation
    stroke.Parent = frame

    window.Frame = frame
    window.Stroke = stroke

    task.wait(2.2) -- Wait for splash screen to disappear
    
    local sizeTween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = size})
    local strokeTween = TweenService:Create(stroke, TweenInfo.new(0.5), {Transparency = 0})
    
    sizeTween:Play()
    strokeTween:Play()

    return window
end

function Window:Destroy()
    if self.Frame then
        self.Frame:Destroy()
        self.Frame = nil
    end
end

function Windo:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
end

return Windo
