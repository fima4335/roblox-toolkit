--[[
    Notify.lua
    Красивые уведомления для игроков
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Notify = {}

-- Создаём RemoteEvent если его ещё нет
local remote = ReplicatedStorage:FindFirstChild("NotifyRemote")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "NotifyRemote"
    remote.Parent = ReplicatedStorage
end

local COLORS = {
    Success = Color3.fromRGB(46, 204, 113),
    Error   = Color3.fromRGB(231, 76, 60),
    Info    = Color3.fromRGB(52, 152, 219),
    Warning = Color3.fromRGB(241, 196, 15),
}

local function createNotification(player, message, notifType)
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = playerGui:FindFirstChild("NotifyGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "NotifyGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 60)
    frame.Position = UDim2.new(0.5, -160, 0, -80)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 6, 1, 0)
    accent.BackgroundColor3 = COLORS[notifType] or COLORS.Info
    accent.BorderSizePixel = 0
    accent.Parent = frame

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 10)
    accentCorner.Parent = accent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextSize = 16
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = frame

    -- Анимация появления
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -160, 0, 20)
    })
    tweenIn:Play()

    task.delay(3.5, function()
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -160, 0, -80),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        frame:Destroy()
    end)
end

-- Серверная часть
function Notify.Success(player, message)
    remote:FireClient(player, message, "Success")
end

function Notify.Error(player, message)
    remote:FireClient(player, message, "Error")
end

function Notify.Info(player, message)
    remote:FireClient(player, message, "Info")
end

function Notify.Warning(player, message)
    remote:FireClient(player, message, "Warning")
end

-- Клиентская часть (нужно запустить на клиенте)
if not game:GetService("RunService"):IsServer() then
    remote.OnClientEvent:Connect(function(message, notifType)
        createNotification(Players.LocalPlayer, message, notifType)
    end)
end

return Notify
