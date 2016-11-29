#!/bin/bash
# A.Walther 7 Nov 2013
# $Header$
#
#   history 20 January 2014: changed to patmosx branch of clavrx (AW)
#            24 March 2014: for CLAVR-x stable version 

#source ~/.bashrc
#export DISPLAY=:1

set -e

# for convinience: symbol link to local directory
# I encourage everybody to do this on all machines
# ln -s <hdf4_path> ~/lib/hdf4
# ln -s <hdf5_path> ~/lib/hdf5
hdf5_path=$HOME"/lib/hdf5_gcc/"
hdf4_path=$HOME"/lib/hdf4_gcc/"
netcdf_path=$HOME"/lib/netcdf3_gcc/"


stable_version='clavrx_stable'

path=$stable_version
if [ -n "$1" ]
then
path=$1

fi

echo
echo -e "\033[1mClavrx stable version will be installed in ===> $path \033[0m"
echo


if [ -d "$path" ]; then
   echo -e "\033[1mThis path already exists!!\033[0m"
    read -p "Do you wish to continue and update this path ?? (This may overwrite your local copy ) " yn
   case $yn in
    [Yy]* ) echo -e "\033[1mClavrx trunk branch will be installed in ===> $path \033[0m";;
    [Nn]* ) exit;;
    * ) echo "Please answer Yes or No. ";; 
  esac

fi
echo
echo '...........     svn checkout clavrx stable version 5.4 .................'
echo

mkdir -p  $path
cd $path

svn checkout -q https://svn.ssec.wisc.edu/repos/cloud_team_clavrx/tags/stable_release_2016b.1 ./


cd dncomp
./configure -hdf5root=$hdf5_path -with-gfortran -hdf4root=${hdf4_path}

cd ../main_src
cp level2_all_on.inc level2.inc
./configure -hdf5root=$hdf5_path -with-gfortran -hdf4root=${hdf4_path} -netcdflib=${netcdf_path} -dncomp_dir=../dncomp/ -acha_dir=../cloud_acha/



if make; then 
  printf '\033[32m Clavrx stable successfully installed %s\033[m\n'
else
   ret=$?
   printf '\033[31m Error !!!! clavrx stable is not installed  error code $ret %s\033[m\n'
fi

#cp clavrxorb_default_options ../
#cd ../
#ln -s clavrx_bin/* ./
#./clavrxorb

exit


