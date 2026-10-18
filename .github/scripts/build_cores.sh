#!/usr/bin/env bash
set -e

CORES_DIR="/root/workspace/static/build/RetroArch/.retroarch/cores"
BUILD_DIR="/tmp/core_builds"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

export CC="arm-linux-gnueabihf-gcc"
export CXX="arm-linux-gnueabihf-g++"
export AR="arm-linux-gnueabihf-ar"
export STRIP="arm-linux-gnueabihf-strip"

echo "=========================================="
echo " Building Updated Cores for Miyoo Mini"
echo " Toolchain: Cortex-A7 (NEON-VFPv4 / HardFloat)"
echo "=========================================="

# 1. Fake-08 (PICO-8)
echo ">>> Building Fake-08 (Pico-8)..."
rm -rf fake-08
git clone --depth 1 https://github.com/jtothebell/fake-08.git
cd fake-08/platform/libretro
make platform=miyoomini -j$(nproc)
$STRIP fake08_libretro_miyoomini.so || true
cp fake08_libretro_miyoomini.so "$CORES_DIR/fake08_libretro.so"
cd "$BUILD_DIR"

# 2. PCSX ReARMed (PlayStation 1)
echo ">>> Building PCSX ReARMed (PS1)..."
rm -rf pcsx_rearmed
git clone --depth 1 https://github.com/libretro/pcsx_rearmed.git
cd pcsx_rearmed
make -f Makefile.libretro platform=classic_armv7_a7 -j$(nproc)
$STRIP pcsx_rearmed_libretro.so || true
cp pcsx_rearmed_libretro.so "$CORES_DIR/pcsx_rearmed_libretro.so"
cd "$BUILD_DIR"

# 3. Gambatte (Game Boy / Game Boy Color)
echo ">>> Building Gambatte (GB/GBC)..."
rm -rf gambatte-libretro
git clone --depth 1 https://github.com/libretro/gambatte-libretro.git
cd gambatte-libretro
make -f Makefile.libretro platform=classic_armv7_a7 -j$(nproc)
$STRIP gambatte_libretro.so || true
cp gambatte_libretro.so "$CORES_DIR/gambatte_libretro.so"
cd "$BUILD_DIR"

# 4. Picodrive (Genesis / Mega Drive / Master System / Game Gear / Sega CD)
echo ">>> Building Picodrive (Genesis/MD)..."
rm -rf picodrive
git clone --depth 1 https://github.com/libretro/picodrive.git
cd picodrive
git submodule update --init --recursive || true
make -f Makefile.libretro platform=classic_armv7_a7 -j$(nproc)
$STRIP picodrive_libretro.so || true
cp picodrive_libretro.so "$CORES_DIR/picodrive_libretro.so"
cd "$BUILD_DIR"

# 5. FCEUmm (NES / Famicom)
echo ">>> Building FCEUmm (NES)..."
rm -rf libretro-fceumm
git clone --depth 1 https://github.com/libretro/libretro-fceumm.git
cd libretro-fceumm
make -f Makefile.libretro platform=classic_armv7_a7 -j$(nproc)
$STRIP fceumm_libretro.so || true
cp fceumm_libretro.so "$CORES_DIR/fceumm_libretro.so"
cd "$BUILD_DIR"

# 6. Snes9x 2005 Plus (SNES - Full Speed)
echo ">>> Building Snes9x 2005 Plus (SNES)..."
rm -rf snes9x2005
git clone --depth 1 https://github.com/libretro/snes9x2005.git
cd snes9x2005
make platform=classic_armv7_a7 USE_BLARGG_APU=1 -j$(nproc)
$STRIP snes9x2005_plus_libretro.so || true
cp snes9x2005_plus_libretro.so "$CORES_DIR/snes9x2005_plus_libretro.so"
cd "$BUILD_DIR"

echo "=========================================="
echo " All updated cores built successfully!"
echo " Output files in $CORES_DIR:"
ls -lh "$CORES_DIR"/*_libretro.so | grep -E "fake08|pcsx_rearmed|gambatte|picodrive|fceumm|snes9x2005_plus"
echo "=========================================="
