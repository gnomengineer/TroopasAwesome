--@TODO clients aren't resizeable and moveable
--@TODO rightclick context menu to close a window/client
--@TODO run application which are started in terminal (i.e. irssi)
--@TODO make certain changes causing by updating from 3.4 to 3.5
-- {{ libraries
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- theme library
local beautiful = require("beautiful")
-- extra libraries
local naughty = require("naughty")
local vicious = require("vicious")
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
		 layout = {layouts[3],layouts[1],layouts[3],layouts[1],layouts[3]}
	   }
for s = 1, screen.count() do
    tags[s]  = awful.tag(tags.name, s, tags.layout)
end
-- }}

-- {{ widgets
-- { separator
--separator = wibox.widget.imagebox()--widget({ type = "imagebox" })
--separator.image = image(beautiful.separator) --need a new symbol in the theme
-- }

-- { textclock
clock = awful.widget.textclock()
-- }

-- { systray
systray = wibox.widget.systray()--widget({ type = "systray" })
-- }

---- { cpu usage and temperature
--cpuicon = wibox.widget.imagebox() --widget({ type = "imagebox" })
--cpuicon.image = image(beautiful.cpu) 
---- initialize
--cpu = wibox.widget.textbox()--widget({ type = "textbox" })
--temperature = wibox.widget.textbox()--widget({ type = "textbox" })
---- register
--vicious.register(cpu, vicious.widgets.cpu, "$1%")
--vicious.register(temperature, vicious.widgets.thermal, "$1C ", 42, {"atk0110", "core"})
---- }

---- { memory usage
--memicon = wibox.widget.imagebox() --widget({ type = "imagebox" })
--memicon.image = image(beautiful.memory) 
---- initialize
--memory = wibox.widget.textbox()--widget({ type = "textbox" })
---- register
--vicious.register(memory, vicious.widgets.mem, "$1%", 13)
---- }

---- { upload/download rate
--downicon = wibox.widget.imagebox() --widget({ type = "imagebox" })
--upicon = wibox.widget.imagebox() --widget({ type = "imagebox" })
--downicon.image = image(beautiful.download)
--upicon.image = image(beautiful.upload)
---- initialize
--netwidget = wibox.widget.textbox()--widget({ type = "imagebox" })
---- register
--vicious.register(netwidget, vicious.widgets.net, '<span color="' .. beautiful.foreground_color .. '">${eth0 down_kb} | </span><span color="'
-- .. beautiful.foreground_color .. '">${eth0 up_kb}</span>', 3)
---- }

-- { launcher for power off etc
awesomemenu = {
	{ "restart", awesome.restart},
	{ "quit", awesome.quit}
}

powermenu = awful.menu({ items = {	{ "power off", "shutdown -h now" },
									{ "reboot", "shutdown -r now" },
									{ "terminal", terminal},
									{ "awesome", awesomemenu }
								 }
					   })
powerlauncher = awful.widget.launcher({ image = beautiful.powerlauncher,
										menu = powermenu })
-- }

-- { menu launcher 
-- menu for all programs which are not categorized
syssubmenu = {
	{ "GEdit", "gedit" },
	{ "Sound", "pavucontrolu" },
	{ "Eclipse", "eclipse" }
}
-- menu for internet applications
netsubmenu = {
	{ "Browser", "chromium" },
	{ "E-Mail", "thunderbird" },
	{ "Torrent", "transmission-qt" }
}
-- menu for applications with them i can chat/talk to another people
chatsubmenu = {
	{ "Skype", "skype" },
	{ "IRC", terminal .. " -e irssi" },
	{ "Teamspeak", "teamspeak3" }
}
-- menu for ALL applications from multimedia (video,audio,image)
mediasubmenu = {
	{ "MPlayer", "smplayer"},
	{ "GIMP", "gimp" },
	{ "Cinelerra", "cinelerra" },
	{ "Audacity", "audacity" },
	{ "Pencil", "pencil" }
}
mainmenu = awful.menu({ items = { { "system", syssubmenu },
								  { "internet", netsubmenu },
								  { "chats", chatsubmenu },
								  { "multimedia", mediasubmenu }
								}
					 })

menulauncher = awful.widget.launcher({ image = beautiful.menulauncher,
									   menu = mainmenu
									})

-- }

--{ context menu, rightclick on the tasklist
--contextmenu = awful.menu({ items = { { "close", function (c) c:kill() end }
--								   }
--						})
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
	tasklist = {}
	tasklist.buttons = awful.util.table.join(
                awful.button({ }, 1, function (c)
		    if c == client.focus then
		       c.minimized = true
		    else
		        if not c:isvisible() then
		            awful.tag.viewonly(c:tags()[1])
		        end
		        -- This will also un-minimize
		        -- the client, if needed
		        client.focus = c
		        c:raise()
		    end
		end),
				awful.button({}, 3, function (c) contextmenu:toggle() end)
	)
	layoutbox = {}
	-- promptbox
	promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
	-- taglist
	taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons )
	-- tasklist
	tasklist[s] = awful.widget.tasklist( function(c) return awful.widget.tasklist.label.currenttags(c, s) end, tasklist.buttons)
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
		tasklist[s],
		layout = awful.widget.layout.horizontal.rightleft
	}
end
-- }}

