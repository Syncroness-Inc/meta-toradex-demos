SUMMARY = "Systemd start script for Qt Embedded demo"
LICENSE = "MIT"
PR = "r1"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit allarch systemd

SRC_URI = " \
    file://qtdemo.service \
    file://mouse.rules \
    file://keyboard.rules \
"

do_install() {
    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/mouse.rules ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/keyboard.rules ${D}${sysconfdir}/udev/rules.d/

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/qtdemo.service ${D}${systemd_unitdir}/system
}

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "qtdemo.service"
