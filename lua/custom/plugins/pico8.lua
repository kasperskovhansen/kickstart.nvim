local configs = require 'lspconfig.configs'
-- vim.filetype.add { extension = { p8 = 'p8' } }
if not configs.pico8_ls then
  configs.pico8_ls = {
    default_config = {
      cmd = { 'pico8-ls', '--stdio' },
      filetypes = { 'pico8', 'p8' },
      root_dir = function(fname)
        return vim.fs.dirname(fname)
      end,
      settings = {},
    },
  }
end

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        pico8_ls = {}, -- enable it
      },
      setup = {
        pico8_ls = function(_, opts)
          require('lspconfig').pico8_ls.setup(opts)
          return true
        end,
      },
    },
  },
}
