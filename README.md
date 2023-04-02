# Experiments with Chromium for Sailfish OS

This is a repository containing files and docs regarding Chromium
packaging for Sailfish OS.

Disclaimer: *IT CANNOT BE USED AS A BROWSER AT THE MOMENT*

As we have /opt/qt5, we have access to newer Wayland protocols. So, it
is possible to get access to newer protocols via nested
compositor. Experiments are done with `pure-qml` (example from Qt
running inside `qt-runner`) or
[newcompositor](https://github.com/ArturGaspar/newcompositor)

## Status

- Chromium can start on SFOS without any containers

- It can show its window to `WAYLAND_DISPLAY` exported by pure-qml or
  newcompositor.

- In pure-qml pinch to zoom and scrolling work. Pinch to zoom didn't
  work in newcompositor.

- In newcompositor it is possible to get chromium scaled by running
  `QT_SCALE_FACTOR=2 newcompositor` . Doesn't scale in pure-qml yet

- Breaking: No keyboard support

- Not sure about HW acceleration as I cannot enter `chrome://gpu`
  without keyboard.


## Build instructions

- it is possible to compile Chromium using regular Chromium build
  instructions for cross-compiling it:
  - https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md
  - https://gn.googlesource.com/gn/+/main/docs/quick_start.md
  - https://chromium.googlesource.com/chromium/src/+/main/docs/linux/chromium_arm.md

- setup sources as described in those HOWTOs.

- build was done in Docker (see [Dockerfile](Dockerfile)) and then
  through interactive use. Should be simple to do with other supported
  Linux distros.

- used settings are in [args.gn](args.gn)

- To get cross-compilation sysroot, run
  `build/linux/sysroot_scripts/install-sysroot.py --arch=arm64`

- Compilation:

```
autoninja -C out/arm64 chrome
ninja -C out/arm64 "chrome/installer/linux:unstable_deb"
```

- Create tgz from generated DEB by `alien -t chromium-browser-unstable*arm64.deb`


## Stdout

```
/opt/chromium.org/chromium-unstable/chromium-browser --start-maximized
MESA-LOADER: failed to open msm_drm: /usr/lib64/dri/msm_drm_dri.so: cannot open shared object file: No such file or directory (search paths /usr/lib64/dri)
failed to load driver: msm_drm
MESA-LOADER: failed to open kms_swrast: /usr/lib64/dri/kms_swrast_dri.so: cannot open shared object file: No such file or directory (search paths /usr/lib64/dri)
failed to load driver: kms_swrast
MESA-LOADER: failed to open swrast: /usr/lib64/dri/swrast_dri.so: cannot open shared object file: No such file or directory (search paths /usr/lib64/dri)
failed to load swrast driver
[16486:16510:0402/184944.633320:ERROR:object_proxy.cc(623)] Failed to call method: org.freedesktop.DBus.Properties.Get: object_path= /org/freedesktop/portal/desktop: org.freedesktop.DBus.Error.InvalidArgs: No such interface “org.freedesktop.portal.FileC
hooser”   
[16486:16510:0402/184944.634042:ERROR:select_file_dialog_linux_portal.cc(274)] Failed to read portal version property
MESA-LOADER: failed to open msm_drm: /usr/lib64/dri/msm_drm_dri.so: cannot open shared object file: No such file or directory (search paths /usr/lib64/dri)
failed to load driver: msm_drm
MESA-LOADER: failed to open kms_swrast: /usr/lib64/dri/kms_swrast_dri.so: cannot open shared object file: No such file or directory (search paths /usr/lib64/dri)
failed to load driver: kms_swrast
MESA-LOADER: failed to open swrast: /usr/lib64/dri/swrast_dri.so: cannot open shared object file: No such file or directory (search paths /usr/lib64/dri)
failed to load swrast driver
[16486:16486:0402/184944.652570:ERROR:chrome_browser_cloud_management_controller.cc(162)] Cloud management controller initialization aborted as CBCM is not enabled.
library "libGLESv2_adreno.so" not found
library "eglSubDriverAndroid.so" not found
[16522:16522:0402/184944.717364:ERROR:gl_angle_util_vulkan.cc(189)] Failed to retrieve vkGetInstanceProcAddr
[16522:16522:0402/184944.717553:ERROR:vulkan_instance.cc(91)] Failed to get vkGetInstanceProcAddr pointer from ANGLE.
[16486:16589:0402/184944.990526:ERROR:object_proxy.cc(623)] Failed to call method: org.freedesktop.DBus.Properties.Get: object_path= /org/freedesktop/UPower: org.freedesktop.DBus.Error.ServiceUnknown: The name org.freedesktop.UPower was not provided by any .service files
[16486:16589:0402/184944.991343:ERROR:object_proxy.cc(623)] Failed to call method: org.freedesktop.UPower.GetDisplayDevice: object_path= /org/freedesktop/UPower: org.freedesktop.DBus.Error.ServiceUnknown: The name org.freedesktop.UPower was not provided by any .service files
[16486:16589:0402/184944.992460:ERROR:object_proxy.cc(623)] Failed to call method: org.freedesktop.UPower.EnumerateDevices: object_path= /org/freedesktop/UPower: org.freedesktop.DBus.Error.ServiceUnknown: The name org.freedesktop.UPower was not provided by any .service files
```

## Linked libraries in this build

```
ldd /opt/chromium.org/chromium-unstable/chrome
        linux-vdso.so.1 (0x00000079e5d71000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00000079d7b97000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00000079d7b66000)
        libnss3.so => /usr/lib64/libnss3.so (0x00000079d7a3c000)
        libnssutil3.so => /usr/lib64/libnssutil3.so (0x00000079d79fb000)
        libsmime3.so => /usr/lib64/libsmime3.so (0x00000079d79c3000)
        libnspr4.so => /usr/lib64/libnspr4.so (0x00000079d7974000)
        libcups.so.2 => /usr/lib64/libcups.so.2 (0x00000079d78c5000)
        libgio-2.0.so.0 => /usr/lib64/libgio-2.0.so.0 (0x00000079d76bf000)
        libgobject-2.0.so.0 => /usr/lib64/libgobject-2.0.so.0 (0x00000079d7648000)
        libglib-2.0.so.0 => /usr/lib64/libglib-2.0.so.0 (0x00000079d7500000)
        libdbus-1.so.3 => /usr/lib64/libdbus-1.so.3 (0x00000079d7490000)
        libdrm.so.2 => /usr/lib64/libdrm.so.2 (0x00000079d746d000)
        libxkbcommon.so.0 => /usr/lib64/libxkbcommon.so.0 (0x00000079d741a000)
        libgbm.so.1 => /usr/lib64/libgbm.so.1 (0x00000079d73fc000)
        libasound.so.2 => /usr/lib64/libasound.so.2 (0x00000079d72e6000)
        libm.so.6 => /lib64/libm.so.6 (0x00000079d7235000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00000079d7210000)
        libc.so.6 => /lib64/libc.so.6 (0x00000079d707f000)
        /lib/ld-linux-aarch64.so.1 (0x00000079e5d41000)
        libplc4.so => /usr/lib64/libplc4.so (0x00000079d706a000)
        libplds4.so => /usr/lib64/libplds4.so (0x00000079d7056000)
        libgnutls.so.26 => /usr/lib64/libgnutls.so.26 (0x00000079d6f7c000)
        libz.so.1 => /usr/lib64/libz.so.1 (0x00000079d6f4b000)
        libgmodule-2.0.so.0 => /usr/lib64/libgmodule-2.0.so.0 (0x00000079d6f37000)
        libselinux.so.1 => /usr/lib64/libselinux.so.1 (0x00000079d6efe000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00000079d6ed6000)
        libffi.so.8 => /usr/lib64/libffi.so.8 (0x00000079d6eaf000)
        libpcre.so.1 => /usr/lib64/libpcre.so.1 (0x00000079d6e61000)
        libsystemd.so.0 => /usr/lib64/libsystemd.so.0 (0x00000079d6dba000)
        libwayland-server.so.0 => /usr/lib64/libwayland-server.so.0 (0x00000079d6d96000)
        libexpat.so.1 => /usr/lib64/libexpat.so.1 (0x00000079d6d54000)
        libgcrypt.so.20 => /usr/lib64/libgcrypt.so.20 (0x00000079d6c6c000)
        libtasn1.so.6 => /usr/lib64/libtasn1.so.6 (0x00000079d6c49000)
        libp11-kit.so.0 => /usr/lib64/libp11-kit.so.0 (0x00000079d6b03000)
        librt.so.1 => /lib64/librt.so.1 (0x00000079d6ae9000)
        liblzma.so.5 => /usr/lib64/liblzma.so.5 (0x00000079d6ab4000)
        libcap.so.2 => /usr/lib64/libcap.so.2 (0x00000079d6a9f000)
        libmount.so.1 => /usr/lib64/libmount.so.1 (0x00000079d6a2c000)
        libgpg-error.so.0 => /usr/lib64/libgpg-error.so.0 (0x00000079d69f9000)
        libblkid.so.1 => /usr/lib64/libblkid.so.1 (0x00000079d698f000)
```