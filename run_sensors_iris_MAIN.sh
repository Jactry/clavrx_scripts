#!/bin/sh
# $Id: 
#
# Author: Denis B.
# January, 2015
#
# Modifications:
#   - Changed to run on iris instead zara (Denis B. - July, 2015)
#
# ---------------------------------------------------------------------------------------------------
# --- !!! USER INPUT !!!

# --- Set year, date, etc.
# !!!!! ATTENTION: CODE SKIPS DAYS AND YEARS THAT ARE OUT OF A SATELLITE LIFE !!!!!
year_start=2013
year_end=2014 #$year_start
doy_start=1 #151
doy_end=366 #$doy_start #366
hour0=0  #0
hour1=23  #$hour0 #23
day_night=''   # set for downloading 1b data: 'D' = day; 'N' = night; '' = day+night

# --- Set satellite id (life time is in the parenthesis - year,doy)
# !!!!! ATTENTION: THESE ID NUMBERS CREATED BY DENIS B. IF CHANGED CHECK level2b_script.sh FILE !!!!!
#  1 = METOP-01 (2012,268-now);      2 = METOP-02 (2007,180-now);      5 = NOAA-05 (1978,309-1980,030);  6 = NOAA-06 (1979,181-1981,244); 
#  7 = NOAA-07 (1981,236-1985,032);  8 = NOAA-08 (1983,136-1985,287);  9 = NOAA-09 (1985,056-1988,312); 10 = NOAA-10 (1986,321-1991,259);
# 11 = NOAA-11 (1988,313-1994,289); 12 = NOAA-12 (1991,259-1998,348); 13 = NOAA-13 (-----------------); 14 = NOAA-14 (1995,020-2002,280); 
# 15 = NOAA-15 (1998,299-now);      16 = NOAA-16 (2001,001-2011,365); 17 = NOAA-17 (2002,176-2011,365); 18 = NOAA-18 (2005,200-now); 
# 19 = NOAA-19 (2009,037-now);     
# 20 = MOD021KM(2000,055-now);  21 = MYD021KM (2002,185-now);  22 = MOD02SSH;  23 = MYD02SSH;  30 = VIIRS (2011,325-now)
# 41 = HIMAWARI-08 (2015,?-now)
sat_id=19

# --- Set region limits
# 0 = global;        1 = 45S - 45N;     2 = Great Lakes; 3 = South Atlantic
# 4 = North Pacific; 5 = South Pacific; 6 = Samoa;       7 = Europe
# 8 = USA;           9 = Brazil;        10 = Azores;     11 = China
# 12 = Sahara;       13 = Dom-C;        14 = Greenland;  15 = Alaska 
# 16 = Tropics
grid=16

# --- Set flag to get and delete data
# !!!!! ATTENTION: FOR AVHRR SET flag_get_1b_data AND flag_delete_l1b TO 0 !!!!!
flag_get_1b_data=0   # set to 1 if need to download data from peate
flag_reprocess_l2_files=1   # if set to 0 it would skip already existing level2 files
flag_make_l2=1   # if set to 1 it creats level2 files
flag_delete_l1b=0   # if set to 1 it deletes level1b data
flag_make_l2b=1   # if set to 1 it creats level2b files
flag_delete_l2=1   # if set to 1 it deletes level2 data

# --- Set pathes and files to be used
# !!!!! ATTENTION: AVHRR DON'T NEED l1b_path_base, HARD-CODED TO THE FJORD LOCATION !!!!!
l1b_path_base='/fjord/jgs/personal/dbotambekov/Satellite_Input/'
out_path_base='/fjord/jgs/personal/dbotambekov/Satellite_Output/'
work_dir='/fjord/jgs/personal/dbotambekov/patmosx_processing/scripts/'
iris_files_path='/home/dbotambekov/src_clavrx_code/iris_run/'
logs_path='/fjord/jgs/personal/dbotambekov/patmosx_processing/logs/'
filelist='file_list'
clavrx_run_file='clavrxorb_trunk'  # clavrxorb_trunk
clavrx_l2b_run_file='comp_asc_des_level2b'
qsub_node='cirrus'   # could be 'all' or 'cirrus' 

