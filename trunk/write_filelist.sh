   #!/bin/sh
# $Id$

args=("$@") 
dir_1b_local=${args[0]} 
output_path_local=${args[1]} 




echo 'local level1b path: '$dir_1b_local

echo
mkdir -p $output_path_local

dir_1bx=$dir_1b_local
dir_level2=$output_path_local

echo $dir_1b_local > file_list
echo $dir_level2 >> file_list

case $# in
3)ls $dir_1b_local |  grep $3  >> file_list;;
4)ls $dir_1b_local |  grep $3 | grep $4  >> file_list;;
5)ls $dir_1b_local |  grep $3 | grep $4 | grep $5  >> file_list;;
6)ls $dir_1b_local |  grep $3 | grep $4 | grep $5  >> file_list;;
esac

echo
echo "files to be processed========>  ",$3,$4,$5
case $# in
3)ls $dir_1b_local |  grep $3 ;;
4)ls $dir_1b_local |  grep $3 | grep $4  ;;
5)ls $dir_1b_local |  grep $3 | grep $4 | grep $5 ;;
esac
echo
