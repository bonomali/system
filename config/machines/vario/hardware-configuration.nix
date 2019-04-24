# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "uas" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "main";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "main/nix";
      fsType = "zfs";
    };

  fileSystems."/betty" =
    { device = "main/betty";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0072-55B1";
      fsType = "vfat";
    };

  fileSystems."/home/infinisil/music" =
    { device = "main/music";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/bee530de-fa34-4720-b047-121be58dff56"; }
    ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
