################################################################################
#
# aesd-assignments
#
################################################################################

# Use your A3+ repo as the source
AESD_ASSIGNMENTS_VERSION = 89167357d86f8c4c8229b7e4bd986564285f01a8
AESD_ASSIGNMENTS_SITE = git@github.com:cu-ecen-aeld/assignments-3-and-later-siddjove.git
AESD_ASSIGNMENTS_SITE_METHOD = git

# Build the finder-app using the cross compiler
define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) -C $(@D)/finder-app CC="$(TARGET_CC)"
endef

# Install scripts and binaries into target rootfs
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	# Scripts and binaries into /usr/bin
	$(INSTALL) -D -m 0755 $(@D)/finder-app/finder.sh $(TARGET_DIR)/usr/bin/finder.sh
	$(INSTALL) -D -m 0755 $(@D)/finder-app/writer $(TARGET_DIR)/usr/bin/writer
	$(INSTALL) -D -m 0755 $(@D)/finder-app/finder-test.sh $(TARGET_DIR)/usr/bin/finder-test.sh

	# Config files into /etc/finder-app/conf
	$(INSTALL) -d $(TARGET_DIR)/etc/finder-app/conf
	cp -r $(@D)/finder-app/conf/* $(TARGET_DIR)/etc/finder-app/conf/
endef

$(eval $(generic-package))
