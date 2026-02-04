#!/bin/bash
clear

echo '****************************************************'
echo 'Conda Data Science environment creation'
echo 'Author: Mauricio Ramos (mauriciocramos at gmail.com)'
echo 'Date created: 17/8/2020 last changed: 3/2/2026'
echo 'Usage: create-env.sh dev [-y]'
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

echo
echo "***************************"
echo "Installing base environment"
echo "***************************"
# Base environment: python, jupyter, numpy, pandas, graphics, scikit, nltk and data objects
# TODO: By 3/2/26 it seems spacy[cuda12x,transformers,lookups] requires python<3.13 and numpy<2 (2024's 1.26.4)
conda create -n "$1" -c conda-forge --override-channels $2 --no-default-packages "python<3.13"
conda activate "$1"
pip install --upgrade pip setuptools wheel
pip install "numpy<2" scipy \
jupyterlab jupyterlab_widgets ipywidgets nodejs jupyterlab_execute_time jupyterlab-git jupyterlab_code_formatter autopep8 isort black \
#statsmodels pandas pandas-stubs openpyxl \
#matplotlib seaborn selenium scrapy \
#sqlalchemy pymongo dnspython pypdf
## TODO: Not using since their courses: pyspark pydub python-confluent-kafka networkx nxviz pydot graphviz

#echo
#echo "*************************"
#echo "Installing CPU ML & NLP's"
#echo "*************************"
#pip install scikit-learn nltk leia vosk wordcloud textblob langdetect
#pip install gensim # Topic modelling, document indexing and similarity retrieval with large corpora
## TODO: shap requires numpy>=2 but spacy requires 1.26.4 (<2)
##pip install shap # SHapley Additive exPlanations: game theoretic approach to explain the output of any machine learning model
## TODO: DEPRECATED
#pip install modAL-python # Modular Active Learning framework built on top of scikit-learn (3+ y.o.)

#echo
#echo "*****************"
#echo "Installing Cupy's"
#echo "*****************"
#pip install cutensor-cu12 # cu11, cu12, cu13 # # https://pypi.org/search/?q=cutensor
#pip install nvidia-cusparselt-cu12 # cu12, cu13 # https://pypi.org/search/?q=cusparselt
#pip install cupy-cuda12x # cuda11x, cuda12x, cuda13x # https://pypi.org/search/?q=cupy-cuda11x
#python -c "import cupy; cupy.show_config()"

#echo
#echo "******************"
#echo "Installing Torch's"
#echo "******************"
## TODO: update pytorch wheels url from time to time for cuda upgrade
#pip install torch torchvision torchaudio torchmetrics torchao --index-url https://download.pytorch.org/whl/cu128
#pip install torch-fidelity # Very old (Jun 15, 2021) High-fidelity performance metrics for generative models in PyTorch
#pip install torchtune # Bit old (Apr 7, 2025) A native-PyTorch library for LLM fine-tuning

#echo
#echo "*************************"
#echo "Installing Hugging Face's"
#echo "*************************"
#pip install transformers sentencepiece sacremoses datasets accelerate evaluate absl-py gguf
## TODO: trl 0.27.2 requires transformers>=4.56.2, but spacy requires transformers 4.49.0 which is incompatible.
##pip install trl # HF's Transformer Reinforcement Learning: A comprehensive library to post-train foundation models
#pip install peft # State-of-the-art Parameter-Efficient Fine-Tuning (PEFT) methods
#pip install bitsandbytes # accessible large language models via k-bit quantization for PyTorch
#pip install wandb # Use Weights & Biases to train and fine-tune models, and manage models from experimentation to production.
#pip install hf_xet # Xet Storage suggested by HF's Transformers
#pip install rouge-score # required by HF's evaluate metric ROUGE

echo
echo "******************"
echo "Installing Spacy's"
echo "******************"
## TODO: By 3/2/26 spacy[cuda12x,transformers,lookups](3.8.11) requires numpy=1.26.4 (5/2/24) and break en_core_web_trf model installer
## [cuda11x] for CUDA 11.2-11.X
## [cuda12x] for CUDA 12.X:
pip install 'spacy[cuda11x,transformers,lookups]'

#echo
#echo "********************"
#echo "Installing Langchain"
#echo "********************"
## LangChain provides a pre-built agent architecture and model integrations to help you get started quickly
## and seamlessly incorporate LLMs into your agents and applications connecting OpenAI, Anthropic, Google, and more.
## TODO: langchain requires numpy<2
#pip install langchain # https://pypi.org/project/langchain/

#echo
#echo "******************"
#echo "Installing LLama's"
#echo "******************"
## pip install llama-cpp-python --no-cache-dir --verbose --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu124
## https://github.com/abetlen/llama-cpp-python#supported-backends
## pip install llama-stack # Composable building blocks to build Llama Apps: https://github.com/meta-llama/llama-stack
#CMAKE_ARGS="-DGGML_CUDA=on" pip install llama-cpp-python #--no-cache-dir

# post install
conda config --set default_activation_env "$1"
conda info
END_TIME=$(date +%s)
date
echo "Elapsed time: $((END_TIME - START_TIME)) seconds"
