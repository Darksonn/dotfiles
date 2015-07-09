-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- local vicious = require("vicious")


-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
  title = "Oops, there were errors during startup!",
  text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, an error happened!",
    text = err })
    in_error = false
  end)
end

--TODO theming
beautiful.init("/home/user/dotfiles/awesome/theme.lua")
beautiful.useless_gap = 6

if beautiful.wallpaper then
  for s = 1, screen.count() do
    if s == 1 then
      gears.wallpaper.maximized("/home/user/bg1.png", s, true)
    end
    if s == 2 then
      gears.wallpaper.maximized("/home/user/bg2.png", s, true)
    end
    if s > 2 then
      gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
  end
end

modkey = "Mod4"


--TODO wallpaper



--- widgets

-- keyboard layout selection
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = {
  {"us", "altgr-intl", "us"},
  {"dk", "", "dk"}
}
kbdcfg.current = 1  -- us is our default layout
kbdcfg.widget = wibox.widget.textbox()
kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current][3] .. " ")
kbdcfg.switch = function ()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = kbdcfg.layout[kbdcfg.current]
  kbdcfg.widget:set_text(" " .. t[3] .. " ")
  os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
end
kbdcfg.widget:buttons(
awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))
)
kbdcfg.widget:buttons(
awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))
)

-- clock
clock = awful.widget.textclock()

---- cpu monitor
--cpuwidget = awful.widget.graph()
--cpuwidget:set_width(50)
--cpuwidget:set_background_color("#494B4F")
--cpuwidget:set_color("#FF5656")
--cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
--vicious.register(cpuwidget, vicious.widgets.cpu, "$1")
--
---- memory monitor
--memwidget = awful.widget.progressbar()
--memwidget:set_width(8)
--memwidget:set_height(10)
--memwidget:set_vertical(true)
--memwidget:set_background_color("#494B4F")
--memwidget:set_border_color(nil)
--memwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0,10 }, stops = { {0, "#AECF96"}, {0.5, "#88A175"}, 
--{1, "#3300CC"}}})
--vicious.register(memwidget, vicious.widgets.mem, "$1", 13)

tags = {}

tasklist = {}
tasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
  if c == client.focus then
    c.minimized = true
  else
    -- Without this, the following
    -- :isvisible() makes no sense
    c.minimized = false
    if not c:isvisible() then
      awful.tag.viewonly(c:tags()[1])
    end
    -- This will also un-minimize
    -- the client, if needed
    client.focus = c
    c:raise()
  end
end)
)

local layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
}

promptbox = {}
layoutbox = {}
taglist = {}
taglist.buttons = awful.util.table.join(
awful.button({ }, 1, awful.tag.viewonly),
awful.button({ modkey }, 1, awful.client.movetotag),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, awful.client.toggletag)
)

swibox = {}
for s = 1, screen.count() do
  promptbox[s] = awful.widget.prompt()
  layoutbox[s] = awful.widget.layoutbox(s)
  layoutbox[s]:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end)
  ))
  tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
  taglist[s] = awful.widget.taglist(s,
  awful.widget.taglist.filter.all,
  taglist.buttons
  )
  tasklist[s] = awful.widget.tasklist(s,
  awful.widget.tasklist.filter.currenttags,
  tasklist.buttons
  )
  swibox[s] = awful.wibox({ position = "top", screen = s })

  -- Widgets that are aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(taglist[s])
  left_layout:add(promptbox[s])

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  if s == 1 then
    right_layout:add(wibox.widget.systray())
  end
  right_layout:add(clock)
  right_layout:add(kbdcfg.widget)
  right_layout:add(layoutbox[s])

  -- Now bring it all together (with the tasklist in the middle)
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(tasklist[s])
  layout:set_right(right_layout)

  swibox[s]:set_widget(layout)

end

