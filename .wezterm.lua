local wezterm = require('wezterm')
local config = wezterm.config_builder()
local act = wezterm.action;

config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.color_scheme = 'Gruvbox (Gogh)'
-- config.color_scheme = 'catppuccin-latte'
config.front_end = "WebGpu"

config.default_domain = "WSL:Ubuntu"

config.window_padding = {
        left=0,
        right=0,
        top=0,
        bottom=0,
}

config.enable_kitty_keyboard = true

-- Keys
local leader = ';'
local modifier = 'CTRL'
config.leader = { key=';', mods=modifier, timeout_milliseconds=2000 }
config.keys = {
        -- send M-; when pressing M-; twice
        {
                key=leader, mods='LEADER',
                action=act.SendKey {key=';', mods="ALT" }
        },
        { key='c', mods='LEADER', action=act.ActivateCopyMode },
        { key='v', mods='CTRL',   action=act.PasteFrom 'Clipboard' },

        -- shift pane status/position
        { key='x', mods='LEADER', action=act.CloseCurrentPane {confirm=true}},
        -- Tab keybinds
        { key='n', mods='LEADER', action=act.SpawnTab("CurrentPaneDomain") },
        { key='h', mods='LEADER|'..modifier, action=act.ActivateTabRelative(-1) },
        { key='j', mods='LEADER|'..modifier, action=act.ActivateTabRelative(-1) },
        { key='k', mods='LEADER|'..modifier, action=act.ActivateTabRelative(1) },
        { key='l', mods='LEADER|'..modifier, action=act.ActivateTabRelative(1) },
        { key='t', mods='LEADER', action=act.ShowTabNavigator },
        { key='m', mods='LEADER|'..modifier, action=act.ActivateKeyTable {name="resize_move", one_shot=false }},
        { key='t', mods='LEADER|'..modifier, action=act.PromptInputLine {
                description="Rename tab to: ",
                action=wezterm.action_callback(function(window,_,line)
                        if line and line ~= "" then
                                window:active_tab():set_title(line)
                        end
                end)
        } },

        -- workspace
        { key='w', mods='LEADER', action=act.ShowLauncherArgs { flags="WORKSPACES"} },
        { key='w', mods='LEADER|'..modifier, action=act.PromptInputLine {
                description="Rename workspace to: ",
                action=wezterm.action_callback(function(window,_,line)
                        if line and line ~= "" then
                                local old = window:active_workspace()
                                wezterm.mux.rename_workspace(old, line)
                        end
                end)
        } },

        -- extract pane to new window
        { key='b', mods='LEADER', action=wezterm.action_callback(
                function(originalWindow, pane)
                        local title = pane:tab():get_title()
                        local tab, newWindow = pane:move_to_new_window()
                        tab:set_title(title)
                end
        ),},
        { key='b', mods='LEADER|'..modifier, action=wezterm.action_callback(
                function(window, _)
                        local mux_window = window:mux_window()
                        local workspace  = mux_window:get_workspace()
                        local target     = mux_window:window_id()

                        -- get all panes in our workspace not in our window
                        for _,w in ipairs(wezterm.mux.all_windows()) do
                                if w:window_id() == target or w:get_workspace() ~= workspace then
                                        goto windowcontinue
                                end
                                for _,tab in ipairs(w:tabs()) do
                                        local title = tab:get_title()
                                        for _,p in ipairs(tab:panes()) do
                                                local pane_id = p:pane_id()
                                                wezterm.run_child_process({
                                                        'wezterm', 'cli', 'move-pane-to-new-tab',
                                                        '--pane-id', tostring(pane_id),
                                                        '--window-id', tostring(target),
                                                })
                                                p:tab():set_title(title)
                                        end
                                end
                                ::windowcontinue::
                        end

                end),
        }
}

for i = 1,9 do
    table.insert(config.keys, {
            key = tostring(i),
            mods = "LEADER",
            action = act.ActivateTab(i-1)
    })
end

config.key_tables = {
        resize_pane = {
                { key='h', action=act.AdjustPaneSize { "Left", 1 }},
                { key='j', action=act.AdjustPaneSize { "Down", 1 }},
                { key='k', action=act.AdjustPaneSize { "Up", 1 }},
                { key='l', action=act.AdjustPaneSize { "Right", 1 }},
                { key='c', action="PopKeyTable" },
                { key='r', action="PopKeyTable" },
                { key='Escape', action="PopKeyTable" },
        },
        resize_move = {
                { key='h', action=act.MoveTabRelative(-1) },
                { key='j', action=act.MoveTabRelative(-1)},
                { key='k', action=act.MoveTabRelative(1)},
                { key='l', action=act.MoveTabRelative(1)},
                { key='m', action="PopKeyTable" },
                { key='c', action="PopKeyTable" },
                { key='r', action="PopKeyTable" },
                { key='Escape', action="PopKeyTable"},
        }
}

config.use_fancy_tab_bar = false
config.enable_tab_bar = false

config.wsl_domains  = {
        {
                name = 'WSL:Ubuntu-Saisystems',
                distribution = 'Ubuntu-Saisystems',
                default_cwd = '~'
        },
        {
                name = 'WSL:Ubuntu-Home',
                distribution = 'Ubuntu',
                default_cwd = '~'
        }
}

return config
