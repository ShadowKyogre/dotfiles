local awful_util = require("awful.util")

--- monkeypatch menubar.utils {{{
local all_icon_sizes = {
    '128x128' ,
    '96x96',
    '72x72',
    '64x64',
    '48x48',
    '36x36',
    '32x32',
    '24x24',
    '22x22',
    '16x16'
}

local mbarfix = {}

local icon_formats = { "png", "xpm" }

local function is_format_supported(icon_file)
    for _, f in ipairs(icon_formats) do
        if icon_file:match('%.' .. f) then
            return true
        end
    end
    return false
end

function mbarfix.lookup_dirs(ico_theme_dirs)
	local output = {}
	for _, icodir in ipairs(ico_theme_dirs) do
		for j, size in ipairs(all_icon_sizes) do
			table.insert(output, icodir .. size .. '/apps/')
			table.insert(output, icodir .. size .. '/actions/')
			table.insert(output, icodir .. size .. '/devices/')
			table.insert(output, icodir .. size .. '/places/')
			table.insert(output, icodir .. size .. '/categories/')
			table.insert(output, icodir .. size .. '/status/')
		end
	end
	return output
end

function mbarfix.lookup_icon(icon_file)
    if not icon_file or icon_file == "" then
        return default_icon
    end

    if icon_file:sub(1, 1) == '/' and is_format_supported(icon_file) then
        -- If the path to the icon is absolute and its format is
        -- supported, do not perform a lookup.
        return icon_file
    else
        local icon_path = {}
        local icon_theme_paths = {}
        local icon_theme = theme.icon_theme
        if icon_theme then
            table.insert(icon_theme_paths, os.getenv('HOME') .. '/.icons/' .. icon_theme .. '/')
            table.insert(icon_theme_paths, '/usr/share/icons/' .. icon_theme .. '/')
            -- TODO also look in parent icon themes, as in freedesktop.org specification
        end
        table.insert(icon_theme_paths, '/usr/share/icons/hicolor/') -- fallback theme

        for i, icon_theme_directory in ipairs(icon_theme_paths) do
            for j, size in ipairs(all_icon_sizes) do
                table.insert(icon_path, icon_theme_directory .. size .. '/apps/')
                table.insert(icon_path, icon_theme_directory .. size .. '/actions/')
                table.insert(icon_path, icon_theme_directory .. size .. '/devices/')
                table.insert(icon_path, icon_theme_directory .. size .. '/places/')
                table.insert(icon_path, icon_theme_directory .. size .. '/categories/')
                table.insert(icon_path, icon_theme_directory .. size .. '/status/')
            end
        end
        -- lowest priority fallbacks
        table.insert(icon_path, '/usr/share/pixmaps/')
        table.insert(icon_path, '/usr/share/icons/')

        for i, directory in ipairs(icon_path) do
            if is_format_supported(icon_file) and awful_util.file_readable(directory .. icon_file) then
                return directory .. icon_file
            else
                -- Icon is probably specified without path and format,
                -- like 'firefox'. Try to add supported extensions to
                -- it and see if such file exists.
                for _, format in ipairs(icon_formats) do
                    local possible_file = directory .. icon_file .. "." .. format
                    if awful_util.file_readable(possible_file) then
                        return possible_file
                    end
                end
            end
        end
        return default_icon
    end
end

return mbarfix
--}}}
