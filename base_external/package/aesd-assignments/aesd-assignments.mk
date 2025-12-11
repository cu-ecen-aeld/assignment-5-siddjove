# AESD assignment package for buildroot
# Assignment repo commit referenced:
AESD_ASSIGNMENTS_VERSION = 61d334296210877130c40c5a6d4153f1c27d1e58
AESD_ASSIGNMENTS_SITE = git@github.com:cu-ecen-aeld/assignments-3-and-later-siddjove.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

# We will vendor buildroot-assignments-base inside this repo to avoid submodule issues.
AESD_ASSIGNMENTS_SUBMODULES = YES
AESD_ASSIGNMENTS_SUBMODULES_URL = git@github.com:cu-ecen-aeld/buildroot-assignments-base.git
