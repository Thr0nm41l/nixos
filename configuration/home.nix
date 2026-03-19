{ config, pkgs, ...}:

{
    home.username = "thron";
    home.homeDirectory = "/home/thron";
    home.stateVersion = "25.11";

    home.packages = with pkgs; [
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

        # PDF reader
        okular

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

    programs.kitty = {
        enable = true;
        font = {
            name = "MesloLGS NF";
            size = 12;
        };
    };

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
        plugins = [
            {
                name = "powerlevel10k";
                src = pkgs.zsh-powerlevel10k;
                file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
        ];
    };
}