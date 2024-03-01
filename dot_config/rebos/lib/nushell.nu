def build-system [] {
  rebos gen current build
}

def sync-system [] {
  cd ~/.config/rebos
  git pull origin main

  cd ~

  rebos gen commit "SYNC"

  build-system

  rebos gen tidy-up
}
