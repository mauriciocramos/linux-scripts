#!/bin/bash
VOSK_DIR=/data/asr/models/vosk/
echo '********************'
echo 'download vosk models'
echo '********************'
echo
echo "WARNING: Downloads vosk models from https://alphacephei.com/vosk/models to $VOSK_DIR"
echo ''
echo
read -rsp $'Press enter to continue...\n'

# english models
wget -N https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip -P $VOSK_DIR
wget -N https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip -P $VOSK_DIR
wget -N https://alphacephei.com/vosk/models/vosk-model-en-us-0.22-lgraph.zip -P $VOSK_DIR
wget -N https://alphacephei.com/vosk/models/vosk-model-en-us-0.42-gigaspeech.zip -P $VOSK_DIR
# portuguese mmodels
wget -N https://alphacephei.com/vosk/models/vosk-model-small-pt-0.3.zip -P $VOSK_DIR
wget -N https://alphacephei.com/vosk/models/vosk-model-pt-fb-v0.1.1-20220516_2113.zip -P $VOSK_DIR
# multi-language speaker identification model
wget -N https://alphacephei.com/vosk/models/vosk-model-spk-0.4.zip -P $VOSK_DIR
# english punctuation model
wget -N https://alphacephei.com/vosk/models/vosk-recasepunc-en-0.22.zip -P $VOSK_DIR

# unzip models
unzip -u "$VOSK_DIR"vosk-model-small-en-us-0.15.zip -d "$VOSK_DIR"
unzip -u "$VOSK_DIR"vosk-model-en-us-0.22.zip -d "$VOSK_DIR"
unzip -u "$VOSK_DIR"vosk-model-en-us-0.22-lgraph.zip -d "$VOSK_DIR"
unzip -u "$VOSK_DIR"vosk-model-en-us-0.42-gigaspeech.zip -d "$VOSK_DIR"
unzip -u "$VOSK_DIR"vosk-model-small-pt-0.3.zip -d "$VOSK_DIR"
unzip -u "$VOSK_DIR"vosk-model-pt-fb-v0.1.1-20220516_2113.zip -d "$VOSK_DIR"
unzip -u "$VOSK_DIR"vosk-model-spk-0.4.zip -d "$VOSK_DIR"
unzip -u "$VOSK_DIR"vosk-recasepunc-en-0.22.zip -d "$VOSK_DIR"
