{ configs, pkgs, ...}:

{
    home.username = "thron";
    home.homeDirectory = "/home/thron";
    programs.bash = {
        enable = true;
        shellAliases = {
            btw = "echo I use NixOS btw";
        };
    };
}