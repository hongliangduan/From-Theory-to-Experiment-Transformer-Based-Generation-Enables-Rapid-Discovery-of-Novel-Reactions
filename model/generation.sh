#!/usr/bin/env bash

#!/bin/bash

# Data
DATA_ROOT=../data/reaction/

# Model
DIV_VAL=1
N_LAYER=12
D_MODEL=512
D_EMBED=512
N_HEAD=8
D_HEAD=64
D_INNER=2048


# Training
TGT_LEN=64
MEM_LEN=64
#WARM_START = ckpt_path/model-165900
#WARM_START = None


BSZ=64
NUM_CORE=4

# Testing
TEST_TGT_LEN=50
TEST_MEM_LEN=100
TEST_CLAMP_LEN=400

TEST_BSZ=1
TEST_NUM_CORE=1

if [[ $1 == 'train_data' ]]; then
    python data_utils.py \
        --data_dir=${DATA_ROOT}/ \
        --dataset=molecular \
        --tgt_len=${TGT_LEN} \
        --per_host_train_bsz=${BSZ} \
        --per_host_valid_bsz=${BSZ} \
        --num_passes=1 \
        --use_tpu=False \
        ${@:2}
elif [[ $1 == 'test_data' ]]; then
    python data_utils_chinese.py \
        --data_dir=${DATA_ROOT}/ \
        --dataset=molecular \
        --tgt_len=${TEST_TGT_LEN} \
        --per_host_test_bsz=${TEST_BSZ} \
        --num_passes=1 \
        --use_tpu=False \
        ${@:2}
elif [[ $1 == 'train' ]]; then
    echo 'Run training...'
 CUDA_VISIBLE_DEVICES='0'   python train_gpu.py \
        --data_dir=${DATA_ROOT}/tfrecords \
        --record_info_dir=${DATA_ROOT}/tfrecords/ \
        --corpus_info_path=${DATA_ROOT}/corpus-info.json \
        --model_dir=ckpt_path \
        --div_val=${DIV_VAL} \
        --untie_r=True \
        --proj_share_all_but_first=True \
        --n_layer=${N_LAYER} \
        --d_model=${D_MODEL} \
        --d_embed=${D_EMBED} \
        --n_head=${N_HEAD} \
        --d_head=${D_HEAD} \
        --d_inner=${D_INNER} \
        --dropout=0.1 \
        --dropatt=0.0 \
        --learning_rate=0.0001 \
        --warmup_steps=0 \
        --train_steps=4500000 \
        --tgt_len=${TGT_LEN} \
        --mem_len=${MEM_LEN} \
        --train_batch_size=${BSZ} \
        --num_core_per_host=${NUM_CORE} \
        --iterations=200 \
        --save_steps=100 \
        ${@:2}
elif [[ $1 == 'inference' ]]; then
    echo 'Run inference...'
 CUDA_VISIBLE_DEVICES='0'   python train_gpu.py \
        --data_dir=${DATA_ROOT}/tfrecords \
        --record_info_dir=${DATA_ROOT}/tfrecords/ \
        --corpus_info_path=${DATA_ROOT}/corpus-info.json \
        --model_dir=ckpt_path  \
        --div_val=${DIV_VAL} \
        --untie_r=True \
        --proj_share_all_but_first=True \
        --n_layer=${N_LAYER} \
        --d_model=${D_MODEL} \
        --d_embed=${D_EMBED} \
        --n_head=${N_HEAD} \
        --d_head=${D_HEAD} \
        --d_inner=${D_INNER} \
        --dropout=0.0 \
        --dropatt=0.0 \
        --tgt_len=${TEST_TGT_LEN} \
        --mem_len=${TEST_MEM_LEN} \
        --clamp_len=${TEST_CLAMP_LEN} \
        --same_length=True \
        --eval_batch_size=${TEST_BSZ} \
        --num_core_per_host=${TEST_NUM_CORE} \
        --do_train=False \
        --do_inference=True \
        --eval_split=test \
        --generated_txt=Chanlam_reaction_without_pretrain_210000_wyj_7.8 \
        --eval_ckpt_path=ckpt_path/model-210000.ckpt \
        ${@:2}

else
    echo 'unknown argment 1'
fi