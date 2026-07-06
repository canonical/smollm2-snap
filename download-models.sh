#!/bin/bash

set -euo pipefail

# Setup Hugging Face CLI
sudo apt-get -qq update
sudo apt-get -qq install -y pipx
pipx install huggingface_hub

# SmolLM2 135M Q4_K_M GGUF
hf download unsloth/SmolLM2-135M-Instruct-GGUF \
    SmolLM2-135M-Instruct-Q4_K_M.gguf \
    --local-dir components/smollm2-135m-q4-k-m-gguf/

echo "All models downloaded successfully!"
