local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera


local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "CamLockUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0.4, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, 0, 0.5, 0)
toggleBtn.Position = UDim2.new(0, 0, 0, 0)
toggleBtn.Text = "Cam Lock: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18

local hotkeyBtn = Instance.new("TextButton", frame)
hotkeyBtn.Size = UDim2.new(1, 0, 0.5, 0)
hotkeyBtn.Position = UDim2.new(0, 0, 0.5, 0)
hotkeyBtn.Text = "Set Hotkey"
hotkeyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
hotkeyBtn.TextColor3 = Color3.new(1,1,1)
hotkeyBtn.Font = Enum.Font.Gotham
hotkeyBtn.TextSize = 16


local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)


local camLock = false
local hotkey = Enum.KeyCode.L -- Mặc định
local listening = false

local function getClosestEnemy()
	local closest, dist = nil, math.huge
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local d = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			if d < dist then
				dist = d
				closest = plr
			end
		end
	end
	return closest
end

toggleBtn.MouseButton1Click:Connect(function()
	camLock = not camLock
	toggleBtn.Text = camLock and "Cam Lock: ON" or "Cam Lock: OFF"
end)

hotkeyBtn.MouseButton1Click:Connect(function()
	hotkeyBtn.Text = "Press any key..."
	listening = true
end)

UIS.InputBegan:Connect(function(input, gp)
	if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
		hotkey = input.KeyCode
		hotkeyBtn.Text = "Hotkey: "..tostring(hotkey):gsub("Enum.KeyCode.", "")
		listening = false
	elseif not gp and input.KeyCode == hotkey then
		camLock = not camLock
		toggleBtn.Text = camLock and "Cam Lock: ON" or "Cam Lock: OFF"
	elseif input.KeyCode == Enum.KeyCode.H then
		frame.Visible = not frame.Visible
	end
end)

RunService.RenderStepped:Connect(function()
	if camLock then
		local target = getClosestEnemy()
		local myChar = LocalPlayer.Character
		if target and target.Character and myChar and myChar:FindFirstChild("HumanoidRootPart") then
			local hrp = myChar.HumanoidRootPart
			local thrp = target.Character.HumanoidRootPart
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, thrp.Position)
			local dir = (thrp.Position - hrp.Position).Unit
			local yaw = math.atan2(-dir.X, -dir.Z)
			hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yaw, 0)
		end
	end
end)
