{ config, pkgs, ...}:

{
    home.username = "thron";
    home.homeDirectory = "/home/thron";
    home.stateVersion = "25.11";

    home.packages = with pkgs; [
        # Hyprland ecosystem
        swww
        hypridle
        hyprlock
        hyprpicker
        hyprshot

        # Status bar
        waybar
        playerctl

        # App launcher
        rofi
        papirus-icon-theme

        # Notifications
        swaynotificationcenter

        # OSD (volume/brightness)
        swayosd

        # Clipboard
        wl-clipboard
        cliphist

        # Wayland Qt support
        qt5.qtwayland
        qt6.qtwayland

        # System monitor
        htop
        mission-center

        # File manager
        xfce.thunar

        # Text editor
        xfce.mousepad

        # PDF reader
        kdePackages.okular

        # Proton
        protonmail-desktop
        proton-pass

        # Network & Bluetooth tray
        networkmanagerapplet
        pavucontrol

        # Development
        (python313.withPackages (ps: with ps; [
            numpy
            pandas
        ]))

        # Apps
        obs-studio
        teamspeak6-client
        easyeffects
    ];

    xdg.configFile = {
        "hypr/hyprland.conf".source    = ./dotfiles/hypr/hyprland.conf;
        "hypr/keybinds.conf".source    = ./dotfiles/hypr/keybinds.conf;
        "hypr/autostart.conf".source   = ./dotfiles/hypr/autostart.conf;
        "hypr/windowrules.conf".source = ./dotfiles/hypr/windowrules.conf;
        "hypr/hyprlock.conf".source    = ./dotfiles/hypr/hyprlock.conf;
        "hypr/hypridle.conf".source    = ./dotfiles/hypr/hypridle.conf;
        "waybar/config.jsonc".source   = ./dotfiles/waybar/config.jsonc;
        "waybar/style.css".source      = ./dotfiles/waybar/style.css;
        "rofi/config.rasi".source      = ./dotfiles/rofi/config.rasi;
        "rofi/theme.rasi".source       = ./dotfiles/rofi/theme.rasi;
        "swaync/config.json".source            = ./dotfiles/swaync/config.json;
        "swaync/style.css".source              = ./dotfiles/swaync/style.css;
        "wallpapers/salty_mountains.png".source = ./dotfiles/wallpapers/salty_mountains.png;
    };

    programs.kitty = {
        enable = true;
        font = {
            name = "MesloLGS NF";
            size = 12;
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
	initExtra = " [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
    };
}
