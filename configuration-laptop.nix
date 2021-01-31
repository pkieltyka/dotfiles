# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

let secrets = import /etc/nixos/secrets.nix; in

{ config, pkgs, options, lib, ... }:

{
  system.copySystemConfiguration = true;

  imports = [
    <nixos-hardware/lenovo/thinkpad/x1/6th-gen>
    /etc/nixos/hardware-configuration.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "p7zip-16.02"
  ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelModules = [ "acpi_call" "kvm-intel" ];
    blacklistedKernelModules = [ "mei_me" ];
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "DejaVu Sans Mono";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    wget
    git
    mkpasswd
    fwupd
    unzip
    p7zip
    dmidecode
    xorg.xinit
    bluez
  ];

  # environment.shellAliases = {
  #   vim = "nvim";
  # };

  fonts.fonts = with pkgs; [
    font-awesome-ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    google-fonts
    dejavu_fonts
    powerline-fonts
    source-code-pro
  ];

  # Networking
  networking.hostName = "pak";
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [
    3000 3001
    8010        # VLC Chromecast
  ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  # battery saver auto tune
  powerManagement.powertop.enable = true;

  services = {
    fwupd.enable = true;

    dnsmasq.enable = true;
    dnsmasq.servers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];
    
    localtime.enable = true;

    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      # desktopManager.default = "none+none";
      layout = "us";

      # Enable touchpad support.
      libinput = {
        enable = true;
        accelProfile = "adaptive";
        accelSpeed = "0.6";
        clickMethod = "clickfinger";
      };
    };

    openssh = {
      enable = false;
      forwardX11 = true;
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint gutenprintBin brlaser
      ];
    };

    usbmuxd.enable = true;
  };

  services.udev.extraRules = ''
    # Nano S
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001|1000|1001|1002|1003|1004|1005|1006|1007|1008|1009|100a|100b|100c|100d|100e|100f|1010|1011|1012|1013|1014|1015|1016|1017|1018|1019|101a|101b|101c|101d|101e|101f", TAG+="uaccess", TAG+="udev-acl", OWNER="peter"
    # qmk keyboard
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", MODE:="0666" OWNER="peter"
  '';

  # Resolution
  services.xserver.dpi = 210;
  fonts.fontconfig.dpi = 210;

  services.xserver.monitorSection = ''
    DisplaySize 310 174   # In millimeters
  '';

  programs.light.enable = true;
  programs.adb.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;


  # https://wiki.archlinux.org/index.php/Bluetooth_headset#Apple_Airpods_have_low_volume
  systemd.services.bluetooth.serviceConfig.ExecStart = [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd --noplugin=avrcp"
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  services.gvfs.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = false; # kvm

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
  users.users.root.hashedPassword = secrets.users.root.hashedPassword;

  users.groups.plugdev = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.peter = {
    isNormalUser = true;
    uid = 1000;
    description = "Peter Kieltyka";
    hashedPassword = secrets.users.peter.hashedPassword;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "sudoers" "docker" "audio" "video" "disk" "networkmanager" "lxd" "adbusers" "libvirtd" "plugdev" ];
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      START_CHARGE_THRESH_BAT0=90
      STOP_CHARGE_THRESH_BAT0=98
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      ENERGY_PERF_POLICY_ON_BAT=powersave
      CPU_SCALING_GOVERNOR_ON_AC=balance-performance
      ENERGY_PERF_POLICY_ON_AC=balance-performance
    '';
  };

  # Disable the "throttling bug fix" -_- https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/cpu-throttling-bug.nix
  systemd.timers.cpu-throttling.enable = lib.mkForce false;
  systemd.services.cpu-throttling.enable = lib.mkForce false;

  system.stateVersion = "23.03";
}