-- lua/plugins/vimtex.lua
return {
  'lervag/vimtex',
  lazy = false, -- Or set to `ft = { "tex", "markdown" }`
  init = function()
    -- This line is the magic. It tells vimtex to work in markdown files.
    vim.g.vimtex_filetypes = { 'markdown' }

    -- Optional: This helps vimtex identify the main file for multi-file projects.
    vim.g.vimtex_main_latex_file = 'main.tex'
  end,
  config = function()
    vim.g.tex_flavor = 'latex'
    vim.g.vimtex_view_method = 'skim'
    vim.g.vimtex_quickfix_mode = 0
    vim.opt.conceallevel = 1
    vim.g.tex_conceal = 'abdmg'
  end,
}
