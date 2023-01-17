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

# export cond env downstream
source /home/mauricio/miniconda3/etc/profile.d/conda.sh

# remove previous env
conda deactivate
conda info
conda env remove --name $1
ENVDIR=/home/mauricio/miniconda3/envs/
rm $ENVDIR$1 -rf
ls $ENVDIR

conda update -y conda

# Past packages still not installed:
# plotly qgrid pyaudio ffmpeg html5lib geopy google-api-python-client google-cloud-speech numpy-financial pyperclip

echo '**************************'
echo 'Creating environment '$1' '
echo '**************************'

OVERRIDE_CHANNELS="--override-channels"

# Base python/mkl/numpy/scipy environment
# rapids -> "python<3.10", rapids -> "numpy=1.23.5", numba -> "numpy<1.24.0"
# blas=*=mkl mutex metapackage (mkl 9%-45% faster than openblas)
# https://conda-forge.org/docs/maintainer/knowledge_base.html#blas
# (conda-forge blas=*=mkl installs llvm-openmp and _openmp_mutex-4.5-2_kmp_llvm)
conda create --no-default-packages $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 "python=3.9" "numpy<1.24" scipy pandas openpyxl libblas=*=*mkl #blas=*=mkl

conda activate $1

# Graphics and jupyter
# jupyter_client=7.34 and jupyter_server<2 still required by rapids=22.12 otherwise jupyter_server_terminals fail when starting jupyter lab
# matplotlib<3.6 because rapids install old networkx that has a bug with matplotlib>=3.6
# conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 matplotlib seaborn jupyterlab jupyterlab_execute_time jupyterlab-git jupyterlab-spellchecker jupyterlab_code_formatter autopep8 isort black
# conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 "matplotlib<3.6" seaborn "jupyter_server<2" "jupyter_client=7.3.4" jupyterlab jupyterlab_execute_time jupyterlab-git jupyterlab-spellchecker jupyterlab_code_formatter autopep8 isort black
conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 matplotlib seaborn jupyterlab jupyterlab_execute_time jupyterlab-git jupyterlab-spellchecker jupyterlab_code_formatter autopep8 isort black

# scikit-learn (installs joblib and threadpoolctl)
conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 scikit-learn

# CUDA Toolkit (used by tensorflow, rapids, py-xgboost-gpu and spacy. Pytorch requires cuda>=11.6<=11.7)
conda install $OVERRIDE_CHANNELS -c conda-forge -c nvidia $2 -n $1 "cudatoolkit=11.7"

# numba waiting https://numba.readthedocs.io/en/stable/user/installing.html#version-support-information
# Left to be installed by rapids

# xgboost GPU version (requires scikit-learn) left to be installed by rapids
# conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 py-xgboost-gpu

# RAPIDS https://rapids.ai/start.html#get-rapids # (installs llvmlite, requires cudatoolkit)
# conda install $OVERRIDE_CHANNELS -c rapidsai -c conda-forge -c nvidia $2 -n $1 "rapids=22.12"
# temporarly install nightly build until 23.02 is stable because of very old packages within 22.12 (e.g. networkx)
conda install $OVERRIDE_CHANNELS -c rapidsai-nightly -c conda-forge -c nvidia $2 -n $1 "rapids=23.02"

# nxviz (having old networkx installed by rapids)
conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 nxviz

# Tensorflow (requires CUDA toolkit. after rapids to avoid conflicts)
conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 tensorflow-gpu

# ffmpeg (before pytorch otherwise torchaudio would install old ffmpeg conflicting with pydub)
conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 ffmpeg

# Pytorch (requires cudatoolkit=11.7, ffmpeg.  Required by spacy on GPU) https://pytorch.org/get-started/locally/
conda install $OVERRIDE_CHANNELS -c pytorch -c nvidia -c conda-forge $2 -n $1 pytorch torchvision torchaudio "pytorch-cuda=11.7"


# NLP and ASR packages
conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 nltk spacy spacy-transformers wordcloud gensim textblob langdetect scrapy speechrecognition pydub textstat

# Mongodb
conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 pymongo dnspython

# Intel extension for scikit-learn (installs intel-openmp, daal4py) disabled because training sparse data and some estimators are limited
# conda install $OVERRIDE_CHANNELS -c conda-forge $2 -n $1 scikit-learn-intelex # dpctl

# Intel Daal4py (deprecated, for benchmarks)
# conda install $OVERRIDE_CHANNELS -c intel -c conda-forge $2 -n $1 daal4py

# PIP section
# vosk
pip install --upgrade pip
pip install vosk
pip install textatistic
# pip install tensorflow-gpu
# ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
# cudf 22.12.1 requires cupy-cuda11x, which is not installed.
# cudf-kafka 22.12.1 requires cython, which is not installed.
# cudf 22.12.1 requires protobuf<3.21.0a0,>=3.20.1, but you have protobuf 3.19.6 which is incompatible.


# post install
conda config --set auto_activate_base false
conda info

END_TIME=$(date +%s)
echo "Elased time: $(($END_TIME - $START_TIME)) seconds"

