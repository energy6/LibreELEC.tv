################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="xorg-server"
PKG_VERSION="94f036d"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://anongit.freedesktop.org/git/xorg/xserver.git"
PKG_DEPENDS_TARGET="toolchain util-macros font-util xorgproto libpciaccess libX11 libXfont2 libXinerama libxshmfence libxkbfile libdrm openssl freetype pixman systemd xorg-launch-helper"
PKG_NEED_UNPACK="$(get_pkg_directory xf86-video-nvidia) $(get_pkg_directory xf86-video-nvidia-legacy)"
PKG_SECTION="x11/xserver"
PKG_SHORTDESC="xorg-server: The Xorg X server"
PKG_LONGDESC="Xorg is a full featured X server that was originally designed for UNIX and UNIX-like operating systems running on Intel x86 hardware."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_USE_MESON="no"

pre_build_target() {
  git clone $PKG_SITE $PKG_BUILD/$PKG_NAME-git
  cd $PKG_BUILD/$PKG_NAME-git
  git reset --hard $PKG_VERSION
  cd -
  mv $PKG_BUILD/$PKG_NAME-git/* $PKG_BUILD/
  rm -rf $PKG_BUILD/$PKG_NAME-git
  for a in $PKG_DIR/patches/*.patch
  do
    patch -p1 -d $PKG_BUILD < $a
  done
}

get_graphicdrivers

if [ "$COMPOSITE_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libXcomposite"
  XORG_COMPOSITE="--enable-composite"
else
  XORG_COMPOSITE="--disable-composite"
fi

if [ ! "$OPENGL" = "no" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGL libepoxy glu"
  XORG_MESA="--enable-glx --enable-dri --enable-glamor"
else
  XORG_MESA="--disable-glx --disable-dri --disable-glamor"
fi

PKG_CONFIGURE_OPTS_TARGET="--disable-debug \
                           --disable-silent-rules \
                           --disable-strict-compilation \
                           --enable-largefile \
                           --enable-visibility \
                           --disable-unit-tests \
                           --disable-sparkle \
                           --disable-xselinux \
                           $XORG_COMPOSITE \
                           --enable-mitshm \
                           --enable-record \
                           --enable-xv \
                           --disable-xvmc \
                           --enable-dga \
                           --disable-screensaver \
                           --disable-xdmcp \
                           --disable-xdm-auth-1 \
                           $XORG_MESA \
                           --enable-dri2 \
                           --enable-dri3 \
                           --enable-present \
                           --enable-xinerama \
                           --enable-xf86vidmode \
                           --disable-xace \
                           --disable-xselinux \
                           --disable-xcsecurity \
                           --disable-tslib \
                           --enable-dbe \
                           --disable-xf86bigfont \
                           --enable-dpms \
                           --enable-config-udev \
                           --enable-config-udev-kms \
                           --disable-config-hal \
                           --disable-config-wscons \
                           --enable-xfree86-utils \
                           --enable-vgahw \
                           --enable-vbe \
                           --enable-int10-module \
                           --disable-windowswm \
                           --enable-libdrm \
                           --enable-clientids \
                           --enable-pciaccess \
                           --disable-linux-acpi \
                           --disable-linux-apm \
                           --disable-systemd-logind \
                           --enable-xorg \
                           --disable-dmx \
                           --disable-xvfb \
                           --disable-xnest \
                           --disable-xquartz \
                           --disable-standalone-xpbproxy \
                           --disable-xwin \
                           --disable-kdrive \
                           --disable-xephyr \
                           --disable-xfake \
                           --disable-xfbdev \
                           --disable-kdrive-kbd \
                           --disable-kdrive-mouse \
                           --disable-kdrive-evdev \
                           --disable-libunwind \
                           --enable-xshmfence \
                           --disable-install-setuid \
                           --enable-unix-transport \
                           --disable-tcp-transport \
                           --disable-ipv6 \
                           --disable-local-transport \
                           --disable-secure-rpc \
                           --enable-input-thread \
                           --enable-xtrans-send-fds \
                           --disable-docs \
                           --disable-devel-docs \
                           --with-int10=x86emu \
                           --with-gnu-ld \
                           --with-sha1=libcrypto \
                           --without-systemd-daemon \
                           --with-os-vendor=LibreELEC.tv \
                           --with-module-dir=$XORG_PATH_MODULES \
                           --with-xkb-path=$XORG_PATH_XKB \
                           --with-xkb-output=/var/cache/xkb \
                           --with-log-dir=/var/log \
                           --with-fontrootdir=/usr/share/fonts \
                           --with-default-font-path=/usr/share/fonts/misc,built-ins \
                           --with-serverconfig-path=/usr/lib/xserver \
                           --without-xmlto \
                           --without-fop"

pre_configure_target() {
# hack to prevent a build error
  CFLAGS=`echo $CFLAGS | sed -e "s|-O3|-O2|" -e "s|-Ofast|-O2|"`
  LDFLAGS=`echo $LDFLAGS | sed -e "s|-O3|-O2|" -e "s|-Ofast|-O2|"`
  strip_lto
  strip_gold
  cd ..
  do_autoreconf
  cd -
}

post_makeinstall_target() {
  rm -rf $INSTALL/var/cache/xkb

  mkdir -p $INSTALL/usr/lib/xorg
    cp -P $PKG_DIR/scripts/xorg-configure $INSTALL/usr/lib/xorg
      sed -i -e "s|@NVIDIA_VERSION@|$(get_pkg_version xf86-video-nvidia)|g" $INSTALL/usr/lib/xorg/xorg-configure
      sed -i -e "s|@NVIDIA_LEGACY_VERSION@|$(get_pkg_version xf86-video-nvidia-legacy)|g" $INSTALL/usr/lib/xorg/xorg-configure

  if [ ! "$OPENGL" = "no" ]; then
    if [ -f $INSTALL/usr/lib/xorg/modules/extensions/libglx.so ]; then
      mv $INSTALL/usr/lib/xorg/modules/extensions/libglx.so \
         $INSTALL/usr/lib/xorg/modules/extensions/libglx_mesa.so # rename for cooperate with nvidia drivers
      ln -sf /var/lib/libglx.so $INSTALL/usr/lib/xorg/modules/extensions/libglx.so
    fi
  fi

  mkdir -p $INSTALL/etc/X11
    if [ -f $PROJECT_DIR/$PROJECT/xorg/xorg.conf ]; then
      cp $PROJECT_DIR/$PROJECT/xorg/xorg.conf $INSTALL/etc/X11
    fi
    cp $PKG_DIR/config/xorg*.conf $INSTALL/etc/X11

  if [ ! "$DEVTOOLS" = yes ]; then
    rm -rf $INSTALL/usr/bin/cvt
    rm -rf $INSTALL/usr/bin/gtf
  fi
}

post_install() {
  enable_service xorg.service
}
