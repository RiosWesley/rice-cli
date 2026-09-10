-- Template: minimal vanilla profile
local HOME = os.getenv("HOME")

-- Shared configuration
require("shared.monitors")
require("shared.input")
require("shared.env")
require("shared.rules")

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg",
            inactive_border = "rgba(595959aa)"
        },
        layout = "dwindle"
    },
    decoration = {
        rounding = 8,
        blur = {
            enabled = false
        }
    }
})

local MOD = "SUPER"
hl.bind({ mods = { MOD }, key = "Return", action = hl.dsp.exec("kitty") })
hl.bind({ mods = { MOD }, key = "q", action = hl.dsp.killactive() })
hl.bind({ mods = { MOD, "SHIFT" }, key = "m", action = hl.dsp.exit() })
hl.bind({ mods = { MOD }, key = "space", action = hl.dsp.exec("fuzzel") })

for i = 1, 9 do
    hl.bind({ mods = { MOD }, key = tostring(i), action = hl.dsp.workspace(tostring(i)) })
    hl.bind({ mods = { MOD, "SHIFT" }, key = tostring(i), action = hl.dsp.movetoworkspace(tostring(i)) })
end
