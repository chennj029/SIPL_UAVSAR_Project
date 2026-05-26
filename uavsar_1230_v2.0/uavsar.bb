#
# This file is the uavsar recipe.
#

SUMMARY = "Simple uavsar application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://main.c \
	   file://main.h \
	   file://acq_brd.c \
	   file://acq_brd.h \
	   file://adc_sample_ctrl.c \
	   file://adc_sample_ctrl.h \
	   file://axi_dma_ctrl.c \
	   file://axi_dma_ctrl.h \
	   file://base_brd.c \
	   file://base_brd.h \
	   file://eth_tcp.c \
	   file://eth_tcp.h \
	   file://platform.c \
	   file://platform.h \
	   file://psu_brd.c \
	   file://psu_brd.h \
	   file://tx_brd.c \
	   file://tx_brd.h \
	   file://uavsar.c \
	   file://Makefile \
		  "

S = "${WORKDIR}"

do_compile() {
	     oe_runmake
}

do_install() {
	     install -d ${D}${bindir}
	     install -m 0755 uavsar ${D}${bindir}
}
