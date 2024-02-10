{ pkgs, config, lib, ... }: {
  security.pam.loginLimits = [{
    domain = "@wheel";
    type = "-";
    item = "nofile";
    value = "1048576";
  }] ++ (map (item: {
    item = item;
    domain = "@wheel";
    type = "-";
    value = "unlimited";
  }) [
    "memlock"
    "fsize"
    "data"
    "rss"
    "stack"
    "cpu"
    "nproc"
    "as"
    "locks"
    "sigpending"
    "msgqueue"
  ]);
}
