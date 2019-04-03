# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Colortail is basically tail but with support for colors. With the help of color config files you define what part of the output to print in which color."
HOMEPAGE="http://joakimandersson.se/projects/colortail/"

SRC_URI="https://github.com/joakim666/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"


src_install() {
	make DESTDIR=${D} install || die
	dodoc README example-conf/conf*
}
