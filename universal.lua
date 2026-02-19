local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) character = c end)

local function getHum() return character and character:FindFirstChildOfClass("Humanoid") end
local function getRoot() return character and character:FindFirstChild("HumanoidRootPart") end

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local intro = Instance.new("TextLabel")
intro.Size = UDim2.fromScale(1, 1)
intro.BackgroundTransparency = 1
intro.Text = "Azura Admin"
intro.Font = Enum.Font.GothamBlack
intro.TextSize = 64
intro.TextColor3 = Color3.fromRGB(255, 255, 255)
intro.Parent = gui

local notifHolder = Instance.new("Frame")
notifHolder.Size = UDim2.fromScale(1, 1)
notifHolder.BackgroundTransparency = 1
notifHolder.Parent = gui
local notifLayout = Instance.new("UIListLayout")
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.Padding = UDim.new(0, 5)
notifLayout.Parent = notifHolder
Instance.new("UIPadding", notifHolder).PaddingTop = UDim.new(0, 14)

local function notify(msg)
	local f = Instance.new("Frame")
	f.Size = UDim2.fromScale(0.22, 0.042)
	f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	f.BackgroundTransparency = 1
	f.Parent = notifHolder
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 9)
	local st = Instance.new("UIStroke")
	st.Thickness = 2
	st.Transparency = 1
	st.Color = Color3.fromRGB(32, 32, 32)
	st.Parent = f
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Text = msg
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextColor3 = Color3.fromRGB(215, 215, 215)
	lbl.TextTransparency = 1
	lbl.Parent = f
	TweenService:Create(f, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
	TweenService:Create(st, TweenInfo.new(0.2), {Transparency = 0}):Play()
	TweenService:Create(lbl, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
	task.delay(2.2, function()
		TweenService:Create(f, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		TweenService:Create(st, TweenInfo.new(0.2), {Transparency = 1}):Play()
		TweenService:Create(lbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
		task.delay(0.25, function() f:Destroy() end)
	end)
end

local cmdBar = Instance.new("Frame")
cmdBar.Size = UDim2.fromScale(0.52, 0.068)
cmdBar.Position = UDim2.fromScale(0.5, 0.94)
cmdBar.AnchorPoint = Vector2.new(0.5, 0.5)
cmdBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
cmdBar.Visible = false
cmdBar.Parent = gui
Instance.new("UICorner", cmdBar).CornerRadius = UDim.new(0, 14)
local cmdStroke = Instance.new("UIStroke")
cmdStroke.Color = Color3.fromRGB(36, 36, 36)
cmdStroke.Thickness = 2
cmdStroke.Parent = cmdBar

local cmdBox = Instance.new("TextBox")
cmdBox.Size = UDim2.fromScale(0.95, 0.65)
cmdBox.Position = UDim2.fromScale(0.02, 0.5)
cmdBox.AnchorPoint = Vector2.new(0, 0.5)
cmdBox.BackgroundTransparency = 1
cmdBox.PlaceholderText = "Command  ;  or  /"
cmdBox.Text = ""
cmdBox.Font = Enum.Font.GothamBold
cmdBox.TextSize = 14
cmdBox.TextColor3 = Color3.fromRGB(245, 245, 245)
cmdBox.TextTransparency = 1
cmdBox.TextXAlignment = Enum.TextXAlignment.Left
cmdBox.ClearTextOnFocus = false
cmdBox.Parent = cmdBar
Instance.new("UIPadding", cmdBox).PaddingLeft = UDim.new(0, 12)

local menu = Instance.new("Frame")
menu.Size = UDim2.fromScale(0.50, 0.60)
menu.Position = UDim2.fromScale(0.5, 0.47)
menu.AnchorPoint = Vector2.new(0.5, 0.5)
menu.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
menu.Visible = false
menu.Parent = gui
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 16)
local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(34, 34, 34)
menuStroke.Thickness = 2
menuStroke.Parent = menu

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromScale(0.26, 1)
sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
sidebar.BorderSizePixel = 0
sidebar.Parent = menu
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 16)

local sideSquare = Instance.new("Frame")
sideSquare.Size = UDim2.fromScale(0.35, 1)
sideSquare.Position = UDim2.fromScale(0.65, 0)
sideSquare.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
sideSquare.BorderSizePixel = 0
sideSquare.Parent = sidebar

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 1, 1, 0)
divider.Position = UDim2.fromScale(0.26, 0)
divider.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
divider.BorderSizePixel = 0
divider.Parent = menu

local pfpImg = Instance.new("ImageLabel")
pfpImg.Size = UDim2.new(0, 46, 0, 46)
pfpImg.Position = UDim2.new(0.5, -23, 0, 10)
pfpImg.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
pfpImg.Image = ""
pfpImg.Parent = sidebar
Instance.new("UICorner", pfpImg).CornerRadius = UDim.new(0.5, 0)
local pfpStroke = Instance.new("UIStroke")
pfpStroke.Thickness = 2
pfpStroke.Color = Color3.fromRGB(44, 44, 44)
pfpStroke.Parent = pfpImg

task.spawn(function()
	local ok, img = pcall(function()
		return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	end)
	if ok and img then pfpImg.Image = img end
end)

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 16)
nameLabel.Position = UDim2.new(0, 0, 0, 60)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = player.DisplayName
nameLabel.Font = Enum.Font.GothamBlack
nameLabel.TextSize = 10
nameLabel.TextColor3 = Color3.fromRGB(205, 205, 205)
nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
nameLabel.Parent = sidebar

