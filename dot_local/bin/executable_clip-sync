#!/usr/bin/env python3
import subprocess
import traceback

##############################################################################
#                           Utility Functions
##############################################################################

def command_exists(cmd):
    """Check if a command is available in PATH."""
    return subprocess.run(['which', cmd], capture_output=True).returncode == 0

def decode_utf8(data: bytes) -> str:
    """Decode bytes to string (UTF-8) safely (replace errors)."""
    return data.decode('utf-8', errors='replace').rstrip('\x00')

def normalize_text(data: bytes) -> bytes:
    """
    Normalize text data to reduce unnecessary re-copies.
    For example, strip trailing newlines/spaces.
    """
    s = decode_utf8(data)
    # Remove trailing newlines
    s = s.strip('\r\n')
    return s.encode('utf-8', errors='replace')

def is_text_mime(mime: str) -> bool:
    """Check if the MIME type indicates textual data."""
    if mime.startswith('text/'):
        return True
    if mime in ('UTF8_STRING', 'STRING'):
        return True
    return False

##############################################################################
#                  Wayland Clipboard (wl-copy / wl-paste)
##############################################################################

def list_wayland_targets() -> list[str]:
    """Get the list of MIME types from the Wayland clipboard."""
    try:
        out = subprocess.run(['wl-paste', '-l'],
                             capture_output=True, timeout=0.5, check=True)
        return decode_utf8(out.stdout).splitlines()
    except:
        return []

def pick_wayland_mime() -> str:
    """
    MIME priority (Wayland → X11):
      1) text/uri-list       (file lists)
      2) text/html           (sometimes images in Firefox appear as HTML)
      3) image/*             (raw images)
      4) text/plain;charset=utf-8
      5) text/plain
      6) UTF8_STRING (fallback)
    """
    targets = list_wayland_targets()
    targets = list(dict.fromkeys(targets))  # remove duplicates if any

    # 1) text/uri-list
    if 'text/uri-list' in targets:
        return 'text/uri-list'
    # 2) text/html
    if 'text/html' in targets:
        return 'text/html'
    # 3) image/*
    for t in targets:
        if t.startswith('image/'):
            return t
    # 4) text/plain;charset=utf-8
    if 'text/plain;charset=utf-8' in targets:
        return 'text/plain;charset=utf-8'
    # 5) text/plain
    if 'text/plain' in targets:
        return 'text/plain'
    # 6) fallback
    if 'UTF8_STRING' in targets:
        return 'UTF8_STRING'
    return 'text/plain;charset=utf-8'

def get_wayland_clipboard() -> tuple[bytes, str]:
    """Return (raw_data, mime) from Wayland clipboard."""
    mime = pick_wayland_mime()
    try:
        out = subprocess.run(['wl-paste', '-t', mime],
                             capture_output=True, timeout=0.8)
        data = out.stdout
        return (data, mime)
    except:
        traceback.print_exc()
        return (b'', '')

def set_wayland_clipboard(data: bytes, mime: str):
    """
    Write data to Wayland clipboard.
    If it's text, use text/plain;charset=utf-8.
    Otherwise use the original MIME (e.g., image/png).
    """
    try:
        if is_text_mime(mime):
            chosen_mime = 'text/plain;charset=utf-8'
        else:
            chosen_mime = mime
        subprocess.run(['wl-copy', '-t', chosen_mime], input=data, check=True)
    except:
        traceback.print_exc()

##############################################################################
#                  X11 Clipboard (xclip)
##############################################################################

def list_x11_targets() -> list[str]:
    """Get the list of MIME types from the X11 clipboard."""
    try:
        out = subprocess.run(['xclip', '-selection', 'clipboard',
                              '-o', '-t', 'TARGETS'],
                             capture_output=True, timeout=0.5, check=True)
        decoded = decode_utf8(out.stdout)
        return decoded.splitlines()
    except:
        return []

