{ lib, secrets, ... }: {
  i18n = {
    defaultLocale = lib.mkForce secrets."default_locale";
    extraLocaleSettings = {
      LC_MESSAGES = lib.mkForce secrets."default_locale";
      LC_ADDRESS = lib.mkForce secrets."specificstuff_locale";
      LC_CTYPE = lib.mkForce secrets."specificstuff_locale";
      LC_IDENTIFICATION = lib.mkForce secrets."specificstuff_locale";
      LC_MEASUREMENT = lib.mkForce secrets."specificstuff_locale";
      LC_MONETARY = lib.mkForce secrets."specificstuff_locale";
      LC_NAME = lib.mkForce secrets."specificstuff_locale";
      LC_NUMERIC = lib.mkForce secrets."specificstuff_locale";
      LC_PAPER = lib.mkForce secrets."specificstuff_locale";
      LC_TELEPHONE = lib.mkForce secrets."specificstuff_locale";
      LC_TIME = lib.mkForce secrets."specificstuff_locale";
    };
    supportedLocales = lib.mkForce secrets."supported_locales";
  };
  time.timeZone = lib.mkForce secrets."timezone";
}