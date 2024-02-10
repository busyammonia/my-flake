{ lib, ... }: {
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_MESSAGES = lib.mkDefault "en_US.UTF-8";
      LC_ADDRESS = lib.mkDefault "ru_RU.UTF-8";
      LC_CTYPE = lib.mkDefault "ru_RU.UTF-8";
      LC_IDENTIFICATION = lib.mkDefault "ru_RU.UTF-8";
      LC_MEASUREMENT = lib.mkDefault "ru_RU.UTF-8";
      LC_MONETARY = lib.mkDefault "ru_RU.UTF-8";
      LC_NAME = lib.mkDefault "ru_RU.UTF-8";
      LC_NUMERIC = lib.mkDefault "ru_RU.UTF-8";
      LC_PAPER = lib.mkDefault "ru_RU.UTF-8";
      LC_TELEPHONE = lib.mkDefault "ru_RU.UTF-8";
      LC_TIME = lib.mkDefault "ru_RU.UTF-8";
    };
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };
  time.timeZone = lib.mkDefault "Europe/Moscow";
}