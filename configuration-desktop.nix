# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

let secrets = import /etc/nixos/secrets.nix; in

{ config, pkgs, options, lib, ... }:

{
  system.copySystemConfiguration = true;

  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "p7zip-16.02"
  ];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  hardware.bluetooth.enable = false;

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
    bluez
    unzip
    p7zip
    dmidecode
    xorg.xinit
    virtmanager
    qemu
    qemu-utils
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
  networking.hostName = "pakd";
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [
    3000 3001
    4000
    8010        # VLC Chromecast
  ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  services = {
    dnsmasq.enable = true;
    dnsmasq.servers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];
    
    localtime.enable = true;

    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      # desktopManager.default = "none+none";
      layout = "us";

      libinput = {
        enable = true;
        touchpad = {
          accelProfile = "adaptive";
          accelSpeed = "0.6";
          clickMethod = "clickfinger";
        };
      };
    };

    openssh = {
      enable = false;
      forwardX11 = true;
    };

    # avahi = {
    #   enable = true;
    #   nssmdns = true;
    # };

    printing = {
      enable = false;
      # drivers = with pkgs; [
        # gutenprint gutenprintBin brlaser
      # ];
    };

    usbmuxd.enable = true;
  };

  security.pam.loginLimits = [
    { domain = "*"; item = "nofile"; type = "-"; value = "65536"; }
  ];

  # services.udev.extraRules = ''
  #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", ATTRS{idVendor}=="2c97"

  #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", ATTRS{idVendor}=="2581"

  #   # Nano S
  #   SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001|1000|1001|1002|1003|1004|1005|1006|1007|1008|1009|100a|100b|100c|100d|100e|100f|1010|1011|1012|1013|1014|1015|1016|1017|1018|1019|101a|101b|101c|101d|101e|101f", TAG+="uaccess", TAG+="udev-acl"
  # '';

  # Resolution
  services.xserver.dpi = 210;
  fonts.fontconfig.dpi = 210;

  services.xserver.monitorSection = ''
    DisplaySize 310 174   # In millimeters
  '';

  programs.light.enable = true;
  programs.adb.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.gvfs.enable = true;
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  virtualisation.docker.enable = true;

  # kvm / qemu
  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemuVerbatimConfig = ''
      namespaces = []
      clear_emulator_capabilities = 0
      cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero", 
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet"
      ]
    '';
  };

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
  users.users.root.hashedPassword = secrets.users.root.hashedPassword;

  users.groups.plugdev = {};

  users.users.qemu-libvirtd.extraGroups = [ "input" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.peter = {
    isNormalUser = true;
    uid = 1000;
    description = "Peter Kieltyka";
    hashedPassword = secrets.users.peter.hashedPassword;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "sudoers" "docker" "audio" "video" "disk" "networkmanager" "lxd" "adbusers" "libvirtd" "plugdev" ];
  };

  system.stateVersion = "23.03";
}
