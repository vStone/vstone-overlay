# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/screen/screen-4.0.3-r4.ebuild,v 1.1 2010/12/08 19:11:04 jlec Exp $

EAPI="3"

WANT_AUTOCONF="2.5"

inherit eutils flag-o-matic toolchain-funcs pam autotools


EGIT_REPO_URI="git://git.savannah.gnu.org/screen.git"
if [[ ${PV} == "9999" ]] ; then
	inherit git
else
	SRC_URI="ftp://ftp.uni-erlangen.de/pub/utilities/${PN}/${P}.tar.gz"
fi

DESCRIPTION="Full-screen window manager that multiplexes physical terminals between several processes"
HOMEPAGE="http://www.gnu.org/software/screen/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~hppa-hpux ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug nethack pam selinux multiuser vsplit doc"

RDEPEND=">=sys-libs/ncurses-5.2
	pam? ( virtual/pam )
	selinux? ( sec-policy/selinux-screen )
	doc? ( sys-apps/texinfo )"
DEPEND="${RDEPEND}"

pkg_setup() {
	# Make sure utmp group exists, as it's used later on.
	enewgroup utmp 406
}

src_unpack() {

	if [[ ${PV} == "9999" ]] ; then
		git_src_unpack
		S="${S}/src"
	#	rm -f configure
	else
		unpack ${A}
		cd "${S}"
	fi

}


src_prepare() {

	# sched.h is a system header and causes problems with some C libraries
	mv sched.h _sched.h || die
	sed -i '/include/s:sched.h:_sched.h:' screen.h || die

	# Allow for more rendition (color/attribute) changes in status bars
	sed -i \
		-e "s:#define MAX_WINMSG_REND 16:#define MAX_WINMSG_REND 64:" \
		screen.c \
		|| die "sed screen.c failed"

	# Fix manpage.
	sed -i \
		-e "s:/usr/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/usr/local/screens:${EPREFIX}/var/run/screen:g" \
		-e "s:/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/etc/utmp:${EPREFIX}/var/run/utmp:g" \
		-e "s:/local/screens/S-:${EPREFIX}/var/run/screen/S-:g" \
		doc/screen.1 \
		|| die "sed doc/screen.1 failed"

	if [[ ${PV} = *9999* ]]; then
		eautoreconf
	fi

	# reconfigure
	eautoconf
}

src_configure() {
	append-flags "-DMAXWIN=${MAX_SCREEN_WINDOWS:-100}"

	[[ ${CHOST} == *-solaris* ]] && append-libs -lsocket -lnsl

	use nethack || append-flags "-DNONETHACK"
	use debug && append-flags "-DDEBUG"

	econf \
		--with-socket-dir="${EPREFIX}/var/run/screen" \
		--with-sys-screenrc="${EPREFIX}/etc/screenrc" \
		--with-pty-mode=0620 \
		--with-pty-group=5 \
		--enable-rxvt_osc \
		--enable-telnet \
		--enable-colors256 \
		$(use_enable pam) \
		|| die "econf failed"


	# Second try to fix bug 12683, this time without changing term.h
	# The last try seemed to break screen at run-time.
	# (16 Jan 2003 agriffis)
	LC_ALL=POSIX make term.h || die "Failed making term.h"
}


src_compile() {
	emake || die "emake failed"

	if use doc; then
		cd doc
		emake html || die "emake html failed"
	fi
}


src_install() {
	dobin screen || die "dobin failed"
	keepdir /var/run/screen || die "keepdir failed"

	if use multiuser || use prefix
	then
		fperms 4755 /usr/bin/screen || die "fperms failed"
	else
		fowners root:utmp /{usr/bin,var/run}/screen \
			|| die "fowners failed, use multiuser USE-flag instead"
		fperms 2755 /usr/bin/screen || die "fperms failed"
	fi

	insinto /usr/share/screen
	doins terminfo/{screencap,screeninfo.src} || die "doins failed"
	insinto /usr/share/screen/utf8encodings
	doins utf8encodings/?? || die "doins failed"
	insinto /etc
	doins "${FILESDIR}"/screenrc || die "doins failed"

	pamd_mimic_system screen auth || die "pamd_mimic_system failed"

	dodoc \
		README ChangeLog INSTALL TODO NEWS* patchlevel.h \
		doc/{FAQ,README.DOTSCREEN,fdpat.ps,window_to_display.ps} \
		|| die "dodoc failed"

	doman doc/screen.1 || die "doman failed"
#	doinfo doc/screen.info* || die "doinfo failed"
}

pkg_postinst() {
	if use multiuser || use prefix
	then
		use prefix || chown root:0 "${EROOT}"/var/run/screen
		if use prefix; then
			chmod 0777 "${EROOT}"/var/run/screen
		else
			chmod 0755 "${EROOT}"/var/run/screen
		fi
	else
		chown root:utmp "${EROOT}"/var/run/screen
		chmod 0775 "${EROOT}"/var/run/screen
	fi

	elog "Some dangerous key bindings have been removed or changed to more safe values."
	elog "We enable some xterm hacks in our default screenrc, which might break some"
	elog "applications. Please check /etc/screenrc for information on these changes."
}
