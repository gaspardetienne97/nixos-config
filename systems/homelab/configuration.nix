# Edit this config.uration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, ... }:

{
  imports = [
    ../../modules/system/caddy.nix
    ../../modules/system/cloudflared.nix
    ../../modules/system/fail2ban.nix
    ../../modules/system/firefly.nix
    ../../modules/system/ollama.nix
    ../../modules/system/authentik.nix
    ../../modules/system/nextcloud.nix
    ../../modules/system/nixarr.nix
    ../../modules/system/immich.nix
    ../../modules/system/personal-website.nix
    ../base/configuration.nix
    ../../modules/system/homepage.nix
    ./hardware-configuration.nix
  ];

  modules = /* baseModules // */
    {
      caddy.enable = true;
      cloudflared.enable = true;
      fail2ban.enable = true;
      firefly.enable = true;
      ollama.enable = true;
      authentik.enable = true;
      nextcloud.enable = true;
      homepage.enable = true;
      nixarr.enable = true;
      immich.enable = true;
      personal-website.enable = true;
      # qbittorrent.enable = true;
    };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-b891f6e5-40bc-4d23-9c91-ea2c5ff10db7".device = "/dev/disk/by-uuid/b891f6e5-40bc-4d23-9c91-ea2c5ff10db7";
  networking.hostName = config.defaultConfigurationOptions.hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = config.defaultConfigurationOptions.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = config.defaultConfigurationOptions.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = config.defaultConfigurationOptions.locale;
    LC_IDENTIFICATION = config.defaultConfigurationOptions.locale;
    LC_MEASUREMENT = config.defaultConfigurationOptions.locale;
    LC_MONETARY = config.defaultConfigurationOptions.locale;
    LC_NAME = config.defaultConfigurationOptions.locale;
    LC_NUMERIC = config.defaultConfigurationOptions.locale;
    LC_PAPER = config.defaultConfigurationOptions.locale;
    LC_TELEPHONE = config.defaultConfigurationOptions.locale;
    LC_TIME = config.defaultConfigurationOptions.locale;
  };

  # Enable the X11 windowing system
  services.xserver = {
    # Required for DE to launch.
    enable = true;
    displayManager = {
      # Enable the GNOME Desktop Environment.
      gdm = {
        enable = true;
        # Enable wayland
        wayland = true;
      };
    };
    # Enable Desktop Environment.
    desktopManager.gnome.enable = true;
    # Configure keymap in X11.
    xkb.layout = "us";
    xkb.variant = "";
    # Exclude default X11 packages I don't want.
    excludePackages = with pkgs; [ xterm ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # trying to make bluetooth dongle more reliable
  hardware.firmware = [ pkgs.rtl8761b-firmware ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #disable useradd and passwd.
  #users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gaspard = {
    isNormalUser = true;
    description = config.defaultConfigurationOptions.fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };


  # nix helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "weekly";
    clean.extraArgs = "--keep-since 5d --keep 5";
    flake = "/home/gaspard/nixos-config";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 5;

  # Perform garbage collection weekly to maintain low disk usage
  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 1w";
  # };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
