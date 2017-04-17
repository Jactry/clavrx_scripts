#!/bin/bash
# A.Walther 2017 April 14
#
# $Id:$
#
#   PURPOSE: This is installer for new clavr-x software package
#
#

set -e


branch='dcomp_all_modes'
branch_version=clavrx_${branch}

path=$branch_version
if [ -n "$1" ]
then
path=$1

fi

echo
echo -e "\033[1mClavrx branch version will be installed in ===> $path \033[0m"
echo
read -p "Do you wish to continue and install the tag version clavrx ?? (You may want to install the trunk with ./install_clavrx_trunk.sh ?!) " yn
   case $yn in
      [Yy]* ) echo -e "\033[1mClavrx trunk branch will be installed in ===> $path \033[0m";;
      [Nn]* ) exit;;
      * ) echo "Please answer Yes or No. ";; 
  esac


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
echo '...........     svn checkout clavrx branch .................'
echo


mkdir -p  $path
cd $path
pwd

svn checkout -q https://svn.ssec.wisc.edu/repos/cloud_team_clavrx/branches/${branch} ./


cd main_src
if make ARCH=gfortran; then
   printf '\033[32m Clavrx stable successfully installed %s\033[m\n'
else 
   ret=$?
   printf '\033[31m Error !!!! clavrx stable is not installed  error code $ret %s\033[m\n'
fi		

cd ..
ln -s clavrx_bin/* ./


exit
