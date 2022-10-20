#!/bin/bash

echo '*****************************'
echo 'install spacy data and models'
echo '*****************************'
if [ -z "$1" ]
  then
    echo 'ERROR: Missing conda environment name'
    exit 1
fi
read -rsp $'Press enter to continue...\n'

# export cond env downstream
source /home/mauricio/miniconda3/etc/profile.d/conda.sh
conda update --yes conda
conda activate $1

# Spacy data and models
pip install spacy-lookups-data
python -m spacy download en_core_web_sm
python -m spacy download xx_ent_wiki_sm
python -m spacy download pt_core_news_sm
python -m spacy download en_core_web_trf
python -m spacy download xx_sent_ud_sm
python -m spacy download pt_core_news_lg

