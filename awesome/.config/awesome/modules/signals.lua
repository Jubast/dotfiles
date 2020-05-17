local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local signals = {}

local function do_sloppy_focus(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and
        awful.client.focus.filter(c) then client.focus = c end
end

local function fixed_maximized_geometry(c, context)
    if c.maximized and context ~= "fullscreen" then
        c:geometry({
            x = c.screen.workarea.x,
            y = c.screen.workarea.y,
            height = c.screen.workarea.height - 2 * c.border_width,
            width = c.screen.workarea.width - 2 * c.border_width
        })
    end
end

function signals:init()
    -- Handle runtime errors after startup
    do
        local in_error = false
        awesome.connect_signal("debug::error", function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end
            in_error = true
    
            naughty.notify({
                preset = naughty.config.presets.critical,
                title = "Oops, an error happened!",
                text = tostring(err)
            })
            in_error = false
        end)
    end

    -- actions on every application start
    client.connect_signal("manage", function(c)
        awful.client.setslave(c)
        beautiful.useless_gap = 3
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 4)
        end

        -- startup placement
        if awesome.startup and not c.size_hints.user_position and
            not c.size_hints.program_position then
            awful.placement.no_offscreen(c)
        end
    end)

    -- add missing borders to windows that get unmaximized
    client.connect_signal("property::maximized", function(c)
        if not c.maximized then c.border_width = beautiful.border_width end
    end)

    -- don't allow maximized windows move/resize themselves
    client.connect_signal("request::geometry", fixed_maximized_geometry)

    client.connect_signal("mouse::enter", do_sloppy_focus)
    client.connect_signal("focus", function(c)
        c.border_color = beautiful.border_focus
    end)
    client.connect_signal("unfocus", function(c)
        c.border_color = beautiful.border_normal
    end)
    
    -- Refresh awesome when number of screens changes
    screen.connect_signal("list", awesome.restart)
end

return signals
