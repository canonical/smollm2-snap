<!--
# This is the name of the snap. The name that is registered on the snap store and also the name of the cli command.
snap-name: smollm2
# This name is just a friendly name for the snap, it can be used in the documentation
snap-friendly-name: SmolLM2
# URL to model card from the model publisher
model-card: https://huggingface.co/collections/HuggingFaceTB/smollm2
# The port that the inference snap will use for its API server.
http-port: 8344
# The port that the inference snap will use for its webui server.
webui-http-port: 8345
# Optimizations
engines: cpu, nvidia-gpu
-->

# SmolLM2 inference snap
[![smollm2](https://snapcraft.io/smollm2/badge.svg)](https://snapcraft.io/smollm2)

SmolLM2 is a compact large language model (LLM) developed by Hugging Face, designed for efficient natural language tasks such as text generation, summarization, and question answering.

Use this snap to quickly install an optimized environment for local inference with SmolLM2.

The snap includes the following hardware-optimized inference engines:

* cpu: Optimized for x64 and ARM (armv8, armv9) CPUs
* nvidia-gpu: CUDA-enabled GPU acceleration

The most suitable engine is automatically selected based on the available hardware.

#### Install
```
sudo snap install smollm2
```

#### Run
```
smollm2
```

> [!TIP]
> Some accelerators require extra [drivers](https://documentation.ubuntu.com/inference-snaps/how-to/setup/drivers/) to be usable with this snap.

## Resources

📚 **[Documentation](https://documentation.ubuntu.com/inference-snaps/)**, learn how to use inference snaps

💬 **[Discussions](https://github.com/canonical/inference-snaps/discussions)**, ask questions and share ideas

🐛 **[Issues](https://github.com/canonical/inference-snaps/issues)**, report bugs and request features

## Build and install from source

Clone the repo:
```shell
git clone https://github.com/canonical/smollm2-snap
cd smollm2-snap
```

Initialize the development environment:
```shell
make init
```

Build and install snap:
```shell
make build
make install
```
