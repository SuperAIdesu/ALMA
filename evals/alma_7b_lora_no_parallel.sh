SUFFIX=$1
OUTPUT_DIR=${2:-"./outputs-alma-7b-lora-canto/"}
TEST_PAIRS=${3:-"zh-yue,yue-zh"}
export HF_DATASETS_CACHE=".cache/huggingface_cache/datasets"
export TRANSFORMERS_CACHE=".cache/models/"
# random port between 30000 and 50000
port=$(( RANDOM % (50000 - 30000 + 1 ) + 30000 ))

python \
    run_llmmt.py \
    --model_name_or_path indiejoseph/cantonese-llama-2-7b-oasst-v1 \
    --do_predict \
    --low_cpu_mem_usage \
    --language_pairs ${TEST_PAIRS} \
    --suffix ${SUFFIX} \
    --mmt_data_path ../data/ \
    --per_device_eval_batch_size 3 \
    --output_dir ${OUTPUT_DIR} \
    --use_peft \
    --peft_model_id  ./alma-7b-parallel-ft-lora-canto \
    --predict_with_generate \
    --max_new_tokens 256 \
    --max_source_length 256 \
    --fp16 \
    --seed 42 \
    --num_beams 5 \
    --overwrite_cache \
    --overwrite_output_dir \
    --multi_gpu_one_model

# if [[ ${TEST_PAIRS} == *zh-en* ]]; then
# python \
#     run_llmmt.py \
#     --model_name_or_path haoranxu/ALMA-7B-Pretrain \
#     --do_predict \
#     --low_cpu_mem_usage \
#     --language_pairs zh-en \
#     --mmt_data_path ./human_written_data/ \
#     --per_device_eval_batch_size 2 \
#     --output_dir ${OUTPUT_DIR} \
#     --use_peft \
#     --peft_model_id  haoranxu/ALMA-7B-Pretrain-LoRA \
#     --predict_with_generate \
#     --max_new_tokens 256 \
#     --max_source_length 512 \
#     --fp16 \
#     --seed 42 \
#     --num_beams 5 \
#     --overwrite_cache \
#     --overwrite_output_dir \
#     --multi_gpu_one_model

# fi

## Evaluation (BLEU, COMET)
# bash ./evals/eval_generation.sh ${OUTPUT_DIR} ${TEST_PAIRS}