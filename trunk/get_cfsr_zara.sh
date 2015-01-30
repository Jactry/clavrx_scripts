#!/bin/bash

args=("$@") 
year=${args[0]} 
doy=${args[1]}

#cfsr_path='/data/Ancil_Data/cfsr/'$year'/'
cfsr_path='/fjord/jgs/patmosx/Ancil_Data/clavrx_ancil_data_new/dynamic/cfsr/'$year'/'
 [ ! -d $cfsr_path ] && mkdir $cfsr_path
 
DAY_OBS=$(date -d "01/01/${year} +${doy} days -1 day" "+%y%m%d")

echo 'check and/or get csfr data from '$DAY_OBS

for hhh in 00 06 12 18
do
  filebase='cfsr.'$DAY_OBS$hhh'_F006.hdf'
  file=$cfsr_path$filebase
  
  if [ ! -f $file ]; 
  then
   
   sh -c 'scp -p -r loki:/data1/Ancil_Data/cfsr/hires/'$year'/cfsr.'$DAY_OBS$hhh'_F006.hdf  '$file
  fi
done


DAY_OBS=$(date -d "01/01/${year} +${doy} days -2 day" "+%y%m%d")

for hhh in 00 06 12 18
do
  file=$cfsr_path'cfsr.'$DAY_OBS$hhh'_F006.hdf'
  if [ ! -f $file ]; 
 then
   
   sh -c 'scp -p -r loki:/data1/Ancil_Data/cfsr/hires/'$year'/cfsr.'$DAY_OBS$hhh'_F006.hdf  '$file
  fi
done

