#!/bin/bash
# Configure equalizer based on environment variables

# EQ Presets for Beovox CX100
declare -A EQ_PRESETS=(
  ["FLAT"]="0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
  ["BALANCED"]="6,4,3,1,0,0,0,-1,0,1,2,3,4,5,3"
  ["AGGRESSIVE"]="10,8,6,4,1,-1,-2,-2,-1,1,3,5,7,8,6"
  ["BASS_HEAVY"]="12,10,8,6,3,0,-1,-2,-1,0,1,2,3,4,3"
  ["VOCAL"]="0,0,1,2,3,4,3,2,3,4,3,2,1,1,0"
)

# Get EQ preset from environment (default: AGGRESSIVE)
EQ_PRESET="${SOUND_EQ_PRESET:-AGGRESSIVE}"

# Get custom EQ if provided (overrides preset)
EQ_CUSTOM="${SOUND_EQ_CUSTOM:-}"

# Get bass/treble boost multipliers (0.0 to 2.0, default 1.0)
BASS_BOOST="${SOUND_EQ_BASS_BOOST:-1.0}"
TREBLE_BOOST="${SOUND_EQ_TREBLE_BOOST:-1.0}"

# Determine final EQ values
if [[ -n "$EQ_CUSTOM" ]]; then
  # Use custom values if provided
  EQ_VALUES="$EQ_CUSTOM"
  echo "Using custom EQ: $EQ_VALUES" >&2
elif [[ -n "${EQ_PRESETS[$EQ_PRESET]}" ]]; then
  # Use preset
  EQ_VALUES="${EQ_PRESETS[$EQ_PRESET]}"
  echo "Using EQ preset: $EQ_PRESET" >&2
  
  # Apply bass/treble multipliers if not default
  if [[ "$BASS_BOOST" != "1.0" ]] || [[ "$TREBLE_BOOST" != "1.0" ]]; then
    echo "Applying bass boost: ${BASS_BOOST}x, treble boost: ${TREBLE_BOOST}x" >&2
    
    # Split into array
    IFS=',' read -ra BANDS <<< "$EQ_VALUES"
    
    # Apply multipliers to bass (first 5 bands) and treble (last 5 bands)
    for i in {0..4}; do
      BANDS[$i]=$(awk "BEGIN {printf \"%.0f\", ${BANDS[$i]} * $BASS_BOOST}")
    done
    for i in {10..14}; do
      BANDS[$i]=$(awk "BEGIN {printf \"%.0f\", ${BANDS[$i]} * $TREBLE_BOOST}")
    done
    
    # Rejoin
    EQ_VALUES=$(IFS=','; echo "${BANDS[*]}")
    echo "Final EQ after multipliers: $EQ_VALUES" >&2
  fi
else
  # Unknown preset, use AGGRESSIVE as fallback
  EQ_VALUES="${EQ_PRESETS[AGGRESSIVE]}"
  echo "Unknown preset '$EQ_PRESET', using AGGRESSIVE" >&2
fi

# Output the EQ configuration line for PulseAudio (to stdout)
echo "load-module module-ladspa-sink sink_name=balena-sound.equalizer sink_master=balena-sound.input plugin=mbeq_1197 label=mbeq control=$EQ_VALUES"

