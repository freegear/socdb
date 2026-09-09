/*
 * Automatically generated C config: don't edit
 */
#define AUTOCONF_INCLUDED
#define CONFIG_UCLINUX 1

/*
 * Code maturity level options
 */
#define CONFIG_EXPERIMENTAL 1

/*
 * Platform dependant setup
 */
#define CONFIG_OR32 1

/*
 * Platform
 */
#define CONFIG_GEN 1
#define CONFIG_RAMKERNEL 1
#undef  CONFIG_ROMKERNEL

/*
 * General setup
 */
#undef  CONFIG_PCI
#undef  CONFIG_NET
#undef  CONFIG_SYSVIPC
#undef  CONFIG_REDUCED_MEMORY
#define CONFIG_BINFMT_FLAT 1
#define CONFIG_BINFMT_ELF 1
#undef  CONFIG_KERNEL_ELF
#undef  CONFIG_CONSOLE

/*
 * Floppy, IDE, and other block devices
 */
#define CONFIG_BLK_DEV_BLKMEM 1
#undef  CONFIG_BLK_DEV_IDE

/*
 * Additional Block/FLASH Devices
 */
#undef  CONFIG_BLK_DEV_LOOP
#undef  CONFIG_BLK_DEV_MD
#define CONFIG_BLK_DEV_RAM 1
#undef  CONFIG_RD_RELEASE_BLOCKS
#define CONFIG_BLK_DEV_INITRD 1
#undef  CONFIG_DEV_FLASH

/*
 * Filesystems
 */
#undef  CONFIG_QUOTA
#undef  CONFIG_MINIX_FS
#undef  CONFIG_EXT_FS
#define CONFIG_EXT2_FS 1
#undef  CONFIG_XIA_FS
#undef  CONFIG_NLS
#define CONFIG_PROC_FS 1
#undef  CONFIG_NCP_FS
#undef  CONFIG_HPFS_FS
#undef  CONFIG_SYSV_FS
#undef  CONFIG_AUTOFS_FS
#undef  CONFIG_AFFS_FS
#define CONFIG_ROMFS_FS 1
#undef  CONFIG_JFFS_FS
#undef  CONFIG_UFS_FS

/*
 * Character devices
 */
#define CONFIG_SERIAL 1
#undef  CONFIG_SERIAL_DUMMY
#undef  CONFIG_WATCHDOG

/*
 * Kernel hacking
 */
#undef  CONFIG_PROFILE
