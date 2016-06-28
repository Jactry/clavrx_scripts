#!/bin/sh
# $Id$
#   day_night should emoty for all 
# --- Main program

function usage() {

cat<< EOF

CG_GET_VIIRS_DATA HELP

This tools downloads MODIS data
Usage:
> cg_get_data_sips.sh <yyyy> <doy_s> <h0> <path> <sensor> <grid> <check> <day_night>

ask denis.botambekov@ssec.wisc.edu or andi.walther@ssec.wisc.edu 

Sensor choises so far:
   VIIRS
   VIIRS-NASA
   MYDO2SSH
   MODO2SSH
   MYDO21KM
   MODO21KM

Grid choises:

 0 = global;        1 = 45S - 45N;     2 = Great Lakes; 3 = South Atlantic
 4 = North Pacific; 5 = South Pacific; 6 = Samoa;       7 = Europe
 8 = USA;           9 = Brazil;        10 = Azores;     11 = China
 12 = Sahara;       13 = Dom-C;        14 = Greenland   15 = Alaska
 
Check: do loop until data are there 

EOF

}


# --- Beginning of the main program

while :; do 
   case $1 in
   
   --path)
      if [ "$2" ]; then
         L1B_PATH=$2
         shift 2
         continue
      fi
   ;;   
   
   --help)
   usage
   exit
   ;;
      -h)
   usage
   exit
   ;;
   
      *)
      break
   esac
done


# --- read arguments
args=("$@") 
year=${args[0]} 
month_s=${args[1]}
day_s=${args[2]}
hour_in=${args[3]}
path=${args[4]}
sensor=${args[5]}
grid=${args[6]}
check=${args[7]}
day_night=${args[8]}

# --- create start and end time stamps
START=$year'-'$month_s'-'$day_s'T'$hour_in':00:00Z'
END=$year'-'$month_s'-'$day_s'T'$hour_in':59:59Z'

echo "IN cg_get_data_sips.sh Searching $sensor, from $START to $END"
#echo "day_night=$day_night"

# --- find out which sensor to download
if [[ $sensor == "VIIRS" ]] ; then
   echo "!!! CAN'T PROCESS VIIRS, TRY VIIRS-NASA, STOPPING !!!"
   exit
   satellite='snpp'
   declare -a files_srch=('GMTCO IICMO SVM01 SVM02 SVM03 SVM04 SVM05 SVM06 SVM07 SVM08 SVM09 SVM10 SVM11 SVM12 SVM13 SVM14 SVM15 SVM16 GDNBO SVDNB');
   #declare -a  files_srch='GMTCO IICMO SVI01 SVI02 SVI05 SVM01 SVM02 SVM03 SVM04 SVM05 SVM06 SVM07 SVM08 SVM09 SVM10 SVM11 SVM12 SVM13 SVM14 SVM15 SVM16 GDNBO SVDNB'
fi
if [[ $sensor == "VIIRS-NASA" ]] ; then
   satellite='snpp'
   files_srch='VGEOM|VL1BM|VGEOD|VL1BD'
fi
if [[ $sensor == "MYD02SSH" ]] ; then
   satellite='aqua'
   files_srch='MYD02SSH'
fi
if [[ $sensor == "MOD02SSH" ]] ; then
   satellite='terra'
   files_srch='MOD02SSH'
fi
if [[ $sensor == "MYD021KM" ]] ; then
   satellite='aqua'
   files_srch='MYD021KM|MYD03|MYD35_L2'
fi
if [[ $sensor == "MOD021KM" ]] ; then
   satellite='terra'
   files_srch='MOD021KM|MOD03|MOD35_L2'
fi

# --- find out what region to get
# 0 = global;        1 = 45S - 45N;     2 = Great Lakes; 3 = South Atlantic
# 4 = North Pacific; 5 = South Pacific; 6 = Samoa;       7 = Europe
# 8 = USA;           9 = Brazil;        10 = Azores;     11 = China
# 12 = Sahara;       13 = Dom-C;        14 = Greenland   15 = Alaska
box=0
# global
if [ $grid == 0 ] ; then
   loc_lat=''
   loc_lon=''
   rad=''
fi
# 45S - 45N (Tropics)
if [ $grid == 1 ] ; then
   box=1
   lat_min=-50
   lat_max=50
   lon_min=-180
   lon_max=180
fi
# Great Lakes
if [ $grid == 2 ] ; then
   box=1
   lat_min=30
   lat_max=60
   lon_min=-100
   lon_max=-70
fi
# South Atlantic
if [ $grid == 3 ] ; then
   box=1
   lat_min=-35
   lat_max=-5
   lon_min=-15
   lon_max=15
fi
# North Pacific
if [ $grid == 4 ] ; then
   loc_lat=25.
   loc_lon=-130.
   rad=2000
