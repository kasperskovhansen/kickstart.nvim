-- ~/.config/nvim/lua/snippets/castel_math.lua

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep
local conds = require 'luasnip.extras.expand_conditions'

-- detect if inside math in markdown
local function in_math()
  if vim.bo.filetype == 'tex' then
    return true
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col)
  local after = line:sub(col + 1)
  local inline = before:match '%$[^%$]*$' and after:match '^[^%$]*%$'
  local display = (before:match '%$%$[^%$]*$' and after:match '^[^%$]*%$%$') or (before:match '\\%[[^%]]*$' and after:match '^[^%]]*\\%]')
  return inline or display
end

-- capture helper
local function CAP(n)
  return f(function(_, snip)
    return snip.captures[n]
  end)
end

-- ==================== Castel Snippets ====================

-- Begin environment
local env = s({ trig = 'beg', snippetType = 'autosnippet' }, fmt('\\begin{{{}}}\n\t{}\n\\end{{{}}}', { i(1), i(0), rep(1) }), { condition = conds.line_begin })

-- Inline and display math (useful in markdown too)
local mk = s({ trig = 'mk', snippetType = 'autosnippet' }, fmt('${}$ {}', { i(1), i(0) }))
local dm = s({ trig = 'dm', snippetType = 'autosnippet' }, fmt('\\[\n{}\n\\] {}', { i(1), i(0) }))

-- Subscripts
local sub1 = s(
  { trig = '([A-Za-z])(\\d)', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
  fmt('{}_{}{}', { CAP(1), CAP(2), i(0) }),
  { condition = in_math }
)
local sub2 = s(
  { trig = '([A-Za-z])_(%d%d)', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
  fmt('{}_{{{}}}{}', { CAP(1), CAP(2), i(0) }),
  { condition = in_math }
)

-- Superscripts
local sr = s({ trig = 'sr', snippetType = 'autosnippet' }, t '^2', { condition = in_math })
local cb = s({ trig = 'cb', snippetType = 'autosnippet' }, t '^3', { condition = in_math })
local compl = s({ trig = 'compl', snippetType = 'autosnippet' }, t '^{c}', { condition = in_math })
local td = s({ trig = 'td', snippetType = 'autosnippet' }, fmt('^{{{}}}{}', { i(1), i(0) }), { condition = in_math })

-- Fractions
local frac_plain = s({ trig = '//', snippetType = 'autosnippet' }, fmt('\\frac{{{}}}{{{}}}{}', { i(1), i(2), i(0) }), { condition = in_math })
local frac_expr = s(
  { trig = '([%w\\_%^%{%}]+)/', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
  fmt('\\frac{{{}}}{{{}}}{}', { CAP(1), i(1), i(0) }),
  { condition = in_math }
)

-- Bars, hats, vectors
local bar_prefix = s({ trig = 'bar', snippetType = 'autosnippet', priority = 10 }, fmt('\\overline{{{}}}{}', { i(1), i(0) }), { condition = in_math })
local hat_prefix = s({ trig = 'hat', snippetType = 'autosnippet', priority = 10 }, fmt('\\hat{{{}}}{}', { i(1), i(0) }), { condition = in_math })
local bar_post = s(
  { trig = '([A-Za-z])bar', regTrig = true, wordTrig = false, snippetType = 'autosnippet', priority = 100 },
  fmt('\\overline{{{}}}', { CAP(1) }),
  { condition = in_math }
)
local hat_post = s(
  { trig = '([A-Za-z])hat', regTrig = true, wordTrig = false, snippetType = 'autosnippet', priority = 100 },
  fmt('\\hat{{{}}}', { CAP(1) }),
  { condition = in_math }
)
local vec_post = s(
  { trig = '(\\?%w+)(,%.|%.,)', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
  f(function(_, snip)
    return '\\vec{' .. snip.captures[1] .. '}'
  end),
  { condition = in_math }
)

-- Other helpers
local mapsto = s({ trig = '!>', snippetType = 'autosnippet' }, t '\\mapsto', { condition = in_math })
local toarrow = s({ trig = '->', snippetType = 'autosnippet' }, t '\\to', { condition = in_math })
local subset = s({ trig = 'cc', snippetType = 'autosnippet' }, t '\\subset', { condition = in_math })
local infinity = s({ trig = 'ooo', snippetType = 'autosnippet' }, t '\\infty', { condition = in_math })

local lim = s({ trig = 'lim', wordTrig = true, snippetType = 'autosnippet' }, fmt('\\lim_{{{} \\to \\infty}} {}', { i(1, 'n'), i(0) }), { condition = in_math })
local sum = s(
  { trig = 'sum', wordTrig = true, snippetType = 'autosnippet' },
  fmt('\\sum_{{{} = 1}}^{{\\infty}} {}', { i(1, 'n'), i(0) }),
  { condition = in_math }
)

ls.filetype_extend('markdown', { 'tex' })
-- ==================== Register ====================

ls.add_snippets('tex', {
  env,
  mk,
  dm,
  sub1,
  sub2,
  sr,
  cb,
  compl,
  td,
  frac_plain,
  frac_expr,
  bar_prefix,
  hat_prefix,
  bar_post,
  hat_post,
  vec_post,
  mapsto,
  toarrow,
  subset,
  infinity,
  lim,
  sum,
})

ls.add_snippets('markdown', {
  mk,
  dm,
  sub1,
  sub2,
  sr,
  cb,
  compl,
  td,
  frac_plain,
  frac_expr,
  bar_prefix,
  hat_prefix,
  bar_post,
  hat_post,
  vec_post,
  mapsto,
  toarrow,
  subset,
  infinity,
  lim,
  sum,
})
