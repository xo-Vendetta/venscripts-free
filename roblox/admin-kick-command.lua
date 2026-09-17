--[[
	Admin Kick Command | Vendetta Scripts
	More scripts: https://venscripts.dev  |  Support & updates: https://discord.gg/9VaUnWTahk
	Version 1.0.0

	Placement: ServerScriptService, as a Script (not a LocalScript).

	Server-side by design: the command is read from Player.Chatted on the
	server, so the admin check cannot be bypassed by an exploiter.

	Setup:  add admin UserIds to ADMIN_IDS below.
	Usage:  /kick PlayerName   (partial names accepted)

	Support: venscripts.dev
--]]

-- ==========================================
-- CONFIGURATION (Please make changes here)
-- ==========================================
-- Find your id in your profile URL: roblox.com/users/1234567/profile
-- Remember to remove the -- or the entry is only a comment.
local ADMIN_IDS = {
	-- 1234567,
}

local COMMAND_PREFIX = "/kick "
local KICK_MESSAGE = "You have been removed from the server by an Administrator."
local PROTECT_ADMINS = true -- Stop admins kicking one another

-- ==========================================
-- SYSTEM LOGIC (Do not touch)
-- ==========================================
local Players = game:GetService("Players")

local function isAdmin(player)
	-- CreatorType matters: in a GROUP-owned game, game.CreatorId is the
	-- group id, not a user id. Comparing it to a UserId is meaningless
	-- there and could in theory match an unrelated player.
	if game.CreatorType == Enum.CreatorType.User and player.UserId == game.CreatorId then
		return true
	end

	for _, adminId in ipairs(ADMIN_IDS) do
		if player.UserId == tonumber(adminId) then
			return true
		end
	end

	return false
end

-- Partial and case-insensitive, so an admin doesn't have to type an exact
-- username while something is actually going wrong in their server.
local function findPlayer(nameFragment)
	nameFragment = nameFragment:lower()

	local exact, partial
	for _, player in ipairs(Players:GetPlayers()) do
		local name = player.Name:lower()
		if name == nameFragment then
			exact = player
		elseif not partial and name:sub(1, #nameFragment) == nameFragment then
			partial = player
		end
	end

	return exact or partial
end

local function onPlayerChatted(player, message)
	if not isAdmin(player) then
		return
	end

	if message:lower():sub(1, #COMMAND_PREFIX) ~= COMMAND_PREFIX:lower() then
		return
	end

	-- Trim stray spaces so "/kick   Bob" still resolves.
	local targetName = message:sub(#COMMAND_PREFIX + 1):match("^%s*(.-)%s*$")

	if targetName == "" then
		warn("[Admin System] " .. player.Name .. " ran /kick with no player name.")
		return
	end

	local target = findPlayer(targetName)

	if not target then
		warn(("[Admin System] %s tried to kick '%s', but no matching player is here.")
			:format(player.Name, targetName))
		return
	end

	if target == player then
		warn("[Admin System] " .. player.Name .. " tried to kick themselves.")
		return
	end

	if PROTECT_ADMINS and isAdmin(target) then
		warn(("[Admin System] %s tried to kick %s, who is also an admin. Blocked.")
			:format(player.Name, target.Name))
		return
	end

	target:Kick(KICK_MESSAGE)
	print(("[Admin System] %s kicked %s."):format(player.Name, target.Name))
end

-- Guarded so a player can never end up with two chat listeners.
local connected = {}

local function hookPlayer(player)
	if connected[player.UserId] then
		return
	end
	connected[player.UserId] = true

	player.Chatted:Connect(function(message)
		onPlayerChatted(player, message)
	end)
end

Players.PlayerAdded:Connect(hookPlayer)
Players.PlayerRemoving:Connect(function(player)
	connected[player.UserId] = nil
end)

-- Anyone already in the game when this script starts.
for _, player in ipairs(Players:GetPlayers()) do
	hookPlayer(player)
end

-- ==========================================
-- SETUP CHECKS (run once on startup)
-- ==========================================
for index, id in ipairs(ADMIN_IDS) do
	if tonumber(id) == nil then
		warn("[Admin System] ADMIN_IDS entry #" .. index
			.. " is not a valid UserId: " .. tostring(id))
	end
end

if #ADMIN_IDS == 0 then
	if game.CreatorType == Enum.CreatorType.User then
		warn("[Admin System] No ADMIN_IDS set, so only the game owner can use /kick.")
	else
		warn("[Admin System] No ADMIN_IDS set, and this game is group-owned so the "
			.. "owner fallback does not apply. Nobody can use /kick.")
	end
end
