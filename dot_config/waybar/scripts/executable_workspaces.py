#!/usr/bin/env python3

import os
import sys
from svgutils.compose import SVG, Figure, Panel
import traceback
from hyprpy import Hyprland

sys.path.append(os.path.expanduser("~/.local/bin"))
from geticon import generate_icon_list

instance = Hyprland()

# INIT VARS
DATA_DIR = "/tmp/waybar-icons"
NUM_OF_WORKSPACES = 10
ACCENT_COLOR = "#bd93f9"
ICON_SIZE = 22
WORKSPACES = {}

MONITOR_MAP = instance.get_monitors()

DEBUG = sys.argv[1] if len(sys.argv) > 1 else ""

def get_focused_monitor():
    monitor_map = instance.get_monitors()
    for mon in monitor_map:
        if mon.is_focused:
            return mon.id
    return 0

def get_focused_workspace():
    active_workspace_id = instance.get_active_workspace().id
    return active_workspace_id % NUM_OF_WORKSPACES

def log_event(event: str):
    if DEBUG == "debug":
        print(event)
    with open(f"{DATA_DIR}/log.txt", "a") as f:
        f.write(f"{event}\n")

def clean():
    # ensure it exists and is empty
    os.makedirs(DATA_DIR, exist_ok=True)
    for f in os.listdir(DATA_DIR):
        os.remove(os.path.join(DATA_DIR, f))
    log_event(f"cleaned {DATA_DIR}")

def get_workspaces(focused_mon, focused_ws):
    workspaces = {
        mon.id: {
            ws: {"status": "inactive-workspace", "icons": [[], []], "classes": []}
            for ws in range(1, NUM_OF_WORKSPACES + 1)
        }
        for mon in MONITOR_MAP
    }
    try:
        clients = instance.get_windows()
    except Exception as e:
        log_event(f"Failed to get clients with error {e}")
    for client in clients:
        try:
            if client.pid == -1:
                continue
            class_ = client.wm_class if client.wm_class else client.initial_title
            log_event(f"actual client ws id: {client.workspace_id}")
            if (
                client.monitor_id is not None and class_ and client.workspace_id > 0
            ):  # if client.workspace_id is negative then it is a special workspace
                client.workspace_id = (
                    client.workspace_id % NUM_OF_WORKSPACES
                    if client.workspace_id % NUM_OF_WORKSPACES != 0
                    else NUM_OF_WORKSPACES
                )
                log_event(f"client mon: {client.monitor_id}")
                log_event(f"client class: {class_}")
                log_event(f"transformed client ws id: {client.workspace_id}")
                workspaces[client.monitor_id][client.workspace_id]["classes"].append(class_)
                if focused_ws == client.workspace_id and focused_mon == client.monitor_id:
                    workspaces[client.monitor_id][client.workspace_id]["status"] = "active-workspace"
                else:
                    workspaces[client.monitor_id][client.workspace_id]["status"] = "inactive-workspace"
                icon_list = generate_icon_list(class_, ICON_SIZE)
                log_event(f"icon list for {class_} is {icon_list}")
                icon = icon_list[0]
                log_event(f"icon for {class_} is {icon}")
                if len(workspaces[client.monitor_id][client.workspace_id]["icons"][0]) < 2:
                    workspaces[client.monitor_id][client.workspace_id]["icons"][0].append(icon)
                elif len(workspaces[client.monitor_id][client.workspace_id]["icons"][1]) < 2:
                    workspaces[client.monitor_id][client.workspace_id]["icons"][1].append(icon)
        except Exception as e:
            log_event(f"Failed to get applist classes for below client with error {e}")
            log_event(client)
            log_event(workspaces[client.monitor_id][client.workspace_id]["icons"])

    return workspaces

def generate(focused_mon=get_focused_monitor(), focused_ws=get_focused_workspace()):
    workspaces = get_workspaces(focused_mon, focused_ws)
    for monitor in MONITOR_MAP:
        log_event(f"Generating for monitor {monitor.id}")
        for ws in range(1, NUM_OF_WORKSPACES + 1):
            try:
                log_event(workspaces[monitor.id][ws])
                top_panels = (
                    Panel(SVG(svg_path)).move(ICON_SIZE * i, 0)
                    for i, svg_path in enumerate(workspaces[monitor.id][ws]["icons"][0])
                )
                bottom_panels = (
                    Panel(SVG(svg_path)).move(ICON_SIZE * i, ICON_SIZE)
                    for i, svg_path in enumerate(workspaces[monitor.id][ws]["icons"][1])
                )
                log_event(f"Generating image for workspace {ws}")
                x_len = ICON_SIZE if len(workspaces[monitor.id][ws]["icons"][0]) <= 1 else ICON_SIZE * 2
                y_len = ICON_SIZE if len(workspaces[monitor.id][ws]["icons"][1]) == 0 else ICON_SIZE * 2
                Figure(f"{x_len}px", f"{y_len}px", *top_panels, *bottom_panels).save(
                    f"{DATA_DIR}/workspace-{monitor.id}-{ws}.svg"
                )
            except Exception as e:
                log_event(f"Failed to generate image for workspace {ws} on monitor {monitor.id} with error {e}")
                # print traceback
                log_event(traceback.format_exc())
                continue


def on_workspace_created(sender, **kwargs):
    log_event(f"on_workspace_created: {kwargs}")
    generate()

def on_workspace_destroyed(sender, **kwargs):
    log_event(f"on_workspace_destroyed: {kwargs}")
    generate()

def on_window_created(sender, **kwargs):
    log_event(f"on_window_created: {kwargs}")
    generate()

def on_window_changed(sender, **kwargs):
    log_event(f"on_window_changed: {kwargs}")
    generate()

def on_window_destroyed(sender, **kwargs):
    log_event(f"on_window_destroyed: {kwargs}")
    generate()

def on_workspace_changed(sender, **kwargs):
    log_event(f"on_workspace_changed: {kwargs}")
    generate()

clean()
generate()

instance.signal_workspace_created.connect(on_workspace_created)
instance.signal_workspace_destroyed.connect(on_workspace_destroyed)
instance.signal_active_workspace_changed.connect(on_workspace_changed)

instance.signal_window_created.connect(on_window_created)
instance.signal_window_destroyed.connect(on_window_destroyed)
instance.signal_active_window_changed.connect(on_window_changed)
instance.watch()
