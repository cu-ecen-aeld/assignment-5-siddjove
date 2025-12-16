AESD_ASSIGNMENTS_SITE = https://github.com/cu-ecen-aeld/assignments-3-and-later-siddjove.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_VERSION = main

define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/server
endef

define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket \
		$(TARGET_DIR)/usr/bin/aesdsocket

	$(INSTALL) -d $(TARGET_DIR)/etc/init.d
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket-start-stop \
		$(TARGET_DIR)/etc/init.d/S99aesdsocket
endef

$(eval $(generic-package))

