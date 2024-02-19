<div align="center">
    <h1>【 Evangelospro's dotfiles 】</h1>
</div>

![](https://img.shields.io/github/last-commit/evangelospro/dotfiles?&style=for-the-badge&color=FFB1C8&logoColor=D9E0EE&labelColor=292324)
![](https://img.shields.io/github/stars/evangelospro/dotfiles?style=for-the-badge&logo=andela&color=FFB686&logoColor=D9E0EE&labelColor=292324)
![](https://img.shields.io/github/repo-size/evangelospro/dotfiles?color=CAC992&label=SIZE&logo=googledrive&style=for-the-badge&logoColor=D9E0EE&labelColor=292324)

![1.png](Pictures/showcase/1.png)

# ELARCH<a name="top"></a>

1. [How to apply?](#applying)
2. [Keybindings](#keybindings)
3. [Contributing](#contributing)
4. [Sources / Inspiration](#sources-and-inspiration)

## My dotfiles can be applied with the below oneliners. BUT `I highly recommend that you fork this repo` and edit the files to your liking before applying them(using your GitHub username). Remember to `grep for evangelospro and replace with your username`. <a name="applying"></a>

```bash
export GITHUB_USERNAME=Evangelospro
curl --silent https://raw.githubusercontent.com/$GITHUB_USERNAME/dotfiles/main/install.sh|bash
```

## Keybindings

### Hyprland

| Keybinding  | Action        |
| ----------- | ------------- |
| Windows + M | Exit Hyprland |

### Launch / Reload Applications

| Keybinding          | Action                                            |
| ------------------- | ------------------------------------------------- |
| Windows + Enter     | Launch Terminal                                   |
| Windows + L         | Lock Screen(swaylock)                             |
| Windows + Space     | Launch launcher(anyrun)                           |
| Windows + V         | Open clipboard manager (wl-clipboard)             |
| Windows + C         | Select color from screen (hyprpicker) and copy it |
| Windows + E         | Open file manager(Nemo)                           |
| Windows + R         | Resize window with slurp                          |
| Windows + Shift + R | Reload the bar on top (waybar)                    |

### Close / Fullscreen / Kill Applications / Arrange monitors

| Keybinding          | Action                                                |
| ------------------- | ----------------------------------------------------- |
| ALT + F4            | Close focused window                                  |
| CTRL + SHIFT + ESC  | Kill window clicked on (xkill or windows taskmanager) |
| Windows + F         | Toggle fullscreen on focused window                   |
| Windows + Shift + F | Toggle floating on focused window                     |
| Windows + P         | Arrange monitors (extend / duplicate)                 |

### Screenshot / OCR

| Keybinding  | Action                                     |
| ----------- | ------------------------------------------ |
| prtsc       | Take screenshot interactively (flameshot)  |
| Windows + O | Copy text from screen with OCR (tesseract) |

### Move focus between windows in the current workspace

| Keybinding           | Action                                       |
| -------------------- | -------------------------------------------- |
| Windows + Arrow keys | Move focus to the direction of the arrow key |

### Rearrange windows in the current workspace

| Keybinding     | Action                                                |
| -------------- | ----------------------------------------------------- |
| Windows + AWSD | Move focused window to the direction of the AWSD keys |

### Move Windows Between Monitors

| Keybinding                   | Action                                                               |
| ---------------------------- | -------------------------------------------------------------------- |
| Windows + SHIFT + Arrow keys | Move focused window to the monitor in the direction of the arrow key |

### Move Windows Between Workspaces

| Keybinding            | Action                                                       |
| --------------------- | ------------------------------------------------------------ |
| Windows + SHIFT + 1-9 | Move focused window to the workspace with the number pressed |
| Windows + 1-9         | Move to the workspace with the number pressed                |

### Cycle through workspaces

| Keybinding            | Action                            |
| --------------------- | --------------------------------- |
| Windows + TAB         | Cycle through workspaces forward  |
| Windows + SHIFT + TAB | Cycle through workspaces backward |

### Move window with mouse

| Keybinding               | Action                 |
| ------------------------ | ---------------------- |
| Windows + Click and drag | Move window with mouse |


## Contributing

### Bug Reports, Feature Requests and questions

-   Please use the [issue tracker](https://github.com/evangelospro/dotfiles/issues) to report any bugs, file feature requests or ask questions.

### Pull Requests

-   Feel free to fork and contribute to this project. If you feel like you can add something to it or fix a bug, go for it.
-   If you want to contribute to the project, please open a pull request.
-   If you want to add a new feature, please create an issue first to discuss if it is a good idea or not.
-   If you want to fix a bug, please also create an issue first.

## 🌟 Stars 🌟

-   _Consider leaving a star if you liked the project! Thanks!_

[![Stars](https://starchart.cc/evangelospro/dotfiles.svg)](https://starchart.cc/evangelospro/dotfiles)

## Thanks to these awesome projects and many more!!! <a name="sources-and-inspiration"></a>

-   [Arch Linux](https://archlinux.org/)
-   [Archiso](https://wiki.archlinux.org/title/Archiso)
-   [ALCI](https://alci.online/)
-   [Calamares](https://calamares.io/)
-   [Hyprland](https://aur.archlinux.org/packages/hyprland-git/)
-   [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter)
-   [Waybar](https://github.com/alexays/waybar/)
-   [Eww](https://github.com/elkowar/eww/)
-   [Wezterm](https://github.com/wez/wezterm/)
-   [Lsd](https://github.com/lsd-rs/lsd)
-   [playerctl](https://github.com/altdesktop/playerctl/)
-   [swayidle](https://archlinux.org/packages/extra/x86_64/swayidle/)
-   [envycontrol](https://github.com/bayasdev/envycontrol/)
-   [swaylock-effects](https://github.com/mortie/swaylock-effects/)
