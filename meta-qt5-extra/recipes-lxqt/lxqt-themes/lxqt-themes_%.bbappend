WALLPAPER-MACHINE = "Wallpaper_Toradex.png"
WALLPAPER-MACHINE_colibri-t20 = "Wallpaper_ColibriT20.png"
WALLPAPER-MACHINE_colibri-t30 = "Wallpaper_ColibriT30.png"
WALLPAPER-MACHINE_apalis-t30 = "Wallpaper_ApalisT30.png"
WALLPAPER-MACHINE_apalis-tk1 = "Wallpaper_ApalisTK1.png"
WALLPAPER-MACHINE_mx6ull = "Wallpaper_ColibriiMX6ULL.png"

FILESEXTRAPATHS_prepend := "${THISDIR}/lxqt-themes:"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI += " \
    file://Wallpaper_Toradex.png \
    file://${WALLPAPER-MACHINE} \
"

# for apalis-imx6/colibri-imx6, we decide on the target during postinst
SRC_URI-MX6QDL = " \
    file://Wallpaper_ApalisiMX6D.png \
    file://Wallpaper_ApalisiMX6Q.png \
    file://Wallpaper_ColibriiMX6DL.png \
    file://Wallpaper_ColibriiMX6S.png \
"
SRC_URI_append_mx6q += " ${SRC_URI-MX6QDL}"
SRC_URI_append_mx6dl += " ${SRC_URI-MX6QDL}"

# for colibri-imx7 we decide on the target during postinst
SRC_URI_append_mx7 += " \
    file://Wallpaper_ColibriiMX7D.png \
    file://Wallpaper_ColibriiMX7S.png \
"
# for colibri-vf50, colibri-vf61 we decide on the target during postinst
SRC_URI_append_vf += " \
    file://Wallpaper_ColibriVF50.png \
    file://Wallpaper_ColibriVF61.png \
"

do_install_append () {
    install -m 0755 -d ${D}/${datadir}/lxqt/themes/toradex
    install -m 0644 ${WORKDIR}/Wallpaper*.png ${D}/${datadir}/lxqt/themes/toradex
    ln -sf ${WALLPAPER-MACHINE} ${D}/${datadir}/lxqt/themes/toradex/toradex.png
}

pkg_postinst_${PN}_vf () {
    # can't do this offline
    if [ "x$D" != "x" ]; then
        exit 1
    fi
    IS_VF50=`grep -c VF50 /proc/cpuinfo`
    IS_VF50_DTB=`grep -c toradex,vf500-colibri_vf50 /proc/device-tree/compatible`
    IS_VF61=`grep -c VF61 /proc/cpuinfo`
    IS_VF61_DTB=`grep -c toradex,vf610-colibri_vf61 /proc/device-tree/compatible`
    if [ $IS_VF50 -gt 0 ] || [ $IS_VF50_DTB -gt 0 ]; then
        ln -sf Wallpaper_ColibriVF50.png ${datadir}/lxqt/themes/toradex/toradex.png
    elif [ $IS_VF61 -gt 0 ] || [ $IS_VF61_DTB -gt 0 ]; then
        ln -sf Wallpaper_ColibriVF61.png ${datadir}/lxqt/themes/toradex/toradex.png
    fi
}

pkg_postinst_${PN}_mx6 () {
    # can't do this offline
    if [ "x$D" != "x" ]; then
        exit 1
    fi
    SOC_TYPE=`cat /sys/bus/soc/devices/soc0/soc_id`
    CORES=`grep -c processor /proc/cpuinfo`
    case $CORES in
        4)
            ln -sf Wallpaper_ApalisiMX6Q.png ${datadir}/lxqt/themes/toradex/toradex.png
            ;;
        2)
            if [ "x$SOC_TYPE" = "xi.MX6DL" ]; then
                ln -sf Wallpaper_ColibriiMX6DL.png ${datadir}/lxqt/themes/toradex/toradex.png
            else
                ln -sf Wallpaper_ApalisiMX6D.png ${datadir}/lxqt/themes/toradex/toradex.png
            fi
            ;;
        1)
            ln -sf Wallpaper_ColibriiMX6S.png ${datadir}/lxqt/themes/toradex/toradex.png
            ;;
        *)
            ln -sf Wallpaper_Toradex.png ${datadir}/lxqt/themes/toradex/toradex.png
            ;;
    esac
}

# the ull is in the mx6 soc family, so give a more specific override here
# do nothing, but do not prevent the injected update-alternatives to run on
# the target.
pkg_postinst_${PN}_mx6ull () {
    :
}

pkg_postinst_${PN}_mx7 () {
    # can't do this offline
    if [ "x$D" != "x" ]; then
        exit 1
    fi
# Currently the soc bus subsystem seems not to work on i.MX 7Solo
#    SOC_TYPE=`cat /sys/bus/soc/devices/soc0/soc_id`
#    if [ "x$SOC_TYPE" = "xi.MX7D" ]; then
#        ln -sf Wallpaper_ColibriiMX7D.png ${datadir}/lxqt/themes/toradex/toradex.png
#    else
#        ln -sf Wallpaper_ColibriiMX7S.png ${datadir}/lxqt/themes/toradex/toradex.png
#    fi
    CORES=`grep -c processor /proc/cpuinfo`
    case $CORES in
        2)
            ln -sf Wallpaper_ColibriiMX7D.png ${datadir}/lxqt/themes/toradex/toradex.png
            ;;
        1)
            ln -sf Wallpaper_ColibriiMX7S.png ${datadir}/lxqt/themes/toradex/toradex.png
            ;;
        *)
            ln -sf Wallpaper_Toradex.png ${datadir}/lxqt/themes/toradex/toradex.png
            ;;
    esac

}
