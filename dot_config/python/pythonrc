try:
    import atexit
    import os
    import sys
    from pathlib import Path
    import readline
except ImportError as e:
    print(f"Couldn't load module. {e}")
    sys.exit(1)


################
# TAB COMPLETION #
##################

try:
    readline.parse_and_bind("tab: complete")
except ImportError:
    pass


### XDG Compliant History File
# See https://gist.github.com/viliampucik/8713b09ff7e4d984b29bfcd7804dc1f4?permalink_comment_id=4582040#gistcomment-4582040

# Destroy default history file writing hook (and also tab completion, which is why we manually added it above)
if hasattr(sys, '__interactivehook__'):
    del sys.__interactivehook__


histfile = Path(os.getenv("XDG_CACHE_HOME", Path.home() / ".cache")) / "python_history"
try:
    histfile.touch(exist_ok=True)
except FileNotFoundError: # Probably the parent directory doesn't exist
    histfile.parent.mkdir(parents=True, exist_ok=True)

readline.read_history_file(histfile)
# Don't store an obscene amount of history
readline.set_history_length(5000)
# Write to history file on exit
atexit.register(readline.write_history_file, histfile)
