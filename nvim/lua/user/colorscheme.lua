local M = {
  "shaunsingh/nord.nvim",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

M.name = "nord"
function M.config()
  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    print("Colorscheme not found!") -- Print an error message if the colorscheme is not installed
    return
  end
end

return M
