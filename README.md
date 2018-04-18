# zenity-xrandr-helper
A small bash script that use zenity and xrandr to configure your displays.

To use it:

1. First verify you have both zenity and xrandr installed (if you're using Debian GNU/Linux, just apt-get install zenity x11-xserver-utils).
2. Launch a terminal and, using xrandr, identify your **main** screen (aka the one you want to be always activated).
3. Edit the script display.sh to replace the value of MAIN_SCREEN with your display name and MAIN_MODE with the wished mode.
4. Just launch the script to configure your display.

Please note that:
_ since i'm using awesome window manager, this script will prompt you for restarting awesome. To avoid this, simply remove line 53-55.
_ Screen rotation isn't implemented ... because i don't need it. Feel free to fork and implement it.
