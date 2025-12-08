# External tree for AESD project base

# Buildroot (when using external.desc) defines:
#   BR2_EXTERNAL_PROJECT_BASE_PATH
# We just need to include all external package .mk files.

include $(sort $(wildcard $(BR2_EXTERNAL_PROJECT_BASE_PATH)/package/*/*.mk))
