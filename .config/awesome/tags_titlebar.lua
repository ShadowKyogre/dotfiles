local awful = require('awful')
awful.util  = require('awful.util')
local wibox = require('wibox')

ttb_widget = { mt = {} }

local function new(c)
    local output = wibox.layout.fixed.horizontal()
    local data = {}

    local function redraw()
        output:reset()
        local fg_focus = theme.fg_focus
        local fg_occupied = theme.fg_normal
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
            local text
            if selected then
                text = "<span color='" .. awful.util.ensure_pango_color(fg_focus) ..
        "'>" .. (awful.util.escape(o.name) or "") .. "</span>"
            else
                text = "<span color='" .. awful.util.ensure_pango_color(fg_occupied) ..
        "'>" .. (awful.util.escape(o.name) or "") .. "</span>"
            end
                    tb:set_markup(text)
                    tt:set_markup(awful.tag.getproperty(o, 'tooltip'))
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
