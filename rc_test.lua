--@TODO clients aren't resizeable and moveable
--@TODO rightclick context menu to close a window/client
--@TODO run application which are started in terminal (i.e. irssi)
--@TODO make certain changes causing by updating from 3.4 to 3.5
-- {{ libraries
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget handling library
local wibox = require("wibox")
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

-- {{ Menu
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
	{ "Sound", "pavucontrol" },
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

-- {{ widgets
-- create textclock widget
w_textclock = awful.widget.textclock()

-- initialize a wibox for each screen
w_wibox = {}
w_promptbox = {}
-- box that contains icons to change the layout
w_layoutbox = {}
-- element in the wibox that contains the tag numbers (1,2,3,...)
w_taglist = {}
-- and its functionality
w_taglist.buttons = awful.util.table.join(
						-- create button with --> awful.button({special key }, key, function)
						awful.button({ }, 1, awful.tag.viewonly),
						awful.button({ }, 3, awful.tag.viewtoggle),
						awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
						awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
					)

-- element that contains the opened programs
w_tasklist = {}
w_tasklist.buttons = awful.util.table.join(
						awful.button({ }, 1, function(c)
							if c == client.focus then
								c.minimized = true
							else
								c.minimized = false
								if not c:isvisible() then
									awful.tag.viewonly(c:tags()[1])
								end
								client.focus = c
								c:raise()
							end
						end),
						awful.button({ }, 3, function ()
							if instance then
								instance:hide()
								instance = nil
							else
								instance = awful.menu.clients({ width=250 })
							end
						end),
						awful.button({ }, 4, function ()
							awful.client.focus.byidx(1)
							if client.focus then client.focus:raise() end
						end),
						awful.button({ }, 5, function ()
							awful.client.focus.byidx(-1)
							if client.focus then client.focus:raise() end
						end)					
					) 

-- add everything  to the wibox and the wibox to the screen
for s = 1, screen.count() do
	w_layoutbox[s] = awful.widget.layoutbox(s)
	w_layoutbox[s]:buttons(awful.util.table.join(
								awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
								awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
								awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
								awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
							)
	)
	-- creates the taglist widget
	w_taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, w_taglist.buttons)

	-- creates the tasklist widget
	w_tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, w_tasklist.buttons)

	-- adds the wibox to the screen in position top
	w_wibox[s] = awful.wibox({ position = "top", screen = s })

	-- variable for leftside content of wibox
	local leftside = wibox.layout.fixed.horizontal()
	leftside:add(menulauncher)
	leftside:add(powerlauncher)
	leftside:add(w_taglist[s])
	--leftside:add()--prompt box?

	-- variable for rightside content of wibox
	local rightside = wibox.layout.fixed.horizontal()
	if s == 1 then rightside:add(wibox.widget.systray()) end --systray
	rightside:add(w_textclock)--clock
	rightside:add(w_layoutbox[s])

	-- adding left, middle and rightside to wibox	
	local layout = wibox.layout.align.horizontal()
	layout:set_left(leftside)
	layout:set_middle(w_tasklist[s])
	layout:set_right(rightside)

	w_wibox[s]:set_widget(layout)
end


-- { separator
--separator = wibox.widget.imagebox()--widget({ type = "imagebox" })
--separator.image = image(beautiful.separator) --need a new symbol in the theme
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

--{{ mouse bindings
root.buttons(awful.util.table.join(
	awful.button({}, 3, function () powermenu:toggle() end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
--}}