local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, 0, 1, -90)
tabHolder.Position = UDim2.new(0, 0, 0, 84)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = sidebar
local tabLayout = Instance.new("UIListLayout")
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
tabLayout.Padding = UDim.new(0, 3)
tabLayout.Parent = tabHolder
Instance.new("UIPadding", tabHolder).PaddingTop = UDim.new(0, 4)

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.fromScale(0.72, 0.94)
contentArea.Position = UDim2.fromScale(0.275, 0.03)
contentArea.BackgroundTransparency = 1
contentArea.Parent = menu

local TABS = {
	{name = "Home",     icon = "⌂"},
	{name = "Player",   icon = "◈"},
	{name = "Server",   icon = "◉"},
	{name = "Settings", icon = "◎"},
}

local tabBtns = {}
local pages = {}

local function switchTab(name)
	for _, t in ipairs(TABS) do
		local btn = tabBtns[t.name]
		local page = pages[t.name]
		local active = t.name == name
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = active and Color3.fromRGB(22, 22, 22) or Color3.fromRGB(0, 0, 0)
		}):Play()
		local lbl = btn:FindFirstChildOfClass("TextLabel")
		lbl.Font = active and Enum.Font.GothamBlack or Enum.Font.GothamBold
		lbl.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(110, 110, 110)
		if page then page.Visible = active end
	end
end

local function makePage(tabName)
	local page = Instance.new("Frame")
	page.Size = UDim2.fromScale(1, 1)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Name = tabName
	page.Parent = contentArea
	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromScale(1, 0.09)
	title.BackgroundTransparency = 1
	title.Text = tabName
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 16
	title.TextColor3 = Color3.fromRGB(228, 228, 228)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = page
	local tp = Instance.new("UIPadding", title)
	tp.PaddingLeft = UDim.new(0, 4)
	tp.PaddingTop = UDim.new(0, 4)
	return page
end

for _, t in ipairs(TABS) do
	local btn = Instance.new("TextButton")
	btn.Name = t.name
	btn.Size = UDim2.fromScale(0.88, 0)
	btn.AutomaticSize = Enum.AutomaticSize.Y
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.Text = ""
	btn.Parent = tabHolder
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	local pad = Instance.new("UIPadding", btn)
	pad.PaddingTop = UDim.new(0, 6)
	pad.PaddingBottom = UDim.new(0, 6)
	pad.PaddingLeft = UDim.new(0, 7)
	local iconLbl = Instance.new("TextLabel")
	iconLbl.Size = UDim2.fromScale(0.22, 1)
	iconLbl.BackgroundTransparency = 1
	iconLbl.Text = t.icon
	iconLbl.Font = Enum.Font.GothamBlack
	iconLbl.TextSize = 12
	iconLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	iconLbl.TextXAlignment = Enum.TextXAlignment.Center
	iconLbl.Parent = btn
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.fromScale(0.78, 1)
	lbl.Position = UDim2.fromScale(0.22, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = t.name
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 11
	lbl.TextColor3 = Color3.fromRGB(110, 110, 110)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = btn
	tabBtns[t.name] = btn
	pages[t.name] = makePage(t.name)
	btn.MouseButton1Click:Connect(function() switchTab(t.name) end)
end

local function makeLabel(parent, text, y, h)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.fromScale(0.96, h or 0.048)
	l.Position = UDim2.fromScale(0.02, y)
	l.BackgroundTransparency = 1
	l.Text = text
	l.Font = Enum.Font.GothamBold
	l.TextSize = 11
	l.TextColor3 = Color3.fromRGB(165, 165, 165)
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = parent
	return l
end

local function makeToggle(parent, label, y, cb)
	local row = Instance.new("Frame")
	row.Size = UDim2.fromScale(0.96, 0.070)
	row.Position = UDim2.fromScale(0.02, y)
	row.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	row.BorderSizePixel = 0
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.fromScale(0.74, 1)
	lbl.BackgroundTransparency = 1
	lbl.Text = label
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 11
	lbl.TextColor3 = Color3.fromRGB(195, 195, 195)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row
	Instance.new("UIPadding", lbl).PaddingLeft = UDim.new(0, 9)
	local track = Instance.new("Frame")
	track.Size = UDim2.fromScale(0.09, 0.42)
	track.Position = UDim2.fromScale(0.87, 0.29)
	track.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
	track.Parent = row
	Instance.new("UICorner", track).CornerRadius = UDim.new(0.5, 0)
	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromScale(0.46, 1)
	knob.Position = UDim2.fromScale(0.04, 0)
	knob.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(0.5, 0)
	local on = false
	local hit = Instance.new("TextButton")
	hit.Size = UDim2.fromScale(1, 1)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.Parent = row
	hit.MouseButton1Click:Connect(function()
		on = not on
		TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = on and Color3.fromRGB(0, 140, 60) or Color3.fromRGB(34, 34, 34)}):Play()
		TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.fromScale(on and 0.50 or 0.04, 0), BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90)}):Play()
		cb(on)
	end)
end

