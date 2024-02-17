{ inputs, lib, pkgs, config, outputs, secrets, username, hostname, homeDirectory, configName, ... }:

let
  userUid = "1000";
  secretsUserPath = "/run/user/${userUid}";
  username = secrets."username";
  coreutils = pkgs.coreutils;
  cat = "${coreutils}/bin/cat";
  chromiumDesktop = "chromium-browser.desktop";
  browser = chromiumDesktop;
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
      trusted-users = [ "root" "@admin" "@wheel" "${username}" ];
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
    age.keyFile = "${homeDirectory}/.keys/${configName}.agekey"; # must have no password!
    defaultSopsFile = ../../../secrets/${configName}/secrets.json;
    defaultSymlinkPath = "${secretsUserPath}/secrets";
    defaultSecretsMountPoint = "${secretsUserPath}/secrets.d";
    secrets = {
      "github_access_token" = {
        path = "${secretsUserPath}/github_access_token.txt";
      };
      "github_signing_key" = {
        path = "${secretsUserPath}/github_signing_key.asc";
      };
      "github_ssh_key" = { path = "${secretsUserPath}/github.key"; };
    };
  };

  home.sessionVariables = {
    __MYFLAKE1__ = "yes";
    __MYFLAKE__ = "yes";
    TZ = secrets."env_TZ";
    EDITOR = "${pkgs.vscode}/bin/code -w";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  home.sessionPath = [
    "/usr/local/bin"
    "/usr/local/zfs/bin"
    "${homeDirectory}/bin"
    "${home.sessionVariables.XDG_BIN_HOME}"
  ];

  xdg.mime = { enable = true; };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = browser;
      "application/x-extension-htm" = browser;
      "application/x-extension-html" = browser;
      "application/xhtml+xml" = browser;
      "application/x-extension-xht" = browser;
      "application/x-extension-xhtml" = browser;
      "application/x-extension-shtml" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "x-scheme-handler/chrome" = browser;
    };
    associations = {
      added = {
        "text/html" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/xhtml+xml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-extension-shtml" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "x-scheme-handler/chrome" = browser;
      };
    };
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
      userName = secrets."github_name";
      userEmail = secrets."github_email";
      signing = {
        signByDefault = true;
        key = secrets."github_signing_key";
      };
    };
  };

  systemd.user.services.add_ssh_keys = {
    Unit.Description = "Add ${username} SSH keys";
    Unit.After = [
      "plasma-kwallet-pam.service"
      "sops-nix.service"
      "plasma-kwin_x11.service"
      "plasma-kwin_wayland.service"
      "plasma-polkit-agent.service"
    ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.writeShellScript "add_ssh_keys" ''
        export SSH_ASKPASS="${pkgs.ksshaskpass}/bin/ksshaskpass"
        export SSH_ASKPASS_REQUIRE="prefer"
        ${pkgs.openssh}/bin/ssh-add ${secretsUserPath}/github.key
      ''}";
    };
  };

  home = {
    username = lib.mkDefault username;
    homeDirectory = lib.mkDefault homeDirectory;
    stateVersion = lib.mkDefault "24.05";

    persistence = {
      "/zhome/${config.home.username}" = {
        directories = secrets."home_persist_directories";
        allowOther = true;
      };
    };
  };
}
