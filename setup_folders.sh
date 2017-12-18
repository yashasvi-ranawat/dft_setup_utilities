#!/bin/bash

workdir=$(pwd)
# folder with all xyz files
xyzfolder="$1"
echo "reading xyz files from folder: $1"

# first, create folderfile

cd $xyzfolder
find . -name "*.xyz" > folderfile
sed -i 's/.xyz//g' folderfile
cp folderfile $workdir/.
cd $workdir


for mydir in $(cat $xyzfolder/folderfile)
do
  
  mkdir -p ${mydir}
  cp -r $xyzfolder/${mydir}.xyz ${mydir}/.

  echo $mydir

done