local function makeSlider(parent, label, y, minV, maxV, defV, cb)
	local row = Instance.new("Frame")
	row.Size = UDim2.fromScale(0.96, 0.10)
	row.Position = UDim2.fromScale(0.02, y)
	row.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	row.BorderSizePixel = 0
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size = UDim2.fromScale(0.58, 0.44)
	nameLbl.Position = UDim2.fromScale(0.03, 0.06)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = label
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.TextSize = 10
	nameLbl.TextColor3 = Color3.fromRGB(185, 185, 185)
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.Parent = row
	local valLbl = Instance.new("TextLabel")
	valLbl.Size = UDim2.fromScale(0.20, 0.44)
	valLbl.Position = UDim2.fromScale(0.77, 0.06)
	valLbl.BackgroundTransparency = 1
	valLbl.Text = tostring(defV)
	valLbl.Font = Enum.Font.GothamBlack
	valLbl.TextSize = 10
	valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	valLbl.TextXAlignment = Enum.TextXAlignment.Right
	valLbl.Parent = row
	local track = Instance.new("Frame")
	track.Size = UDim2.fromScale(0.91, 0.13)
	track.Position = UDim2.fromScale(0.04, 0.74)
	track.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	track.Parent = row
	Instance.new("UICorner", track).CornerRadius = UDim.new(0.5, 0)
	local prog = Instance.new("Frame")
	prog.Size = UDim2.fromScale((defV - minV) / (maxV - minV), 1)
	prog.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	prog.BorderSizePixel = 0
	prog.Parent = track
	Instance.new("UICorner", prog).CornerRadius = UDim.new(0.5, 0)
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 10, 0, 10)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.fromScale((defV - minV) / (maxV - minV), 0.5)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(0.5, 0)
	local dragging = false
	local hit = Instance.new("TextButton")
	hit.Size = UDim2.fromScale(1, 5)
	hit.Position = UDim2.fromScale(0, -2)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.ZIndex = 5
	hit.Parent = track
	hit.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	hit.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if not dragging then return end
		if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
		local ap = track.AbsolutePosition
		local as = track.AbsoluteSize
		local rel = math.clamp((i.Position.X - ap.X) / as.X, 0, 1)
		local val = math.floor(minV + rel * (maxV - minV))
		valLbl.Text = tostring(val)
		prog.Size = UDim2.fromScale(rel, 1)
		knob.Position = UDim2.fromScale(rel, 0.5)
		cb(val)
	end)
end

local flyOn = false
local noclipOn = false
local infJumpOn = false
local floatPart = nil
local swimOn = false
local espOn = false
local espTeamOn = false
local chamsOn = false
local freecamOn = false
local antivoidOn = false
local antiIdleOn = false
local autoRejoinOn = false
local loopSpeedOn = false
local loopSpeedVal = 16
local loopJpOn = false
local loopJpVal = 50
local autoJumpOn = false
local lastDeathPos = nil
local xrayData = {}
local espConns = {}
local espFolder = nil
local chamParts = {}
local flyConn = nil
local noclipConn = nil
local freecamConn = nil
local antivoidConn = nil
local loopSpeedConn = nil
local loopJpConn = nil
local autoJumpConn = nil
local swimConn = nil

player.CharacterAdded:Connect(function(c)
	character = c
	local hum = c:WaitForChild("Humanoid")
	hum.Died:Connect(function()
		local root = c:FindFirstChild("HumanoidRootPart")
		if root then lastDeathPos = root.Position end
	end)
end)

local function startFly(speed)
	local spd = speed or 60
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = true end
	local bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.zero
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Name = "AzFlyBV"
	bv.Parent = root
	local bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bg.P = 1e4
	bg.Name = "AzFlyBG"
	bg.Parent = root
	if flyConn then flyConn:Disconnect() end
	flyConn = RunService.Heartbeat:Connect(function()
		if not flyOn then
			bv:Destroy()
			bg:Destroy()
			if hum then hum.PlatformStand = false end
			flyConn:Disconnect()
			return
		end
		local cf = workspace.CurrentCamera.CFrame
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
		bv.Velocity = dir.Magnitude > 0 and dir.Unit * spd or Vector3.zero
		bg.CFrame = cf
	end)
end

local function startNoclip()
	if noclipConn then noclipConn:Disconnect() end
	noclipConn = RunService.Stepped:Connect(function()
		if not noclipOn then noclipConn:Disconnect(); return end
		local char = player.Character
		if char then
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
			end
		end
	end)
end

local function startSwim()
	if swimConn then swimConn:Disconnect() end
	swimConn = RunService.Heartbeat:Connect(function()
		if not swimOn then swimConn:Disconnect(); return end
		local hum = getHum()
		if hum then hum:ChangeState(Enum.HumanoidStateType.Swimming) end
	end)
end

local function clearEsp()
	espOn = false
	espTeamOn = false
	for _, c in ipairs(espConns) do pcall(function() c:Disconnect() end) end
	espConns = {}
	if espFolder then espFolder:Destroy(); espFolder = nil end
end