-- {{ mouse bindings
root.buttons(awful.util.table.join(
	awful.button({}, 3, function () powermenu:hide(); mainmenu:toggle() end),
	awful.button({ superkey }, 3, function () mainmenu:hide(); powermenu:toggle() end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
-- }}

-- {{ key bindings
-- normal key bindings
keybindings = awful.util.table.join(
    -- some routine function
    awful.key({ superkey, }, "t", function () awful.util.spawn(terminal) end),
    awful.key({ superkey, }, "w", function () mainmenu:show({ keygrabber = true }) end),
    --awful.key({ superkey }, "l", function () slim.lock end)
    awful.key({ superkey, }, "p", function () powermenu:show({ keygrabber = true }) end),
    --awful.key({ superkey, }, "e", terminal .. "-e ranger"),--function () awful.util.spawn("ranger") end),
    awful.key({ superkey, }, "r", function () awful.prompt.run({ prompt = "Run in terminal: " },
												mypromptbox[mouse.screen].widget,
												function (...) awful.util.spawn(terminal .. " -e " .. ...) end,
												awful.completion.shell,
												awful.util.getdir("cache") .. "/history")
								  end),
	awful.key({}, "Pause", terminal .. " -e screen"),

	awful.key({ superkey, "Control" }, "s", function () awful.util.spawn("skype") end),
    awful.key({ superkey ,"Control" }, "t", function () awful.util.spawn("mumble") end),
    awful.key({ superkey ,"Control" }, "c", function () awful.util.spawn("irssi") end),
    awful.key({ superkey , "Control" }, "b", function () awful.util.spawn("chromium") end),
    awful.key({ superkey , "Control" }, "m", function () awful.util.spawn("thunderbird") end)
)

clientkeys = awful.util.table.join(
	awful.key({ superkey , "Shift" }, "c", function (c) c:kill() end),
	awful.key({ superkey , "Shift" }, "r", function (c) c:redraw() end)
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
    awful.button({ superkey }, 1, awful.mouse.client.move),
    awful.button({ superkey }, 3, awful.mouse.client.resize)
)
-- set all keybindings
root.keys(keybindings)
-- }}

-- {{ rules
--awful.rules.rules = {
--	{ rule = { },
--	  properties = { border_width = beautiful.border_width,
--					 border_color = beuatiful.border_normal,
--					 focus = true,
--					 keys = clientkeys,
--					 buttons = mousebuttons } }
--}
-- }}

-- {{ signals
client.add_signal("manage", function (c, startup)
	c:add_signal("mouse::enter", function (c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magifier and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)
	
	if not startup then
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
end)
client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}
