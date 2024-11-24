{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
let
  secrets =
    if builtins.pathExists ./secrets.toml then import ./secrets.nix { inherit pkgs lib; } else { };
in
{
  imports = [
    ./swaywm.nix
    ./hypr.nix
  ];
  home.username = "sirimhrzn";
  home.homeDirectory = "/home/sirimhrzn";
  home.file.".config/kxkbrc" = {
    text = ''
      [$Version]
      update_info=kxkb_variants.upd:split-variants

      [Layout]
      DisplayNames=
      LayoutList=us
      LayoutLoopCount=-1
      Model=pc86
      Options=terminate:ctrl_alt_bksp,compose:rctrl
      ResetOldOptions=true
      SwitchMode=Global
      Use=true
      VariantList=dvorak
    '';
  };

  home.packages = [
    pkgs.kitty-themes
    pkgs.wlsunset
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };

  programs.kitty = {
    enable = true;
    font.name = "Liga SFMono Nerd Font";
    theme = "Darkside";

    settings = {
      background_opacity = "100.0";
      term = "xterm-256color";
      font_size = "11.0";
      font_style = "Medium";
    };
  };
  home.stateVersion = "24.05";
  programs = {
    firefox = {
      enable = true;
    };
    chromium = {
      enable = false;
    };
    home-manager.enable = true;
    starship.enable = false;
    starship.settings = {
      hostname.ssh_only = true;
      hostname.style = "bold green";
      character = {
        success_symbol = "[➜](white)";
        error_symbol = "[✗](white)";
      };
    };

    fzf.enable = true;
    fzf.enableZshIntegration = true;
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;

    direnv.enable = true;
    direnv.enableZshIntegration = true;
    direnv.nix-direnv.enable = true;

    git = {
      enable = true;
      package = unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "shirishmaharjan64@gmail.com";
      userName = "sirimhrzn";
    };
  };
  programs.zsh =
    let
      secret_exports =
        if builtins.pathExists ./secret_exports then builtins.readFile ./secret_exports else "";
    in
    {
      enable = true;
      autocd = true;
      autosuggestion.enable = false;
      defaultKeymap = "emacs";
      history.size = 100000;
      history.save = 100000;
      history.expireDuplicatesFirst = true;
      history.ignoreDups = true;
      history.ignoreSpace = true;
      historySubstringSearch.enable = true;

      shellAliases = {
        nnn = "bash ~/Documents/geniusvpn/startgpn.sh";
        zel = "zellij -l ~/layout.kdl";
        nv = "fzf | xargs nvim";
        gl = "git log --oneline";
        idid = "nvim ~/idid.md";
        ket = "kubectl get pods | rg ";
        kex = "kubectl exec -it ";
        k = "kubectl";
        d = "docker";
        dc = "docker compose";
        ".." = "cd ..";
        "...." = "cd ../..";
        cal = "php -S 0.0.0.0:8001 -t public";
        news = "php artisan serve --port 8002";
        rad = "php artisan serve --port 8003";
        ni = "nvim ~/nixos";
        gc = "git checkout";
        gpo = "git push origin";
      };

      envExtra = ''
        export PATH=$PATH:$HOME/.local/bin
        export KUBE_EDITOR=nvim
        export EDITOR=nvim
        ${if builtins.pathExists ./secrets.toml then secrets.secret.mariaDbHooks else ""}
        ${secret_exports}
      '';
    };
}