local function setupEsp(teamMode)
	clearEsp()
	espOn = not teamMode
	espTeamOn = teamMode
	espFolder = Instance.new("Folder")
	espFolder.Name = "AzESP"
	espFolder.Parent = gui
	local function addFor(p)
		if p == player then return end
		task.spawn(function()
			local char = p.Character or p.CharacterAdded:Wait()
			local root = char:WaitForChild("HumanoidRootPart", 5)
			if not root then return end
			local bb = Instance.new("BillboardGui")
			bb.Size = UDim2.new(0, 80, 0, 28)
			bb.StudsOffset = Vector3.new(0, 3, 0)
			bb.AlwaysOnTop = true
			bb.Adornee = root
			bb.Parent = espFolder
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.fromScale(1, 1)
			lbl.BackgroundTransparency = 1
			lbl.Font = Enum.Font.GothamBold
			lbl.TextSize = 11
			lbl.TextStrokeTransparency = 0
			lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			lbl.Parent = bb
			local conn = RunService.Heartbeat:Connect(function()
				if not (espOn or espTeamOn) or not p.Character then
					bb:Destroy()
					conn:Disconnect()
					return
				end
				local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
				lbl.Text = p.Name .. "\n" .. (hum and math.floor(hum.Health) or "?") .. " HP"
				if teamMode then
					lbl.TextColor3 = p.Team == player.Team and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 70, 70)
				else
					lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			end)
			table.insert(espConns, conn)
		end)
	end
	for _, p in ipairs(Players:GetPlayers()) do addFor(p) end
	local addConn = Players.PlayerAdded:Connect(function(p) addFor(p) end)
	table.insert(espConns, addConn)
end

