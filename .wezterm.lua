local wezterm = require('wezterm')
local config = wezterm.config_builder()
local act = wezterm.action;
-- local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- Settings
-- config.default_domain = 'WSL:Ubuntu'
-- config.default_cwd = '//wsl.localhost/Ubuntu/home/kachow'

config.color_scheme = 'Gruvbox Dark (Gogh)'

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
                        local current_tab = active_tab(window)
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
        -- { key='m', mods='LEADER', action=act.ActivateKeyTable {name="resize_move", one_shot=false }},
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

    -- restore
    -- { key='t', mods='CTRL|SHIFT', 
    --   action=wezterm.action_callback(function(win, pane)
            --   resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
                    --     local type = string.match(id, "^([^/]+)") -- match before '/'
                    --     id = string.match(id, "([^/]+)$") -- match after '/'
                    --     id = string.match(id, "(.+)%..+$") -- remove file extention
                    --     local opts = {
                    --       relative = true,
                    --       restore_text = true,
                    --       on_pane_restore = resurrect.tab_state.default_on_pane_restore,
                    --     }
                    --     if type == "workspace" then
                    --       local state = resurrect.state_manager.load_state(id, "workspace")
                    --       resurrect.workspace_state.restore_workspace(state, opts)
                    --     elseif type == "window" then
                    --       local state = resurrect.state_manager.load_state(id, "window")
                    --       resurrect.window_state.restore_window(pane:window(), state, opts)
                    --     elseif type == "tab" then
                    --       local state = resurrect.state_manager.load_state(id, "tab")
                    --       resurrect.tab_state.restore_tab(pane:tab(), state, opts)
                    --     end
            --   end)
    -- end), }
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

        local basename = function(s)
                return string.gsub(s, "(.*[/\\])(.*)", "%2")
        end
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

function active_tab(window)
        for _, item in ipairs(window:tabs_with_info()) do
                if item.is_active then
                        return item
                end
        end
end

return config
