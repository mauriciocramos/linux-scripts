#!/bin/bash

echo '*******************'
echo 'install vosk models'
echo '*******************'

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
