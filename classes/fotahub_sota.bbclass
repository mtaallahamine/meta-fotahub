python __anonymous() {
    if bb.utils.contains('DISTRO_FEATURES', 'sota', True, False, d):
        d.appendVarFlag("do_image_wic", "depends", " %s:do_image_otaimg" % d.getVar("IMAGE_BASENAME", True))
}

OVERRIDES .= "${@bb.utils.contains('DISTRO_FEATURES', 'sota', ':sota', '', d)}"

IMAGE_INSTALL_append_sota = " ostree os-release"
IMAGE_CLASSES += " image_types_ostree image_types_ota"
IMAGE_FSTYPES += "${@bb.utils.contains('DISTRO_FEATURES', 'sota', 'ostreepush otaimg wic', ' ', d)}"

PACKAGECONFIG_append_pn-curl = " ssl"
PACKAGECONFIG_remove_pn-curl = "gnutls"

EXTRA_IMAGEDEPENDS_append_sota = " parted-native mtools-native dosfstools-native"

OSTREE_INITRAMFS_FSTYPES ??= "${@oe.utils.ifelse(d.getVar('OSTREE_BOOTLOADER', True) == 'u-boot', 'ext4.gz.u-boot', 'ext4.gz')}"

OSTREE_REPO ?= "${DEPLOY_DIR_IMAGE}/ostree_repo"
OSTREE_BRANCHNAME ?= "fotahub-os-${MACHINE}"
OSTREE_OSNAME ?= "os"
OSTREE_BOOTLOADER ??= 'u-boot'
OSTREE_BOOT_PARTITION ??= "/boot"

OSTREE_INITRAMFS_IMAGE ?= "initramfs-ostree-image"

inherit fotahub_sota_${MACHINE}
