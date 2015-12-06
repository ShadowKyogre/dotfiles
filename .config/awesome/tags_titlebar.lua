local awful = require('awful')
local beautiful = require('beautiful')
awful.util  = require('awful.util')
local wibox = require('wibox')

local ttb_widget = { mt = {} }

local function new(c)
    local output = wibox.layout.fixed.horizontal()
    local data = {}

    local function redraw()
        output:reset()
        local fg_focus    = beautiful.taglist_fg_focus or beautiful.fg_focus
        local fg_occupied = beautiful.taglist_fg_occupied or beautiful.fg_normal
        local bg_focus    = beautiful.taglist_bg_focus or beautiful.bg_focus
        local bg_normal   = beautiful.taglist_bg_empty or beautiful.bg_normal
        for i, o in ipairs(awful.tag.gettags(c.screen)) do
            local selected = false
            for _, t in ipairs(c:tags()) do
                if t == o then
                    selected = true
                    break
                end
            end
            local tb, tt
            local cache = data[o]
            if cache then
                tb = cache.tb
                tt = cache.tt
            else
                tb = wibox.widget.textbox()
                tt = awful.tooltip({objects = {tb}, })
                data[o] = {
                    tb = tb,
                    tt = tt, 
                }
            end
            local etext = awful.util.escape(o.name) or ""
            local ettext = awful.util.escape(awful.tag.getproperty(o, 'tooltip')) or ""

            local text
            local ttext
            if selected then
                text = "<span color='" .. awful.util.ensure_pango_color(fg_focus) ..
        "'>" .. etext .. "</span>"
                ttext = "<span color='" .. awful.util.ensure_pango_color(fg_focus) ..
        "'>" .. ettext .. "</span>"
                tt.wibox:set_bg(bg_focus)
                tt.wibox.border_color = fg_focus
            else
                text = "<span color='" .. awful.util.ensure_pango_color(fg_occupied) ..
        "'>" .. etext .. "</span>"
                ttext = "<span color='" .. awful.util.ensure_pango_color(fg_occupied) ..
        "'>" .. ettext .. "</span>"
                tt.wibox:set_bg(bg_occupied)
                tt.wibox.border_color = fg_occupied
            end
            tb:set_markup(text)

            tt:set_markup(ttext)
            output:add(tb)
        end
    end

    redraw()
    c:connect_signal('tagged', redraw)
    c:connect_signal('untagged', redraw)
    return output
end

function ttb_widget.mt:__call(...)
    return new(...)
end

return setmetatable(ttb_widget, ttb_widget.mt)
