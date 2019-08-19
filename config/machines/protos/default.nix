{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ((import ../../sources).nixbot + "/module.nix")
  ];

  mine.mail.enable = true;
  mine.saveSpace = true;
  mine.radicale.enable = true;
  mine.paste.enable = true;
  mine.publicDir.enable = true;
  mine.gitHost.enable = true;
  mine.znc.enable = true;

  mine.dns.enable = true;

  mine.profiles.server.enable = true;

  services.taskserver.enable = true;
  mine.web = {
    enable = true;
    root = "/webroot/www";
    keys.enable = true;
  };

  services.openvpn.servers.protos = {
    mine.type = "server";
    mine.server = {
      subnet = "10.99.0.0/24";
      staticClientIps =
        let clients = builtins.removeAttrs config.networking.connectivitySpec.vpn.protos ["protos"];
        in lib.mapAttrs' (client: lib.nameValuePair "protos-${client}") clients;
    };
  };
  services.openvpn.servers.orakel = {
    mine.type = "client";
    mine.client = {
      serverIp = config.networking.connections.orakel;
      makeDefaultGateway = false;
    };
  };

  services.znapzend = {
    enable = true;
    autoCreation = true;
    pure = true;
    zetup = {
      "tank/root/data" = {
        plan = "1day=>1hour";
        recursive = true;
        destinations.vario = {
          host = config.networking.connections.vario;
          dataset = "main/backup/protos";
          plan = "1day=>1hour,1week=>1day,1month=>1week";
        };
      };
    };
  };

  services.nixbot = {
    enable = true;
    channels = [ "nixos-unstable" "nixos-19.03" "nixos-18.09" ];
    config = {
      users = {
        commands.enable = true;
        nixrepl.enable = true;
        nixrepl.nixPath = [ "nixbotlib=/var/lib/nixbot/lib" ];
      };
      channels.nixos-unregistered.unreg.enable = true;
      channels.home-manager.pr = {
        defaultRepo = "home-manager";
        defaultOwners.home-manager = "rycee";
      };
      channelDefaults = {
        pr.enable = true;
        commands.enable = true;
        nixrepl.enable = true;
        leaked.enable = true;
        karma.enable = true;
        nixrepl.nixPath = [ "nixbotlib=/var/lib/nixbot/lib" ];
        karma.blacklist = [ "c" ];
      };
    };

  };

  services.nginx.virtualHosts."nixbot.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
  };

  users.users.infinisil.extraGroups = [ "nixbot" ];
  users.users.nginx.extraGroups = [ "nixbot" ];

  mine.enableUser = true;

  mine.hardware = {
    cpuCount = 1;
    swap = true;
  };

  boot = {
    loader.grub.device = "/dev/vda";
    zfs.devNodes = "/dev";
    kernelParams = [ "net.ifnames=0" ];
  };

  services.openssh.enable = true;

  networking = {
    domain = "infinisil.com";
    hostName = "protos";
    hostId = "6ad3ae1f";
    defaultGateway = "206.81.16.1";
    defaultGateway6 = "2a03:b0c0:3:d0::1";
    nameservers = [ "1.1.1.1" ];
    interfaces.eth0 = {
      ipv4.addresses = [{
        address = "206.81.23.189";
        prefixLength = 20;
      }];
      ipv6.addresses = [{
        address = "2a03:b0c0:3:d0::5f7f:5001";
        prefixLength = 64;
      }];
      macAddress = "ba:d5:84:08:05:c1";
    };
    interfaces.eth1 = {
      ipv4.addresses = [{
        address = "10.135.238.247";
        prefixLength = 16;
      }];
      macAddress = "4e:5c:97:f6:7e:bc";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIrsQzCzdxcl1O3eE+QNSZGvyehnMJOFLdFX7xIhz/lM infinisil@vario" ];

  system.stateVersion = "19.03";

}
