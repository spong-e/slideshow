#!/bin/sh
# -f : full-screen; -R : disable deletion; -s : slideshow; -d : delay <secs>; -i : status-bar;
# -m : zoom; [-r : ranomdize]
# this doesn't handle filenames with spaces:
##cd /media; qiv -f -R -s -d 5 -i -m `find /media -regex ".+\.jpe?g$"`
# this one does:
export DISPLAY=:0
if [ "$1" = "l" ]; then
# print out proposed filenames
  find . -regex ".+\.[jJ][pP][eE]?[gG]$"
else
# args: f fullscreen d delay s slideshow l autorotate R readonly I statusbar
# i nostatusbar m maxspect
  find . -regex ".+\.[jJ][pP][eE]?[gG]$" -print0|xargs -0 qiv -fRsmil -d 10
fi
