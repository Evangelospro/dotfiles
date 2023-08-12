#!/bin/env python3

import subprocess
import sys
import time
import os

import gi

gi.require_version('Gtk', '3.0')

from gi.repository import Gio  # noqa
from gi.repository import GLib  # noqa

JGMENU_CONFIG = os.path.join(os.path.dirname(__file__), 'jgmenurc')
# JGMENU_CMD = ['jgmenu', '--simple', '--no-spawn', f"--config-file='{JGMENU_CONFIG}'"]
JGMENU_CMD = ['jgmenu', '--simple', '--no-spawn', "--config-file='./scripts/jgmenurc'"]

class Bus:
    def __init__(self, conn, name, path):
        self.conn = conn
        self.name = name
        self.path = path

    def call_sync(self, interface, method, params, params_type, return_type):
        return self.conn.call_sync(
            self.name,
            self.path,
            interface,
            method,
            GLib.Variant(params_type, params),
            GLib.VariantType(return_type),
            Gio.DBusCallFlags.NONE,
            -1,
            None,
        )

    def get_menu_layout(self, *args):
        return self.call_sync(
            'com.canonical.dbusmenu',
            'GetLayout',
            args,
            '(iias)',
            '(u(ia{sv}av))',
        )

    def menu_event(self, *args):
        self.call_sync('com.canonical.dbusmenu', 'Event', args, '(isvu)', '()')



def makemenu(item,menu,tag):
    entry = ""

    if len(item) == 0:
        entry = "^sep()\n"
    else:
        for i in item:
            if 'children-display' in i[1] and i[1]['children-display'] == 'submenu':
                temp = i[1]['label']

                while temp in menu:
                    temp = temp + "x"

                entry = f'{entry}{i[1]["label"]},^checkout({temp})\n'
                makemenu(i[2], menu, temp)
                
            else:
                if 'type' in i[1] and i[1]['type'] == "separator":
                    entry = f'{entry}^sep()\n'

                elif ('enabled' in i[1] and
                        not i[1]['enabled'] and
                        'label' in i[1] and len(i[1]['label']) > 0):

                    entry = f"{entry}^sep({i[1]['label']})\n"

                elif 'label' in i[1] and len(i[1]['label']) > 0:
                    entry = f"{entry}{i[1]['label']},{str(i[0])}\n"

    menu[tag] = entry
    return menu

def formatmenu(menu):
    csv = menu[""]

    for i in menu:
        if i != "":
            csv = f'{csv}\n^tag({i})\n{menu[i]}'

    return csv

def jgmenu(_input):
    p = subprocess.Popen(
        JGMENU_CMD,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        encoding='utf-8',
    )
    out, _ = p.communicate(_input)
    return out

def show_menu(conn, name, path):
    bus = Bus(conn, name, path)
    item = bus.get_menu_layout(0, -1, [])
    menu = {}

    for i in item:
        if type(i) == tuple and i[1]['children-display'] == 'submenu':
            makemenu(i[2], menu, "")

    csv = formatmenu(menu)

    print(csv)

    id = jgmenu(csv)

    if id:
        print("id: " + id)
        bus.menu_event(int(id), 'clicked', GLib.Variant('s', ''), time.time())



if __name__ == '__main__':
    conn = Gio.bus_get_sync(Gio.BusType.SESSION)
    show_menu(conn, sys.argv[1], sys.argv[2])