fi
# South Pacific
if [ $grid == 5 ] ; then
   box=1
   lat_min=-30
   lat_max=0
   lon_min=-110
   lon_max=70
fi
# Samoa
if [ $grid == 6 ] ; then
   box=1
   lat_min=-30
   lat_max=0
   lon_min=-180
   lon_max=-155
fi
# Europe
if [ $grid == 7 ] ; then
   box=1
   lat_min=35
   lat_max=65
   lon_min=-5
   lon_max=35
fi
# USA
if [ $grid == 8 ] ; then
   box=1
   lat_min=20
   lat_max=60
   lon_min=-130
   lon_max=-60
fi
# Brazil
if [ $grid == 9 ] ; then
   box=1
   lat_min=-35
   lat_max=5
   lon_min=-85
   lon_max=-30
fi
# Azores
if [ $grid == 10 ] ; then
   box=1
   lat_min=20
   lat_max=50
   lon_min=-35
   lon_max=-5
fi
# China
if [ $grid == 11 ] ; then
   box=1
   lat_min=5
   lat_max=55
   lon_min=80
   lon_max=150
fi
# Sahara
if [ $grid == 12 ] ; then
   box=1
   lat_min=10
   lat_max=40
   lon_min=-25
   lon_max=65
fi
# Dom-C
if [ $grid == 13 ] ; then
   loc_lat=-75.1
   loc_lon=123.35
   rad=1000
fi
# Greenland
if [ $grid == 14 ] ; then
   box=1
   lat_min=63
   lat_max=80
   lon_min=-55
   lon_max=-25
fi

# Alaska
if [ $grid == 15 ] ; then
   box=1
   lat_min=47
   lat_max=77
   lon_min=-167
   lon_max=-137
fi

# Tropics
if [ $grid == 16 ] ; then
   box=1
   lat_min=-5
   lat_max=25
   lon_min=-105
   lon_max=-75
fi 

cd $path
if [ $check -eq 0 ] ; then
  [ ! -d $hour_in ] && hhh_2d=`echo $hour_in | awk '{printf ("%02i", $1)}'` && mkdir -v -p $hhh_2d
  cd $hhh_2d 
fi
#echo here I am
#pwd

#sh -c './peate_downloader.sh '$year'-'$month'-'$day'+'$hour_in':00:00 '$year'-'$month'-'$day'+'$hour_in':59:59 '$files_srch
#---------- search data and create a script to download                                                                                                             
#curl 'http://sips.ssec.wisc.edu/api/v1/products/search.sh?start=2016-04-20T15:25:00Z&end=2016-04-20T15:26:00Z&products=VGEOM|VL1BM&satellite=snpp&solar_zen=&bbox=&loc=' > downloader.sh
if [ $box == 0 ] ;then
   if [ $grid == 0 ] ; then
      URL="http://sips.ssec.wisc.edu/api/v1/products/search.sh?start=$START&end=$END&loc=&solar_zen=$day_night&products=$files_srch&satellite=$satellite"
   else
      URL="http://sips.ssec.wisc.edu/api/v1/products/search.sh?start=$START&end=$END&loc=$loc_lat,$loc_lon,$rad&tod=$day_night&products=$files_srch&satellite=$satellite"
   fi
else
   URL="http://sips.ssec.wisc.edu/api/v1/products/search.sh?start=$START&end=$END&bbox=$lat_max,$lon_max,$lat_min,$lon_min&tod=$day_night&products=$files_srch&satellite=$satellite"
fi

#echo "$URL"

SCRIPT=downloader.sh

#wget -q -O $SCRIPT """${URL}"""
curl -s  ${URL} > $SCRIPT
echo "curl -s ${URL} > $SCRIPT"

if [ "$?" -ne "0" ]; then
  echo "Retreiving file list failed" 
  rm $SCRIPT &> /dev/null
else
  echo "Downloaded $SCRIPT"
fi
#---------- if this is just a check for files return #
if [ $check -ne 0 ] ; then
  files_exist=$(grep Results $SCRIPT | tr -dc '[0-9]')
  #pwd
  #echo files_exist= $files_exist
  rm $SCRIPT
  if [ $files_exist -eq 0 ] ; then
     return 0 # no files
  else
     return 1 # files exist
  fi
fi

#---------- add -nc to wget line                                                                                                                                    
old_strg="curl -sO"
new_strg="wget -q -nc "
sed "s/$old_strg/$new_strg/g" <$SCRIPT > 'tmp.txt'  # for wget
#sed -e 's/-s/-s -z "Aug 25 2014"/g' <$SCRIPT > 'tmp.txt'  # for curl
mv 'tmp.txt' $SCRIPT

#---------- move and run script
chmod u+x $SCRIPT

echo "Running $SCRIPT"
bash $SCRIPT

if [ ! $? ]; then
  echo "Warning: $SCRIPT returned non-zero status"
fi

exit


