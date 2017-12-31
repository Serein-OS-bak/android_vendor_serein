PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup tool
PRODUCT_COPY_FILES += \
    vendor/serein/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/serein/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/serein/prebuilt/common/bin/50-serein.sh:system/addon.d/50-serein.sh \
    vendor/serein/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/serein/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/serein/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/serein/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Backup services whitelist
PRODUCT_COPY_FILES += \
    vendor/serein/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/serein/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# serein-specific init file
PRODUCT_COPY_FILES += \
    vendor/serein/prebuilt/common/etc/init.local.rc:root/init.serein.rc

# Copy LatinIME for gesture typing
PRODUCT_COPY_FILES += \
    vendor/serein/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/serein/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/serein/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/serein/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

# Fix Dialer
#PRODUCT_COPY_FILES +=  \
#    vendor/serein/prebuilt/common/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# serein-specific startup services
PRODUCT_COPY_FILES += \
    vendor/serein/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/serein/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/serein/prebuilt/common/bin/sysinit:system/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    SpareParts \
    LockClock \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam \
    OmniStyle

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# Extra Optional packages
PRODUCT_PACKAGES += \
    Calculator \
    LatinIME \
    BluetoothExt \
    Launcher3Dark


# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Default notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.notification_sound=Popcorn.ogg \
    ro.config.alarm_alert=Bright_morning.ogg

# Default ringtone
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=The_big_adventure.ogg

PRODUCT_PACKAGES += \
    charger_res_images

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Miracast
PRODUCT_PROPERTY_OVERRIDES += \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# Disable rescue party
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.disable_rescue=true

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGES += \
    AndroidDarkThemeOverlay \
    SettingsDarkThemeOverlay

PRODUCT_PACKAGE_OVERLAYS += vendor/serein/overlay/common

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID)

# sereinOS extras
include vendor/sereinextras/config.mk

# Custom sereinOS versioning system
include vendor/serein/config/serein_version.mk

# Telephony-ext
 PRODUCT_PACKAGES += \
    telephony-ext
 PRODUCT_BOOT_JARS += \
    telephony-ext

EXTENDED_POST_PROCESS_PROPS := vendor/serein/tools/serein_process_props.py