globalkeys = awful.util.table.join(
awful.key({modkey}, "d", function ()
  awful.client.focus.byidx(1)
  if client.focus then client.focus:raise() end
end),
awful.key({modkey, "Shift"}, "d", function ()
  awful.client.focus.byidx(-1)
  if client.focus then client.focus:raise() end
end),
awful.key({modkey}, "s", function ()
  awful.client.swap.byidx(1)
end),
awful.key({modkey, "Shift"}, "s", function ()
  awful.client.swap.byidx(-1)
end),
awful.key({modkey}, "Return", function () awful.util.spawn("terminator") end),
awful.key({modkey, "Shift", "Control"}, "r", awesome.restart),
awful.key({modkey, "Shift", "Control"}, "q", awesome.quit),
awful.key({modkey}, "a", function ()
  awful.tag.incmwfact(0.05)
end),
awful.key({modkey, "Shift"}, "a", function ()
  awful.tag.incmwfact(-0.05)
end),
awful.key({modkey}, "space", function ()
  awful.layout.inc(layouts,  1)
end),
awful.key({modkey, "Shift"}, "space", function ()
  awful.layout.inc(layouts, -1)
end),
awful.key({modkey}, "r", function ()
  promptbox[mouse.screen]:run()
end),
awful.key({modkey}, "q", function ()
  awful.util.spawn("firefox -new-window")
end),
--	awful.key({modkey}, "k", function ()
--		awful.util.spawn("terminator --working-directory=/opt/romaji_to_kana -e './run'")
--	end),
awful.key({modkey}, "x", function ()
  awful.prompt.run({prompt = "Run Lua code: "},
  promptbox[mouse.screen].widget,
  awful.util.eval, nil,
  awful.util.getdir("cache") .. "/history_eval")
end)
)
clientkeys = awful.util.table.join(
awful.key({modkey}, "f", function (c)
  c.fullscreen = not c.fullscreen
end),
awful.key({modkey, "Shift"}, "c", function (c)
  c:kill()
end),
awful.key({modkey, "Control"}, "space", awful.client.floating.toggle),
awful.key({modkey}, "o", awful.client.movetoscreen)
)

for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
  awful.key({modkey}, "#" .. i + 9, function ()
    local screen = mouse.screen
    local tag = awful.tag.gettags(screen)[i]
    if tag then
      awful.tag.viewonly(tag)
    end
  end),
  awful.key({modkey, "Control"}, "#" .. i + 9, function ()
    local screen = mouse.screen
    local tag = awful.tag.gettags(screen)[i]
    if tag then
      awful.tag.viewtoggle(tag)
    end
  end),
  awful.key({modkey, "Shift"}, "#" .. i + 9, function ()
    if client.focus then
      local tag = awful.tag.gettags(client.focus.screen)[i]
      if tag then
        awful.client.movetotag(tag)
      end
    end
  end),
  awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function ()
    if client.focus then
      local tag = awful.tag.gettags(client.focus.screen)[i]
      if tag then
        awful.client.toggletag(tag)
      end
    end
  end)
  )
end
clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize)
)
root.keys(globalkeys)


awful.rules.rules = {
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons
    }
  },
  {
    rule = {
      class = "MPlayer"
    },
    properties = {
      floating = true
    }
  },
  {
    rule = {
      class = "pinentry"
    },
    properties = {
      floating = true
    }
  },
  {
    rule = {
      class = "gimp"
    },
    properties = {
      floating = true
    }
  }
}

client.connect_signal("manage", function (c, startup)
  -- Enable sloppy focus
  c:connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end

  local titlebars_enabled = false
  if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
    awful.button({ }, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
    )

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(awful.titlebar.widget.iconwidget(c))
    left_layout:buttons(buttons)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(awful.titlebar.widget.floatingbutton(c))
    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    right_layout:add(awful.titlebar.widget.stickybutton(c))
    right_layout:add(awful.titlebar.widget.ontopbutton(c))
    right_layout:add(awful.titlebar.widget.closebutton(c))

    -- The title goes in the middle
    local middle_layout = wibox.layout.flex.horizontal()
    local title = awful.titlebar.widget.titlewidget(c)
    title:set_align("center")
    middle_layout:add(title)
    middle_layout:buttons(buttons)

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(middle_layout)

    awful.titlebar(c):set_widget(layout)
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

--local tee = awesome.ipc_start("tee", {"/home/user/output"})
--
--local stdin = tee:stdin()
--stdin:write("test")
--stdin:close()

