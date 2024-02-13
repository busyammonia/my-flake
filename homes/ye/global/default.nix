{ inputs, lib, pkgs, config, outputs, ... }:

let
  userUid = "1000";
  secretsUserPath = "/run/user/${userUid}";
  homePath = "/home/ye";
  coreutils = pkgs.coreutils;
  cat = "${coreutils}/bin/cat";
in rec {
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
    age.keyFile = "/home/ye/.keys/keys.txt"; # must have no password!
    defaultSopsFile = ../../../secrets/pc/secrets.json;
    defaultSymlinkPath = "${secretsUserPath}/secrets";
    defaultSecretsMountPoint = "${secretsUserPath}/secrets.d";
    secrets = {
      "github_access_token" = {
        path = "${secretsUserPath}/github_access_token.txt";
      };
      "github_signing_key" = {
        path = "${secretsUserPath}/github_signing_key.asc";
      };
      "github_ssh_key" = {
        path = "${secretsUserPath}/github.key";
      };
    };
  };

  home.sessionVariables = {
    __MYFLAKE1__ = "yes";
    __MYFLAKE__ = "yes";
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      export GITHUB_TOKEN=$(${cat} ${sops.secrets.github_access_token.path})
      export GITHUB_API_TOKEN=$(${cat} ${sops.secrets.github_access_token.path})
    '';
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs = { enable = true; };
      userName = "busyammonia";
      userEmail = "159623986+busyammonia@users.noreply.github.com";
      signing = {
        signByDefault = true;
        key = "CDDD51948F679059";
      };
    };
  };

  systemd.user.services.add_ssh_keys = {
    Unit.Description = "Neuron zettelkasten service";
    Unit.After = [ "plasma-kwallet-pam.service" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.writeShellScript "add_ssh_keys" ''
      eval `${pkgs.openssh}/bin/ssh-agent -s`
      export SSH_ASKPASS="${pkgs.ksshaskpass}/bin/ksshaskpass"
      export SSH_ASKPASS_REQUIRE="prefer"
      ${pkgs.openssh}/bin/ssh-add ${secretsUserPath}/github.key
    ''}";
    };
  };

  home = {
    username = lib.mkDefault "ye";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";

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
