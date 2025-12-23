# This file allows Buildroot to find and include your external packages
include $(sort $(wildcard $(BR2_EXTERNAL_AESD_ASSIGN_PATH)/package/*/*.mk))