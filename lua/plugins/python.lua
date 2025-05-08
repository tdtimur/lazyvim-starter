vim.g.python_host_prog = '/opt/homebrew/bin/python3.11'

return {
  -- Add `pyright` to mason
  -- TODO: check following tools -> mypy types-requests types-docutils
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- vim.list_extend(opts.ensure_installed, { "pyright", "black", "ruff-lsp", "ruff" })
      vim.list_extend(opts.ensure_installed, {
        "ruff",
        "ruff-lsp",
        "basedpyright"
      })
    end,
  },

  -- Setup adapters as nvim-dap dependencies
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method" },
        { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class" },
      },
      config = function()
        -- local path = require("mason-registry").get_package("debugpy"):get_install_path()
        local cwd = vim.fn.getcwd()
        -- require("dap-python").setup(path .. "/opt/homebrew/bin/python3")
        require("dap-python").setup(cwd .. "/.venv/bin/python")
      end,
    },
  },

  -- Add `python` debugger to mason DAP to auto-install
  -- Not absolutely necessary to declare adapter in `ensure_installed`, since `mason-nvim-dap`
  -- has `automatic-install = true` in LazyVim by default and it automatically installs adapters
  -- that are are set up (via dap) but not yet installed. Might as well skip the lines below as
  -- a whole.

  -- Add which-key namespace for Python debugging
  -- {
  --   "folke/which-key.nvim",
  --   optional = true,
  --   opts = {
  --     spec = {
  --       "<leader>dP", group = "Python"
  --     },
  --   },
  -- },

  -- Setup `neotest`
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },

  -- Add `server` and setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    opts = {
      servers = {
        basedpyright = { enabled = true },
        ruff_lsp = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
        },
        jedi_language_server = { mason = false, autostart = false },
        pyright = { mason = false, autostart = false },
        -- ruff_lsp = { mason = false, autostart = false },
      },
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
        basedpyright = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "basedpyright" then
              -- disable hover in favor of jedi-language-server
              client.server_capabilities.hoverProvider = true
            end
          end)
        end,
      },
    },
  },

  -- Setup null-ls with `black`
  -- {
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     opts.sources = vim.list_extend(opts.sources, {
  --       -- Order of formatters matters. They are used in order of appearance.
  --       nls.builtins.formatting.ruff,
  --       nls.builtins.formatting.black,
  --       -- nls.builtins.formatting.black.with({
  --       --   extra_args = { "--preview" },
  --       -- }),
  --       -- nls.builtins.diagnostics.ruff,
  --     })
  --   end,
  -- },

  -- For selecting virtual envs
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python",
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    branch = "regexp",
    config = function()
      require("venv-selector").setup({
        settings = {
          enable_cached_venvs = true,
          cached_venv_automatic_activation = true,
          notify_user_on_venv_activation = true,
        }
      })
    end,
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" },
    },
    -- cmd = "VenvSelect",
    -- opts = {
    --   dap_enabled = true,
    --   -- Path is relative to the project root under .venv directory
    --   path = ".venv",
    --   name = ".venv",
    -- },
    -- keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
  },
}
