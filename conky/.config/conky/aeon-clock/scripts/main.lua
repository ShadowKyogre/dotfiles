-- This is a lua script for use in Conky.
require 'cairo'
-- require 'cairo_imlib2_helper'
require 'math'
require 'os'


-- local pconfig = os.getenv('HOME') .. "/.config/conky/aeon-clock/scripts/private.lua"
-- local ok, e = pcall(dofile, pconfig)
-- if not ok then
--     imgs = {}
-- end


function blend_colors(c1, c2, blend_factor)
    local result = {
        math.sqrt( (1 - blend_factor) * c1[1]^2 + blend_factor * c2[1]^2),
        math.sqrt( (1 - blend_factor) * c1[2]^2 + blend_factor * c2[2]^2),
        math.sqrt( (1 - blend_factor) * c1[3]^2 + blend_factor * c2[3]^2),
        math.sqrt( (1 - blend_factor) * c1[4]^2 + blend_factor * c2[4]^2),
    }
    return result
end

function rainbow_ring (cr, opts)
    cairo_save(cr)
    local cx = opts.cx
    local cy = opts.cy
    local radius = opts.radius or 224
    local thickness = opts.thickness or 32
    local colors = opts.colors or {
        {1, 1, 0, 1},
        {0, 1, 1, 1},
        {1, 0, 1, 1},
    }
    local fine_tune = opts.fine_tune or 39
    local shadow = opts.shadow or false

    local len_colors = #colors
    local full_circle = 2 * math.pi

    local part_arc = full_circle / len_colors
    local fine_tune_arc = part_arc / fine_tune
    local gradient = nil
    local start_color, end_color = nil, nil


    if shadow then
        cairo_arc(cr, cx, cy, radius, 0, 2 * math.pi)
        cairo_set_source_rgba(cr, 0, 0, 0, 0.2)
        cairo_set_line_width(cr, thickness + 10)
        cairo_stroke_preserve(cr)
        
        cairo_set_source_rgba(cr, 0, 0, 0, 0.4)
        cairo_set_line_width(cr, thickness + 5)
        cairo_stroke(cr)
    end

    for i, color in pairs(colors) do
        start_color = color
        -- Need to account for lua table indexes starting at 1
        next_i = math.max(1, (i + 1) % (len_colors + 1))
        end_color = colors[next_i]

        start_arc = part_arc * i
        end_arc   = start_arc + fine_tune_arc

        for j = 0, fine_tune + 1 do
            color = blend_colors(start_color, end_color, j / fine_tune)

            cairo_arc(cr, cx, cy, radius - thickness / 2, start_arc, end_arc)
            cairo_arc_negative(cr, cx, cy, radius + thickness / 2, end_arc, start_arc)

            cairo_set_source_rgba(cr, color[1], color[2], color[3], color[4])
            cairo_close_path(cr)

            cairo_fill_preserve(cr)
            cairo_set_line_width(cr, 1)
            cairo_stroke(cr)

            start_arc = start_arc + fine_tune_arc
            end_arc = end_arc + fine_tune_arc
        end
    end
    cairo_restore(cr)
end

function oval(cr, opts)
    cairo_save(cr)
    local cx = opts.cx
    local cy = opts.cy
    local width = opts.width or 192
    local height = opts.height or 64
    
    local canvas_width = opts.canvas_width
    local canvas_height = opts.canvas_height
    local color = opts.color

    cairo_translate(cr, canvas_width / 2.0, canvas_height / 2.0)
    cairo_scale(cr, width / canvas_width, height / canvas_height)
    cairo_translate(cr, - canvas_width / 2.0, - canvas_height / 2.0)

    cairo_arc(cr, cx, cy, opts.max_radius, 0, 2 * math.pi)

    cairo_set_source_rgba(cr, table.unpack(color))
    cairo_close_path(cr)
    cairo_fill_preserve(cr)

    cairo_set_line_width(cr, 1)
    cairo_stroke(cr)

    cairo_restore(cr)
end

function concave_pentagon(cr, opts)
    cairo_save(cr)
    local cx = opts.cx
    local cy = opts.cy
    local width = opts.width or 64
    local height = opts.height or 64
    local color = opts.color or {1,1,1,1}
    local shadow = opts.shadow or false

    -- _ left
    cairo_move_to(cr, cx, cy)
    cairo_line_to(cr, cx - width / 2 * .875, cy)

    -- \ up
    cairo_curve_to(cr,
        cx - (width / 2 * .875), cy + height / 4,
        cx - (width / 2 * .875), cy + height / 4,
        cx - width / 2, cy + height / 2)

    -- / up
    cairo_curve_to(cr,
        cx - width / 4, cy + height * .625,
        cx - width / 8, cy + height * .66,
        cx, cy + height)

    -- \ down
    cairo_curve_to(cr,
        cx + width / 8, cy + height * .66,
        cx + width / 4, cy + height * .625,
        cx + width / 2, cy + height / 2)
 
    -- / down
    cairo_curve_to(cr,
        cx + (width / 2 * .875), cy + height / 4,
        cx + (width / 2 * .875), cy + height / 4,
        cx + width / 2 * .875, cy)

    -- __ right
    cairo_line_to(cr, cx, cy)
    cairo_close_path(cr)

    if type(color) == "userdata" then
        cairo_set_source(cr, color)
    else
        cairo_set_source_rgba(cr, table.unpack(color))
    end

    if shadow then
        cairo_fill_preserve(cr)
        cairo_set_source_rgba(cr, 0, 0, 0, .2)
        cairo_set_line_width(cr, 5)

        cairo_stroke_preserve(cr)
        cairo_set_source_rgba(cr, 0, 0, 0, .4)
        cairo_set_line_width(cr, 2.5)
        cairo_stroke(cr)
    else
        cairo_fill(cr)
    end

    cairo_restore(cr)
