#!/usr/bin/env bash

set -euo pipefail

hyprctl -j binds |
jq -r '
  def getbit($position; $n):
    fmod($n / ($position | exp2) | floor; 2) | fabs;


  def mod($position; $name):
    if getbit($position; .modmask) == 1 then $name else empty end;


  def keys:
    [mod(6; "SUPER"), mod(2; "CTRL"), mod(3; "ALT"), mod(0; "SHIFT"), .key]
    | map(select(. != ""))
    | join("+");


  [.[] | select(.has_description and .description != "") | { keys: keys, description }]
  | (map(.keys | length) | max + 2) as $width
  | .[]
  | .keys + " |" + (" " * ($width - (.keys | length))) + .description
' | walker -d
