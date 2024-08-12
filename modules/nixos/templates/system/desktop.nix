{ config, lib, pkgs, ... }:

let
  cfg = config.templates.system.desktop;
in
{
  options.templates.system.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Desktop services.";
    };
    waydroid.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable waydroid services.";
    };
    sddm.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable display manager services.";
    };
    portals = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ 
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
      description = "xdg destkop portals";
    };
    users = lib.mkOption {
      type = lib.types.listOf lib.types.string;
      default = [ ];
      description = "Users to install desktop services for.";
    };
  };

  config = lib.mkIf cfg.enable {

    fonts = {
      packages = with pkgs; [
        ibm-plex
        jetbrains-mono
        hasklig
        hack-font

        material-design-icons
        material-icons

        powerline-fonts

        fira
        fira-mono
        fira-code
        fira-code-symbols

        noto-fonts
        noto-fonts-emoji
        noto-fonts-extra

        roboto
        roboto-mono
        roboto-slab

        anonymousPro
        corefonts
        source-code-pro
        symbola
        liberation_ttf

        (nerdfonts.override { fonts = [
          "JetBrainsMono"
          "SourceCodePro"
          "Hack"
        ]; })
      ];
    };

    security.polkit.enable = true;

    # https://nixos.wiki/wiki/Appimage
    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    virtualisation = {
      waydroid = lib.mkIf cfg.waydroid.enable {
        enable = true;
      };
    };

    networking.networkmanager.enable = true;

    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
      setLdLibraryPath = true;
    };
    services = {
      dbus.enable = true;
      udisks2.enable = true;
      atd.enable = true;
      flatpak.enable = true;
    };

    programs = {
      nm-applet = {
        enable = true;
        indicator = false;
      };
      dconf.enable = true;
      xwayland.enable = true;
      zsh.enable = true;
      thunar.enable = true;
    };

    xdg.autostart.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = cfg.portals;
    };

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    hardware.pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };

    services = lib.mkIf cfg.sddm.enable {
      displayManager = {
        defaultSession = "plasma";
        sddm = {
          enable = true;
          theme = "where_is_my_sddm_theme";
          wayland = {
            enable = true;
          };
        };
      };
      desktopManager.plasma6.enable = true;
      libinput.enable = true;
    };

    qt = lib.mkIf cfg.sddm.enable {
      enable = true;
      platformTheme = "kde";
      style = "kvantum";
    };

    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = cfg.users;
    };

    systemd.defaultUnit = "graphical.target";

    environment = {
      systemPackages = with pkgs; lib.mkMerge [ 
        [
          at
          glxinfo
          firefox
          networkmanagerapplet
          xdg-utils
          appimage-run
          libnotify
          libappindicator
          kdePackages.qt6ct
          kdePackages.qt6gtk2
          kdePackages.plasma5support
          kdePackages.libquotient
          libsForQt5.breeze-gtk
          libsForQt5.breeze-qt5
          libsForQt5.qt5ct
          flatpak-builder
          gnome.adwaita-icon-theme
          shared-mime-info
          xwaylandvideobridge
        ]
        (lib.mkIf cfg.sddm.enable [
          kdePackages.sddm-kcm
          (pkgs.where-is-my-sddm-theme.override {
            variants = [ "qt6" ];
            themeConfig = {
              General = {
                passwordCharacters = "*";
                passwordMask = "true";
                passwordInputWidth = 0.5;
                passwordInputBackground = "#282A36";
                passwordInputRadius = 10;
                passwordFontSize = 28;
                cursorBlinkAnimation = true;
                passwordCursorColor = "#6272A4";
                passwordTextColor = "#F8F8F2";
                passwordInputCursorVisible = true;
                background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                backgroundMode = "none";
                backgroundFill = "#44475A";
                showSessionsByDefault = true;
                sessionsFontSize = 20;
                showUsersByDefault = false;
                usersFontSize = 36;
                basicTextColor = "#F8F8F2";
              };
            };
          })
        ])
      ];
      pathsToLink = [
        "/share/icons"
        "/share/mime"
      ];
    };
  };
}
