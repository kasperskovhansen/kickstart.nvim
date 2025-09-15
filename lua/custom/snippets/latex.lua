local ls = require 'luasnip'
-- Define a snippet, e.g., for the "align" environment
ls.add_snippets('tex', {
  s(
    {
      trig = 'aligggn',
      dscr = 'align environment',
    },
    t(
      [[
  \begin{align}
    <>
  \end{align}
  ]],
      { i(1) }
    )
  ),
})

-- Extend Markdown to use tex snippets
ls.filetype_extend('markdown', { 'tex' })
