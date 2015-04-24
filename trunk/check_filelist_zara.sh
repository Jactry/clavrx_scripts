#!/bin/sh

args=("$@")
filelist=${args[0]}
srch_str=${args[1]}

# --- read output path and file list
out_path=`sed -n '2p' $filelist`
files_tmp=`grep $srch_str $filelist`

#echo $out_path
#echo $files_tmp

# --- loop over files to check if they exist
for i in `echo ${files_tmp} | tr "," " "`
do
   #echo "L1 file $i"
   # --- check the type of L1b input file and create L2 file name 
   if [[ $srch_str == 'GMTCO' ]]
   then
      l2_file='clavrx_'${i:6:38}'.level2.hdf'
   elif [[ $srch_str == 'MYD02SSH' ]] || [[ $srch_str == 'MOD02SSH' ]] \
     || [[ $srch_str == 'MYD021KM' ]] || [[ $srch_str == 'MOD021KM' ]] 
   then
      l2_file='clavrx_'${i:0:40}'.level2.hdf'
   fi
   if [[ $srch_str == 'HS_H08' ]] ; then
      l2_file='clavrx_'${i:3:17}'.level2.hdf'
   fi

   # --- look for L2 file, if exists delete coresponding L1b filename
   #echo "looking for $out_path$l2_file"
   if [ -f "$out_path$l2_file" ]
   then
      echo "$l2_file found, deleting."
      grep -v $i $filelist > 'tmp.txt'; mv 'tmp.txt' $filelist 
   fi

done

#0         1         2         3         4
#01234567890123456789012345678901234567890123456789
#MYD02SSH.A2014001.1000.006.2014009211230.hdf
#clavrx_MOD02SSH.A2012001.1735.006.2012290215947.level2.hdf
#HS_H08_20150324_2130_B01_FLDK.nc

#echo END OF THE CODE

