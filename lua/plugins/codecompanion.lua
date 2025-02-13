return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            name = "openai-4o-mini",
            schema = {
              model = {
                default = "gpt-4o-mini",
              },
            },
          })
        end
      },
      display = {
        chat = {
          show_settings = true,
        }
      },
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = "openai",
        },
        inline = {
          adapter = "openai",
        },
      },
      opts = {
        -- Set debug logging
        log_level = "DEBUG",
      },
    },
  },
}
