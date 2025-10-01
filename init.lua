-- ------------------------------------------------------ --
-- ╔════════════════════════════════════════════════════╗ --
-- ║ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ║ -- 
-- ║ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ║ -- 
-- ║ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ║ -- 
-- ║ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ║ -- 
-- ║ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ║ -- 
-- ║ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ║ -- 
-- ╚════════════════════════════════════════════════════╝ -- 
-- ------------------------------------------------------ --

-- Bootstrap lazy.nvim -------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader keys ---------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Statusline ---------------------------------------------------------------
vim.o.statusline = table.concat({
  " %<%F",               -- file path
  " %= ",                -- right align
  "%{&expandtab ? 'spaces:' . &shiftwidth : 'tabs:' . &tabstop}", -- indent style
  " %5l / %2L ",         -- line / total
})

-- Basic settings ------------------------------------------------------------
vim.o.number = true
vim.o.cursorcolumn = true
vim.o.cursorline = true
vim.o.relativenumber = true
vim.o.showmatch = true
vim.o.wrap = false
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.hlsearch = true
vim.o.scrolloff = 5

-- Better up/down ------------------------------------------------------------
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Setup lazy.nvim -----------------------------------------------------------
require("lazy").setup({
  spec = {
    "psliwka/vim-smoothie",
    "folke/ts-comments.nvim",

    {
      "tpope/vim-sleuth",
    },

    {
      "catppuccin/nvim",
      lazy = true,
      priority = 1000,
      name = "catppuccin",
      opts = {
        lsp_styles = {
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        integrations = {
          aerial = true,
          alpha = true,
          cmp = true,
          dashboard = true,
          flash = true,
          fzf = true,
          grug_far = true,
          gitsigns = true,
          headlines = true,
          illuminate = true,
          indent_blankline = { enabled = true },
          leap = true,
          lsp_trouble = true,
          mason = true,
          mini = true,
          navic = { enabled = true, custom_bg = "lualine" },
          neotest = true,
          neotree = true,
          noice = true,
          notify = true,
          snacks = true,
          telescope = true,
          treesitter_context = true,
        },
      },
      specs = {
        {
          "akinsho/bufferline.nvim",
          optional = true,
          opts = function(_, opts)
            if (vim.g.colors_name or ""):find("catppuccin") then
              opts.highlights = require("catppuccin.special.bufferline").get_theme()
            end
          end,
        },
      },
    },

    {
      "numToStr/Comment.nvim",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("Comment").setup()
      end
    },

    {
      "echasnovski/mini.pairs",
      version = "*",
      config = function()
        require("mini.pairs").setup()
      end,
    },

    {
      "andrewferrier/wrapping.nvim",
      config = function()
        require("wrapping").setup({
          softener = { markdown = true, text = true },
          create_keymaps = true,
          keymaps = {
            motion = true,
            text_obj = true,
          },
        })
      end,
    },

    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        render_modes = { 'n', 'c', 't', 'i' },
        code = {
          sign = false,
          width = "block",
          right_pad = 1,
        },
        heading = {
          sign = false,
          icons = {},
        },
        checkbox = {
          enabled = false,
        },
      },
      ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
      config = function(_, opts)
        require("render-markdown").setup(opts)
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if not ok then
          vim.notify("nvim-treesitter not available", vim.log.levels.WARN)
          return
        end
        configs.setup({
          highlight = { enable = true },
          indent = { enable = true },
          ensure_installed = {
            "bash", "c", "diff", "html", "javascript", "json",
            "lua", "markdown", "markdown_inline", "python",
            "query", "regex", "toml", "tsx", "typescript",
            "vim", "vimdoc", "yaml",
          },
        })
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if not ok then return end
        configs.setup({
          textobjects = {
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
              },
              goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
              },
            },
          },
        })
      end,
    },

    {
      "folke/noice.nvim",
      dependencies = { "MunifTanjim/nui.nvim" },
      config = function()
        require("noice").setup({
          notify = { enabled = true },
          presets = {
            bottom_search = false,
            command_palette = true,
            long_message_to_split = true,
          },
        })

        local map = vim.keymap.set
        map("n", "<leader>n", "<cmd>Noice history<cr>", { desc = "Notification History" })
        map("n", "<leader>un", "<cmd>Noice dismiss<cr>", { desc = "Dismiss All Notifications" })
      end,
    },
  },

  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = false },
      scope = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
    },
  },

  checker = { enabled = true, notify = false },
  change_detection = { enabled = true, notify = false },
  ui = { wrap = true },
})

-- Intelligent Commenting ----------------------------------------------------
local api = require("Comment.api")

vim.keymap.set("n", "<C-/>", function()
  local count = vim.v.count1
  for _ = 1, count do
    api.toggle.linewise.current()
    vim.cmd("normal! j")
  end
end, { noremap = true, silent = true })

vim.keymap.set("x", "<C-/>", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  api.toggle.linewise(vim.fn.visualmode())
  vim.cmd("normal! j")
end, { noremap = true, silent = true })

vim.keymap.set("i", "<C-/>", function()
  vim.cmd("stopinsert")
  api.toggle.linewise.current()
  vim.cmd("normal! jA")
end, { noremap = true, silent = true })

require("catppuccin").setup({
  compile_path = vim.fn.stdpath("cache") .. "/catppuccin"
})

vim.cmd.colorscheme "catppuccin-macchiato"
