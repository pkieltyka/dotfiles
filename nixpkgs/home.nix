{ pkgs, lib, ... }:
with lib;

let
  machine = import ~/.dotfiles/machine.nix;
  theme = import ./theme.nix;
  git-quick-stats = import ./git-quick-stats;
  # hyper = pkgs.callPackage ./hyper/default.nix { };

  # mozilla = import (builtins.fetchGit {
  #   url = "https://github.com/mozilla/nixpkgs-mozilla.git";
  #   ref = "master";
  #   rev = "d46240e8755d91bc36c0c38621af72bf5c489e13";
  # });

  # nixpkgs = import <nixpkgs> {
  #   overlays = [ mozilla ];
  # };

in

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.0.2u"
    "p7zip-16.02"
  ];

  nixpkgs.config.allowBroken = true;
  
  programs.home-manager.enable = true;

  # nixpkgs.overlays = [
  #   mozilla
  #   (self: super: {
  #     latest = {
  #       rustChannels.nightly.rust = (nixpkgs.rustChannelOf { date = "2019-10-01"; channel = "nightly"; }).rust.override {
  #         targets = [
  #           "wasm32-unknown-unknown"
  #         ];

  #         extensions = [
  #           "rustfmt-preview"
  #           "rls-preview"
  #           "clippy-preview"
  #           "rust-src"
  #         ];
  #       };
  #     };
  #   })
  # ];

  home.packages = with pkgs; [
    # system utils
    htop
    gotop
    mtr
    xclip
    psmisc
    acpi
    sysstat
    lm_sensors
    file
    xorg.xev
    openssl
    rename
    usbutils
    ffmpeg
    pciutils
    s-tui
    stress
    xorg.xmodmap
    xorg.xdpyinfo
    nix-index

    whois
    tmux
    arandr
    # wine
    docker-compose

    # languages & build tools
    gcc8
    go
    #tinygo
    cloc

    nvme-cli

    gnumake
    binutils
    lua
    python
    python3Full
    python37Packages.pip
    # python37Packages.pip-tools
    python37Packages.setuptools
    
    ruby
    cmake

    (yarn.override {
      # nodejs = nodejs_latest;
      nodejs = nodejs-14_x;
    })
    nodejs-14_x

    ms-sys
    git-quick-stats
    ansible
    glslang
    gitg
    lsof
    parallel
    graphviz

    libudev
    # nodePackages.node-gyp
    libusb

    # hyper
    ngrok-2

    ## latest.rustChannels.nightly.rust
    rustc
    rustfmt
    cargo
    cargo-edit

    # i3lock-color
    # i3lock-pixeled
    i3lock

    ngrok-2

    rubyPackages_2_6.sqlite3
    #sqlite

    # desktop env
    pywal
    i3status-rust
    srandrd
    gnome3.dconf
    maim
    pavucontrol
    feh
    libnotify
    inotify-tools
    # xwobf
    blueman
    exa
    gitAndTools.git-extras
    playerctl
    unclutter
    redshift
    networkmanagerapplet

    # apps
    appimage-run
    google-chrome
    vscode
    kitty
    pcmanfm
    gnome3.eog
    # gnome3.gucharmap
    gnome3.nautilus
    neofetch
    simplescreenrecorder
    gimp
    vlc
    xfce.thunar
    spotify
    git-lfs
    brave
    irssi
    xournal
    libreoffice-fresh
    font-manager
    slack
    powerstat
    transmission-gtk
    xorg.xkill
    webtorrent_desktop
    nmap
    jq
    xdotool
    openvpn
    xorg.xwininfo
    gparted
    ntfsprogs
    gnome3.gnome-disk-utility
    unetbootin
    blueman

    gnupg
    
    xsensors

    dmg2img

    # android
    android-studio
    jdk
    androidenv.androidPkgs_9_0.platform-tools

    # rice
    lxappearance
    hicolor-icon-theme
    
    # chat
    weechat
    discord

    minikube
    kubectl
    google-cloud-sdk

    trickle
    # zoom-us
    jetbrains.datagrip

    pspp
    memtester
  ];

  programs.zsh = import ./zsh.nix pkgs;
  programs.rofi = import ./rofi.nix pkgs;
  programs.autorandr = import ./autorandr.nix pkgs;

  home.file.".tmux.conf".source = ../config/tmux.conf;
  home.file."./.config/kitty/kitty.conf".source = ../config/kitty/kitty.conf;

  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "peter.kieltyka@gmail.com";
    userName = "Peter Kieltyka";
    aliases = {
      co = "checkout";
      s = "status";
      ci = "commit";
      b = "branch";
      undo = "reset --soft HEAD^";
      last = "log 1 HEAD";
      diff2 = "diff --color-words --ignore-all-space --patience";
    };
    extraConfig = {
      branch."master" = {
        remote = "origin";
        merge = "refs/heads/master";
      };
      core.editor = "code --wait";
      push.default = "current";
      pull.rebase = "false";
      diff.tool = "default-difftool";
      url."git@github.com:".insteadOf = "https://github.com/";
      http = {
      	postBuffer = 524288000;
      };
    };
  };

  programs.firefox = {
    enable = true;
    # enableIcedTea = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  gtk = {
    enable = true;
    font = {
      package = pkgs.google-fonts;
      name = "Open Sans 10";
      # package = pkgs.noto-fonts;
      # name = "Noto Sans 10";
    };
    theme = {
      package = pkgs.theme-vertex;
      name = "Vertex-Dark";
    };
    iconTheme = {
      package = pkgs.tango-icon-theme;
      name = "Tango";
    };
    gtk3.extraConfig = {
      gtk-decoration-layout = "appmenu,menu";
    };
  };


  # Services
  services.dunst = import ./dunst.nix pkgs;
  services.redshift = import ./redshift.nix pkgs;
  # services.compton = import ./compton.nix pkgs;


  # X
  xsession = {
    enable = true;
    windowManager.i3 = import ./i3.nix pkgs;

    pointerCursor = {
      name = "Vanilla-DMZ-AA";
      package = pkgs.vanilla-dmz;
      size = 32;
    };
  };

  xresources.properties = {
    "Xft.dpi" = 140; # = 210 / 1.5
  };

  home.file.".xinitrc".text = ''
    #!/bin/sh
    [ -f ~/.xprofile ] && . ~/.xprofile
    export TERMINAL=kitty
    exec dbus-launch --exit-with-x11 i3
  '';

  # laptop only
  home.file.".xmodmap".text = if (machine == "desktop") then "" else ''
   ! Swap windows and alt keys
    remove mod1 = Alt_L
    add control = Alt_L
    clear mod4
    add mod1 = Super_L

    ! set caps lock key to mod3
    clear lock
    keycode 66 = Hyper_R
    add mod3 = Hyper_R

    ! set print screen to mod3 as well
    keycode 107 = Hyper_R

    ! set left alt key to Control_L (thinking its super/command)
    keycode 64 = Control_L

    ! set super key to Alt_L (swapping windows and alt key)
    keycode 133 = Alt_L
  '';

  # systemd.user.services.lock = {
  #   Unit = {
  #     Description = "Lock Screen When Sleeping";
  #     Before = [ "sleep.target" ];
  #   };
  #   Service = {
  #     Type = "forking";
  #     ExecStart = "${pkgs.maim} /tmp/screen.png && ${xwobf}/bin/xwobf -s 11 /tmp/screen.png && ${pkgs.i3lock}/bin/i3lock -i /tmp/screen.png && rm /tmp/screen.png";
  #     # ExecStartPost = "/run/current-system/sw/bin/sleep 1";
  #   };
  #   Install = {
  #     WantedBy = [ "default.target" ];
  #   };
  # };

}
