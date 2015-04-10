#!/bin/sh
# this script is for writing level2b files from existing level2 files
#
# to run type use the syntax as in following line.
# level2b_script.sh input_path output_path scid region jday_start jday_end year_start year_end node
#
# qsub -q r720.q -l vf=4G -S /bin/bash -l matlab=0 -l friendly=1 -p -200 -o /fjord/jgs/personal/dbotambekov/logs/ -e /fjord/jgs/personal/dbotambekov/logs/ -l h_rt=03:00:00 level2b_script.sh
#
# 0 = global;        1 = 45S - 45N;     2 = Great Lakes; 3 = South Atlantic
# 4 = North Pacific; 5 = South Pacific; 6 = Samoa;       7 = Europe
# 8 = USA;           9 = Brazil;        10 = Azores;     11 = China
# 12 = Sahara;       13 = Dom-C;        14 = Greenland
#
# author: Denis Botambekov
#

args=("$@")
clavrx_l2b_run_file=${args[0]}
dir_level2=${args[1]}
dir_level2b=${args[2]}
scid=${args[3]}
lon_west=${args[4]}
lon_east=${args[5]}
lat_south=${args[6]}
lat_north=${args[7]}
jday=${args[8]}
year=${args[9]}


# --- set some variables
dlat=0.1
dlon=0.1
[ ! -d $dir_level2b ] && mkdir -v -p $dir_level2b


if [ $scid == 1 ] ;then
   satname='metop-01'
   satname2='NSS.GHRR.M1'
fi
if [ $scid == 2 ] ;then
   satname='metop-02'
   satname2='NSS.GHRR.M2'
fi
if [ $scid == 5 ] ;then
   satname='noaa-05'
   satname2='NSS.GHRR.TN'
fi
if [ $scid == 6 ] ;then
   satname='noaa-06'
   satname2='NSS.GHRR.NA'
fi
if [ $scid == 7 ] ;then
   satname='noaa-07'
   satname2='NSS.GHRR.NC'
fi
if [ $scid == 8 ] ;then
   satname='noaa-08'
   satname2='NSS.GHRR.NE'
fi
if [ $scid == 9 ] ;then
   satname='noaa-09'
   satname2='NSS.GHRR.NF'
fi
if [ $scid == 10 ] ;then
   satname='noaa-10'
   satname2='NSS.GHRR.NG'
fi
if [ $scid == 11 ] ;then
   satname='noaa-11'
   satname2='NSS.GHRR.NH'
fi
if [ $scid == 12 ] ;then
   satname='noaa-12'
   satname2='NSS.GHRR.ND'
fi
if [ $scid == 13 ] ;then
   satname='noaa-13'
   satname2='NSS.GHRR.NI'
fi
if [ $scid == 14 ] ;then
   satname='noaa-14'
   satname2='NSS.GHRR.NJ'
fi
if [ $scid == 15 ] ;then
   satname='noaa-15'
   satname2='NSS.GHRR.NK'
fi
if [ $scid == 16 ] ;then
   satname='noaa-16'
   satname2='NSS.GHRR.NL'
fi
if [ $scid == 17 ] ;then
   satname='noaa-17'
   satname2='NSS.GHRR.NM'
fi
if [ $scid == 18 ] ;then
   satname='noaa-18'
   satname2='NSS.GHRR.NN'
fi
if [ $scid == 19 ] ;then
   satname='noaa-19'
   satname2='NSS.GHRR.NP'
fi
if [ $scid == 20 ] ;then
   satname='terra-modis'
   satname2='MOD021KM'
fi
if [ $scid == 21 ] ;then 
   satname='aqua-modis'
   satname2='MYD021KM'
fi
if [ $scid == 22 ] ;then 
   satname='terra-modis'
   satname2='MOD02SSH'
fi
if [ $scid == 23 ] ;then 
   satname='aqua-modis'
   satname2='MYD02SSH'
fi
if [ $scid == 30 ] ;then 
   satname='npp'
   satname2='npp'
fi
if [ $scid == 41 ] ;then
   satname='HIM8'
   satname2='HS_H08'
fi

# --- print some constants
echo 'satname   ' $satname
echo 'year      ' $year
echo 'jday      ' $jday
echo 'lon_west  ' $lon_west
echo 'lon_east  ' $lon_east
echo 'lat_south ' $lat_south
echo 'lat_north ' $lat_north

# --- compute julian day including zeroes
if  [ $jday -lt 100 ]; then 
  jday=0$jday
fi
if  [ $jday -lt 10 ]; then 
  jday=0$jday
fi

# --- level2 daily compositing (level2b)
echo $dir_level2 > comp_asc_des_level2b_input
echo $dir_level2b >> comp_asc_des_level2b_input
echo $year >> comp_asc_des_level2b_input
echo $jday >> comp_asc_des_level2b_input
echo '0 0' >> comp_asc_des_level2b_input
echo $satname >> comp_asc_des_level2b_input
echo $lon_west' '$lon_east' '$dlon >> comp_asc_des_level2b_input
echo $lat_south' '$lat_north' '$dlat >> comp_asc_des_level2b_input

ls $dir_level2 | grep 'clavrx_'$satname2 >> comp_asc_des_level2b_input

# --- loop over nodes
for cnt in {0..1}; do
   if [ $cnt == 0 ]; then
      node='asc'
   else
      node='des'
   fi
   echo 'Calling comp_asc_des_level2b for '$satname'  '$jday'  '$year'   '$node
   ./$clavrx_l2b_run_file $node
done


