local rust_analyzer = require "configs.lsp.server-settings.rust_analyzer"
local config = {

  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  -- Set colorscheme
  --[[ colorscheme = "default_theme", ]]

  -- Override highlight groups in any theme
  highlights = {
    -- duskfox = { -- a table of overrides
    --   Normal = { bg = "#000000" },
    -- },
    default_theme = function(highlights) -- or a function that returns one
      local C = require "default_theme.colors"

      highlights.Normal = { fg = C.fg, bg = C.bg }
      return highlights
    end,
  },

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
      relativenumber = true, -- sets vim.opt.relativenumber

      foldcolumn = "1",
      foldlevel = 99,
      foldlevelstart = 99,
      foldenable = true,
      --[[ foldmethod = "expr", ]]
      --[[ foldexpr = "nvim_treesitter#foldexpr()", ]]
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      minimap_auto_start = 1,
      minimap_width = 10,
      minimap_auto_start_win_enter = 1,
    },
  },

  -- Default theme configuration
  default_theme = {
    diagnostics_style = { italic = true },
    -- Modify the color table
    colors = {
      fg = "#abb2bf",
    },
    plugins = { -- enable or disable extra plugin highlighting
      aerial = true,
      beacon = false,
      bufferline = true,
      dashboard = true,
      highlighturl = true,
      hop = false,
      indent_blankline = true,
      lightspeed = false,
      ["neo-tree"] = true,
      notify = true,
      ["nvim-tree"] = false,
      ["nvim-web-devicons"] = true,
      rainbow = true,
      symbols_outline = false,
      telescope = true,
      vimwiki = false,
      ["which-key"] = true,
    },
  },

  -- Disable AstroNvim ui features
  ui = {
    nui_input = true,
    telescope_select = true,
  },

  -- Configure plugins
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    init = {
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },

      -- You can also add new plugins here as well:
      {
        "fladson/vim-kitty",
      },
      { "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" },
      {
        "phaazon/hop.nvim",
        branch = "v2", -- optional but strongly recommended
        config = function()
          -- you can configure Hop the way you like here; see :h hop-config
          require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
        end,
      },
      {
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
      },
      {
        "wfxr/minimap.vim",
      },
      {
        "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async",
        --[[ config = function() ]]
        --[[   require("ufo").setup { ]]
        --[[     provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end, ]]
        --[[   } ]]
        --[[ end, ]]
      },
      --[[ { "rrethy/nvim-base16" }, ]]
      {
        "nvim-orgmode/orgmode",
        config = function()
          require("orgmode").setup {
            require("orgmode").setup_ts_grammar(),
            org_agenda_files = { "~/Desktop/org/*" },
            org_default_notes_file = "~/Desktop/org/inbox.org",
          }
        end,
      },
      {
        "olimorris/onedarkpro.nvim",
        config = function() require("onedarkpro").setup() end,
      },
      {
        "ray-x/go.nvim",
        event = "VimEnter",
        config = function() require("go").setup() end,
      },
      {
        "ray-x/guihua.lua",
      },
      -- {
      --   "github/copilot.vim",
      --   --[[ config = function() require("copilot").setup() end, ]]
      -- },
      -- { "andweeb/presence.nvim" },
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },
    },
    -- All other entries override the setup() call for default plugins
    ["neo-tree"] = function(config)
      config.window.position = "right"
      return config
    end,

    ["null-ls"] = function(config)
      local null_ls = require "null-ls"
      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      config.sources = {
        -- Set a formatter
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
      }
      -- set up null-ls's on_attach function
      config.on_attach = function(client)
        -- NOTE: You can remove this on attach function to disable format on save
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end
      return config -- return final config table
    end,

    treesitter = {
      ensure_installed = { "lua", "org" },
      --[[ run = ":TSUpdate", ]]
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "org" }, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
      },
      require("ufo").setup {
        provider_selector = function(bufnr, filetype) return { "treesitter", "indent" } end,
      },
    },
    -- use mason-lspconfig to configure LSP installations
    ["mason-lspconfig"] = {
      ensure_installed = { "sumneko_lua" },
    },
    -- use mason-tool-installer to configure DAP/Formatters/Linter installation
    ["mason-tool-installer"] = {
      ensure_installed = { "prettier", "stylua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "data" .. "/packer_compiled.lua",
    },
    gitsigns = {
      current_line_blame = true,
    },
  },
  -- LuaSnip Options
  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {
      "./lua/user/snippets",
    },
    -- Extend filetypes
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  cinnamon = {
    extra_keymaps = true,
    extended_keymaps = true,
    default_delay = 1,
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- easily add or disable built in mappings added during LSP attaching
    mappings = {
      n = {
        -- ["<leader>lf"] = false -- disable formatting keymap
      },
    },
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server].setup(opts)
    -- end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      rust_analyzer = {
        rust_analyzer,
      },
      -- example for addings schemas to yamlls
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- Mapping data with "desc" stored directly by vim.keymap.set().
  --
  -- Please use this mappings table to set keyboard mapping since this is the
  -- lower level configuration and more robust one. (which-key will
  -- automatically pick-up stored data by this setting.)
  mappings = {
    -- first key is the mode
    n = {
      -- second key is the lefthand side of the map
      -- mappings seen under group name "Buffer"
      ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
      ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
      ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
      ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
      -- quick save
      -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
      -- ["<leader>j"] = { "<cmd>copilot#Accept<cr>", desc = "Copilot Accept" },
      -- ["<C-J>"] = { "copilot#Accept(<Tab>)", silent = true, expr = true, script = true },
      --[[ ["zR"] = { "<cmd>lua require('ufo').openAllFolds<cr>", desc = "ufo openAllFolds" }, ]]
      --[[ ["zM"] = { "<cmd>lua require('ufo').closeAllFolds()<cr>", desc = "ufo closeAllFolds" }, ]]
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
    i = {
      -- ["<C-J>"] = { "copilot#Accept(<Tab>)", silent = true, expr = true, script = true },
    },
  },

  -- Modify which-key registration (Use this with mappings table in the above.)
  ["which-key"] = {
    -- Add bindings which show up as group name
    register_mappings = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- third key is the key to bring up next level and its displayed
          -- group name in which-key top level menu
          ["b"] = { name = "Buffer" },
        },
      },
    },
  },

  -- This function is run last
  -- good place to configuring augroups/autocommands and custom filetypes
  polish = function()
    -- Set key binding
    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })

    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap("i", "<C-e>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    vim.g.copilot_assume_mapped = true
    --
    -- Run gofmt + goimport on save
    vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

    vim.cmd "colorscheme onedarkpro"

    -- Load custom tree-sitter grammar for org filetype
    -- require("orgmode").setup_ts_grammar()

    -- vim.cmd "Neotree position=right"

    --[[ vim.cmd "colorscheme base16-monokai" ]]

    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

return config
