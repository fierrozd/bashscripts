#!/bin/bash
# Usage: must have argument like captionjpg.sh *.fits
#shopt -s nullglob
for f in $@
do
# read fits info
  object=$(dfits $f | fitsort object | awk '{print $2}' | tail -n 1)
#  dfits *.fits | fitsort object naxis1 naxis2 exptime
#  dfits *.fits | fitsort object slitname dichname graname grisname trapdoor
#  dfits *.fits | fitsort object airmass ra dec
#  dfits *.fits | fitsort object rotmode rotposn rotpposn opt_pa
   koa=$(dfits $f | fitsort koaid    | awk '{print $2}' | tail -n 1)
  slit=$(dfits $f | fitsort slitname | awk '{print $2}' | tail -n 1)
  dich=$(dfits $f | fitsort dichname | awk '{print $2}' | tail -n 1)
  grat=$(dfits $f | fitsort graname  | awk '{print $2}' | tail -n 1) #RED  SIDE
  gris=$(dfits $f | fitsort grisname | awk '{print $2}' | tail -n 1) #BLUE SIDE
  trpd=$(dfits $f | fitsort trapdoor | awk '{print $2}' | tail -n 1)
  expt=$(dfits $f | fitsort elaptime | awk '{print $2}' | tail -n 1)
  fear=$(dfits $f | fitsort feargon  | awk '{print $2}' | tail -n 1)
 otype=$(dfits $f | fitsort obstype  | awk '{print $2}' | tail -n 1)
# cut extension off filename
  file=$(echo "$koa" | cut -d '.' -f 1-3)
  file=$file.jpg
# cut extension off filename
  f2=$(echo "$f" | cut -d '.' -f 1)
  fout=$f2.jpg
   if [ -f $file ]; then
# call imagemagick
#convert MyJpeg.jpg -print "Size: %wx%h\n" /dev/null
#Size: 4168x688
   convert $file -crop +2400+0\
     -crop -400-0\
     -pointsize 40 -fill orange\
     -annotate +2410+80  "$f"\
     -annotate +2410+140  "$object"\
     -annotate +2410+200  "$slit"\
     -annotate +2410+260  "di: $dich"\
     -annotate +2410+320  "gr: $grat"\
     -annotate +2410+380 "$trpd $expt sec"\
     -annotate +2410+440 "type: $otype" $fout
   echo $file $object $fout
   else
   echo $file does not exist
   fi
done
