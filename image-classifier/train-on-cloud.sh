#!/usr/bin/env bash

echo "Submitting a Cloud ML Engine job..."

REGION="us-central1"
MODEL_NAME="ImageClassifier" # change to your model name

CURRENT_DATE=`date +%Y%m%d_%H%M%S`
EPOCHS=100
BATCH_SIZE=16

LOSS=categorical_crossentropy

BASE_PATH=gs://bigdata-allanbatista-com-br/image-classifier/20181118_165025/
BUCKET_NAME=bigdata-allanbatista-com-br
TRAIN_PATH=${BASE_PATH}/train/${CURRENT_DATE}/

JOB_NAME=train_${MODEL_NAME}_${CURRENT_DATE}
JOB_DIR=${TRAIN_PATH}job/

gcloud ml-engine jobs submit training ${JOB_NAME} \
        --scale-tier=BASIC \
        --job-dir=${JOB_DIR} \
        --runtime-version=1.10 \
        --region=${REGION} \
        --module-name=image-classifier.train \
        --package-path=image-classifier  \
        -- \
        --bucket-name=${BUCKET_NAME} \
        --epochs=${EPOCHS} \
        --batch-size=${BATCH_SIZE} \
        --current-date=${CURRENT_DATE} \
        --base-path=${BASE_PATH} \
        --loss=${LOSS}

echo "to see training progress"
echo "$ tensorboard --port 8080 --logdir ${TRAIN_PATH}tensorboards/"

# notes:
# use --packages instead of --package-path if gcs location
# add --reuse-job-dir to resume training