--[[
	Killbrick | Vendetta Scripts
	More scripts: https://venscripts.dev  |  Support & updates: https://discord.gg/9VaUnWTahk
	Version 1.0.0

	Placement: inside the brick, as a Script (not a LocalScript).
	Server-side, so the kill cannot be blocked by a client.

	No configuration needed. Drop it in and the brick is lethal.

	Support: venscripts.dev
--]]

-- 1. Reference the brick this script is attached to
local brick = script.Parent

-- 2. Runs whenever anything touches the brick
local function onTouch(otherPart)
	-- A part destroyed in the same frame it touches leaves Parent nil, which
	-- would otherwise error on the next line.
	local character = otherPart.Parent
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	-- 3. Already-dead check: a body resting on the brick fires Touched
	--    continuously, and this skips the redundant writes.
	if humanoid and humanoid.Health > 0 then
		humanoid.Health = 0
	end
end

-- 4. Listen for the "Touched" event
brick.Touched:Connect(onTouch)
