{ config, lib, ... }:

{ 
  xdg.configFile."rofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/nixos/config/programs/rofi";
}
