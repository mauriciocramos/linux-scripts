#!/bin/bash

echo '*******************'
echo 'download vosk models'
echo '*******************'
echo
echo 'WARNING: Previously downloaded models will be deleted.'
echo
read -rsp $'Press enter to continue...\n'

VOSK_DIR=/data/asr/models/vosk/
rm -rf "$VOSK_DIR"
# download and unzip models
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip -P $VOSK_DIR
wget https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip -P $VOSK_DIR
wget https://alphacephei.com/vosk/models/vosk-model-en-us-0.22-lgraph.zip -P $VOSK_DIR
wget https://alphacephei.com/vosk/models/vosk-model-small-pt-0.3.zip -P $VOSK_DIR
wget https://alphacephei.com/vosk/models/vosk-model-pt-fb-v0.1.1-20220516_2113.zip -P $VOSK_DIR
# unzip "$VOSK_DIR"vosk-model-small-en-us-0.15.zip -d "$VOSK_DIR"
# unzip "$VOSK_DIR"vosk-model-en-us-0.22.zip -d "$VOSK_DIR"
# unzip "$VOSK_DIR"vosk-model-en-us-0.22-lgraph.zip -d "$VOSK_DIR"
# unzip "$VOSK_DIR"vosk-model-small-pt-0.3.zip -d "$VOSK_DIR"
# unzip "$VOSK_DIR"vosk-model-pt-fb-v0.1.1-20220516_2113.zip -d "$VOSK_DIR"
unzip "$VOSK_DIR"*.zip -d "$VOSK_DIR"
rm "$VOSK_DIR"*.zip
