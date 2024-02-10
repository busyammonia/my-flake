{ lib, pkgs, ... }: {
  systemd = {
    enableUnifiedCgroupHierarchy = lib.mkForce true;
    enableCgroupAccounting = lib.mkForce true;
  };

  boot = { kernelParams = [ "systemd.unified_cgroup_hierarchy=1" ]; };
}
