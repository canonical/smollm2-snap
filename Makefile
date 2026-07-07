SHELL := /bin/bash

# Use a locally installed `hf` CLI if available; otherwise fall back to pipx.
hf := $(shell command -v hf 2>/dev/null || echo 'pipx run --spec "huggingface_hub[cli]" hf')

SNAP_NAME ?= smollm2
ENGINE ?= cpu

.PHONY: help all prepare download-models download-model-135m build install upload smoke-test

all: help

help: ## Show this help message
	@echo "Usage: make <target>"
	@echo
	@echo "Targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

prepare: ## Init submodules and ensure the hf CLI is available
	git submodule update --init
	
	@# If hf is not installed locally, ensure pipx is available for the fallback.
	@command -v hf >/dev/null 2>&1 || command -v pipx >/dev/null 2>&1 || { \
		sudo apt-get update; \
		sudo apt-get install -y pipx; \
	}

download-models: download-model-135m ## Download all models
	
download-model-135m: ## Download SmolLM2 135M Q4_K_M GGUF
	$(hf) download unsloth/SmolLM2-135M-Instruct-GGUF \
    	SmolLM2-135M-Instruct-Q4_K_M.gguf \
    	--local-dir components/smollm2-135m-q4-k-m-gguf/

build: ## Build the snap
	./dev/build.sh

install: ## Install the snap
	./dev/install.sh

upload: ## Upload the snap
	./dev/upload.sh

smoke-test: ## Run smoke tests (override with SNAP_NAME=... ENGINE=...)
	sudo ./dev/smoke-test.sh $(SNAP_NAME) $(ENGINE)
