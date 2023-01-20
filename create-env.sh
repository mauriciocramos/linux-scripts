#!/bin/bash
clear
echo '****************************************************'
echo 'Conda Data Science environment creation'
echo 'Author: Mauricio Ramos (mauriciocramos at gmail.com)'
echo 'Date created: 17/8/2020 Date changed: 2/9/2022'
echo 'Usage: create-env.sh dev'
echo '****************************************************'

if [ -z "$1" ]
  then
    echo 'ERROR: Missing environment name'
    exit 1
fi
echo
echo 'WARNING: Previoulsly created environment '$1' will be removed'
echo
read -rsp $'Press enter to continue...\n'
START_TIME=$(date +%s)

# required to use conda within a script
source /home/mauricio/miniconda3/etc/profile.d/conda.sh

# remove previous environment
conda deactivate
conda info
conda env remove --name $1
ENVDIR=/home/mauricio/miniconda3/envs/
rm $ENVDIR$1 -rf
ls $ENVDIR

conda update -y conda

# Past packages still not installed: plotly qgrid pyaudio html5lib geopy google-api-python-client google-cloud-speech numpy-financial pyperclip

echo '**************************'
echo 'Creating environment '$1' '
echo '**************************'

OVERRIDE_CHANNELS="--override-channels"

# Base environment
# rapids -> "python<3.10", rapids -> "numpy=1.23.5", numba -> "numpy<1.24.0"
# https://conda-forge.org/docs/maintainer/knowledge_base.html#blas
# libblas=*=*mkl or blas=*=mkl (mkl 9%-45% faster than openblas)
# (conda-forge blas=*=mkl installs llvm-openmp and _openmp_mutex-4.5-2_kmp_llvm)
# ffmpeg before pytorch otherwise torchaudio would install old ffmpeg conflicting with pydub)
conda create --no-default-packages $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 "python=3.9" numpy scipy pandas \
# openpyxl dnspython pymongo ffmpeg nxviz \
# matplotlib seaborn nodejs jupyterlab jupyterlab_execute_time jupyterlab-git jupyterlab-spellchecker jupyterlab_code_formatter autopep8 isort black \
# scikit-learn

conda activate $1

# CUDA Toolkit (used by tensorflow, rapids, py-xgboost-gpu and spacy. Pytorch requires cuda>=11.6<=11.7)
# conda install $OVERRIDE_CHANNELS -c conda-forge -c nvidia $2 -n $1 "cudatoolkit=11.2" "cudnn=8.1.0" # tensorflow?
# conda install $OVERRIDE_CHANNELS -c conda-forge -c nvidia $2 -n $1 "cudatoolkit=11.7"

# numba waiting https://numba.readthedocs.io/en/stable/user/installing.html#version-support-information
# Left to be installed by rapids

# xgboost GPU version (requires scikit-learn) left to be installed by rapids
# conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 py-xgboost-gpu

# RAPIDS https://rapids.ai/start.html#get-rapids # (installs llvmlite, numba, requires cudatoolkit)
# conda install $OVERRIDE_CHANNELS -c rapidsai -c conda-forge -c nvidia $2 -n $1 "rapids=22.12"

# Tensorflow (requires CUDA toolkit)
# conda tensorflow is not built/linked to tensorrt
# conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 "tensorflow<2.10"

# Pytorch (requires cudatoolkit=11.7, ffmpeg.  Required by spacy on GPU) https://pytorch.org/get-started/locally/
# conda install $OVERRIDE_CHANNELS -c pytorch -c nvidia -c conda-forge $2 -n $1 pytorch torchvision torchaudio "pytorch-cuda=11.7"

# NLP and ASR packages
# conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 nltk spacy spacy-transformers wordcloud gensim textblob langdetect scrapy speechrecognition pydub textstat

# Pip section
# pip install --upgrade pip
# pip install vosk
# pip install textatistic

# post install
conda config --set auto_activate_base false
conda info

END_TIME=$(date +%s)
echo "Elased time: $(($END_TIME - $START_TIME)) seconds"

