#!/bin/sh
# ghostty +ssh runs this as its ssh binary: host lookups (-G) and calls without a terminal on stdin stay plain ssh, interactive sessions go through lig
case " $* " in *" -G "*) exec /usr/bin/ssh "$@" ;; esac
if [ -t 0 ]; then exec lig ssh "$@"; fi
exec /usr/bin/ssh "$@"
