#!/usr/bin/env python3

# Author: https://github.com/Evangelospro

import json
import os
import re
import subprocess
import sys
from svgutils.compose import Panel, SVG, Figure
import hyprland


class Workspacer(hyprland.Events):
    def __init__(self) -> None:
        self.debug = sys.argv[1] if len(sys.argv) > 1 else ""
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

        self.monitormap: dict[str, int] = {}
        # set monitorMap
        self.monitor_event()

        self.accentColor = "#bd93f9"
        self.workspaceRange = range(1, self.numOfWorkspaces + 1)
        self.focusedws = 1
        self.iconSize = 22
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
    def monitor_event(self) -> None:
        with subprocess.Popen(["hyprctl", "-j", "monitors"], stdout=subprocess.PIPE) as proc:
            try:
                output = json.loads(proc.stdout.read().decode())
                for monitor in output:
                    id = int(monitor["id"])
                    name = monitor["name"]
                    self.monitormap[name] = id
                    focused = monitor["focused"]
                    if focused:
                        self.focusedMon = monitor["name"]
            except Exception as e:
                self.logEvent(f"Failed to get monitor info with error {e}")
                pass

    def applistClass(self, ws: int, mon: str) -> list[str]:
        with subprocess.Popen(["hyprctl", "-j", "clients"], stdout=subprocess.PIPE) as proc:
            try:
                clients = json.loads(proc.stdout.read().decode())
                classes = [
                    client["class"]
                    for client in clients
                    # % to take in to account the use of split-monitor-workspaces plugin
                    if client["workspace"]["id"] % self.numOfWorkspaces == ws
                    and int(client["monitor"]) == self.monitormap[mon]
                ]
                return classes
            except Exception as e:
                self.logEvent(f"Failed to get applist classes info for mon: {mon} on ws: {ws} with error {e}")
                return []

    # make it return type any
    def getIcon(self, class_name: str) ->
        # Attempt to use any manually set icons
        if self.windowNames.get(class_name) is not None:
            icon = self.windowNames[class_name]["icon"]
            if os.path.exists(os.path.expanduser(icon)):
                return os.path.expanduser(icon)
            else:
                class_name = icon

        for class_name_test in [class_name,z class_name.lower()]:
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

    def generate(self) -> None:
        for mon in self.monitormap:
            self.logEvent(f"Fetching monitor: {mon}")
            for ws in self.workspaceRange:
                classes = self.applistClass(ws, mon)[0:4]  # only render up to 4 icons
                icons = [self.getIcon(class_name) for class_name in classes]
                self.workspaces[mon][ws]["icons"] = [icons[0:2], icons[2:4]]
                try:
                    top_panels = (Panel(
                        SVG(svg_path)
                    ).move(self.iconSize * i, 0) for i, svg_path in enumerate(self.workspaces[mon][ws]["icons"][0]))
                    bottom_panels = (Panel(
                        SVG(svg_path)
                    ).move(self.iconSize * i, self.iconSize) for i, svg_path in enumerate(self.workspaces[mon][ws]["icons"][1]))
                    self.logEvent(f"Generating image for workspace {ws}")
                    x_len = self.iconSize if len(self.workspaces[mon][ws]['icons'][0]) <= 1 else self.iconSize * 2
                    y_len = self.iconSize if len(self.workspaces[mon][ws]['icons'][1]) == 0 else self.iconSize * 2
                    Figure(f"{x_len}px",
                        f"{y_len}px",
                        *top_panels,
                        *bottom_panels
                    ).save(f"{self.iconsDir}/workspace-{mon}-{ws}.svg")
                    # set the svg background to purple if the workspace is active
                    if ws == self.focusedws and mon == self.focusedMon:
                        # add <rect width="100%" height="10%" fill="self.accentColor"/>  after the <svg ...> tag
                        self.logEvent(f"Setting ws: {ws} on mon: {mon} to active")
                        with open(f"{self.iconsDir}/workspace-{mon}-{ws}.svg", "r+") as f:
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
                    self.logEvent(f"Failed to generate image for workspace {ws} on monitor {mon} with error {e}")
                    continue

    def logEvent(self, event:str) -> None:
        if self.debug == "debug":
            print(event)

    async def on_connect(self) -> None:
        self.logEvent("Connected to Hyprland socket")
        self.generate()

    async def on_workspace(self, ws:int) -> None:
        self.logEvent(f"Workspace changed to {ws}")
        self.focusedws = int(ws) % self.numOfWorkspaces
        self.generate()

    async def on_focusedmon(self, mon:str, ws:int) -> None:
        self.logEvent(f"Monitor changed to {mon} at workspace {ws}")
        self.focusedMon = mon
        self.focusedws = int(ws) % self.numOfWorkspaces
        self.generate()

    async def on_createworkspace(self, ws:int) -> None:
        self.logEvent(f"Workspace {ws} created")
        self.focusedws = int(ws) % self.numOfWorkspaces
        # self.generate()
        pass

    async def on_destroyworkspace(self, ws:int) -> None:
        self.logEvent(f"Workspace {ws} destroyed")
        self.focusedws = int(ws) % self.numOfWorkspaces
        # self.generate()
        pass

    async def on_moveworkspace(self, ws:int, mon:str) -> None:
        self.logEvent(f"app moved to workspace {ws} on monitor {mon}")
        self.focusedMon = mon
        self.focusedws = int(ws) % self.numOfWorkspaces
        self.generate()

    async def on_activewindow(self, window_class: str, window_title: str) -> None:
        self.logEvent(f"window changed to {window_class} with title {window_title}")
        self.generate()

    async def on_closewindow(self, window_address: str) -> None:
        self.logEvent(f"window with address {window_address} destroyed")
        self.generate()

    async def on_movewindow(self, window_address: str, workspace: int) -> None:
        self.logEvent(f"window with address {window_address} moved to workspace {workspace}")
        self.generate()


w = Workspacer()
try:
    w.async_connect()
except Exception as e:
    print(e)
    w.logEvent("Failed to connect to Hyprland socket")
    w.logEvent("Manual intervention required")
