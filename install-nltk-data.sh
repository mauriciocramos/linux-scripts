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
source /home/mauricio/miniconda3/etc/profile.d/conda.sh
conda update --yes conda
conda activate $1

# NLTK data and models
# python -m nltk.downloader -d /data/nltk_data all
# python -c 'import nltk; nltk.download('all', download_dir='/data/nltk_data')'
# python -m nltk.downloader -d /data/nltk_data punkt stopwords vader_lexicon averaged_perceptron_tagger maxent_ne_chunker words tagsets
python -c 'import nltk; nltk.download(["punkt", "stopwords", "vader_lexicon", "averaged_perceptron_tagger", "maxent_ne_chunker", "words", "tagsets"], download_dir="/data/nltk_data")'