# --- Set how many jobs to run
user_name='dbot'  # use not less than 4 and not more than 7 characters 
job_max=60
sleep_time=3


# --- !!! END USER INPUT !!!
# ---------------------------------------------------------------------------------------------------


echo "+++++++++++ PROCESSING DATA ++++++++++++"

# --- Set region limits
#--- global
if [ $grid == 0 ] ; then
 lon_west=-180.0
 lon_east=180.0
 lat_south=-90.0
 lat_north=90.0
 region="global"
fi
#--- 45S - 45N (Tropics)
if [ $grid == 1 ] ; then
 lon_west=-180
 lon_east=180
 lat_south=-45.0
 lat_north=45.0
 region="tropics"
fi
#--- great_lakes
if [ $grid == 2 ] ; then
 lon_west=-95.05
 lon_east=-74.95
 lat_south=35.05
 lat_north=54.95
 region="great_lakes"
fi
#--- south atlantic
if [ $grid == 3 ] ; then
 lon_west=-9.95
 lon_east=9.95
 lat_south=-29.95
 lat_north=-10.05
 region="south_atlantic"
fi
#--- north pacific
if [ $grid == 4 ] ; then
 lon_west=-139.95
 lon_east=-120.05
 lat_south=15.05
 lat_north=34.95
 region="north_pacific"
fi
#--- south pacific
if [ $grid == 5 ] ; then
 lon_west=-104.95
 lon_east=-75.05
 lat_south=-24.95
 lat_north=-4.95
 region="south_pacific"
fi
#--- samoa
if [ $grid == 6 ] ; then
 lon_west=-179.05
 lon_east=-160.05
 lat_south=-24.95
 lat_north=-4.95
 region="samoa"
fi
#--- europe
if [ $grid == 7 ] ; then
 lon_west=0.05
 lon_east=29.95
 lat_south=40.05
 lat_north=59.95
 region="europe"
fi
#--- usa
if [ $grid == 8 ] ; then
 lon_west=-124.95
 lon_east=-65.05
 lat_south=25.05
 lat_north=54.95
 region="usa"
fi
#--- brazil
if [ $grid == 9 ] ; then
 lon_west=-79.95
 lon_east=-35.05
 lat_south=-29.95
 lat_north=-0.05
 region="brazil"
fi
#--- azores
if [ $grid == 10 ] ; then
 lon_west=-30.0
 lon_east=-10.0
 lat_south=25.0
 lat_north=45.0
 region="azores"
fi
#--- china
if [ $grid == 11 ] ; then
 lon_west=85.0
 lon_east=145.0
 lat_south=10.0
 lat_north=50.0
 region="china"
fi
#--- sahara
if [ $grid == 12 ] ; then
 lon_west=-15.0
 lon_east=55.0
 lat_south=15.0
 lat_north=35.0
 region="sahara"
fi
#--- dom-c
if [ $grid == 13 ] ; then
 lon_west=115.0
 lon_east=130.0
 lat_south=-80.0
 lat_north=-70.0
 region="dom_c"
fi
#--- greenland
if [ $grid == 14 ] ; then
 lon_west=-45.05
 lon_east=-34.95
 lat_south=67.95
 lat_north=75.05
 region="greenland"
fi
#--- alaska
if [ $grid == 15 ] ; then
 lon_west=-162.05
 lon_east=-141.95
 lat_south=51.95
 lat_north=72.05
 region="alaska"
fi
#--- tropics
if [ $grid == 16 ] ; then
 lon_west=-100.05
 lon_east=-79.95
 lat_south=-0.05
 lat_north=20.05
 region="tropics"
fi

# --- set some variables depending on sensor
if [ $sat_id == 1 ] ; then
   satname='m01'
   filetype='M1'
   filetype2='M1'
   year_start_sat=2012
   year_end_sat=2015
   doy_start_sat=268
   doy_end_sat=365
fi
if [ $sat_id == 2 ] ; then
   satname='m02'
   filetype='M2'
   filetype2='M2'
   year_start_sat=2007
   year_end_sat=2015
   doy_start_sat=180
   doy_end_sat=365
