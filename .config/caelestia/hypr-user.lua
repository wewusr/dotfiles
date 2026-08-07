hl.config({
    input = {
        kb_layout = "us,ara",
    },
})

hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"), { locked = true })
