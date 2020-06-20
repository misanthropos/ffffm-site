GLUON_FEATURES := \
	autoupdater \
	config-mode-outdoor \
	config-mode-domain-select \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-source-filter \
	mesh-batman-adv-15 \
	mesh-vpn-fastd \
	radv-filterd \
	respondd \
	status-page \
	web-wizard \
	web-private-wifi \
	web-logging \
	web-advanced \

GLUON_SITE_PACKAGES := \
	iwinfo \
	ffffm-button-bind \
	respondd-module-airtime \
	ffda-domain-director \
	gluon-web-ffda-domain-director \

# Enable multidomain support
GLUON_MULTIDOMAIN := 1

#####################################################################################################################
ifndef GLUON_SITEDIR
	include version.mk
else
	include $(GLUON_SITEDIR)/version.mk
endif

# GIT Properties
ifndef GLUON_SITEDIR
	GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
	COMMIT_DESCRIPTION := $(shell git describe --tags --long)
	BUILD_DATESTAMP := $(shell [ -f build_date ] && cat build_date || date '+%m%d')
	GIT_COMMIT := $(shell git rev-parse --short HEAD)
	GLUON_COMMIT := $(shell git -C .. rev-parse --short HEAD)
else
	GIT_BRANCH := $(shell git -C $(GLUON_SITEDIR) rev-parse --abbrev-ref HEAD)
	COMMIT_DESCRIPTION := $(shell git -C $(GLUON_SITEDIR) describe --tags --long)
	BUILD_DATESTAMP := $(shell [ -f $(GLUON_SITEDIR)/build_date ] && cat $(GLUON_SITEDIR)/build_date || date '+%m%d')
	GIT_COMMIT := $(shell git -C $(GLUON_SITEDIR) rev-parse --short HEAD)
	GLUON_COMMIT := $(shell git -C $(GLUON_SITEDIR)/.. rev-parse --short HEAD)
endif


### Build Release Name
# Default: Goto Experimental
DEFAULT_GLUON_BRANCH := experimental
DEFAULT_GLUON_RELEASE := $(DEFAULT_BASE_VERSION)-$(DEFAULT_GLUON_BRANCH)-$(BUILD_DATESTAMP)-$(GIT_COMMIT)-$(GLUON_COMMIT)
ifeq ($(GIT_BRANCH),next)
	# Next-Branch
	DEFAULT_GLUON_BRANCH := next
	DEFAULT_GLUON_RELEASE := $(DEFAULT_BASE_VERSION)-$(DEFAULT_GLUON_BRANCH)-$(BUILD_DATESTAMP)-$(GIT_COMMIT)-$(GLUON_COMMIT)
else ifeq ($(GIT_BRANCH),experimental)
		# RC-Branch
		DEFAULT_GLUON_BRANCH := experimental
		DEFAULT_GLUON_RELEASE := $(DEFAULT_BASE_VERSION)-$(DEFAULT_GLUON_BRANCH)-$(BUILD_DATESTAMP)-$(GIT_COMMIT)-$(GLUON_COMMIT)
else ifeq ($(GIT_BRANCH),stable)
	# RC-Branch
	DEFAULT_GLUON_BRANCH := rc
	DEFAULT_GLUON_RELEASE := $(DEFAULT_BASE_VERSION)-$(DEFAULT_GLUON_BRANCH)-$(BUILD_DATESTAMP)-$(GIT_COMMIT)-$(GLUON_COMMIT)
else ifeq ($(GIT_BRANCH),HEAD)
	# Determine TAG - if tagged set Version
	ifndef GLUON_SITEDIR
		GIT_TAG := $(shell git describe --exact-match --tags HEAD 2>/dev/null || echo false)
		ifneq ($(GIT_TAG),false)
			DEFAULT_GLUON_BRANCH := stable
			DEFAULT_GLUON_RELEASE := $(GIT_TAG)
		endif
	else
		GIT_TAG := $(shell git -C $(GLUON_SITEDIR) describe --exact-match --tags HEAD 2>/dev/null || echo false)
		ifneq ($(GIT_TAG),false)
			DEFAULT_GLUON_BRANCH := stable
			DEFAULT_GLUON_RELEASE := $(GIT_TAG)
		endif
	endif
