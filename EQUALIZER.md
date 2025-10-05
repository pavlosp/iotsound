# Equalizer Configuration

Your IoTSound system now includes a 15-band LADSPA equalizer optimized for Beovox CX100 speakers.

## Quick Start (Balena Cloud)

1. Go to your device in Balena Cloud
2. Navigate to **Device Variables** or **Fleet Variables**
3. Add environment variables to control the EQ

## Environment Variables

### Basic Controls

| Variable | Default | Description |
|----------|---------|-------------|
| `SOUND_EQ_ENABLED` | `true` | Enable/disable equalizer (`true` or `false`) |
| `SOUND_EQ_PRESET` | `AGGRESSIVE` | EQ preset name (see below) |

### Fine-Tuning

| Variable | Default | Description |
|----------|---------|-------------|
| `SOUND_EQ_BASS_BOOST` | `1.0` | Bass multiplier (0.0 to 2.0) |
| `SOUND_EQ_TREBLE_BOOST` | `1.0` | Treble multiplier (0.0 to 2.0) |

### Advanced

| Variable | Description |
|----------|-------------|
| `SOUND_EQ_CUSTOM` | Custom 15-band EQ values (comma-separated dB values) |

## EQ Presets

### FLAT
No equalization. Natural sound.
```
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
```

### BALANCED (Gentle)
Subtle bass lift and treble sparkle. Good for most music.
```
+6, +4, +3, +1, 0, 0, 0, -1, 0, +1, +2, +3, +4, +5, +3 dB
```

### AGGRESSIVE (Current Default) ⭐
Deep bass punch + sharp highs. Great for small speakers and electronic music.
```
+10, +8, +6, +4, +1, -1, -2, -2, -1, +1, +3, +5, +7, +8, +6 dB
```

### BASS_HEAVY
Maximum bass emphasis. For bassheads.
```
+12, +10, +8, +6, +3, 0, -1, -2, -1, 0, +1, +2, +3, +4, +3 dB
```

### VOCAL
Emphasis on vocal ranges. Good for podcasts and vocal music.
```
0, 0, +1, +2, +3, +4, +3, +2, +3, +4, +3, +2, +1, +1, 0 dB
```

## Examples

### Example 1: Switch to Balanced Preset
In Balena Cloud, add device variable:
```
SOUND_EQ_PRESET = BALANCED
```
Restart the audio service or device to apply.

### Example 2: Less Bass, Keep Current Preset
```
SOUND_EQ_BASS_BOOST = 0.5
```
This reduces bass by 50% from the current preset.

### Example 3: More Treble
```
SOUND_EQ_TREBLE_BOOST = 1.5
```
This increases treble by 50% from the current preset.

### Example 4: Disable EQ Completely
```
SOUND_EQ_ENABLED = false
```

### Example 5: Custom EQ (Advanced)
```
SOUND_EQ_CUSTOM = 8,6,4,2,0,0,0,0,0,0,2,4,6,8,10
```
This creates your own custom curve with 15 comma-separated dB values.

## Frequency Bands

The 15 bands control these frequencies:
1. 50 Hz (sub-bass)
2. 100 Hz (bass)
3. 156 Hz (bass)
4. 220 Hz (low-mid)
5. 311 Hz (low-mid)
6. 440 Hz (mid)
7. 622 Hz (mid)
8. 880 Hz (mid)
9. 1.25 kHz (upper-mid)
10. 1.75 kHz (upper-mid)
11. 2.5 kHz (presence)
12. 3.5 kHz (presence)
13. 5 kHz (brilliance)
14. 10 kHz (air)
15. 20 kHz (air)

## Tips

- **After changing any variable**, restart the audio service for changes to take effect
- Start with presets, then fine-tune with `BASS_BOOST` and `TREBLE_BOOST`
- Values above +10 dB may cause distortion
- Negative values reduce those frequencies
- The `AGGRESSIVE` preset works great for Beovox CX100 speakers!

## Troubleshooting

If audio stops working after EQ changes:
1. Set `SOUND_EQ_ENABLED = false` to disable EQ
2. Restart the device
3. Check logs: `balena logs <device-uuid> --service audio`

