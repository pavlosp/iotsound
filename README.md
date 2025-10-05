# IoTSound + Equalizer Fork

**Starter project enabling you to add multi-room audio streaming via Airplay2, UPnP and others to any old speakers or Hi-Fi using just a Raspberry Pi.**

> 🎚️ **This is a fork of [iotsound/iotsound](https://github.com/iotsound/iotsound)** with added **15-band LADSPA equalizer support** and a custom Debian-based audio block. Bluetooth and Spotify plugins have been removed for a streamlined setup focused on high-quality audio with EQ control.

IoTSound, formerly balenaSound, was developed in 2019 to showcase the capabilities of the [balena IoT platform](https://www.balena.io/) which provides powerful edge device management at scale. Unfortunately, balenaSound has not connected with its intended audience: the commercial and industrial IoT space where the balena platform has thrived. Rather than archive and discontinue balenaSound, we are separating it from balena and gifting it to the hobbyist audio community that has been so passionate about it over the past years. 

If you would like to become a maintainer of this project, please reach out to us in the [call for maintainers](https://github.com/iotsound/iotsound/issues/689) issue open now!

**Alternatives**

There is no guarantee that this project will be maintained, working, or error-free. We've listed some alternative well-maintained Raspberry Pi-based music players below you may want to check out in the meantime:
 
- [moOde Audio](https://moodeaudio.org/) is a free, open source "Audiophile streamer for the wonderful Raspberry Pi family of single board computers and DIY audio community." MoOde also offers a multiroom feature.
- [Volumio](https://volumio.com/) offers free and premium options for building your own music player.
- [piCorePlayer](https://www.picoreplayer.org/) - Free software that plays local music as well as online music streaming services on a Raspberry Pi.

All of the above software is easily installable from downloads or via the [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

## Highlights

- **15-band LADSPA equalizer**: Fine-tune your sound with manual band control (see [EQUALIZER.md](EQUALIZER.md))
- **Audio source plugins**: Stream audio from Airplay2, UPnP, and more (Bluetooth & Spotify removed)
- **Multi-room synchronous playing**: Play perfectly synchronized audio on multiple devices all over your place
- **Extended DAC support**: Upgrade your audio quality with one of our supported DACs
- **Debian-based audio block**: Using Debian Bullseye for better audio plugin compatibility (SWH LADSPA plugins)


## Hardware Compatibility

⚠️ **This fork has been tested on:**
- **Raspberry Pi 4** with BossDAC (Allo Boss DAC)

Other Raspberry Pi models may work but have not been tested. The Debian-based audio block may have different performance characteristics compared to the original Alpine-based image.

## Setup and configuration

Running this app is as simple as deploying it to a balenaCloud fleet. You can do it in just one click by using the button below:

[![deploy button](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/pavlosp/iotsound&defaultDeviceType=raspberry-pi)

### Equalizer

The equalizer is **enabled by default** with a custom 15-band curve optimized for Beovox CX100 speakers.

**To customize the sound:**
1. Edit the EQ bands in `core/audio/balena-sound.pa` (line 12)
2. Commit and push: `git push balena master`
3. Wait ~1 minute for the device to update

📖 **Complete guide**: See [EQUALIZER.md](EQUALIZER.md) for:
- Current frequency breakdown and settings
- How to adjust specific bands
- Verification commands to check EQ status
- Tuning tips (reduce hiss, adjust bass, etc.)
- Troubleshooting

## Technical Changes from Original

This fork includes several modifications to support the equalizer:

- **Audio Block Base Image**: Changed from Alpine Linux 3.15 to Debian Bullseye for better LADSPA plugin support
- **LADSPA Equalizer**: Uses `module-ladspa-sink` with SWH plugins (`mbeq_1197` - 15-band multiband EQ)
- **Audio Format**: All PulseAudio sinks configured as `float32le` for LADSPA compatibility
- **Static Configuration**: EQ curve defined in `balena-sound.pa` for reliability and simplicity
- **Removed Plugins**: Bluetooth and Spotify plugins removed to reduce complexity
- **Kept Plugins**: Airplay, UPnP, and multiroom functionality fully intact

## Documentation

Head over to the [original docs](https://iotsound.github.io/) for detailed installation and usage instructions, customization options, and more!

For equalizer-specific documentation, see [EQUALIZER.md](EQUALIZER.md).

## Motivation

![concept](https://raw.githubusercontent.com/iotsound/iotsound/master/docs/images/sound.png)

There are many commercial solutions out there that provide functionality similar to IoTSound. Most of them though come with a premium price tag and are riddled with privacy concerns.

IoTSound is an open source project that allows you to build your own DIY audio streaming platform without compromises. Why spend big money on hardware that might be deemed obsolete by the vendor as they see fit? With IoTSound you are in control, bring your old speakers back to life!

This project is no longer in active development but if you'd like to be a maintainer please submit an issue here on GitHub.

## Getting Help

For issues related to the **equalizer or this fork**, please [raise an issue](https://github.com/pavlosp/iotsound/issues/new) on this repository.

For general IoTSound issues, refer to the [original project](https://github.com/iotsound/iotsound).

---

### Fork Maintainer

This fork is maintained by [@pavlosp](https://github.com/pavlosp). The original IoTSound project is available at [iotsound/iotsound](https://github.com/iotsound/iotsound).
