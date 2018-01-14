{ config, pkgs, ... }:

let

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
  boot.extraModprobeConfig = ''
    options libata.force=noncq
    options resume=/dev/sda2
    options snd_hda_intel index=0 model=intel-mac-auto id=PCH
    options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
    options snd-hda-intel model=mbp101
    options hid_apple fnmode=2
  '';

  time.timeZone = "Europe/Prague";

  fonts.enableFontDir = true;
  fonts.enableCoreFonts = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fonts = with pkgs; [
    corefonts
    inconsolata
    liberation_ttf
    dejavu_fonts
    bakoma_ttf
    gentium
    ubuntu_font_family
    terminus_font
  ];

  nix.useSandbox = true;
  nix.binaryCaches =
    [
      https://cache.nixos.org
    ];

  networking.hostName = "nixos";
  networking.firewall.enable = true;
  networking.wireless.enable = true;

  hardware.bluetooth.enable = false;
  # This enables the facetime HD webcam on newer Macbook Pros (mid-2014+).
  hardware.facetimehd.enable = true;
  # Enable pulseaudio for audio
  hardware.pulseaudio.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  environment.systemPackages = with pkgs; [
    tmux
    acpi
    vim
    git
  ];

  nixpkgs.config.allowUnfree = true;

  powerManagement.enable = true;

  programs.light.enable = true;
  programs.bash.enableCompletion = true;

  services.dnsmasq.enable = true;
  services.dnsmasq.servers = [
    "8.8.4.4"
    "8.8.8.8"
  ];

  services.locate.enable = true;

  services.xserver.enable = true;
  services.xserver.enableTCP = false;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "mac";
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

  services.xserver.desktopManager.kde5.enable = true;
  services.xserver.displayManager.kdm.enable = true;

  services.xserver.multitouch.enable = true;
  services.xserver.multitouch.invertScroll = true;

  services.xserver.synaptics.additionalOptions = ''
    Option "VertScrollDelta" "-100"
    Option "HorizScrollDelta" "-100"
  '';
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.tapButtons = true;
  services.xserver.synaptics.fingersMap = [ 0 0 0 ];
  services.xserver.synaptics.buttonsMap = [ 1 3 2 ];
  services.xserver.synaptics.twoFingerScroll = true;

  users.mutableUsers = true;
  users.extraUsers.mmahut = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    description = "Marek Mahut";
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "messagebus"
      "systemd-journal"
      "disk"
      "audio"
      "video"
    ];
    createHome = true;
    home = "/home/mmahut";
  };

}
