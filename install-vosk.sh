#!/bin/bash

echo '************'
echo 'install vosk'
echo '************'
  then
    echo 'ERROR: Missing conda environment name'
    exit 1
fi
read -rsp $'Press enter to continue...\n'

# export cond env downstream
source /home/mauricio/miniconda3/etc/profile.d/conda.sh
conda update --yes conda
conda activate $1

# vosk
pip install vosk

# download and unzip models
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip -P /data/asr/models/vosk/
wget https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip -P /data/asr/models/vosk/
wget https://alphacephei.com/vosk/models/vosk-model-en-us-0.22-lgraph.zip -P /data/asr/models/vosk/
wget https://alphacephei.com/vosk/models/vosk-model-small-pt-0.3.zip -P /data/asr/models/vosk/
wget https://alphacephei.com/vosk/models/vosk-model-pt-fb-v0.1.1-20220516_2113.zip -P /data/asr/models/vosk/
unzip /data/asr/models/vosk/vosk-model-small-en-us-0.15.zip -d /data/asr/models/vosk/
unzip /data/asr/models/vosk/vosk-model-en-us-0.22.zip -d /data/asr/models/vosk/
unzip /data/asr/models/vosk/vosk-model-en-us-0.22-lgraph.zip -d /data/asr/models/vosk/
unzip /data/asr/models/vosk/vosk-model-small-pt-0.3.zip -d /data/asr/models/vosk/
unzip /data/asr/models/vosk/vosk-model-pt-fb-v0.1.1-20220516_2113.zip -d /data/asr/models/vosk/
rm /data/asr/models/vosk/*.zip
