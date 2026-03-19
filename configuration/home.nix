{ config, pkgs, ...}:

{
    home.username = "thron";
    home.homeDirectory = "/home/thron";
    home.stateVersion = "25.11";

    home.packages = with pkgs; [
        # Terminal
        kitty

        # Hyprland ecosystem
        hyprpaper
        hypridle
        hyprlock
        hyprpicker

        # Status bar
        waybar

        # App launcher
        rofi-wayland

        # Notifications
        dunst

        # Wayland Qt support
        qt5.qtwayland
        qt6.qtwayland

        # System monitor
        htop
        mission-center

        # File manager
        thunar

        # Text editor
        mousepad

        # Proton
        proton-mail
        proton-pass

        # Network & Bluetooth tray
        blueman
        networkmanagerapplet

        # Development
        (python313.withPackages (ps: with ps; [
            numpy
            pandas
        ]))

        # Apps
        obs-studio
        teamspeak6-client
    ];

    programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
            donjayamanne.githistory
            mechatroner.rainbow-csv
            redhat.vscode-yaml
            jnoortheen.nix-ide
        ];
    };

    programs.firefox = {
        enable = true;
        profiles.thron = {
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
                proton-pass
                proton-vpn
                ublock-origin
                adblock-plus
            ];
        };
    };

    programs.zsh = {
        enable = true;
        shellAliases = {
            btw = "echo I use NixOS btw";
        };
    };
}