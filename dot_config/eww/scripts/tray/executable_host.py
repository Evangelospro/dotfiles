#!/bin/env python3

import os
import sys
import json

import gi

gi.require_version('Gtk', '3.0')

from gi.repository import Gio
from gi.repository import Gtk
from gi.repository import GLib
from gi.repository import GdkPixbuf
from pathlib import Path

MENU_PATH = os.path.join(os.path.dirname(__file__), 'menu.lua')

NODE_INFO = Gio.DBusNodeInfo.new_for_xml("""
<?xml version="1.0" encoding="UTF-8"?>
<node>
    <interface name="org.kde.StatusNotifierWatcher">
        <method name="RegisterStatusNotifierItem">
            <arg type="s" direction="in"/>
        </method>
        <property name="RegisteredStatusNotifierItems" type="as" access="read">
        </property>
        <property name="IsStatusNotifierHostRegistered" type="b" access="read">
        </property>
    </interface>
</node>""")

items = {}

def geticon(item):
    icon_theme = Gtk.IconTheme.get_default()

    icon = icon_theme.lookup_icon(item['Title'].lower(), 22, 0)

    if icon != None:
        return icon.get_filename()
    else:
        icon = icon_theme.lookup_icon(item['IconName'].lower(), 22, 0)
        if icon != None:
            return icon.get_filename()
        else:
            icon = icon_theme.lookup_icon(item['Id'].lower(), 22, 0)
            if icon != None:
                return icon.get_filename()

            elif 'IconPixmap' in item and len(item['IconPixmap']) > 0:
                data = item['IconPixmap'][-1]

                alpha = data[2][0::4]
                red = data[2][1::4]
                green = data[2][2::4]
                blue = data[2][3::4]

                newdata = []

                for i in range(len(alpha)):
                    newdata.append(red[i])
                    newdata.append(green[i])
                    newdata.append(blue[i])
                    newdata.append(alpha[i])

                gbytes = GLib.Bytes.new(newdata)

                iconpath = Path(os.getenv('XDG_DATA_HOME', ( os.getenv( 'HOME' ) + '/.local/share' ) ) + '/icons/hicolor/' + str(data[0]) + 'x' + str(data[1]) +'/apps/')
                iconpath.mkdir(parents=True, exist_ok=True)

                iconpath = ( iconpath.as_posix() + '/' + item['Id'] + '.png' )

                icon = GdkPixbuf.Pixbuf.new_from_bytes(gbytes, GdkPixbuf.Colorspace.RGB, True, 8, data[0], data[1], (4 * data [0]) )
                icon.savev( iconpath , 'png' )

                icon_theme = Gtk.IconTheme.get_default()
                return icon_theme.lookup_icon(item['Id'], 22, 0).get_filename()

            else:
                return icon_theme.lookup_icon("computer", 22, 0).get_filename()

def render():
    # customize this function to your needs
    # see https://www.freedesktop.org/wiki/Specifications/StatusNotifierItem/StatusNotifierItem/
    # for available fields

    try:
        labels = []
        for key, item in reversed(items.items()):
            address, object = key.split('/', 1)

            if 'ToolTip' in item:
                if type(item['ToolTip']) is tuple:
                    item['ToolTip'] = item['ToolTip'][2]

                elif not type(item['ToolTip']) is str:
                    item['ToolTip'] = item['Title']
            else:
                item['ToolTip'] = item['Title']

            if os.path.isfile(item['IconName']):
                item['IconPath'] = item['IconName']
            else:
                item['IconPath'] = geticon(item)

            item['address'] = address
            item['path'] = f'/{object}'
            item['cmd'] = f'busctl --user call {address} /{object} org.kde.StatusNotifierItem Activate ii 0 0'
            item['menu_cmd'] = f'{MENU_PATH} {address} {item["Menu"]}'

            labels.append(item)


        print(json.dumps(labels))
        sys.stdout.flush()

    except BrokenPipeError:
        devnull = os.open(os.devnull, os.O_WRONLY)
        os.dup2(devnull, sys.stdout.fileno())
        sys.exit(1)  # Python exits with error code 1 on EPIPE


def get_item_data(conn, sender, path):
    def callback(conn, red, user_data=None):
        args = conn.call_finish(red)
        items[sender + path] = args[0]
        render()

    conn.call(
        sender,
        path,
        'org.freedesktop.DBus.Properties',
        'GetAll',
        GLib.Variant('(s)', ['org.kde.StatusNotifierItem']),
        GLib.VariantType('(a{sv})'),
        Gio.DBusCallFlags.NONE,
        -1,
        None,
        callback,
        None,
    )


def on_call(
    conn, sender, path, interface, method, params, invocation, user_data=None
):
    props = {
        'RegisteredStatusNotifierItems': GLib.Variant('as', items.keys()),
        'IsStatusNotifierHostRegistered': GLib.Variant('b', True),
    }

    if method == 'Get' and params[1] in props:
        invocation.return_value(GLib.Variant('(v)', [props[params[1]]]))
        conn.flush()
    if method == 'GetAll':
        invocation.return_value(GLib.Variant('(a{sv})', [props]))
        conn.flush()
    elif method == 'RegisterStatusNotifierItem':
        if params[0].startswith('/'):
            path = params[0]
        else:
            path = '/StatusNotifierItem'
        get_item_data(conn, sender, path)
        invocation.return_value(None)
        conn.flush()


def on_signal(
    conn, sender, path, interface, signal, params, invocation, user_data=None
):
    if signal == 'NameOwnerChanged':
        if params[2] != '':
            return
        keys = [key for key in items if key.startswith(params[0] + '/')]
        if not keys:
            return
        for key in keys:
            del items[key]
        render()
    elif sender + path in items:
        get_item_data(conn, sender, path)


def on_bus_acquired(conn, name, user_data=None):
    for interface in NODE_INFO.interfaces:
        if interface.name == name:
            conn.register_object('/StatusNotifierWatcher', interface, on_call)

    def signal_subscribe(interface, signal):
        conn.signal_subscribe(
            None,  # sender
            interface,
            signal,
            None,  # path
            None,
            Gio.DBusSignalFlags.NONE,
            on_signal,
            None,  # user_data
        )

    signal_subscribe('org.freedesktop.DBus', 'NameOwnerChanged')
    for signal in [
        'NewAttentionIcon',
        'NewIcon',
        'NewIconThemePath',
        'NewStatus',
        'NewTitle',
    ]:
        signal_subscribe('org.kde.StatusNotifierItem', signal)


def on_name_lost(conn, name, user_data=None):
    sys.exit(
        f'Could not aquire name {name}. '
        f'Is some other service blocking it?'
    )


if __name__ == '__main__':
    owner_id = Gio.bus_own_name(
        Gio.BusType.SESSION,
        NODE_INFO.interfaces[0].name,
        Gio.BusNameOwnerFlags.NONE,
        on_bus_acquired,
        None,
        on_name_lost,
    )

    try:
        loop = GLib.MainLoop()
        print(json.dumps([]))
        loop.run()
    finally:
        Gio.bus_unown_name(owner_id)
