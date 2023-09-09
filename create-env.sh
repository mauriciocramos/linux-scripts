#!/bin/bash
clear
echo '****************************************************'
echo 'Conda Data Science environment creation'
echo 'Author: Mauricio Ramos (mauriciocramos at gmail.com)'
echo 'Date created: 17/8/2020 Date changed: 7/9/2023'
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

# required to use conda within a script
source "$HOME"/miniconda3/etc/profile.d/conda.sh
# remove previous environment
conda deactivate
conda info
conda env remove --name "$1"
ENVDIR=$HOME/miniconda3/envs/
rm "$ENVDIR$1" -rf
ls "$ENVDIR"

conda update -y -n base conda

# Past packages still not installed: plotly qgrid pyaudio html5lib geopy google-api-python-client google-cloud-speech numpy-financial pyperclip

# Base environment
conda create --no-default-packages --override-channels -c conda-forge "$2" -n "$1" "python<3.11" \
numpy scipy pandas \
openpyxl \
sqlalchemy trino-python-client \
dnspython pymongo \
ffmpeg \
networkx nxviz pydot graphviz \
matplotlib seaborn \
scikit-learn \
pyspark \
jupyterlab jupyterlab_execute_time jupyterlab-git jupyterlab-spellchecker jupyterlab_code_formatter autopep8 isort black nodejs \
selenium scrapy \
python-confluent-kafka \
tweepy

conda activate "$1"

# CUDA Toolkit (used by tensorflow, rapids, py-xgboost-gpu, spacy and pytorch)
conda install --override-channels -c conda-forge -c nvidia "$2" -n "$1" cudatoolkit

# RAPIDS https://rapids.ai/#quick-start
#conda install --override-channels -c rapidsai -c conda-forge -c nvidia $2 -n $1 "rapids=23.06"

# Tensorflow conda package is not built with tensorrt
conda install --override-channels -c conda-forge "$2" -n "$1" tensorflow

# Pytorch (cudatoolkit=11.8, ffmpeg.  Required by spacy on GPU) https://pytorch.org/get-started/locally/
conda install --override-channels -c pytorch -c nvidia -c conda-forge "$2" -n "$1" pytorch torchvision torchaudio "pytorch-cuda=11.8"

# NLP and ASR packages
conda install --override-channels -c conda-forge "$2" -n "$1" nltk spacy spacy-transformers wordcloud gensim textblob langdetect speechrecognition pydub textstat

echo '*******************************************'
echo 'Pip installations after conda installations'
echo '*******************************************'
pip install --upgrade pip
pip install vosk
pip install textatistic
# https://www.adriangb.com/scikeras/stable/install.html#users-installation
pip install --no-deps "scikeras[tensorflow]" # TODO: replace by pip install keras-tuner https://keras.io/keras_tuner/
pip install kafka-python

# post install
conda config --set auto_activate_base false
conda info

END_TIME=$(date +%s)
echo "Elapsed time: $((END_TIME - START_TIME)) seconds"

