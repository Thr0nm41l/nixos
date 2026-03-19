# Powerlevel10k Setup

Powerlevel10k is already installed via `home.nix` — no manual cloning needed.

## First Launch

1. Open kitty
2. The Powerlevel10k configuration wizard launches automatically
3. Follow the wizard (icons, prompt style, colors, etc.)
4. Done

## Making the Config Declarative (optional)

After the wizard, p10k writes its config to `~/.p10k.zsh`. To track it in the repo, copy it into the `configuration/` directory and reference it in `home.nix`:

```nix
programs.zsh = {
    ...
    initExtra = "source ~/.p10k.zsh";
};
```

Then copy the file:
```bash
cp ~/.p10k.zsh ~/path/to/your/nixos-config/configuration/
```

To re-run the wizard at any time:
```bash
p10k configure
```
