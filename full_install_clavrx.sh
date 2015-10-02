#!/bin/bash
# $Header$
#  HISTORY
#
#    developed 2014
#     tested 10/02/2015 AW

set -e

 svn checkout -q https://svn.ssec.wisc.edu/repos/clavrx_scripts/trunk scripts_trunk
 cp scripts_trunk/install_clavrx_trunk.sh ./
 rm -rf scripts_trunk
 ./install_clavrx_trunk.sh
 
 mkdir -p data
 l1b_path='data/l1b_data'
 
 if [ ! -d data/Ancil_Data ]; then
   echo "no local Ancil Data, will be downloaded"
 fi
 

 if [ ! -d data/l1b_path ]; then
   mkdir -p data/l1b_path
   cd data/l1b_path
   wget ftp.ssec.wisc.edu:/pub/awalther/CLAVRX_TEST_DATA/exampl.tgz
   tar xfvz exampl.tgz
   cd ../..
 fi
 
 nwp_path='data/nwp'
 pwd
 if [ ! -d data/nwp ]; then
   mkdir -p data/nwp
   
   cd data/nwp
   
   wget ftp.ssec.wisc.edu:/pub/awalther/CLAVRX_TEST_DATA/gfs_2014_0101.tgz
   tar xfvz gfs_2014_0101.tgz
   cd ../..
 fi
 
 echo 'NWP downloaded '
 ancil_path='data/Ancil_Data' 
  
 if [ ! -d "$ancil_path" ]; then 
  mkdir -p data/Ancil_Data
  cd data/Ancil_Data
  wget ftp.ssec.wisc.edu:/pub/awalther/CLAVRX_TEST_DATA/viirs_aux_data.tgz
  tar xfvz viirs_aux_data.tgz
  cd ../..
 fi
 cd clavrx_trunk
 rm -f  clavrxorb_default_options
 rm -f file_madison_winter
 wget ftp.ssec.wisc.edu:/pub/ssec/awalther/CLAVRX_TEST_DATA/clavrxorb_default_options
 wget ftp.ssec.wisc.edu:/pub/ssec/awalther/CLAVRX_TEST_DATA/file_madison_winter
 rm -f clavrxorb
 ln -s clavrx_bin/clavrxorb ./
 
 mkdir -p temporary_files
 clavrxorb -filelist file_madison_winter 
 
 
 
 
