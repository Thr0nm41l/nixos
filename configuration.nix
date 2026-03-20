# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  # Imports
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # System packages — keep minimal, user packages live in home.nix
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    vim
    polkit_gnome
  ];

  # User accounts and security
  users.users.thron = {
    isNormalUser = true;
    description = "thron";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    initialPassword = "changeme";
    useDefaultShell = true;
    shell = pkgs.zsh;
  };

  users.defaultUserShell = pkgs.zsh;
  system.userActivationScripts.zshrc = "touch .zshrc";

  systemd.tmpfiles.rules = [
    "d /home/thron 0700 thron users -"
  ];

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };

  # Polkit (required for Hyprland privilege escalation)
  security.polkit.enable = true;

  # Program configurations
  programs.zsh.enable = true;

  programs.dconf = {
    enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true; 
  };
  programs.gamemode.enable = true;

  # Home manager (configured via flake.nix)

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Hyprland
  programs.hyprland.enable = true;

  # XDG Portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Configure keymap
  console.keyMap = "fr";
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Fonts
  fonts.packages = with pkgs; [
    udev-gothic-nf
    noto-fonts
    liberation_ttf
    nerd-fonts.meslo-lg
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  fonts.fontconfig = {
    enable = true;
    hinting.style = "slight"; 
    subpixel.rgba = "rgb"; 
  };

  # Flatpak
  services.flatpak.enable = true;

  # Environment Variables
  # environment.variables.XDG_DATA_DIRS = lib.mkForce "/home/thron/.nix-profile/share:/run/current-system/sw/share";

  # Networking and time
  networking.hostName = "nixos-btw";

  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  # English UI, French regional formats (dates, currency, paper, measurements)
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8" ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS      = "fr_FR.UTF-8"; # French address format
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT  = "fr_FR.UTF-8"; # Metric system
    LC_MONETARY     = "fr_FR.UTF-8"; # € currency
    LC_NAME         = "fr_FR.UTF-8";
    LC_NUMERIC      = "fr_FR.UTF-8"; # Comma as decimal separator
    LC_PAPER        = "fr_FR.UTF-8"; # A4 paper
    LC_TELEPHONE    = "fr_FR.UTF-8";
    LC_TIME         = "fr_FR.UTF-8"; # DD/MM/YYYY, 24h clock
  };

  # Audio and system services
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.blueman.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # Power Management Services
  services.power-profiles-daemon.enable = true; 

  # Nix settings and maintenance
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };
  boot = {
    plymouth = {
      enable = true;
      theme = "simple";
      themePackages = [
        (pkgs.stdenv.mkDerivation {
          pname = "plymouth-theme-simple";
          version = "1.0";
          
          # CHANGE THIS to the actual path of your custom theme folder
          src = ./config/programs/plymouth/simple;

          installPhase = ''
            mkdir -p $out/share/plymouth/themes/simple
            cp -r * $out/share/plymouth/themes/simple/
            
            # This dynamically replaces the @out@ placeholder with the real Nix store path
            substituteInPlace $out/share/plymouth/themes/simple/simple.plymouth \
              --replace "@out@" "$out"
          '';
        })      
	];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "intel_pstate=active"
      "tsc=reliable" 
      "asus_wmi"
    ];
    
  };
  # Bootloader
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel Packages and Optimization
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.intel.updateMicrocode = true;

  boot.kernelModules = [ "tcp_bbr" ]; # FIX: Network Congestion Control (Helps with packet jitter)
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
    "net.core.wmem_max" = 1073741824;
    "net.core.rmem_max" = 1073741824;
    "net.ipv4.tcp_rmem" = "4096 87380 1073741824";
    "net.ipv4.tcp_wmem" = "4096 87380 1073741824";
  };

  # FIX: Force CPU to run at max clock speed to prevent frame-time jitter
  powerManagement.cpuFreqGovernor = "performance";

  # ==========================================
  # GPU / GRAPHICS CONFIGURATION (ADDED)
  # ==========================================

  # Enable OpenGL/Vulkan (renamed to hardware.graphics in 24.11+)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for Steam/CS2
  };

  # Load NVIDIA Drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption after suspend/wake.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures.
    # We set to false here for maximum stability on the mobile 3050.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Select the stable driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME CONFIGURATION (Hybrid Graphics)
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      
      # Bus IDs — run `lspci | grep -E "VGA|3D"` to find yours
      # Format: XX:YY.Z -> PCI:XX:YY:Z
      nvidiaBusId = "PCI:1:0:0";
      intelBusId  = "PCI:0:2:0";
    };
  };

  system.stateVersion = "25.11"; 
}
