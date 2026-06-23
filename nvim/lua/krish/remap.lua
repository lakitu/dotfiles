-- <leader>pv opens explorer
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>");


vim.keymap.set("n", "<leader>tn", "<CMD>tabnew<CR>");   -- <leader>tn opens a new tab
vim.keymap.set("n", "<leader>tx", "<CMD>tabclose<CR>"); -- <leader>tx closes current tab
vim.keymap.set("n", "<leader>tl", "<CMD>tabnext<CR>");  -- <leader>tl goes to right tab
vim.keymap.set("n", "<leader>th", "<CMD>tabNext<CR>");  -- <leader>th goes to left tab
-- -- <leader>t opens terminal below
-- vim.keymap.set("n", "<leader>t", function()
-- 	vim.cmd('split');
-- 	vim.cmd('wincmd j');
-- 	vim.cmd('resize 10');
-- 	vim.cmd('term');
-- 	vim.cmd('startinsert');
-- end, {noremap = true, silent = true});

-- <shift>u is redo
vim.keymap.set('n', 'U', function() vim.cmd('redo') end, {noremap=true});

-- G now centers on screen
vim.keymap.set('n', 'G', 'Gzz', {noremap=true, silent=true});

-- ctrl + / is comment/uncomment
vim.keymap.set('n', '<C-/>', 'gcc', { remap = true })
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true })
vim.keymap.set('v', '<C-/>', 'gc', { remap = true })
vim.keymap.set('v', '<C-_>', 'gc', { remap = true })

-- <leader>of opens the file in firefox
vim.keymap.set('n', "<leader>of", function()
        local path = vim.fn.expand("%:p");
        print(path)
        local is_oil_buf = string.find(path, "^oil:///") == 1;
        local final_path;
        if not is_oil_buf then
                final_path = "file:///" .. path
        else
                local cursor_entry = require("oil").get_cursor_entry();
                local file_name = cursor_entry and cursor_entry.name or "";
                local dir_path = string.sub(path, 9, -1); -- get rid of "oil:///C"
                final_path = "file:///C:" .. dir_path .. file_name;

        end

        if vim.fn.has('win32') == 1 then
                browser_path="C:/Program Files/Firefox Nightly/firefox.exe"
        else
                browser_path="/mnt/c/Program Files/Firefox Nightly/firefox.exe"
        end
        vim.fn.jobstart({ browser_path, final_path, }, { detach = true });

end, { silent = true, noremap=true });
