# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/liferea/liferea-1.7.4.ebuild,v 1.6 2011/03/21 22:19:52 nirbheek Exp $

EAPI=2

GCONF_DEBUG=no

inherit eutils gnome2 pax-utils git

MY_P=${P/_/-}

DESCRIPTION="News Aggregator for RDF/RSS/CDF/Atom/Echo/etc feeds"
HOMEPAGE="http://liferea.sourceforge.net/"
EGIT_REPO_URI="git://liferea.git.sourceforge.net/gitroot/liferea/liferea"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="libnotify"

RDEPEND=">=x11-libs/gtk+-2.18.0:2
	>=dev-libs/glib-2.16.0:2
	>=x11-libs/pango-1.4.0
	gnome-base/gconf:2
	dev-libs/libunique:1
	>=dev-libs/libxml2-2.6.27:2
	>=dev-libs/libxslt-1.1.19
	>=dev-db/sqlite-3.6.10:3
	>=net-libs/libsoup-2.28.2:2.4
	>=net-libs/webkit-gtk-1.1.11:2
	libnotify? ( >=x11-libs/libnotify-0.3.2 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog README"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-sm
		--disable-schemas-install
		$(use_enable libnotify)"
}

src_prepare() {
	epatch "${FILESDIR}/fix-mark-read.patch"
	./autogen.sh
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	# bug #338213
	# Uses webkit's JIT. Needs mmap('rwx') to generate code in runtime.
	# MPROTECT policy violation. Will sit here until webkit will
	# get optional JIT.
	pax-mark m "${D}"/usr/bin/liferea
}
