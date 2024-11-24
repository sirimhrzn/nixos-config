{ config, ... }:
{
  services.grafana = {
    enable = false;
    settings = {
      server = {
        http_port = 2362;
        http_addr = "0.0.0.0";
      };
    };
  };
}
