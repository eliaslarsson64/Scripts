local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Create a custom highlight for a character
local function createCustomHighlight(character)
	if not character:FindFirstChild("CustomHighlight") then
		local h = Instance.new("Highlight")
		h.Name = "CustomHighlight"
		h.Parent = character
		h.FillColor = Color3.new(1, 0, 0.015) -- Red-ish
		h.OutlineColor = Color3.new(1, 1, 1) -- White outline
		h.FillTransparency = 0.5 -- Semi see-through body glow
		h.OutlineTransparency = 0 -- Solid outline
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- ESP through walls
	end
end

-- Create a BillboardGui with the player’s name
local function createBillboardGui(character, player)
	local head = character:FindFirstChild("Head")
	if not head then
		return
	end

	-- Avoid duplicates
	if head:FindFirstChild("NameTag") then
		head.NameTag:Destroy()
	end

	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "NameTag"
	billboardGui.Parent = head
	billboardGui.Size = UDim2.new(0, 100, 0, 50)
	billboardGui.Adornee = head
	billboardGui.StudsOffset = Vector3.new(0, 2, 0)
	billboardGui.AlwaysOnTop = true -- makes name visible through walls

	local textLabel = Instance.new("TextLabel")
	textLabel.Parent = billboardGui
	textLabel.Text = player.Name -- Show that player’s name
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextStrokeTransparency = 0.5
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
end

-- Setup for a player’s character
local function setupCharacter(player, character)
	createCustomHighlight(character)
	createBillboardGui(character, player)

	character:WaitForChild("Humanoid").Died:Connect(function()
		if character:FindFirstChild("CustomHighlight") then
			character.CustomHighlight:Destroy()
		end
		local head = character:FindFirstChild("Head")
		if head and head:FindFirstChild("NameTag") then
			head.NameTag:Destroy()
		end
	end)
end

-- Setup for each player
local function setupPlayer(player)
	if player == localPlayer then
		return
	end -- Skip yourself

	if player.Character then
		setupCharacter(player, player.Character)
	end

	player.CharacterAdded:Connect(function(character)
		setupCharacter(player, character)
	end)
end

-- Run for all current players
for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

-- Run for future players
Players.PlayerAdded:Connect(setupPlayer)
