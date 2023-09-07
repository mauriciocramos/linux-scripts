#!/bin/bash
clear
echo '****************************************************'
echo 'Conda Data Science R environment creation'
echo 'Author: Mauricio Ramos (mauriciocramos at gmail.com)'
echo 'Date created: 17/8/2020 Date changed: 2/9/2022'
echo 'Usage: R-env.sh'
echo '****************************************************'
echo
echo 'WARNING: Previoulsly created environment 'r' will be removed'
echo
read -rsp $'Press enter to continue...\n'

# export cond env downstream
source "$HOME"/miniconda3/etc/profile.d/conda.sh

# remove previous env
conda deactivate
conda info
conda env remove --name r
ENVDIR="$HOME"/miniconda3/envs
rm $ENVDIR/r -rf
ls $ENVDIR

conda update -y conda
conda create --no-default-packages --override-channels -c conda-forge -n r "python=3.9" numpy scipy pandas libblas=*=*mkl \
matplotlib seaborn openpyxl \
jupyterlab jupyterlab_execute_time jupyterlab-git jupyterlab-spellchecker \
r-base r-irkernel r-XML r-xlsx r-httr r-stringr r-dplyr r-tm r-NLP # base/conar requirements

