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
conda deactivate
conda update -y -n base conda
conda activate $1

# Spacy data and models from https://spacy.io/models/en

pip install spacy-lookups-data

# English pipeline optimized for CPU. Components: tok2vec, tagger, parser, senter, ner, attribute_ruler, lemmatizer.
python -m spacy download en_core_web_sm # no static word vectors
# English pipeline optimized for CPU. Components: tok2vec, tagger, parser, senter, ner, attribute_ruler, lemmatizer.
python -m spacy download en_core_web_md # word vectors: 514k keys, 20k unique vectors (300 dimensions)
# English pipeline optimized for CPU. Components: tok2vec, tagger, parser, senter, ner, attribute_ruler, lemmatizer.
python -m spacy download en_core_web_lg # word vectors: 514k keys, 514k unique vectors (300 dimensions)
# English transformer pipeline (roberta-base). Components: transformer, tagger, parser, ner, attribute_ruler, lemmatizer.
python -m spacy download en_core_web_trf # no static word vectors

# Portuguese pipeline optimized for CPU. Components: tok2vec, morphologizer, parser, lemmatizer (trainable_lemmatizer), senter, ner, attribute_ruler.
python -m spacy download pt_core_news_sm # no static word vectors
# Portuguese pipeline optimized for CPU. Components: tok2vec, morphologizer, parser, lemmatizer (trainable_lemmatizer), senter, ner, attribute_ruler.
python -m spacy download pt_core_news_md # word vectors: 500k keys, 20k unique vectors (300 dimensions)
# Portuguese pipeline optimized for CPU. Components: tok2vec, morphologizer, parser, lemmatizer (trainable_lemmatizer), senter, ner, attribute_ruler.
python -m spacy download pt_core_news_lg # word vectors: 500k keys, 500k unique vectors (300 dimensions)

# Multi-language pipeline optimized for CPU. Components: ner.
python -m spacy download xx_ent_wiki_sm # no word vectors
# Multi-language pipeline optimized for CPU. Components: senter.
python -m spacy download xx_sent_ud_sm # no word vectors

# verify installation
python -m spacy validate