end

function clock_hands(cr, opts)
  local cx = opts.cx
  local cy = opts.cy
  local height = opts.max_radius * .39375
  local width = opts.max_radius * .27
  local colors = opts.colors or {{1,1,1,1}}
  local len_colors = #colors
  local shadow = opts.shadow or false

  local radius = opts.radius or .2875 * opts.canvas_height

  cairo_save(cr)
  cairo_translate(cr, cx, cy)
  for i = 1, 12 do
      cairo_rotate(cr, 30 * math.pi / 180)
      color_i = math.max(1, i % (len_colors) + 1)
      concave_pentagon(cr, {cx=0, cy=radius, height=height, width=width, color=colors[color_i], shadow=shadow})
  end
  cairo_restore(cr)

  local hand_width = width * .8
  local hand_height = height * .8
  local sec_hand_width = width * .6
  local sec_hand_height = height * .6
  local time = os.date("*t")

  cairo_save(cr)
  cairo_translate(cr, cx, cy)
  cairo_rotate(cr, (time.hour / 12 + .5) * 2 * math.pi)
  if time.hour >= 12 then
      concave_pentagon(cr, {cx=0, cy=radius, height=hand_height, width=hand_width, color=colors.pm_hour, shadow=shadow})
  else
      concave_pentagon(cr, {cx=0, cy=radius, height=hand_height, width=hand_width, color=colors.am_hour, shadow=shadow})
  end
  cairo_restore(cr)

  cairo_save(cr)
  cairo_translate(cr, cx, cy)
  cairo_rotate(cr, (time.min / 60 + .5) * 2 * math.pi)
  concave_pentagon(cr, {cx=0, cy=radius, height=hand_height, width=hand_width, color=colors.min, shadow=shadow})
  cairo_restore(cr)

  cairo_save(cr)
  cairo_translate(cr, cx, cy)
  cairo_rotate(cr, (time.sec / 60 + .5) * 2 * math.pi)
  concave_pentagon(cr, {cx=0, cy=radius, height=sec_hand_height, width=sec_hand_width, color=colors.sec, shadow=shadow})
  cairo_restore(cr)
end

function dict_copy(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        result[k] = v
    end
    return result
end

function conky_startup ()
    print("Setting up gradient patterns...")
    rainbow_warm = cairo_pattern_create_linear(-32, 0, 32, 0)
    cairo_pattern_add_color_stop_rgb(rainbow_warm,
        0,
        1, 1, 0
    )
    cairo_pattern_add_color_stop_rgb(rainbow_warm,
        .125,
        1, .75, 0
    )
    cairo_pattern_add_color_stop_rgb(rainbow_warm,
        .5,
        1, 0, 1
    )
    cairo_pattern_add_color_stop_rgb(rainbow_warm,
        .875,
        1, .75, 0
    )
    cairo_pattern_add_color_stop_rgb(rainbow_warm,
        1,
        1, 1, 0
    )

    rainbow_cold = cairo_pattern_create_linear(-32, 0, 32, 0)
    cairo_pattern_add_color_stop_rgb(rainbow_cold,
        0,
        .25, 1, 0
    )
    cairo_pattern_add_color_stop_rgb(rainbow_cold,
        .125,
        0, 1, 1
    )
    cairo_pattern_add_color_stop_rgb(rainbow_cold,
        .5,
        .75, 0, 1
    )
    cairo_pattern_add_color_stop_rgb(rainbow_cold,
        .875,
        0, 1, 1
    )
    cairo_pattern_add_color_stop_rgb(rainbow_cold,
        1,
        .25, 1, 0
    )
end

function conky_shutdown()
    print("Tearing down gradient patterns...")
    cairo_pattern_destroy(rainbow_warm)
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
    opts = {
        cx = conky_window.width / 2,
        cy = conky_window.height / 2,
        canvas_width = conky_window.width,
        canvas_height = conky_window.height,
    }
    opts.smallest_dim = math.min(conky_window.width, conky_window.height)
    opts.max_radius = opts.smallest_dim / 2

    ring_opts = dict_copy(opts)
    ring_opts.radius = opts.max_radius * 0.60
    ring_opts.thickness = 0.125 * opts.max_radius
    ring_opts.shadow = true

    eye_opts = dict_copy(opts)
    eye_opts.height = 3 * ring_opts.thickness
    eye_opts.width = 2 * 0.875 * ring_opts.radius
    eye_opts.color = {.204, .123, .533, 1}

    iris_opts = dict_copy(opts)
    iris_opts.radius = .375 * eye_opts.height
    iris_opts.thickness = 0.625 * iris_opts.radius
    iris_opts.colors = {
        {.851, 0, .996, 1},
        {.474, 0, .906, 1},
        {.474, 0, .906, 1},
        {.474, 0, .906, 1},
    }

    shine_opts = dict_copy(opts)
    shine_opts.height = .375 * eye_opts.height
    shine_opts.width = shine_opts.height
    shine_opts.cy = shine_opts.cy - 9 * shine_opts.height
    shine_opts.color =  {.851, 0, .996, .75}

    clock_opts = dict_copy(opts)
    clock_opts.colors = {
        rainbow_warm,
        rainbow_cold,
        am_hour = {1,0,.5,1},
        pm_hour = {.5,0,1,1},
        min = {.8, 1, 1, 1},
        sec = {1, 1, .8, 1},
    }
    clock_opts.shadow = true

    clock_hands(cr, clock_opts)
    rainbow_ring(cr, ring_opts)
    oval(cr, eye_opts)
    rainbow_ring(cr, iris_opts)
    oval(cr,shine_opts)

    cairo_destroy (cr)
    cairo_surface_destroy (cs)
    cr = nil
end
