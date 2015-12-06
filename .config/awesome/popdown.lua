local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')

local popdown = { mt = {} }

popdown.hide = function(self)
	self.wibox.visible = false
end

popdown.show = function(self)
	self.wibox.visible = true
end

popdown.visible = function(self)
	return self.wibox.visible
end

popdown.toggle = function(self)
	self.wibox.visible = not self.wibox.visible
end

popdown.geometry = function(self, ...)
	return self.wibox:geometry(...)
end

-- example
popdown.simple_text = function(text)
	local testbox = wibox.widget.textbox()
	local m = wibox.layout.margin(testbox, 4, 4)
	testbox:set_markup(text)
	local w, h = testbox:get_preferred_size(mouse.screen)
	return m, w+8, h+8
end

local function new(wrapped_widget, w, h)
	local self = {}
	self.prevx = 0
	self.prevy = 0
	self.wibox = wibox({})
	self.wibox:set_bg(beautiful.bg_normal)
	self.wibox:set_fg(beautiful.fg_normal)
	self.wibox.border_color = beautiful.border_normal
	self.wibox.border_width = beautiful.border_width
	self.wibox.ontop = true

	self.hide     = popdown.hide
	self.geometry = popdown.geometry
	self.show     = popdown.show
	self.visible  = popdown.visible
	self.toggle   = popdown.toggle

	self.wibox:set_widget(wrapped_widget)
	self.wibox:geometry({height = h, width = w})

	return self
end

function popdown.mt:__call(...)
    return new(...)
end

return setmetatable(popdown, popdown.mt)
