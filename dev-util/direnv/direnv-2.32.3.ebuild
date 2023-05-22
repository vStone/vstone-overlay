# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module


DESCRIPTION="Direnv is an environment switcher for the shell."
HOMEPAGE="https://direnv.net"
SRC_URI="https://github.com/direnv/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/vStone/vstone-overlay/releases/download/${P}/${P}-vendor.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!dev-go/direnv"
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( docs/ruby.md docs/hook.md )


src_compile() {
	ego build
}

src_install() {
	dobin direnv
}
