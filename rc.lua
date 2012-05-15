-- {{ libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
-- theme library
require("beautiful")
-- extra libraries
require("vicious")
-- }}

-- {{ variable definitions
local altkey = "Mod1"
local superkey = "Mod4"

local home = os.getenv("HOME")
-- theme
beautiful.init("/usr/share/awesome/themes/default/theme.lua")

-- layouts
layouts = {
    awful.layout.suit.tile,         -- 1
    awful.layout.suit.tile.bottom,  -- 2
    awful.layout.suit.max,          -- 3
    awful.layout.suit.floating      -- 4
}
-- }}

-- {{ tags
tags = {}
for s = 1, screen.count() do
    tags[s]  = awful.tag({1, 2, 3, 4, 5}, s, layouts[1])
end
-- }}

-- {{ widgets
-- { separator
separator = widget({ type = "imagebox" })
--separator.image = image(beautiful.separator) --need a new symbol in the theme
-- }

-- { textclock
clock = awful.widget.textclock({ align = "right" })
-- }

-- { systray
systray = widget({ type = "systray" })
-- }

-- { cpu usage and temperature
cpuicon = widget({ type = "imagebox" })
--cpuicon.image = image(beautiful.cpu) --need a new symbol in the theme
-- initialize
cpugraph = awful.widget.graph()
tempearture = widget({ type = "textbox" })
-- graph properties
cpugraph:set_width(40):set_height(15)
cpugraph:set_background_color(beautiful.gbgcolor) --color have to be defined in the theme
cpugraph:set_gradient_angle(0):set_gradient_colors(beautiful.gfgcolor)
-- register
vicious.register(cpugraph, vicious.widgets.cpu, "$1")
vicious.register(temperature, vicious.widgets.thermal, "$1", 42, "thermal_zone0")
-- }

-- { memory usage
memicon = widget({ type = "imagebox" })
--memicon.image = image(beautiful.memory) --need a new symbol in the theme
-- initialize
memory
-- { upload/download rate
-- { launcher for power off etc
-- { menu launcher 


-- }}

-- {{ wibox
for s = 1, screen.count() do
	
