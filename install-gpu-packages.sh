#!/usr/bin/env bash

# =============================================================================
# Install graphics drivers for AMD and Intel GPUs on Arch Linux
# URL: https://github.com/e33io/scripts/blob/main/install-gpu-packages.sh
# =============================================================================

set -e

# Detect any VGA/3D/Display devices
gpu_info=$(lspci | grep -Ei 'VGA|3D|Display')

# AMD GPU
if echo "$gpu_info" | grep -i 'amd' > /dev/null; then
    echo "AMD GPU detected – installing drivers..."
    sudo pacman -S --noconfirm --needed mesa vulkan-radeon
fi

# Intel GPU
INTEL_GPU=$(echo "$gpu_info" | grep -i 'intel')
if [[ -n "$INTEL_GPU" ]]; then
    GPU_LOWER="${INTEL_GPU,,}"
    # Newer Intel graphics (HD Graphics, Iris, Xe)
    if [[ "$GPU_LOWER" == *"hd graphics"* ]] ||
       [[ "$GPU_LOWER" == *"iris"* ]] ||
       [[ "$GPU_LOWER" == *"xe"* ]]; then
        echo "Intel HD/Iris/Xe GPU detected – installing drivers..."
        sudo pacman -S --noconfirm --needed intel-media-driver vulkan-intel
    # Older Intel graphics (GMA generations)
    elif [[ "$GPU_LOWER" == *"gma"* ]]; then
        echo "Older Intel GMA GPU detected – installing drivers..."
        sudo pacman -S --noconfirm --needed libva-intel-driver vulkan-intel
    fi
fi
