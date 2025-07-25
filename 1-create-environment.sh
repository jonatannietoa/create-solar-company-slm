python -m venv .venv
source .venv/bin/activate
pip install mlx-lm
huggingface-cli login
huggingface-cli download mistralai/Mistral-7B-Instruct-v0.2
