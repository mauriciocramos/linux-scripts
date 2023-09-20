#!/bin/bash
echo '****************************'
echo 'install NLTK data and models'
echo '****************************'

if [ -z "$1" ]
  then
    echo 'ERROR: Missing conda environment name'
    exit 1
fi
read -rsp $'Press enter to continue...\n'

# export cond env downstream
source "$HOME"/miniconda3/etc/profile.d/conda.sh
conda update -y -n base conda
conda activate $1

# NLTK data and models
# python -m nltk.downloader -d /data/nltk_data all
# python -c 'import nltk; nltk.download('all', download_dir='/data/nltk_data')'
# python -m nltk.downloader -d /data/nltk_data punkt stopwords vader_lexicon averaged_perceptron_tagger maxent_ne_chunker words tagsets
# TODO: leia para SE PT
# python -c 'import nltk; nltk.download(["punkt", "stopwords", "vader_lexicon", "averaged_perceptron_tagger", "maxent_ne_chunker", "words", "tagsets", "wordnet", "omw-1.4"], download_dir="/data/nltk_data")'
python -m nltk.downloader -d $NLTK_DATA all
