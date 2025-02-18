# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  swapDevices =
    [ { device = "/dev/disk/by-uuid/06c1de2c-eee3-4df1-b519-df26f1c2bd43"; }
      { device = "/dev/disk/by-uuid/c7313451-73a8-4eeb-911e-2023656865a5"; }
    ];

  boot.swraid = {
    enable = true;
    mdadmConf = ''
      ARRAY /dev/md/md1 level=raid1 num-devices=2 metadata=1.2 name=md1 UUID=dc628a98:9516259e:f8ba977a:eb216ffc
         devices=/dev/sda1,/dev/sdb1
      ARRAY /dev/md/md2 level=raid1 num-devices=2 metadata=1.2 name=md2 UUID=4d91ed60:d2c5b009:52f918cd:7141d124
         devices=/dev/sda2,/dev/sdb2
      MAILADDR andi@andimiller.net
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/md2";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/md1";
      fsType = "ext4";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
