# Comfort shell

For greater comfort, you can use the development shell in `shell` directory using `nix develop`.
It saves you from enabling common experimental nix features and makes essential utilities available.

Example:
```
sudo nix develop --extra-experimental-features "nix-command flakes" ./shell
```

# Partition disk using disko
**WARNING**: this will erase your data!

You should partition your disk before installing NixOS. This repository offers you a way using `disko`.
Pick a configuration that suits your preferred target and needs, and use it using `nix run`.

Example:
```
nix run github:nix-community/disko -- --mode disko ./disko/pc/disko.nix  --arg target '["/dev/vda"]' # this assumes you are using the comfort shell from this repository
```

# Installation steps
First, you may want to enter the comfort shell.

Format the main disk on which your system will reside:
```
nix run github:nix-community/disko -- --mode disko ./disko/pc/disko.nix  --arg target '["/dev/vda"]' # this assumes you are using the comfort shell from this repository
```

Create the persistent directory in `/nix`:

```
mkdir /mnt/nix/persistent -p
```

Now run `nixos-install`:
```
nixos-install --flake .#pc
```
