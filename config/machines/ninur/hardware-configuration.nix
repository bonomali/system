# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "ohci_pci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  fileSystems."/" =
    { device = "tank/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/94BD-F45B";
      fsType = "vfat";
    };

  fileSystems."/var/lib" =
    { device = "tank/root/data/varlib";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "tank/root/data/home";
      fsType = "zfs";
    };

  fileSystems."/root" =
    { device = "tank/root/data/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "tank/root/nix";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/97dba5c4-d94e-43bf-afac-1d9d38ab94e1"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}