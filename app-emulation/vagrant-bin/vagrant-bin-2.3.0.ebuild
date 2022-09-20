# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

VAGRANT_DL_URI="https://releases.hashicorp.com/vagrant"
VAGRANT_PN="${PN/-bin}"
VAGRANT_P="${VAGRANT_PN}-${PV}-1"

inherit eutils rpm epatch

DESCRIPTION="Development environments made easy."
HOMEPAGE="http://vagrantup.com"

SRC_URI="
    amd64?  ( ${VAGRANT_DL_URI}/${PV}/${VAGRANT_P}.x86_64.rpm )
    x86?    ( ${VAGRANT_DL_URI}/${PV}/${VAGRANT_P}.i686.rpm )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-*" #~amd64 ~x86"
IUSE=""

DEPEND="virtual/libcrypt"
RDEPEND="${DEPEND}
    !app-emulation/vagrant
"

RESTRICT="mirror"

src_unpack() {
    mkdir -p ${S}
    cd ${S}
    rpm_unpack ${A}
    cd ${WORKDIR}
}

src_install() {
    dodir /opt
    einfo "DESTDIR: ${D}"
    einfo "SOURCEDIR: ${S}"
    cp -Rv "${S}/opt/vagrant" "${D}/opt" || die "Install failed!"

    dobin usr/bin/vagrant || die
}
