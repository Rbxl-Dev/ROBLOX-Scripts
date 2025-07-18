if RBXL_RUNNING_SCRIPT or _G.RBXL_RUNNING_SCRIPT then return end

if getgenv then
	getgenv().DISABLE_RAYFIELD_REQUESTS = true
end

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local GamePasses = {
	["HD Admin"] = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, 10787783),
	["VIP"] = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, 11649960),
	["Trail"] = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, 11251919),
	["Pride Flag Pack"] = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, 11399991),
	["Custom Flag"] = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, 11500770)
}

local Remotes = {
	["ChangeFlagImage"] = ReplicatedStorage:WaitForChild("ChangeFlagImage"),
	["RequestCommand"] = ReplicatedStorage:WaitForChild("HDAdminHDClient"):WaitForChild("Signals"):WaitForChild("RequestCommandModification"),
	["RequestCommandBubblechat"] = ReplicatedStorage:WaitForChild("HDAdminHDClient"):WaitForChild("Signals"):WaitForChild("RequestCommand")
}

local Window = Rayfield:CreateWindow({
	Name = "BitsProxy Panel",
	Icon = 81821536708572,
	LoadingTitle = "Roblox Game Script",
	LoadingSubtitle = "by BitsProxy",
	Theme = "Default",
	DisableRayfieldPrompts = true,
	DisableBuildWarnings = true,
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "BitsProxy",
		FileName = "LGBTQ Hangout"
	}
})

local function GetPlayers(str)
	str = tostring(str):lower()
	if str == "me" then
		return {Player}
	end
	if str == "random" then
		return Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
	end
	if str == "all" or str == "everyone" then return Players:GetPlayers() end
	if str:find("others") then
		local plrs = {}
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= Player then
				table.insert(plrs, player)
			end
		end
		return plrs
	end
	local players = {}
	for i, v in pairs(Players:GetPlayers()) do
		if string.find(v.Name:lower(), str) or string.find(v.DisplayName:lower(), str) then
			table.insert(players, v)
		end
	end
	return players
end

local function FindInTable(tab,val)
	for i,v in pairs(tab) do
		if v == val then
			return true
		end
	end
	return false
end

local function Notify(title, content)
	Rayfield:Notify({
		["Title"] = title,
		["Content"] = content,
		["Duration"] = 5,
		["Image"] = "bell"
	})
end

local function ChangeTheme(theme)
	return function()
		Window.ModifyTheme(theme)
	end
end

local function CopyToClipboard(content)
	local CopyClipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
	if CopyClipboard then CopyClipboard(content) return true end
	return false
end

local FlagNames = {'Flag', 'AceFlag', 'BiFlag', 'DemiFlag', 'GayFlag', 'LesbianFlag', 'PanFlag', 'TransFlag'}

local function GetFlags(character)
	local Flags = {}; do
		if character then
			for i,v in pairs(character:GetChildren()) do
				if v:IsA("Tool") and FindInTable(FlagNames, v.Name) then
					table.insert(Flags, v)
				end
			end
		end
	end
	return Flags
end

local function GetFlag(character, specific)
	local Flag; do
		if character then
			for i,v in pairs(character:GetChildren()) do
				if v:IsA("Tool") and FindInTable(FlagNames, v.Name) then
					if typeof(specific) == "string" then
						if v.Name:lower() == specific:lower() then
							Flag = v;
							break
						end
					else
						Flag = v;
						break
					end
				end
			end
		end
	end
	return Flag
end

local function GetDecalsFromFlag(flag)
	if flag then
		local Decals = {}
		for i,v in pairs(flag:GetDescendants())do
			table.insert(Decals, v)
		end
		return Decals
	end
end

local function ChangeDecal(decal, assetId)
	local Object = {["\70\108\97\103"]={["\67\117\115\116\111\109\70\108\97\103\76\101\102\116"]=decal,["\67\117\115\116\111\109\70\108\97\103\82\105\103\104\116"]=decal}}
	Remotes.ChangeFlagImage:FireServer(Object, assetId)
end

local function ChangeFlag(player, assetId, specific)
	local Flag = GetFlag(player.Character, specific)
	if Flag then
		for i, decal in pairs(GetDecalsFromFlag(Flag)) do
			ChangeDecal(decal, assetId)
		end
	end
end

local function MoveCharacter(vector3)
	if Player.Character then
		Player.Character:MoveTo(vector3)
	end
end

local function unequipTool(name)
	if not Player.Character then return end
	for i,v in pairs(Player.Character:GetChildren()) do
		if v:IsA("Tool") and v.Name == name then
			v.Parent = Player.Backpack;
		end
	end
end

