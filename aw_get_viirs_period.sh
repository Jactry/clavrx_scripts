#!/bin/sh
# downloads alaska (if 15) or USA (if 8) for time period
# $Id$

args=("$@") 
doy0=${args[0]} 
doy1=${args[1]} 

shift 2

for (( ddd = $doy0; ddd < $doy1; ddd++ ))
do
ddd_3d=`echo $ddd | awk '{printf ("%03i", $1)}'`
for (( hhh = 0; hhh < 24; hhh++ ))
do

hhh_2d=`echo $hhh | awk '{printf ("%02i", $1)}'`
echo $hhh_2d

mkdir -p  ${ddd_3d}/${hhh_2d}
cg_get_data_sips.sh 2014 $ddd $hhh ${ddd_3d} VIIRS 8 0 N
done

done
