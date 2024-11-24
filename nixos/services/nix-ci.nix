{ config, pkgs, ... }:
{
  services.minio = {
    enable = false;
    consoleAddress = ":9001";
    listenAddress = ":9000";
  };

  services.gitlab-runner = {
    enable = true;
  };
  #services.stunnel = {
  #  enable = false;
  #  clients = {
  #    gitlab-runner = {
  #      accept = "0.0.0.0:3126";
  #      connect = "gitlab.com:443";
  #      verifyChain = true;
  #    };
  #  };
  #};
  #services.nix-serve = {
  #  enable = false;
  #  package = pkgs.nix-serve-ng;
  #  secretKeyFile = "/home/sirimhrzn/nix-ci/tests/cache-keys/minio-local-secret";
  #};
}
