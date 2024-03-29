{ pkgs, lib, config, ... }: {
  services.memavaild = {
    enable = true;
    extraConfig = ''
      ## This is memavaild config file.
      ## Lines starting with $ contains required config keys and values.
      ## Lines starting with @ contain optional config keys that may be repeated.
      ## Other lines will be ignored.

      ## condition for starting correction
      $MIN_MEM_AVAILABLE=2.5%

      ## correction step: to what level are we trying to restore available memory
      $TARGET_MEM_AVAILABLE=3%
      $MAX_CORRECTION_STEP_MIB=50

      ## in how many seconds to remove limits if available memory is above the
      ## specified threshold
      $CANCEL_LIMITS_ABOVE_MEM_AVAILABLE=4%
      $CANCEL_LIMITS_IN_TIME=20

      ## remove limits if the free swap volume is below the specified
      $CANCEL_LIMITS_BELOW_SWAP_FREE_MIB=100

      ## monitoring intensity
      $MEM_FILL_RATE=4000
      $MAX_INTERVAL=3
      $MIN_INTERVAL=0.2
      $CORRECTION_INTERVAL=0.1

      $VERBOSITY=1

      $MIN_UID=1000


      @LIMIT  CGROUP=system.slice  MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1

      @LIMIT  CGROUP=user.slice    MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1

      # @LIMIT  CGROUP=user.slice/user-$UID.slice  MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1


      # @LIMIT  CGROUP=user.slice/user-$UID.slice/user@$UID.service/app.slice/app-org.gnome.Terminal.slice  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2

      # @LIMIT  CGROUP=user.slice/user-$UID.slice/user@$UID.service/gnome-terminal-server.service  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2


      # @LIMIT  CGROUP=user.slice/user-$UID.slice/user@$UID.service/idle.slice  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2

      # @LIMIT  CGROUP=idle.slice  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2

      ## set this in ~/.bashrc
      ## alias idle-run='systemd-run --slice=idle.slice --shell'  # on modern Distros
      ## alias idle-run='systemd-run --setenv=XPWD=$PWD --slice=idle.slice --uid=$UID --gid=$UID -t $SHELL'  # on Debian 9
    '';
  };
}
