-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.mouse.finder = require("awful.mouse.finder")
awful.client = require("awful.client")
awful.rules = require("awful.rules")
awful.util = require("awful.util")
awful.widget.common = require("awful.widget.common")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local keydoc  = require("keydoc")
local mbarfix = require("mbarfix")
local posix   = require("posix")
local tags_titlebar = require("tags_titlebar")

-- {{{ Error handling
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
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/shadowkyogre/.config/awesome/themes/sk/theme.lua")
--- Need clear for the standard icons since awesome is a bit stupid
theme.icon_theme = "AwOken-220214194/clear"

naughty.config.icon_formats = {"png", "gif", "xpm"}
naughty.config.icon_size = 80
tmp_table_dirs = mbarfix.lookup_dirs({
    os.getenv('HOME') .. '/.icons/' .. theme.icon_theme .. '/',
    '/usr/share/icons/hicolor'})
table.insert(tmp_table_dirs, "/usr/share/icons/")
table.insert(tmp_table_dirs, "/usr/share/pixmaps/")
naughty.config.icon_dirs = tmp_table_dirs

mymousefinder = awful.mouse.finder()

-- This is used later as the default terminal and editor to run.
terminal = "termite"
terminal_exe_flag = "-e"
preferred_shell = "/usr/bin/fish -i"
editor = os.getenv("EDITOR") or "nano"
minibrowser_cmd = "qutebrowser"

function launch_term_editor(fname)
    posix.popen({terminal, terminal_exe_flag, editor .. " " .. fname}, 'r')
end

function launch_term_with_shell()
    posix.popen({terminal, terminal_exe_flag, preferred_shell}, 'r')
end

function launch_minibrowser(url)
    posix.popen({minibrowser_cmd, "-s", "tabs", "position", "top", url}, 'r')
end

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

local default_layout = layouts[1]
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {
        -- Astrology
        awful.tag.add('♅', {
            screen = s,
            tooltip = "Astrology",
            wallpaper = gears.surface.load_uncached("/home/shadowkyogre/Pictures/WallPaper/kill_la_kill___matoi_ryuko_by_kirukatocchi-darkened-d7b0n3g.png") }),
        -- Internet
        awful.tag.add('⛓', {
            screen = s,
            tooltip = "Internet",
            wallpaper = gears.surface.load_uncached("/home/shadowkyogre/Pictures/WallPaper/lelouch_-_custom_wallpaper.png") }),
        -- Art
        awful.tag.add('⛧', {
            screen = s,
            tooltip = "Art",
            wallpaper = gears.surface.load_uncached("/home/shadowkyogre/Pictures/WallPaper/merric-wallpaper-minimal.png") }),
        -- Games
        awful.tag.add('♛', {
            screen = s,
            tooltip = "Games",
            wallpaper = gears.surface.load_uncached("/home/shadowkyogre/Pictures/WallPaper/sample_f6cac1a1c6ff90f0b8f2952eb405f8448649eca6.jpg") }),
        -- Development
        awful.tag.add('⚡', {
            screen = s,
            tooltip = "Development",
            wallpaper = gears.surface.load_uncached("/home/shadowkyogre/Pictures/WallPaper/pacgraph.png") }),
        -- Books
        awful.tag.add('☬', {
            screen = s,
            tooltip = "Books",
            wallpaper = gears.surface.load_uncached("/home/shadowkyogre/Pictures/WallPaper/pokemon__horizon_by_reaper_bunny-d55wyw0.jpg") }),
        -- References
        awful.tag.add('⛏', {
            screen = s,
            tooltip = "References",
            wallpaper = gears.surface.load_uncached("/home/shadowkyogre/Pictures/WallPaper/thepaperwall_-_just_after_sunset.jpg") }),
        -- Rituals
        awful.tag.add('⚖', {
            screen = s,
            tooltip = "Rituals",
            wallpaper = gears.surface.load_uncached("/home/shadowkyogre/Pictures/WallPaper/one_of_my_favorite_quotes_by_vovina_de_micaloz-d77xbkl.png") }),
        -- Writing
        awful.tag.add('✒', {
            screen = s,
            tooltip = "Writing",
            wallpaper = gears.surface.load_uncached("/home/shadowkyogre/Pictures/WallPaper/glowingSnakePurpleBlue.jpg") }),
    }

end
-- }}}

