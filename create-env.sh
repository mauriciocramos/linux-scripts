#!/bin/bash
clear
echo '****************************************************'
echo 'Conda Data Science environment creation'
echo 'Author: Mauricio Ramos (mauriciocramos at gmail.com)'
echo 'Date created: 17/8/2020 Date changed: 10/1/2025'
echo 'Usage: create-env.sh dev'
echo '****************************************************'

if [ -z "$1" ]
  then
    echo 'ERROR: Missing environment name'
    exit 1
fi
echo
echo "WARNING: Previously created environment $1 will be removed"
echo
read -rsp $'Press enter to continue...\n'
START_TIME=$(date +%s)
date

source "$HOME"/miniconda3/etc/profile.d/conda.sh # required to use conda within a script
# remove previous environment
conda deactivate
conda info
conda env remove --name "$1" $2
ENVDIR=$HOME/miniconda3/envs/
rm "$ENVDIR$1" -rf
ls "$ENVDIR"

conda update -y -n base conda

# Past packages: grid pyaudio html5lib geopy google-api-python-client google-cloud-speech numpy-financial tweepy pyperclip

# Base environment RELEASE CONTROL
# Numba: https://numba.readthedocs.io/en/stable/user/installing.html#version-support-information
# AWS 2020-11-30: numba=0.52.x->python>=3.6<3.9->numpy>=1.15<1.20->llvmlite=0.35->LLVM=10->TBB>=2019.5<2020.3
# rig 2023-06-21: numba=0.57.1->python>=3.8<3.12->numpy>=1.21<1.25-llvmlite=0.40->LLVM=14->TBB>=2021.6
# rig 2024: python<3.10 jupyterlab<4 jupyterlab_execute_time<3
conda create -n "$1" -c conda-forge --override-channels $2 --no-default-packages "python<3.13" \
jupyterlab nodejs jupyterlab_execute_time jupyterlab-git jupyterlab_code_formatter autopep8 isort black \
"numpy=1.26.4" scipy statsmodels \
pandas openpyxl \
matplotlib seaborn \
scikit-learn \
selenium scrapy \
sqlalchemy \
pymongo dnspython \
python-confluent-kafka \
pyspark \
ffmpeg pydub \
networkx nxviz pydot graphviz \
great-expectations
# boto3 \
# trino-python-client \
# sagemaker \
# bokeh plotly \
# numba dask \

conda activate "$1" # mainly for late pip installations because conda's explicit --name "$1"

# CUDA Toolkit (used by tensorflow, rapids, py-xgboost-gpu, spacy and pytorch)
conda install -n "$1" -c conda-forge -c nvidia --override-channels $2  cudatoolkit

# RAPIDS https://rapids.ai/#quick-start
# conda install -n "$1" -c rapidsai -c conda-forge -c nvidia --override-channels $2 "rapids=23.06"

# Tensorflow conda package is not built with tensorrt
conda install -n "$1" -c conda-forge --override-channels $2 tensorflow

# Pytorch (cudatoolkit=11.8, ffmpeg.  Required by spacy on GPU) https://pytorch.org/get-started/locally/
conda install -n "$1" -c pytorch -c nvidia -c conda-forge --override-channels $2 pytorch torchvision torchaudio "pytorch-cuda=11.8"

# NLP packages
conda install -n "$1" -c conda-forge --override-channels $2 nltk spacy spacy-transformers wordcloud gensim textblob langdetect textstat

echo '*******************************************'
echo 'Pip installations after conda installations'
echo '*******************************************'
pip install --upgrade pip
# pip install tensorflow
pip install vosk
# pip install textatistic # asked for gcc?
# https://www.adriangb.com/scikeras/stable/install.html#users-installation
pip install --no-deps "scikeras[tensorflow]" # TODO: replace by pip install keras-tuner https://keras.io/keras_tuner/

# post install
conda config --set auto_activate_base false
conda info

END_TIME=$(date +%s)
echo "Elapsed time: $((END_TIME - START_TIME)) seconds"

