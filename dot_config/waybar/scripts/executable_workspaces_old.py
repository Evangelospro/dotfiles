#!/usr/bin/env python3

# Author: https://github.com/Evangelospro

import os
import sys
import hyprland
from svgutils.compose import SVG, Figure, Panel
import subprocess
import json
import traceback
import asyncio

sys.path.append(os.path.expanduser("~/.local/bin"))
from geticon import generate_icon_list


class Workspacer(hyprland.Events):

    def __init__(self) -> None:
        self.debug = sys.argv[1] if len(sys.argv) > 1 else ""
        self.i = hyprland.info.Info()
        self.c = hyprland.Config()
        super().__init__()

        # INIT VARS
        self.DATA_DIR = "/tmp/waybar-icons"
        self.NUM_OF_WORKSPACES = 10
        self.focusedMon = 0
        self.accentColor = "#bd93f9"
        self.focusedws = 1
        self.iconSize = 22

        try:
            self.monitormap: dict[int, str] = {
                monitor["id"]: monitor["name"]
                for monitor in json.loads(subprocess.check_output(["hyprctl", "monitors", "-j"]))
            }
        except Exception as e:
            raise Exception(f"Failed to get monitor info with error {e}")

        self.clean()
        self.reset()

        self.log_event(f"workspaces {self.workspaces}")

    def get_monitor_id(self, mon: str) -> int:
        for id, name in self.monitormap.items():
            if name == mon:
                return id
        return -1

    def clean(self) -> None:
        # ensure it exists and is empty
        os.makedirs(self.DATA_DIR, exist_ok=True)
        for f in os.listdir(self.DATA_DIR):
            os.remove(os.path.join(self.DATA_DIR, f))
        self.log_event(f"cleaned {self.DATA_DIR}")

    def reset(self) -> None:
        self.workspaces: dict[int, dict[int, dict[str, str | list]]] = {
            mon: {
                ws: {"status": "inactive-workspace", "icons": [[], []], "classes": []}
                for ws in range(1, self.NUM_OF_WORKSPACES + 1)
            }
            for mon in self.monitormap.keys()
        }
        self.log_event(f"reset workspaces to {self.workspaces}")

    # handle monitor (dis)connects
    async def refresh_monitors(self) -> None:
        try:
            monitors_info = await self.i.monitors()
            for monitor in monitors_info:
                mon_id = int(monitor["id"])
                name = monitor["name"]
                self.monitormap[mon_id] = name
                focused = monitor["focused"]
                if focused:
                    self.focusedMon = mon_id
        except Exception as e:
            self.log_event(f"Failed to get monitor info with error {e}")

    async def set_classes(self) -> None:
        self.reset()
        try:
            clients = await self.i.clients()
        except Exception as e:
            self.log_event(f"Failed to get applist json with error {e}")
        for client in clients:
            try:
                mon_id = int(client["monitor"])
                if client["pid"] == -1:
                    continue
                class_ = client["class"] if client["class"] else client["initialTitle"]
                workspace_id = int(client["workspace"]["id"])
                self.log_event(f"actual client ws id: {workspace_id}")
                if (
                    mon_id is not None and class_ and workspace_id > 0
                ):  # if workspace_id is negative then it is a special workspace
                    workspace_id = (
                        workspace_id % self.NUM_OF_WORKSPACES
                        if workspace_id % self.NUM_OF_WORKSPACES != 0
                        else self.NUM_OF_WORKSPACES
                    )
                    self.log_event(f"client mon: {mon_id}")
                    self.log_event(f"client class: {class_}")
                    self.log_event(f"transformed client ws id: {workspace_id}")
                    self.workspaces[mon_id][workspace_id]["classes"].append(class_)
                    if self.focusedws == workspace_id and self.focusedMon == mon_id:
                        self.workspaces[mon_id][workspace_id]["status"] = "active-workspace"
                    else:
                        self.workspaces[mon_id][workspace_id]["status"] = "inactive-workspace"
                    icon_list = generate_icon_list(class_, self.iconSize)
                    self.log_event(f"icon list for {class_} is {icon_list}")
                    icon = icon_list[0]
                    self.log_event(f"icon for {class_} is {icon}")
                    if len(self.workspaces[mon_id][workspace_id]["icons"][0]) < 2:
                        self.workspaces[mon_id][workspace_id]["icons"][0].append(icon)
                    elif len(self.workspaces[mon_id][workspace_id]["icons"][1]) < 2:
                        self.workspaces[mon_id][workspace_id]["icons"][1].append(icon)
            except Exception as e:
                self.log_event(f"Failed to get applist classes for below client with error {e}")
                self.log_event(client)
                self.log_event(self.workspaces[mon_id][workspace_id]["icons"])

    async def generate(self) -> None:
        await self.set_classes()
        for mon_id in self.monitormap.keys():
            self.log_event(f"Generating for monitor {mon_id}")
            for ws in range(1, self.NUM_OF_WORKSPACES + 1):
                try:
                    self.log_event(self.workspaces[mon_id][ws])
                    top_panels = (
                        Panel(SVG(svg_path)).move(self.iconSize * i, 0)
                        for i, svg_path in enumerate(self.workspaces[mon_id][ws]["icons"][0])
                    )
                    bottom_panels = (
                        Panel(SVG(svg_path)).move(self.iconSize * i, self.iconSize)
                        for i, svg_path in enumerate(self.workspaces[mon_id][ws]["icons"][1])
                    )
                    self.log_event(f"Generating image for workspace {ws}")
                    x_len = self.iconSize if len(self.workspaces[mon_id][ws]["icons"][0]) <= 1 else self.iconSize * 2
                    y_len = self.iconSize if len(self.workspaces[mon_id][ws]["icons"][1]) == 0 else self.iconSize * 2
                    Figure(f"{x_len}px", f"{y_len}px", *top_panels, *bottom_panels).save(
                        f"{self.DATA_DIR}/workspace-{mon_id}-{ws}.svg"
                    )
                except Exception as e:
                    self.log_event(f"Failed to generate image for workspace {ws} on monitor {mon_id} with error {e}")
                    # print traceback
                    self.log_event(traceback.format_exc())
                    continue

    def log_event(self, event: str) -> None:
        if self.debug == "debug":
            print(event)
        with open(f"{self.DATA_DIR}/log.txt", "a") as f:
            f.write(f"{event}\n")

    async def on_connect(self) -> None:
        self.log_event("Connected to Hyprland socket")
        await self.generate()

    async def on_workspace(self, ws: int) -> None:
        self.log_event(f"Workspace changed to {ws}")
        try:
            ws = int(ws)
        except ValueError:
            return
        self.focusedws = ws % self.NUM_OF_WORKSPACES
        await self.generate()

    async def on_focusedmon(self, mon: str, ws: int) -> None:
        mon_id = self.get_monitor_id(mon)
        self.log_event(f"Monitor changed to {mon_id} at workspace {ws}")
        self.focusedMon = mon_id
        try:
            ws = int(ws)
            self.focusedws = ws % self.NUM_OF_WORKSPACES
        except ValueError:
            self.log_event(f"Failed to convert {ws} to int")
        await self.generate()

    async def on_createworkspace(self, ws: int) -> None:
        self.log_event(f"Workspace {ws} created")
        try:
            ws = int(ws)
            self.focusedws = ws % self.NUM_OF_WORKSPACES
        except ValueError:
            self.log_event(f"Failed to convert {ws} to int")
        # self.generate()

    async def on_destroyworkspace(self, ws: int) -> None:
        self.log_event(f"Workspace {ws} destroyed")
        try:
            ws = int(ws)
            self.workspaces[self.focusedMon][int(ws) % self.NUM_OF_WORKSPACES] = {
                "status": "inactive-workspace",
                "icons": [[], []],
            }
        except ValueError:
            self.log_event(f"Failed to convert {ws} to int")
        # self.generate()

    async def on_moveworkspace(self, ws: int, mon: str) -> None:
        mon_id = self.get_monitor_id(mon)
        self.log_event(f"app moved to workspace {ws} on monitor {mon_id}")
        self.focusedMon = mon_id
        try:
            ws = int(ws)
            self.focusedws = int(ws) % self.NUM_OF_WORKSPACES
        except ValueError:
            self.log_event(f"Failed to convert {ws} to int")
        await self.generate()

    async def on_activewindow(self, *args) -> None:
        window_class = args[0]
        window_title = args[1:]
        self.log_event(f"window changed to {window_class} with title {window_title}")
        await self.generate()

    async def on_closewindow(self, window_address: str) -> None:
        self.log_event(f"window with address {window_address} destroyed")
        await self.generate()

    async def on_movewindow(self, window_address: str, workspace: int) -> None:
        self.log_event(f"window with address {window_address} moved to workspace {workspace}")
        await self.generate()

    async def on_monitoradded(self, mon: str) -> None:
        self.log_event(f"Monitor {mon} added")
        await self.refresh_monitors()
        await self.generate()

    async def on_monitordisconnected(self, mon: str) -> None:
        self.log_event(f"Monitor {mon} disconnected")
        await self.refresh_monitors()
        await self.generate()

    async def on_closelayer(self, layer: str) -> None:
        self.log_event(f"Layer {layer} closed")
        await self.refresh_monitors()

    async def on_openlayer(self, layer: str) -> None:
        self.log_event(f"Layer {layer} opened")
        await self.refresh_monitors()

    async def on_configreloaded(self) -> None:
        self.log_event("Config reloaded")
        await self.refresh_monitors()
        await self.generate()
        
try:
    w = Workspacer()
    w.async_connect()
except Exception as e:
    print(f"Failed to start Workspacer with error {e}", file=sys.stderr)
    sys.exit(1)
