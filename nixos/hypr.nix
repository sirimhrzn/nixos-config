{
  config,
  lib,
  pkgs,
  windowManager,
  unstable,
  stable,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = if windowManager == "hyprland" then true else false;
    package = stable.hyprland;
    settings = {
      animations = {
        enabled = true;
        # "animation" = "windows, 1, 7, default";
        "animation" = "workspaces, 0, 0, default";
      };
      monitor = "eDP-1,1920x1080,0x0,1";
      general = {
        gaps_in = 4;
        gaps_out = 10;
        border_size = 4;
        "col.active_border" = "rgb(B072D1) rgb(A367C9) rgb(9660C3) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };
      input = {
        # kb_layout = "us,us";
        # kb_variant = ",dvorak";
        # kb_options = "grp:win_space_toggle";
        repeat_rate = 80;
        repeat_delay = 300;

        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
        };
      };
      "$mod" = "SUPER";
      bind =
        [
          ", Print, exec, grimblast copy area"
          "$mod SHIFT,Q ,killactive"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          ) 10
        ));
    };
    extraConfig = ''
                  exec-once = swww-daemon
                  exec-once = nm-applet
                  exec-once = blueman-applet 
                  # exec-once = swww img ~/Downloads/m.jpg
                  exec-once = waybar
                  $mainMod = SUPER
                  $terminal = ghostty

                  bind = SUPER ALT, N, exec, pkill -x wlsunset || wlsunset -T 4500
                  bind = SUPER ALT, W, exec, waybar
                  bind = SUPER ALT, L, exec, pkill waybar
                  bind = $mainMod, D, exec, pkill -x wofi || wofi --show drun
                  bind = $mainMod, T, exec, $terminal
                  bind = $mainMod, N, exec, appimage-run ~/Downloads/AppFlowy-0.7.0-linux-x86_64.AppImage
                  bind = $mainMod, Z, exec, appimage-run ~/Downloads/zen-specific.AppImage
                  bind = $mainMod, M, exec, appimage-run ~/Downloads/bruno_1.32.0_x86_64_linux.AppImage
                  bind = $mainMod, B, exec, dunstctl close-all

      	    # bind = $mainMod, h, layoutmsg, preselect l
      	    # bind = $mainMod, j, layoutmsg, preselect b
      	    # bind = $mainMod, k, layoutmsg, preselect t
      	    # bind = $mainMod, l, layoutmsg, preselect r

                  bind = , XF86AudioMute, exec, pamixer --toggle-mute
                  bind = , XF86AudioRaiseVolume, exec, pamixer --increase 5
                  bind = , XF86AudioLowerVolume, exec, pamixer --decrease 5
                  bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
                  bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
                  bind = $mainMod, P, exec, grimblast copysave area
                  bind = $mainMod, F, fullscreen, 0
                  bind = $mainMod, V, togglefloating,
                  bind = $mainMod, H, movefocus, l
                  bind = $mainMod, L, movefocus, r
                  bind = $mainMod, K, movefocus, u
                  bind = $mainMod, J, movefocus, d


                  bind = $mainMod SHIFT, h, resizeactive, -20 0
            bind = $mainMod SHIFT, j, resizeactive, 0 20
            bind = $mainMod SHIFT, k, resizeactive, 0 -20
            bind = $mainMod SHIFT, l, resizeactive, 20 0


                  env = WLR_RENDERER,pixman
                  env = WLR_NO_HARDWARE_CURSORS,1
                  windowrule = float,^(rofi|blue.*)$
                  windowrule = opacity 0.8 0.7,^(Alacritty|kitty|postman.*)$
                  # windowrule = blur,^(kitty)$
    '';
    systemd = {
      enable = true;
    };
  };
}
