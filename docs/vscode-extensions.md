# Adding VSCode Extensions via Home Manager

Replace `vscode` in `home.packages` with a `programs.vscode` block in `home.nix`:

```nix
programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        ms-python.python
        esbenp.prettier-vscode
    ];
};
```

Browse available extensions at https://search.nixos.org/packages by searching `vscode-extensions`.

## If an extension is not in nixpkgs

Fetch it directly from the VSCode marketplace:

```nix
extensions = (with pkgs.vscode-extensions; [
    vscodevim.vim
]) ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
        name = "extension-name";
        publisher = "publisher-name";
        version = "1.0.0";
        sha256 = "...";
    }
]);
```
