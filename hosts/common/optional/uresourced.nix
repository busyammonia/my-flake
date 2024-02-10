{ pkgs, lib, config, ... }: {

  services.uresourced = {
    enable = true;
    extraConfig = ''
      [Global]
      # Protect at maximum 10% of available memory. user.slice system will get a
      # MemoryLow allocation of
      #   min(ActiveUser.MemoryLow * active_users, MaxMemoryLow)
      MaxMemoryMin=10%
      #MaxMemoryLow=0


      [ActiveUser]
      # This creates a memory allocation for the active user.
      MemoryMin=250M
      #MemoryLow=0M
      IOWeight=500
      CPUWeight=500

      [SessionSlice]
      # The following values default to the ones from ActiveUser. By default, this
      # creates a session.slice drop-in configuration with the exact same settings
      # as ActiveUser has.
      # i.e. delegate all the memory to session critical applications and boost them
      # in the same relation as an active user is boosted compared to inactive ones.
      #MemoryMin=250M
      #MemoryLow=0M
      #
      #IOWeight=500
      #CPUWeight=500

      [AppBoost]
      # The following values are used for resource management of user applications.
      # The range for all weights are [1,10000]
      # Default weights apply to an application when it is not active,
      # I.e. the window is not focused. Default value for CPU is 100, IO is 100
      #DefaultCPUWeight=100
      #DefaultIOWeight=100
      # Active weights apply when the window is focused, this is when
      # user is actively interacting with the application/window.
      # If these weights are not set they default to 100 for CPU and 100 for IO,
      # therefore making no difference irrespective of application state.
      ActiveCPUWeight=300
      ActiveIOWeight=300
      # Boost weights act like increments to the active or default weights
      # mentioned previously, these apply to special use-cases like when 
      # an application is playing audio or for a game(detected through GameMode).
      # If these are not set they default to 0 for CPU and 0 for IO (No Boost).
      BoostCPUWeightInc=200
      BoostIOWeightInc=200
    '';
  };

  services.dbus.packages = [
    pkgs.uresourced
  ];
}
