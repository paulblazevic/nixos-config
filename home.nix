{ pkgs, ... }: {
  home.stateVersion = "25.05";

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    extraConfig = ''
      # ──────────────────────── Visuals ────────────────────────
      monitor=,preferred,auto,1.2

      general {
        gaps_in = 6
        gaps_out = 12
        border_size = 2
        col.active_border = rgba(cba6f7ff) rgba(94e2d5ff) 45deg
        col.inactive_border = rgba(45475a88)
        layout = dwindle
      }

      decoration {
        rounding = 12
        blur {
          enabled = true
          size = 8
          passes = 3
          new_optimizations = true
          ignore_opacity = true
        }
        drop_shadow = true
        shadow_range = 20
        shadow_render_power = 4
        col.shadow = rgba(000000aa)
      }

      animations {
        enabled = true
        bezier = ease, 0.4, 0, 0.2, 1
        animation = windows, 1, 4, ease, slide
        animation = fade, 1, 6, ease
        animation = workspaces, 1, 6, ease, slidevert
      }

      # ──────────────────────── Keybinds ────────────────────────
      $mod = SUPER

      bind = $mod, Return, exec, kitty
      bind = $mod, Q, killactive
      bind = $mod, D, exec, wofi --show drun -I
      bind = $mod, Tab, cyclenext
      bind = $mod SHIFT, Tab, cyclenext, prev

      # Move windows
      bind = $mod, h, movefocus, l
      bind = $mod, j, movefocus, d
      bind = $mod, k, movefocus, u
      bind = $mod, l, movefocus, r

      # Workspaces 1-9
      ${builtins.concatStringsSep "\n" (map (i: "bind = $mod, ${toString i}, workspace, ${toString i}") (lib.range 1 9))}
      ${builtins.concatStringsSep "\n" (map (i: "bind = $mod SHIFT, ${toString i}, movetoworkspace, ${toString i}") (lib.range 1 9))}

      # Special keys
      bind = , XF86AudioPlay, exec, playerctl play-pause
      bind = , XF86AudioNext, exec, playerctl next
      bind = , XF86AudioPrev, exec, playerctl previous
      bind = , Print, exec, grim -g "$(slurp)" - | wl-copy

      # Startup
      exec-once = waybar
      exec-once = swww init && swww img /home/paul/Pictures/Wallpapers/catppuccin-anime.jpg
      exec-once = dunst
      exec-once = cliphist restore
    '';
  };

  # Waybar + Dunst + Wofi with catppuccin-mocha
  programs.waybar = {
    enable = true;
    style = builtins.readFile (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/waybar/main/themes/mocha.css";
      hash = "sha256-7sE2v4s5i6v4uW6v2+6u7z8v9w0x1y2z3c4v5b6n7m8=";
    });
  };

  programs.dunst = {
    enable = true;
    settings = {
      global = {
        corner_radius = 12;
        follow = "keyboard";
        font = "JetBrainsMono Nerd Font 11";
        frame_width = 0;
        offset = "15x15";
      };
      urgency_low = { background = "#1e1e2e"; foreground = "#cdd6f4"; };
      urgency_normal = { background = "#1e1e2e"; foreground = "#89b4fa"; };
      urgency_critical = { background = "#f38ba8"; foreground = "#11111b"; frame_color = "#f38ba8"; };
    };
  };

  programs.wofi.enable = true;

  home.packages = with pkgs; [
    wofi grim slurp wl-clipboard cliphist swaylock-effects swww dunst waybar
  ];
}
