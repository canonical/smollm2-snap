# Build placeholder

This directory exists as a snapcraft source placeholder for architectures where
a part has no real source (e.g. `llamacpp-cuda` on `riscv64`). The part's
override-pull/build/stage/prime skip all work on such architectures, so this
directory's contents never end up in the snap - snapcraft just requires every
part to have a resolvable source string.
