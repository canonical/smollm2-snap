# SmolLM2 snap (change)
[![smollm2](https://snapcraft.io/smollm2/badge.svg)](https://snapcraft.io/smollm2)

Install [SmolLM2](https://huggingface.co/collections/HuggingFaceTB/smollm2), optimized directly for your hardware.
This package deploys a high-performance runtime for local inference across arm and x86 platforms.
It runs efficiently on pure CPU or leverages hardware acceleration via NVIDIA GPUs.

## Resources

📚 **[Documentation](https://documentation.ubuntu.com/inference-snaps/)**, learn how to use inference snaps

💬 **[Discussions](https://github.com/canonical/inference-snaps/discussions)**, ask questions and share ideas

🐛 **[Issues](https://github.com/canonical/inference-snaps/issues)**, report bugs and request features

## Build and install from source

Clone this repo with its submodules:
```shell
git clone --recurse-submodules https://github.com/canonical/smollm-snap
```

Prepare the required models by running `download-models.sh`.

Build the snap and its component:
```shell
snapcraft pack -v
```

Refer to the `./dev` directory for additional development tools.
