#!/usr/bin/env bash

build-system () {
  rebos gen current build
}

sync-system () {
  cd $HOME/.config/rebos
  git pull origin main

  cd $HOME

  rebos gen commit "SYNC"

  build-system

  rebos gen tidy-up
}
