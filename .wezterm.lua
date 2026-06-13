local wezterm = require('wezterm')
local config = wezterm.config_builder()
local act = wezterm.action;

-- config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.color_scheme = 'Gruvbox (Gogh)'
config.color_scheme = 'catppuccin-latte'
config.front_end = "WebGpu"

-- Claude Code should 
-- wezterm.on("bell", function(window, pane)
--         local msg = 'Claude code finished a job in the "' .. window:active_workspace() .. '" workspace'
--         window:toast_notification('Claude Code', msg, nil, 3000)
-- end)

config.window_padding = {
        left=0,
        right=0,
        top=0,
        bottom=0,
}

-- Keys
local leader = ';'

config.leader = { key = leader, mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
        -- send C-a when pressing C-a twice
        {
                key=leader, mods='LEADER',
                action=act.SendKey {key=leader, mods="CTRL" }
        },
        { key='c', mods='LEADER', action=act.ActivateCopyMode },
        { key='v', mods='CTRL',   action=act.PasteFrom 'Clipboard' },

        -- Pane keybinds
        -- Open new pane
        { key='-', mods='LEADER', action=act.SplitVertical { domain = "CurrentPaneDomain"} },
        { key='-', mods='LEADER|CTRL', action=act.SplitHorizontal { domain = "CurrentPaneDomain"} },
        -- move to adjacent panes
        { key='h', mods='LEADER', action=act.ActivatePaneDirection("Left")},
        { key='j', mods='LEADER', action=act.ActivatePaneDirection("Down")},
        { key='k', mods='LEADER', action=act.ActivatePaneDirection("Up")},
        { key='l', mods='LEADER', action=act.ActivatePaneDirection("Right")},
        -- shift pane status/position
        { key='x', mods='LEADER', action=act.CloseCurrentPane {confirm=true}},
        { key='z', mods='LEADER', action=act.TogglePaneZoomState },
        { key='s', mods='LEADER', action=act.RotatePanes "Clockwise" },
        { key='s', mods='LEADER|CTRL', action=act.RotatePanes "CounterClockwise" },

        -- resize panes (see keytable below)
        { key='r', mods='LEADER', action=act.ActivateKeyTable {name="resize_pane", one_shot=false }},

        -- swap panes and tabs
        { key='p', mods='LEADER', action=wezterm.action_callback(
                function(_,pane) pane:move_to_new_tab() end
        )},
        { key='p', mods='LEADER|CTRL', action=wezterm.action_callback(
                function(window,pane)
                        window = wezterm.mux.get_window(window:window_id())
                        local pid = pane:pane_id()

                        wezterm.log_info("current pane id: ", pid)
                        wezterm.log_info("current window id: ", window:window_id())
                        -- get the next tab
                        -- TODO: make this more elegant, dynamically select tab
                        -- local window_obj = wezterm.mux.get_window(window:window_id())
                        -- wezterm.log_info(window_obj:active_tab())
                        local tabs = window:tabs_with_info()
                        if #tabs <= 1 then
                                return
                        end
                        wezterm.log_info("tabs: ", tabs)
                        local current_tab
                        for _, item in ipairs(window:tabs_with_info()) do
                                if item.is_active then
                                        curent_tab = item
                                        break
                                end
                        end

                        -- local current_tab = window:active_tab()
                        wezterm.log_info(current_tab.index, current_tab)
                        local tab_to_merge_index = current_tab.index + 1;
                        if tab_to_merge_index >= #tabs then
                                return
                        end
                        local tab_to_merge = tabs[tab_to_merge_index].tab
                        wezterm.log_info("tab to merge: ", tab_to_merge)
                        local pane_to_merge = tab_to_merge:active_pane()
                        wezterm.log_info("pane to merge: ", pane_to_merge)
                        local merge_pid = pane_to_merge:pane_id()
                        wezterm.log_info("pane id to merge: ", merge_pid)

                        wezterm.log_info("current tab: ", current_tab.index)

                        window:perform_action(wezterm.action.SpawnCommandInNewTab {
                                args = { "C:/Program Files/WezTerm/wezterm.exe",
                                        "cli",
                                        "split-pane",
                                        "--bottom",
                                        "--move-pane-id", tostring(pid),
                                        "--pane-id", tostring(merge_pid)
                                }
                        }, pane)
                        window:perform_action(wezterm.action.ActivateTab(current_tab.index), pane)
                end
        )},
        --[[
        --      pulling tabs into panes LEADER C-p
        --      option 1: open tab navigator, select tab, pull it into pane
        --      option 2: LEADER C-p tabnum
        --]]

        -- Tab keybinds
        { key='n', mods='LEADER', action=act.SpawnTab("CurrentPaneDomain") },
        { key='h', mods='LEADER|CTRL', action=act.ActivateTabRelative(-1) },
        { key='j', mods='LEADER|CTRL', action=act.ActivateTabRelative(-1) },
        { key='k', mods='LEADER|CTRL', action=act.ActivateTabRelative(1) },
        { key='l', mods='LEADER|CTRL', action=act.ActivateTabRelative(1) },
        { key='t', mods='LEADER', action=act.ShowTabNavigator },
        { key='m', mods='LEADER', action=act.ActivateKeyTable {name="resize_move", one_shot=false }},
        { key='t', mods='LEADER|CTRL', action=act.PromptInputLine {
                description="Rename tab to: ",
                action=wezterm.action_callback(function(window,_,line)
                        if line and line ~= "" then
                                window:active_tab():set_title(line)
                        end
                end)
        } },

        -- workspace
        { key='w', mods='LEADER', action=act.ShowLauncherArgs { flags="WORKSPACES"} },
        { key='w', mods='LEADER|CTRL', action=act.PromptInputLine {
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
        { key='b', mods='LEADER|CTRL', action=wezterm.action_callback(
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
-- config.enable_tab_bar = true
config.status_update_interval = 1000
wezterm.on("update-right-status", function(window, pane)
        local stat = window:active_workspace()
        if window:leader_is_active() then stat = "LDR" end
        if window:active_key_table() then stat = window:active_key_table() end

        local cwd_uri = pane:get_current_working_dir()
        local cwd = ""
        if cwd_uri then
                cwd = cwd_uri.file_path or ""
        end

        window:set_right_status(wezterm.format({
                { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
                { Text = " | " },
                { Text = wezterm.nerdfonts.oct_file_directory_open_fill .. "  " .. cwd },
        }))
end)

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
