local CoreGui = game:GetService("CoreGui")

local Windo = {
    _VERSION = "0.0.1"
}
Windo.__index = Windo

local Window = {}
Window.__index = Window

function Windo.new()
    local self = setmetatable({}, Windo)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WindoCoreUI_" .. math.random(100000, 999999)
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = CoreGui
    
    return self
end

function Windo:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Windo v0.0.1"
    local size = config.Size or UDim2.new(0, 350, 0, 350)
    local position = config.Position or UDim2.new(0.5, -175, 0.5, -175)
    local backgroundColor = config.BackgroundColor or Color3.fromRGB(20, 20, 20)
    local borderColor = config.BorderColor or Color3.fromRGB(0, 255, 0)

    local window = setmetatable({}, Window)

    local frame = Instance.new("Frame")
    frame.Name = title
    frame.Size = size
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
    stroke.Parent = frame

    window.Frame = frame
    return window
end

function Window:UpdateConfig(config)
    if config.Size then
        self.Frame.Size = config.Size
    end
    if config.Position then
        self.Frame.Position = config.Position
    end
    if config.BackgroundColor then
        self.Frame.BackgroundColor3 = config.BackgroundColor
    end
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
