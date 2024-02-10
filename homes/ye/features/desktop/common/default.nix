{ pkgs, inputs, ... }: {
  home.packages = let genpw = pkgs.writeShellScriptBin "genpw" "${pkgs.diceware}/bin/diceware -n 3 -d _ | tr '[:lower:]' '[:upper:]' | tr '_' 'z' | tr '\n' 'z'"; in with pkgs; [
    zotero
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    bottles
    nekoray
    genpw
    telegram-desktop
    pkgs.inputs.nixpkgs-master.pdfannots2json
    cntr
  ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;    
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    enableExtraSocket = true;
    grabKeyboardAndMouse = true;
    enableScDaemon = true;
    pinentryFlavor = null;
    extraConfig = ''
    pinentry-program ${pkgs.kwalletcli}/bin/pinentry-kwallet
    '';
  };
}