#!/bin/bash
clear
echo '****************************************************'
echo 'Conda Data Science environment creation'
echo 'Author: Mauricio Ramos (mauriciocramos at gmail.com)'
echo 'Date created: 17/8/2020 Date changed: 22/7/2022'
echo 'Usage: create-conda-env.sh dev'
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

# Old defaults+conda-forge creation:
# conda create --yes --no-default-packages --override-channels --channel defaults --name $1 python numpy pandas scikit-learn scikit-learn-intelex nltk statsmodels seaborn pymongo dnspython openpyxl plotly qgrid autopep8 notebook jupyterlab nodejs pyaudio ffmpeg beautifulsoup4 lxml html5lib psutil
# conda activate $1
# conda install --yes --override-channels --channel conda-forge jupyterlab_execute_time geopy wordcloud speechrecognition google-api-python-client google-cloud-speech numpy-financial spacy pyperclip

echo '**************************'
echo 'Creating environment '$1' '
echo '**************************'

# Channel defaults builds intel MKL, numpy<1.23 for scikit-learn's scipy usage and python pinnned for 3.9.12 to avoid update it with downstream conda-forge installs
# conda create --no-default-packages $2 -n $1 "python<3.10" blas=*=mkl "numpy<1.23.0" scipy pandas matplotlib seaborn openpyxl

# Baseline environment
# rapids->"python<3.10"
# rapids ->"numpy=1.22.0"
# numba->"numpy<1.23.0"
# blas=*=mkl mutex metapackage (still unsure numpy/scipy show_config())
conda create --no-default-packages --override-channels -c conda-forge $2 -n $1 "python<3.10.0a" "numpy=1.22.0" scipy pandas matplotlib seaborn openpyxl \
 jupyterlab "nodejs>12" jupyterlab_execute_time jupyterlab-git # Jupyter's

conda activate $1

# nvidia CUDA toolkit 11.7 (Geforce RTX3060LHR)
conda install --override-channels -c nvidia -c conda-forge $2 -n $1 cudatoolkit=11.7

# cupy drop-in (mostly) replacement for numpy/scipy
# rapids->conda-forge/linux-64::cupy-10.6.0-py39hc3c280e_0
# conda install --override-channels -c conda-forge $2 -n $1 "cupy=10.6"

# numba waiting https://numba.readthedocs.io/en/stable/user/installing.html#version-support-information
# rapids->conda-forge/linux-64::numba-0.55.2-py39h66db6d7_0
# conda install --override-channels -c numba -c conda-forge $2 -n $1 "numba=0.55.2"

# scikit-learn
# rapids->scikit-learn=1.1.2
conda install --override-channels -c conda-forge $2 -n $1 "scikit-learn>=1.1.2"

# xgboost GPU version (requires scikit-learn)
# rapids->rapidsai/linux-64::xgboost-1.6.0dev.rapidsai22.08-cuda_11_py39_0
# conda install --override-channels -c conda-forge $2 -n $1 py-xgboost-gpu

# RAPIDS (end-to-end GPU pipelines) https://rapids.ai/start.html#get-rapids
conda install --override-channels -c rapidsai -c nvidia -c conda-forge $2 -n $1 "rapids=22.08"

# Intel extension for scikit-learn (dpctl for Intel GPU?)
conda install --override-channels -c intel -c conda-forge $2 -n $1 scikit-learn-intelex dpctl
# Intel Daal4py (deprecated? for now benchmarks)
conda install --override-channels -c intel -c conda-forge $2 -n $1 daal4py

# conda install -c conda-forge $2 -n $1 "nltk>=3.6.7" spacy spacy-transformers wordcloud
conda install --override-channels -c conda-forge $2 -n $1 nltk spacy spacy-transformers wordcloud
# Mongodb
conda install --override-channels -c conda-forge $2 -n $1 pymongo dnspython

# post install
conda config --set auto_activate_base false
conda info

