vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>");
vim.keymap.set("n", "<leader>t", function()
	vim.cmd('split');
	vim.cmd('wincmd j');
	vim.cmd('resize 10');
	vim.cmd('term');
	vim.cmd('startinsert');
end, {noremap = true, silent = true});

vim.keymap.set('n', 'U', function() vim.cmd('redo') end, {noremap=true});

vim.keymap.set('n', 'G', 'Gzz', {noremap=true, silent=true});

vim.keymap.set('n', "<C-s>", '<CMD>w<CR>', {noremap=true, silent=true});
vim.keymap.set('n', "<C-x>", '<CMD>q<CR>', {noremap=true, silent=true});

vim.keymap.set('n', "<leader>of", function()
        local path = vim.fn.expand("%:p");
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
        vim.fn.jobstart({
                "C:/Program Files/Firefox Nightly/firefox.exe",
                final_path,
        }, { detach = true });
end, { silent = true, noremap=true });
