python -m mlx_lm.lora \
    --model mistralai/Mistral-7B-Instruct-v0.2 \
    --train \
    --data ./training-data \
    --adapter-path ./adapter \
    --iters 200
