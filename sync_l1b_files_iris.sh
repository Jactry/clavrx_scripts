#!/bin/sh

start()
{
#  echo "Check files again"

sch_path=$l1b_path'*'$file_type'*'
num_real_files=`ls -1 $sch_path | wc -l`
echo "Real $num_real_files"

if [ "$num_real_files" -ne "$num_need_files" ]
then
   echo "Not enough files"
   cd $l1b_path
   bash $down_file
   stat=1
else
   stat=0
fi
return $stat
}


args=("$@") 
l1b_path=${args[0]}
hr_path=${args[1]}
file_type=${args[2]}


l1b_path=$l1b_path'/'$hr_path'/'
down_file=$l1b_path'downloader.sh'
curr_dir=`pwd`
#echo $l1b_path
#echo $down_file

tmp=`grep Results $down_file`
#echo HERE $tmp

if [ -f $down_file ] ; then
  num_need_files=`echo $tmp |awk -F " " '{print $3}'`
  echo "Need $num_need_files"
#  sed -e 's/-q/-q -nc/g' <$down_file >temp.txt
#  cp temp.txt $down_file
#  rm temp.txt
  stat=1
fi

while [ $stat -eq 1 ]
do
   start
done

mv $l1b_path*$file_type* $l1b_path/../.
rm -r $l1b_path
cd $curr_dir
echo "All files are there"

