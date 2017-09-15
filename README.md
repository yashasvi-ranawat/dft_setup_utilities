# dft_setup_utilities
Setup many CP2K calculations at the same time

Setup_gopt_calculations:
a) fully relax structure
b) only last atom will relax

Check the CP2K input file, the .slrm file (which works on taito) and how examples is structured
All folders contain one xyz file. Give the path to the folder in the file named folderfile
It is recommended to first comment out # sbatch in order to check if the input files are correct