-- {{{ Wallpaper
function set_wallpaper_for_tag(scr)
    local tag = awful.tag.selected(scr)
    local tagwall = awful.tag.getproperty(tag, 'wallpaper')
    if tagwall then
        gears.wallpaper.maximized(tagwall, scr)
    elseif beautiful.wallpaper then
        gears.wallpaper.maximized(beautiful.wallpaper, scr, true)
    end
end

if beautiful.wallpaper then
    for s = 1, screen.count() do
        set_wallpaper_for_tag(scr)
        screen[s]:connect_signal("tag::history::update", function()
            for scr = 1, screen.count() do
                set_wallpaper_for_tag(scr)
            end
        end)
    end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", function()
                   posix.popen({terminal, terminal_exe_flag, "man awesome"})
               end    },
   { "edit config", function()
                   launch_term_editor(awesome.conffile)
               end    },

   { "open docs", function()
                      launch_minibrowser("/usr/share/doc/awesome/doc/index.html")
               end}, 

   { "UTF8 symbols", function()
                       launch_minibrowser("http://unicode-table.com/")
                    end},
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal",
                                    launch_term_with_shell }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = '/home/shadowkyogre/Pictures/WallPaper/archse.png',
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock("<b>%Y-%m-%d</b> %H:%M:%S", 1)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
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
                                          end),
                     awful.button({ }, 3, function (c)
                                              hide_client_actions()
                                              client_actions = create_client_actions_menu(c)
                                              client_actions:show()
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

function tag_tooltips(w, buttons, label, data, tags)
    w:reset()
    for i, o in ipairs(tags) do
        local cache = data[o]
        local bgb, tb, m, tt
        if cache then
            bgb = cache.bgb
            tb = cache.tb
            m = cache.m
            tt = cache.tt
        else
            bgb = wibox.widget.background()
            tb = wibox.widget.textbox()
            m = wibox.layout.margin(tb, 4, 4)
            tt = awful.tooltip({objects = {bgb}, })
            tt:set_markup(awful.tag.getproperty(o, 'tooltip'))

            bgb:set_widget(m)
            bgb:buttons(awful.widget.common.create_buttons(buttons, o))

            data[o] = {
                bgb = bgb,
                tb = tb,
                m = m,
                tt = tt,
            }
        end

        local text, bg, bg_image, icon = label(o)
        tb:set_markup(text)
        tt.wibox:set_bg(bg)
        bgb:set_bg(bg)
        bgb:set_bgimage(bg_image)

        w:add(bgb)
    end
end

unknown_task_icon = mbarfix.lookup_icon('gnome-unknown')
function icons_only_update(w, buttons, label, data, objects)
    w:reset()
    local l = wibox.layout.fixed.horizontal()
    if tmpmenu then
        tmpmenu:hide()
        tmpmenu = nil
    end
    tmpmenu = awful.menu.clients({ theme = { width = 250 } })
    tmpmenu:hide()
    local all_clients = awful.widget.launcher({ image = mbarfix.lookup_icon('gnome-panel-window-list'), menu = tmpmenu, })
    local all_clients_tt = awful.tooltip({objects = {all_clients}})
    all_clients_tt:set_text("List all clients")
    l:add(all_clients)

    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, bgb, tt
        if cache then
            ib = cache.ib
            bgb = cache.bgb
            tt = cache.tt
        else
            ib = wibox.widget.imagebox()
            bgb = wibox.widget.background()
            bgb:buttons(awful.widget.common.create_buttons(buttons, o))
            tt = awful.tooltip({objects = {bgb}, })

            data[o] = {
                ib = ib,
                bgb = bgb,
                tt = tt,
            }
        end

        -- pass the tooltip since it'll try to set the font of it
        local text, bg, bg_image, icon = label(o, tt.textbox)

        if icon then
            ib:set_image(icon)
        else
            ib:set_image(unknown_task_icon)
        end
        l:add(bgb)
        tt:set_markup(text)
        tt.wibox:set_bg(bg)
        bgb:set_widget(ib)
        bgb:set_bg(bg)
        bgb:set_bgimage(bg_image)
    end
    w:add(l)
end

function create_layout_menu()
    output = { items = {} }
    for i, o in ipairs(layouts) do
        layout_name = awful.layout.getname(o)
        layout_output = {
            layout_name,
            function()
                awful.layout.set(o)
            end,
            o and beautiful["layout_" .. layout_name]
        }
        table.insert(output.items, layout_output)
    end
    return awful.menu(output)
end

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 2,
                       function()
                           if layout_menu then
                               layout_menu:toggle()
                           else
                               layout_menu = create_layout_menu()
                               layout_menu:show()
                           end
                       end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons, nil, tag_tooltips)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons, nil, icons_only_update)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s })
    -- click anywhere else on the taskbar to hide menus
    mywibox[s]:buttons(awful.util.table.join(
        awful.button({  }, 1, function()
            hide_client_actions()
            if layout_menu then
                layout_menu:hide()
            end
            if mymainmenu then
                mymainmenu:hide()
            end
        end)
        )
    )


    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mylayoutbox[s])
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    left_layout:buttons()

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 1, function()
        hide_client_actions()
        if layout_menu then
            layout_menu:hide()
        end
        if mymainmenu then
            mymainmenu:hide()
        end
    end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    keydoc.group("Misc"),
    awful.key({modkey, }, "F1", keydoc.display, "Show help"),
    keydoc.group("Tag Navigation"),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ,
        "View next tag"),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ,
        "View previous tag"),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
        "Jump between the most two recent tags"),
    awful.key({ modkey, "Control"   }, "Escape", awful.tag.viewnone,
        "View no tags"),

    keydoc.group("Client Navigation"),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end, "Focus next client"),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end, "Focus previous client"),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
        "Jump to an urgent client"),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end, "Switch between two most recent clients"),
    keydoc.group("Client Actions"),
    awful.key({ modkey, "Control" }, "n", awful.client.restore,
        "Unminimize clients (MRF)"),

    -- Layout manipulation
    keydoc.group("Layout Manipulation"),
    awful.key({ modkey, "Shift"   }, "j", 
        function () awful.client.swap.byidx(  1)    end,
        "Move client to next slot in layout"),
    awful.key({ modkey, "Shift"   }, "k",
        function () awful.client.swap.byidx( -1)    end,
        "Move client to previous slot in layout"),
    keydoc.group("Screen Navigation"),
    awful.key({ modkey, "Control" }, "j",
        function () awful.screen.focus_relative( 1) end,
        "Move pointer to the next screen"),
    awful.key({ modkey, "Control" }, "k",
        function () awful.screen.focus_relative(-1) end,
        "Move pointer to the previous screen"),

    keydoc.group("CMus Control"),
    awful.key({ modkey }, "slash",  function() posix.spawn({"cmus-remote", "-u"}, 'r') end, "Play/Pause"),
    awful.key({ modkey }, "comma",  function() posix.spawn({"cmus-remote", "-r"}, 'r') end, "Next"),
    awful.key({ modkey }, "period", function() posix.spawn({"cmus-remote", "-n"}, 'r') end, "Previous"),
    awful.key({ modkey, "Shift" }, "slash",
        function()
            posix.spawn({os.getenv('HOME') .. '/bin/cmus_mark_impressive.sh'}, 'r')
        end, "Quickmark"),
    -- Standard program
    keydoc.group("Misc"),
    awful.key({ modkey,           }, "Return", launch_term_with_shell , "Spawn a shell"),
    awful.key({ modkey, "Control" }, "r", awesome.restart, "Restart awesome"),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit, "Quit awesome"),

    keydoc.group("Layout Manipulation"),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end, "Master width++"),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end, "Master width--"),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end, "Master count++"),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end, "Master count--"),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end, "Columns++"),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end, "Columns--"),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end, "Next layout"),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end, "Previous layout"),


    -- Prompt
    keydoc.group("Misc"),
    awful.key({ modkey }, "z", function() awful.mouse.finder.find(mymousefinder) end),
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end, "Run command"),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end, "Run lua code in awesome")
)

