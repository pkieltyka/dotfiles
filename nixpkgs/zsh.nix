let secrets = import /etc/nixos/secrets.nix; in

{ pkgs, ... }:

{
  enable = true;
  enableCompletion = true;
  enableAutosuggestions = true;
  #syntaxHighlighting.enable = true;

  oh-my-zsh = {
    enable = true;
    theme = "robbyrussell";
    plugins = [ "git" "colorize" "z" ];
  };

  shellAliases = {
    open = "xdg-open";
    vim = "nvim";
    gs = "git status";
    g = "lazygit";
  };

  initExtra = ''
    if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
      exec ssh-agent startx
    fi

    #ulimit -n 10000

    export PATH=$PATH:$HOME/.bin:$HOME/.scripts:$HOME/.local/bin

    # Node
    #export N_PREFIX="$HOME/.n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

    # Go
    export GOPATH=$HOME/Dev/go
    export PATH=$PATH:$GOPATH/bin

    # Rust
    #export PATH=$PATH:~/.cargo/bin

    # IPFS
    #export IPFS_PATH=$HOME/.ipfs

    # Java
    #export JAVA_HOME=$(readlink -e $(type -p javac) | sed  -e 's/\/bin\/javac//g')
    export JAVA_HOME=${pkgs.jdk.home}

    # Android
    #export ANDROID_HOME=$HOME/Dev/android/sdk
    #export PATH=$PATH:$ANDROID_HOME/emulator
    #export PATH=$PATH:$ANDROID_HOME/tools
    #export PATH=$PATH:$ANDROID_HOME/tools/bin
    #export PATH=$PATH:$ANDROID_HOME/platform-tools

    # xdg
    #export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/peter/.local/share/flatpak/exports/share

    # stuff
    export EDITOR="code"

    #export MOD_VENDOR=""
    #export GOMODULES="off"

    # for ssh
    export TERM=xterm

  '';
}
