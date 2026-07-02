SHELL := /bin/bash

.PHONY: download-models download-model-8b download-model-20b setup-hf-cli

all: download-models

download-models: download-model-8b

setup-hf-cli:
	sudo apt-get update
	sudo apt-get install -y pipx
	pipx install huggingface_hub

download-model-8b:
	wget <...>

download-20b-model: setup-hf-cli
	. .venv/bin/activate && hf download <...> --local-dir components/mymodel-20b