local function equipTool(name)
	if not Player.Character then return end
	for i,v in pairs(Player.Backpack:GetChildren()) do
		if v:IsA("Tool") and v.Name == name then
			v.Parent = Player.Character;
		end
	end
end

local UserTab = Window:CreateTab("Hub", "info")
UserTab:CreateSection("Details")
UserTab:CreateLabel("Version: 3.2.8", "history")
UserTab:CreateLabel("Role: Premium", "circle-user-round")

UserTab:CreateDivider()

UserTab:CreateSection("Theme")

UserTab:CreateButton({
	Name = "Default Theme",
	Callback = ChangeTheme("Default")
})

UserTab:CreateButton({
	Name = "Amber Glow Theme",
	Callback = ChangeTheme("AmberGlow")
})

UserTab:CreateButton({
	Name = "Amethyst (Purple) Theme",
	Callback = ChangeTheme("Amethyst")
})

UserTab:CreateButton({
	Name = "Bloom Theme",
	Callback = ChangeTheme("Bloom")
})

UserTab:CreateButton({
	Name = "Dark Blue Theme",
	Callback = ChangeTheme("DarkBlue")
})

UserTab:CreateButton({
	Name = "Green Theme",
	Callback = ChangeTheme("Green")
})

UserTab:CreateButton({
	Name = "Light Theme",
	Callback = ChangeTheme("Light")
})

UserTab:CreateButton({
	Name = "Ocean Theme",
	Callback = ChangeTheme("Ocean")
})

UserTab:CreateButton({
	Name = "Serenity Theme",
	Callback = ChangeTheme("Serenity")
})

local MapTab = Window:CreateTab("Map", "map")