fi
if [ $sat_id == 5 ] ; then
   satname='n05'
   filetype='TN'
   filetype2='TN'
   year_start_sat=1978
   year_end_sat=1980
   doy_start_sat=309
   doy_end_sat=30
fi
if [ $sat_id == 6 ] ; then
   satname='n06'
   filetype='NA'
   filetype2='NA'
   year_start_sat=1979
   year_end_sat=1981
   doy_start_sat=181
   doy_end_sat=244
fi
if [ $sat_id == 7 ] ; then
   satname='n07'
   filetype='NC'
   filetype2='NC'
   year_start_sat=1981
   year_end_sat=1985
   doy_start_sat=236
   doy_end_sat=32
fi
if [ $sat_id == 8 ] ; then
   satname='n08'
   filetype='NE'
   filetype2='NE'
   year_start_sat=1983
   year_end_sat=1985
   doy_start_sat=136
   doy_end_sat=287
fi
if [ $sat_id == 9 ] ; then
   satname='n09'
   filetype='NF'
   filetype2='NF'
   year_start_sat=1985
   year_end_sat=1988
   doy_start_sat=56
   doy_end_sat=312
fi
if [ $sat_id == 10 ] ; then
   satname='n10'
   filetype='NG'
   filetype2='NG'
   year_start_sat=1986
   year_end_sat=1991
   doy_start_sat=321
   doy_end_sat=259
fi
if [ $sat_id == 11 ] ; then
   satname='n11'
   filetype='NH'
   filetype2='NH'
   year_start_sat=1988
   year_end_sat=1994
   doy_start_sat=313
   doy_end_sat=289
fi
if [ $sat_id == 12 ] ; then
   satname='n12'
   filetype='ND'
   filetype2='ND'
   year_start_sat=1991
   year_end_sat=1998
   doy_start_sat=259
   doy_end_sat=348
fi
if [ $sat_id == 13 ] ; then  # no sat, turned off
   satname='n13'
   filetype='NI'
   filetype2='NI'
   year_start_sat=100
   year_end_sat=10
   doy_start_sat=100
   doy_end_sat=10
fi
if [ $sat_id == 14 ] ; then
   satname='n14'
   filetype='NJ'
   filetype2='NJ'
   year_start_sat=1995
   year_end_sat=2002
   doy_start_sat=20
   doy_end_sat=280
fi
if [ $sat_id == 15 ] ; then
   satname='n15'
   filetype='NK'
   filetype2='NK'
   year_start_sat=1998
   year_end_sat=2015
   doy_start_sat=299
   doy_end_sat=365
fi
if [ $sat_id == 16 ] ; then
   satname='n16'
   filetype='NL'
   filetype2='NL'
   year_start_sat=2001
   year_end_sat=2011
   doy_start_sat=1
   doy_end_sat=365
fi
if [ $sat_id == 17 ] ; then
   satname='n17'
   filetype='NM'
   filetype2='NM'
   year_start_sat=2002
   year_end_sat=2011
   doy_start_sat=176
   doy_end_sat=365
fi
if [ $sat_id == 18 ] ; then
   satname='n18'
   filetype='NN'
   filetype2='NN'
   year_start_sat=2005
   year_end_sat=2015
   doy_start_sat=200
   doy_end_sat=365
fi
if [ $sat_id == 19 ] ; then
   satname='n19'
   filetype='NP'
   filetype2='NP'
   year_start_sat=2009
   year_end_sat=2015
   doy_start_sat=37
   doy_end_sat=365
fi
if [ $sat_id == 20 ] ; then
   satname='MOD021KM'
   filetype='MOD021KM'
   filetype2='hdf'
   year_start_sat=2000
   year_end_sat=2015
   doy_start_sat=55
   doy_end_sat=365
fi
if [ $sat_id == 21 ] ; then
   satname='MYD021KM'
   filetype='MYD021KM'
   filetype2='hdf'
   year_start_sat=2002
   year_end_sat=2015
   doy_start_sat=185
   doy_end_sat=365
fi
if [ $sat_id == 22 ] ; then
   satname='MOD02SSH'
   filetype='MOD02SSH'
   filetype2='hdf'
   year_start_sat=2000
   year_end_sat=2015
   doy_start_sat=55
   doy_end_sat=365
