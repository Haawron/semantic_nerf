#!/bin/bash

#SBATCH -J sparse
#SBATCH -p batch
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-gpu=4
#SBATCH --mem-per-gpu=10G
#SBATCH -t 1-0
#SBATCH -x agi2,augi2,vll[2-4]
#SBATCH --array 0-1%2
#SBATCH -o slurm/logs/slurm-%A_%a-%x.out

current_time=$(date +'%Y%m%d-%H%M%S')

# shellcheck source=../unzip.sh
source slurm/unzip.sh

dataset='replica'
scene='room_0'
sequence='Sequence_1'
task='020_sparse'  # 010_full, 020_sparse, 030_partial, 040_sparse_partial
workdir="work_dirs/${dataset}/${scene}/${sequence}/${task}"
workdir="${workdir}/${SLURM_ARRAY_JOB_ID}__${SLURM_JOB_NAME}/${SLURM_ARRAY_TASK_ID}/${current_time}"
config=$(python slurm/edit_yaml.py --options experiment.save_dir="$workdir" --jid "$SLURM_ARRAY_JOB_ID")

# Semantic View Synthesis with Sparse Labels (frame droprate)
python train_SSR_main.py --config_file "$config" --sparse_views --sparse_ratio 0.6 --visualise_save
exit 0
