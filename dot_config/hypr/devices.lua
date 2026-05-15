-- ENABLED

-- Touchpads
hl.device({
    name = "asuf1204:00-2808:0104-touchpad",
    natural_scroll = true,
    disable_while_typing = true,
    tap_to_click = true,
    sensitivity = 0.1,
    accel_profile = "flat",
    scroll_method = "2fg",
})

-- External mice
hl.device({
    name = "usb-optical-mouse",
    sensitivity = 0.1,
    natural_scroll = false,
})

hl.device({
    name = "razer-razer-deathadder-essential",
    sensitivity = 0.00001,
    natural_scroll = false,
    accel_profile = "flat",
})

-- Keyboards
-- Laptop keyboards
hl.device({
    name = "at-translated-set-2-keyboard",
})

-- External keyboards
hl.device({
    name = "compx-2.4g-receiver",
})

-- DISABLED
hl.device({
    name = "sleep-button",
    enabled = false,
})

hl.device({
    name = "power-button",
    enabled = false,
})

hl.device({
    name = "power-button-1",
    enabled = false,
})