fi
if [ $sat_id == 23 ] ; then
   satname='MYD02SSH'
   filetype='MYD02SSH'
   filetype2='hdf'
   year_start_sat=2002
   year_end_sat=2015
   doy_start_sat=185
   doy_end_sat=365
fi
if [ $sat_id == 30 ] ; then
   satname='VIIRS'
   filetype='GMTCO'
   filetype2='h5'
   year_start_sat=2011
   year_end_sat=2015
   doy_start_sat=325
   doy_end_sat=365
fi
if [ $sat_id == 41 ] ; then
   satname='HIM08'
   filetype='HS_H08'
   filetype2='.nc'
   year_start_sat=2015
   year_end_sat=2015
   doy_start_sat=040
   doy_end_sat=365
fi

# --- remember current dir
curr_dir=`pwd`

# --- loop over the years
for (( year = $year_start; year <= $year_end; year ++ ))
do
   echo Thinking about Processing $satname, Year $year
   # - check if year is out of satellite's life period, skip those years
   if [ $year -lt $year_start_sat ] && [ $year -gt $year_end_sat ] ; then
      echo Skipping $year Year, $satname Life Time is from $year_start_sat to $year_end_sat
      continue
   fi

   # --- find out if this is a leap year (0=leap, other=not leap)
   leap_chk=`echo "$year%4" | bc`

   # --- make a short 2 digit year
   if [ $year -gt 1999 ] ; then
      year_short=$[year-2000]
   else
      year_short=$[year-1900]
   fi
   if [ $year_short -lt 10 ] ; then
      year_short_str=`expr 0$year_short`
   else
      year_short_str=$year_short
   fi

   # --- Loop days
   for (( doy = $doy_start; doy <= $doy_end; doy ++ ))
   do
      echo Thinking about Processing $satname, Year $year, Day $doy
      # --- check if doy is out of satellite's life period, skip those doy
      if [ $year -eq $year_start_sat ] && [ $doy -lt $doy_start_sat ]  ; then
         echo Skipping $year Year, $doy Day, It is Out of $satname Life Time
         continue
      fi
      if [ $year -eq $year_end_sat ]   && [ $doy -gt $doy_end_sat ]  ; then
         echo Skipping $year Year, $doy Day, It is Out of $satname Life Time
         continue
      fi

     # --- check if doy=366, but it's not a leap year
     if [ $doy -eq 366 ] && [ $leap_chk -ne 0 ] ; then
        echo $year is Not a Leap Year, Skipping
        continue
     fi

     # --- check if doy is less than 10 or 100
     if [ $doy -lt 10 ] ; then
       doy_str=`expr 00$doy`
     elif [ $doy -ge 10 ] && [ $doy -lt 100 ] ; then
       doy_str=`expr 0$doy`
     else
       doy_str=$doy
     fi

     # --- calculate month, day, number of hours per this day
     month=$(date -d "01/01/${year} +${doy} days -1 day" "+%m")
     day=$(date -d "01/01/${year} +${doy} days -1 day" "+%d")
     hour_tot=$[hour1-hour0+1]
     #$ -t 1-$hour_tot


     # --- Loop through the hours
     for (( hhh = $hour0; hhh <= $hour1; hhh ++ ))
     do
        hhh_str=$hhh
        hhh_str1=$hhh
        if [ $hhh -lt 10 ] ; then
           hhh_str=`expr 0$hhh`
           hhh_str1=`expr 0$hhh`
        fi

        # --- some more constants
        if   [ $sat_id -ge 1 ] && [ $sat_id -le 19 ] ; then
           n_lines_per_seg=1000
           options='clavrxorb_default_options_avhrr_iris'
           file_srch="NSS.GHRR.${filetype}.D${year_short_str}${doy_str}.S${hhh_str1}"
        fi
        if   [ $sat_id -ge 20 ] && [ $sat_id -le 23 ] ; then
           n_lines_per_seg=500
           options='clavrxorb_default_options_modis_iris'
           file_srch="${filetype}.A${year}${doy_str}.${hhh_str1}"
        fi
        if [ $sat_id == 30 ] ; then
           n_lines_per_seg=400
           options='clavrxorb_default_options_viirs_iris'
           file_srch="${filetype}_npp_d${year}${month}${day}_t${hhh_str1}"
        fi
        if [ $sat_id == 41 ] ; then
           n_lines_per_seg=200
           options='clavrxorb_default_options_ahi_iris'
           file_srch="${filetype}_${year}${month}${day}_${hhh_str1}.*B01"
        fi

        # --- set pathes
        if   [ $sat_id -ge 1 ] && [ $sat_id -le 19 ] ; then
           l1b_path="/fjord/jgs/patmosx/Satellite_Input/avhrr/${region}/${satname}_${year}/"
           out_path="${out_path_base}/AVHRR/${region}/${year}/${doy_str}/"
        else
           #l1b_path="${l1b_path_base}/${satname}/${region}/${year}/${doy_str}/"
           l1b_path="${l1b_path_base}/${satname}/${region}/${year}/${doy_str}/level1b/"
           out_path="${out_path_base}/${satname}/${region}/${year}/${doy_str}/"
        fi
        if   [ $sat_id -eq 41 ] ; then
           l1b_path="/fjord/jgs/patmosx/Satellite_Input/${satname}/${year}_${doy_str}/"
           out_path="${out_path_base}/${satname}/${region}/${year}/${doy_str}/"
        fi

        #l2_path=$out_path'/rtm/'
        l2_path=$out_path'/level2/'
        #l2_path=$out_path'/level2_dcomp2/'
        #l2_path=$out_path

        # !!!!!!!!! BECAUSE IRIS CAN'T HANDLE MANY CALLS CHECK IF DATA EXISTS
        # !!!!!!!!! IF NO DATA THEN SKIP THIS HOUR
        if [ $flag_get_1b_data -eq 0 ] ; then   # L1b data already saved
           num_files=`ls -l ${l1b_path}${file_srch}* | wc -l`
           #echo num_files= $num_files
           if [ $num_files -eq 0 ] ; then
              echo No Level 1b Files, Go To The Next Hour!!!
              continue
           fi
        fi
        if [ $flag_get_1b_data -ne 0 ] ; then   # L1b data need to be downloaded from sips
           cd $curr_dir
           source ./cg_get_data_sips.sh $year $doy_str $hhh_str './' $satname $grid 1 $day_night
           num_files=$?
           #echo num_files= $num_files
           if [ $num_files -eq 0 ] ; then
              echo No Level 1b Files, Go To The Next Hour!!!
              continue
           fi
        fi

        # !!!!!!!!! CREATE A NEW TEMP SCRIPT TO SUBMIT IT TO ZARA
        tmp_script=$work_dir$satname'_'$year'_'$doy_str'_'$hhh_str1'_'$region'_patmosx.sh'
        tmp_work_dir=$work_dir$satname'_'$year'_'$doy_str'_'$hhh_str1'_'$region
        if [ $flag_get_1b_data -ne 0 ] || [ $flag_make_l2 -ne 0 ] ; then
           # --- Write settings for SBATCH
           echo "#!/bin/sh" > $tmp_script
           echo "#SBATCH --job-name=$tmp_script" >> $tmp_script
	   echo "#SBATCH --partition=$qsub_node" >> $tmp_script
           echo "#SBATCH --share" >> $tmp_script
           echo "#SBATCH --time=10:00:00" >> $tmp_script
           echo "#SBATCH --ntasks=1" >> $tmp_script
           echo "#SBATCH --cpus-per-task=1" >> $tmp_script
           echo "#SBATCH --output=$logs_path$satname'_'$year'_'$doy_str'_'$hhh_str1'_'$region'_patmosx.log'" >> $tmp_script
           echo "#SBATCH --mem-per-cpu=10000" >> $tmp_script
           # --- Load modules
           #echo "module purge" >> $tmp_script
           #echo "module load license_intel/S4 intel/14.0-2" >> $tmp_script
           #echo "module load hdf-nocdf/4.2.9" >> $tmp_script
           #echo "module load hdf5/1.8.12" >> $tmp_script
           #echo "module load netcdf3/3.6.3" >> $tmp_script
 
           echo "echo 'Processing $satname $year $doy_str $hhh_str1 $region'" >> $tmp_script

           echo "echo 'Creating necessary dirs and copying files'" >> $tmp_script
           echo "[ ! -d $tmp_work_dir ] && mkdir -v -p $tmp_work_dir" >> $tmp_script
           echo "[ ! -d $out_path ] && mkdir -v -p $out_path" >> $tmp_script
           if [ $flag_make_l2 -ne 0 ] ; then
              echo "[ ! -d $tmp_work_dir/temporary_files ] && mkdir -v -p $tmp_work_dir/temporary_files" >> $tmp_script
              if [ $flag_get_1b_data -ne 0 ] ; then
                 echo "cp $iris_files_path/cg_get_data_sips.sh $tmp_work_dir" >> $tmp_script
                 echo "cp $iris_files_path/sync_l1b_files_iris.sh $tmp_work_dir" >> $tmp_script
                 echo "[ ! -d $l1b_path ] && mkdir -v -p $l1b_path" >> $tmp_script
              fi
              echo "cp $iris_files_path/write_filelist_iris.sh $tmp_work_dir" >> $tmp_script