def pick_x11_mime() -> str:
    """
    MIME priority (X11 → Wayland):
      1) text/uri-list
      2) text/html
      3) image/*
      4) text/plain;charset=utf-8
      5) text/plain
      6) UTF8_STRING
    """
    targets = list_x11_targets()

    if 'text/uri-list' in targets:
        return 'text/uri-list'
    if 'text/html' in targets:
        return 'text/html'
    for t in targets:
        if t.startswith('image/'):
            return t
    if 'text/plain;charset=utf-8' in targets:
        return 'text/plain;charset=utf-8'
    if 'text/plain' in targets:
        return 'text/plain'
    if 'UTF8_STRING' in targets:
        return 'UTF8_STRING'
    return 'text/plain;charset=utf-8'

def get_x11_clipboard() -> tuple[bytes, str]:
    """Return (raw_data, mime) from X11 clipboard."""
    mime = pick_x11_mime()
    try:
        out = subprocess.run(['xclip', '-selection', 'clipboard',
                              '-o', '-t', mime],
                             capture_output=True, timeout=0.8)
        data = out.stdout
        return (data, mime)
    except:
        traceback.print_exc()
        return (b'', '')

def set_x11_clipboard(data: bytes, mime: str):
    """
    Write data to X11 clipboard.

    Note:
      If you copy an image, and then run 'xclip -o' (without '-t'), you'll likely
      get an error 'cannot convert CLIPBOARD selection to target STRING' because
      no text target is provided for an image. Use 'xclip -o -t image/png' instead.
    """
    try:
        subprocess.run(["xclip", "-selection", "clipboard",
                        "-t", mime],
                       input=data, check=True)
    except:
        traceback.print_exc()

##############################################################################
#                            Main Loop
##############################################################################

def main():
    # Check required tools
    for tool in ['wl-copy', 'wl-paste', 'xclip', 'clipnotify']:
        if not command_exists(tool):
            print(f"Error: '{tool}' not found in PATH.")
            return

    print("Starting Wayland ↔ X11 clipboard sync...")

    # Store the last known data (bytes) + MIME for both sides
    last_w_data = b''
    last_w_mime = ''
    last_x_data = b''
    last_x_mime = ''

    while True:
        # clipnotify will wake up on any clipboard change
        p = subprocess.Popen(['clipnotify'])
        p.wait()

        # Read both clipboards
        w_raw, w_mime = get_wayland_clipboard()
        x_raw, x_mime = get_x11_clipboard()

        # Normalize text data to reduce duplicates
        if is_text_mime(w_mime) and w_raw:
            w_norm = normalize_text(w_raw)
        else:
            w_norm = w_raw

        if is_text_mime(x_mime) and x_raw:
            x_norm = normalize_text(x_raw)
        else:
            x_norm = x_raw

        w_changed = (w_norm != b'' and w_norm != last_w_data)
        x_changed = (x_norm != b'' and x_norm != last_x_data)

        if w_changed and not x_changed:
            # Wayland changed
            if w_norm != last_x_data:
                print(f"[Wayland -> X11] MIME={w_mime}")
                set_x11_clipboard(w_norm, w_mime)
                last_x_data = w_norm
                last_x_mime = w_mime

            last_w_data = w_norm
            last_w_mime = w_mime

        elif x_changed and not w_changed:
            # X11 changed
            if x_norm != last_w_data:
                print(f"[X11 -> Wayland] MIME={x_mime}")
                set_wayland_clipboard(x_norm, x_mime)
                last_w_data = x_norm
                last_w_mime = x_mime

            last_x_data = x_norm
            last_x_mime = x_mime

        elif w_changed and x_changed:
            # Both changed - pick Wayland priority
            print(f"[Conflict] Both changed. Preferring Wayland -> X11 (MIME={w_mime})")
            if w_norm != last_x_data:
                set_x11_clipboard(w_norm, w_mime)
                last_x_data = w_norm
                last_x_mime = w_mime
            last_w_data = w_norm
            last_w_mime = w_mime

        else:
            # Possibly no real difference or empty data
            if w_norm != b'':
                last_w_data = w_norm
                last_w_mime = w_mime
            if x_norm != b'':
                last_x_data = x_norm
                last_x_mime = x_mime


if __name__ == '__main__':
    main()
