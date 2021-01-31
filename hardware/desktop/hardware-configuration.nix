# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      systemd-boot.configurationLimit = 20;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      # stage-1 kernel modules
      kernelModules = [
        "dm-snapshot"
      ];
      availableKernelModules = [
        "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"
        "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd"
      ];

      # pass-through the guest gpu to vfio-pci (the rx 5700)
      preDeviceCommands = ''
        #    | rx 5700                 | usb-ctrlr  |
        DEVS="0000:0f:00.0 0000:0f:00.1 0000:06:00.0"
        for DEV in $DEVS; do
          echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
        done
        modprobe vfio_pci
      '';
    };

    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPatches = [ { name = "navi-reset.patch"; patch = ./navi-reset.patch; } ];
    
    # vfio for: 5700xt-video,5700xt-audio,usb-controller
    kernelParams = [
      "quiet" "iommu=pt" "amd_iommu=on" "pcie_aspm=off"
      "video=vesafb:off,efifb:off"
    ];

    # kernel modules in stage-2
    kernelModules = [
      "kvm-amd" "amdgpu"
    ];
  };

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/e84f094c-111c-4f67-a076-62038dc8d9e4";
      preLVM = true;
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/389d0035-873e-4ef7-94b5-07f0703ca288";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A755-FDFB";
      fsType = "vfat";
    };


  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 32;

  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
