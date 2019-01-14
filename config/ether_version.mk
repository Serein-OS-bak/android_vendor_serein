# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

# Custom Version
ETHER_CODENAME=kekzu
ETHER_BRANCH=pie

# ETHER RELEASE VERSION
ETHER_VERSION_MAJOR = 1
ETHER_VERSION_MINOR = 0
ETHER_VERSION_MAINTENANCE = 0

# Only include SereinOTA for official builds
ifeq ($(filter-out OFFICIAL EXPERIMENTAL ,$(ETHER_BUILDTYPE)),)
    PRODUCT_PACKAGES += \
        SereinOTA
endif

VERSION := $(ETHER_VERSION_MAJOR).$(ETHER_VERSION_MINOR)

ifndef ETHER_BUILDTYPE
    ifdef RELEASE_TYPE
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^ETHER_||g')
        ETHER_BUILDTYPE := $(RELEASE_TYPE)
    else
        ETHER_BUILDTYPE := UNOFFICIAL
    endif
endif

ifdef ETHER_BUILDTYPE
    ifeq ($(ETHER_BUILDTYPE), OFFICIAL)
       ETHER_VERSION := $(TARGET_PRODUCT)_$(ETHER_CODENAME)_$(ETHER_BRANCH)-$(VERSION)-OFFICIAL-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(ETHER_BUILDTYPE), NIGHTLY)
        ETHER_VERSION := $(TARGET_PRODUCT)_$(ETHER_CODENAME)_$(ETHER_BRANCH)-$(VERSION)-NIGHTLY-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(ETHER_BUILDTYPE), WEEKLY)
       ETHER_VERSION := $(TARGET_PRODUCT)_$(ETHER_CODENAME)_$(ETHER_BRANCH)-$(VERSION)-WEEKLY-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(ETHER_BUILDTYPE), EXPERIMENTAL)
        ETHER_VERSION := $(TARGET_PRODUCT)_$(ETHER_CODENAME)_$(ETHER_BRANCH)-$(VERSION)-EXPERIMENTAL-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(ETHER_BUILDTYPE), RC)
        ETHER_VERSION := $(TARGET_PRODUCT)_$(ETHER_CODENAME)_$(ETHER_BRANCH)-$(VERSION)-RC-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(ETHER_BUILDTYPE), UNOFFICIAL)
        ETHER_VERSION := $(TARGET_PRODUCT)_$(ETHER_CODENAME)_$(ETHER_BRANCH)-$(VERSION)-UNOFFICIAL-$(shell date -u +%Y%m%d)
    endif
else
#We reset back to UNOFFICIAL
        ETHER_VERSION := $(TARGET_PRODUCT)_$(ETHER_CODENAME)_$(ETHER_BRANCH)-$(VERSION)-UNOFFICIAL-$(shell date -u +%Y%m%d)
endif

# ETHER System Version
PRODUCT_PROPERTY_OVERRIDES += \
    ro.modversion=$(VERSION)-$(ETHER_BUILDTYPE) \
    ro.ether.releasetype=$(ETHER_BUILDTYPE) \
    ro.ether.version=$(VERSION)-$(ETHER_BUILDTYPE) \
    ro.ether.version.update=$(ETHER_BRANCH)-$(VERSION) \
    ro.ether.build.version=$(VERSION) \
    ro.ether.display.version=$(ETHER_VERSION) \
    ro.ether.codename=$(ETHER_CODENAME)
