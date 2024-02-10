{ config, ... }: {
  boot = {
    kernelModules = [ "veth" "xt_comment" "xt_CHECKSUM" "xt_MASQUERADE" "vhost_vsock" "iptable_mangle" ];
    kernel = {
      sysctl = {
        "kernel.keys.maxkeys" = 2000;
        "kernel.keys.maxbytes" = 2000000;
        "net.core.bpf_jit_limit" = 1000000000;
        "kernel.dmesg_restrict" = 1;
        "net.ipv4.neigh.default.gc_thresh3" = 8192;
        "net.ipv6.neigh.default.gc_thresh3" = 8192;
        "fs.inotify.max_queued_events" = 1048576;
        "fs.inotify.max_user_instances" = 1048576;
        "fs.inotify.max_user_watches" = 1048576;
      };
    };
  };
}
