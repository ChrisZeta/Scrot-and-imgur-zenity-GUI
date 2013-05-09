#!/bin/bash

# zscreen script by Christian Zucchelli (@Chris_Zeta) <thewebcha@gmail.com>

if [ ! -d "$HOME/.zscreen" ]
then
mkdir ~/.zscreen
fi

cd ~
if [ ! -d "Screenshots" ]
then mkdir ~/Screenshots
fi

ans=$(zenity --list --text "Screenshot mode" --radiolist --column "Pick" --column "Options" TRUE "Selected Area... (click & drag mouse)" FALSE "Now" FALSE "With delay");

case $ans in

"Selected Area... (click & drag mouse)" )

zenity --question --text "Do you want upload the screenshot?"
if [ "$?" = "0" ]; then
scrot -s '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Screenshots/ & zimgur ~/Screenshots/$f'
else
scrot -s '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Screenshots/'
fi;;

"Now" ) zenity --question --text "Do you want upload the screenshot?"
if [ "$?" = "0" ]; then
scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Screenshots/ & zimgur ~/Screenshots/$f'
else
scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Screenshots/'
fi;;

"With delay" ) d=$(zenity --entry --title="With delay" --text="Enter second of delay:" --entry-text "5")
zenity --question --text "Do you want upload the screenshot?"
if [ "$?" = "0" ]; then
scrot -d "$d" '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Screenshots/ & zimgur ~/Screenshots/$f'
else
scrot -d "$d" '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Screenshots/'
fi;;

esac
