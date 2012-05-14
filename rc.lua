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

-- }}

-- {{ wibox

