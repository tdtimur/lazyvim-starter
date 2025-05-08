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
            name = "openai",
            schema = {
              model = {
                default = "gpt-4o-mini",
              },
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            name = "gemini",
            schema = {
              model = {
                order = 1,
                mapping = "parameters",
                type = "enum",
                desc =
                "The model that will complete your prompt. See https://ai.google.dev/gemini-api/docs/models/gemini#model-variations for additional details and options.",
                default = "gemini-2.5-flash-preview-04-17",
                choices = {
                  "gemini-2.5-pro-exp-03-25",
                  "gemini-2.0-flash",
                  "gemini-2.0-pro-exp-02-05",
                  "gemini-1.5-flash",
                  "gemini-1.5-pro",
                  "gemini-1.0-pro",
                },
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
