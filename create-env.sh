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
conda env remove -q -n "$1" $2
ENVDIR=$HOME/miniconda3/envs/
rm "$ENVDIR$1" -rf
ls "$ENVDIR"

conda update -y -n base conda

# Base environment
conda create -n "$1" -c conda-forge --override-channels $2 --no-default-packages "python<3.13" \
jupyterlab jupyterlab_widgets ipywidgets nodejs jupyterlab_execute_time jupyterlab-git jupyterlab_code_formatter autopep8 isort black \
numpy \
scipy statsmodels \
pandas openpyxl \
matplotlib seaborn \
scikit-learn nltk \
selenium scrapy \
sqlalchemy \
pymongo dnspython \
pypdf
# TODO: pyspark is on hold because conda required numpy=1.26.4 while pip installs fine over numpy=2.2.4
# TODO: Used in courses but no longer used: pydub python-confluent-kafka networkx nxviz pydot graphviz
# TODO: never tested this UI:  great-expectations

conda activate "$1" # mainly for late pip installations because conda explicit --name "$1"

# Pytorch no longer officially supports conda: https://pytorch.org/get-started/locally/
# Pytorch officially supports: pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
# conda install -n "$1" -c conda-forge --override-channels $2 pytorch-gpu torchvision torchaudio torchmetrics torch-fidelity

# TODO: tensorflow Not used beyond courses
# Tensorflow conda package is not built with tensorrt.
# Official: pip install tensorflow
# Unofficial: conda  install -n "$1" -c conda-forge --override-channels $2 tensorflow

# Huggging Face NLP for PyTorch and TensorFlow
#conda install -n "$1" -c conda-forge --override-channels $2 transformers sentencepiece sacremoses datasets accelerate evaluate absl-py gguf

# NLP packages
# TODO: spacy-transformers is on hold because it is forcing outdated (2022) version of HF transformers
# TODO: gensim is on hold because conda required numpy<2, conflicting to "numpy>=2.2.4"
# TODO: langchain is on hold because conda required numpy=1.26.4
#conda install -n "$1" -c conda-forge --override-channels $2  spacy cupy wordcloud # shap textblob langdetect textstat

echo '*******************************************'
echo 'Pip installations after conda installations'
echo '*******************************************'
pip install --upgrade pip setuptools wheel
pip install vosk
pip install leia

pip install torch torchvision torchaudio torchmetrics torch-fidelity torchtune torchao

pip install transformers sentencepiece sacremoses datasets accelerate evaluate absl-py gguf
pip install trl # HF's Transformer Reinforcement Learning: A comprehensive library to post-train foundation models
pip install peft # State-of-the-art Parameter-Efficient Fine-Tuning (PEFT) methods
pip install bitsandbytes
pip install wandb # Use Weights & Biases to train and fine-tune models, and manage models from experimentation to production.

pip install hf_xet # Xet Storage suggested by HF's Transformers
pip install rouge-score # required by HF's evaluate metric ROUGE

# Llama's:
CMAKE_ARGS="-DGGML_CUDA=on" pip install llama-cpp-python --no-cache-dir #--verbose --force-reinstall # https://github.com/abetlen/llama-cpp-python#supported-backends
# pip install llama-cpp-python --no-cache-dir --verbose # CPU-ONLY
# pip install llama-cpp-python --no-cache-dir --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu124 # https://github.com/abetlen/llama-cpp-python#supported-backends
# pip install llama-stack # Composable building blocks to build Llama Apps: https://github.com/meta-llama/llama-stack

# Modular Active Learning framework for Python3 (very old at Apr 2025)
pip install modAL-python

# TODO: replace scikeras by keras_tunner: https://keras.io/keras_tuner/
# scikeras: https://www.adriangb.com/scikeras/stable/install.html#users-installation
# pip install --no-deps "scikeras[tensorflow]" # pip install keras-tuner

# post install
conda config --set auto_activate_base false
conda info

END_TIME=$(date +%s)
echo "Elapsed time: $((END_TIME - START_TIME)) seconds"

