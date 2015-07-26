#!/usr/bin/env bash
# zscreen script by
#	Christian Zucchelli (@Chris_Zeta) <thewebcha@gmail.com>,
#	Erik Westrup <erik.westrup@gmail.com>

opt_clickdrag="Selected Area... (click & drag mouse)"
opt_now="Now"
opt_delay="With delay"

read_conf() {
	if [ ! -d "$HOME/.zscreen" ]; then
		mkdir $HOME/.zscreen
	fi

	if [ -e "$HOME/.zscreen/conf.sh" ]; then
		. $HOME/.zscreen/conf.sh
	fi

	# Set default values.
  export ZSCREEN_SCREENSHOT_DIR=${ZSCREEN_SCREENSHOT_DIR:-"$HOME/Screenshots"}
  export ZSCREEN_FILEFMT=${ZSCREEN_FILEFMT:-'%Y-%m-%d--%s_$wx$h_scrot.png'}
  export ZSCREEN_ALWAYS_UPLOAD=${ZSCREEN_ALWAYS_UPLOAD:-"false"}
  export ZSCREEN_UPLOAD_CMD=${ZSCREEN_UPLOAD_CMD:-'zimgur'}

	if [ ! -d "$ZSCREEN_SCREENSHOT_DIR" ]; then
		mkdir -p "$ZSCREEN_SCREENSHOT_DIR"
  fi
}

ask_mode() {
	zenity --width 350 --height 220 --list --text "Screenshot mode" --radiolist --column "Pick" --column "Options" TRUE "$opt_clickdrag" FALSE "$opt_now" FALSE "$opt_delay"
}

ask_upload() {
	if [ "$ZSCREEN_ALWAYS_UPLOAD" == "true" ]; then
		echo "true"
	else
		zenity --question --text "Do you want upload the screenshot?"
		[ "$?" == "0" ] && echo "true" || echo "false"
	fi
}

ask_delay() {
	zenity --entry --title="With delay" --text="Enter seconds of delay:" --entry-text "5"
}

use_scrot() {
	local upload="$1"
	local scrotargs="$2"

	local cmdline="scrot ${scrotargs} \${ZSCREEN_FILEFMT} -e \"sleep 2 & mv \\"'$'"f ${ZSCREEN_SCREENSHOT_DIR}"
	if [ "$upload" == "true" ]; then
		cmdline="$cmdline & $ZSCREEN_UPLOAD_CMD ${ZSCREEN_SCREENSHOT_DIR}/\\"'$'"f"
	fi
	cmdline="$cmdline\""
	eval "$cmdline"
}

read_conf
mode=$(ask_mode)
case "$mode" in
	"$opt_clickdrag")
		upload=$(ask_upload)
		use_scrot "$upload" "-s"
		;;
	"$opt_now")
		upload=$(ask_upload)
		use_scrot "$upload" "-d 1"
		;;
	"$opt_delay")
		upload=$(ask_upload)
		delay=$(ask_delay)
		use_scrot "$upload" "-d $delay"
		;;
esac
