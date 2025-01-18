return {
  'nvim-lualine/lualine.nvim',
  optional = true,
  opts = function(_, opts)
    local trouble = require("trouble")
    if not trouble.statusline then
      LazyVim.error("You have enabled the **trouble-v3** extra,\nbut still need to update it with `:Lazy`")
      return
    end

    local symbols = trouble.statusline({
      mode = "symbols",
      groups = {},
      title = false,
      filter = { range = true },
      format = "{kind_icon}{symbol.name:Normal}",
      hl_group = "lualine_c_normal",
    })
    table.insert(opts.sections.lualine_c, {
      symbols.get,
      cond = symbols.has,
    })
    table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("codeium"))
  end,
}
