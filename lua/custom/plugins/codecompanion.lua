return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        adapter = "claude_code",
      },
      inline = {
        adapter = "claude_code",
        layout = "vsplit",
      },
    },
    display = {
      chat = {
        show_settings = false,
        show_token_count = false,
        window = {
          layout = "vertical",
          width = 0.3,
        },
      },
    },
    opts = {
      log_level = "error",
      send_code = true,
    },
  },
  keys = {
    { "<leader>ct", "<cmd>CodeCompanionChat<CR>", mode = { "n", "v" }, desc = "Chat (Claude+DeepSeek)" },
    { "<leader>ci", "<cmd>CodeCompanion<CR>", mode = { "n", "v" }, desc = "Inline Edit" },
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  event = "VeryLazy",
}
