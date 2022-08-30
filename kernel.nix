{ pkgs, lib, config, inputs, ... }: {
  # Kernel doesn't support AHCI
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = [];
  #boot.kernelModules = [ "spi-nor" ]; # Not sure why this doesn't autoload. Provides SPI NOR at /dev/mtd0
  boot.kernelModules = lib.mkForce [];
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl8189es ];

  boot.kernelParams = ["console=ttyS0,115200n8"];

  hardware.deviceTree = {
    #overlays = [
    #  { name = "battery"; dtsFile = ./battery.dtso; }
    #];
    filter = "*pinecube*";
  };

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.buildLinux {
    inherit (pkgs.linux_latest) src version modDirVersion;
    kernelPatches = pkgs.linux_latest.kernelPatches ++ [
      { name = "pinecube"; patch = ./kernel/Pine64-PineCube-support.patch; }
    ];
    autoModules = false;
    defconfig = "sunxi_defconfig";
    structuredExtraConfig = with lib.kernel; {
      CFG80211 = module;
      WIRELESS = yes;
      WLAN = yes;
      RFKILL = yes;
      RFKILL_INPUT = yes;
      RFKILL_GPIO = yes;
      CRYPTO_ZSTD = yes;
      ZSTD_COMPRESS = yes;
      IPV6_SIT = no;
      IPV6_TUNNEL = no;
      MEDIA_CAMERA_SUPPORT = yes;
      VIDEO_OV5640 = yes;

      EFI = yes;

      ZSMALLOC = lib.mkForce yes;
      ZRAM = module;
      ZRAM_DEF_COMP_ZSTD = yes;
      MTD = yes;
      PSTORE = yes;
      MTD_SPI_NOR = yes;
      MTD_BLOCK = yes;

      NETFILTER = lib.mkForce no;
      #NF_TABLES = yes;
      #NF_LOG_SYSLOG = yes;
      #NF_CONNTRACK = yes;
      #NETFILTER_XT_MARK = yes;
      #NETFILTER_XT_MATCH_COMMENT = yes;
      #NETFILTER_XT_MATCH_CONNTRACK = yes;
      #NETFILTER_XT_MATCH_MULTIPORT = yes;
      #NETFILTER_XT_MATCH_PKTTYPE = yes;
      #NETFILTER_XT_SET = yes;
      #NETFILTER_XT_TARGET_LOG = yes;

      #IP_NF_IPTABLES = yes;
      #IP_NF_FILTER = yes;
      #IP_NF_TARGET_REJECT = yes;
      #IP_NF_MANGLE = yes;
      #IP_NF_MATCH_RPFILTER = yes;
      #IP_NF_RAW = yes;

      #NF_REJECT_IPV6 = yes;
      #IP6_NF_IPTABLES = yes;
      #IP6_NF_TARGET_REJECT = yes;
      #IP6_NF_FILTER = yes;
      #IP6_NF_MANGLE = yes;
      #IP6_NF_MATCH_RPFILTER = yes;
      #IP6_NF_RAW = yes;

      #IP_SET = yes;
      #IP_SET_HASH_NET = yes;

      IOSCHED_BFQ = lib.mkForce no;
      INET_DIAG = lib.mkForce no;
      INET_TCP_DIAG = lib.mkForce no;
      INET_UDP_DIAG = lib.mkForce no;
      INET_RAW_DIAG = lib.mkForce no;
      INET_MPTCP_DIAG = lib.mkForce no;
      NET_CLS_BPF = lib.mkForce no;
      BONDING = lib.mkForce no;
      USB_GSPCA = lib.mkForce no;
      VIDEO_STK1160_COMMON = lib.mkForce no;
      VIDEO_STK1160 = lib.mkForce no;
      VIDEOBUF2_VMALLOC = lib.mkForce no;
      VIDEO_SAA711X = lib.mkForce no;
      XEN_GNTDEV = lib.mkForce no;
      XEN_GRANT_DEV_ALLOC = lib.mkForce no;
      F2FS_FS = lib.mkForce no;
      UDF_FS = lib.mkForce no;
      NLS_CODEPAGE_437 = lib.mkForce yes;
      NLS_ISO8859_1 = lib.mkForce yes;
      NLS_UTF8 = lib.mkForce yes;
      CRYPTO_CRC32 = lib.mkForce no;
      CRC_ITU_T = lib.mkForce no;
      LZ4_COMPRESS = lib.mkForce no;
      LZ4HC_COMPRESS = lib.mkForce no;

      NFS_FS = no;
      BPF_SYSCALL = lib.mkForce no;
      FRAMEBUFFER_CONSOLE = lib.mkForce no;
      ANDROID = lib.mkForce no;
      DRM = no;
      FB = lib.mkForce no;
      ATA = lib.mkForce no;
    };
  });
}
