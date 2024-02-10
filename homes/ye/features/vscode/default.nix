{ pkgs, config, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = false;
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "editor.tabSize" = 2;
      "files.autoGuessEncoding" = true;
      "editor.insertSpaces" = true;
    };
  };
}
