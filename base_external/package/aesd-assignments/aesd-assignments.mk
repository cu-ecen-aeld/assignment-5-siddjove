################################################################################
#
# aesd-assignments
#
################################################################################

AESD_ASSIGNMENTS_VERSION = assignment-5-complete-v9

# Use HTTPS so CI doesn't require an SSH key by default
AESD_ASSIGNMENTS_SITE = https://github.com/cu-ecen-aeld/assignments-3-and-later-siddjove.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_LICENSE = GPL-2.0+
AESD_ASSIGNMENTS_INSTALL_TARGET = YES

# If your repo uses a specific branch/tag, you can set:
# AESD_ASSIGNMENTS_SITE_SUBDIR = <optional>
# AESD_ASSIGNMENTS_SITE_TAG = <optional>

# Build: run make in the server subdir, using the cross-compiler from TARGET_CC
define AESD_ASSIGNMENTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(PKG_BUILD_DIR)/server CC="$(TARGET_CC)"
endef

# Install into target rootfs
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	# Ensure target directories exist
	$(INSTALL_DIR) $(TARGET_DIR)/usr/bin
	$(INSTALL_DIR) $(TARGET_DIR)/etc/init.d

	# Install the cross-built aesdsocket binary (ensure it was built under server/)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server/aesdsocket $(TARGET_DIR)/usr/bin/aesdsocket

	# Install the init script as S99aesdsocket so it runs at boot
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server/aesdsocket-start-stop $(TARGET_DIR)/etc/init.d/S99aesdsocket
	# Ensure permissions
	chmod 0755 $(TARGET_DIR)/etc/init.d/S99aesdsocket || true
	chmod 0755 $(TARGET_DIR)/usr/bin/aesdsocket || true
endef

$(eval $(generic-package))

