#!/bin/bash

echo '************'
echo 'install vosk'
echo '************'

if [ -z "$1" ]
  then
    echo 'ERROR: Missing conda environment name'
    exit 1
fi
read -rsp $'Press enter to continue...\n'

# export cond env downstream
source /home/mauricio/miniconda3/etc/profile.d/conda.sh
conda update --yes conda
conda activate $1

# vosk
pip install vosk
