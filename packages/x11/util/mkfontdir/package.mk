################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="mkfontdir"
PKG_VERSION="1.0.7"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://xorg.freedesktop.org"
PKG_URL="https://xorg.freedesktop.org/archive/individual/app/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="mkfontscale:host"
PKG_SECTION="x11/util"
PKG_SHORTDESC="mkfontdir creates the fonts.dir files needed by the legacy X server core font system."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
