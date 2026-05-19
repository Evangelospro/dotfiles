-- ENABLED

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
