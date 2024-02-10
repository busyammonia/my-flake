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
nix run github:nix-community/disko -- --mode disko ./disko/test/disko.nix  --arg target '"/dev/vda"' # this assumes you are using the comfort shell from this repository
```

# Installation steps
First, you may want to enter the comfort shell.

You may want to format your "data" disks:
```
nix run github:nix-community/disko -- --mode disko ./disko/test/single-disk-zfs.nix  --arg target '"/dev/disk/by-id/ata-WDC_WD10EZEX-08WN4A0_WD-WCC6Y6EVXVE7"'
```

Format the main disk on which your system will reside:
```
nix run github:nix-community/disko -- --mode disko ./disko/test/disko.nix  --arg target '"/dev/disk/by-id/ata-Samsung_SSD_860_EVO_250GB_S4BFNF0M805092Z"'
```

**WARNING**: If you WILL format "data" disks, format them first, and only then the main disk. After that, mount the data disk using `zfs mount zdata/persist`!

Now run `nixos-install`:
```
nixos-install --flake .#pc
```
