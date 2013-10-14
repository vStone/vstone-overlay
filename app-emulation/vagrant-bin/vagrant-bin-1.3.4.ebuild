# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $



EAPI=5

VAGRANT_DL_URI="http://files.vagrantup.com/packages"
VAGRANT_DL_HASH="0ac2a87388419b989c3c0d0318cc97df3b0ed27d"
VAGRANT_PN="${PN/-bin}"
VAGRANT_P="${VAGRANT_PN}_${PV}"

inherit eutils rpm

DESCRIPTION="Development environments made easy."
HOMEPAGE="http://vagrantup.com"

SRC_URI="
    amd64?  ( ${VAGRANT_DL_URI}/${VAGRANT_DL_HASH}/${VAGRANT_P}_x86_64.rpm )
    x86?    ( ${VAGRANT_DL_URI}/${VAGRANT_DL_HASH}/${VAGRANT_P}_i686.rpm )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-*" #~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
    !app-emulation/vagrant"

RESTRICT="mirror"

src_unpack() {
    mkdir -p ${S}
    cd ${S}
    rpm_unpack ${A}
    cd ${WORKDIR}
}

src_prepare() {
    true
}

src_install() {
    dodir /opt
    einfo "DESTDIR: ${D}"
    einfo "SOURCEDIR: ${S}"
    cp -Rv "${S}/opt/vagrant" "${D}/opt" || die "Install failed!"

    dobin usr/bin/vagrant || die
}
