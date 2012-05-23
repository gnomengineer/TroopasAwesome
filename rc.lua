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
local control = "Control_L"

local home = os.getenv("HOME")
local terminal = "lxterminal"
-- theme
beautiful.init("/usr/share/awesome/themes/igotblues/theme.lua")

-- layouts
layouts = {
    awful.layout.suit.tile,         -- 1
    awful.layout.suit.tile.bottom,  -- 2
    awful.layout.suit.max,          -- 3
    awful.layout.suit.floating      -- 4
}
-- }}

-- {{ tags
tags = { name = {"games", "system", "internet", "chat", "vai"},
		 layout = {layouts[3],layouts[1],layouts[3],layouts[1],layouts[4]}
	   }
for s = 1, screen.count() do
    tags[s]  = awful.tag(tags.name, s, tags.layout)
end
-- }}

-- {{ widgets
-- { separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.separator) --need a new symbol in the theme
-- }

-- { textclock
clock = awful.widget.textclock({ align = "right" })
-- }

-- { systray
systray = widget({ type = "systray" })
-- }

-- { cpu usage and temperature
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.cpu) --need a new symbol in the theme
-- initialize
cpu = widget({ type = "textbox" })
temperature = widget({ type = "textbox" })
-- register
vicious.register(cpu, vicious.widgets.cpu, "$1%")
vicious.register(temperature, vicious.widgets.thermal, "$1", 42, "thermal_zone0")
-- }

-- { memory usage
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.memory) --need a new symbol in the theme
-- initialize
memory = awful.widget.progressbar()
-- progressbar properties
memory:set_vertical(true)
memory:set_ticks(true)
memory:set_ticks_size(2)
memory:set_height(15)
memory:set_width(14)
memory:set_border_color(nil)
memory:set_background_color(beautiful.background_color)
memory:set_color(beautiful.foreground_color)
-- register
vicious.register(memory, vicious.widgets.mem, "$1", 13)
-- }

-- { upload/download rate
downicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
downicon.image = image(beautiful.download)
upicon.image = image(beautiful.upload)
-- initialize
netwidget = widget({ type = "textbox" })
-- register
vicious.register(netwidget, vicious.widgets.net, '<span color="' .. beautiful.foreground_color .. '">${eth0 down_kb}</span><span color="'
 .. beautiful.foreground_color .. '">${eth0 up_kb}</span>', 3)
-- }

-- { launcher for power off etc
awesomemenu = {
	{ "restart", awesome.restart},
	{ "quit", awesome.quit}
}

powermenu = awful.menu({ items = {	{ "power off", "gedit" },
									{ "logout", "gedit"},
									{ "awesome", awesomemenu }
								 }
					   })
powerlauncher = awful.widget.launcher({ image = image(beautiful.powerlauncher),
										menu = powermenu })
-- }

-- { menu launcher 
-- menu for my games
gamesubmenu = {
	{ "GuildWars2", "wine ~/Games/GuildWars2/Gw2.exe" },
	{ "Teeworlds", "teeworlds" },
	{ "Spiral Knights", "." .. home .. "/Games/spiral/spiral" }
}
-- menu for all programs which are not categorized
syssubmenu = {
	{ "GEdit", "gedit" },
	{ "VirtualBox", "virtualbox" },
	{ "Sound", "pavucontrol" },
	{ "FileManager", "pcmanfm" }
}
-- menu for internet applications
netsubmenu = {
	{ "Browser", "chromium" },
	{ "E-Mail", "thunderbird" },
	{ "Deluge", "deluge" }
}
-- menu for applications with them i can chat/talk to another people
chatsubmenu = {
	{ "Skype", "skype" },
	{ "IRC", "irssi" }, --this is only a call without any properties
	{ "Teamspeak3", "teamspeak3" } 
}
-- menu for ALL applications from multimedia (video,audio,image)
mediasubmenu = {
	{ "VLC", "vlc" },
	{ "Musicplayer", "gnome-terminal mocp" },
	{ "Openshot", "openshot" },
	{ "Audacity", "audacity" },
	{ "Recorder", "recordmydesktop" }, --this is only a call without any properties
	{ "GIMP", "gimp" }
}
mainmenu = awful.menu({ items = { { "games", gamesubmenu },
								  { "system", syssubmenu },
								  { "internet", netsubmenu },
								  { "chats", chatsubmenu },
								  { "multimedia", mediasubmenu }
								}
					 })

menulauncher = awful.widget.launcher({ image = image(beautiful.menulauncher),
									   menu = mainmenu
									})
-- }
-- }}

