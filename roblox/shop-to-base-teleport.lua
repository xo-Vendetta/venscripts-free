--[[
	Shop to Base Teleport — Vendetta Scripts
	More scripts: https://venscripts.dev  |  Support & updates: https://discord.gg/9VaUnWTahk
	Version 1.0.0

	Placement: inside the teleport pad Part, as a Script (not a LocalScript).
	Server-side, so the destination cannot be altered by a client.

	Setup:  name your destination part to match DESTINATION_NAME below.
	        It can sit anywhere in Workspace, including inside a folder.

	Support: venscripts.dev
--]]

-- ==========================================
-- CONFIGURATION (Please make changes here)
-- ==========================================
local DESTINATION_NAME = "DestinationHomeBase1" -- Part or Model to send players to
local HEIGHT_OFFSET = 3                          -- Studs above the destination
local COOLDOWN = 1                               -- Seconds before the same player can re-trigger

-- ==========================================
-- SYSTEM LOGIC (Do not touch)
-- ==========================================
local Players = game:GetService("Players")

local pad = script.Parent

-- Per player, so one person using the pad never blocks anyone else.
local lastTeleport = {}

-- Direct children first, then a deep search, so the destination still resolves
-- if it has been tidied into a folder or model.
local destination = workspace:WaitForChild(DESTINATION_NAME, 10)
    or workspace:FindFirstChild(DESTINATION_NAME, true)

local function destinationCFrame()
	if destination:IsA("BasePart") then
		return destination.CFrame
	end
	return destination:GetPivot() -- destination is a Model
end

local function onTouch(otherPart)
	if not destination then
		return
	end

	local character = otherPart.Parent
	local player = Players:GetPlayerFromCharacter(character)
	if not player then
		return -- an NPC or a stray part, not a player
	end

	local now = os.clock()
	local last = lastTeleport[player.UserId]
	if last and (now - last) < COOLDOWN then
		return
	end
	lastTeleport[player.UserId] = now

	-- PivotTo moves the whole character model. Setting HumanoidRootPart.CFrame
	-- alone can fight the client's physics ownership and cause rubber-banding.
	character:PivotTo(destinationCFrame() + Vector3.new(0, HEIGHT_OFFSET, 0))
end

pad.Touched:Connect(onTouch)

Players.PlayerRemoving:Connect(function(player)
	lastTeleport[player.UserId] = nil
end)

-- ==========================================
-- SETUP CHECKS (run once on startup)
-- ==========================================
if not destination then
	warn(("[Teleport] No part or model named '%s' found in Workspace - this pad "
		.. "will do nothing. Check the spelling in DESTINATION_NAME.")
		:format(DESTINATION_NAME))
elseif not (destination:IsA("BasePart") or destination:IsA("Model")) then
	warn(("[Teleport] '%s' is a %s - it needs to be a Part or a Model.")
		:format(DESTINATION_NAME, destination.ClassName))
	destination = nil
end
