{ inputs, lib, pkgs, config, outputs, ... }:

rec {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.impermanence.nixosModules.home-manager.impermanence
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  systemd.user.startServices = "sd-switch";

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      trusted-users = [ "root" "@admin" "@wheel" "ye" ];
      extra-substituters =
        [ "https://nyx.chaotic.cx/" "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  sops = {
    age.keyFile = "/home/user/.keys/keys.txt"; # must have no password!
    defaultSopsFile = ../../../secrets/pc/secrets.json;
    secrets = {
      "github_access_token" = {
        # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

        # %r gets replaced with a runtime directory, use %% to specify a '%'
        # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
        # DARWIN_USER_TEMP_DIR) on darwin.
        path = "%r/github_access_token.txt";
      };
    };
  };

  programs.zsh = {
    enable = true;
    sessionVariables = {
      GITHUB_TOKEN = "$(cat ${sops.secrets.github_access_token.path})";
      __MYFLAKE__ = "yes";
    };
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs = { enable = true; };
      userName = "busyammonia";
      userEmail = "159623986+busyammonia@users.noreply.github.com";
    };
  };

  home = {
    username = lib.mkDefault "ye";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.11";

    persistence = {
      "/zhome/${config.home.username}" = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          "VirtualBox VMs"
          "VM"
          "Templates"
          "Public"
          "Desktop"
          "NixConfig"
          "Git"
          "Vault"
          "Torrents"
          "Zotero"
          ".gnupg"
          ".ssh"
          ".nixops"
          ".mozilla"
          ".vscode"
          ".vscode-insiders"
          ".vscodium"
          ".zotero"
          ".keys"

          ".local/share/keyrings"
          ".local/share/direnv"
          ".local/share/tor-browser"
          ".local/share/qBittorrent"
          ".local/share/Anki2"
          ".local/share/Anki"
          ".local/share/tg"
          ".local/share/kscreen"
          ".local/share/bottles"
          ".local/share/TelegramDesktop"
          ".local/bin"
          ".local/share/kwalletd"

          ".config/kwalletrc"
          ".config/chromium"
          ".config/Code"
          ''.config/"Code - Insiders"''
          ".config/VSCodium"
          ".config/Bitwarden"
          ".config/Bitwarden CLI"
          ".config/qBittorrent"
          ".config/tg"
          ".config/obsidian"
          ".config/nekoray"
        ];
        allowOther = true;
      };
    };
  };
}
