local ls = require 'luasnip'

-- Jump forward
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if ls.jumpable(1) then
    ls.jump(1)
  else
    return '<Tab>'
  end
end, { expr = true, silent = true })

-- Jump backward
vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    return '<S-Tab>'
  end
end, { expr = true, silent = true })
