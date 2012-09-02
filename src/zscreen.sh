#!/bin/bash

# zscreen script by Christian Zucchelli (@Chris_Zeta) <thewebcha@gmail.com>

ans=$(zenity  --list  --text "Screenshot mode" --radiolist  --column "Pick" --column "Options" TRUE "Selected Area... (click & drag mouse)" FALSE "Now" FALSE "With delay"); 

case $ans in

"Selected Area... (click & drag mouse)" ) 

zenity --question --text "Do you want upload the screenshot?"
if [ "$?" = "0" ]; then 
scrot -s '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Immagini/Screenshot/ & zimgur ~/Immagini/Screenshot/$f'
else
scrot -s '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Immagini/Screenshot/'
fi;;

"Now" ) zenity --question --text "Do you want upload the screenshot?"
if [ "$?" = "0" ]; then 
scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Immagini/Screenshot/ & zimgur ~/Immagini/Screenshot/$f'
else
scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Immagini/Screenshot/'
fi;;

"In n second" ) if zenity --entry --title="Second delay" --text="Enter second of delay:" --entry-text "5"
then echo $?

zenity --question --text "Do you want upload the screenshot?"
if [ "$?" = "0" ]; then 
scrot -d $? '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Immagini/Screenshot/ & zimgur ~/Immagini/Screenshot/$f'
else
scrot -d $? '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/Immagini/Screenshot/'
fi
fi;;

esac
