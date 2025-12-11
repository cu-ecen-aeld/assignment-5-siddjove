################################################################################
#
# aesd-assignments
#
################################################################################

AESD_ASSIGNMENTS_VERSION = assignment-5-complete-v9

# Keep SSH (as you requested)
AESD_ASSIGNMENTS_SITE = git@github.com:cu-ecen-aeld/assignments-3-and-later-siddjove.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_LICENSE = GPL-2.0+
AESD_ASSIGNMENTS_INSTALL_TARGET = YES

# Build: run make in the server subdir, using the cross-compiler
define AESD_ASSIGNMENTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(PKG_BUILD_DIR)/server CC="$(TARGET_CC)"
endef

# Install into target rootfs using Buildroot macros
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(INSTALL_DIR) $(TARGET_DIR)/usr/bin
	$(INSTALL_DIR) $(TARGET_DIR)/etc/init.d

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server/aesdsocket $(TARGET_DIR)/usr/bin/aesdsocket
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server/aesdsocket-start-stop $(TARGET_DIR)/etc/init.d/S99aesdsocket

	# extra safety perms (no-op if already correct)
	chmod 0755 $(TARGET_DIR)/usr/bin/aesdsocket || true
	chmod 0755 $(TARGET_DIR)/etc/init.d/S99aesdsocket || true
endef

$(eval $(generic-package))

