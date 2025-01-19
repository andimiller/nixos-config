# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  #boot.loader.grub.efiSupport = true;
  #boot.loader.grub.efiInstallAsRemovable = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb"];

  networking.hostName = "honse"; # Define your hostname.
  networking.domain = "pizza.moe";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking.useDHCP = false;
  networking.usePredictableInterfaceNames = false;
  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "94.23.27.19";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "94.23.27.254";
  networking.nameservers = [ "8.8.8.8" ];

  users.users.root.initialHashedPassword = "";
  users.users.root.shell = pkgs.zsh;
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQdqjE9UPIG0O3iwnPrxKlkWkLvG9myLXU1d/fjKY9RlTh9RyRRYfrLOCvWfpfsmYtps/jZZWKvU5MK/wcZ7q7k+Qitd+Gqq8DnVrFXuVcv/qwek9oe99K4L+2X5dSL9tTFombeie35shzIyMnnGvkGuXFQeqxl941SFVTIlG5h9XwyB3znLJTgXSxtOe+WOl7YH0znQTlIp2z7im8zEnO9rYm5Mk2q13qx4APW6KnCZ8isnJWVuSP4gRIv7NsESQ60K4819i0j7vXPA4u8Wa/dzdr5bRskGFvWkVNy3Rlpaun1dC49BL5Gp4OG4QXaaiDkgbag9EJYwzmSwJodUxr andi@ldn.andimiller.net"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnRI/Rbote2bW5xaoOBwWoRtxxWMwSsghEPUZWUijV26+uqyfK1VDgY+6tzwyWnkuPtURnWkYdgkUpG9t1zcNVkXK/hBAymwAw3efCguP4VOpwIDTfiiqsxPjJN/hz4uHMukCmSIw6yRPy3cC9TDO0Dymck7C/Ab6BawZYD7tAvSgECpZJT0p9u8ged/JJvk+/X7FWojRH9elVEjiBT+cYocMPguZkgN+kvFvsappjjs1spI7PvfFKSl3tpohgegZAkA89pIlRHXpfHmVKn7w3Pl1ok9IdPg3PcA9cOzKX6SfPBsH5oZfPUoU6JMcMYyp8Rsi/g9ZBFEePzAcoSEHH callum"
  ];

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = 
    with pkgs; [
      vim 
      wget
      emacs
      zsh
      any-nix-shell
      htop
      neofetch
      figlet
      nettools
      fail2ban
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      docker = "podman";
    };
    ohMyZsh = {
      enable = true;
      plugins = [ 
        "git"
        "kubectl"
        "history-substring-search"
        "nix"
      ];
      theme = "andimiller";
    };
    promptInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };

  programs.zsh.ohMyZsh.customPkgs =
    let
      oh-my-zsh-andimiller-theme = with pkgs; stdenv.mkDerivation rec {
        name = "oh-my-zsh-andimiller-theme";
        src = pkgs.fetchFromGitHub {
          owner = "andimiller";
          repo = "dotfiles";
          rev = "fc61aaea1a9fb5fda64f433ddbb16f668aff914f";
          sha256 = "Dp8hU6G/fvJ1wCvSrUrfzpc8axUe0I8Fy4FL5dxgRB0=";
        };
        paths = [ pkgs.oh-my-zsh ];
        dontBuild = true;
        installPhase = ''
           mkdir -p $out/share/zsh
           cp -r oh-my-zsh-custom/themes $out/share/zsh
        '';
      };
    in with pkgs; [
      oh-my-zsh-andimiller-theme
      nix-zsh-completions
      zsh-nix-shell
    ];
    

  programs.rust-motd = {
    enable = true;
    settings = {
      banner = { 
        color = "cyan"; 
        command = "${pkgs.nettools}/bin/hostname | ${pkgs.figlet}/bin/figlet -f univers"; 
      };
      filesystems.root = "/";
      memory.swap_pos = "beside";
      fail2_ban.jails = ["sshd"];
      service_status.k3s = "k3s";
      last_login = {
        root = 1;
      };
      uptime.prefix = "Up";
    };
    order = [ "banner" "filesystems" "memory" "fail2_ban" "service_status" "last_login" "uptime" ];
  };
  # patch the path to add fail2ban
  systemd.services.rust-motd.path = with pkgs; [ bash fail2ban ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    6443
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # set up fail2ban just in case
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "30d";
  };

  # we're a solo kubernetes node
  services.k3s = {
    enable = true;
    role = "server";
  };
  # and we have podman 
  virtualisation.podman.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

