{ pkgs, ... }: {
  home.packages = with pkgs; [
    sops
    ssh-to-age
    gnupg
    age

    curlFull
    wget
  ];
}
