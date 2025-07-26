python3.11 -m venv .venv
source .venv/bin/activate
pip install mlx-lm sentencepiece
pip install mistral_inference
huggingface-cli login
huggingface-cli download mistralai/Mistral-7B-Instruct-v0.3
