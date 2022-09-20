# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="CLI based audio visualizer"
HOMEPAGE="https://github.com/dpayne/cli-visualizer"
EGIT_REPO_URI="https://github.com/dpayne/cli-visualizer.git"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	sci-libs/fftw:3.0
	sys-libs/ncurses"
DEPEND="${RDEPEND}"
BDEPEND=""


src_install() {
	cmake-utils_src_install

	docompress -x /usr/share/doc/"${PF}"/examples
	insinto /usr/share/doc/"${PF}"/examples
	doins -r examples/config
	insinto /usr/share/doc/"${PF}"/examples/colors
	doins -r examples/rainbow examples/basic_colors

}

pkg_postinst() {
	einfo "You must copy /usr/share/doc/${PF}/examples into your ~/.config/vis directory"
	einfo "    cp -rv /usr/share/doc/${PF}/examples ~/.config/vis"
}
