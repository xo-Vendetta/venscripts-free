# Roblox Free Scripts

Luau scripts for Roblox Studio. All three run **server-side**, so they can't be
bypassed or triggered by a client.

[← All games](../README.md)

| Script | What it does | Where it goes |
| --- | --- | --- |
| [Admin Kick Command](#admin-kick-command) | Chat command that lets listed admins kick players | `ServerScriptService` |
| [Killbrick](#killbrick) | Any part becomes lethal on touch | Inside the brick |
| [Shop to Base Teleport](#shop-to-base-teleport) | Teleport pad that sends players to a fixed point | Inside the pad |

---

## Admin Kick Command

[`admin-kick-command.lua`](admin-kick-command.lua)

Lets the people you list kick players straight from chat.

**Placement:** `ServerScriptService`, as a **Script** (not a LocalScript).

**Setup:** add your admins' User IDs to the configuration block at the top.

```lua
local ADMIN_IDS = {
    1234567,
}
```

> Find a User ID in the profile URL: `roblox.com/users/`**`1234567`**`/profile`.
> Remember to delete the `--` in front of the line, or the entry is only a comment.

**Usage:** `/kick PlayerName`

Partial names work, so `/kick ste` finds `Steve123`. In a game owned by your own
account, you always have access, even with an empty list.

**Settings**
- `COMMAND_PREFIX`: the command players type. Default `/kick `.
- `KICK_MESSAGE`: what the kicked player sees.
- `PROTECT_ADMINS`: stops admins kicking one another. On by default.

**Notes**
- The command is read from `Player.Chatted` on the server, so the admin check
  can't be faked by an exploiter.
- You can't kick yourself, and results are printed to the **server output**,
  not in-game chat.
- In a **group-owned** game the owner fallback doesn't apply, so add every admin
  to `ADMIN_IDS`. The script warns at startup if nobody would have access.

---

## Killbrick

[`killbrick.lua`](killbrick.lua)

Turns any part into an instant kill on contact.

**Placement:** inside the brick, as a **Script** (not a LocalScript).

**Setup:** none. Drop it in and the brick is lethal.

**Notes**
- Kills anything with a `Humanoid`, NPCs included.
- Works through spawn ForceFields, since it sets health directly.

---

## Shop to Base Teleport

[`shop-to-base-teleport.lua`](shop-to-base-teleport.lua)

A pad that moves players to a fixed destination, such as a shop exit back to a home
base, for example.

**Placement:** inside the teleport pad Part, as a **Script** (not a LocalScript).

**Setup:** create the destination and name it to match the configuration.

```lua
local DESTINATION_NAME = "DestinationHomeBase1"
local HEIGHT_OFFSET = 3   -- studs above the destination
local COOLDOWN = 1        -- seconds before the same player can re-trigger
```

The destination can be a **Part or a Model**, and it can sit anywhere in
`Workspace`, including inside a folder.

**Notes**
- The cooldown is **per player**, so one person using the pad never blocks
  anyone else.
- Uses `PivotTo` to move the whole character, which avoids the rubber-banding
  you get from setting `HumanoidRootPart.CFrame` directly.
- If the destination is missing or misnamed, the pad says so in the Output
  window rather than failing silently.

---

## Installing in Roblox Studio

1. Open your place in Roblox Studio.
2. Create a **Script** in the location listed for the one you want.
3. Paste the contents of the `.lua` file over the default `print("Hello world!")`.
4. Edit the configuration block at the top, if the script has one.
5. Press **Play** and check the **Output** window.

Setup problems show up in Output with a tag in brackets, such as `[Teleport]` or `[Admin System]`. A missing
admin list or a misspelled destination names itself there rather than failing
quietly.
