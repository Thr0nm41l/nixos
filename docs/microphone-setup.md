# Microphone Setup & Troubleshooting

## Diagnosing poor mic quality

### 1. Identify your audio card and capture devices

```bash
arecord -l
```

Look for the card number (e.g. `card 0`) and device name. On this machine the internal mic is `pci-0000_00_1f.3` (Intel HDA).

### 2. Check and adjust levels in alsamixer

```bash
alsamixer -c 0 -V capture
```

- `-c 0` targets card 0 (adjust if your mic is on a different card)
- `-V capture` shows capture channels only

**Navigation:**
- Arrow keys — move between channels
- Up/Down — adjust level
- Space — toggle capture source on/off
- F4 — switch to capture view if not already there
- Esc — exit

**What to look for:**

| Control | Recommended | Notes |
|---|---|---|
| Mic Boost | 0–25% | High values cause distortion and hiss |
| Capture | 60–80% | Main mic input gain |
| Internal Mic Boost | 0–25% | Same as above for built-in mic |

If the mic sounds distorted or picks up too much noise, **Mic Boost** is the first thing to lower.

### 3. Test at the ALSA level

Record 5 seconds and play back immediately:

```bash
arecord -d 5 -f cd /tmp/test.wav && aplay /tmp/test.wav
```

If it sounds clean here, the issue is upstream (PipeWire or EasyEffects).
If it still sounds bad, the problem is at the driver/gain level — keep adjusting alsamixer.

### 4. Save ALSA settings across reboots

By default alsamixer settings reset on reboot. To persist them:

```bash
sudo alsactl store
```

This saves to `/var/lib/alsa/asound.state`. NixOS restores it on boot via the `alsa-restore` service (enabled automatically when `services.pipewire.alsa.enable = true`).

---

## Plugging in an external mic

When you plug in a new mic, PipeWire usually picks it up automatically. If levels are off:

```bash
# Find the card number of the new mic
arecord -l

# Open alsamixer for that specific card
alsamixer -c <card_number> -V capture
```

Then repeat the level check above and run `sudo alsactl store` once you're happy.

---

## Software noise suppression (EasyEffects)

If the mic hardware is clean but background noise is still an issue, use EasyEffects:

1. Open EasyEffects
2. Go to the **Recording** tab (not Playback)
3. Add effect → **RNNoise** or **Noise Reduction**
4. Enable it — it runs a neural network to filter ambient noise in real time

This is a good complement to correct hardware gain settings.

---

## Architecture note

This system uses:
- **Intel HDA** (`snd_hda_intel`) — standard on Intel platforms, card `00_1f.3`
- **PipeWire** as the audio server (with `wireplumber` session manager)
- **EasyEffects** for per-app/global audio processing

SOF firmware (`sof-firmware`) is **not needed** here — that is only for laptops where the Intel audio DSP runs Sound Open Firmware (detectable via `dmesg | grep -i sof` showing actual SOF messages).
