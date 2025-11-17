return {
  'karb94/neoscroll.nvim',
  opts = {
    -- EXCLUDE all custom-handled mappings from defaults
    mappings = {
      -- '<C-b>',
      -- '<C-f>',
      -- '<C-y>',
      -- '<C-e>',
    },
    hide_cursor = true,
    stop_eof = true,
    easing = 'sine',
    duration_multiplier = 0.5,
    pre_hook = nil,
    post_hook = nil,
  },

  config = function(_, opts)
    local neoscroll = require 'neoscroll'
    local original_scrolloff = vim.opt.scrolloff:get()

    -- Base duration for all smooth scrolls
    local scroll_duration = 250

    -- Base options for smooth scroll, including all duration-related keys
    local base_scroll_opts = {
      duration = scroll_duration,
      half_win_duration = scroll_duration,
      easing = 'sine',
      move_cursor = true,
    }

    -- 1. REFINED HOOKS: Only apply 'zz' if the 'center_final' flag is set
    opts.pre_hook = function(info)
      -- Only set scrolloff=0 if we intend to center the line
      if info and info.center_final then
        vim.opt.scrolloff = 0
      end
    end

    opts.post_hook = function(info)
      -- ONLY run zz and restore scrolloff if the 'center_final' flag is set
      if info and info.center_final then
        vim.cmd 'normal! zz'
        vim.opt.scrolloff = original_scrolloff
        -- Also need to restore scrolloff for zt/zb, which only used the pre_hook
      elseif info and info.restore_scrolloff then
        vim.opt.scrolloff = original_scrolloff
      end
    end

    neoscroll.setup(opts) -- Apply all options

    -- Helper to create the combined options table for ZZ, C-d, C-u (Needs final centering)
    local function get_centering_opts()
      -- We set 'center_final = true' which triggers the zz command in the post_hook
      return vim.tbl_extend('force', {}, base_scroll_opts, { info = { center_final = true } })
    end

    -- Helper to create the combined options table for ZT, ZB (Needs scrolloff restoration only)
    local function get_zt_zb_opts()
      -- We set 'restore_scrolloff = true' which restores the original scrolloff value
      return vim.tbl_extend('force', {}, base_scroll_opts, { info = { restore_scrolloff = true } })
    end

    -- 2. CUSTOM SCROLL FUNCTIONS (C-d/C-u) - Uses Centering Opts

    local half_window_lines = function()
      return math.floor(vim.fn.winheight(0) / 2)
    end

    local function scroll_down_and_center()
      neoscroll.new_scroll(half_window_lines(), get_centering_opts())
    end

    local function scroll_up_and_center()
      neoscroll.new_scroll(-half_window_lines(), get_centering_opts())
    end

    -- 3. CUSTOM Z-COMMAND FUNCTIONS

    -- zz: Must use Centering Opts (Triggers zz command in post_hook)
    local function custom_zz()
      neoscroll.zz(get_centering_opts())
    end

    -- zt/zb: Must use ZT/ZB Opts (Restores scrolloff but DOES NOT run zz)
    local function custom_zt()
      neoscroll.zt(get_zt_zb_opts())
    end

    local function custom_zb()
      neoscroll.zb(get_zt_zb_opts())
    end

    -- 4. APPLY CUSTOM KEYMAPS

    vim.keymap.set('n', '<C-d>', scroll_down_and_center, { desc = 'Smooth half-page down and center' })
    vim.keymap.set('n', '<C-u>', scroll_up_and_center, { desc = 'Smooth half-page up and center' })

    -- These now work as intended: zz centers, zt/zb place cursor at top/bottom.
    vim.keymap.set('n', 'zz', custom_zz, { desc = 'Smooth center view' })
    vim.keymap.set('n', 'zt', custom_zt, { desc = 'Smooth top view' })
    vim.keymap.set('n', 'zb', custom_zb, { desc = 'Smooth bottom view' })
  end,
}
