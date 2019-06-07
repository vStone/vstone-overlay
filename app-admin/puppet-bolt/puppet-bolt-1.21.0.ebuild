# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils systemd unpacker user

DESCRIPTION="general puppet bolt client "
HOMEPAGE="https://puppetlabs.com/"
SRC_BASE="http://apt.puppet.com/pool/stretch/puppet/${PN:0:1}/${PN}/${PN}_${PV}-1stretch"
SRC_URI="
	amd64? ( ${SRC_BASE}_amd64.deb )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="selinux"
RESTRICT="strip"

CDEPEND="!app-admin/augeas
	!app-admin/puppet
	!dev-ruby/hiera
	!dev-ruby/facter
	!app-emulation/virt-what"

DEPEND="
	${CDEPEND}"
RDEPEND="${CDEPEND}
	app-portage/eix
	sys-apps/dmidecode
	sys-libs/glibc
	sys-libs/readline:0/7
	sys-libs/ncurses:0[tinfo]
	selinux? (
		sys-libs/libselinux[ruby]
	)"

S=${WORKDIR}

src_install() {
	# logrotate.d
	# the rest
	insinto /opt
	#dodir opt/puppetlabs/puppet/cache
	doins -r opt/*
	# init
	# symlinks
	chmod 0755 -R "${D}/opt/puppetlabs/bolt/bin/"
	chmod 0755 "${D}/opt/puppetlabs/bin/bolt"
	dosym ../../opt/puppetlabs/bin/bolt /usr/bin/bolt
}
