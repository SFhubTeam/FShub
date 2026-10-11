-- =======================================================
-- 🕋 FShub — Minimalist Edition (Black & White)
-- =======================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- База интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FShub_Minimal"
ScreenGui.ResetOnSpawn = false
local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- =======================================================
-- 🕋 1. ЧЕРНО-БЕЛЫЙ ИНТРО-ЛОГОТИП
-- =======================================================
local IntroLabel = Instance.new("TextLabel")
IntroLabel.Size = UDim2.new(0, 300, 0, 100)
IntroLabel.Position = UDim2.new(0.5, -150, 0.5, -50)
IntroLabel.BackgroundTransparency = 1
IntroLabel.Text = "FShub"
IntroLabel.Font = Enum.Font.Code
IntroLabel.TextSize = 1
IntroLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroLabel.TextTransparency = 1
IntroLabel.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Transparency = 1
UIStroke.Parent = IntroLabel

TweenService:Create(IntroLabel, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextSize = 60, TextTransparency = 0}):Play()
TweenService:Create(UIStroke, TweenInfo.new(0.8), {Transparency = 0.5}):Play()
task.wait(1.5)
TweenService:Create(IntroLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextSize = 75, TextTransparency = 1}):Play()
TweenService:Create(UIStroke, TweenInfo.new(0.6), {Transparency = 1}):Play()
task.wait(0.6)
IntroLabel:Destroy()

-- =======================================================
-- 📱 2. МИНИМАЛИСТИЧНОЕ МЕНЮ
-- =======================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 230)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -115)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Глубокий черный
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1
MainStroke.Color = Color3.fromRGB(60, 60, 60)
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "FShub // main"
Title.Font = Enum.Font.Code
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

-- Функция для создания строгих ч/б кнопок
local function CreateButton(text, yPos)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 200, 0, 40)
    Btn.Position = UDim2.new(0.5, -100, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = text .. " [OFF]"
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 13
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.BorderSizePixel = 0
    Btn.Parent = MainFrame

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Thickness = 1
    BtnStroke.Color = Color3.fromRGB(50, 50, 50)
    BtnStroke.Parent = Btn

    return Btn
end

local AuraBtn = CreateButton("KILL AURA", 50)
local FlyBtn = CreateButton("FLY MODE", 105)
local JumpBtn = CreateButton("INF JUMP", 160)

-- =======================================================
-- 👁️ 3. КНОПКА СКРЫТИЯ/ОТКРЫТИЯ МЕНЮ (МАСКИРОВКА)
-- =======================================================
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 80, 0, 30)
ToggleMenuBtn.Position = UDim2.new(1, -95, 0, 15) -- В правом верхнем углу экрана
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleMenuBtn.Text = "[FShub]"
ToggleMenuBtn.Font = Enum.Font.Code
ToggleMenuBtn.TextSize = 12
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.BorderSizePixel = 0
ToggleMenuBtn.Parent = ScreenGui

local MenuBtnStroke = Instance.new("UIStroke")
MenuBtnStroke.Thickness = 1
MenuBtnStroke.Color = Color3.fromRGB(70, 70, 70)
MenuBtnStroke.Parent = ToggleMenuBtn

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- =======================================================
-- ⚔️ ЛОГИКА СУЩНОСТЕЙ СЕРВЕРА
-- =======================================================
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(newchar)
    Character = newchar
    HumanoidRootPart = newchar:WaitForChild("HumanoidRootPart")
    Humanoid = newchar:WaitForChild("Humanoid")
end)

-- 1. КИЛЛАУРА (3 уд/сек, радиус 60)
local AuraOn = false
local DamageEvent = ReplicatedStorage.Modules.Shared.Event.Remotes.DamageEntity
local MobFolder = Workspace.Mobs
local Range = 60

AuraBtn.MouseButton1Click:Connect(function()
    AuraOn = not AuraOn
    AuraBtn.Text = AuraOn and "KILL AURA [ON]" or "KILL AURA [OFF]"
    AuraBtn.TextColor3 = AuraOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    AuraBtn.BackgroundColor3 = AuraOn and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
end)

task.spawn(function()
    while task.wait(0.33) do -- 3 удара в секунду
        if AuraOn and Humanoid and Humanoid.Health > 0 and HumanoidRootPart then
            for _, obj in ipairs(MobFolder:GetChildren()) do 
                if obj:IsA("Model") then
                    local MobRoot = obj:FindFirstChild("HumanoidRootPart")
                    local MobHum = obj:FindFirstChildOfClass("Humanoid")
                    if MobHum and MobHum.Health > 0 and MobRoot then 
                        if (HumanoidRootPart.Position - MobRoot.Position).Magnitude <= Range then 
                            DamageEvent:FireServer(obj, nil, "Melee")
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- 2. ГРАМОТНЫЙ ФЛАЙ (ДЛЯ ТЕЛЕФОНОВ)
local FlyOn = false
local FlySpeed = 50
local BodyVelocity, BodyGyro

FlyBtn.MouseButton1Click:Connect(function()
    FlyOn = not FlyOn
    FlyBtn.Text = FlyOn and "FLY MODE [ON]" or "FLY MODE [OFF]"
    FlyBtn.TextColor3 = FlyOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    FlyBtn.BackgroundColor3 = FlyOn and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)

    if FlyOn then
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = HumanoidRootPart.CFrame
        BodyGyro.Parent = HumanoidRootPart

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Parent = HumanoidRootPart
        
        task.spawn(function()
            while FlyOn and HumanoidRootPart do
                RunService.RenderStepped:Wait()
                BodyGyro.cframe = Workspace.CurrentCamera.CFrame
                local moveDir = Humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    BodyVelocity.velocity = Workspace.CurrentCamera.CFrame.LookVector * FlySpeed
                else
                    BodyVelocity.velocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
    end
end)

-- 3. ИНФИНИТ ДЖАМП
local InfJumpOn = false
JumpBtn.MouseButton1Click:Connect(function()
    InfJumpOn = not InfJumpOn
    JumpBtn.Text = InfJumpOn and "INF JUMP [ON]" or "INF JUMP [OFF]"
    JumpBtn.TextColor3 = InfJumpOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    JumpBtn.BackgroundColor3 = InfJumpOn and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpOn and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
