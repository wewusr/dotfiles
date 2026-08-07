hl.config({
    input = {
        kb_layout    = "us,ara",
        repeat_rate  = 25,
        repeat_delay = 600,
    },
})

hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"), { locked = true })
