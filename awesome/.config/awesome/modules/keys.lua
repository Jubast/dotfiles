local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local modkey = "Mod4"
local terminal = "alacritty"

local keys = { keys = {} }

function keys:init(args)
    local modkey = args.modkey
    local terminal = args.terminal

    self.keys = gears.table.join(

    -- Awesome common
    awful.key({ modkey }, "s", hotkeys_popup.show_help, 
        {description="show help", group="awesome"}),
    awful.key({ modkey }, "w", function () mymainmenu:show() end,
        {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit,
        {description = "exit awesome", group = "awesome"}),
    
    -- Client movement
    awful.key({ modkey }, "j", function () awful.client.focus.bydirection("left") end, 
        {description = "focus left client", group = "client"}),
    awful.key({ modkey }, "k", function () awful.client.focus.bydirection("down") end, 
        {description = "focus down client", group = "client"}),
    awful.key({ modkey }, "l", function () awful.client.focus.bydirection("up") end, 
        {description = "focus up client", group = "client"}),
    awful.key({ modkey }, ";", function () awful.client.focus.bydirection("right") end, 
        {description = "focus right client", group = "client"}),

    -- Switch clients
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.bydirection("left") end,
        {description = "swap with left client", group = "client"}),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.bydirection("down") end,
        {description = "swap with down client", group = "client"}),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.swap.bydirection("up") end,
        {description = "swap with up client", group = "client"}),
    awful.key({ modkey, "Shift" }, ";", function () awful.client.swap.bydirection("right") end,
        {description = "swap with down client", group = "client"}),

    -- Resize clients (Mod1 = Alt)
    awful.key({ modkey, "Mod1" }, "j", function () awful.tag.incmwfact(-0.05) end,
        {description = "resize left", group = "layout"}), 
    awful.key({ modkey, "Mod1" }, "k", function () awful.client.incmwfact( 0.05) end,
        {description = "resize up", group = "layout"}),
    awful.key({ modkey, "Mod1" }, "l", function () awful.client.incmwfact(-0.05) end,
        {description = "resize down", group = "layout"}),
    awful.key({ modkey, "Mod1" }, ";", function () awful.tag.incmwfact(0.05) end,
        {description = "resize right", group = "layout"}),

    -- Switch screens 
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_bydirection("left") end,
        {description = "resize left", group = "screen"}), 
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_bydirection("down") end,
        {description = "resize up", group = "screen"}),
    awful.key({ modkey, "Control" }, "l", function () awful.screen.focus_bydirection("up") end,
        {description = "resize down", group = "screen"}),
    awful.key({ modkey, "Control" }, ";", function () awful.screen.focus_bydirection("right") end,
        {description = "resize right", group = "screen"}),

    -- Mystic
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "jump to previous client", group = "client"}),
    
    -- Standard program
    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
        {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey }, "r", function () awful.spawn("rofi -show run") end,
        {description = "run prompt", group = "launcher"})

    --awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    --     {description = "select next", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    --     {description = "select previous", group = "layout"}),

    --awful.key({ modkey, "Control" }, "n",
    --         function ()
    --              local c = awful.client.restore()
    --              -- Focus restored client
    --              if c then
    --                c:emit_signal(
    --                    "request::activate", "key.unminimize", {raise = true}
    --                )
    --              end
    --          end,
    --          {description = "restore minimized", group = "client"}),

    --awful.key({ modkey }, "x",
    --          function ()
    --              awful.prompt.run {
    --                prompt       = "Run Lua code: ",
    --                textbox      = awful.screen.focused().mypromptbox.widget,
    --                exe_callback = awful.util.eval,
    --                history_path = awful.util.get_cache_dir() .. "/history_eval"
    --              }
    --          end,
    --          {description = "lua execute prompt", group = "awesome"}),

    -- Menubar
    --awful.key({ modkey }, "p", function() menubar.show() end,
    --          {description = "show the menubar", group = "launcher"})
    )

    self.client = gears.table.join(
    awful.key({ modkey, "Shift" }, "q", function (c) c:kill() end,
        {description = "kill client", group = "client"}),
 awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}),
    awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end,
        {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey, "Control" }, "n", function (c) c:move_to_screen() end,
        {description = "move to next screen", group = "screen"})
 
    )

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    self.keys = gears.table.join(self.keys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

    root.keys(self.keys)
end

--clientbuttons = gears.table.join(
--    awful.button({ }, 1, function (c)
--        c:emit_signal("request::activate", "mouse_click", {raise = true})
--    end),
--    awful.button({ modkey }, 1, function (c)
--        c:emit_signal("request::activate", "mouse_click", {raise = true})
--        awful.mouse.client.move(c)
--    end),
--    awful.button({ modkey }, 3, function (c)
--        c:emit_signal("request::activate", "mouse_click", {raise = true})
--        awful.mouse.client.resize(c)
--    end)
--)

return keys
