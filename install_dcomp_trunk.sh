#!/bin/bash

set -e

hdf5_path=$HOME"/lib/hdf5/"
hdf4_path=$HOME"/lib/hdf4/"

path='dcomp_software'
if [ -n "$1" ]
then
path=$1
fi

echo
echo -e "\033[1mDCOMP TRUNK will be installed in ===> $path \033[0m"
echo
echo
echo "...........     SVN $path checkout/update programs ................."
echo
mkdir -p  $path
cd $path
svn checkout -q https://svn.ssec.wisc.edu/repos/cloud_team_clavrx/trunk/dcomp ./

./configure -hdf5root=$hdf5_path -with-ifort -hdflib=${hdf4_path}/lib

if make; then 
  printf '\033[32m Clavrx trunk successfully installed %s\033[m\n'
else
   ret=$?
   printf '\033[31m Error !!!! clavrx trunk is not installed  error code $ret %s\033[m\n'
fi
./dcomp_one_pixel_run