keydoc.group("Client Actions")
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c) c.fullscreen = not c.fullscreen  end,
        "Toggle fullscreen"),
    awful.key({ modkey, "Ctrl"   }, "c",
        function (c) c:kill() end,
        "Kill window"),
    awful.key({ modkey, "Control" }, "space", 
        awful.client.floating.toggle,
        "Toggle floating mode"),
    awful.key({ modkey, "Control" }, "Return",
        function (c) c:swap(awful.client.getmaster()) end,
        "Swap client with master"),
    awful.key({ modkey,           }, "o",
        awful.client.movetoscreen,
        "Move client to screen"),
    awful.key({ modkey,           }, "s",
        function (c) c.sticky = not c.sticky end,
        "Toggle sticky"),
    awful.key({ modkey,           }, "t",
        function (c) c.ontop = not c.ontop end,
        "Toggle on top"),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        "Minimize client"),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end,
        "Toggle maximization")
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.

generic_viewonly_tag_doc = "View only this tag"
generic_toggleview_tag_doc = "Toggle viewing this tag"
genertic_client_toggle_tag_doc = "Toggle tag on client"
genertic_client_move_tag_doc = "Move client to this tag"

numeric_pad = { "KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin", "KP_Right", "KP_Home", "KP_Up", "KP_Prior" }