local function startChams()
	clearChams = function()
		for _, s in ipairs(chamParts) do pcall(function() s:Destroy() end) end
		chamParts = {}
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			for _, part in ipairs(p.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					local sb = Instance.new("SelectionBox")
					sb.Adornee = part
					sb.Color3 = Color3.fromRGB(255, 255, 255)
					sb.LineThickness = 0.03
					sb.SurfaceTransparency = 0.75
					sb.SurfaceColor3 = Color3.fromRGB(255, 255, 255)
					sb.Parent = gui
					table.insert(chamParts, sb)
				end
			end
		end
	end
end

clearChams = function()
	for _, s in ipairs(chamParts) do pcall(function() s:Destroy() end) end
	chamParts = {}
end

local function startXray()
	xrayData = {}
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			local char = player.Character
			if not (char and obj:IsDescendantOf(char)) then
				table.insert(xrayData, {obj, obj.Transparency})
				obj.Transparency = 0.82
			end
		end
	end
end

local function clearXray()
	for _, d in ipairs(xrayData) do
		pcall(function() d[1].Transparency = d[2] end)
	end
	xrayData = {}
end

local freecamCF = CFrame.new()
local function startFreecam()
	local cam = workspace.CurrentCamera
	cam.CameraType = Enum.CameraType.Scriptable
	freecamCF = cam.CFrame
	if freecamConn then freecamConn:Disconnect() end
	freecamConn = RunService.Heartbeat:Connect(function(dt)
		if not freecamOn then
			cam.CameraType = Enum.CameraType.Custom
			freecamConn:Disconnect()
			return
		end
		local dir = Vector3.zero
		local spd = 28
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + freecamCF.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - freecamCF.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - freecamCF.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + freecamCF.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
		if dir.Magnitude > 0 then
			freecamCF = CFrame.new(freecamCF.Position + dir.Unit * spd * dt) * (freecamCF - freecamCF.Position)
		end
		local delta = UIS:GetMouseDelta()
		freecamCF = freecamCF * CFrame.Angles(0, math.rad(-delta.X * 0.28), 0)
		freecamCF = freecamCF * CFrame.Angles(math.rad(-delta.Y * 0.28), 0, 0)
		cam.CFrame = freecamCF
	end)
end

local function startAntivoid()
	if antivoidConn then antivoidConn:Disconnect() end
	antivoidConn = RunService.Heartbeat:Connect(function()
		if not antivoidOn then antivoidConn:Disconnect(); return end
		local root = getRoot()
		if root and root.Position.Y < -450 then
			root.CFrame = CFrame.new(root.Position.X, 60, root.Position.Z)
		end
	end)
end

local function startLoopSpeed()
	if loopSpeedConn then loopSpeedConn:Disconnect() end
	loopSpeedConn = RunService.Heartbeat:Connect(function()
		if not loopSpeedOn then loopSpeedConn:Disconnect(); return end
		local h = getHum()
		if h then h.WalkSpeed = loopSpeedVal end
	end)
end

local function startLoopJp()
	if loopJpConn then loopJpConn:Disconnect() end
	loopJpConn = RunService.Heartbeat:Connect(function()
		if not loopJpOn then loopJpConn:Disconnect(); return end
		local h = getHum()
		if h then h.JumpPower = loopJpVal end
	end)
end

local function startAutoJump()
	if autoJumpConn then autoJumpConn:Disconnect() end
	autoJumpConn = RunService.Heartbeat:Connect(function()
		if not autoJumpOn then autoJumpConn:Disconnect(); return end
		local hum = getHum()
		local root = getRoot()
		if hum and root then
			local params = RaycastParams.new()
			params.FilterDescendantsInstances = {player.Character}
			params.FilterType = Enum.RaycastFilterType.Exclude
			local hit = workspace:Raycast(root.Position, root.CFrame.LookVector * 4, params)
			if hit then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end)
end

local function giveTpTool()
	local tool = Instance.new("Tool")
	tool.Name = "Teleport"
	tool.RequiresHandle = false
	tool.Parent = player.Backpack
	local mouse = player:GetMouse()
	tool.Activated:Connect(function()
		local root = getRoot()
		if root and mouse.Hit then
			root.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
		end
	end)
end

local function spawnFloat()
	local root = getRoot()
	if not root then return end
	if floatPart then floatPart:Destroy() end
	local p = Instance.new("Part")
	p.Size = Vector3.new(8, 0.4, 8)
	p.Anchored = true
	p.BrickColor = BrickColor.new("Dark grey")
	p.Name = "AzFloat"
	p.CFrame = root.CFrame * CFrame.new(0, -3, 0)
	p.Parent = workspace
	floatPart = p
end

local function getPlayers(sel)
	local result = {}
	local s = sel:lower():gsub("^%s*", "")
	if s == "all" then
		for _, p in ipairs(Players:GetPlayers()) do result[#result+1] = p end
	elseif s == "others" then
		for _, p in ipairs(Players:GetPlayers()) do if p ~= player then result[#result+1] = p end end
	elseif s == "me" then
		result[1] = player
	elseif s == "random" then
		local pool = Players:GetPlayers()
		if #pool > 0 then result[1] = pool[math.random(1, #pool)] end
	elseif s == "nearest" then
		local root = getRoot()
		if root then
			local closest, dist = nil, math.huge
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					local r = p.Character:FindFirstChild("HumanoidRootPart")
					if r then
						local d = (r.Position - root.Position).Magnitude
						if d < dist then dist = d; closest = p end
					end
				end
			end
			if closest then result[1] = closest end
		end
	elseif s == "farthest" then
		local root = getRoot()
		if root then
			local farthest, dist = nil, 0
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					local r = p.Character:FindFirstChild("HumanoidRootPart")
					if r then
						local d = (r.Position - root.Position).Magnitude
						if d > dist then dist = d; farthest = p end
					end
				end
			end
			if farthest then result[1] = farthest end
		end
	elseif s == "friends" then
		for _, p in ipairs(Players:GetPlayers()) do
			local ok, v = pcall(function() return player:IsFriendsWith(p.UserId) end)
			if ok and v then result[#result+1] = p end
		end
	elseif s == "nonfriends" then
		for _, p in ipairs(Players:GetPlayers()) do
			local ok, v = pcall(function() return player:IsFriendsWith(p.UserId) end)
			if ok and not v then result[#result+1] = p end
		end
	elseif s == "allies" or s == "team" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Team and p.Team == player.Team then result[#result+1] = p end
		end
	elseif s == "enemies" or s == "nonteam" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Team ~= player.Team then result[#result+1] = p end
		end
	elseif s == "alive" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local h = p.Character:FindFirstChildOfClass("Humanoid")
				if h and h.Health > 0 then result[#result+1] = p end
			end
		end
	elseif s == "dead" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local h = p.Character:FindFirstChildOfClass("Humanoid")
				if h and h.Health <= 0 then result[#result+1] = p end
			end
		end
	elseif s == "bacons" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				for _, a in ipairs(p.Character:GetDescendants()) do
					if a:IsA("Accessory") and (a.Name:lower():find("bacon") or a.Name:lower():find("pal hair")) then
						result[#result+1] = p; break
					end
				end
			end
		end
	elseif s == "guests" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Name:lower():sub(1, 5) == "guest" then result[#result+1] = p end
		end
	elseif s:sub(1, 1) == "@" then
		local name = s:sub(2)
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Name:lower():find(name, 1, true) then result[#result+1] = p end
		end
	elseif s:sub(1, 1) == "#" then
		local n = tonumber(s:sub(2))
		if n then
			local pool = {}
			for _, p in ipairs(Players:GetPlayers()) do pool[#pool+1] = p end
			for i = 1, math.min(n, #pool) do
				local idx = math.random(1, #pool)
				result[#result+1] = table.remove(pool, idx)
			end
		end
	elseif s:sub(1, 1) == "%" then
		local tn = s:sub(2)
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Team and p.Team.Name:lower():find(tn, 1, true) then result[#result+1] = p end
		end
	elseif s:sub(1, 3) == "age" then
		local n = tonumber(s:sub(4))
		if n then
			for _, p in ipairs(Players:GetPlayers()) do
				if p.AccountAge <= n then result[#result+1] = p end
			end
		end
	elseif s:sub(1, 3) == "rad" then
		local n = tonumber(s:sub(4))
		local root = getRoot()
		if n and root then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					local r = p.Character:FindFirstChild("HumanoidRootPart")
					if r and (r.Position - root.Position).Magnitude <= n then result[#result+1] = p end
				end
			end
		end
	elseif s:sub(1, 5) == "group" then
		local gid = tonumber(s:sub(6))
		if gid then
			for _, p in ipairs(Players:GetPlayers()) do
				local ok, v = pcall(function() return p:IsInGroup(gid) end)
				if ok and v then result[#result+1] = p end
			end
		end
	else
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Name:lower():find(s, 1, true) or p.DisplayName:lower():find(s, 1, true) then
				result[#result+1] = p
			end
		end
	end
	return result
end

UIS.JumpRequest:Connect(function()
	if infJumpOn then
		local hum = getHum()
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

RunService.Heartbeat:Connect(function()
	if antiIdleOn then
		pcall(function()
			local VU = game:GetService("VirtualUser")
			VU:CaptureController()
			VU:ClickButton2(Vector2.new())
		end)
	end
end)

player.OnTeleport:Connect(function(state)
	if state == Enum.TeleportState.Failed and autoRejoinOn then
		task.wait(3)
		TeleportService:Teleport(game.PlaceId, player)
	end
end)

do
	local page = pages["Home"]
	makeLabel(page, "Welcome to Azura Admin", 0.10, 0.055)
	makeLabel(page, "Use  ;  or  /  prefix in the command bar.", 0.16, 0.048)
	makeLabel(page, "Press  K  to toggle.", 0.21, 0.048)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.fromScale(0.96, 0.60)
	scroll.Position = UDim2.fromScale(0.02, 0.30)
	scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 55)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.Parent = page
	Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 7)
	local sLayout = Instance.new("UIListLayout")
	sLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	sLayout.Padding = UDim.new(0, 1)
	sLayout.Parent = scroll
	local sp = Instance.new("UIPadding", scroll)
	sp.PaddingLeft = UDim.new(0, 7)
	sp.PaddingTop = UDim.new(0, 4)
	local lines = {
		"SELECTORS",
		"all  /  others  /  me  /  random",
		"@username  /  #[n]  /  %[team]",
		"nearest  /  farthest  /  rad[n]",
		"allies  /  enemies  /  friends  /  nonfriends",
		"alive  /  dead  /  bacons  /  guests",
		"age[n]  /  group[ID]",
		"",
		"MOVEMENT",
		"fly [speed]  /  unfly",
		"noclip  /  unnoclip",
		"float  /  unfloat",
		"swim  /  unswim",
		"goto [player]  /  tweengoto [player]",
		"bring [player]",
		"loopspeed [n]  /  unloopspeed",
		"loopjump [n]  /  unloopjump",
		"speed [n]  /  jump [n]  /  gravity [n]",
		"sit  /  autojump  /  unautojump",
		"antivoid  /  unantivoid",
		"freecam  /  unfreecam",
		"inf  /  uninf",
		"flashback  /  diedtp",
		"refresh  /  respawn  /  reset",
		"teleporttool  /  tptool",
		"",
		"VISUAL",
		"esp  /  noesp",
		"espteam  /  unespteam",
		"chams  /  unchams",
		"xray  /  unxray",
		"fullbright  /  unfullbright",
		"day  /  night",
		"nofog  /  fog",
		"fov [n]  /  maxzoom [n]  /  fixcam",
		"spectate [player]  /  unspectate",
		"",
		"SERVER",
		"rejoin  /  rj",
		"serverhop  /  shop",
		"autorejoin  /  unautorejoin",
		"antiidle  /  unantiidle",
		"exit",
	}
	for _, line in ipairs(lines) do
		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1, -7, 0, 0)
		l.AutomaticSize = Enum.AutomaticSize.Y
		l.BackgroundTransparency = 1
		l.Text = (line == "") and " " or line
		local isHeader = line:upper() == line and line ~= "" and line ~= " "
		l.Font = isHeader and Enum.Font.GothamBlack or Enum.Font.GothamBold
		l.TextSize = isHeader and 10 or 9
		l.TextColor3 = isHeader and Color3.fromRGB(225, 225, 225) or Color3.fromRGB(135, 135, 135)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = scroll
	end
end

do
	local page = pages["Player"]
	makeSlider(page, "Walk Speed", 0.09, 1, 5000, 16, function(v)
		local h = getHum(); if h then h.WalkSpeed = v end
	end)
	makeSlider(page, "Jump Power", 0.21, 1, 5000, 50, function(v)
		local h = getHum(); if h then h.JumpPower = v end
	end)
	makeSlider(page, "Gravity", 0.33, 1, 5000, 196, function(v)
		workspace.Gravity = v
	end)
	makeToggle(page, "Fly  (WASD + Space / Ctrl)", 0.47, function(on)
		flyOn = on
		if on then startFly() end
		notify("Fly  " .. (on and "ON" or "OFF"))
	end)
	makeToggle(page, "Noclip", 0.56, function(on)
		noclipOn = on
		if on then startNoclip() end
		notify("Noclip  " .. (on and "ON" or "OFF"))
	end)
	makeToggle(page, "Infinite Jump", 0.65, function(on)
		infJumpOn = on
		notify("Infinite Jump  " .. (on and "ON" or "OFF"))
	end)
	makeToggle(page, "Antivoid", 0.74, function(on)
		antivoidOn = on
		if on then startAntivoid() end
		notify("Antivoid  " .. (on and "ON" or "OFF"))
	end)
end

do
	local page = pages["Server"]
	local infoBox = Instance.new("Frame")
	infoBox.Size = UDim2.fromScale(0.96, 0.28)
	infoBox.Position = UDim2.fromScale(0.02, 0.11)
	infoBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	infoBox.BorderSizePixel = 0
	infoBox.Parent = page
	Instance.new("UICorner", infoBox).CornerRadius = UDim.new(0, 7)
	local inLayout = Instance.new("UIListLayout")
	inLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	inLayout.Padding = UDim.new(0, 3)
	inLayout.Parent = infoBox
	local ip = Instance.new("UIPadding", infoBox)
	ip.PaddingTop = UDim.new(0, 6)
	ip.PaddingLeft = UDim.new(0, 9)
	local function infoRow(k, v)
		local l = Instance.new("TextLabel")
		l.Size = UDim2.fromScale(0.97, 0)
		l.AutomaticSize = Enum.AutomaticSize.Y
		l.BackgroundTransparency = 1
		l.Text = k .. "  " .. v
		l.Font = Enum.Font.GothamBold
		l.TextSize = 10
		l.TextColor3 = Color3.fromRGB(155, 155, 155)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = infoBox
	end
	infoRow("Job ID :", tostring(game.JobId):sub(1, 28))
	infoRow("Place ID :", tostring(game.PlaceId))
	infoRow("Players :", #Players:GetPlayers() .. " / " .. game.Players.MaxPlayers)
	local function makeBtn(txt, y, fn)
		local b = Instance.new("TextButton")
		b.Size = UDim2.fromScale(0.40, 0.11)
		b.Position = UDim2.fromScale(0.02, y)
		b.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
		b.Text = txt
		b.Font = Enum.Font.GothamBold
		b.TextSize = 11
		b.TextColor3 = Color3.fromRGB(205, 205, 205)
		b.Parent = page
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
		Instance.new("UIStroke", b).Color = Color3.fromRGB(30, 30, 30)
		b.MouseButton1Click:Connect(fn)
	end
	makeBtn("Rejoin", 0.44, function() TeleportService:Teleport(game.PlaceId, player) end)
	makeBtn("Server Hop", 0.57, function() TeleportService:Teleport(game.PlaceId) end)
end

do
	local page = pages["Settings"]
	makeLabel(page, "Blur Intensity", 0.10, 0.048)
	makeSlider(page, "Blur", 0.16, 0, 40, 14, function(v) blur.Size = v end)
	makeToggle(page, "Hide Command Bar", 0.31, function(on)
		cmdBar.Visible = not on
		notify("Command Bar  " .. (on and "Hidden" or "Shown"))
	end)
	makeLabel(page, "K  →  Toggle menu     ;  /  →  Command", 0.46, 0.048)
end

switchTab("Home")

local function runCmd(raw)
	local args = {}
	for w in raw:gmatch("%S+") do args[#args+1] = w end
	local cmd = (args[1] or ""):lower()

	if cmd == "fly" then
		flyOn = true
		startFly(tonumber(args[2]))
		notify("Fly  ON")
	elseif cmd == "unfly" then
		flyOn = false
		notify("Fly  OFF")
	elseif cmd == "noclip" then
		noclipOn = true
		startNoclip()
		notify("Noclip  ON")
	elseif cmd == "unnoclip" or cmd == "clip" then
		noclipOn = false
		notify("Noclip  OFF")
	elseif cmd == "float" or cmd == "platform" then
		spawnFloat()
		notify("Float  ON")
	elseif cmd == "unfloat" or cmd == "noplatform" then
		if floatPart then floatPart:Destroy(); floatPart = nil end
		notify("Float  OFF")
	elseif cmd == "swim" then
		swimOn = true
		startSwim()
		notify("Swim  ON")
	elseif cmd == "unswim" or cmd == "noswim" then
		swimOn = false
		notify("Swim  OFF")
	elseif cmd == "speed" then
		local v = tonumber(args[2])
		if v then
			local h = getHum(); if h then h.WalkSpeed = math.max(1, v) end
			notify("Speed  " .. v)
		end
	elseif cmd == "jump" then
		local v = tonumber(args[2])
		if v then
			local h = getHum(); if h then h.JumpPower = math.max(1, v) end
			notify("Jump  " .. v)
		end
	elseif cmd == "gravity" then
		local v = tonumber(args[2])
		if v then workspace.Gravity = math.max(1, v); notify("Gravity  " .. v) end
	elseif cmd == "inf" then
		infJumpOn = true; notify("Infinite Jump  ON")
	elseif cmd == "uninf" then
		infJumpOn = false; notify("Infinite Jump  OFF")
	elseif cmd == "loopspeed" or cmd == "loopws" then
		local v = tonumber(args[2])
		if v then loopSpeedVal = v; loopSpeedOn = true; startLoopSpeed(); notify("LoopSpeed  " .. v) end
	elseif cmd == "unloopspeed" or cmd == "unloopws" then
		loopSpeedOn = false; notify("LoopSpeed  OFF")
	elseif cmd == "loopjump" or cmd == "loopjp" or cmd == "loopjumppower" then
		local v = tonumber(args[2])
		if v then loopJpVal = v; loopJpOn = true; startLoopJp(); notify("LoopJump  " .. v) end
	elseif cmd == "unloopjump" or cmd == "unloopjp" or cmd == "unloopjumppower" then
		loopJpOn = false; notify("LoopJump  OFF")
	elseif cmd == "sit" then
		local h = getHum(); if h then h.Sit = true end; notify("Sit")
	elseif cmd == "autojump" or cmd == "ajump" then
		autoJumpOn = true; startAutoJump(); notify("AutoJump  ON")
	elseif cmd == "unautojump" or cmd == "unajump" then
		autoJumpOn = false; notify("AutoJump  OFF")
	elseif cmd == "antivoid" then
		antivoidOn = true; startAntivoid(); notify("Antivoid  ON")
	elseif cmd == "unantivoid" then
		antivoidOn = false; notify("Antivoid  OFF")
	elseif cmd == "freecam" or cmd == "fc" then
		freecamOn = true; startFreecam(); notify("Freecam  ON")
	elseif cmd == "unfreecam" or cmd == "unfc" then
		freecamOn = false; notify("Freecam  OFF")
	elseif cmd == "esp" then
		setupEsp(false); notify("ESP  ON")
	elseif cmd == "espteam" then
		setupEsp(true); notify("ESP Team  ON")
	elseif cmd == "noesp" or cmd == "unesp" or cmd == "unespteam" then
		clearEsp(); notify("ESP  OFF")
	elseif cmd == "chams" then
		chamsOn = true; startChams(); notify("Chams  ON")
	elseif cmd == "nochams" or cmd == "unchams" then
		chamsOn = false; clearChams(); notify("Chams  OFF")
	elseif cmd == "xray" then
		startXray(); notify("Xray  ON")
	elseif cmd == "unxray" or cmd == "noxray" then
		clearXray(); notify("Xray  OFF")
	elseif cmd == "fullbright" or cmd == "fb" then
		Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		Lighting.Brightness = 2
		notify("Fullbright  ON")
	elseif cmd == "unfullbright" or cmd == "unfb" then
		Lighting.Ambient = Color3.fromRGB(127, 127, 127)
		Lighting.Brightness = 1
		notify("Fullbright  OFF")
	elseif cmd == "day" then
		Lighting.ClockTime = 14; notify("Day")
	elseif cmd == "night" then
		Lighting.ClockTime = 0; notify("Night")
	elseif cmd == "nofog" then
		Lighting.FogEnd = 1e6; notify("Fog  OFF")
	elseif cmd == "fog" then
		Lighting.FogEnd = 100000; notify("Fog  ON")
	elseif cmd == "fov" then
		local v = tonumber(args[2])
		if v then workspace.CurrentCamera.FieldOfView = v; notify("FOV  " .. v) end
	elseif cmd == "maxzoom" then
		local v = tonumber(args[2])
		if v then player.CameraMaxZoomDistance = v; notify("MaxZoom  " .. v) end
	elseif cmd == "fixcam" or cmd == "restorecam" then
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		workspace.CurrentCamera.FieldOfView = 70
		player.CameraMaxZoomDistance = 400
		notify("Camera Fixed")
	elseif cmd == "reset" then
		local h = getHum(); if h then h.Health = 0 end
	elseif cmd == "respawn" then
		player:LoadCharacter()
	elseif cmd == "refresh" or cmd == "re" then
		local pos = getRoot() and getRoot().CFrame
		player:LoadCharacter()
		if pos then
			task.wait(1)
			local root = getRoot()
			if root then root.CFrame = pos end
		end
	elseif cmd == "flashback" or cmd == "diedtp" then
		if lastDeathPos then
			local root = getRoot()
			if root then root.CFrame = CFrame.new(lastDeathPos) end
			notify("Teleported to death")
		else
			notify("No death recorded")
		end
	elseif cmd == "teleporttool" or cmd == "tptool" then
		giveTpTool(); notify("TP Tool  given")
	elseif cmd == "goto" or cmd == "tweengoto" or cmd == "tgoto" then
		if args[2] then
			local targets = getPlayers(args[2])
			local t = targets[1]
			if t and t.Character then
				local root = t.Character:FindFirstChild("HumanoidRootPart")
				local myRoot = getRoot()
				if root and myRoot then
					myRoot.CFrame = root.CFrame + root.CFrame.LookVector * 4
					notify("Went to  " .. t.Name)
				end
			end
		end
	elseif cmd == "bring" then
		if args[2] then
			local targets = getPlayers(args[2])
			for _, t in ipairs(targets) do
				if t ~= player and t.Character then
					local tRoot = t.Character:FindFirstChild("HumanoidRootPart")
					local myRoot = getRoot()
					if tRoot and myRoot then tRoot.CFrame = myRoot.CFrame + myRoot.CFrame.LookVector * 5 end
				end
			end
			notify("Brought  " .. args[2])
		end
	elseif cmd == "spectate" or cmd == "view" then
		if args[2] then
			local targets = getPlayers(args[2])
			local t = targets[1]
			if t and t.Character then
				local root = t.Character:FindFirstChild("HumanoidRootPart")
				if root then
					workspace.CurrentCamera.CameraSubject = root
					notify("Spectating  " .. t.Name)
				end
			end
		end
	elseif cmd == "unspectate" or cmd == "unview" then
		local h = getHum()
		if h then workspace.CurrentCamera.CameraSubject = h end
		notify("Unspectate")
	elseif cmd == "rejoin" or cmd == "rj" then
		TeleportService:Teleport(game.PlaceId, player)
	elseif cmd == "serverhop" or cmd == "shop" then
		TeleportService:Teleport(game.PlaceId)
	elseif cmd == "autorejoin" or cmd == "autorj" then
		autoRejoinOn = true; notify("AutoRejoin  ON")
	elseif cmd == "unautorejoin" or cmd == "unautorj" then
		autoRejoinOn = false; notify("AutoRejoin  OFF")
	elseif cmd == "antiidle" or cmd == "antiafk" then
		antiIdleOn = true; notify("AntiIdle  ON")
	elseif cmd == "unantiidle" or cmd == "unantiafk" then
		antiIdleOn = false; notify("AntiIdle  OFF")
	elseif cmd == "exit" then
		player:Kick("Exited")
	elseif cmd == "cmds" then
		menu.Visible = true; switchTab("Home")
	end
end

cmdBox.FocusLost:Connect(function(enter)
	if not enter then return end
	local raw = cmdBox.Text:gsub("^[;/]", ""):lower():match("^%s*(.-)%s*$")
	cmdBox.Text = ""
	runCmd(raw)
end)

TweenService:Create(blur, TweenInfo.new(0.4), {Size = 14}):Play()
task.delay(2, function()
	TweenService:Create(intro, TweenInfo.new(0.7), {TextTransparency = 1}):Play()
	task.delay(0.7, function()
		intro:Destroy()
		cmdBar.Visible = true
		menu.Visible = true
		TweenService:Create(cmdBox, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		notify("Azura Admin Loaded")
	end)
end)

local open = true
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.K then
		open = not open
		gui.Enabled = open
		TweenService:Create(blur, TweenInfo.new(0.2), {Size = open and 14 or 0}):Play()
	end
end)
