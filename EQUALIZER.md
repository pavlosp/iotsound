# Equalizer Configuration

Your IoTSound fork includes a **15-band LADSPA equalizer** using SWH plugins, optimized for high-quality audio with manual control.

## Current Configuration

The default EQ profile is **BALANCED-AGGRESSIVE** for Beovox CX100 speakers:

```
control=10,8,6,4,1,-1,-2,-2,-1,1,3,5,6,6,4
```

### Frequency Breakdown

| Band | Frequency | Current Level | Description |
|------|-----------|---------------|-------------|
| 1 | 50 Hz | +10 dB | Sub-bass (deep rumble) |
| 2 | 100 Hz | +8 dB | Bass (kick drums) |
| 3 | 156 Hz | +6 dB | Bass (low fundamentals) |
| 4 | 220 Hz | +4 dB | Low-mids (warmth) |
| 5 | 311 Hz | +1 dB | Low-mids |
| 6 | 440 Hz | -1 dB | Mids (slightly scooped) |
| 7 | 622 Hz | -2 dB | Mids (scooped) |
| 8 | 880 Hz | -2 dB | Mids (scooped) |
| 9 | 1.25 kHz | -1 dB | Upper-mids (reduced) |
| 10 | 1.75 kHz | +1 dB | Presence (vocal clarity) |
| 11 | 2.5 kHz | +3 dB | Presence (bite) |
| 12 | 3.5 kHz | +5 dB | Brilliance (detail) |
| 13 | 5 kHz | +6 dB | Brilliance (sparkle) |
| 14 | 10 kHz | +6 dB | Air (shimmer) |
| 15 | 20 kHz | +4 dB | Ultra-high air |

## How to Change the EQ

### Step 1: Edit the Configuration File

Open `core/audio/balena-sound.pa` and find line 12:

```bash
load-module module-ladspa-sink sink_name=balena-sound.equalizer sink_master=balena-sound.input plugin=mbeq_1197 label=mbeq control=10,8,6,4,1,-1,-2,-2,-1,1,3,5,6,6,4
```

Change the `control=` values to your desired dB levels (range: -70 to +30 dB).

### Step 2: Deploy Changes

```bash
git add core/audio/balena-sound.pa
git commit -m "Adjust EQ curve"
git push origin master
git push balena master
```

Wait for the build to complete (~1 minute) and the device will update automatically.

## Example EQ Presets

### FLAT (No EQ)
```
control=0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
```

### BASS HEAVY
Maximum low-end emphasis:
```
control=12,10,8,6,3,0,-1,-2,-1,0,1,2,3,2,1
```

### VOCAL FOCUS
Emphasis on voice frequencies:
```
control=0,0,1,2,3,4,3,2,3,4,3,2,1,0,0
```

### GENTLE SMILE
Subtle bass and treble lift:
```
control=6,4,3,1,0,0,0,-1,0,1,2,3,4,3,2
```

### CURRENT (BALANCED-AGGRESSIVE)
Strong bass, scooped mids, smooth highs:
```
control=10,8,6,4,1,-1,-2,-2,-1,1,3,5,6,6,4
```

## Tuning Tips

### Reduce Hiss
If you hear hiss or harshness:
- Lower bands 13-15 (5kHz-20kHz): `6,4,2` → `4,2,0`

### More Bass Impact
For deeper bass:
- Increase bands 1-3: `10,8,6` → `12,10,8`

### Reduce Muddiness
If bass is too boomy:
- Lower bands 2-4: `8,6,4` → `6,4,2`

### Add Presence
For more vocal clarity:
- Increase bands 10-12: `2,4,5` → `3,5,6`

### Scooped Mids (V-shape)
For modern "smiley face" sound:
- Keep bass high, mids negative, highs high

## Verifying the Equalizer is Working

SSH into your device to check the EQ status:

```bash
balena ssh <device-uuid>
balena-engine exec audio bash
```

### Check 1: Verify Equalizer Sink Exists

```bash
pactl list sinks short
```

**Expected output:**
```
0  alsa_output.dac.stereo-fallback  ...  RUNNING
1  balena-sound.input               ...  IDLE
2  balena-sound.output              ...  IDLE
3  snapcast                         ...  RUNNING
4  balena-sound.equalizer           ...  SUSPENDED  ← EQ sink present! ✅
```

### Check 2: Confirm Default Sink

```bash
pactl info | grep "Default Sink"
```

**Expected output:**
```
Default Sink: balena-sound.equalizer  ← Audio routed through EQ! ✅
```

### Check 3: View EQ Module Details

```bash
pactl list modules | grep -A 20 "module-ladspa-sink"
```

**Expected output:**
```
Module #XX
    Name: module-ladspa-sink
    Argument: sink_name=balena-sound.equalizer sink_master=balena-sound.input plugin=mbeq_1197 label=mbeq control=10,8,6,4,1,-1,-2,-2,-1,1,3,5,6,6,4
    ...
```

You should see your **control values** here! ✅

### Check 4: Verify LADSPA Module is Loaded

```bash
pactl list modules short | grep ladspa
```

**Expected output:**
```
XX  module-ladspa-sink  sink_name=balena-sound.equalizer ...
```

### Check 5: View All Module Arguments

```bash
pactl list modules | grep -B 2 "mbeq_1197"
```

This shows the complete LADSPA configuration including your EQ curve.

## Testing the Equalizer by Ear

### A/B Comparison Test

**Enable EQ (default):**
```bash
pactl set-default-sink balena-sound.equalizer
```

**Bypass EQ (flat sound):**
```bash
pactl set-default-sink balena-sound.input
```

Play the same song and switch between them. You should hear:
- **With EQ**: Punchier bass, clearer highs, more exciting sound
- **Without EQ**: Flatter, more neutral, less impactful

**Re-enable EQ:**
```bash
pactl set-default-sink balena-sound.equalizer
```

## Troubleshooting

### EQ Module Not Loading

Check PulseAudio logs:
```bash
journalctl -u pulseaudio -n 50 --no-pager
```

Or view audio service logs from Balena Cloud dashboard.

### Audio Sounds Distorted

Your EQ settings may be too extreme. Try:
1. Reduce all values by 3-6 dB
2. Avoid exceeding +15 dB on any single band
3. Don't boost more than 3-4 adjacent bands by +10 dB

### No Sound at All

Reset to default sink:
```bash
pactl set-default-sink alsa_output.dac.stereo-fallback
```

If sound returns, the issue is with the EQ module. Check the logs.

### DAC Status Light Goes Off

This indicates PulseAudio crashed. Check logs for errors and reduce EQ boost levels.

## Technical Details

- **Plugin**: SWH LADSPA `mbeq_1197` (Steve Harris Multiband EQ)
- **Bands**: 15 (ISO standard 1/3 octave centers)
- **Sample Format**: float32le @ 44100Hz (required for LADSPA)
- **Latency**: Minimal (~few milliseconds)
- **Processing**: Real-time DSP in PulseAudio

## Need Help?

If the equalizer isn't working:
1. Check that `balena-sound.equalizer` sink exists (Check 1)
2. Verify it's set as default sink (Check 2)
3. Confirm control values are correct (Check 3)
4. Test by playing music via AirPlay

For issues specific to this fork, open an issue at: https://github.com/pavlosp/iotsound/issues
