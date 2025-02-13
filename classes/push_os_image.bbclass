inherit ostree

do_pull_os_image_from_fotahub[depends] = " \
    ostree-native:do_populate_sysroot \
"

do_push_os_image_to_fotahub[recrdeptask] = "do_pull_os_image_from_fotahub"
do_push_os_image_to_fotahub[depends] = " \
    curl-native:do_populate_sysroot \
    ostree-native:do_populate_sysroot \
"

do_pull_os_image_from_fotahub() {
    bbnote "Initializing OSTree repo at ${OSTREE_REPO}"
    ostree_init_if_non_existent ${OSTREE_REPO} archive-z2

    bbnote "Adding '${FOTAHUB_OSTREE_REMOTE_NAME}' remote for '${FOTAHUB_OSTREE_URL}' to OSTree repo in ${OSTREE_REPO}"
    ostree_remote_add_if_not_present ${OSTREE_REPO} ${FOTAHUB_OSTREE_REMOTE_NAME} ${FOTAHUB_OSTREE_URL}

    set +e
    # Ignore error for this command, since the remote repo could be empty and we have no way to know
    bbnote "Pulling '${OSTREE_BRANCHNAME}' OS from remote OSTree repo at FotaHub"
    ostree_pull_mirror ${OSTREE_REPO} ${FOTAHUB_OSTREE_REMOTE_NAME} ${OSTREE_BRANCHNAME} ${OSTREE_MIRROR_PULL_DEPTH} ${OSTREE_MIRROR_PULL_RETRIES}
    set -e
}

do_push_os_image_to_fotahub() {
    bbnote "Pushing '${PN}' application to remote OSTree repo at FotaHub"
    ostree_push_to_fotahub ${OSTREE_REPO} ${OSTREE_BRANCHNAME}
}

IMAGE_CMD_ostreepush() {
    # Do nothing
}

addtask do_pull_os_image_from_fotahub after do_rootfs before do_image_ostree
addtask do_push_os_image_to_fotahub after do_image_ostree before do_image_ostreepush
