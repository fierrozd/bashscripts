#!/bin/bash
# Usage: must have argument like fits2jpg.sh *.fits
#shopt -s nullglob
echo "defaults write com.apple.dock workspaces-auto-swoosh -bool NO"
echo "killall Dock"

for f in $@
do
# cut extension off filename
  file=$(echo $f | cut -d '.' -f 1)
# read axis info
  axis1=$(dfits $f | fitsort naxis1 | awk '{print $2}' | tail -n 1)
  axis2=$(dfits $f | fitsort naxis2 | awk '{print $2}' | tail -n 1)
  if [[ -z $axis1 ]]; then
  echo I think you forgot to use bias script first
  echo Cant find naxis1 && exit
  fi
  if (($axis1 < $axis2 )); then
# calculate zoom and geoheight for portrait images
  geoy=800    #max height for mac desktop
  zoom=$(awk -v m=$axis2 'BEGIN { print 800  / (m + 1460) }')
  geox=$(echo $axis2 $zoom | awk '{print ($1*$2) + 12 }')
  else
# calculate zoom and geoheight for landscape images (prefered)
  geox=1210   #max width for mac desktop
  zoom=$(awk -v m=$axis1 'BEGIN { print 1210 / (m - 640) }')
  geoy=$(echo $axis2 $zoom | awk '{print ($1*$2) + 222 }') 
  fi
# format pretty
  zoomf=$(printf "%0.2f\n" $zoom)
  geoxf=$(printf "%0.0f\n" $geox)
  geoyf=$(printf "%0.0f\n" $geoy)
  geometry=$geoxf"x"$geoyf
# call ds9
  echo "Pulling up $f with ds9"
# echo "ds9 -geometry $geometry -scale mode zscale $f -zoom $zoomf"
   ds9 -geometry $geometry -scale mode zscale $f -zoom $zoomf -saveimage jpeg $file.jpg -exit
   echo "Saved image as $file.jpg"
   echo
done

echo "defaults write com.apple.dock workspaces-auto-swoosh -bool YES"
echo "killall Dock"

