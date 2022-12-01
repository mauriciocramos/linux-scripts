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
# plotly qgrid autopep8 pyaudio ffmpeg beautifulsoup4 html5lib psutil
# geopy speechrecognition google-api-python-client google-cloud-speech numpy-financial pyperclip

echo '**************************'
echo 'Creating environment '$1' '
echo '**************************'

# Base python/mkl/numpy/scipy environment
# rapids -> "python<3.10", rapids -> "numpy=1.23.5", numba -> "numpy<1.24.0"
# blas=*=mkl mutex metapackage (mkl 9%-45% faster than openblas)
# https://conda-forge.org/docs/maintainer/knowledge_base.html#blas
# (conda-forge blas=*=mkl installs llvm-openmp and _openmp_mutex-4.5-2_kmp_llvm)
# conda create --no-default-packages --override-channels -c conda-forge $2 -n $1 "python=3.9" "numpy=1.21.6" scipy libblas=*=*mkl #blas=*=mkl
conda create --no-default-packages --override-channels -c conda-forge $2 -n $1 "python=3.9" numpy scipy libblas=*=*mkl #blas=*=mkl

conda activate $1

# Common graphics and jupyter packages
# conda install --override-channels -c conda-forge $2 -n $1 matplotlib seaborn openpyxl "nodejs>12" jupyterlab jupyterlab_execute_time jupyterlab-git jupyterlab-spellchecker
conda install --override-channels -c conda-forge $2 -n $1 matplotlib seaborn openpyxl nodejs jupyterlab jupyterlab_execute_time jupyterlab-git jupyterlab-spellchecker

# nvidia CUDA toolkit 11.7 (Geforce RTX3060LHR, used by rapids, py-xgboost-gpu and spacy)
conda install --override-channels -c nvidia -c conda-forge $2 -n $1 cudatoolkit=11.7

# cupy drop-in (mostly) replacement for numpy/scipy
# Leave it be installed by rapids

# numba waiting https://numba.readthedocs.io/en/stable/user/installing.html#version-support-information
# Leave it be installed by rapids

# scikit-learn (installs joblib and threadpoolctl)
# conda install --override-channels -c conda-forge $2 -n $1 scikit-learn "joblib=1.1.1"
conda install --override-channels -c conda-forge $2 -n $1 scikit-learn

# xgboost GPU version (requires scikit-learn)
# Leave it be installed by rapids
# In case rapids will not be installed:
# conda install --override-channels -c conda-forge $2 -n $1 py-xgboost-gpu

# RAPIDS (end-to-end GPU pipelines) https://rapids.ai/start.html#get-rapids
# (installs llvmlite)
# disabled because requiring numpy 1.21.6 since rapids 22.08 and conflicts to be solved
# conda install --override-channels -c rapidsai -c nvidia -c conda-forge $2 -n $1 "rapids=22.10"
conda install --override-channels -c rapidsai -c conda-forge -c nvidia $2 -n $1 "rapids=22.10"

# Intel extension for scikit-learn
# (installs intel-openmp, daal4py, dpctl for Intel GPU?)
# Avoid installing from intel because it raises the multiple openmp issue:
# https://github.com/joblib/threadpoolctl/blob/master/multiple_openmp.md
# disabled because training sparse data and some estimators become limited
# conda install --override-channels -c conda-forge $2 -n $1 scikit-learn-intelex # dpctl

# Intel Daal4py (deprecated, for benchmarks)
# conda install --override-channels -c intel -c conda-forge $2 -n $1 daal4py

# NLP packages
# conda install -c conda-forge $2 -n $1 "nltk>=3.6.7" spacy spacy-transformers wordcloud
conda install --override-channels -c conda-forge $2 -n $1 nltk spacy spacy-transformers wordcloud
# Mongodb
conda install --override-channels -c conda-forge $2 -n $1 pymongo dnspython

# post install
conda config --set auto_activate_base false
conda info

END_TIME=$(date +%s)
echo "Elased time: $(($END_TIME - $START_TIME)) seconds"

