#!/bin/bash

MAIN_SCREEN="eDP1"
MAIN_MODE="1920x1080"

to_run=()
to_run_idx=0

queue_run() {
    echo "adding $1 to run_queue at index ${to_run_idx}"
    to_run[$to_run_idx]="$(echo $1|tr ' ' ' ')"
    to_run_idx=$((to_run_idx+1))
}

# Simply disable disconnected outputs
for disconnect_out in $(xrandr|grep disconnected|cut -f1 -d' ') ; do
    queue_run "xrandr --output ${disconnect_out} --off"
done

# Always enable main screen
queue_run "xrandr --output ${MAIN_SCREEN} --mode ${MAIN_MODE}"

CONNECTED=$(xrandr |grep " connected"|grep -v "${MAIN_SCREEN}"| cut -f1 -d' ')
echo "Connected: ${CONNECTED}"

# Now ask what we must do ?
for dpy in ${CONNECTED} ; do
    choices=""
    for dpy2 in ${CONNECTED} ${MAIN_SCREEN} ; do
        if [ "${dpy}" == "${dpy2}" ]; then
            echo "dpy (${dpy}) == dpy2 (${dpy})"
            continue
        fi
        for pos in "left-of" "right-of" ; do
            choices="${choices} ${pos} ${dpy2}"
        done
    done
    choices="${choices} disabled"
    ret=$(zenity --list --title "${dpy}" --text "How should ${dpy} be configured" --column "Modes" ${choices})
    if [ "${ret}" == "disabled" ]; then
        queue_run "xrandr --output ${dpy} --off"
    else
        queue_run "xrandr --output ${dpy} --${ret} --auto"
    fi
done

if (zenity --question --title "Apply configuration ?" --text "Do you want to apply configuration ?"); then
    idx=0
    for ((idx=0; idx<to_run_idx; idx++)); do 
        echo "==> ${to_run[$idx]}"
        ${to_run[$idx]}
    done
    if ( zenity --question --title "Restart Awesome ?" --text "Do you want to restart awesome ?" ) ; then
        echo "awesome.restart()"|awesome-client
    fi
fi

