#!/bin/bash

### takes a folderfile to determine where to go to
### takes a cp2k template input file
### calculates the cell dimensions using getcell.py
### runs all of them in different folders

workdir=$(pwd)
sbatchfile="batch.slrm"

for mydir in $(cat folderfile)
do

  cd $mydir
  echo $mydir
  cp -rs ../cnstr_templates/*[^*.slrm] .

  # insert cellsize
  python3 getcell.py *.xyz > cellsize
  cellsize=$(cat cellsize)
  sed -i "s/mycellsizemy/${cellsize}/g" *inp

  # get clustersize, freeze cluster
  #clustersize=$(head -n 1 *xyz)
  #clustersize=$(($clustersize -1))
  #echo $clustersize
  #sed -i "s/myclustersizemy/${clustersize}/g" *inp

  cd $workdir
done
NUM=`cat folderfile | wc -l`


cat > $sbatchfile << EOF
#!/bin/bash
#SBATCH -p debug #partition : serial, test, hugemem, longrun
##SBATCH -t 01-00
#SBATCH --mem-per-cpu=5000
##SBATCH -o sbatch-hsw-%j.out
#SBATCH -n 48
#SBATCH -N 2
#SBATCH --constraint=hsw
#SBATCH --array=0-$NUM

module load CP2K #cp2k-env/4.1
declare -a fname
fname=(\`cat folderfile\`)

cd \${fname[\$SLURM_ARRAY_TASK_ID]}

## use first input you get
input_file="\$(ls -1 | grep '\\.inp' | head -1)"
output_file="\${input_file%inp}out"

## use first xyz-file you get
xyz_file="\$(ls -1 | grep '\\.xyz' | head -1)"

## define projectname in cp2k inputfile 
sed -i "s/myprojectnamemy/\${input_file%.inp}/g" \$input_file

sed -i "s/myxyzfilemy/\${xyz_file%.xyz}/g" \$input_file


cp2k_bin=cp2k.popt 
work_dir=.   
## runs the actual calculation
srun \$cp2k_bin -o \$output_file -i \$input_file  # option 1 

############################################################################
echo "Name of the partition in which the job is running: \$SLURM_JOB_PARTITION"
echo "Name of the node running the job script: \$SLURMD_NODENAME"
echo "     The ID of the job allocation: \$SLURM_JOB_ID"
echo "     List of nodes allocated to the job: \$SLURM_JOB_NODELIST"
echo "finnish"
EOF
#sbatch $sbatchfile

