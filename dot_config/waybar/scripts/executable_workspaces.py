#!/usr/bin/env python3

# Author: https://github.com/Evangelospro

import json
import os
import subprocess
import sys
from svgutils.compose import Panel, SVG, Figure
import hyprland

class Workspacer(hyprland.Events):
    ICONS_DIR = "/tmp/waybar-icons"
    NUM_OF_WORKSPACES = 10

    def __init__(self) -> None:
        self.debug = sys.argv[1] if len(sys.argv) > 1 else ""
        # make a temp dir for icons
        self.clean()
        self.i = hyprland.info.Info()
        self.c = hyprland.Config()
        super().__init__()

        self.window_names = self.load_window_names()

        self.monitormap: dict[int, str] = {}
        # set monitorMap and self.focusedMon
        self.refresh_monitors()

        self.accentColor = "#bd93f9"
        self.focusedws = 1
        self.iconSize = 22
        self.appgridIcon = self.get_icon("appgrid", self.iconSize)

        self.reset()
        self.log_event(f"workspaces {self.workspaces}")
        # generate initial widget
        self.generate()

    def load_window_names(self) -> dict:
        try:
            window_names_path = os.path.join(
                os.path.dirname(os.path.realpath(__file__)), "window_names.json"
            )
            with open(window_names_path, "r") as f:
                return json.load(f)
        except (FileNotFoundError, json.JSONDecodeError) as e:
            self.log_event(f"Failed to load window names with error: {e}")
            return {}

    def get_monitor_id(self, mon: str) -> int:
        for id, name in self.monitormap.items():
            if name == mon:
                return id
        return -1

    def clean(self) -> None:
        # ensure it exists and is empty
        os.makedirs(self.ICONS_DIR, exist_ok=True)
        for f in os.listdir(self.ICONS_DIR):
            os.remove(os.path.join(self.ICONS_DIR, f))

    def reset(self) -> None:
        self.workspaces: dict[int, dict[int, dict[str, str | list]]] = {
            mon: {
                ws: {
                    "status": "inactive-workspace",
                    "icons": [[], []],
                    "classes": []
                } for ws in range(1, self.NUM_OF_WORKSPACES + 1)
            } for mon in self.monitormap.keys()
        }
        self.log_event(f"reset workspaces to {self.workspaces}")

    # handle monitor (dis)connects
    def refresh_monitors(self) -> None:
        try:
            output = subprocess.check_output(["hyprctl", "-j", "monitors"])
            monitors_info = json.loads(output.decode())
            for monitor in monitors_info:
                mon_id = int(monitor["id"])
                name = monitor["name"]
                self.monitormap[mon_id] = name
                focused = monitor["focused"]
                if focused:
                    self.focusedMon = mon_id
        except Exception as e:
            self.log_event(f"Failed to get monitor info with error {e}")

    def set_classes(self) -> None:
        self.reset()
        try:
            clients = json.loads(subprocess.check_output(["hyprctl", "-j", "clients"]).decode())
        except Exception as e:
            self.log_event(f"Failed to get applist json with error {e}")
        for client in clients:
            try:
                mon_id = int(client['monitor'])
                class_ = client['class']
                workspace_id = client['workspace']['id']
                self.log_event(f"adding client {class_} to workspace {workspace_id} on monitor {mon_id}")
                if mon_id is not None and class_ and workspace_id > 0:  # if workspace_id is negative then it is a special workspace
                    workspace_id = workspace_id % self.NUM_OF_WORKSPACES
                    self.log_event(f"client mon: {mon_id}")
                    self.log_event(f"client class: {class_}")
                    self.log_event(f"client ws: {workspace_id}")
                    self.workspaces[mon_id][workspace_id]["classes"].append(class_)
                    if self.focusedws == workspace_id and self.focusedMon == mon_id:
                        self.workspaces[mon_id][workspace_id]["status"] = "active-workspace"
                    else:
                        self.workspaces[mon_id][workspace_id]["status"] = "inactive-workspace"
                    icon = self.get_icon(class_, self.iconSize)
                    if len(self.workspaces[mon_id][workspace_id]["icons"][0]) < 2:
                        self.workspaces[mon_id][workspace_id]["icons"][0].append(icon)
                    elif len(self.workspaces[mon_id][workspace_id]["icons"][1]) < 2:
                        self.workspaces[mon_id][workspace_id]["icons"][1].append(icon)
            except Exception as e:
                self.log_event(f"Failed to get applist classes for below client with error {e}")
                self.log_event(client)
                pass

    def get_icon(self, class_name: str, size: int) -> str:
        # Attempt to use any manually set icons
        self.log_event(f"Getting icon for {class_name}")
        if self.window_names.get(class_name) is not None:
            icon = self.window_names[class_name]["icon"]
            if os.path.exists(os.path.expanduser(icon)):
                return os.path.expanduser(icon)
            else:
                class_name = icon

        for class_name_test in [class_name, class_name.lower()]:
            icon_list = (
                subprocess.check_output(
                    ["geticons", "--no-fallbacks", class_name_test, "-s", str(size), "-c", "1"]
                ).decode().splitlines()
            )
            if icon_list:
                return icon_list[0]
        else:
            self.log_event(f"Failed to get icon for {class_name} please fix...")
            return self.appgridIcon

    def generate(self) -> None:
        self.set_classes()
        for mon_id in self.monitormap.keys():
            self.log_event(f"Generating for monitor {mon_id}")
            for ws in range(1, self.NUM_OF_WORKSPACES + 1):
                try:
                    self.log_event(self.workspaces[mon_id][ws])
                    top_panels = (
                        Panel(SVG(svg_path)).move(self.iconSize * i, 0) for i, svg_path in enumerate(
                            self.workspaces[mon_id][ws]["icons"][0])
                    )
                    bottom_panels = (
                        Panel(SVG(svg_path)).move(self.iconSize * i, self.iconSize) for i, svg_path in enumerate(
                            self.workspaces[mon_id][ws]["icons"][1])
                    )
                    self.log_event(f"Generating image for workspace {ws}")
                    x_len = self.iconSize if len(self.workspaces[mon_id][ws]['icons'][0]) <= 1 else self.iconSize * 2
                    y_len = self.iconSize if len(self.workspaces[mon_id][ws]['icons'][1]) == 0 else self.iconSize * 2
                    Figure(f"{x_len}px", f"{y_len}px", *top_panels, *bottom_panels).save(
                        f"{self.ICONS_DIR}/workspace-{mon_id}-{ws}.svg"
                    )
                except Exception as e:
                    self.log_event(f"Failed to generate image for workspace {ws} on monitor {mon_id} with error {e}")
                    continue

    def log_event(self, event: str) -> None:
        if self.debug == "debug":
            print(event)

    async def on_connect(self) -> None:
        self.log_event("Connected to Hyprland socket")
        self.generate()

    async def on_workspace(self, ws: int) -> None:
        self.log_event(f"Workspace changed to {ws}")
        try:
            ws = int(ws)
        except ValueError:
            return
        self.focusedws = ws % self.NUM_OF_WORKSPACES
        self.generate()

    async def on_focusedmon(self, mon:str, ws:int) -> None:
        mon_id = self.getMonitorId(mon)
        self.log_event(f"Monitor changed to {mon_id} at workspace {ws}")
        self.focusedMon = mon_id
        try:
            ws = int(ws)
            self.focusedws = ws % self.numOfWorkspaces
        except ValueError:
            self.log_event(f"Failed to convert {ws} to int")
        self.generate()

    async def on_createworkspace(self, ws:int) -> None:
        self.log_event(f"Workspace {ws} created")
        try:
            ws = int(ws)
            self.focusedws = ws % self.numOfWorkspaces
        except ValueError:
            self.log_event(f"Failed to convert {ws} to int")
        # self.generate()

    async def on_destroyworkspace(self, ws:int) -> None:
        self.log_event(f"Workspace {ws} destroyed")
        try:
            ws = int(ws)
            self.workspaces[self.focusedMon][int(ws) % self.numOfWorkspaces] = {"status": "inactive-workspace", "icons": [[], []]}
        except ValueError:
            self.log_event(f"Failed to convert {ws} to int")
        # self.generate()

    async def on_moveworkspace(self, ws:int, mon:str) -> None:
        mon_id = self.getMonitorId(mon)
        self.log_event(f"app moved to workspace {ws} on monitor {mon_id}")
        self.focusedMon = mon_id
        try:
            ws = int(ws)
            self.focusedws = int(ws) % self.numOfWorkspaces
        except ValueError:
            self.log_event(f"Failed to convert {ws} to int")
        self.generate()

    async def on_activewindow(self, *args) -> None:
        window_class = args[0]
        window_title = args[1:]
        self.log_event(f"window changed to {window_class} with title {window_title}")
        self.generate()

    async def on_closewindow(self, window_address: str) -> None:
        self.log_event(f"window with address {window_address} destroyed")
        self.generate()

    async def on_movewindow(self, window_address: str, workspace: int) -> None:
        self.log_event(f"window with address {window_address} moved to workspace {workspace}")
        self.generate()

    async def on_monitoradded(self, mon:str) -> None:
        self.log_event(f"Monitor {mon} added")
        self.refresh_monitors()
        self.generate()

    async def on_monitordisconnected(self, mon:str) -> None:
        self.log_event(f"Monitor {mon} disconnected")
        self.refresh_monitors()
        self.generate()

    async def on_closelayer(self, layer:str) -> None:
        self.log_event(f"Layer {layer} closed")
        self.refresh_monitors()

    async def on_openlayer(self, layer:str) -> None:
        self.log_event(f"Layer {layer} opened")
        self.refresh_monitors()

w = Workspacer()
try:
    w.async_connect()
except Exception as e:
    print(e)
    w.log_event("Failed to connect to Hyprland socket")
    w.log_event("Manual intervention required cleaning up...")
    w.clean()
