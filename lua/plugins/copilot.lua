return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  enabled = false,
  opts = {
    suggestion = {
      enabled = false,
      auto_trigger = false,
      debounce = 2000,
    },
    panel = {
      enabled = false,
    },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}
