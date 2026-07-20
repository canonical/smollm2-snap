SHELL := /bin/bash

# Always run `hf` via pipx to avoid relying on local `hf` installations.
hf := pipx run --spec "huggingface_hub[cli]" hf

SNAP_NAME ?= smollm2
ENGINE ?= cpu

.PHONY: help all prepare download-models download-model-135m build install upload smoke-test

all: help

help: ## Show this help message
	@echo "Usage: make <target>"
	@echo
	@echo "Targets:"
	@# List all targets with descriptions (lines starting with '##'):
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-11s %s\n", $$1, $$2}'

install-deps:
	@echo "Installing dependencies..."
	@# Ensure pipx is available for running the hf CLI.
	@command -v pipx >/dev/null 2>&1 || { \
		sudo apt-get update; \
		sudo apt-get install -y pipx; \
	}

download-models: download-model-135m
	
download-model-135m:
	@echo "Downloading SmolLM2-135M-Instruct-GGUF model weights..."
	$(hf) download unsloth/SmolLM2-135M-Instruct-GGUF \
    	SmolLM2-135M-Instruct-Q4_K_M.gguf \
    	--local-dir components/smollm2-135m-q4-k-m-gguf/

init-submodules:
	@echo "Initializing submodules..."
	@if git submodule status | grep -q '^-'; then \
		git submodule update --init; \
	fi

init: init-submodules install-deps download-models ## Initialize the build environment (dependencies, model weights, submodules, etc.)

build: init ## Build the snap
	./dev/build.sh

install: init ## Install the snap
	./dev/install.sh

upload: init ## Upload the snap
	./dev/upload.sh

smoke-test: init ## Run smoke tests (override with SNAP_NAME=... ENGINE=...)
	sudo ./dev/smoke-test.sh $(SNAP_NAME) $(ENGINE)
