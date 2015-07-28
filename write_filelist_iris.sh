#!/bin/sh
# $Id: write_filelist_iris.sh 83 2015-04-09 20:30:46Z awalther $

args=("$@") 
dir_1b_local=${args[0]} 
output_path_local=${args[1]} 

echo 'local level1b path: '$dir_1b_local
echo

dir_1bx=$dir_1b_local
dir_level2=$output_path_local
clavrxorb_file_list='file_list'

echo $dir_1b_local > $clavrxorb_file_list
echo $dir_level2 >> $clavrxorb_file_list

case $# in
3)ls $dir_1b_local |  grep $3  >> $clavrxorb_file_list;;
4)ls $dir_1b_local |  grep $3 | grep $4  >> $clavrxorb_file_list;;
5)ls $dir_1b_local |  grep $3 | grep $4 | grep $5  >> $clavrxorb_file_list;;
6)ls $dir_1b_local |  grep $3 | grep $4 | grep $5  >> $clavrxorb_file_list;;
esac

echo
echo "files to be processed========>  ",$3,$4,$5
case $# in
3)ls $dir_1b_local |  grep $3 ;;
4)ls $dir_1b_local |  grep $3 | grep $4  ;;
5)ls $dir_1b_local |  grep $3 | grep $4 | grep $5 ;;
esac
echo
