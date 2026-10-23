return {
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                preset = "super-tab", -- Gives you Tab/S-Tab navigation and Enter to accept like VS Code
            },
            completion = {
                menu = {
                    border = "rounded",
                    draw = {
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = { border = "rounded" },
                },
                ghost_text = {
                    enabled = true, -- Enables VS Code-style grey inline ghost completion
                },
            },
        },
    },
}
