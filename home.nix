{ config, pkgs, ... }:

let
  # 1. Define the path to your programs directory
  programsDir = ./config/programs;

  # 2. Get the content of the directory
  files = builtins.readDir programsDir;

  # 3. Filter for directories only (ignoring regular files like .DS_Store or READMEs)
  directories = builtins.filter 
    (name: files.${name} == "directory") 
    (builtins.attrNames files);

  # 4. Map the directory names to import paths
  programImports = map (name: programsDir + "/${name}") directories;
in
{
  imports = [
    # sessions
    ./config/sessions/hyprland/default.nix
  ] ++ programImports; 

  home.username = "thron";
  home.homeDirectory = "/home/thron";
  home.stateVersion = "25.11"; 
  
  home.packages = with pkgs; [
    # GTK themes
    adwaita-icon-theme
    adw-gtk3

    # Hyprland ecosystem
    hyprpicker
    grim
    slurp
    swappy
    satty
    mpvpaper
    playerctl

    # Clipboard
    wl-clipboard
    cliphist

    # Wayland / Qt support
    qt5.qtwayland
    qt6.qtwayland
    xdg-desktop-portal-gtk

    # Bar / widgets
    eww
    quickshell

    # System monitor / tray
    htop
    mission-center
    networkmanagerapplet
    piper
    pavucontrol
    btop

    # File manager / text editor / PDF
    xfce.thunar
    xfce.mousepad
    kdePackages.okular

    # Proton
    protonmail-desktop
    proton-pass

    # Productivity
    obsidian
    papers
    fastfetch

    # Media
    obs-studio
    ffmpeg

    # Development
    matugen
    yq-go
    (python313.withPackages (ps: with ps; [
      numpy
      pandas
    ]))
    pkgsCross.mingwW64.stdenv.cc

    # Apps
    qbittorrent
    bottles
    wmctrl
    steam-run
    teamspeak6-client
    p7zip
    discord

    # Icon themes
    papirus-icon-theme
  ];

  # set cursor 
  home.pointerCursor = 
  let 
    getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = 24;
        package = 
          pkgs.runCommand "moveUp" {} ''
            mkdir -p $out/share/icons
            ln -s ${pkgs.fetchzip {
              url = url;
              hash = hash;
            }}/dist $out/share/icons/${name}
          '';
      };
  in
    getFrom 
      "https://github.com/yeyushengfan258/ArcMidnight-Cursors/archive/refs/heads/main.zip"
      "sha256-VgOpt0rukW0+rSkLFoF9O0xO/qgwieAchAev1vjaqPE=" 
      "ArcMidnight-Cursors";

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.easyeffects.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-theme-name = "adw-gtk3-dark";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };
  
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home.file = {
    ".local/share/fonts/eww-fonts" = {
      source = config/programs/eww/my-eww-config/fonts;
      recursive = true;
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "MesloLGS NF";
      size = 12;
    };
    settings = {
      background = "#1a1b26";       # dark navy — change to any hex color
      background_opacity = "0.35";  # 0.0 = fully transparent, 1.0 = fully opaque
    };
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      donjayamanne.githistory
      mechatroner.rainbow-csv
      redhat.vscode-yaml
      jnoortheen.nix-ide
    ];
  };

  programs.firefox = {
    enable = true;
    profiles.thron = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        proton-pass
        proton-vpn
        ublock-origin
      ];
    };
  };
}
