#!/bin/bash

### takes a folderfile to determine where to go to
### takes a cp2k template input file
### calculates the cell dimensions using getcell.py
### runs all of them in different folders

workdir=$(pwd)
sbatchfile="batch-hsw.slrm"

for mydir in $(cat folderfile)
do
  cp -r cnstr_templates/* ${mydir}

  cd $mydir
  echo $mydir

  # insert cellsize
  python3 getcell.py *.xyz > cellsize
  cellsize=$(cat cellsize)
  sed -i "s/mycellsizemy/${cellsize}/g" *inp

  # get clustersize, freeze cluster
  clustersize=$(head -n 1 *xyz)
  clustersize=$(($clustersize -1))
  echo $clustersize
  sed -i "s/myclustersizemy/${clustersize}/g" *inp

  # run CP2K
  echo "running CP2K"
  sbatch $sbatchfile

  cd $workdir
done


