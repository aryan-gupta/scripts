#!/bin/bash

# https://techwiser.com/custom-keyboard-shortcuts-ubuntu/
# https://github.com/UbuntuBudgie/budgie-xfdashboard/blob/master/usr/share/budgie-remix/define-custom-keyboard-shortcut.py

gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"

function set_custom_keybinds() {
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[
          '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/'
        , '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/'
        , '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/'
        , '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/'
    ]"
}

set_custom_keybinds
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'terminal_launch'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Alt>t'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'/usr/bin/alacritty'"

set_custom_keybinds
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'web_browser_launch'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'<Alt>c'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'/snap/bin/firefox'"

set_custom_keybinds
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name "'file_browser_launch'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "'<Alt>f'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "'/bin/nautilus'"

# https://askubuntu.com/questions/1036473
# gsettings list-recursively | grep screen
gsettings set org.gnome.shell.keybindings screenshot '[]'
gsettings set org.gnome.shell.keybindings screenshot-window '[]'
gsettings set org.gnome.shell.keybindings show-screen-recording-ui '[]'
gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'
set_custom_keybinds
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name "'screenshot_ui'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding "'Print'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command "'/bin/flameshot gui'"

gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings
