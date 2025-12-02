################################################################################
# AESD Assignments Package
################################################################################

AESD_ASSIGNMENTS_VERSION = master
AESD_ASSIGNMENTS_SITE = git@github.com:cu-ecen-aeld/assignments-3-and-later-siddjove.git
AESD_ASSIGNMENTS_SITE_METHOD = git

AESD_ASSIGNMENTS_LICENSE = Proprietary
AESD_ASSIGNMENTS_LICENSE_FILES =

# Build step: use Buildroot's cross compiler to build writer
define AESD_ASSIGNMENTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/finder-app CC="$(TARGET_CC)"
endef

# Install step: put binaries and scripts into /usr/bin,
# and config files into /etc/finder-app/conf
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	# Install writer binary
	$(INSTALL) -D $(@D)/finder-app/writer $(TARGET_DIR)/usr/bin/writer

	# Install scripts
	$(INSTALL) -D $(@D)/finder-app/finder.sh $(TARGET_DIR)/usr/bin/finder.sh
	$(INSTALL) -D $(@D)/finder-app/finder-test.sh $(TARGET_DIR)/usr/bin/finder-test.sh

	# Install configuration files
	$(INSTALL) -D -m 0644 $(@D)/finder-app/conf/username.txt \
		$(TARGET_DIR)/etc/finder-app/conf/username.txt
	$(INSTALL) -D -m 0644 $(@D)/finder-app/conf/assignment.txt \
		$(TARGET_DIR)/etc/finder-app/conf/assignment.txt
endef

$(eval $(generic-package))