endif

# Set final Branch and release

GLUON_BRANCH ?= $(DEFAULT_GLUON_BRANCH)
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

# Default priority for updates.
GLUON_PRIORITY ?= 0

# Languages to include
GLUON_LANGS ?= de

# region information for regulatory compliance
GLUON_REGION ?= eu

# Build only sysupgrade for deprecated
GLUON_DEPRECATED ?= 0

# Gluon Device Class specific features
GLUON_FEATURES_standard := wireless-encryption-wpa3

### Specific Packages

INCLUDE_USB := \
    usbutils

EXCLUDE_USB := \
    -usbutils

INCLUDE_USB_HID := \
    kmod-usb-hid \
    kmod-hid-generic

EXCLUDE_USB_HID := \
    -kmod-usb-hid \
    -kmod-hid-generic

INCLUDE_USB_SERIAL := \
    kmod-usb-serial \
    kmod-usb-serial-ftdi \
    kmod-usb-serial-pl2303

EXCLUDE_USB_SERIAL := \
    -kmod-usb-serial \
    -kmod-usb-serial-ftdi \
    -kmod-usb-serial-pl2303

INCLUDE_USB_STORAGE := \
    block-mount \
    blkid \
    kmod-fs-ext4 \
    kmod-fs-ntfs \
    kmod-fs-vfat \
    kmod-usb-storage \
    kmod-usb-storage-extras \
    kmod-usb-storage-uas \
    kmod-nls-base \
    kmod-nls-cp1250 \
    kmod-nls-cp437 \
    kmod-nls-cp850 \
    kmod-nls-cp852 \
    kmod-nls-iso8859-1 \
    kmod-nls-iso8859-13 \
    kmod-nls-iso8859-15 \
    kmod-nls-iso8859-2 \
    kmod-nls-utf8

EXCLUDE_USB_STORAGE := \
    -block-mount \
    -blkid \
    -kmod-fs-ext4 \
    -kmod-fs-ntfs \
    -kmod-fs-vfat \
    -kmod-usb-storage \
    -kmod-usb-storage-extras \
    -kmod-usb-storage-uas \
    -kmod-nls-base \
    -kmod-nls-cp1250 \
    -kmod-nls-cp437 \
    -kmod-nls-cp850 \
    -kmod-nls-cp852 \
    -kmod-nls-iso8859-1 \
    -kmod-nls-iso8859-13 \
    -kmod-nls-iso8859-15 \
    -kmod-nls-iso8859-2 \
    -kmod-nls-utf8

INCLUDE_USB_NET := \
    kmod-mii \
    kmod-usb-net \
    kmod-usb-net-asix \
    kmod-usb-net-asix-ax88179 \
    kmod-usb-net-cdc-eem \
    kmod-usb-net-cdc-ether \
    kmod-usb-net-cdc-subset \
    kmod-usb-net-dm9601-ether \
    kmod-usb-net-hso \
    kmod-usb-net-ipheth \
    kmod-usb-net-mcs7830 \
    kmod-usb-net-pegasus \
    kmod-usb-net-rndis \
    kmod-usb-net-rtl8152 \
    kmod-usb-net-smsc95xx

EXCLUDE_USB_NET := \
    -kmod-mii \
    -kmod-usb-net \
    -kmod-usb-net-asix \
    -kmod-usb-net-asix-ax88179 \
    -kmod-usb-net-cdc-eem \
    -kmod-usb-net-cdc-ether \
    -kmod-usb-net-cdc-subset \
    -kmod-usb-net-dm9601-ether \
    -kmod-usb-net-hso \
    -kmod-usb-net-ipheth \
    -kmod-usb-net-mcs7830 \
    -kmod-usb-net-pegasus \
    -kmod-usb-net-rndis \
    -kmod-usb-net-rtl8152 \
    -kmod-usb-net-smsc95xx

INCLUDE_PCI := \
    pciutils

EXCLUDE_PCI := \
    -pciutils

INCLUDE_PCI_NET := \
    kmod-bnx2

EXCLUDE_PCI_NET := \
    -kmod-bnx2

INCLUDE_TLS := \
    ca-bundle \
    libustream-opensl

