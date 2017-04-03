#!/bin/bash

# Script to read VIIRS IDPS data from CIMSS/SSEC/UW-Madison Data Center FTP
# !!!!! ATTENTION: THEY KEEP ONLY 30-31 DAY OF DATA FROM TODAY !!!!!
# 
# Author: Denis B. (denis.botambekov@ssec.wisc.edu)
#
# April 4th, 2015
#
# Example to Run:
# ./download_viirs_ftp.sh YEAR DOY HOUR PATH
#
# ./download_viirs_ftp.sh 2016 172 0 /data/Satellite_Input/VIIRS/2016172
#
# Note: If path doesn't exist it would be created
#


# --- read arguments
args=("$@")
year=${args[0]}
doy=${args[1]}
hour_s=${args[2]}
path=${args[3]}

# --- add zeroes to doy
if [ $doy -lt 10 ] ; then
  doy_s=`expr 00$doy`
elif [ $doy -ge 10 ] && [ $doy -lt 100 ] ; then
  doy_s=`expr 0$doy`
else
  doy_s=$doy
fi
 

# --- calculate month, day, number of hours per this day
month_s=$(date -d "01/01/${year} +${doy_s} days -1 day" "+%m")
day_s=$(date -d "01/01/${year} +${doy_s} days -1 day" "+%d")

# --- construct search string
#srch_str="_npp_d${year}${month_s}${day_s}_t${hour_s}"
srch_str="_npp_d${year}${month_s}${day_s}"

# --- go to level1b folder
[ ! -d $path ] && mkdir -v -p $path
cd $path
echo 'Wait until all data downloads here'
pwd

# --- download from ftp
ftp -in snpp.ssec.wisc.edu << SCRIPTEND
user anonymous denis.botambekov@ssec.wisc.edu
binary
cd ingest/viirs/npp/${year}/${doy_s}/GMTCO/
mget GMTCO${srch_str}*
cd ../GDNBO/
mget GDNBO${srch_str}*
cd ../SVDNB/
mget SVDNB${srch_str}*
cd ../SVM01/
mget SVM01${srch_str}*
cd ../SVM02/
mget SVM02${srch_str}*
cd ../SVM03/
mget SVM03${srch_str}*
cd ../SVM04/
mget SVM04${srch_str}*
cd ../SVM05/
mget SVM05${srch_str}*
cd ../SVM06/
mget SVM06${srch_str}*
cd ../SVM07/
mget SVM07${srch_str}*
cd ../SVM08/
mget SVM08${srch_str}*
cd ../SVM09/
mget SVM09${srch_str}*
cd ../SVM10/
mget SVM10${srch_str}*
cd ../SVM11/
mget SVM11${srch_str}*
cd ../SVM12/
mget SVM12${srch_str}*
cd ../SVM13/
mget SVM13${srch_str}*
cd ../SVM14/
mget SVM14${srch_str}*
cd ../SVM15/
mget SVM15${srch_str}*
cd ../SVM16/
mget SVM16${srch_str}*
cd ../VICMO/
mget VICMO${srch_str}*
SCRIPTEND

echo "DONE!"



