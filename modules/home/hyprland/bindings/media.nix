{ pkgs, ... }:

{
  services.swayosd.enable = true;
  services.playerctld.enable = true;

  wayland.windowManager.hyprland = {

    settings = {

      "$osdclient" =
        "swayosd-client --monitor \"$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')";

      # laptop multimedia keys
      bindeld = [
        ",XF86AudioRaiseVolume, Volume Up, exec, $osdclient --output-volume raise"
        ",XF86AudioLowerVolume, Volume down, exec, $osdclient --output-volume lower"
        ",XF86AudioMute, Mute, exec, $osdclient --output-volume mute-toggle"
        ",XF86AudioMicMute, Mute microphone, exec, $osdclient --input-volume mute-toggle"
        ",XF86MonBrightnessUp, Brightness up, exec, $osdclient --brightness raise"
        ",XF86MonBrightnessDown, Brightness down, exec, $osdclient --brightness lower"

        # 1% adjustments with alt modifier

        "ALT, XF86AudioRaiseVolume, Volume Up precise, exec, $osdclient --output-volume +1"
        "ALT, XF86AudioLowerVolume, Volume down precise, exec, $osdclient --output-volume -1"
        "ALT, XF86MonBrightnessUp, Brightness up precise, exec, $osdclient --brightness +1"
        "ALT, XF86MonBrightnessDown, Brightness down precise, exec, $osdclient --brightness -1"
      ];

      bindld = [
        ",XF86AudioNext, Next track, exec, $osdclient --playerctl next"
        ",XF86AudioPause, Pause, exec, $osdclient --playerctl play-pause"
        ",XF86AudioPlay, Play, exec, $osdclient --playerctl play-pause"
        ",XF86AudioPrev, Previous track, exec, $osdclient --playerctl previous"
      ];

    };
  };
}
