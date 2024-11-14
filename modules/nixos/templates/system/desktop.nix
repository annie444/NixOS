{
  config,
  lib,
  pkgs,
  ...
}: let
  extraKdePackages = with pkgs.kdePackages; [
    breeze-icons
    kirigami
    plasma5support
    qtsvg
    qtvirtualkeyboard
    sddm-kcm
  ];

  extraIcons = with pkgs; [
    nixos-icons
  ];

  sddmTheme = pkgs.where-is-my-sddm-theme.override {
    variants = ["qt6"];
    themeConfig = {
      General = {
        passwordCharacters = "*";
        passwordMask = "true";
        passwordInputWidth = 0.5;
        passwordInputBackground = "#282A36";
        passwordInputRadius = 10;
        passwordFontSize = 28;
        passwordCursorColor = "#6272A4";
        passwordTextColor = "#F8F8F2";
        passwordInputCursorVisible = true;
        passwordAllowEmpty = false;

        hideCursor = false;
        cursorBlinkAnimation = true;

        background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        backgroundMode = "none";
        backgroundFill = "#44475A";

        showSessionsByDefault = true;
        sessionsFontSize = 20;

        showUsersByDefault = false;
        usersFontSize = 36;
      };
    };
  };

  extraPackages = [sddmTheme] ++ extraKdePackages ++ extraIcons;

  cfg = config.templates.system.desktop;
in {
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
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
      description = "xdg destkop portals";
    };
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
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

        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            "SourceCodePro"
            "Hack"
          ];
        })
      ];
      fontDir.enable = true;
    };

    # https://nixos.wiki/wiki/Appimage
    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    virtualisation = {
      waydroid = lib.mkIf cfg.waydroid.enable {
        enable = true;
      };
    };

    networking.networkmanager.enable = true;
    environment.sessionVariables = {
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
    };

    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true;
        setLdLibraryPath = true;
      };
      pulseaudio = {
        enable = false;
        package = pkgs.pulseaudioFull;
        support32Bit = true;
      };
    };

    services = {
      dbus.enable = true;
      udisks2.enable = true;
      atd.enable = true;
      flatpak.enable = true;
      packagekit.enable = true;
      fwupd.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
      displayManager = lib.mkIf cfg.sddm.enable {
        enable = true;
        logToJournal = true;
        defaultSession = "plasma";
        sessionPackages = [];
        sddm = {
          enable = true;
          package = lib.mkForce (pkgs.kdePackages.sddm.override {
            inherit extraPackages;
            withWayland = true;
          });
          enableHidpi = true;
          autoNumlock = true;
          theme = "where_is_my_sddm_theme";
          wayland = {
            enable = true;
            compositor = "kwin";
          };
          extraPackages = lib.mkForce extraPackages;
        };
      };
      desktopManager.plasma6 = lib.mkIf cfg.sddm.enable {
        enable = true;
        enableQt5Integration = true;
      };
      xserver.enable = lib.mkIf cfg.sddm.enable true;
      libinput.enable = true;
    };

    programs = {
      nm-applet = {
        enable = true;
        indicator = false;
      };
      dconf.enable = true;
      xwayland.enable = true;
      fish.enable = true;
      thunar.enable = true;
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = cfg.users;
      };
      kdeconnect = lib.mkIf cfg.sddm.enable {
        package = lib.mkForce pkgs.kdePackages.kdeconnect-kde;
        enable = true;
      };
      kde-pim = lib.mkIf cfg.sddm.enable {
        enable = true;
        merkuro = true;
        kontact = true;
        kmail = true;
      };
      partition-manager.enable = lib.mkIf cfg.sddm.enable true;
      k3b.enable = lib.mkIf cfg.sddm.enable true;
    };

    xdg = {
      autostart.enable = true;
      portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = cfg.portals;
      };
    };

    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };

    qt = lib.mkIf cfg.sddm.enable {
      enable = true;
      platformTheme = "kde";
      style = "kvantum";
    };

    environment = {
      systemPackages = with pkgs;
        lib.mkMerge [
          [
            at
            glxinfo
            firefox
            networkmanagerapplet
            xdg-utils
            appimage-run
            libnotify
            libappindicator
            pinentry-all
            kdePackages.qt6ct
            kdePackages.qt6gtk2
            kdePackages.plasma5support
            kdePackages.breeze
            kdePackages.discover
            kdePackages.packagekit-qt
            libportal
            flatpak-builder
            gnome.adwaita-icon-theme
            shared-mime-info
            xwaylandvideobridge
            wl-clipboard-rs
            dmenu-wayland
            ydotool
          ]
          (lib.mkIf cfg.sddm.enable [
            kdePackages.sddm-kcm
            sddmTheme
          ])
        ];
      pathsToLink = [
        "/share/icons"
        "/share/mime"
      ];
    };
  };
}