MapTab:CreateSection("Teleports")
MapTab:CreateButton({
	Name = "Hidden Area",
	Callback = function()
		MoveCharacter(Vector3.new(-1290, 48, -10))
	end,
})
MapTab:CreateButton({
	Name = "Minigame",
	Callback = function()
		MoveCharacter(Vector3.new(-116, 57, 38))
	end
})
MapTab:CreateButton({
	Name = "Spawn",
	Callback = function()
		local Spawns = {}
		for i,v in pairs(Workspace:GetChildren()) do
			if v:IsA("SpawnLocation") then
				table.insert(Spawns, v)
			end
		end
		local SpawnPart = Spawns[math.random(1, #Spawns)]
		MoveCharacter(Vector3.new(SpawnPart.Position.X, 42, SpawnPart.Position.Z))
	end,
})
MapTab:CreateButton({
	Name = "Lesbian",
	Callback = function()
		MoveCharacter(Vector3.new(-116, 65, -62))
	end
})
MapTab:CreateButton({
	Name = "Gay",
	Callback = function()
		MoveCharacter(Vector3.new(-70, 65, -62))
	end
})
MapTab:CreateButton({
	Name = "Bisexual",
	Callback = function()
		MoveCharacter(Vector3.new(-24, 65, -63))
	end
})
MapTab:CreateButton({
	Name = "Transgender",
	Callback = function()
		MoveCharacter(Vector3.new(22, 65, -63))
	end
})
MapTab:CreateButton({
	Name = "Asexual",
	Callback = function()
		MoveCharacter(Vector3.new(67, 65, -64))
	end
})
MapTab:CreateButton({
	Name = "Pansexual",
	Callback = function()
		MoveCharacter(Vector3.new(114, 65, -64))
	end
})

local FlagsTab = Window:CreateTab("Flags", "flag")
local FlagId = 17497331752

local function SplitIDs(id)
	id = string.gsub(tostring(id),"\32","")
	local split = string.split(id, ",")
	return split
end

FlagsTab:CreateSection("Flag Changing")
FlagsTab:CreateInput({
	Name = "Change Players Flags",
	CurrentValue = "me",
	PlaceholderText = "Input Player Names",
	RemoveTextAfterFocusLost = false,
	Callback = function(value)
		if string.gsub(value, '\32', '') == '' then return end
		for _, player in pairs(GetPlayers(value)) do
			local ids = SplitIDs(FlagId)
			local flags = GetFlags(player.Character)
			for i = 1, math.min(#ids, #flags) do
				local assetId = tonumber(ids[i])
				if assetId then
					ChangeFlag(player, assetId, flags[i].Name)
				end
			end
		end

	end,
})
FlagsTab:CreateInput({
	Name = "Decal IDs",
	CurrentValue = "17497331752",
	PlaceholderText = "Input Decal Id",
	RemoveTextAfterFocusLost = false,
	Flag = "FlagsDecalId",
	Callback = function(value)
		FlagId = tonumber(value) or 17497331752
	end,
})

FlagsTab:CreateSection("Flag Gripping")
local function StopHoldingToolAnims(Character)
	if not Character then return end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local Animate = Character:FindFirstChild("Animate")

	if not Humanoid or not Animate then return end

	for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
	end

	local idleValue = Animate:FindFirstChild("idle")
	if idleValue and idleValue:IsA("StringValue") then
		for _, anim in ipairs(idleValue:GetChildren()) do
			if anim:IsA("Animation") and anim.AnimationId ~= "" then
				local track = Humanoid:LoadAnimation(anim)
				track:Play()
			end
		end
	end
end

local function SetGripFlag(flag, grip)
	Player.Backpack:FindFirstChild(flag).Grip = grip
end
FlagsTab:CreateButton({
	Name = "Equip Flags",
	Callback = function()
		if not Player.Character then return end
		for i,v in pairs(Player.Backpack:GetChildren()) do
			if Player.Character and FindInTable(FlagNames, v.Name) then
				v.Parent = Player.Character
			end
		end
	end,
})
FlagsTab:CreateButton({
	Name = "Reset Flag Grips",
	Callback = function()
		if not Player.Character then return end
		for i,v in pairs(Player.Backpack:GetChildren()) do
			if v:IsA("Tool") and FindInTable(FlagNames, v.Name) then
				SetGripFlag(v.Name, CFrame.new(0, -1.94999981, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1))
			end
		end
		for i,v in pairs(Player.Character:GetChildren()) do
			if v:IsA("Tool") and FindInTable(FlagNames, v.Name) then
				v.Parent = Player.Backpack
				SetGripFlag(v.Name, CFrame.new(0, -1.94999981, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1))
				v.Parent = Player.Character
			end
		end
	end
})
FlagsTab:CreateButton({
	Name = "X Flags",
	Callback = function()
		if not Player.Character then return end
		for i,v in pairs(Player.Character:GetChildren()) do
			if v:IsA("Tool") and FindInTable(FlagNames, v.Name) then
				v.Parent = Player.Backpack
			end
		end
		task.wait()
		local FlagCounter = 0
		for i,v in pairs(Player.Backpack:GetChildren()) do
			if Player.Character and FindInTable(FlagNames, v.Name) then
				FlagCounter += 1
				v.Grip *= CFrame.Angles(0, math.rad(45*(FlagCounter)), 0)
				v.Parent = Player.Character
			end
		end
	end,
})
FlagsTab:CreateButton({
	Name = "Monitor Flags",
	Callback = function()
		if not Player.Character then return end
		for i,v in pairs(Player.Character:GetChildren()) do
			if v:IsA("Tool") and FindInTable(FlagNames, v.Name) then
				v.Parent = Player.Backpack
			end
		end
		task.wait()
		SetGripFlag("Flag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(4,0,-6)))
		SetGripFlag("AceFlag", CFrame.Angles(math.rad(-90),0,math.rad(-90)) * CFrame.new(Vector3.new(-4,0,-6)))
		SetGripFlag("BiFlag", CFrame.Angles(math.rad(-90),0,math.rad(-90)) * CFrame.new(Vector3.new(2,0,-6)))
		SetGripFlag("DemiFlag", CFrame.Angles(math.rad(-90),0,math.rad(-90)) * CFrame.new(Vector3.new(2,0,-10)))
		SetGripFlag("GayFlag", CFrame.Angles(math.rad(-90),0,math.rad(-90)) * CFrame.new(Vector3.new(2,0,-14)))
		SetGripFlag("LesbianFlag", CFrame.Angles(math.rad(-90),0,math.rad(-90)) * CFrame.new(Vector3.new(-4,0,-10)))
		SetGripFlag("PanFlag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(4,0,-10)))
		SetGripFlag("TransFlag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(-0.8,0,-2)))
		task.wait()
		for i,v in pairs(Player.Backpack:GetChildren()) do
			if Player.Character and FindInTable(FlagNames, v.Name) then
				v.Parent = Player.Character
			end
		end
		StopHoldingToolAnims()
	end,
})
FlagsTab:CreateButton({
	Name = "Line Flags",
	Callback = function()
		if not Player.Character then return end
		for i,v in pairs(Player.Character:GetChildren()) do
			if v:IsA("Tool") and FindInTable(FlagNames, v.Name) then
				v.Parent = Player.Backpack
			end
		end
		task.wait()
		SetGripFlag("Flag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(3,0,-3)))
		SetGripFlag("AceFlag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(8,0,-3)))
		SetGripFlag("BiFlag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(13,0,-3)))
		SetGripFlag("DemiFlag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(18,0,-3)))
		SetGripFlag("GayFlag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(-3,0,-3)))
		SetGripFlag("LesbianFlag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(-8,0,-3)))
		SetGripFlag("PanFlag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(-13,0,-3)))
		SetGripFlag("TransFlag", CFrame.Angles(math.rad(-90),0,math.rad(90)) * CFrame.new(Vector3.new(-18,0,-3)))
		task.wait()
		for i,v in pairs(Player.Backpack:GetChildren()) do
			if Player.Character and FindInTable(FlagNames, v.Name) then
				v.Parent = Player.Character
			end
		end
		StopHoldingToolAnims()
	end,
})

local ServerTab = Window:CreateTab("Server", "server")
local ServerDecalId = 17497331752
local DecalSpamming = false

ServerTab:CreateSection("Serverside Decals")
ServerTab:CreateButton({
	Name = "Change Map Decals",
	Callback = function()
		for i,v in pairs(GetDecalsFromFlag(workspace)) do
			ChangeDecal(v, ServerDecalId)
		end
	end
})
ServerTab:CreateInput({
	Name = "Decal Id",
	CurrentValue = "17497331752",
	PlaceholderText = "Input Asset Id",
	RemoveTextAfterFocusLost = false,
	Flag = "ServersideDecalID",
	Callback = function(txt)
		ServerDecalId = tonumber(txt) or 17497331752
	end
})
ServerTab:CreateInput({
	Name = "Change Players Face",
	CurrentValue = "others",
	PlaceholderText = "Input Player Names",
	RemoveTextAfterFocusLost = false,
	Callback = function(players)
		if string.gsub(players, '\32', '') == '' then return end
		for _, player in pairs(GetPlayers(players)) do
			spawn(function()
				if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("face") then
					ChangeDecal(player.Character.Head.face, ServerDecalId)
				end
			end)
		end
	end
})
ServerTab:CreateToggle({
	Name = "Decal Spam",
	CurrentValue = false,
	Flag = "DecalSpammingServer",
	Callback = function(value)
		DecalSpamming = value;
		spawn(function()
			while DecalSpamming do
				for i, decal in ipairs(GetDecalsFromFlag(Workspace)) do
					ChangeDecal(decal, ServerDecalId)
					task.wait()
				end
				task.wait(0.01)
			end
		end)
	end
})

ServerTab:CreateSection("Controller")

local LagServer = false
local LagTools = {}
ServerTab:CreateButton({
	Name = "Fix Gui Glitches",
	Callback = function()
		for i, v in pairs(Player.PlayerGui:GetChildren()) do
			if v.Name == 'Gui' or v.Name == 'CustomFlagUI' then
				v:Destroy()
			end
		end
	end
})
ServerTab:CreateToggle({
	Name = "Lag Server",
	CurrentValue = false,
	Callback = function(value)
		LagServer = value;
		spawn(function()
			if LagServer == true then
				if Player.Character then
					for i,v in pairs(Player.Character:GetChildren()) do
						if v:IsA("Tool") then
							v.Parent = Player.Backpack
						end
					end
				end
				for i,v in pairs(Player.Backpack:GetChildren())do
					if v:IsA("Tool") then
						table.insert(LagTools, v.Name)
					end
				end
			end
			while LagServer do
				for i,v in pairs(LagTools) do
					equipTool(v)
					unequipTool(v)
				end
				task.wait()
			end
		end)
	end
})

local SettingsTab = Window:CreateTab("Settings", "settings")
local AntiFling

SettingsTab:CreateLabel("Executor: " .. (identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "******"), "app-window")
SettingsTab:CreateLabel("HWID: " .. RbxAnalyticsService:GetClientId(), "binary")
SettingsTab:CreateToggle({
	Name = "Anti Fling",
	CurrentValue = false,
	Flag = "AntiFlinging",
	Callback = function(value)
		if AntiFling then
			AntiFling:Disconnect()
			AntiFling = nil
		end
		if value == true then
			AntiFling = RunService.Stepped:Connect(function()
				for _, player in pairs(Players:GetPlayers()) do
					if player ~= Players.LocalPlayer and player.Character then
						for _, v in pairs(player.Character:GetDescendants()) do
							if v:IsA("BasePart") then
								v.CanCollide = false
							end
						end
					end
				end
			end)
		end
	end
})

--[[
>> IGNORE THIS!!
pcall(function()
	Player.PlayerGui:WaitForChild("HDAdminInterface"):WaitForChild("Notices").Visible = false
end)
while true do
    if tr then break end
execCmd(game.HttpService:GenerateGUID(false):gsub('-', '‐'))
task.wait(5)
end
]]

Rayfield:LoadConfiguration()
