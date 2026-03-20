{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    history.path = "$HOME/.zsh_history";
    history.ignoreAllDups = true;

    initContent = ''
      ${builtins.readFile ./zsh-init.sh}
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    shellAliases = {
      edit = "sudo -E nvim -n";
      update = "sudo nixos-rebuild switch";
      stop = "shutdown now";
      edconf = "sudo -E nvim /etc/nixos/nixos-config/nixos/configuration.nix";
      out = "loginctl terminate-user thron";
      edeww = "sudo -E nvim /etc/nixos/nixos-config/nixos/config/programs/eww/new-eww/";
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

  home.sessionVariables = {
      hypr = "/etc/nixos/nixos-config/nixos/config/sessions/hyprland/";
      programs = "/etc/nixos/nixos-config/nixos/config/programs";
    };

}
