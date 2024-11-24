{
  config,
  lib,
  pkgs,
  windowManager,
  ...
}:
let
  smod = config.wayland.windowManager.sway.config.modifier;
in
{
  wayland.windowManager.sway = {
    enable = if windowManager == "sway" then true else false;
    checkConfig = false;
    package = pkgs.sway;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      startup = [
        { command = "waybar"; }
        { command = "nm-applet"; }
        { command = "blueman-applet"; }
        { command = "swww-daemon"; }
        # { command = "swww img ~/Downloads/doybuda.jpeg"; }
      ];
      keybindings = lib.mkOptionDefault {
        "${smod}+d" = "exec pkill -x rofi || rofi -show drun";
        "${smod}+t" = "exec ${terminal}";
        "XF86AudioMute" = "exec pamixer --toggle-mute";
        "XF86AudioRaiseVolume" = "exec  pamixer --increase 5";
        "XF86AudioLowerVolume" = "exec  pamixer --decrease 5";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "${smod}+n" = "exec pkill wl-sunset || wlsunset -T 4500";
        "${smod}+p" = "exec grimblast copysave area";
        "${smod}+m" = "exec appimage-run ~/Downloads/bruno_1.32.0_x86_64_linux.AppImage";
      };
      bars = [ ];
      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "type:keyboard" = {
          repeat_delay = "300";
          repeat_rate = "80";
        };
      };
    };
    extraConfig = ''
            #swayfx config
            # blur enable
            # blur_xray disable
            # blur_passes 2
            # blur_radius 5
            # # Window border settings
            default_border none
      	default_floating_border none
      	titlebar_padding 1
      	titlebar_border_thickness 0
            # # Additional window rules (optional)
            # for_window [app_id=".*"] opacity 0.90
            # for_window [class=".*"] opacity 0.90
    '';
  };
}