-- {{ wibox
for s = 1, screen.count() do
	-- { promptbox, taglist and layoutbox
	promptbox = {}
	taglist = {}
	taglist.buttons = awful.util.table.join(
		awful.button({}, 1, awful.tag.viewonly),
		awful.button({superkey}, 1, awful.client.movetotag),
		awful.button({}, 3, awful.tag.viewtoggle),
		awful.button({superkey}, 3, awful.client.toggletag),
		awful.button({}, 4, awful.tag.viewnext),
		awful.button({}, 5, awful.tag.viewprev)
	)	
	layoutbox = {}
	-- promptbox
	promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
	-- taglist
	taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons )
	-- layoutbox
	layoutbox[s] = awful.widget.layoutbox(s)
	layoutbox[s]:buttons(awful.util.table.join(
		awful.button({}, 1, function () awful.layout.inc(layouts, 1) end),
		awful.button({}, 3, function () awful.layout.inc(layouts, -1) end),
		awful.button({}, 4, function () awful.layout.inc(layouts, 1) end),
		awful.button({}, 5, function () awful.layout.inc(layouts, -1) end)
	))
	-- }
	-- { wibox
	wii = {}
	wii[s] = awful.wibox({ position = "top", screen = s })
	wii[s].widgets = {
		{
		menulauncher,
		powerlauncher,
		taglist[s],
		promptbox[s],
		layout = awful.widget.layout.horizontal.leftright
		},
		layoutbox[s],
		clock, systray, separator,
		upicon, netwidget, downicon, separator,
		memory, memicon, separator,
		cpu, temperature, cpuicon, separator,
		layout = awful.widget.layout.horizontal.rightleft
	}
end
-- }}

-- {{ mouse bindings
root.buttons(awful.util.table.join(
	awful.button({}, 3, function () menulauncher:toggle() end),
	awful.button({ superkey}, 3, function () powerlauncher:toggle() end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
-- }}

-- {{ key bindings
-- normal key bindings
keybindings = awful.util.table.join(
    -- some routine function
    awful.key({ superkey }, "t", function () awful.util.spawn(terminal) end),
    awful.key({ superkey }, "w", function () menulauncher:show({ keygrabber=true }) end),
    awful.key({ superkey }, "l", function () slim.lock end)
    awful.key({ superkey }, "p", function () powerlauncher:show({ keygrabber=true }) end),
    awful.key({ superkey }, "e", function () awful.util.spawn("pcmanfm") end),
    awful.key({ superkey }, "r", function () awful.util.spawn("executer") end),

    -- start programs
    awful.key({ control }, "s", function () awful.util.spawn("skype") end),
    awful.key({ control }, "t", function () awful.util.spawn("teamspeak3") end),
    awful.key({ control }, "c", function () awful.util.spawn("irssi") end),
    awful.key({ control }, "w", function () awful.util.spawn("chromium") end),
    awful.key({ control }, "m", function () awful.util.spawn("thunderbird") end),
    awful.key({ control }, "r", function () awful.util.spawn("gtk-recordmydesktop") end)
)

-- switch tags with number
keynumber = 0
for s = 1, screen.count() do
    keynumber = math.min(9, math.max(#tags[s], keynumber));
end
-- bind keynumber to tag
for i = 1, keynumber do
    keybindings = awful.util.table.join( keybindings,
        awful.key({ superkey }, "#" .. i + 9,
            function () 
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end
        )
    )
end
-- window resize/move with mouse
mousebuttons = awful.util.table.join(
    awful.button({ superkey }, 1, awful.client.mouse.move),
    awful.button({ superkey }, 3, awful.client.mouse.resize)
)
-- set all keybindings
root.keys(keybindings)
-- }}
