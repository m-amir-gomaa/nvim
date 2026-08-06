return {
    "m-amir-gomaa/mathwiz",
    lazy = false,
    priority = 1000,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("mathviz").setup({
            enabled = true,
            math_mode = {
                enabled_by_default = true,
            },
        })
    end,
}
