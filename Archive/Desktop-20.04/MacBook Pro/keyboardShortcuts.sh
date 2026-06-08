#!/usr/bin/env bash


# This is the commands to backup all possible keyboard shortcut file locations.
#dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > dump_1
#dconf dump /org/gnome/desktop/wm/keybindings/ > dump_2
#dconf dump /org/gnome/shell/keybindings/ > dump_3
#dconf dump /org/gnome/mutter/keybindings/ > dump_4
#dconf dump /org/gnome/mutter/wayland/keybindings/ > dump_5

read -p "Do you wish to restore you custom keyboard shortcuts? [Yes/No]"
case ${answer:0:1} in
    y|Y|yes|Yes )
        #restore
        cat KbShorts/dump_1 | dconf load /org/gnome/settings-daemon/plugins/media-keys/
        cat KbShorts/dump_2 | dconf load /org/gnome/desktop/wm/keybindings/
        cat KbShorts/dump_3 | dconf load /org/gnome/shell/keybindings/
        cat KbShorts/dump_4 | dconf load /org/gnome/mutter/keybindings/
        cat KbShorts/dump_5 | dconf load /org/gnome/mutter/wayland/keybindings/
        echo "keybindings backed up."
    ;;
    * )
        echo "No? Operation canceled"
    ;;
esac
