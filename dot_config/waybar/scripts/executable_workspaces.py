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

def generate():

    workspaces = {
        mon.id: {
            ws: {"icons": []}
            for ws in range(1, NUM_OF_WORKSPACES + 1)
        }
        for mon in MONITOR_MAP
    }

    try:
        clients = instance.get_windows()
    except Exception as e:
        log_event(f"Failed to get clients with error {e}")
        return
    for client in clients:
        try:
            # if client.workspace_id is negative then it is a special workspace
            # if client.pid is -1 then it is a window stuck in cleanup
            if client.pid == -1 or client.workspace_id < 0:
                continue
            class_ = client.wm_class if client.wm_class else client.initial_title
            log_event(f"actual client ws id: {client.workspace_id}")
            if class_:
                client.workspace_id = (
                    client.workspace_id % NUM_OF_WORKSPACES
                    if client.workspace_id % NUM_OF_WORKSPACES != 0
                    else NUM_OF_WORKSPACES
                )
                icon_list = generate_icon_list(class_, ICON_SIZE)
                log_event(f"icon list for {class_} is {icon_list}")
                icon = icon_list[0]
                log_event(f"icon for {class_} is {icon}")
                workspaces[client.monitor_id][client.workspace_id]["icons"].append(icon)
            else:
                log_event("Failed to get wm_class for below client")
                log_event(client)
                return
        except Exception as e:
            log_event(f"Failed to get applist classes for below client with error {e}")
            log_event(client)
            log_event(workspaces[client.monitor_id][client.workspace_id]["icons"])
            return

    for monitor in MONITOR_MAP:
        log_event(f"Generating for monitor {monitor.id}")
        for ws in range(1, NUM_OF_WORKSPACES + 1):
            try:
                log_event(workspaces[monitor.id][ws])
                top_panels = (
                    Panel(SVG(svg_path)).move(ICON_SIZE * i, 0)
                    for i, svg_path in enumerate(workspaces[monitor.id][ws]["icons"][:2])
                )
                bottom_panels = (
                    Panel(SVG(svg_path)).move(ICON_SIZE * i, ICON_SIZE)
                    for i, svg_path in enumerate(workspaces[monitor.id][ws]["icons"][2:4])
                )
                log_event(f"Generating image for workspace {ws} has {len(workspaces[monitor.id][ws]['icons'])} icons")
                if len(workspaces[monitor.id][ws]["icons"]) <= 1:
                    # if there is only one icon, make it bigger
                    x_len = ICON_SIZE
                    y_len = ICON_SIZE
                else:
                    x_len = ICON_SIZE * 2
                    y_len = ICON_SIZE * 2
                Figure(f"{x_len}px", f"{y_len}px", *top_panels, *bottom_panels).save(
                    f"{DATA_DIR}/workspace-{monitor.id}-{ws}.svg"
                )
            except Exception as e:
                log_event(f"Failed to generate image for workspace {ws} on monitor {monitor.id} with error {e}")
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
    window_address = kwargs["created_window_address"]
    window = instance.get_window_by_address(window_address)

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
