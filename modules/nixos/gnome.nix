{ config, pkgs, lib, ... }:

let
  # GDM login wallpaper — copied to nix store so the gdm user can read it.
  # This is the same Catppuccin Mocha wallpaper used for GRUB.
  gdmWallpaper = pkgs.runCommand "gdm-wallpaper" { } ''
    mkdir -p $out/share/wallpapers
    cp ${../../assets/wallpapers/Catppuccin_Mocha/17._Catppuccin_Mocha.jpg} $out/share/wallpapers/gdm-background.jpg
  '';
in
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # XDG Portal
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };

  # DConf
  programs.dconf.enable = true;

  # GDM login screen background wallpaper
  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/background" = {
        picture-uri = "file://${gdmWallpaper}/share/wallpapers/gdm-background.jpg";
        picture-options = "zoom";
      };
    }
  ];

  # GPaste clipboard manager daemon
  programs.gpaste.enable = true;

  # ── GDM Login Screen Wallpaper via gnome-shell overlay ───────────────────────
  # Patches the GNOME Shell SCSS so the #lockDialogGroup uses the custom
  # wallpaper as a background image instead of a solid colour.
  # Ref: https://discourse.nixos.org/t/a-gnome-wallpaper-build-factory/78794
  nixpkgs.overlays = [
    (final: prev: {
      gnome-shell = prev.gnome-shell.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ gdmWallpaper ];

        patches = (oldAttrs.patches or [ ]) ++ [
          (final.replaceVars ../../modules/nixos/patches/gdm-wallpaper.patch {
            backgroundPath = "${gdmWallpaper}/share/wallpapers/gdm-background.jpg";
          })
        ];
      });
    })
  ];
}
