"""
Author: @DodoLeDev

Add a 'Send to Device' shortcut button to the right-click menu (Nautilus GTK4)

Based on the file collision-extension.py created by myself and @GeopJr for the Collision application
    -> https://github.com/GeopJr/Collision/blob/main/nautilus-extension/collision-extension.py

"""

from subprocess import Popen, check_call, CalledProcessError
from urllib.parse import urlparse, unquote
from gi import require_version
from gettext import textdomain, gettext

textdomain('ca.andyholmes.Valent')
_ = gettext

require_version('Gtk', '4.0')
require_version('Nautilus', '4.0')

from gi.repository import Nautilus, GObject, Gtk, Gdk

def is_valent_installed():
    try:
        check_call("gapplication list-apps | grep \"ca.andyholmes.Valent\" &> /dev/null", shell=True)
        return True
    except CalledProcessError:
        return False

class NautilusValent(Nautilus.MenuProvider, GObject.GObject):

    def __init__(self):
        self.window = None
        return
    
    # Executed method when the right-click entry is clicked
    def openWithValent(self, menu, files):

        get_path = lambda file: repr(unquote(urlparse(file.get_uri()).path)) # URI parser

        file_pathes = [get_path(oneFile) for oneFile in files]  # Build the file list
        Popen("gapplication launch ca.andyholmes.Valent " + " ".join(file_pathes), shell=True)  # Execute the command
    
    # Displays nothing on a right click on the background
    def get_background_items(self, files):
        return

    def get_file_items(self, files):

        # Do not display menu entry if at least 1 folder is selected
        def check_file_types():
            for file in files:
                if file.is_directory():
                    return True
            return False
        
        # The option doesn't appear when a folder is selected
        if check_file_types() or not is_valent_installed(): 
            return ()

        # Registering entry in the Nautilus right-click
        menu_item = Nautilus.MenuItem(
                        name="NautilusValent::SendToDevice",
                        label=_("Send to Device..."))

        menu_item.connect('activate', self.openWithValent, files)

        return menu_item,
