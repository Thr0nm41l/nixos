# NixOS Installation Guide

Machine specs: Intel CPU, Nvidia GPU, NixOS 25.11, Flakes + Home-Manager, Hyprland, French AZERTY keyboard.

---

## 1. Boot & Connect to Network

```bash
# If on WiFi:
iwctl
  station wlan0 connect "YourSSID"
  exit

# Verify connectivity
ping nixos.org
```

## 2. Partition the Disk

Find your disk name first:
```bash
lsblk
```

Then partition (replace `sda` with your disk, e.g. `nvme0n1`):
```bash
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart primary linux-swap 512MB 8GB
parted /dev/sda -- mkpart primary 8GB 100%
```

## 3. Format & Mount

```bash
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3

mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2
```

## 4. Generate Hardware Config

```bash
nixos-generate-config --root /mnt
```

This creates `/mnt/etc/nixos/hardware-configuration.nix` — you will need it.

## 5. Set Up Your Config Files

```bash
# Install git (temporarily)
nix-shell -p git

# Clone your repo
git clone https://github.com/YOUR_USER/nixos /mnt/etc/nixos/nixos-config
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/nixos-config/configuration/
```

## 6. Write configuration.nix

```bash
nano /mnt/etc/nixos/nixos-config/configuration/configuration.nix
```

The `configuration.nix` file is already written in the repo at `configuration/configuration.nix`. Just make sure `hardware-configuration.nix` is copied into the same directory after running `nixos-generate-config`.

## 7. Install

```bash
cd /mnt/etc/nixos/nixos-config/configuration

git add .

nixos-install --flake .#nixos-btw
```

Set the root password when prompted, then:

```bash
reboot
```

## 8. Post-Install

Log in as `thron` (password: `changeme`) and immediately change it:
```bash
passwd
```

## SSH

SSH is enabled in `configuration.nix` with root login and password authentication disabled (key-based auth only).

**Add your public key** to be able to log in remotely. Either declaratively in `configuration.nix`:

```nix
users.users.thron = {
    ...
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAA... you@yourmachine"
    ];
};
```

Or directly on the machine after install:

```bash
mkdir -p ~/.ssh
echo "ssh-ed25519 AAAA... you@yourmachine" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

**Other common settings** you can add to `services.openssh.settings` in `configuration.nix`:

| Option | Values | Purpose |
|---|---|---|
| `Port` | `22` or custom | Change default port |
| `X11Forwarding` | `true/false` | Forward GUI apps over SSH |
| `AllowUsers` | `"thron"` | Whitelist specific users |

Since password authentication is disabled, make sure you add your public key before you need to SSH in, otherwise you will be locked out remotely.

## GameMode

GameMode is enabled in `configuration.nix` and boosts game performance by switching the CPU/GPU to high performance mode while a game is running, then reverting when it closes.

To activate it for a game on Steam, add this to the game's launch options (right-click game > Properties > Launch Options):

```
gamemoderun %command%
```
