-- {{{ Libraries
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- }}}

-- initialisize of the awesome theme
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")

-- {{{ Variable declaration
local terminal = "gnome-terminal"
local browser = "chromium"
local fmhome = "pcmanfm"
local editor = os.getenv("EDITOR") or "vim"
local editor_cmd = terminal .. " -e " .. editor
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell
-- Default modkey. Mod4 
local modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,             -- 1
    awful.layout.suit.floating,         -- 2
    awful.layout.suit.max.fullscreen    -- 3
}
-- }}}

-- {{{ Tag definition
tags = {
    names = {"devel","irssi","inet","game","convi"},
    layout = {layouts[1],layouts[1],layouts[2],layouts[2],layouts[1]}
}
tags[0] = awful.tag(tags.names, s, tags.layout)
-- }}}

-- {{{ Menu launcher 
-- Main Menu with basic commands
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "home", fmhome },
   { "edit config","sudo " .. editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}
-- Menu for multimedia (video, music, recording)
multimediamenu = {
   { "VirtualDJ", terminal .. "mocp"},
   { "Openshot", "openshot"},
   { "VLC", "vlc"},
   { "Audacity", "audacity"},
   { "RecordmyDesktop", "recordmydesktop"}
}
-- menu where all my games are placed
gamemenu = {
   { "Skyrim", "gedit"},
   { "Guild Wars 2", "gedit"},
   { "Teeworlds", "gedit"}
}
-- menu for all internet applications
internetmenu = {
   { "Browser", browser},
   { "Thunderbird", "thunderbird"},
   { "IRC", "irssi"},
   { "Skype", "skype"},
   { "TS3", "teamspeak"}
}
-- menu for design
graphicalmenu = {
   { "Gimp", "gimp"},
   { "Inkscape",  "inkscape"}
}
-- order all submenu into a supermenu wich were placed into the launcher
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "multimedia", multimediamenu },
				                    { "games", gamemenu },
				                    { "internet", internetmenu },
				                    { "graphics", graphicalmenu },
				                    { "open terminal", terminal }
                                  }
                        })
mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Widgets
mysystray = widget({ type = "systray" })

mytextclock = awful.widget.textclock({ align = "right" })

mytaglist = {}
mytaglist[0] = awful.widget.taglist(0, awful.widget.taglist.label.all, mytaglist.buttons)
-- }}}
-- {{{ Wibox

mywibox = {}
mywibox[0] = awful.wibox({ position = "top", screen = s })
mywibox[0].widgets = {
    {
        mylauncher,
        mytaglist[0]
    },
    mytextclock,
    mysystray,
    layout = awful.widget.layout.horizontal.rightleft
}
-- {{{ Key Bindings

