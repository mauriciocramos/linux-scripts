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
conda config --set default_activation_env base # otherwise conda remove fails
conda env remove -q -n "$1" $2
ENVDIR=$HOME/miniconda3/envs/
rm "$ENVDIR$1" -rf
ls "$ENVDIR"

conda update -y -n base conda

# Base environment: python, jupyter, numpy, pandas, graphics, data objects
# As of 30/1/26 it seems spacy[cuda12x,transformers,lookups] required python<3.13 and numpy<2 (1.26.4 from 2024's while latest 2.4.1)
conda create -n "$1" -c conda-forge --override-channels $2 --no-default-packages "python<3.13"
conda activate "$1"

pip install --upgrade pip setuptools wheel
pip install "numpy<2" \
jupyterlab jupyterlab_widgets ipywidgets nodejs jupyterlab_execute_time jupyterlab-git jupyterlab_code_formatter autopep8 isort black \
scipy statsmodels \
pandas pandas-stubs openpyxl \
matplotlib seaborn \
scikit-learn nltk \
selenium scrapy \
sqlalchemy \
pymongo dnspython \
pypdf
# TODO: Not using quite sometime: pyspark pydub python-confluent-kafka networkx nxviz pydot graphviz

# Spacy's
# TODO: as of 31/1/26 spacy 3.8.11 downgrades numpy=1.26.4 of 5/2/24:
#pip install 'spacy[cuda12x,transformers,lookups]'
# TODO: as of 31/1/26 spacy[cuda12x,transformers,lookups] breaks spacy model installs so cuda11x
pip install 'spacy[cuda11x,transformers,lookups]'

# Pytorch's
# TODO: update pytorch wheels url from time to time for cuda upgrade
pip install torch torchvision torchaudio torchmetrics torchao #-index-url https://download.pytorch.org/whl/cu130 # for cuda 13.0
pip install torch-fidelity # Very old (Jun 15, 2021) High-fidelity performance metrics for generative models in PyTorch
pip install torchtune # Bit old (Apr 7, 2025) A native-PyTorch library for LLM fine-tuning
# Hugging Face's:
pip install transformers sentencepiece sacremoses datasets accelerate evaluate absl-py gguf
pip install trl # HF's Transformer Reinforcement Learning: A comprehensive library to post-train foundation models
pip install peft # State-of-the-art Parameter-Efficient Fine-Tuning (PEFT) methods
pip install bitsandbytes # accessible large language models via k-bit quantization for PyTorch
pip install wandb # Use Weights & Biases to train and fine-tune models, and manage models from experimentation to production.
pip install hf_xet # Xet Storage suggested by HF's Transformers
pip install rouge-score # required by HF's evaluate metric ROUGE

# TODO: gensim requires numpy<2
pip install gensim

# TODO: langchain requires numpy<2
pip install langchain

# NLP's:
pip install leia vosk wordcloud textblob langdetect
# TODO: shap requires numpy-2.3.5 but spacy requires 1.26.4 (<2)

# Llama's:
## pip install llama-cpp-python --no-cache-dir --verbose # CPU-ONLY
## pip install llama-cpp-python --no-cache-dir --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu124 # https://github.com/abetlen/llama-cpp-python#supported-backends
## pip install llama-stack # Composable building blocks to build Llama Apps: https://github.com/meta-llama/llama-stack
CMAKE_ARGS="-DGGML_CUDA=on" pip install llama-cpp-python --no-cache-dir #--verbose --force-reinstall # https://github.com/abetlen/llama-cpp-python#supported-backends

# Modular Active Learning framework for Python3 (very old at Apr 2025)
pip install modAL-python

# post install
conda config --set default_activation_env "$1"
conda info

END_TIME=$(date +%s)
date
echo "Elapsed time: $((END_TIME - START_TIME)) seconds"