for i = 1, 9 do
    local viewonly_tag_doc, toggleview_tag_doc
    local client_move_tag_doc, client_toggle_tag_doc
    if i == 5 then
        viewonly_tag_doc = generic_viewonly_tag_doc
        toggleview_tag_doc = generic_toggleview_tag_doc
        client_toggle_tag_doc = genertic_client_toggle_tag_doc
        client_move_tag_doc = genertic_client_move_tag_doc
    else
        viewonly_tag_doc = nil
        toggleview_tag_doc = nil
        client_toggle_tag_doc = nil
        client_move_tag_doc = nil
    end

    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only. If you set wallpapers up above, ALWAYS WRAP
        -- THEM WITH gears.surface.load_uncached. Otherwise, you'll
        -- notice huge delays when switching tags.
        keydoc.group("Tag Navigation"),
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end,
                  viewonly_tag_doc),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  toggleview_tag_doc),
        -- Numpad variants
        awful.key({ modkey }, numeric_pad[i],
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, numeric_pad[i],
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end,
                  client_move_tag_doc),

        -- Toggle tag on client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end,
                  client_toggle_tag_doc),
        -- Numpad variants
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, numeric_pad[i],
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),

        -- Toggle tag on client.
        awful.key({ modkey, "Control", "Shift" }, numeric_pad[i],
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end)
    )
end

ticked_icon = mbarfix.lookup_icon('gtk-apply')
hmaximize_toggle_icon = mbarfix.lookup_icon('object-flip-horizontal')
vmaximize_toggle_icon = mbarfix.lookup_icon('object-flip-vertical')
master_icon = mbarfix.lookup_icon('star')
minimize_icon = mbarfix.lookup_icon('gtk-go-down')
close_icon = mbarfix.lookup_icon('gtk-close')
move_to_tag_icon = mbarfix.lookup_icon('transform-move')
toggle_tag_icon = mbarfix.lookup_icon('gtk-properties')
toggle_top_icon = mbarfix.lookup_icon('gtk-goto-top')
toggle_sticky_icon = mbarfix.lookup_icon('sticky-notes')

function create_client_actions_menu(c)
    local ttags_for_screen = {}
    local mtags_for_screen = {}
    local ctags = c:tags()
    for _, o in ipairs(tags[c.screen]) do
        local tag_ticked = false
        for _, ct in ipairs(ctags) do
            if o == ct then
                tag_ticked = true
            end
        end

        if tag_ticked then
            tag_icon = ticked_icon
        else
            tag_icon = nil
        end
        local fullname = o.name .. " " .. awful.tag.getproperty(o, 'tooltip')

        table.insert(ttags_for_screen,
            {
                fullname,
                function()
                    awful.client.toggletag(o, c)
                end,
                tag_icon
            }
        )

        table.insert(mtags_for_screen,
            {
                fullname,
                function()
                    awful.client.movetotag(o, c)
                end,
                tag_icon
            }
        )
    end

    output = {
        items = {
            {
                "[H] Maximize toggle", 
                function() 
                    c.maximized_horizontal = not c.maximized_horizontal
                end,
                hmaximize_toggle_icon
            },
            {
                "[V] Maximize toggle",
                function()
                    c.maximized_vertical   = not c.maximized_vertical
                end,
                vmaximize_toggle_icon
            },
            {
                "Set as master",
                function()
                    c:swap(awful.client.getmaster())
                end,
                master_icon
            },
            {
                "Toggle on top",
                function()
                    c.ontop = not c.ontop
                end,
                toggle_top_icon,
            },
            {
                "Toggle sticky",
                function()
                    c.sticky = not c.sticky
                end,
                toggle_sticky_icon,
            },
            {
                "Toggle tags",
                ttags_for_screen,
                toggle_tag_icon
            },
            {
                "Move to tag",
                mtags_for_screen,
                move_to_tag_icon
            },
            {
                "Minimize",
                function()
                    c.minimized=true
                end,
                minimize_icon
            },
            {
                "Close",
                function()
                    c:kill()
                end,
                close_icon
            },
        },
        theme = {
            width = 250,
        },
    }

    if awful.layout.get(c.screen) == awful.layout.suit.floating then
        table.remove(output.items, 3)
    end

    return awful.menu(output)
