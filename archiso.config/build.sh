#!/bin/bash

set -e -u

iso_name=coindrone
iso_label="CoinDrone_$(date +%Y%m)"
install_dir=arch
work_dir=work
out_dir=out
coindroneIMG=nv

arch=$(uname -m)
verbose=""
script_path=$(readlink -f ${0%/*})

_usage ()
{
    echo "usage ${0} [options]"
    echo
    echo " General options:"
    echo "    -v                 Enable verbose output"
    echo "    -h                 This help message"
    exit ${1}
}

# Helper function to run make_*() only one time per architecture.
run_once() {
    if [[ ! -e ${work_dir}-${coindroneIMG}/build.${1}_x86_64 ]]; then
        $1
        touch ${work_dir}-${coindroneIMG}/build.${1}_x86_64
    fi
}

# Setup custom pacman.conf with current cache directories.
make_pacman_conf() {
    local _cache_dirs
    _cache_dirs=($(pacman -v 2>&1 | grep '^Cache Dirs:' | sed 's/Cache Dirs:\s*//g'))
    sed -r "s|^#?\\s*CacheDir.+|CacheDir = $(echo -n ${_cache_dirs[@]})|g" ${script_path}/pacman.conf > ${pacman_conf}
}

# Base installation, plus needed packages (root-image)
make_basefs() {
    setarch x86_64 mkarchiso ${verbose} -w "${work_dir}-${coindroneIMG}/x86_64" -C "${pacman_conf}" -D "${install_dir}" init
    setarch x86_64 mkarchiso ${verbose} -w "${work_dir}-${coindroneIMG}/x86_64" -C "${pacman_conf}" -D "${install_dir}" -p "memtest86+ mkinitcpio-nfs-utils nbd" install
}

# Additional packages (root-image)
make_packages() {
    setarch x86_64 mkarchiso ${verbose} -w "${work_dir}-${coindroneIMG}/x86_64" -C "${pacman_conf}" -D "${install_dir}" -p "$(grep -h -v ^# ${script_path}/packages.{both,x86_64,${coindroneIMG}})" install
}

# Copy mkinitcpio archiso hooks and build initramfs (root-image)
make_setup_mkinitcpio() {
    local _hook
    for _hook in archiso archiso_shutdown archiso_pxe_common archiso_pxe_nbd archiso_pxe_http archiso_pxe_nfs archiso_loop_mnt; do
        cp /usr/lib/initcpio/hooks/${_hook} ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/lib/initcpio/hooks
        cp /usr/lib/initcpio/install/${_hook} ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/lib/initcpio/install
    done
    cp /usr/lib/initcpio/install/archiso_kms ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/lib/initcpio/install
    cp /usr/lib/initcpio/archiso_shutdown ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/lib/initcpio
    cp ${script_path}/mkinitcpio.conf ${work_dir}-${coindroneIMG}/x86_64/root-image/etc/mkinitcpio-archiso.conf
    setarch x86_64 mkarchiso ${verbose} -w "${work_dir}-${coindroneIMG}/x86_64" -C "${pacman_conf}" -D "${install_dir}" -r 'mkinitcpio -c /etc/mkinitcpio-archiso.conf -k /boot/vmlinuz-linux -g /boot/archiso.img' run
}

# Customize installation (root-image)
make_customize_root_image() {
    cp -af ${script_path}/root-image ${work_dir}-${coindroneIMG}/x86_64

    curl -o ${work_dir}-${coindroneIMG}/x86_64/root-image/etc/pacman.d/mirrorlist 'https://www.archlinux.org/mirrorlist/?country=all&protocol=http&use_mirror_status=on'

    lynx -dump -nolist 'https://wiki.archlinux.org/index.php/Installation_Guide?action=render' >> ${work_dir}-${coindroneIMG}/x86_64/root-image/root/install.txt

    setarch x86_64 mkarchiso ${verbose} -w "${work_dir}-${coindroneIMG}/x86_64" -C "${pacman_conf}" -D "${install_dir}" -r '/root/customize_root_image.sh' run
    rm ${work_dir}-${coindroneIMG}/x86_64/root-image/root/customize_root_image.sh
}

# Prepare kernel/initramfs ${install_dir}/boot/
make_boot() {
    mkdir -p ${work_dir}-${coindroneIMG}/iso/${install_dir}/boot/x86_64
    cp ${work_dir}-${coindroneIMG}/x86_64/root-image/boot/archiso.img ${work_dir}-${coindroneIMG}/iso/${install_dir}/boot/x86_64/archiso.img
    cp ${work_dir}-${coindroneIMG}/x86_64/root-image/boot/vmlinuz-linux ${work_dir}-${coindroneIMG}/iso/${install_dir}/boot/x86_64/vmlinuz
}

# Add other aditional/extra files to ${install_dir}/boot/
make_boot_extra() {
    cp ${work_dir}-${coindroneIMG}/x86_64/root-image/boot/memtest86+/memtest.bin ${work_dir}-${coindroneIMG}/iso/${install_dir}/boot/memtest
    cp ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/share/licenses/common/GPL2/license.txt ${work_dir}-${coindroneIMG}/iso/${install_dir}/boot/memtest.COPYING
}

# Prepare /${install_dir}/boot/syslinux
make_syslinux() {
    mkdir -p ${work_dir}-${coindroneIMG}/iso/${install_dir}/boot/syslinux
    for _cfg in ${script_path}/syslinux/*.cfg; do
        sed "s|%ARCHISO_LABEL%|${iso_label}|g;
             s|%INSTALL_DIR%|${install_dir}|g" ${_cfg} > ${work_dir}-${coindroneIMG}/iso/${install_dir}/boot/syslinux/${_cfg##*/}
    done
    cp ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/lib/syslinux/bios/*.c32 ${work_dir}-${coindroneIMG}/iso/${install_dir}/boot/syslinux
    cp ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/lib/syslinux/bios/lpxelinux.0 ${work_dir}-${coindroneIMG}/iso/${install_dir}/boot/syslinux
}

# Prepare /isolinux
make_isolinux() {
    mkdir -p ${work_dir}-${coindroneIMG}/iso/isolinux
    sed "s|%INSTALL_DIR%|${install_dir}|g" ${script_path}/isolinux/isolinux.cfg > ${work_dir}-${coindroneIMG}/iso/isolinux/isolinux.cfg
    cp ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/lib/syslinux/bios/isolinux.bin ${work_dir}-${coindroneIMG}/iso/isolinux/
    cp ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/lib/syslinux/bios/isohdpfx.bin ${work_dir}-${coindroneIMG}/iso/isolinux/
    cp ${work_dir}-${coindroneIMG}/x86_64/root-image/usr/lib/syslinux/bios/ldlinux.c32 ${work_dir}-${coindroneIMG}/iso/isolinux/
}

# Copy aitab
make_aitab() {
    mkdir -p ${work_dir}-${coindroneIMG}/iso/${install_dir}
    cp ${script_path}/aitab ${work_dir}-${coindroneIMG}/iso/${install_dir}/aitab
}

# Build all filesystem images specified in aitab (.fs.sfs .sfs)
make_prepare() {
    cp -a -l -f ${work_dir}-${coindroneIMG}/x86_64/root-image ${work_dir}-${coindroneIMG}
    setarch x86_64 mkarchiso ${verbose} -w "${work_dir}-${coindroneIMG}" -D "${install_dir}" pkglist
    setarch x86_64 mkarchiso ${verbose} -w "${work_dir}-${coindroneIMG}" -D "${install_dir}" prepare
    rm -rf ${work_dir}-${coindroneIMG}/root-image
    # rm -rf ${work_dir}-${coindroneIMG}/x86_64/root-image (if low space, this helps)
}

# Build ISO
make_iso() {
    mkarchiso ${verbose} -w "${work_dir}-${coindroneIMG}" -D "${install_dir}" checksum
    mkarchiso ${verbose} -w "${work_dir}-${coindroneIMG}" -D "${install_dir}" -L "${iso_label}" -o "${out_dir}" iso "${iso_name}-${coindroneIMG}.iso"
}

if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root."
    _usage 1
fi

if [[ x86_64 != x86_64 ]]; then
    echo "This script needs to be run on x86_64"
    _usage 1
fi

while getopts 'N:V:L:D:w:o:vh' arg; do
    case "${arg}" in
        v) verbose="-v" ;;
        h) _usage 0 ;;
        *)
           echo "Invalid argument '${arg}'"
           _usage 1
           ;;
    esac
done


for coindroneIMG in nv amd; do
  mkdir -p ${work_dir}-${coindroneIMG}

  
  pacman_conf=${work_dir}-${coindroneIMG}/pacman.conf
  run_once make_pacman_conf

  # Do all stuff for each root-image

  run_once make_basefs
  run_once make_packages
  run_once make_setup_mkinitcpio
  run_once make_customize_root_image

  run_once make_boot

  # Do all stuff for "iso"
  run_once make_syslinux
  run_once make_isolinux

  run_once make_aitab
  run_once make_prepare

  run_once make_iso
done
