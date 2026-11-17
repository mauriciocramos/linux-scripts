#!/bin/bash
clear

echo '****************************************************'
echo 'Spacy environment creation'
echo 'Author: Mauricio Ramos (mauriciocramos at gmail.com)'
echo 'Date created: 17/8/2020 last changed: 3/2/2026'
echo 'Usage: create-spacy.sh [-y]'
echo '****************************************************'

echo
echo "WARNING: Previously created spacy environment will be removed"
echo
read -rsp $'Press enter to continue...\n'
START_TIME=$(date +%s)
date

echo
echo "********************************"
echo "Configuring conda-forge channels"
echo "********************************"
source "$HOME"/miniconda3/etc/profile.d/conda.sh # required to use conda within a script
conda deactivate
conda config --prepend channels conda-forge
conda config --append channels nodefaults
conda config --add default_channels conda-forge
conda config --remove channels defaults
conda config --show-sources

echo
echo "**************"
echo "Updating conda"
echo "**************"
conda update conda -n base -y --override-channels -c conda-forge

# remove previous environment
conda info
conda config --set default_activation_env base # otherwise conda fails to remove previous environment
conda env remove -q -n spacy $1

ENVDIR=$HOME/miniconda3/envs/
rm "$ENVDIRspacy" -rf
ls "$ENVDIR" -la

echo
echo "***************************"
echo "Installing base environment"
echo "***************************"
# Base environment: python, jupyter, numpy, pandas, graphics, scikit, nltk and data objects
# TODO: 13/4/26 spacy[cuda12x,transformers,lookups] requires python<3.13 and numpy<2 (2024's 1.26.4)
conda create -n spacy -c conda-forge --override-channels $1 --no-default-packages "python<3.13" pip
conda activate spacy

pip install --upgrade pip setuptools wheel
pip install numpy #scipy statsmodels
pip install jupyterlab jupyterlab_widgets ipywidgets nodejs jupyterlab_execute_time jupyterlab-git jupyterlab_code_formatter autopep8 isort black
#pip install matplotlib seaborn
#pip install pandas
pip install openpyxl scrapy selenium sqlalchemy pymongo dnspython pypdf
# TODO: Not using since their courses: pyspark python-confluent-kafka networkx nxviz pydot graphviz

echo
echo "***********************"
echo "Installing CPU ML & NLP"
echo "***********************"
pip install nltk # scikit-learn
echo
echo "****************"
echo "Installing spacy"
echo "****************"
pip install 'spacy[cuda12x,transformers,lookups]'
echo
echo "*************"
echo "Testing spacy"
echo "*************"
python -c "import spacy; print(f'{spacy.require_gpu()=}')"

# post install
#conda config --set default_activation_env spacy
conda info
END_TIME=$(date +%s)
date
echo "Elapsed time: $((END_TIME - START_TIME)) seconds"
