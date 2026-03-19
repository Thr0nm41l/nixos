{ config, pkgs, lib, ... }:
{
    imports = [ ./hardware-configuration.nix ];

    boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;  # auto-detects Windows and adds it to the boot menu
    };
    boot.loader.efi.canTouchEfiVariables = true;

    # Nvidia drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # 32-bit graphics support (required for Steam and older games)
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    networking.hostName = "nixos-btw";
    networking.networkmanager.enable = true;

    # Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

    time.timeZone = "Europe/Paris";

    # French AZERTY keyboard layout
    console.keyMap = "fr";
    services.xserver.xkb.layout = "fr";

    programs.zsh.enable = true;

    users.users.thron = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
        initialPassword = "changeme";
        shell = pkgs.zsh;
        home = "/home/thron";
    };

    systemd.tmpfiles.rules = [
        "d /home/thron 0700 thron users -"
    ];

    # Enable Hyprland
    programs.hyprland.enable = true;

    # Display manager
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
    };

    # Polkit (required for Hyprland privilege escalation)
    security.polkit.enable = true;

    # RTKit (real-time priority for PipeWire)
    security.rtkit.enable = true;

    # Steam (requires system-level setup for 32-bit support)
    programs.steam.enable = true;

    # GameMode - performance boost for games
    programs.gamemode.enable = true;

    # Allow unfree packages (Steam, VSCode...)
    nixpkgs.config.allowUnfree = true;

    # Audio
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
    };

    # Fonts
    fonts.packages = with pkgs; [
        nerd-fonts.meslo-lg
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka
    ];

    # Docker
    virtualisation.docker.enable = true;

    # SSH
    services.openssh = {
        enable = true;
        settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
        };
    };

    # Flakes support
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        git
        wget
        curl
        vim
        polkit_gnome
    ];

    system.stateVersion = "25.11";
}
