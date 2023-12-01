#!/usr/bin/env python3

# Author: https://github.com/Evangelospro

import json
import os
import subprocess
import sys
from svgutils.compose import Panel, SVG, Figure
import hyprland


class Workspacer(hyprland.Events):
    def __init__(self) -> None:
        self.debug = sys.argv[1] if len(sys.argv) > 1 else ""
        # make a temp dir for icons
        self.iconsDir = "/tmp/waybar-icons"
        self.clean()
        self.i = hyprland.info.Info()
        self.c = hyprland.Config()
        super().__init__()

        self.numOfWorkspaces = 10
        self.windowNames = json.loads(open(os.path.expanduser("~/.config/eww/scripts/windowNames.json")).read())

        self.monitormap: dict[str, int] = {}
        # set monitorMap and self.focusedMon
        self.refresh_monitors()

        self.accentColor = "#bd93f9"
        self.workspaceRange = range(1, self.numOfWorkspaces + 1)
        self.focusedws = 1
        self.iconSize = 22
        self.appgridIcon = self.getIcon("appgrid", self.iconSize)

        self.reset()
        self.logEvent(f"workspaces {self.workspaces}")
        # generate initial widget
        self.generate()

    def clean(self) -> None:
        # ensure it exists and is empty
        os.makedirs(self.iconsDir, exist_ok=True)
        for f in os.listdir(self.iconsDir):
            os.remove(os.path.join(self.iconsDir, f))

    def reset(self) -> None:
        self.workspaces : dict[str, dict[int, dict[str, str|list]]] = {mon:
                    {ws:
                        {"status": "inactive-workspace",
                        "icons": [[], []],
                        "classes": []
                        }
                        for ws in self.workspaceRange}
                    for mon in self.monitormap.keys()
                    }

    # handle monitor (dis)connects
    def refresh_monitors(self) -> None:
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

    def setClasses(self) -> None:
        self.reset()
        with subprocess.Popen(["hyprctl", "-j", "clients"], stdout=subprocess.PIPE) as proc:
            try:
                clients = json.loads(proc.stdout.read().decode())
            except Exception as e:
                self.logEvent(f"Failed to get applist json with error {e}")
            for client in clients:
                try:
                    mon_id = client['monitor']
                    mon = next((key for key, value in self.monitormap.items() if value == mon_id), None)
                    class_ = client['class']
                    workspace_id = client['workspace']['id']
                    if mon and class_ and workspace_id > 0: # if workspace_id is negative then it is a special workspace
                        workspace_id = workspace_id % self.numOfWorkspaces
                        self.logEvent(f"client mon: {mon}")
                        self.logEvent(f"client class: {class_}")
                        self.logEvent(f"client ws: {workspace_id}")
                        self.workspaces[mon][workspace_id]["classes"].append(class_)
                        if self.focusedws == workspace_id and self.focusedMon == mon:
                            self.workspaces[mon][workspace_id]["status"] = "active-workspace"
                            icon = self.getIcon(class_, self.iconSize)
                        else:
                            icon = self.getIcon(class_, self.iconSize)
                            self.workspaces[mon][workspace_id]["status"] = "inactive-workspace"
                        if len(self.workspaces[mon][workspace_id]["icons"][0]) < 2:
                            self.workspaces[mon][workspace_id]["icons"][0].append(icon)
                        elif len(self.workspaces[mon][workspace_id]["icons"][1]) < 2:
                            self.workspaces[mon][workspace_id]["icons"][1].append(icon)
                except Exception as e:
                    self.logEvent(f"Failed to get applist classes for below client with error {e}")
                    self.logEvent(client)
                    pass

    def getIcon(self, class_name: str, size:int) -> str:
        # Attempt to use any manually set icons
        self.logEvent(f"Getting icon for {class_name}")
        if self.windowNames.get(class_name) is not None:
            icon = self.windowNames[class_name]["icon"]
            if os.path.exists(os.path.expanduser(icon)):
                return os.path.expanduser(icon)
            else:
                class_name = icon

        for class_name_test in [class_name, class_name.lower()]:
            icon_list = (
                subprocess.check_output(["geticons", "--no-fallbacks", class_name_test, "-s", str(size), "-c", "1"])
                .decode()
                .splitlines()
            )
            if icon_list:
                icon = icon_list[0]
                break
        else:
            self.logEvent(f"Failed to get icon for {class_name} please fix...")
            icon = self.appgridIcon
        return icon



    def generate(self) -> None:
        self.setClasses()
        for mon in self.monitormap:
            self.logEvent(f"Generating monitor: {mon}")
            for ws in self.workspaceRange:
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
                    # if ws == self.focusedws and mon == self.focusedMon:
                    #     # add <rect width="100%" height="10%" fill="self.accentColor"/>  after the <svg ...> tag
                    #     self.logEvent(f"Setting ws: {ws} on mon: {mon} to active")
                    #     with open(f"{self.iconsDir}/workspace-{mon}-{ws}.svg", "r+") as f:
                    #         content = f.read()
                    #         f.seek(0, 0)
                    #         f.write(
                    #             re.sub(
                    #                 r'<svg(.*?)>',
                    #                 r'<svg\1>\n<rect width="100%" height="100%" fill="' + self.accentColor + '"/>',
                    #                 content,
                    #             )
                    #         )

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
        try:
            ws = int(ws)
            self.logEvent(f"Failed to convert {ws} to int")
        except ValueError:
            return
        self.focusedws = ws % self.numOfWorkspaces
        self.generate()

    async def on_focusedmon(self, mon:str, ws:int) -> None:
        self.logEvent(f"Monitor changed to {mon} at workspace {ws}")
        self.focusedMon = mon
        try:
            ws = int(ws)
            self.focusedws = ws % self.numOfWorkspaces
        except ValueError:
            self.logEvent(f"Failed to convert {ws} to int")
        self.generate()

    async def on_createworkspace(self, ws:int) -> None:
        self.logEvent(f"Workspace {ws} created")
        try:
            ws = int(ws)
            self.focusedws = ws % self.numOfWorkspaces
        except ValueError:
            self.logEvent(f"Failed to convert {ws} to int")
        # self.generate()

    async def on_destroyworkspace(self, ws:int) -> None:
        self.logEvent(f"Workspace {ws} destroyed")
        try:
            ws = int(ws)
            self.workspaces[self.focusedMon][int(ws) % self.numOfWorkspaces] = {"status": "inactive-workspace", "icons": [[], []]}
        except ValueError:
            self.logEvent(f"Failed to convert {ws} to int")
        # self.generate()

    async def on_moveworkspace(self, ws:int, mon:str) -> None:
        self.logEvent(f"app moved to workspace {ws} on monitor {mon}")
        self.focusedMon = mon
        try:
            ws = int(ws)
            self.focusedws = int(ws) % self.numOfWorkspaces
        except ValueError:
            self.logEvent(f"Failed to convert {ws} to int")
        self.generate()

    async def on_activewindow(self, *args) -> None:
        window_class = args[0]
        window_title = args[1:]
        self.logEvent(f"window changed to {window_class} with title {window_title}")
        self.generate()

    async def on_closewindow(self, window_address: str) -> None:
        self.logEvent(f"window with address {window_address} destroyed")
        self.generate()

    async def on_movewindow(self, window_address: str, workspace: int) -> None:
        self.logEvent(f"window with address {window_address} moved to workspace {workspace}")
        self.generate()

    async def on_monitoradded(self, mon:str) -> None:
        self.logEvent(f"Monitor {mon} added")
        self.refresh_monitors()
        self.generate()

    async def on_monitordisconnected(self, mon:str) -> None:
        self.logEvent(f"Monitor {mon} disconnected")
        self.refresh_monitors()
        self.generate()

    async def on_closelayer(self, layer:str) -> None:
        self.logEvent(f"Layer {layer} closed")
        self.refresh_monitors()

    async def on_openlayer(self, layer:str) -> None:
        self.logEvent(f"Layer {layer} opened")
        self.refresh_monitors()

w = Workspacer()
try:
    w.async_connect()
except Exception as e:
    print(e)
    w.logEvent("Failed to connect to Hyprland socket")
    w.logEvent("Manual intervention required cleaning up...")
    w.clean()
