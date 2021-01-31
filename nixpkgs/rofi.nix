{ pkgs, ...}:

let t = import ./theme.nix; in

{
  enable = true;

  # font = "DejaVu Sans Mono 16";

  extraConfig = {
    font = "DejaVu Sans Mono 16";
    line-margin =	"5";
    separator-style =	"solid";

    modi = "drun,window,ssh";
    ssh-client = "ssh";
    ssh-command = "{terminal} -e {ssh-client} {host}";
    run-shell-command = "{terminal} -e {cmd}";

    # ! Background | Foreground | Background (Alternate) | Background (Highlighted) | Foreground (Highlighted)
    color-normal = "argb:00282a36, #f8f8f2, argb:00282a36, #44475a, #f8f8f2";

    # ! Background | Border | Separator
    color-window = "argb:ee282a36, #282a36, #f1fa8c";

    # ! Key bindings
    # kb-row-select:
    # kb-mode-next:

    kb-cancel = "Escape"; #,Control+space,Control+Tab";
  };
}
