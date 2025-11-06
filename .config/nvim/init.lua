local jai_bin_path = os.getenv("HOME") .. "/.jai/bin"
-- if not string.find(vim.env.PATH, jai_bin_path, 1, true) then
-- 	vim.env.PATH = vim.env.PATH .. ":" .. jai_bin_path
-- end

print(jai_bin_path)

vim.env.PATH = vim.env.PATH .. ":" .. jai_bin_path

--
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
