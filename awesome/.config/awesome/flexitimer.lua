local awful = require('awful')
local beautiful = require('beautiful')
-- local naughty = require('naughty')
local timer = require("gears.timer")

local flexitimer = { mt = {} }

flexitimer.check_breaktime = function(self)
	self.curbreaktime = self.curbreaktime + 1
	self._widget:set_value(100 * (1 - self.curbreaktime / self.breaks))
	self:tooltip_update()
	if (self.breaks <= self.curbreaktime) or self.paused then
		self._timer:stop()
	end
end

flexitimer.check_time = function(self)
	self.curtime = self.curtime + 1
	self._widget:set_value(100 * (1 - self.curtime / self.work))
	self:tooltip_update()
	if (self.work <= self.curtime) or self.paused then
		self._timer:stop()
	end
end

flexitimer.breakstart = function(self, restart)
	self._timer:disconnect_signal('timeout', self.dummytime)
	self._timer:disconnect_signal('stop', self.dummybreaktimestop)
	self._timer:disconnect_signal('stop', self.dummytimestop)
	self._timer:disconnect_signal('stop', self.dummytimeresume)

	self.curbreaktime = 0
	self.inbreak = true
	self.paused  = false

	self._widget:set_color(self.breakstyle)
	self._widget:set_value(100 * (1 - self.curbreaktime / self.breaks))
	self:tooltip_update()
	self._timer:connect_signal('timeout', self.dummybreaktime)
	if restart then
		self._timer:connect_signal('stop', self.dummybreaktimestop)
	else
		self._timer:connect_signal('stop', self.dummytimeresume)
	end
	self._timer:start()
end

flexitimer.start = function(self, noreset)
	self._timer:disconnect_signal('timeout', self.dummybreaktime)
	self._timer:disconnect_signal('stop', self.dummybreaktimestop)
	self._timer:disconnect_signal('stop', self.dummytimestop)
	self._timer:disconnect_signal('stop', self.dummytimeresume)
	self.inbreak = false
	self.paused  = false

	if not noreset then
		self.curtime = 0
	end

	self._timer:connect_signal('timeout', self.dummytime)

	self._widget:set_color(self.workstyle)
	self:tooltip_update()
	self._widget:set_value(100 * (1 - self.curtime / self.work))
	self._timer:connect_signal('stop', self.dummytimestop)
	self._timer:start()
end

flexitimer.resume = function(self)
	self.paused = false
	if self.inbreak then
		self._widget:set_color(self.breakstyle)
		self._timer:connect_signal('stop', self.dummytimeresume)
	else
		self._widget:set_color(self.workstyle)
		self._timer:connect_signal('stop', self.dummytimestop)
	end
	self._timer:start()
end

flexitimer.pause = function(self, startbreak)
	self.startbreak = startbreak
	local prevstarted = self._timer.started
	self._timer:disconnect_signal('stop', self.dummybreaktimestop)
	self._timer:disconnect_signal('stop', self.dummytimestop)
	self._timer:disconnect_signal('stop', self.dummytimeresume)
	self._timer:stop()
	if prevstarted and self.startbreak then
		self:breakstart(false)
	else
		self.paused = true
		self._widget:set_color(self.pausestyle)
	end
	self:tooltip_update()
end

flexitimer.reset = function(self)
	self._timer:disconnect_signal('timeout', self.dummybreaktime)
	self._timer:disconnect_signal('timeout', self.dummytime)
	self._timer:disconnect_signal('stop', self.dummybreaktimestop)
	self._timer:disconnect_signal('stop', self.dummytimestop)
	self._timer:disconnect_signal('stop', self.dummytimeresume)

	self.startbreak   = false
	self.inbreak      = false
	self.paused       = true
	self.curtime      = 0
	self.curbreaktime = 0

	self:tooltip_update()
	self._widget:set_color(self.pausestyle)
end

flexitimer.tooltip_update = function(self)
	local fmt = "<b>Status:</b> %s\n<b>Remaining time:</b> %s"
	local fmttime = "%d:%02d:%02d"
	local ttime, delta, hours, h, m, s

	if self.inbreak then
		delta = self.breaks - self.curbreaktime
	else
		delta = self.work - self.curtime
	end

	hours = delta / 3600
	h     = math.floor(hours)
	m     = math.floor(hours % 1 * 60)
	s     = math.floor(delta % 60)
	ttime = string.format(fmttime, h, m, s)

	local text

	if self.paused then
		text = string.format(fmt, "Paused", ttime)
	else
		if self.inbreak then
			text = string.format(fmt, "Break", ttime)
		else
			text = string.format(fmt, "Work", ttime)
		end
	end

	self._tt:set_markup(text)
end

flexitimer.buttons = function(self, ...)
	self._widget:buttons(...)
end

-- Create a progress bar and link it to these three states:
-- @tparam table args Arguments for creation
-- @tparam[opt=25*60] number args.work Timer in seconds for work
-- @tparam[opt=5*60] number args.breaks Timer in seconds for breaks after work has elapsed
-- @tparam[opt] string args.workstyle Styles for while working
-- @tparam[opt] string args.breakstyle Styles for while taking break
-- @tparam[opt] string args.pausestyle Styles for while pausing
local function new(args)
	local self = {}

	self._widget = awful.widget.progressbar()
	self._tt = awful.tooltip({objects = {self._widget} })
	self._widget:set_max_value(100)
	self._widget:set_value(100)
	self._widget:set_ticks(true)
	self._timer = timer({timeout = 1})

	-- necessary instance variables
	self.buttons         = flexitimer.buttons
	self.pause           = flexitimer.pause
	self.resume          = flexitimer.resume
	self.start           = flexitimer.start
	self.reset           = flexitimer.reset
	self.breakstart      = flexitimer.breakstart
	self.check_time      = flexitimer.check_time
	self.check_breaktime = flexitimer.check_breaktime
	self.dummytime       = function() self:check_time() end
	self.dummybreaktime  = function() self:check_breaktime() end
	self.dummytimestop   = function()
		if self.work <= self.curtime then
		-- naughty.notify{text="Work over! Take a break!"}
			  self:breakstart(true)
		end
	end
	self.dummytimeresume = function() 
		-- naughty.notify{text="Going back to main timer"}
		self:start(true)
	end

	self.dummybreaktimestop = function()
		if self.breaks <= self.curbreaktime then
			-- naughty.notify{text="Break over!"}
			self:start()
		end
	end

	self.tooltip_update  = flexitimer.tooltip_update
	self.startbreak      = false
	self.inbreak         = false
	self.paused          = true
	self.curtime         = 0
	self.curbreaktime    = 0

	-- user config
	self.workstyle    = (args and args.workstyle)  or beautiful.fg_normal
	self.breakstyle   = (args and args.breakstyle) or beautiful.fg_urgent
	self.pausestyle   = (args and args.pausestyle) or beautiful.fg_minimize
	-- default to pomodoro
	self.work         = (args and args.work) or 25*60
	self.breaks       = (args and args.breaks) or 5*60

	self._widget:set_color(self.pausestyle)
	self:tooltip_update()

	return self
end

function flexitimer.mt:__call(...)
	return new(...)
end

return setmetatable(flexitimer, flexitimer.mt)
