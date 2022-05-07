#!/bin/bash

for dirs in ~/.icons ~/.local/share/icons /usr/share/icons
do
    echo Updating icons from folder...... $dirs
    echo ========================================
    for dir in $dirs/*
    do
        echo "Updating icon from $dir"
        gtk-update-icon-cache -f -t $dir
    done
done
