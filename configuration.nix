{ config, lib, pkgs, ... }:
{
  imports = [ ./cross-config.nix ./kernel.nix ];
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  # boot.consoleLogLevel = 7;

  boot.kernelModules = [ "spi-nor" ]; # Not sure why this doesn't autoload. Provides SPI NOR at /dev/mtd0
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl8189es ];

  zramSwap.enable = true; # 128MB is not much to work with

  sound.enable = true;

  networking.wireless.enable = true;
}
