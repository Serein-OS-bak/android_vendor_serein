# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

# Custom Version
SEREIN_CODENAME=kekzu
SEREIN_BRANCH=pie

# SEREIN RELEASE VERSION
SEREIN_VERSION_MAJOR = 1
SEREIN_VERSION_MINOR = 0
SEREIN_VERSION_MAINTENANCE = 0

VERSION := $(SEREIN_VERSION_MAJOR).$(SEREIN_VERSION_MINOR)

ifndef SEREIN_BUILDTYPE
    ifdef RELEASE_TYPE
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^SEREIN_||g')
        SEREIN_BUILDTYPE := $(RELEASE_TYPE)
    else
        SEREIN_BUILDTYPE := UNOFFICIAL
    endif
endif

ifdef SEREIN_BUILDTYPE
    ifeq ($(SEREIN_BUILDTYPE), OFFICIAL)
       SEREIN_VERSION := $(TARGET_PRODUCT)_$(SEREIN_CODENAME)_$(SEREIN_BRANCH)-$(VERSION)-OFFICIAL-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(SEREIN_BUILDTYPE), NIGHTLY)
        SEREIN_VERSION := $(TARGET_PRODUCT)_$(SEREIN_CODENAME)_$(SEREIN_BRANCH)-$(VERSION)-NIGHTLY-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(SEREIN_BUILDTYPE), WEEKLY)
       SEREIN_VERSION := $(TARGET_PRODUCT)_$(SEREIN_CODENAME)_$(SEREIN_BRANCH)-$(VERSION)-WEEKLY-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(SEREIN_BUILDTYPE), EXPERIMENTAL)
        SEREIN_VERSION := $(TARGET_PRODUCT)_$(SEREIN_CODENAME)_$(SEREIN_BRANCH)-$(VERSION)-EXPERIMENTAL-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(SEREIN_BUILDTYPE), RC)
        SEREIN_VERSION := $(TARGET_PRODUCT)_$(SEREIN_CODENAME)_$(SEREIN_BRANCH)-$(VERSION)-RC-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(SEREIN_BUILDTYPE), UNOFFICIAL)
        SEREIN_VERSION := $(TARGET_PRODUCT)_$(SEREIN_CODENAME)_$(SEREIN_BRANCH)-$(VERSION)-UNOFFICIAL-$(shell date -u +%Y%m%d)
    endif
else
#We reset back to UNOFFICIAL
        SEREIN_VERSION := $(TARGET_PRODUCT)_$(SEREIN_CODENAME)_$(SEREIN_BRANCH)-$(VERSION)-UNOFFICIAL-$(shell date -u +%Y%m%d)
endif

# SEREIN System Version
PRODUCT_PROPERTY_OVERRIDES += \
    ro.modversion=$(VERSION)-$(SEREIN_BUILDTYPE) \
    ro.serein.releasetype=$(SEREIN_BUILDTYPE) \
    ro.serein.version=$(VERSION)-$(SEREIN_BUILDTYPE) \
    ro.serein.version.update=$(SEREIN_BRANCH)-$(VERSION) \
    ro.serein.build.version=$(VERSION) \
    ro.serein.display.version=$(SEREIN_VERSION) \
    ro.serein.codename=$(SEREIN_CODENAME)
