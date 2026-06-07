#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# 1. ENVIRONMENT VARIABLES & CONSTANTS
# ==============================================================================
# Define the read-only system backup paths and target user-space paths
readonly SYSTEM_SHARE="/usr/share/hypr-wall-theme"
readonly USER_MATUGEN="$HOME/.config/matugen"
readonly CACHE_DIR="$HOME/.cache/hypr-wall-theme"

# ==============================================================================
# 2. THE MATUGEN BOOTSTRAP PHASE
# ==============================================================================
# This logic guarantees your theme environment exists before doing any work
initialize_theme() {
  # If the main configuration file already exists, skip to protect user modifications
  if [[ -f "$USER_MATUGEN/config.toml" ]]; then
    return 0
  fi

  echo ":: Deploying custom Matugen theme templates..."

  # Ensure target directory trees exist in the user's home directory
  mkdir -p "$USER_MATUGEN/templates"
  mkdir -p "$CACHE_DIR"

  # Verify system-wide files exist, then copy your theme into place
  if [[ -d "$SYSTEM_SHARE" ]]; then
    cp "$SYSTEM_SHARE/config.toml" "$USER_MATUGEN/config.toml"
    cp -r "$SYSTEM_SHARE/templates/." "$USER_MATUGEN/templates/"
    echo ":: Theme successfully deployed to $USER_MATUGEN"
  else
    echo "Error: Core theme assets not found in $SYSTEM_SHARE." >&2
    exit 1
  fi
}

# Run the initialization check immediately
initialize_theme

# ==============================================================================
# 3. SWWW (NOW AWWW) DAEMON LIFECYCLE MANAGEMENT
# ==============================================================================
# Ensure awww-daemon is running. If it isn't, spawn it automatically.
if ! pgrep -x "awww-daemon" >/dev/null; then
  echo ":: awww-daemon is inactive. Starting wallpaper engine..."
  awww-daemon --format xrgb &

  # Block the script until the daemon's socket is fully responsive
  while ! awww query &>/dev/null; do
    sleep 0.1
  done
fi

# ==============================================================================
# 4. PREPARING FOR WORKLOAD (THE NEXT STEP)
# ==============================================================================


WALLPAPER_DIR="$HOME/Pictures/wallpapers"
input_path="${1:-}"

convert_to_gif() {
  local input_file="$1"
  local output_file="$2"
  if ffmpeg -i "$input_file" -vf "fps=15,scale=1920:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$output_file"; then
    echo "Conversion done! Check $output_file for results"
    awww img "$output_file" && matugen image "$output_file"
  else
    echo "Conversion failed. Make sure you're using the right input path"
    exit 1
  fi
}

set_wallpaper() {
  if [ -f "$input_path" ]; then
    awww img "$input_path" && matugen image "$input_path"
    echo "Wallpaper changed to $input_path"
  elif [ -f "$WALLPAPER_DIR/$input_path" ]; then
    awww img "$WALLPAPER_DIR/$input_path" && matugen image "$WALLPAPER_DIR/$input_path"
    echo "Wallpaper changed to $input_path"
  else
    echo "Error: Check paths and make sure wallpaper is in (.jpg, .png, .gif)"
  fi
}

check_file_type() {
  mime=$(file --mime-type -b "$input_path")
  if [[ "$mime" =~ image/(png|jpeg|gif) ]]; then
    set_wallpaper "$input_path"
  else
    local output_path="${input_path%.*}.gif"
    convert_to_gif "$input_path" "$output_path"
  fi
}

if [ -z "$input_path" ]; then
  echo "Error: Please provide a file path."
  echo "Usage: $0 /path/to/file.png"
  exit 1
fi

check_file_type

