# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/xdebug/xdebug-2.1.0-r1.ebuild,v 1.1 2011/03/03 18:17:09 olemarkus Exp $

PHP_EXT_NAME="xdebug"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="yes"

EAPI="2"
inherit php-ext-source-r2

KEYWORDS="alpha amd64 hppa ia64 ~ppc ~ppc64 sparc x86"

MY_PV="${PV/_/}"
MY_PV="${MY_PV/rc/RC}"

DESCRIPTION="A PHP debugging and profiling extension"
HOMEPAGE="http://www.xdebug.org/"
SRC_URI="http://pecl.php.net/get/${PN}-${MY_PV}.tgz"
LICENSE="Xdebug"
SLOT="0"
IUSE=""

S="${WORKDIR}/${PN}-${MY_PV}"

DEPEND="!dev-php5/ZendOptimizer"
RDEPEND="${DEPEND}
		~dev-php/xdebug-client-${PV}"

src_install() {
	dodoc NEWS README Changelog CREDITS
	php-ext-source-r2_src_install

	php-ext-source-r2_addtoinifiles "xdebug.auto_trace" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.trace_output_dir" '"/tmp"'
	php-ext-source-r2_addtoinifiles "xdebug.trace_output_name" '"trace.%c"'
	php-ext-source-r2_addtoinifiles "xdebug.trace_format" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.trace_options" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.collect_includes" '"1"'
	php-ext-source-r2_addtoinifiles "xdebug.collect_params" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.collect_return" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.collect_vars" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.default_enable" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.extended_info" '"1"'
	php-ext-source-r2_addtoinifiles "xdebug.manual_url" '"http://www.php.net"'
	php-ext-source-r2_addtoinifiles "xdebug.max_nesting_level" '"100"'
	php-ext-source-r2_addtoinifiles "xdebug.show_exception_trace" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.show_local_vars" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.show_mem_delta" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.dump.COOKIE" '"NULL"'
	php-ext-source-r2_addtoinifiles "xdebug.dump.ENV" '"NULL"'
	php-ext-source-r2_addtoinifiles "xdebug.dump.FILES" '"NULL"'
	php-ext-source-r2_addtoinifiles "xdebug.dump.GET" '"NULL"'
	php-ext-source-r2_addtoinifiles "xdebug.dump.POST" '"NULL"'
	php-ext-source-r2_addtoinifiles "xdebug.dump.REQUEST" '"NULL"'
	php-ext-source-r2_addtoinifiles "xdebug.dump.SERVER" '"NULL"'
	php-ext-source-r2_addtoinifiles "xdebug.dump.SESSION" '"NULL"'
	php-ext-source-r2_addtoinifiles "xdebug.dump_globals" '"1"'
	php-ext-source-r2_addtoinifiles "xdebug.dump_once" '"1"'
	php-ext-source-r2_addtoinifiles "xdebug.dump_undefined" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.profiler_enable" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.profiler_output_dir" '"/tmp"'
	php-ext-source-r2_addtoinifiles "xdebug.profiler_output_name" '"cachegrind.out.%p"'
	php-ext-source-r2_addtoinifiles "xdebug.profiler_enable_trigger" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.profiler_append" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.profiler_aggregate" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.remote_enable" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.remote_handler" '"dbgp"'
	php-ext-source-r2_addtoinifiles "xdebug.remote_host" '"localhost"'
	php-ext-source-r2_addtoinifiles "xdebug.remote_mode" '"req"'
	php-ext-source-r2_addtoinifiles "xdebug.remote_port" '"9000"'
	php-ext-source-r2_addtoinifiles "xdebug.remote_autostart" '"0"'
	php-ext-source-r2_addtoinifiles "xdebug.remote_log" '""'
	php-ext-source-r2_addtoinifiles "xdebug.idekey" '""'
	php-ext-source-r2_addtoinifiles "xdebug.var_display_max_data" '"512"'
	php-ext-source-r2_addtoinifiles "xdebug.var_display_max_depth" '"2"'
	php-ext-source-r2_addtoinifiles "xdebug.var_display_max_children" '"128"'

}

pkg_postinst() {
	ewarn "We have set xdebug.default_enable to 0 (off), as xdebug can be"
	ewarn "installed as a dependency, and not all users will want xdebug to be"
	ewarn "enabled by default. If you want to enable it, you should edit the"
	ewarn "ini file and set xdebug.default_enable to 1. Alternatively you can"
	ewarn "call xdebug_enable() in your code."
}
