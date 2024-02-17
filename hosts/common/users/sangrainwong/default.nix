{ pkgs, inputs, config, self, secrets, specialArgsPassthrough, username
, hostname, homeDirectory, configName, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  homeManagerConfigUserName = configName;
  precreateUserDirectoryRules = (persistPath: perm: user: group: dirs:
    builtins.map
    (dir: "d ${persistPath}/${user}/${dir} ${perm} ${user} ${group} - -") dirs);
  precreateUserDirectoryRulesPerm = precreateUserDirectoryRules "/zhome" "0700";
  precreateUserDirectoryRulesDefault =
    precreateUserDirectoryRulesPerm username "users";
  persistPath = "/zhome/${username}";
  _persist = user: group: perm: dir: {
    directory = dir;
    user = user;
    group = group;
    mode = perm;
  };
  persistDefault = dirs:
    builtins.map (dir: _persist username username dir.perm dir.path) dirs;
  homeManagerSessionVars =
    "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  users.mutableUsers = true;
  sops = {
    age.keyFile = "/persist/keys/${configName}.agekey"; # must have no password!
    defaultSopsFile = "${self}/secrets/${configName}/secrets.json";
    secrets."${configName}_password_hash" = { neededForUsers = true; };
  };
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

    hashedPasswordFile = config.sops.secrets."${configName}_password_hash".path;
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

  environment.persistence = let
    dirs = builtins.map (x: {
      directory = x;
      mode = "u=rwx,g=,o=";
    }) secrets."home_persist_directories";
  in {
    "${persistPath}" = {
      hideMounts = true;
      users."${username}" = {
        home = homeDirectory;
        directories = dirs;
      };
    };
  };
}
