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

# Base environment
conda create -n "$1" -c conda-forge --override-channels $2 --no-default-packages python \
jupyterlab nodejs jupyterlab_execute_time jupyterlab-git jupyterlab_code_formatter autopep8 isort black \
numpy scipy statsmodels \
pandas openpyxl \
matplotlib seaborn \
scikit-learn \
sqlalchemy \
pymongo dnspython \
selenium scrapy \
ffmpeg pydub \
python-confluent-kafka \
networkx nxviz pydot graphviz \
great-expectations \
pyspark
# boto3 \
# trino-python-client \
# sagemaker \
# bokeh plotly \
# numba dask \

conda activate "$1" # mainly for late pip installations because conda explicit --name "$1"

# CUDA Toolkit (used by tensorflow, rapids, py-xgboost-gpu, spacy and pytorch)
conda install -n "$1" -c conda-forge -c nvidia --override-channels $2 cudatoolkit

# Pytorch Conda packages are no longer available in pytorch conda channel: https://pytorch.org/get-started/locally/
# Officially: pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
# Alternative:
conda install -n "$1" -c conda-forge --override-channels $2 pytorch-gpu torchvision torchaudio torchmetrics torch-fidelity \
torchtext # <- deprectated since April 2024 but datacamp still uses it

# Tensorflow conda package is not built with tensorrt
# Officially: pip install tensorflow
# Alternative:
# conda install -n "$1" -c conda-forge --override-channels $2 tensorflow

# NLP packages
conda install -n "$1" -c conda-forge --override-channels $2 nltk spacy cupy spacy-transformers langchain shap wordcloud gensim textblob langdetect textstat

echo '*******************************************'
echo 'Pip installations after conda installations'
echo '*******************************************'
pip install --upgrade pip
pip install vosk
# pip install textatistic # asked for gcc?
# https://www.adriangb.com/scikeras/stable/install.html#users-installation
# pip install --no-deps "scikeras[tensorflow]" # TODO: replace by pip install keras-tuner https://keras.io/keras_tuner/

# post install
conda config --set auto_activate_base false
conda info

END_TIME=$(date +%s)
echo "Elapsed time: $((END_TIME - START_TIME)) seconds"

