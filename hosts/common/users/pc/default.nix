{ pkgs, inputs, config, secrets, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  homeManagerConfigUserName = "pc";
  userName = "ye";
  homeDirectory = "/home/${userName}";
  precreateUserDirectoryRules = (persistPath: perm: user: group: dirs:
    builtins.map
    (dir: "d ${persistPath}/${user}/${dir} ${perm} ${user} ${group} -") dirs);
  precreateUserDirectoryRulesPerm =
    precreateUserDirectoryRules "zhome" "0750";
  precreateUserDirectoryRulesDefault =
    precreateUserDirectoryRulesPerm userName userName;
  homeManagerSessionVars =
    "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  users.mutableUsers = false;
  users.users."${userName}" = {
    isNormalUser = true;

    extraGroups = [ "wheel" "video" "audio" ] ++ ifTheyExist [
      "minecraft"
      "wireshark"
      "i2c"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "deluge"
      "networkmanager"
      "adbusers"
      "lxd"
      "vboxusers"
      "uucp"

      "cdrom"
      "tape"
      "input"
      "games"
      "floppy"
      "render"
      "realtime"
      "dialout"
      "network"
      "flashrom"
      "disk"
      "${userName}"
    ];

    initialPassword = "test";
    packages = [ pkgs.home-manager ];
  };

  fileSystems = {
    "${homeDirectory}" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=100%" ];
    };
  };

  programs.fuse.userAllowOther = true;

  home-manager = {
    users = {
      "${userName}" = import
        ../../../../homes/${homeManagerConfigUserName}/${config.networking.hostName}.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = rec { inherit secrets; };
  };
  environment.extraInit =
    "[[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars}";

  users.groups."${userName}" = { };

  systemd.tmpfiles = let
    dirs = [
      ""
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ''"VirtualBox VMs"''
      "VM"
      "Templates"
      "Public"
      "Desktop"
      "NixConfig"
      "bin"
      ".local"
      ".config"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".vscode"
      ".vscode-insiders"
      ".vscodium"
      ".keys"
      ".local/share"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".local/bin"
      ".config"
      ".config/Code"
      ''.config/"Code - Insiders"''
      "./config/VSCodium"
    ];
  in {
    rules = precreateUserDirectoryRulesDefault dirs;
  };
}
