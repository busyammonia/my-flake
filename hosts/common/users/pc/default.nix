{ pkgs, inputs, config, secrets, specialArgsPassthrough, username, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  homeManagerConfigUserName = "pc";
  homeDirectory = "/home/${username}";
  precreateUserDirectoryRules = (persistPath: perm: user: group: dirs:
    builtins.map
    (dir: "d ${persistPath}/${user}/${dir} ${perm} ${user} ${group} -") dirs);
  precreateUserDirectoryRulesPerm =
    precreateUserDirectoryRules "zhome" "0750";
  precreateUserDirectoryRulesDefault =
    precreateUserDirectoryRulesPerm username username;
  homeManagerSessionVars =
    "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  users.mutableUsers = false;
  users.users."${username}" = {
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
      "${username}"
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
      "${username}" = import
        ../../../../homes/${homeManagerConfigUserName}/${config.networking.hostName}.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgsPassthrough;
  };
  environment.extraInit =
    "[[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars}";

  users.groups."${username}" = { };

  systemd.tmpfiles = let
    dirs = secrets."home_persist_directories";
  in {
    rules = precreateUserDirectoryRulesDefault dirs;
  };
}
