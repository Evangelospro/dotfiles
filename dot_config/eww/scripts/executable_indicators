#!/usr/bin/env python3
import asyncio
import json
import os
import subprocess
import sys

import hyprland
from evdev import InputDevice, categorize, ecodes


class Indicators(hyprland.Events):
    def __init__(self):
        self.debug = sys.argv[1] if len(sys.argv) > 1 else ""
        self.c = hyprland.Config()
        self.layout = "US"
        self.layout_dict = {"Greek": "GR", "English (US)": "US"}
        self.KEYBOARD = "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        # CAPS_EVENT_ON: "type 17 (EV_LED), code 1 (LED_CAPSL), value 1"
        # CAPS_EVENT_OFF: "type 17 (EV_LED), code 1 (LED_CAPSL), value 0"
        self.keyboard = InputDevice(self.KEYBOARD)
        self.laptop_keyboard_name = "at-translated-set-2-keyboard"
        self.external_keyboard_name = "compx-2.4g-receiver"
        self.HOME = os.environ["HOME"]
        self.caps_lock = "inactive"
        self.num_lock = "active"  # enable numlock by default on startup
        self.caffeine_state = "inactive"
        self.swayidle_activate = "swayidle &"
        self.swayidle_deactivate = "pkill -9 swayidle"
        super().__init__()

    def logEvent(self, event):
        if self.debug == "debug":
            print(event)

    async def locks(self):
        async for ev in self.keyboard.async_read_loop():
            if ev.type == ecodes.EV_LED:
                value = ev.value
                if ev.code == ecodes.LED_CAPSL:
                    self.logEvent(f"Caps lock: {value}")
                    self.caps_lock = "active" if value == 1 else "inactive"
                if ev.code == ecodes.LED_NUML:
                    self.logEvent(f"Num lock: {value}")
                    self.num_lock = "active" if value == 1 else "inactive"

    async def swayidleUpdate(self):
        try:
            subprocess.check_output(["pgrep", "swayidle"])
        except subprocess.CalledProcessError:
            self.caffeine_state = "active"
            self.logEvent("Swayidle is not running")
        else:
            self.caffeine_state = "inactive"
            self.logEvent("Swayidle is running")

    async def update_periodically(self, function, interval):
        while True:
            await function()
            await asyncio.sleep(interval)

    async def on_activelayout(self, keyboard, layout):
        if keyboard == self.laptop_keyboard_name or keyboard == self.external_keyboard_name:
            self.layout = self.layout_dict[layout]
        if self.debug == "debug":
            print(f"Keyboard: {keyboard}")
            print(f"Layout: {self.layout}")
        await self.generateJSON()

    async def generateJSON(self):
        print(
            json.dumps(
                {
                    "caps_lock": self.caps_lock,
                    "num_lock": self.num_lock,
                    "caffeine_state": self.caffeine_state,
                    "caffeine_command": self.swayidle_activate
                    if self.caffeine_state == "active"
                    else self.swayidle_deactivate,
                    "layout": self.layout,
                }
            ),
            flush=True,
        )

    async def on_connect(self):
        if self.debug == "debug":
            print("Connected to Hyprland socket")
        self.c = await hyprland.Config.from_conf()

        DELAY = 0.5

        asyncio.create_task(self.update_periodically(self.swayidleUpdate, DELAY))

        asyncio.create_task(self.update_periodically(self.locks, DELAY))

        asyncio.create_task(self.update_periodically(self.generateJSON, DELAY))


indicators = Indicators()

indicators.async_connect()