#              echo "cp $iris_files_path/get_cfsr_iris.sh $tmp_work_dir" >> $tmp_script
              if [ $flag_reprocess_l2_files -eq 0 ] ; then 
                 echo "cp $iris_files_path/check_filelist_iris.sh $tmp_work_dir" >> $tmp_script
              fi
              echo "cp $iris_files_path/$clavrx_run_file $tmp_work_dir" >> $tmp_script
              echo "cp $iris_files_path/$options $tmp_work_dir" >> $tmp_script
              echo "[ ! -d $l2_path ] && mkdir -v -p $l2_path" >> $tmp_script
           fi

           echo "cd $tmp_work_dir" >> $tmp_script
           if [ $flag_get_1b_data -ne 0 ] ; then
              echo "echo 'Getting l1b data'" >> $tmp_script
              echo "./cg_get_data_sips.sh $year $doy_str $hhh_str $l1b_path $satname $grid 0 $day_night" >> $tmp_script
              echo "echo 'Making sure all files are there, running sync_l1b_files_iris.sh'" >> $tmp_script
              echo "./sync_l1b_files_iris.sh $l1b_path $hhh_str $filetype2" >> $tmp_script
           fi
           if [ $flag_make_l2 -ne 0 ] ; then
              echo "echo 'Writing files to the filelist'" >> $tmp_script
              echo "./write_filelist_iris.sh $l1b_path $l2_path $file_srch" >> $tmp_script
