local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Scripts",
	Icon = 0,
	LoadingTitle = "Rayfield Interface Suite",
	LoadingSubtitle = "by wortex",
	ShowText = "Rayfield",
	Theme = "Default",

	ToggleUIKeybind = "K",

	DisableRayfieldPrompts = true,
	DisableBuildWarnings = true,

	ConfigurationSaving = {
		Enabled = true,
		FolderName = "WortexHub",
		FileName = "Scripts",
	},
})

function TurtleSpy ()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
	Rayfield:Notify({
   		Title = "ScriptCreating",
   		Content = "You executed TurtleSpy",
  		Duration = 6.5,
    	Image = "rewind",
	})
end

function DexExplorer()
	loadstring(game:HttpGet("https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"))()
	Rayfield:Notify({
   		Title = "Scripts",
   		Content = "You executed Dex Explorer",
  		Duration = 6.5,
    	Image = "rewind",
	})
end

function InfiniteYield()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
	Rayfield:Notify({
   		Title = "Scripts",
   		Content = "You executed infinite yield",
  		Duration = 6.5,
    	Image = "rewind",
	})
end

function fly(Value)
	local flyNotify = nil
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")

	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local flightConnection = nil

	-- Flight Settings
	local NORMAL_SPEED = 60
	local SPRINT_SPEED = 250

	local function stopFlying()
		if flightConnection then
			flightConnection:Disconnect()
			flightConnection = nil
		end

		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			if rootPart:FindFirstChild("FlightGyro") then rootPart.FlightGyro:Destroy() end
			if rootPart:FindFirstChild("FlightVelocity") then rootPart.FlightVelocity:Destroy() end
		end

		if humanoid and humanoid.Health > 0 then
			humanoid.PlatformStand = false
		end
	end

	local function startFlying()
		stopFlying() -- Always clean up before starting

		local rootPart = character:WaitForChild("HumanoidRootPart")
		if not (rootPart and humanoid and humanoid.Health > 0) then return end

		humanoid.PlatformStand = true

		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.Name = "FlightGyro"
		bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyGyro.P = 50000
		bodyGyro.Parent = rootPart

		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = "FlightVelocity"
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = rootPart

		flightConnection = RunService.Heartbeat:Connect(function()
			local camera = workspace.CurrentCamera
			if not camera or not bodyGyro.Parent or not bodyVelocity.Parent then
				stopFlying()
				return
			end

			bodyGyro.CFrame = camera.CFrame

			local moveVector = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += Vector3.new(0, 0, -1) end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector += Vector3.new(0, 0, 1) end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector += Vector3.new(-1, 0, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += Vector3.new(1, 0, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector += Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector += Vector3.new(0, -1, 0) end

			local currentSpeed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and SPRINT_SPEED or NORMAL_SPEED

			if moveVector.Magnitude > 0.01 then
				bodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(moveVector.Unit) * currentSpeed
			else
				bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			end
		end)
	end
	if Value then
		startFlying()
		flyNotify = "You are flying"
	elseif not Value then
		stopFlying()
		flyNotify = "You are not flying"
	end
	Rayfield:Notify({
   		Title = "Player",
   		Content = flyNotify,
  		Duration = 6.5,
    	Image = "rewind",
	})
end

function WalkSpeed(Value)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end

function Kick()
	game.Players.LocalPlayer:Kick("Kicked")
end

function kill()
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
	Rayfield:Notify({
   		Title = "Player",
   		Content = "You killed yourself",
  		Duration = 6.5,
    	Image = "rewind",
	})
end

local Player = Window:CreateTab("Player", 4483362458)
local Scripts = Window:CreateTab("Scripts", 4483362458)
local ScriptCreating = Window:CreateTab("ScriptCreating", 4483362458)

local Button = Player:CreateButton({
	Name = "kill",
	Callback = function()
		kill()
	end,
})

local Button = Player:CreateButton({
	Name = "kick",
	Callback = function()
		Kick()
	end,
})

local Slider = Player:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 10,
   Flag = "WalkSpeed",
   Callback = function(Value)
		WalkSpeed(Value)
   end,
})

local Button = ScriptCreating:CreateButton({
	Name = "DexExplorer",
	Callback = function()
		DexExplorer()
	end,
})

local Button = Scripts:CreateButton({
	Name = "InfiniteYield",
	Callback = function()
		InfiniteYield()
	end,
})

local Button = ScriptCreating:CreateButton({
	Name = "TurtleSpy",
	Callback = function()
		TurtleSpy()
	end,
})

local Toggle = Player:CreateToggle({
   Name = "Fly",
   CurrentValue = nil,
   Flag = "Fly",
   Callback = function(Value)
	fly(Value)
   end,
})