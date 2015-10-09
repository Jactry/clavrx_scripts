#!/bin/sh
# $Id$


# makes hourly jobs stored in temporary shell scripts 

function usage() {

cat<< EOF

CG_RUN_VIIRS_ZARA

This tools downloads MODIS data
Usage:
> cg_run_viirs_zara.sh <yyyy> <doy0> <doy1> <region>

ask denis.botambekov@ssec.wisc.edu or andi.walther@ssec.wisc.edu 



Grid choises:

 0 = global;        1 = 45S - 45N;     2 = Great Lakes; 3 = South Atlantic
 4 = North Pacific; 5 = South Pacific; 6 = Samoa;       7 = Europe
 8 = USA;           9 = Brazil;        10 = Azores;     11 = China
 12 = Sahara;       13 = Dom-C;        14 = Greenland   15 = Alaska

EOF

}

#source /etc/bashrc
#module load bundle/basic-1
#module load bundle/basic-1 hdf5


while :; do 
   case $1 in
   
   --reg)
      if [ "$2" ]; then
         REG=$2
         shift 2
         continue
      fi
      ;;
   --path)
      if [ "$2" ]; then
         BASE_PATH=$2
         shift 2
         continue
      fi
   ;;   
      *)
      break
   esac
done

if [ ! $REG ]; then
	REG='global'
fi

year=$1
doy_start=$2
doy_end=$3
reg_idx=$4

hour0=0
hour1=0

# definitions 
satname='VIIRS'
data_root_path='/fjord/jgs/patmosx/'
work_dir='/fjord/jgs/personal/dbotambekov/patmosx_processing/scripts/'
#work_dir='/fjord/jgs/personal/awalther/patmosx_processing/scripts/'
mkdir -p $work_dir

#script_path='/home/awalther/ALGO/clavrx_trunk/clavrx_scripts/'
script_path='/home/dbotambekov/clavrx_scripts/'

#logs_path='/fjord/jgs/personal/awalther/logs/'
logs_path='/fjord/jgs/personal/dbotambekov/patmosx_processing/logs/'
mkdir -p $logs_path

#clavrx_path='/home/awalther/ALGO/clavrx_trunk/'
clavrx_path='/home/dbotambekov/src_clavrx_code/src_trunk/'
options='clavrxorb_default_options_viirs_zara'
#options='clavrxorb_default_options'
filelist=$clavrx_path'clavrxorb_file_list'

filetype='GMTCO'

region=$REG

echo "+++++++++++VIIRS PROCESSING ++++++++++++"


# --- Loop days
for (( dd = $doy_start; dd <= doy_end; dd ++ ))
do

   doy_str=$(printf "%03d" ${dd} )
   month=$(date -d "01/01/${year} +${doy_str} days -1 day" "+%m")
   day=$(date -d "01/01/${year} +${doy_str} days -1 day" "+%d")

   echo 'Processing DOY: ' $doy_str,$month$day
   
   # loop hours
    for (( hhh = $hour0; hhh <= $hour1; hhh ++ ))
	do
   		hhh_str=$(printf "%.2d" ${hhh} )
   		
		l1b_path=$data_root_path'/Satellite_Input/'$satname'/'$region'/'$year'/'$doy_str'/'
  		out_path=$data_root_path'/Satellite_Output/'$satname'/'$region'/'$year'/'$doy_str'/'
		
		# !!!!!!!!! CREATE A NEW TEMP SCRIPT TO SUBMIT IT TO ZARA
   		tmp_script=$work_dir'npp_'$year'_'$doy_str'_'$hhh_str'_reg_'$reg_idx'_patmosx.sh'
   		tmp_work_dir=$work_dir'npp_'$year'_'$doy_str'_'$hhh_str'_reg_'$reg_idx
		
   		echo "#!/bin/sh" > $tmp_script
   		echo "source /etc/bashrc" >> $tmp_script
   		echo "module load bundle/basic-1" >> $tmp_script
   		echo "module load bundle/basic-1 hdf5" >> $tmp_script

   		echo "echo 'Processing viirs $year $doy_str $hhh_str1 $region'" >> $tmp_script

   		echo "echo 'Creating necessary dirs and copying files'" >> $tmp_script
		
   		echo "mkdir -v -p $tmp_work_dir" >> $tmp_script
   		echo "mkdir -v -p $tmp_work_dir/temporary_files" >> $tmp_script
		
		echo "cp -r $script_path/*.sh $tmp_work_dir" >> $tmp_script
		
		
 
   		echo "cp $clavrx_path/clavrx_bin/clavrxorb $tmp_work_dir" >> $tmp_script
   		echo "cp $clavrx_path/clavrx_bin/comp_asc_des_level2b $tmp_work_dir" >> $tmp_script
   		#echo "cp $clavrx_path/$options $tmp_work_dir" >> $tmp_script
   		echo "cp /home/dbotambekov/src_clavrx_code/$options $tmp_work_dir" >> $tmp_script
		
   		echo "mkdir -v -p $l1b_path" >> $tmp_script
   		echo "mkdir -v -p $out_path" >> $tmp_script

   		echo "echo 'Linking Ancil Data'" >> $tmp_script
   		
		echo "[ ! -d $tmp_work_dir/clavrx_ancil_data ] && ln -s /fjord/jgs/patmosx/Ancil_Data/clavrx_ancil_data $tmp_work_dir" >> $tmp_script
   		
   		

   		echo "echo 'Getting l1b data'" >> $tmp_script
   		echo "cd $tmp_work_dir" >> $tmp_script
   		echo "./cg_get_data_sips.sh $year $doy_str $hhh_str $l1b_path $satname $reg_idx " >> $tmp_script
   		#echo "./cg_get_viirs_data.sh --path $l1b_path --reg $region $year$doy_str $hhh " >> $tmp_script
   		echo "echo 'Making sure all files are there, running sync_viirs_zara.sh'" >> $tmp_script
			filetype2='.hdf'
   		echo "sync_l1b_files_zara.sh $l1b_path $hhh_str $filetype2" >> $tmp_script

   		#echo "echo 'Writing files to the filelist'" >> $tmp_script
   		echo "./write_filelist.sh $l1b_path $out_path $filetype d$year$month$day t$hhh_str" >> $tmp_script
   		echo "echo 'Checking files, if already processed delete them from the filelist'" >> $tmp_script
   		#echo "./check_filelist_zara.sh $filelist $filetype" >> $tmp_script
   		echo "echo 'Starting CLAVR-x'" >> $tmp_script
   		echo "./clavrxorb  -default $options -lines_per_seg 400 -dcomp_mode 3 " >> $tmp_script
   		echo "echo 'Finished, Deleting All Temp Data'" >> $tmp_script
		
		 #$tmp_script
		
		 qsub -q r720.q -l vf=4G -S /bin/bash -l matlab=0 -l friendly=1 -p -00 -o $logs_path -e $logs_path -l h_rt=01:00:00 $tmp_script
   done
done



