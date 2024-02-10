{ config, ... }: {
  boot = {
    kernel = {
      sysctl = {
        "fs.file-max" = 9223372036854775807;
        "fs.aio-max-nr" = 19349474;
        "fs.aio-nr" = 0;
        "fs.epoll.max_user_watches" = 39688724;
      };
    };
  };
}
