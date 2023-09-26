#!/usr/bin/env python3

# Author: https://github.com/Evangelospro

import json
import os
import re
import subprocess
import sys

import hyprland


class Appnames(hyprland.Events):
    def __init__(self):
        # Initialize hyprland
        self.i = hyprland.info.Info()
        self.c = hyprland.Config()
        super().__init__()

        # Initialize variables
        self.windowNames = json.loads(open(os.path.expanduser("~/.config/eww/scripts/windowNames.json")).read())
        self.monitormap = {}
        self.targetMonitor = sys.argv[1]
        self.monitor_event()

        # check if target monitor is a number if it is not output usage
        if re.match("^[0-9]+$", self.targetMonitor):
            self.targetMonitor = int(self.targetMonitor)
        else:
            print("Usage: python script.py [0|1]")
            sys.exit(1)

        self.debug = sys.argv[2] if len(sys.argv) > 2 else ""

        self.appgridIcon = "/usr/share/icons/Papirus/22x22/apps/appgrid.svg"
        self.focusedMon = self.targetMonitor
        self.currClass = ""
        self.currIconPath = ""
        self.currTitle = ""

    def getIcon(self, class_name):
        # Attempt to use any manually set icons
        if self.windowNames.get(class_name) is not None:
            icon = self.windowNames[class_name]["icon"]
            if os.path.exists(os.path.expanduser(icon)):
                return os.path.expanduser(icon)
            else:
                class_name = icon
        # attempt to get icon from geticons, with the provided class_name
        icon_list = (
            subprocess.check_output(["geticons", "--no-fallbacks", class_name, "-s", "22", "-c", "1"])
            .decode()
            .splitlines()
        )
        icon = icon_list[0] if icon_list else None
        # if icon is not found, try again with the class_name in lowercase
        if icon is None:
            lowerClass = class_name.lower()
            icon_list = (
                subprocess.check_output(["geticons", "--no-fallbacks", lowerClass, "-s", "22", "-c", "1"])
                .decode()
                .splitlines()
            )
            icon = icon_list[0] if icon_list else None
        if icon is None and class_name.strip() != "":
            # send a notification that icon with class_name was not found
            # subprocess.Popen(
            # 	[
            # 		"notify-send",
            # 		"-u",
            # 		"critical",
            # 		"-t",
            # 		"5000",
            # 		f"Icon not found for {class_name} manually fix in windowNames.json",
            # 	]
            # )
            icon = self.appgridIcon
        return icon

    def getActiveWindow(self):
        return json.loads(subprocess.check_output(["hyprctl", "-j", "activewindow"]).decode())

    # handle monitor (dis)connects
    def monitor_event(self):
        with subprocess.Popen(["hyprctl", "-j", "monitors"], stdout=subprocess.PIPE) as proc:
            try:
                output = json.loads(proc.stdout.read().decode())
            except json.decoder.JSONDecodeError:
                return
        for monitor in output:
            id = int(monitor["id"])
            name = monitor["name"]
            self.monitormap[name] = id

    def logEvent(self, event):
        if self.debug == "debug":
            print(event)

    def generate(self):
        title = f"{self.currClass} | {self.currTitle}"
        if not self.currTitle or self.currTitle == "":
            self.currIconPath = self.appgridIcon
            title = "No focused window"
        print(json.dumps({"title": title, "icon": self.currIconPath}), flush=True)

    async def on_focusedmon(self, mon, ws):
        self.focusedMon = self.monitormap[mon]
        self.logEvent(f"monitor changed to {self.focusedMon} target: {self.targetMonitor}")
        if self.focusedMon == self.targetMonitor:
            self.focusedws = int(ws)
            # self.generate()

    async def on_activewindow(self, *args):
        try:
            activeWindow = self.getActiveWindow()
            # self.logEvent(f"activewindow JSON: {activeWindow}")
        except subprocess.CalledProcessError:
            self.logEvent("hyprctl failed")
            return
        if activeWindow:
            window_class = activeWindow["class"]
            window_title = activeWindow["title"]
            self.focusedMon = activeWindow["monitor"]
            self.logEvent(
                f"window changed to {window_class} with title {window_title} on monitor {self.focusedMon} target: {self.targetMonitor}"
            )
            if self.focusedMon == self.targetMonitor:
                # get icon before changing currClass
                self.currIconPath = self.getIcon(window_class)
                try:
                    candidateName = self.windowNames[window_class]["name"]
                    self.currClass = candidateName
                except KeyError:
                    self.currClass = window_class
                self.currTitle = window_title
                self.generate()

    async def on_closewindow(self, window_address):
        self.logEvent(f"window with address {window_address} destroyed")
        if self.focusedMon == self.targetMonitor:
            self.currClass = ""
            self.currTitle = ""
            self.generate()

    async def on_movewindow(self, window_address, workspace):
        self.logEvent(f"window with address {window_address} moved to workspace {workspace}")
        self.focusedMon = 0 if workspace < 10 else 1
        self.generate()

    async def om_focusedmon(self, mon, ws):
        self.focusedMon = self.monitormap[mon]
        self.logEvent(f"monitor changed to {self.focusedMon} target: {self.targetMonitor}")
        if self.focusedMon == self.targetMonitor:
            self.focusedws = int(ws)
            self.generate()


a = Appnames()

a.async_connect()