#              echo "./get_cfsr_iris.sh $year $doy" >> $tmp_script
              if [ $flag_reprocess_l2_files -eq 0 ] ; then
                 echo "echo 'Checking files, if already processed delete them from the filelist'" >> $tmp_script
                 echo "./check_filelist_iris.sh $filelist $filetype" >> $tmp_script
              fi
              echo "echo 'Starting CLAVR-x'" >> $tmp_script
              echo "./$clavrx_run_file -default $options -lines_per_seg $n_lines_per_seg" >> $tmp_script
              echo "echo 'Finished processing CLAVR-x'" >> $tmp_script
           fi

           echo "echo 'Deleting All Temp Data'" >> $tmp_script
           echo "rm -rf $tmp_work_dir" >> $tmp_script
           if [ $flag_delete_l1b -ne 0 ] ; then
              echo "rm -rf $l1b_path" >> $tmp_script
           fi
           echo "rm $tmp_script" >> $tmp_script

           # --- Submit job to iris for downloading level 1b data and/or process level 2 and save IDs for the future
           jobID_tmp=`sbatch $tmp_script`
           echo $jobID_tmp
           #jobID[$hhh]=`echo $jobID_tmp | awk 'match($0, /[0-9]+/) { print substr( $0, RSTART, RLENGTH )}'`
           jobID[$hhh]=$(echo $jobID_tmp | tr -dc '[0-9]')
         fi

         # --- Check how many jobs and sleep if it's max
         n_jobs=`squeue | grep ${user_name} | wc -l`
         if [ $n_jobs -ne 0 ] ; then
            echo Processing $n_jobs jobs
         fi
         while [ $n_jobs -ge $job_max ] ; do
            echo Too many jobs, sleeping for $sleep_time seconds
            sleep $sleep_time
            n_jobs=`squeue | grep ${user_name} | wc -l`
         done
         
      done # hours loop

      # --- Make Level 2b Files
      # !!! To make level 2b we need to wait until all scripts for that date are done
      if [ $flag_make_l2b -ne 0 ] ; then

         # --- save level 2 jobs IDs and separate by commas
         jobID_com=$(printf ",%s" "${jobID[@]}")
         jobID_com=${jobID_com:1}

         # --- set names and pathes
         l2b_path=$out_path'/level2b/'
         #l2b_path=$out_path'/level2b_dcomp2/'
         tmp_script_l2b_2=$satname'_'$year'_'$doy_str'_'$region'_patmosx_l2b.sh'
         tmp_script_l2b=$work_dir$satname'_'$year'_'$doy_str'_'$region'_patmosx_l2b.sh'
         tmp_work_dir_l2b=$work_dir$satname'_'$year'_'$doy_str'_'$region'_l2b'
         job_srch=$satname'_'$year'_'$doy_str

         # --- write a script
         echo "#!/bin/sh" > $tmp_script_l2b
         echo "#SBATCH --job-name=$tmp_script_l2b" >> $tmp_script_l2b
         echo "#SBATCH --partition=$qsub_node" >> $tmp_script_l2b
         echo "#SBATCH --share" >> $tmp_script_l2b
         echo "#SBATCH --time=10:00:00" >> $tmp_script_l2b
         echo "#SBATCH --ntasks=1" >> $tmp_script_l2b
         echo "#SBATCH --cpus-per-task=1" >> $tmp_script_l2b
         echo "#SBATCH --output=$logs_path$tmp_script_l2b_2'.log'" >> $tmp_script_l2b
         echo "#SBATCH --mem-per-cpu=8000" >> $tmp_script_l2b
         echo "echo 'Processing L2b $satname $year $doy_str $region'" >> $tmp_script_l2b
         echo "echo 'Creating necessary dirs and copying files'" >> $tmp_script_l2b
         echo "[ ! -d $tmp_work_dir_l2b ] && mkdir -v -p $tmp_work_dir_l2b" >> $tmp_script_l2b
         echo "[ ! -d $l2b_path ] && mkdir -v -p $l2b_path" >> $tmp_script_l2b
         echo "cp $iris_files_path/$clavrx_l2b_run_file $tmp_work_dir_l2b" >> $tmp_script_l2b
         echo "cp $iris_files_path/level2b_script.sh $tmp_work_dir_l2b" >> $tmp_script_l2b
         echo "cd $tmp_work_dir_l2b" >> $tmp_script_l2b

         echo "echo 'Starting level2b_script.sh'" >> $tmp_script_l2b
         echo "sh level2b_script.sh $clavrx_l2b_run_file $l2_path $l2b_path $sat_id $lon_west $lon_east $lat_south $lat_north $doy $year" >> $tmp_script_l2b
   
         echo "echo 'Deleting All Temp Data'" >> $tmp_script_l2b
         echo "rm -rf $tmp_work_dir_l2b" >> $tmp_script_l2b
         if [ $flag_delete_l2 -ne 0 ] ; then
            echo "rm -rf $l2_path" >> $tmp_script_l2b
         fi 
         echo "rm $tmp_script_l2b" >> $tmp_script_l2b

         # --- Submit job to iris for processing level 2b
         cd $work_dir
         if [ $flag_make_l2 -ne 0 ] ; then
            #qsub -q $qsub_node -l vf=4G -S /bin/bash -l matlab=0 -l friendly=1 -p -200 -o $logs_path -e $logs_path -l h_rt=12:00:00 -hold_jid ${jobID_com[@]} $tmp_script_l2b_2
            sbatch --dependency=afterok:${jobID_com[@]} $tmp_script_l2b_2
         else
            #qsub -q $qsub_node -l vf=4G -S /bin/bash -l matlab=0 -l friendly=1 -p -200 -o $logs_path -e $logs_path -l h_rt=12:00:00 $tmp_script_l2b_2
            sbatch $tmp_script_l2b_2
         fi
            
      fi

   done # days loop
done # years loop


