{ pkgs, lib, ... }:
let
  conf = lib.importTOML ./secrets.toml;
  database = conf.database;
  concatToStr = f: builtins.concatStringsSep "\n" f;

  hostConfToStrList = builtins.mapAttrs (
    hostName: hostConf: "${hostConf.ip} ${hostConf.hostname}"
  ) conf.hostnames;
  hostConf = concatToStr (builtins.attrValues hostConfToStrList);

  attrToAlias =
    {
      alias,
      host,
      username,
      password,
    }:
    "alias -- '${alias}'='mariadb -h ${host} -u ${username} -p${password}'";
  dbConfigToAlias =
    { conf, env }:
    builtins.mapAttrs (
      alias: dbConfig:
      attrToAlias {
        inherit (dbConfig) password host username;
        alias = "${alias}${env}";
      }
    ) conf;

  envMapped = builtins.mapAttrs (
    env: conf:
    let
      withAliases = dbConfigToAlias { inherit env conf; };
      aliasHook = concatToStr (builtins.attrValues withAliases);
    in
    aliasHook
  ) database.env;
  combinedEnvMappedAlias = concatToStr (builtins.attrValues envMapped);
in
{
  secret = {
    mariaDbHooks = if builtins.pathExists ./secrets.toml then combinedEnvMappedAlias else "";
    hostNameConfig = hostConf;
  };
}