end

function hide_client_actions()
    if client_actions then
        client_actions:hide()
        client_actions = nil
    end
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1,
        function (c)
            hide_client_actions()
            if layout_menu then
                layout_menu:hide()
            end
            client.focus = c; c:raise()
        end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 2, awful.mouse.client.resize),
    awful.button({ modkey }, 3,
        function (c)
            client.focus = c
            c:raise()
            local grab_before_show = awful.client.property.get(c, 'grab_before_show')
            if grab_before_show then
                -- Chromium, I hate you
                mousegrabber.run(function (_mouse)
                    return true
                end,
                'left_ptr')
            end
            hide_client_actions()
            client_actions = create_client_actions_menu(c)
            client_actions:show()
            if grab_before_show then
                mousegrabber.stop()
            end
        end, function (c) end
    )
)

-- Set keys
root.keys(globalkeys)
-- }}}

function default_custom_properties(c)
   awful.client.property.set(c, 'grab_before_show', false) 
end

function force_grab_before_clamenu(c)
   awful.client.property.set(c, 'grab_before_show', true) 
end

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { 
                     border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                   },
       callback =  default_custom_properties,
    },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Stjerm" },
      properties = { floating = true }, callback = awful.titlebar.hide },
    { rule = { class = "Kupfer.py", type='utility' },
        properties = { border_width = 0, floating = true, x = 746, y = 438 },
        callback = awful.titlebar.hide },
    { rule = { class = "Keepassx" }, properties = { floating = true } },
    { rule_any = {
            -- If you're here, that's because you misbehave on super+right-clicks
            class = { "qutebrowser", "chromium", "Nomacs", "Qpdfview" }
         },
         callback = force_grab_before_clamenu
    },
    -- autotagging {{{
    -- astrology
    { rule_any = { class = {"Openastro", } },
        properties = { tag = tags[1][1] } },
    -- web stuff
    { rule_any = { class = {"Firefox", "Pidgin", "Transmission", "Thunderbird", "Skype", "qutebrowser"} },
        properties = { tag = tags[1][2] } },
    -- arts
    { rule_any = { class = {"Gimp", "MyPaint", "Qosmic", "xsane"} },
      properties = { tag = tags[1][3] } },
    -- games
    { rule_any = { class = {"ltris", "perl", "icebreaker", "Mupen64plus", "Pysol", "Gweled", "zsnes", "Simsu"},
                   name = {"chuzzle.exe", "PlantsVsZombies.exe", "Yugioh Virtual Desktop 9.exe",
                           "MWSPlay.exe", "MagicWorkstation.exe", "ZumasRevenge.exe"} },
      properties = { tag = tags[1][4] } },
    --- }}}
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    -- c:connect_signal("mouse::enter", function(c)
    --    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --        and awful.client.focus.filter(c) then
    --        client.focus = c
    --    end
    --end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 2, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)
        left_layout:add(tags_titlebar(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        -- right_layout:add(awful.titlebar.widget.floatingbutton(c))
        -- right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        -- right_layout:add(awful.titlebar.widget.stickybutton(c))
        -- right_layout:add(awful.titlebar.widget.ontopbutton(c))
        -- right_layout:add(awful.titlebar.widget.closebutton(c))

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

        awful.titlebar(c, {size="18"}):set_widget(layout)
    end
end)

client.connect_signal("focus", 
function(c) 
    c.border_color = beautiful.border_focus 
end)
client.connect_signal("unfocus", 
function(c) 
    c.border_color = beautiful.border_normal 
end)
-- }}}

function awesome_autostart()
    posix.popen({"devmon"}, 'r')
    posix.popen({"setxkbmap", "-model", "microsoftprousb", "-layout",
        "us", "-variant", "olpc", "-option", "compose:rctrl",
        "-option", "caps:none"}, 'r')
    posix.popen({"xmodmap", os.getenv('HOME') .. '/.Xmodmap'}, 'r')
    posix.popen({"compton", "-b"}, 'r')
    posix.popen({"copyq"}, 'r')
    posix.popen({"volumeicon"}, 'r')
    posix.popen({"kupfer", "--no-splash"}, 'r')
    posix.popen({"syncthing-gtk"}, 'r')
    -- posix.popen({"xscreensaver", "-no-splash"})
end

if not finished_autostart then
    finished_autostart = true
    -- awesome_autostart()
end
-- vim: ts=4:sw=4:expandtab:foldmethod=marker
