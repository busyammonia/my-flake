{ pkgs, config, ... }: {
  services.irqbalance = {
    enable = true;
  };
}
