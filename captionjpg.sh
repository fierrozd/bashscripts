#!/bin/bash
# Usage: must have argument like captionjpg.sh *.fits
#shopt -s nullglob
for f in $@
do
# cut extension off filename
  file=$(echo "$f" | cut -d '.' -f 1)
  file=$file.jpg
# read fits info
  object=$(dfits $f | fitsort object | awk '{print $2}' | tail -n 1)
#  dfits *.fits | fitsort object naxis1 naxis2 exptime
#  dfits *.fits | fitsort object slitname dichname graname grisname trapdoor
#  dfits *.fits | fitsort object airmass ra dec
#  dfits *.fits | fitsort object rotmode rotposn rotpposn opt_pa
  slit=$(dfits $f | fitsort slitname | awk '{print $2}' | tail -n 1)
  dich=$(dfits $f | fitsort dichname | awk '{print $2}' | tail -n 1)
  grat=$(dfits $f | fitsort graname  | awk '{print $2}' | tail -n 1) #RED  SIDE
  gris=$(dfits $f | fitsort grisname | awk '{print $2}' | tail -n 1) #BLUE SIDE
  trpd=$(dfits $f | fitsort trapdoor | awk '{print $2}' | tail -n 1)
  expt=$(dfits $f | fitsort exptime  | awk '{print $2}' | tail -n 1)
   if [ -f $file ]; then
# call imagemagick
   convert $file -pointsize 20 -fill orange\
     -annotate +10+20  "$object"\
     -annotate +10+40  "$slit"\
     -annotate +10+60  "$dich"\
     -annotate +10+80  "$grat"\
     -annotate +10+100 "$trpd"\
     -annotate +10+120 "$expt sec" $file
   echo $file $object
   else
   echo $file does not exist
   fi
done
