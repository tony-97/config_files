#°/bin/bash

MY_HOME_TONY=/home/tony

for folders_icons in $MY_HOME_TONY/.icons $MY_HOME_TONY/.local/share/icons /usr/share/icons
do
    echo Updating icos from folder...... $folders_icons
    echo ========================================
    for folder_icon in $folders_icons/*
    do
        echo "Updating icon from $folder_icon"
        gtk-update-icon-cache -f -t $folder_icon
    done
done
