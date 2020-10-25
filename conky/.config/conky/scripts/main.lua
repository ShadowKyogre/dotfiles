-- This is a lua script for use in Conky.
require 'cairo'
require 'cairo_imlib2_helper'
require 'math'
require 'os'


local pconfig = os.getenv('HOME') .. "/.config/conky/scripts/private.lua"
local ok, e = pcall(dofile, pconfig)
if not ok then
    imgs = {}
end

function from_png(cr, file, setup)
  cairo_save(cr)
  local cs = cairo_image_surface_create_from_png(file)
  local x = setup.x or 0
  local y = setup.y or 0
  local smart = setup.smart or false

  if smart then
      local w_ratio = 1
      local h_ratio = 1
      local xoffset = 0
      local yoffset = 0
      if setup.w or setup.h then -- want horizontal or vertical scaling, keep proportional
          local w =  cairo_image_surface_get_width(cs)
          local h =  cairo_image_surface_get_height(cs)
          if w > h then
              w_ratio = setup.w and setup.w / w or 1
              h_ratio = w_ratio
              yoffset = (setup.w * (h - h_ratio)) / 2
          else
              h_ratio = setup.h and setup.h / h or 1
              w_ratio = h_ratio
              xoffset = (setup.h - (w * w_ratio)) / 2
          end
          x = x + xoffset
          y = y + yoffset
          cairo_translate(cr, x, y)
          cairo_scale(cr, w_ratio, h_ratio)
      end
      cairo_set_source_surface(cr, cs, 0, 0)
  else
      if setup.w or setup.h then -- want horizontal or vertical scaling
        local w =  cairo_image_surface_get_width(cs)
        local h =  cairo_image_surface_get_height(cs)
        local w_ratio = setup.w and setup.w / w or 1
        local h_ratio = setup.h and setup.h / h or 1
        -- x = x / w_ratio
        -- y = y / h_ratio
        cairo_scale(cr, w_ratio, h_ratio)
      end
      cairo_set_source_surface(cr, cs, x, y)
  end

  cairo_paint_with_alpha(cr, setup.a or 1)
  cairo_restore(cr)
  cairo_surface_destroy(cs)
end

function conky_main ()
    if conky_window == nil then
        return
    end
    local cs = cairo_xlib_surface_create (conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create (cs)

    for key, value in pairs(imgs) do
        key_offset = 256 * (key - 1)
        -- print(key_offset, value)
        from_png(cr, value, {smart=true, w=256, h=256, x=key_offset})
    end

    cairo_destroy (cr)
    cairo_surface_destroy (cs)
    cr = nil
end
