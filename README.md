# VenScripts Free Scripts

Free scripts for game servers and game developers, released with full,
readable source. No dependencies, no account, no catch. Download one, read it,
and use it in whatever you're building.

It started with Roblox and is growing to cover more games. The paid catalogue,
with larger systems and FiveM (QBCore) resources, lives at
**[venscripts.dev](https://venscripts.dev)**.

💬 **Join the Discord** for help, updates and new free scripts:
[discord.gg/9VaUnWTahk](https://discord.gg/9VaUnWTahk)

---

## Scripts by game

| Game | Scripts | Language |
| --- | --- | --- |
| [Roblox](roblox/) | [Admin Kick Command](roblox/README.md#admin-kick-command) · [Killbrick](roblox/README.md#killbrick) · [Shop to Base Teleport](roblox/README.md#shop-to-base-teleport) | Luau |

More games are on the way. Each game has its own folder with a README covering
where every script goes and how to set it up.

---

## How the scripts are written

Every script follows the same few rules, whatever the game:

- **Settings live in one clearly marked block** at the top, under
  `CONFIGURATION`. Nothing below it needs touching.
- **Server-side where it matters.** Anything that affects gameplay, like kicks,
  kills and teleports, runs where players can't tamper with it.
- **Problems say so.** A misspelled name or missing setup is reported in the
  game's output or console, tagged so you can tell which script it came from, rather than failing
  silently.

---

## Using a script

1. Open the folder for your game and read its README.
2. Copy the script into the place it tells you to.
3. Change the settings in the configuration block, if the script has any.
4. Test it, and check the output for any setup warnings.

---

## Licence

Released under the [MIT Licence](LICENSE). Use the scripts in personal or
commercial projects and change them however you like. Just keep the copyright
notice.

---

## Help and requests

- **Something broken or unclear?** Open an
  [issue](https://github.com/xo-Vendetta/venscripts-free/issues), or ask in the
  [Discord](https://discord.gg/9VaUnWTahk).
- **Want a script for your game?** Suggest it in the Discord.

All scripts here are written and maintained by VenScripts, so pull requests
aren't merged, but bug reports and ideas are always welcome, and a good idea
may well turn into the next free script.
