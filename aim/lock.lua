--// Cam Lock by Mouse Target | Made By King


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")


getgenv().CamLock = false
getgenv().CamLockKey = Enum.KeyCode.L
local Target = nil
local GUIVisible = true
local Camera = workspace.CurrentCamera


local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "CamLockUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Position = UDim2.new(0, 30, 0, 120)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🎯 Cam Lock"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Font = Enum.Font.Gotham
Title.TextSize = 16

local HotkeyBtn = Instance.new("TextButton", Frame)
HotkeyBtn.Position = UDim2.new(0, 10, 0, 40)
HotkeyBtn.Size = UDim2.new(0, 200, 0, 30)
HotkeyBtn.Text = "🎮 Set Hotkey (Current: L)"
HotkeyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
HotkeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HotkeyBtn.Font = Enum.Font.Gotham
HotkeyBtn.TextSize = 14

local HideBtn = Instance.new("TextButton", Frame)
HideBtn.Position = UDim2.new(0, 10, 0, 80)
HideBtn.Size = UDim2.new(0, 200, 0, 30)
HideBtn.Text = "🙈 Hide GUI (Press H)"
HideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HideBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
HideBtn.Font = Enum.Font.Gotham
HideBtn.TextSize = 12


HotkeyBtn.MouseButton1Click:Connect(function()
	HotkeyBtn.Text = "⏳ Press any key..."
	local conn
	conn = UIS.InputBegan:Connect(function(input, gpe)
		if not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
			getgenv().CamLockKey = input.KeyCode
			HotkeyBtn.Text = "🎮 Set Hotkey (Current: " .. input.KeyCode.Name .. ")"
			conn:Disconnect()
		end
	end)
end)


HideBtn.MouseButton1Click:Connect(function()
	GUIVisible = false
	ScreenGui.Enabled = false
end)


UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.H then
		GUIVisible = not GUIVisible
		ScreenGui.Enabled = GUIVisible
	end
end)


UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == getgenv().CamLockKey then
		if getgenv().CamLock then
			-- Turn off cam lock
			getgenv().CamLock = false
			Target = nil
			Title.Text = "🎯 Cam Lock"
		else
			-- Try to lock on player under mouse
			local mouseTarget = Mouse.Target
			if mouseTarget then
				local model = mouseTarget:FindFirstAncestorOfClass("Model")
				if model and Players:GetPlayerFromCharacter(model) and model:FindFirstChild("HumanoidRootPart") then
					Target = Players:GetPlayerFromCharacter(model)
					getgenv().CamLock = true
					Title.Text = "🔒 Locked: " .. Target.Name
				end
			end
		end
	end
end)


RunService.RenderStepped:Connect(function()
	if getgenv().CamLock and Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local myHRP = LocalPlayer.Character.HumanoidRootPart
		local targetHRP = Target.Character.HumanoidRootPart
		Camera.CFrame = CFrame.new(myHRP.Position, targetHRP.Position)
	end
end)
