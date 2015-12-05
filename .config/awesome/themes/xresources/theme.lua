---------------------------------------------
-- Awesome theme which follows xrdb config --
--   by Yauhen Kirylau                    --
---------------------------------------------

local xresources = require("beautiful").xresources
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi

-- inherit default theme
local theme = dofile("/usr/share/awesome/themes/default/theme.lua")
-- load vector assets' generators for this theme
local theme_assets = dofile("/usr/share/awesome/themes/xresources/assets.lua")

theme.font          = "AveriaSerif 12"

theme.bg_normal     = xrdb.background
theme.bg_focus      = xrdb.color0
theme.bg_urgent     = xrdb.color1
theme.bg_minimize   = xrdb.color8
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = xrdb.foreground
theme.fg_focus      = xrdb.color11
theme.fg_urgent     = xrdb.color9
theme.fg_minimize   = theme.fg_normal

theme.mouse_finder_color  = theme.fg_urgent
theme.mouse_finder_radius = 20
theme.mouse_finder_factor = 2

theme.useless_gap   = dpi(4)
theme.border_width  = dpi(2)
theme.border_normal = xrdb.color0
theme.border_focus  = theme.bg_focus
theme.border_marked = xrdb.color10

theme.fg_widget_value = xrdb.foreground
theme.fg_widget_value_important = xrdb.color1
theme.fg_widget_clock = xrdb.color3

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_bg_empty    = theme.bg_normal
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_fg_empty    = theme.fg_normal

theme.tooltip_fg_color = theme.fg_normal
theme.tooltip_bg_color = theme.bg_normal

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = dpi(16)
theme.menu_width  = dpi(130)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Recolor titlebar icons:
theme = theme_assets.recolor_titlebar_normal(theme, theme.fg_normal)
theme = theme_assets.recolor_titlebar_focus(theme, theme.fg_focus)
theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Try to determine if we are running light or dark colorscheme:
local bg_numberic_value = 0;
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
    bg_numberic_value = bg_numberic_value + tonumber("0x"..s);
end
local is_dark_bg = (bg_numberic_value < 383)

-- Generate wallpaper:
local wallpaper_bg = xrdb.color8
local wallpaper_fg = xrdb.color7
local wallpaper_alt_fg = xrdb.color12
if not is_dark_bg then
    wallpaper_bg, wallpaper_fg = wallpaper_fg, wallpaper_bg
end
theme.wallpaper = theme_assets.wallpaper(
    wallpaper_bg, wallpaper_fg, wallpaper_alt_fg
)

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
