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
source "$HOME"/miniconda3/etc/profile.d/conda.sh

conda deactivate
# conda update -y -n base conda # uneeded
conda activate $1

# Spacy data and models from https://spacy.io/models/en

pip install spacy-lookups-data

# efficiency
python -m spacy download en_core_web_sm
python -m spacy download xx_ent_wiki_sm
python -m spacy download pt_core_news_sm

# accuracy
python -m spacy download en_core_web_trf
python -m spacy download xx_sent_ud_sm
python -m spacy download pt_core_news_lg

# verify installation
python -m spacy validate

