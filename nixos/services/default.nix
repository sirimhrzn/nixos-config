{ config, ... }:
{
  imports = [
    ./grafana.nix
    ./nix-ci.nix
  ];

  services.redis = {
    servers = {
      "localhost" = {
        enable = true;
        port = 6379;
        requirePass = null;
        bind = "127.0.0.1";
      };
    };
  };
}
