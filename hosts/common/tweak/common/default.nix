{ config, ... }: {
  imports = [
    ./pam.nix
    ./lxc.nix
    ./bbr.nix
    ./console-blank.nix
    ./nested-virt.nix
    ./file-max.nix
    ./fix-transparent-proxy.nix
    ./max-map-count.nix
    ./network.nix
    ./preempt.nix
    ./quiet.nix
    ./shell-on-fail.nix
    ./unprivileged-clone.nix
    ./random-nocpu.nix
    ./protected-symlinks.nix
    ./forward-ip.nix
  ];
}
