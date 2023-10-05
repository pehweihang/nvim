local opts = { noremap = true, silent = true }

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup({
          ---@usage set to false to disable project.nvim.
          --- This is on by default since it's currently the expected behavior.
          active = true,

          on_config_done = nil,

          ---@usage set to true to disable setting the current-woriking directory
          --- Manual mode doesn't automatically change your root directory, so you have
          --- the option to manually do so using `:ProjectRoot` command.
          manual_mode = false,

          ---@usage Methods of detecting the root directory
          --- Allowed values: **"lsp"** uses the native neovim lsp
          --- **"pattern"** uses vim-rooter like glob pattern matching. Here
          --- order matters: if one is not detected, the other is used as fallback. You
          --- can also delete or rearangne the detection methods.
          -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
          detection_methods = { "pattern" },

          ---@usage patterns used to detect root dir, when **"pattern"** is in detection_methods
          patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

          ---@ Show hidden files in telescope when searching for files in a project
          show_hidden = false,

          ---@usage When set to false, you will get a message when project.nvim changes your directory.
          -- When set to false, you will get a message when project.nvim changes your directory.
          silent_chdir = true,

          ---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
          ignore_lsp = {},

          ---@type string
          ---@usage path to store the project history for use in telescope
          datapath = vim.fn.stdpath("data"),
        })
      end,
    },
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-media-files.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "gbrlsnchs/telescope-lsp-handlers.nvim",
  },
  ft = { "alpha" },
  keys = {
    {
      "<leader>f",
      "<cmd>Telescope find_files previewer=false<cr>",
      mode = "n",
      opts,
    },
    { "<leader>t", "<cmd>Telescope live_grep<cr>",             mode = "n", opts },
    {
      "<leader>b",
      "<cmd>Telescope buffers previewer=false<cr>",
      mode = "n",
      opts,
    },
    { "<leader>d", "<cmd>Telescope diagnostics bufnr=0<CR>", mode = "n", opts },
    { "<leader>D", "<cmd>Telescope diagnostics<CR>",         mode = "n", opts },
  },
  config = function()
    local status_ok, telescope = pcall(require, "telescope")
    if not status_ok then
      return
    end

    telescope.load_extension("media_files")
    telescope.load_extension("fzf")
    telescope.load_extension("lsp_handlers")
    telescope.load_extension("projects")
    telescope.load_extension("file_browser")

    local actions = require("telescope.actions")
    local layout_actions = require("telescope.actions.layout")
    local fb_actions = require("telescope").extensions.file_browser.actions

    telescope.setup({
      defaults = {

        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },

        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "top",
          mirror = true,
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-p>"] = layout_actions.toggle_preview,

            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<C-c>"] = actions.close,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = function()
              vim.cmd([[:stopinsert]])
              vim.cmd([[call feedkeys("\<CR>")]])
            end,
            -- ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist,    -- + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist, -- + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key,         -- keys from pressing <C-/>
          },

          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-p>"] = layout_actions.toggle_preview,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

            ["?"] = actions.which_key,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
      },
      extensions = {
        media_files = {
          -- filetypes whitelist
          -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
          filetypes = { "png", "webp", "jpg", "jpeg" },
          find_cmd = "rg", -- find command (defaults to `fd`)
        },
        -- Your extension configuration goes here:
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
          mappings = {
            ["i"] = {
              -- your custom insert mode mappings
            },
            ["n"] = {
              ["c"] = fb_actions.create,
              ["r"] = fb_actions.rename,
              ["m"] = fb_actions.move,
              ["y"] = fb_actions.copy,
              ["d"] = fb_actions.remove,
              ["o"] = fb_actions.open,
            },
          },
        },
      },
    })
  end,
}
