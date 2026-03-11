rm -rf package/emortal/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led package/luci-app-athena-led/root/usr/sbin/athena-led

# Fix mbedtls GCC 14 build failure on aarch64 (cortex-a53):
# The #pragma GCC push_options/target("arch=armv8-a+crypto") block covers
# both capability-detection helpers AND init/free functions. GCC 14 refuses
# to inline always_inline memset (from _FORTIFY_SOURCE) inside a +crypto
# function when memset itself was compiled for the base target. This patch
# scopes the +crypto pragma tightly: one scope for detection helpers, one
# scope for hardware process functions, leaving init/free with default target.
mkdir -p package/libs/mbedtls/patches
cp -f $GITHUB_WORKSPACE/scripts/102-fix-sha256-gcc14-aarch64.patch \
    package/libs/mbedtls/patches/102-fix-sha256-gcc14-aarch64.patch