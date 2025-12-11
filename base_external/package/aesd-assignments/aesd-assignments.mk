################################################################################
#
# aesd-assignments
#
################################################################################

AESD_ASSIGNMENTS_VERSION = assignment-5-complete-v9

AESD_ASSIGNMENTS_SITE = git@github.com:cu-ecen-aeld/assignments-3-and-later-siddjove.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_LICENSE = GPL-2.0+
AESD_ASSIGNMENTS_INSTALL_TARGET = YES

# Build: run make from the server subdirectory inside unpacked package
define AESD_ASSIGNMENTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(PKG_BUILD_DIR)/server CC="$(TARGET_CC)"
endef

# Install: copy the built binary and init script from the package server dir into target FS
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	# Ensure target dirs exist
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/bin
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/init.d

	# Install aesdsocket binary
	$(INSTALL) -m 0755 $(PKG_BUILD_DIR)/server/aesdsocket \
		$(TARGET_DIR)/usr/bin/aesdsocket

	# Install init script so it runs at boot (S99 priority)
	$(INSTALL) -m 0755 $(PKG_BUILD_DIR)/server/aesdsocket-start-stop \
		$(TARGET_DIR)/etc/init.d/S99aesdsocket
endef

$(eval $(generic-package))

