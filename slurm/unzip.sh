#!/bin/bash

if [ ! -d '/local_datasets/Replica_Dataset' ]; then
    unzip '/data/dataset/zipfiles/Semantic_NeRF(ICCV2021).zip' -d /local_datasets
    find /local_datasets/Replica_Dataset -name '*.zip' | while read -r line; do
        unzip "$line" -d "$(dirname "$line")"
    done
fi
