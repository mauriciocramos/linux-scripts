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

source "$HOME"/miniconda3/etc/profile.d/conda.sh # required to use conda within a script
conda deactivate
conda activate $1

pip install spacy-lookups-data

# ENGLISH MODELS

# English pipeline optimized for CPU. Components: tok2vec, tagger, parser, senter, ner, attribute_ruler, lemmatizer.
# vectors: 0 keys, 0 unique vectors (0 dimensions)
python -m spacy download en_core_web_sm

# English pipeline optimized for CPU. Components: tok2vec, tagger, parser, senter, ner, attribute_ruler, lemmatizer.
#  vectors: 685k keys, 20k unique vectors (300 dimensions)
python -m spacy download en_core_web_md

# English pipeline optimized for CPU. Components: tok2vec, tagger, parser, senter, ner, attribute_ruler, lemmatizer.
# vectors: 685k keys, 343k unique vectors (300 dimensions)
python -m spacy download en_core_web_lg

# English transformer pipeline (Transformer(name=‘roberta-base’, piece_encoder=‘byte-bpe’, stride=104, type=‘roberta’,
# width=768, window=144, vocab_size=50265)). Components: transformer, tagger, parser, ner, attribute_ruler, lemmatizer.
# vectors: 0 keys, 0 unique vectors (0 dimensions)
python -m spacy download en_core_web_trf

# PORTUGUESE MODELS

# Portuguese pipeline optimized for CPU. Components: tok2vec, morphologizer, parser, lemmatizer (trainable_lemmatizer),
# senter, ner, attribute_ruler.
# vectors: 0 keys, 0 unique vectors (0 dimensions)
python -m spacy download pt_core_news_sm

# Portuguese pipeline optimized for CPU. Components: tok2vec, morphologizer, parser, lemmatizer (trainable_lemmatizer),
# senter, ner, attribute_ruler.
# vectors: 500k keys, 20k unique vectors (300 dimensions)
python -m spacy download pt_core_news_md

# Portuguese pipeline optimized for CPU. Components: tok2vec, morphologizer, parser, lemmatizer (trainable_lemmatizer),
# senter, ner, attribute_ruler.
# vectors: 500k keys, 500k unique vectors (300 dimensions)
python -m spacy download pt_core_news_lg

# MULTI-LANGUAGE MODELS

# Multi-language pipeline optimized for CPU. Components: ner.
python -m spacy download xx_ent_wiki_sm

# Multi-language pipeline optimized for CPU. Components: senter.
python -m spacy download xx_sent_ud_sm

# verify installation
python -m spacy validate

