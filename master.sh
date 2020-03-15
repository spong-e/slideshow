#!/bin/sh
# DrJ 8/2019
# call this from cron once a day to refesh random slideshow once a day
RANFILE="./random.list"
NUMFOLDERS=1
DISPLAYFOLDER="/home/pi/slideshow/pictures"
#DISPLAYFOLDERTMP="/home/alun/Picturestmp"
SLEEPINTERVAL=3
DEBUG=1
STARTFOLDER="frame"
 
echo "Starting master process at "`date`
 
#mkdir $DISPLAYFOLDERTMP
 
#listing of all Google drive files starting from the picture root
if [ $DEBUG -eq 1 ]; then echo Listing all files from Google drive; fi
rclone ls remote:"$STARTFOLDER" --max-age 2m > files
 
# filter down to only jpegs, lose the docs folders
if [ $DEBUG -eq 1 ]; then echo Picking out the JPEGs; fi
egrep '\.[jJ][pP][eE]?[gG]$' files |awk '{$1=""; print substr($0,2)}'|grep -i -v /docs/ > jpegs.list
 
# throw NUMFOLDERS or so random numbers for picture selection, select triplets of photos by putting
# names into a file
# if [ $DEBUG -eq 1 ]; then echo Generate random filename triplets; fi
# ./random-files.pl -f $NUMFOLDERS -j jpegs.list -r $RANFILE
 
# # copy over these 60 jpegs
# if [ $DEBUG -eq 1 ]; then echo Copy over these random files; fi
# cat $RANFILE|while read line; do
#   echo "Copying over image...${STARTFOLDER}/$line" 
#   rclone copy remote:"${STARTFOLDER}/$line" $DISPLAYFOLDERTMP
#   sleep $SLEEPINTERVAL
# done

# copy over these 60 jpegs
if [ $DEBUG -eq 1 ]; then echo Copy over these random files; fi
cat jpegs.list|while read line; do
  echo "Copying over image...${STARTFOLDER}/$line" 
  rclone copy remote:"${STARTFOLDER}/$line" $DISPLAYFOLDER
  sleep $SLEEPINTERVAL
done
 
# kill any qiv slideshow
if [ $DEBUG -eq 1 ]; then echo Killing old qiv slideshow; fi
pkill -9 -f qiv
 
# remove old pics
#if [ $DEBUG -eq 1 ]; then echo Removing old pictures; fi
#rm -rf $DISPLAYFOLDER
 
#mv $DISPLAYFOLDERTMP $DISPLAYFOLDER
 
 
#run looping qiv slideshow on these pictures
if [ $DEBUG -eq 1 ]; then echo Start qiv slideshow in background; fi
cd $DISPLAYFOLDER ; nohup ~/slideshow/qiv.sh &
 
if [ $DEBUG -eq 1 ]; then echo "And now it is "`date`; fi