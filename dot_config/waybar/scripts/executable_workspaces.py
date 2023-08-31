#!/usr/bin/env python3

# Author: https://github.com/Evangelospro

import json
import os
import re
import subprocess
import sys
from svgutils.compose import *
import hyprland


class Workspacer(hyprland.Events):
    def __init__(self):
        # make a temp dir for icons
        self.iconsDir = "/tmp/waybar-icons"
        # ensure it exists and is empty
        os.makedirs(self.iconsDir, exist_ok=True)
        for f in os.listdir(self.iconsDir):
            os.remove(os.path.join(self.iconsDir, f))
        self.i = hyprland.info.Info()
        self.c = hyprland.Config()
        super().__init__()

        self.numOfWorkspaces = 10
        self.windowNames = json.loads(open(os.path.expanduser("~/.config/eww/scripts/windowNames.json")).read())

        self.monitormap = {}
        # set monitorMap
        self.monitor_event()

        self.debug = sys.argv[1] if len(sys.argv) > 1 else ""
        self.accentColor = "#bd93f9"
        self.workspaceRange = range(1, self.numOfWorkspaces + 1)
        self.focusedws = 1
        self.prevFocusedws = self.focusedws
        self.iconSize = 32
        self.appgridIcon = self.getIcon("appgrid")

        self.workspaces = {mon:
                    {ws:
                        {"status": "inactive-workspace",
                        "icons": [[], []]}
                        for ws in self.workspaceRange}
                    for mon in self.monitormap.keys()
                    }
        self.logEvent(f"workspaces {self.workspaces}")
        # generate initial widget
        self.generate()

    # handle monitor (dis)connects
    def monitor_event(self):
        with subprocess.Popen(["hyprctl", "-j", "monitors"], stdout=subprocess.PIPE) as proc:
            try:
                output = json.loads(proc.stdout.read().decode())
                for monitor in output:
                    id = int(monitor["id"])
                    name = monitor["name"]
                    self.monitormap[name] = id
            except Exception as e:
                self.logEvent(f"Failed to get monitor info with error {e}")
                pass

    def applistClass(self, ws, mon):
        with subprocess.Popen(["hyprctl", "-j", "clients"], stdout=subprocess.PIPE) as proc:
            try:
                clients = json.loads(proc.stdout.read().decode())
                classes = [
                    client["class"]
                    for client in clients
                    # % to take in to account the use of split-monitor-workspaces plugin
                    if client["workspace"]["id"] % self.numOfWorkspaces == ws and int(client["monitor"]) == self.monitormap[mon]
                ]
                self.logEvent(classes)
                return classes
            except Exception as e:
                self.logEvent(f"Failed to get applist classes info for mon: {mon} on ws: {ws} with error {e}")
                return []

    def getIcon(self, class_name):
        # Attempt to use any manually set icons
        if self.windowNames.get(class_name) is not None:
            icon = self.windowNames[class_name]["icon"]
            if os.path.exists(os.path.expanduser(icon)):
                return os.path.expanduser(icon)
            else:
                class_name = icon

        for class_name_test in [class_name, class_name.lower()]:
            icon_list = (
                subprocess.check_output(["geticons", "--no-fallbacks", class_name_test, "-s", str(self.iconSize), "-c", "1"])
                .decode()
                .splitlines()
            )
            if icon_list:
                icon = icon_list[0]
                break
        else:
            icon = self.appgridIcon
        return icon

    def setAppicons(self, ws, mon):
        self.workspaces[mon][ws]["icons"] = [[], []]
        classes = self.applistClass(ws, mon)[0:4]  # only render up to 4 icons
        for i, class_name in enumerate(classes):
            icon = self.getIcon(class_name)
            # first 2 icons go in first list and the other 2 in the second list
            self.workspaces[mon][ws]["icons"][0 if i < 2 else 1].append(icon)

    def generate(self):
        for mon in self.monitormap:
            self.logEvent(f"Fetching monitor: {mon}")
            for num in self.workspaceRange:
                self.setAppicons(num, mon)
                try:
                    top_panels = (Panel(
                        SVG(svg_path)
                    ).move(self.iconSize * i, 0) for i, svg_path in enumerate(self.workspaces[mon][num]["icons"][0]))
                    bottom_panels = (Panel(
                        SVG(svg_path)
                    ).move(self.iconSize * i, self.iconSize) for i, svg_path in enumerate(self.workspaces[mon][num]["icons"][1]))
                    self.logEvent(f"Generating image for workspace {num}")
                    x_len = self.iconSize if len(self.workspaces[mon][num]['icons'][0]) <= 1 else self.iconSize * 2
                    y_len = self.iconSize if len(self.workspaces[mon][num]['icons'][1]) == 0 else self.iconSize * 2
                    Figure(f"{x_len}px",
                        f"{y_len}px",
                        *top_panels,
                        *bottom_panels
                    ).save(f"{self.iconsDir}/workspace-{mon}-{num}.svg")
                    # set the svg background to purple if the workspace is active
                    if num == self.focusedws and mon == self.focusedMon:
                        # add <rect width="100%" height="10%" fill="self.accentColor"/>  after the <svg ...> tag
                        with open(f"{self.iconsDir}/workspace-{mon}-{num}.svg", "r+") as f:
                            content = f.read()
                            f.seek(0, 0)
                            f.write(
                                re.sub(
                                    r'<svg(.*?)>',
                                    r'<svg\1>\n<rect width="100%" height="100%" fill="' + self.accentColor + '"/>',
                                    content,
                                )
                            )
                    else:
                        pass

                except Exception as e:
                    self.logEvent(f"Failed to generate image for workspace {num} on monitor {mon} with error {e}")
                    continue

    def logEvent(self, event):
        if self.debug == "debug":
            print(event)

    async def on_connect(self):
        self.logEvent("Connected to Hyprland socket")
        self.generate()

    async def on_workspace(self, ws):
        self.logEvent(f"Workspace changed to {ws}")
        self.focusedws = int(ws)
        self.generate()

    async def on_focusedmon(self, mon, ws):
        self.logEvent(f"Monitor changed to {mon} at workspace {ws}")
        self.focusedMon = mon
        self.generate()

    async def on_createworkspace(self, ws):
        self.logEvent(f"Workspace {ws} created")
        # self.focusedws = int(ws)
        # self.generate()
        pass

    async def on_destroyworkspace(self, ws):
        self.logEvent(f"Workspace {ws} destroyed")
        # self.focusedws = int(ws)
        # self.generate()
        pass

    async def on_moveworkspace(self, ws, mon):
        self.logEvent(f"app moved to workspace {ws} on monitor {mon}")
        self.focusedws = int(ws)
        self.generate()

    async def on_activewindow(self, window_class, window_title):
        self.logEvent(f"window changed to {window_class} with title {window_title}")
        self.generate()

    async def on_closewindow(self, window_address):
        self.logEvent(f"window with address {window_address} destroyed")
        self.generate()

    async def on_movewindow(self, window_address, workspace):
        self.logEvent(f"window with address {window_address} moved to workspace {workspace}")
        self.generate()


w = Workspacer()
try:
    w.async_connect()
except Exception as e:
    print(e)
    w.logEvent("Failed to connect to Hyprland socket")
    w.logEvent("Manual intervention required")
