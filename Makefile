SHELL := /bin/bash

# Always run `hf` via pipx to avoid relying on local `hf` installations.
hf := pipx run --spec "huggingface_hub[cli]" hf

SNAP_NAME ?= smollm2
ENGINE ?= cpu

.PHONY: help all init init-submodules install-deps download-models download-model-135m download-model-360m download-model-1.7b download-model-360m-ov download-model-1.7b-ov build install upload smoke-test

all: help

#
# Main targets
#

help: ## Show this help message
	@echo "Usage: make <target>"
	@echo
	@echo "Targets:"
	@# List all targets with descriptions (lines starting with '##'):
	@grep -E '^[a-zA-Z0-9_-]+:.*## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  %-11s %s\n", $$1, $$2}'

init: init-submodules install-deps download-models ## Initialize the build environment (dependencies, model weights, submodules, etc.)

build: ## Build the snap
	./dev/build.sh

install: ## Install the snap
	./dev/install.sh

upload: ## Upload the snap
	./dev/upload.sh

smoke-test: ## Run smoke tests (override with SNAP_NAME=... ENGINE=...)
	sudo ./dev/smoke-test.sh $(SNAP_NAME) $(ENGINE)

#
# Supporting targets
#

install-deps:
	@echo "Installing dependencies..."
	@# Ensure pipx is available for running the hf CLI.
	@command -v pipx >/dev/null 2>&1 || { \
		sudo apt-get update; \
		sudo apt-get install -y pipx; \
	}

init-submodules:
	@echo "Initializing submodules..."
	@if git submodule status | grep -q '^-'; then \
		git submodule update --init; \
	fi

download-models: download-model-135m download-model-360m download-model-1.7b download-model-360m-ov download-model-1.7b-ov
	
download-model-135m:
	@echo "Downloading SmolLM2-135M-Instruct-GGUF model weights..."
	$(hf) download unsloth/SmolLM2-135M-Instruct-GGUF \
		SmolLM2-135M-Instruct-Q4_K_M.gguf \
		--local-dir model-weights/smollm2-135m-q4-k-m-gguf/

download-model-360m:
	@echo "Downloading SmolLM2-360M-Instruct-GGUF model weights..."
	$(hf) download unsloth/SmolLM2-360M-Instruct-GGUF \
		SmolLM2-360M-Instruct-Q4_K_M.gguf \
		--revision 391ed11137586e383b1be0fab9acf01d282c2e11 \
		--local-dir model-weights/smollm2-360m-q4-k-m-gguf/

download-model-1.7b:
	@echo "Downloading SmolLM2-1.7B-Instruct-GGUF model weights..."
	$(hf) download unsloth/SmolLM2-1.7B-Instruct-GGUF \
		SmolLM2-1.7B-Instruct-Q4_K_M.gguf \
		--revision e933f1cdf73cc87cb67915bf5dd6ea81d36080ca \
		--local-dir model-weights/smollm2-1-7b-q4-k-m-gguf/

download-model-360m-ov:
	@echo "Downloading SmolLM2-360M-Instruct OpenVINO INT8 model weights..."
	$(hf) download AIFunOver/SmolLM2-360M-Instruct-openvino-8bit \
		--revision 4d5c9cbb82354e2f0929283ac5fa187761f43332 \
		--local-dir model-weights/smollm2-360m-int8-ov/
	@echo "OVMS writes graph.pbtxt at runtime; pointing it to /tmp because component files are read-only..."
	ln -sf /tmp/smollm2-360m-int8-ov-graph.pbtxt model-weights/smollm2-360m-int8-ov/graph.pbtxt

download-model-1.7b-ov:
	@echo "Downloading SmolLM2-1.7B-Instruct OpenVINO INT8 model weights..."
	$(hf) download AIFunOver/SmolLM2-1.7B-Instruct-openvino-8bit \
		--revision 713d8867320008c7bdb8b2c32f0053b6c970bfb1 \
		--local-dir model-weights/smollm2-1-7b-int8-ov/
	@echo "OVMS writes graph.pbtxt at runtime; pointing it to /tmp because component files are read-only..."
	ln -sf /tmp/smollm2-1-7b-int8-ov-graph.pbtxt model-weights/smollm2-1-7b-int8-ov/graph.pbtxt
