return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function(_, opts)
            require("luasnip").setup(opts)
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
        end,
    },
}
