{ pkgs, lib, ... }:
with lib;

let
  machine = import ~/.dotfiles/machine.nix;

  ws = {
    _1 = "1: >_";
    _2 = "2: dev";
    _3 = "3: www";
    _4 = "4: docs";
    _5 = "5";
    _6 = "6";
    _7 = "7: email";
    _8 = "8: chat";
    _9 = "9: music";
    _10 = "10: sys";
    _11 = "11";
    _12 = "12";
    _13 = "13";
    _14 = "14";
    _15 = "15";
    _16 = "16";
    _17 = "17";
    _18 = "18";
    _19 = "19";
    _20 = "20";
  };

  mod = if (machine == "desktop") then "Mod4" else "Mod3";
  modc = "Control";
  moda = "Mod1";

in

{
  enable = true;
  package = pkgs.i3-gaps;
  config = {
    gaps = {
      inner = 8;
      outer = 0;
      smartBorders = "on";
    };
    modifier = mod;
    keybindings = {
      "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +3%";
      "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -3%";
      "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle # mute sound";
      "XF86MonBrightnessUp" = "exec --no-startup-id light -A 10";
      "XF86MonBrightnessDown" = "exec --no-startup-id light -U 10";
      "${mod}+XF86MonBrightnessUp" = "exec --no-startup-id light -A 2";
      "${mod}+XF86MonBrightnessDown" = "exec --no-startup-id light -U 2";
      "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute 1 toggle";
      "XF86Display" = "exec autorandr -c";
      "${mod}+XF86Display" = "exec ls ~/.screenlayout/* | rofi -dmenu | xargs -r -t sh"; # Screen mode switcher
      "${mod}+Shift+XF86Display" = "exec xrandr --auto"; # Reset screen
      
      #
      # App hotkeys
      #
      "${mod}+Return" = "exec --no-startup-id kitty";

      # File manager
      "${mod}+Shift+Return" = "exec ~/.bin/i3-powertools app open --new.floating --new.exec='nautilus --new-window'";

      # Chrome
      "${mod}+s" = "exec ~/.bin/i3-powertools app open --focus.class=Google-chrome --new.exec='google-chrome-stable --new-window'";
      "${mod}+${modc}+s" = "exec ~/.bin/i3-powertools app open --new.exec='google-chrome-stable --new-window'";

      # Mail
      "${mod}+m" = "exec ~/.bin/i3-powertools app open --focus.mark=email --focus.class=firefox --new.mark=email --new.workspace='7: email' --new.exec='firefox --new-window https://mail.google.com'";

      # Discord
      "${mod}+d" = "exec ~/.bin/i3-powertools app open --focus.class=discord --new.workspace='8: chat' --new.exec='Discord'";

      # Terminal
      "${mod}+t" = "exec ~/.bin/i3-powertools app open --focus.class=kitty --new.exec='kitty'";

      # Editor
      "${mod}+e" = "exec ~/.bin/i3-powertools app open --focus.class=Code --new.exec='code'";

      # Spotify
      "${mod}+i" = "exec ~/.bin/i3-powertools app open --focus.class=Spotify --new.workspace='9: music' --new.exec='spotify'";

      # Sys journal terminal
      "${mod}+z" = "exec ~/.bin/i3-powertools app open --focus.mark=systail --new.mark=systail --new.workspace='10: sys' --new.exec='kitty -e journalctl -f'";

      # Project
      #"${mod}+o" = "exec ~/.bin/i3-powertools app open --focus.mark=project --focus.class=google-chrome --new.mark=project --new.workspace='15' --new.exec='google-chrome-stable --new-window https://github.com/horizon-games/SkyWeaver/projects/16?fullscreen=true'";


      #--

      "${modc}+q" = "kill";
    
      "${mod}+Shift+Up" = "exec --no-startup-id xrandr --output DP-1 --brightness 1";
      "${mod}+Shift+Down" = "exec --no-startup-id xrandr --output DP-1 --brightness 0.85";

      "${mod}+slash" = "exec playerctl play-pause";
      "${mod}+period" = "exec playerctl next";
      "${mod}+comma" = "exec playerctl previous";

      "${modc}+space" = "exec rofi -show drun -show-icons";
      #"${modc}+Mod1+space" = "exec rofi -show window";
      "${modc}+Tab" = "exec rofi -show window -show-icons";
      "${mod}+p" = "exec rofi -show window -show-icons";

      # switch window focus
      "${mod}+Left" = "focus left";
      "${mod}+Down" = "focus down";
      "${mod}+Up" = "focus up";
      "${mod}+Right" = "focus right";
      # "${mod}+Shift+Left" = "focus parent; focus left";
      # "${mod}+Shift+Down" = "focus parent; focus down";
      # "${mod}+Shift+Up" = "focus parent; focus up";
      # "${mod}+Shift+Right" = "focus parent; focus right";

      # "${mod}+Tab" = "i3-powertools -- on release, go to prev window
      # mod+tab+left/right etc.. go to direction you select
      # mod+tidle i3-powertools, go to prev workspace

      # move window position
      "${mod}+Control+Left" = "move left";
      "${mod}+Control+Down" = "move down";
      "${mod}+Control+Up" = "move up";
      "${mod}+Control+Right" = "move right";

      # split in horizontal/vertifical orientation
      "${mod}+h" = "split h";
      "${mod}+v" = "split v";

      # enter fullscreen mode for the focused container
      "${mod}+f" = "fullscreen toggle";

      # change container layout (toggle split, stacking, tabbed)
      "${mod}+o" = "layout toggle tabbed split";
      #"${mod}+${modc}+d" = "layout tabbed";

      # toggle tiling / floating
      "${mod}+space" = "floating toggle";

      # change focus between tiling / floating windows
      # "${mod}+i" = "focus mode_toggle";

      # focus the parent container
      "${mod}+${modc}+minus" = "focus parent";

      # focus the child container
      "${mod}+${modc}+equal" = "focus child";

      # switch to workspace
      "${mod}+1" = "workspace ${ws._1}";
      "${mod}+2" = "workspace ${ws._2}";
      "${mod}+3" = "workspace ${ws._3}";
      "${mod}+4" = "workspace ${ws._4}";
      "${mod}+5" = "workspace ${ws._5}";
      "${mod}+6" = "workspace ${ws._6}";
      "${mod}+7" = "workspace ${ws._7}";
      "${mod}+8" = "workspace ${ws._8}";
      "${mod}+9" = "workspace ${ws._9}";
      "${mod}+0" = "workspace ${ws._10}";
      "${mod}+Shift+1" = "workspace ${ws._11}";
      "${mod}+Shift+2" = "workspace ${ws._12}";
      "${mod}+Shift+3" = "workspace ${ws._13}";
      "${mod}+Shift+4" = "workspace ${ws._14}";
      "${mod}+Shift+5" = "workspace ${ws._15}";
      "${mod}+Shift+6" = "workspace ${ws._16}";
      "${mod}+Shift+7" = "workspace ${ws._17}";
      "${mod}+Shift+8" = "workspace ${ws._18}";
      "${mod}+Shift+9" = "workspace ${ws._19}";
      "${mod}+Shift+0" = "workspace ${ws._20}";

      # move focused container to workspace
      "${modc}+${mod}+1" = "move container to workspace ${ws._1}";
      "${modc}+${mod}+2" = "move container to workspace ${ws._2}";
      "${modc}+${mod}+3" = "move container to workspace ${ws._3}";
      "${modc}+${mod}+4" = "move container to workspace ${ws._4}";
      "${modc}+${mod}+5" = "move container to workspace ${ws._5}";
      "${modc}+${mod}+6" = "move container to workspace ${ws._6}";
      "${modc}+${mod}+7" = "move container to workspace ${ws._7}";
      "${modc}+${mod}+8" = "move container to workspace ${ws._8}";
      "${modc}+${mod}+9" = "move container to workspace ${ws._9}";
      "${modc}+${mod}+0" = "move container to workspace ${ws._10}";
      "${modc}+${mod}+Shift+1" = "move container to workspace ${ws._11}";
      "${modc}+${mod}+Shift+2" = "move container to workspace ${ws._12}";
      "${modc}+${mod}+Shift+3" = "move container to workspace ${ws._13}";
      "${modc}+${mod}+Shift+4" = "move container to workspace ${ws._14}";
      "${modc}+${mod}+Shift+5" = "move container to workspace ${ws._15}";
      "${modc}+${mod}+Shift+6" = "move container to workspace ${ws._16}";
      "${modc}+${mod}+Shift+7" = "move container to workspace ${ws._17}";
      "${modc}+${mod}+Shift+8" = "move container to workspace ${ws._18}";
      "${modc}+${mod}+Shift+9" = "move container to workspace ${ws._19}";
      "${modc}+${mod}+Shift+0" = "move container to workspace ${ws._20}";

      # move worksapce to other monitor
      "${mod}+${modc}+n" = "move workspace to output up";
      "${mod}+${modc}+m" = "move workspace to output down";

      # Workspaces and multiple monitors
      "${mod}+${moda}+Left" = "move workspace to output left";
      "${mod}+${moda}+Right" = "move workspace to output right";
      "${mod}+${moda}+Up" = "move workspace to output up";
      "${mod}+${moda}+Down" = "move workspace to output down";

      # next/prev workspace
      "${mod}+Next" = "exec ~/.bin/i3-powertools workspace switch next";
      "${mod}+Prior" = "exec ~/.bin/i3-powertools workspace switch prev";

      "${mod}+bracketright" = "workspace next";
      "${mod}+bracketleft" = "workspace prev";

      "${mod}+l" = "exec ~/.scripts/screenlock";
      "${mod}+Shift+l" = "exec ~/.scripts/screenoff";

      "${mod}+r" = "mode resize";

      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      "${mod}+Shift+r" = "restart";

      # exit i3 (logs you out of your X session)
      "${mod}+Shift+e" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'\"";

      # pick a new wallpaper
      "${mod}+Shift+w" = "exec ~/.scripts/set-wallpaper.sh";

      #
      "${mod}+semicolon" = "move scratchpad";

      #
      "${mod}+apostrophe" = "scratchpad show";
    };
    # colors = with theme; {
    #   background = hex.background;
    #   focused = {
    #     border = hex.background;
    #     background = hex.background;
    #     text = hex.foreground;
    #     indicator = hex.background;
    #     childBorder = hex.foreground;
    #   };
    #   focusedInactive = {
    #     border = hex.background;
    #     background = hex.background;
    #     text = hex.foreground;
    #     indicator = hex.background;
    #     childBorder = hex.background;
    #   };
    #   unfocused = {
    #     border = hex.background;
    #     background = hex.background;
    #     text = hex.foreground;
    #     indicator = hex.background;
    #     childBorder = hex.background;
    #   };
    #   urgent = {
    #     border = hex.background;
    #     background = hex.background;
    #     text = hex.foreground;
    #     indicator = hex.background;
    #     childBorder = hex.background;
    #   };
    #   placeholder = {
    #     border = hex.background;
    #     background = hex.background;
    #     text = hex.foreground;
    #     indicator = hex.background;
    #     childBorder = hex.background;
    #   };
    # };
    modes = {
      # resize window (you can also use the mouse for that)
      resize = {
        # same bindings, but for the arrow keys
        "Left" = "resize shrink width 10 px or 10 ppt";
        "Down" = "resize grow height 10 px or 10 ppt";
        "Up" = "resize shrink height 10 px or 10 ppt";
        "Right" = "resize grow width 10 px or 10 ppt";
        "Escape" = "mode default";
        "Return" = "mode default";
        "${mod}+r" = "mode default";
      };
    };
    fonts = ["DejaVu Sans Mono 10"];
    bars = [{
      trayOutput = "primary";
      fonts = [ "DejaVu Sans Mono, Font Awesome 5 Free 10" ];
      position = "bottom";
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.dotfiles/config/i3status/status.toml";
      # colors = with theme; {
      #   background = hex.background;
      #   statusline = hex.foreground;
      #   separator = hex.foreground;
      #   focusedWorkspace = { border = hex.color4; background = hex.foreground; text = hex.background; };
      #   activeWorkspace = { border = hex.color4; background = hex.background; text = hex.foreground; };
      #   inactiveWorkspace = { border = hex.black; background = hex.black; text = hex.foreground; };
      #   urgentWorkspace = { border = hex.red; background = hex.red; text = hex.black; };
      # };
      colors = {
        background = "#222222";
        separator = "#666666";
        statusline = "#dddddd";
        focusedWorkspace = { border = "#0088CC"; background = "#0088CC"; text = "#ffffff"; };
        activeWorkspace = { border = "#333333"; background = "#333333"; text = "#ffffff"; };
        inactiveWorkspace = { border = "#333333"; background = "#333333"; text = "#888888"; };
        urgentWorkspace = { border = "#2f343a"; background = "#900000"; text = "#ffffff"; };
      };
    }];
    focus = {
      newWindow = "urgent";
    };
    window = {
      border = 2;
      titlebar = false;
    };
    floating = {
      modifier = "${mod}";
      criteria = [
        { "window_type"="dialog"; }
        { "window_type"="menu"; }
        { "window_role"="pop-up"; } # how to disable pop for chrome devtools?  "title"="^(?!DevTools - .*$))";
      ];
    };
    startup = [
      # xresources
      { command = "xrdb -merge ~/.Xresources"; notification = false; }

      # key rate
      { command = "xset r rate 175 30"; notification = false; }

      # detect screens
      { command = "autorandr -c"; always = true; notification = false; }

      # turn off screen after 5min
      { command = "xset dpms 300"; notification = false; }

      # go to first workspace
      { command = "i3-msg workspace '${ws._1}'"; notification = false; }

      # network
      { command = "nm-applet"; notification = false; }

      # wallpaper
      { command = "~/.scripts/set-wallpaper.sh"; notification = false; }

      # unclutter makes the mouse invisible after a brief period
      { command = "unclutter"; notification = false; }

      # scratchpad terminal
      { command = "kitty --name=scratchterm"; notification = false; }

    ] ++ optionals (machine == "laptop") [

      # keyboard override
      { command = "xmodmap ~/.xmodmap"; notification = false; }

      # bluetooth
      { command = "blueman-applet"; notification = false; }

    ];
  };
  extraConfig = ''
    #--
    set $fg #f0f0f0
    set $bg #000000
    set $black #f0f0f0
    set $highlight #ff0000

    # set $focused #E69543
    # set $focused #C55E33
    set $focused #f1c691

    # class                 border  backgr. text    indicator child_border
    client.focused          #002b36 #002b36 #ffffff #2e9ef4   $focused
    client.focused_inactive #333333 #5f676a #ffffff #484e50   #5f676a
    client.unfocused        #333333 #222222 #888888 #292d2e   #222222
    client.urgent           #2f343a #900000 #ffffff #900000   #900000
    client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c

    client.background       #ffffff
    #--

    workspace_auto_back_and_forth yes
    focus_on_window_activation focus

    for_window [class=".*"] border pixel 2

    # screenshot, clip
    bindsym --release ${mod}+Shift+p exec maim -s | xclip -selection clipboard -t "image/png"

    # screenshot, full screen
    bindsym --release ${mod}+${moda}+p exec --no-startup-id maim ~/Pictures/screenshot-$(date +%s).png

    # switch workspace with mod + mouse wheel/scroll
    bindsym --whole-window --border ${mod}+button4 exec ~/.bin/i3-powertools workspace switch prev
    bindsym --whole-window --border ${mod}+button5 exec ~/.bin/i3-powertools workspace switch next

    # Scratchpad terminal
    for_window [instance="scratchterm"] floating enable
    for_window [instance="scratchterm"] move scratchpad
    for_window [instance="scratchterm"] border pixel 4
    for_window [instance="scratchterm"] resize set 1600px 1000px
    bindsym ${mod}+backslash [instance="scratchterm"] scratchpad show

    # File manager, floating
    for_window [class="Org.gnome.Nautilus"] floating enable

    # Screen recorder, floating
    for_window [class="SimpleScreenRecorder"] floating enable
  '';
}