EXCLUDE_TLS := \
    -ca-bundle \
    -libustream-opensl

ifeq ($(GLUON_TARGET),ar71xx-generic)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

    GLUON_allnet-all0315n_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_avm-fritz-wlan-repeater-300e_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_avm-fritz-wlan-repeater-450e_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_d-link-dap-1330-rev-a1_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_d-link-dir-825-rev-b1_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_meraki-mr12_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_meraki-mr16_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ocedo-koala_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_openmesh-mr1750_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_openmesh-mr600_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_openmesh-mr900_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_openmesh-om2p_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_openmesh-om5p_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_openmesh-om5p-ac_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-cpe210-v1_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-cpe210-v2_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-cpe210-v3_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-cpe510-v1_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-wbs210-v1_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-wbs510-v1_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c25-v1_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c58-v1_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c60-v1_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c60-v2_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-re355_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-re450_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-airgateway_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-airgateway-pro_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-bullet-m_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-rocket-m_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-nanostation-m_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-loco-m-xw_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-nanostation-m-xw_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-rocket-m-xw_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-rocket-m-ti_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-unifi_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-unifi-ap-pro_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-unifiap-outdoor_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-unifiap-outdoor+_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-ls-sr71_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-unifi-ac-lite_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-unifi-ac-lr_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-unifi-ac-pro_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-unifi-ac-mesh_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_linksys-wrt160nl_SITE_PACKAGES += $(EXCLUDE_TLS) $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr710n-v1_SITE_PACKAGES += $(EXCLUDE_TLS) $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr710n-v2.1_SITE_PACKAGES += $(EXCLUDE_TLS) $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr842n-nd-v1_SITE_PACKAGES += $(EXCLUDE_TLS) $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr842n-nd-v2_SITE_PACKAGES += $(EXCLUDE_TLS) $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr1043n-nd-v1_SITE_PACKAGES += $(EXCLUDE_TLS) $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubiquiti-airrouter_SITE_PACKAGES += $(EXCLUDE_TLS) $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
endif

# no pkglists for target ar71xx-mikrotik


ifeq ($(GLUON_TARGET),ar71xx-nand)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

# no pkglists for target ar71xx-tiny


ifeq ($(GLUON_TARGET),ath79-generic)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

    GLUON_devolo-wifi-pro-1200e_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_devolo-wifi-pro-1200i_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_devolo-wifi-pro-1750c_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_devolo-wifi-pro-1750i_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_devolo-wifi-pro-1750x_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ocedo-raccoon_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c6-v2_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-cpe220-v3_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
endif

ifeq ($(GLUON_TARGET),brcm2708-bcm2708)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_HID) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),brcm2708-bcm2709)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_HID) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),brcm2708-bcm2710)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_HID) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),ipq40xx-generic)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),ipq806x-generic)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),lantiq-xrx200)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),lantiq-xway)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),mpc85xx-generic)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),mpc85xx-p1020)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),mvebu-cortexa9)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),ramips-mt7620)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),ramips-mt7621)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

    GLUON_netgear-ex6150_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubnt-erx_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_ubnt-erx-sfp_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
endif

ifeq ($(GLUON_TARGET),ramips-mt76x8)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

    GLUON_cudy-wr1000_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_gl.inet-vixmini_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c50-v3_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c50-v4_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wa801nd-v5_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr841n-v13_SITE_PACKAGES += $(EXCLUDE_USB) $(EXCLUDE_USB_NET) $(EXCLUDE_USB_SERIAL) $(EXCLUDE_USB_STORAGE)
endif

# no pkglists for target ramips-rt305x


ifeq ($(GLUON_TARGET),sunxi-cortexa7)
    GLUON_SITE_PACKAGES += $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),x86-64)
    GLUON_SITE_PACKAGES += $(INCLUDE_PCI) $(INCLUDE_PCI_NET) $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),x86-generic)
    GLUON_SITE_PACKAGES += $(INCLUDE_PCI) $(INCLUDE_PCI_NET) $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

ifeq ($(GLUON_TARGET),x86-geode)
    GLUON_SITE_PACKAGES += $(INCLUDE_PCI) $(INCLUDE_PCI_NET) $(INCLUDE_TLS) $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)

endif

# no pkglists for target x86-legacy
