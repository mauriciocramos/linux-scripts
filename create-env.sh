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

# Packages still not installed:
# plotly qgrid autopep8 pyaudio ffmpeg beautifulsoup4 html5lib psutil
# geopy speechrecognition google-api-python-client google-cloud-speech numpy-financial pyperclip

echo '**************************'
echo 'Creating environment '$1' '
echo '**************************'

# Channel defaults builds intel MKL, numpy<1.23 for scikit-learn's scipy usage and python pinnned for 3.9.12 to avoid update it with downstream conda-forge installs
# conda create --no-default-packages $2 -n $1 "python<3.10" blas=*=mkl "numpy<1.23.0" scipy pandas matplotlib seaborn openpyxl

# Base python/mkl/numpy/scipy environment
# rapids -> "python<3.10", rapids -> "numpy=1.22.0", numba -> "numpy<1.23.0"
# blas=*=mkl mutex metapackage (mkl 9%-45% faster than openblas)
# https://conda-forge.org/docs/maintainer/knowledge_base.html#blas
# (conda-forge blas=*=mkl installs llvm-openmp and _openmp_mutex-4.5-2_kmp_llvm)
conda create --no-default-packages --override-channels -c conda-forge $2 -n $1 "python<3.10" "numpy=1.22.0" scipy libblas=*=*mkl #blas=*=mkl

conda activate $1

# Common graphics and jupyter packages
conda install --override-channels -c conda-forge $2 -n $1 matplotlib seaborn openpyxl "nodejs>12" jupyterlab jupyterlab_execute_time jupyterlab-git

# nvidia CUDA toolkit 11.7 (Geforce RTX3060LHR)
conda install --override-channels -c nvidia -c conda-forge $2 -n $1 cudatoolkit=11.7

# cupy drop-in (mostly) replacement for numpy/scipy
# Leave it to rapids install: rapids -> conda-forge/linux-64::cupy-10.6.0-py39hc3c280e_0
# conda install --override-channels -c conda-forge $2 -n $1 "cupy=10.6"
# numba waiting https://numba.readthedocs.io/en/stable/user/installing.html#version-support-information
# Leave it to rapids install: rapids -> conda-forge/linux-64::numba-0.55.2-py39h66db6d7_0
# conda install --override-channels -c numba -c conda-forge $2 -n $1 "numba=0.55.2"

# scikit-learn (installs joblib and threadpoolctl)
conda install --override-channels -c conda-forge $2 -n $1 scikit-learn

# xgboost GPU version (requires scikit-learn)
# Leave it to rapids install: rapids -> rapidsai/linux-64::xgboost-1.6.0dev.rapidsai22.08-cuda_11_py39_0
# conda install --override-channels -c conda-forge $2 -n $1 py-xgboost-gpu

# RAPIDS (end-to-end GPU pipelines) https://rapids.ai/start.html#get-rapids
# (installs llvmlite)
conda install --override-channels -c rapidsai -c nvidia -c conda-forge $2 -n $1 "rapids=22.08"

# Intel extension for scikit-learn
# (installs intel-openmp, daal4py, dpctl for Intel GPU?)

# conda install --override-channels -c intel -c conda-forge $2 -n $1 scikit-learn-intelex # dpctl
# Avoid installing from intel because it raises the multiple openmp issue:
# https://github.com/joblib/threadpoolctl/blob/master/multiple_openmp.md
conda install --override-channels -c conda-forge $2 -n $1 scikit-learn-intelex # dpctl

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

