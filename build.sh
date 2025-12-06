#!/usr/bin/env bash
# CI-friendly build wrapper for Buildroot
set -euo pipefail

# Where your external overlay lives relative to repo root
export BR2_EXTERNAL="$(pwd)/base_external"
echo "build.sh: using BR2_EXTERNAL=$BR2_EXTERNAL"

# Build log
LOG="$(pwd)/build.sh.out"
: > "$LOG"

# number of build threads
NPROCS=$(nproc || echo 1)

cd buildroot

# 1) Make sure we have a .config. Use olddefconfig so any NEW Kconfig options are
# accepted with their defaults (non-interactive). This prevents the menu prompt you saw.
if [ ! -f .config ]; then
  echo "No buildroot .config found — attempting to generate from defconfig..." | tee -a "$LOG"
  # If your repo contains a defconfig (e.g. configs/your_defconfig), replace 'defconfig' below.
  # Otherwise olddefconfig will try to use defaults.
  make BR2_EXTERNAL="$BR2_EXTERNAL" olddefconfig &>> "$LOG" || true
else
  echo "Existing .config found — running olddefconfig to accept new defaults (non-interactive)" | tee -a "$LOG"
  make BR2_EXTERNAL="$BR2_EXTERNAL" olddefconfig &>> "$LOG" || true
fi

# 2) Build (non-interactive). Capture output to build.sh.out for CI debugging
echo "Starting build: make -j$NPROCS" | tee -a "$LOG"
time make BR2_EXTERNAL="$BR2_EXTERNAL" -j"$NPROCS" O=output &>> "$LOG" || {
  echo "Build failed — tail of log:" | tee -a "$LOG"
  tail -n 200 "$LOG" | sed -n '1,200p'
  exit 1
}

# 3) Ensure images exist and copy artifacts for autograder
cd ..

BUILDROOT_OUT="$(pwd)/buildroot/output/images"
AUTOGRADER_DIR="/tmp/aesd-autograder"

mkdir -p "$AUTOGRADER_DIR"
echo "Copying artifacts to $AUTOGRADER_DIR" | tee -a "$LOG"

# Copy Image and rootfs files (if present)
if [ -f "$BUILDROOT_OUT/Image" ]; then
  cp -v "$BUILDROOT_OUT/Image" "$AUTOGRADER_DIR/" | tee -a "$LOG"
else
  echo "WARNING: Image not found at $BUILDROOT_OUT/Image" | tee -a "$LOG"
fi

# Prefer ext4 if available, else ext2 else tar
if [ -f "$BUILDROOT_OUT/rootfs.ext4" ]; then
  cp -v "$BUILDROOT_OUT/rootfs.ext4" "$AUTOGRADER_DIR/" | tee -a "$LOG"
elif [ -f "$BUILDROOT_OUT/rootfs.ext2" ]; then
  cp -v "$BUILDROOT_OUT/rootfs.ext2" "$AUTOGRADER_DIR/" | tee -a "$LOG"
elif [ -f "$BUILDROOT_OUT/rootfs.tar" ]; then
  cp -v "$BUILDROOT_OUT/rootfs.tar" "$AUTOGRADER_DIR/" | tee -a "$LOG"
else
  echo "ERROR: no rootfs image found in $BUILDROOT_OUT" | tee -a "$LOG"
  tail -n 200 "$LOG"
  exit 1
fi

# Make a small summary that CI log can use to detect success
echo "=== BUILD SUMMARY ===" | tee -a "$LOG"
ls -lh "$BUILDROOT_OUT" | tee -a "$LOG"
echo "Artifacts copied to $AUTOGRADER_DIR" | tee -a "$LOG"
echo "Build completed successfully." | tee -a "$LOG"
