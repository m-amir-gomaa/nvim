-- Markdown browser preview with full MathJax ($...$ rendering)
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  init = function()
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_refresh_slow = 1
    vim.g.mkdp_browser = ""
    vim.g.mkdp_echo_preview_url = 1
  end,
  keys = {
    { "<leader>M", "<cmd>MarkdownPreviewToggle<CR>", mode = "n", desc = "Preview (MathJax)" },
  },
}
