# SmolLM2 inference snap
[![smollm2](https://snapcraft.io/smollm2/badge.svg)](https://snapcraft.io/smollm2)

SmolLM2 is a compact large language model (LLM) developed by Hugging Face, designed for efficient natural language tasks such as text generation, summarization, and question answering.

Use this snap to quickly install an optimized environment for local inference with SmolLM2.

The snap includes the following hardware-optimized inference engines:

* cpu: Optimized for x64 and ARM (armv8, armv9) CPUs
* intel-cpu: OpenVINO acceleration for Intel CPUs
* intel-gpu: OpenVINO acceleration for supported Intel GPUs
* nvidia-gpu: CUDA-enabled GPU acceleration

The most suitable engine is automatically selected based on the available hardware.

#### Install
```shell
sudo snap install smollm2
```

#### Run
```shell
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

## RISC-V (riscv64)

The `cpu` engine also targets **riscv64**. The `llamacpp` component on this
architecture is built from llama.cpp with `GGML_CPU_RISCV64_SPACEMIT=ON`
([riscv64+spacemit job](https://github.com/canonical/llama.cpp-builds) in
llama.cpp-builds): a single artifact with runtime hardware dispatch.

- On **SpacemiT boards** (Key Stone K1/K3) running the vendor BSP kernel, the
  engine automatically detects and engages the A100 "AI core" cluster, the IME
  `vmadot` matrix-extension instructions and TCM — no configuration needed
  (look for `CPU_RISCV64_SPACEMIT:` lines in the logs).
- On any other riscv64 system (including SpacemiT boards on mainline kernels),
  the same binary falls back to portable RVV 1.0 kernels.

Runtime requirements: an RVA23-class CPU (`rv64gcv` with
`zba/zfh/zvfh/zicbop/zihintpause`). No separate SpacemiT engine entry is
needed — the binary detects its own silicon at runtime.

Building on a riscv64 host (e.g. a SpacemiT K3 with the vendor OS):

```shell
make init
snapcraft --destructive-mode
sudo snap install ./smollm2_*_riscv64.snap --dangerous
smollm2 status   # engine auto-selection should pick the cpu engine
```

Note: the riscv64 modelctl binary is currently shipped in-tree
(`modelctl-linux-riscv64.tar.xz`) until the inference-snaps CLI publishes
riscv64 release assets.
