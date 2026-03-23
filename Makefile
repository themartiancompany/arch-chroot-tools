# SPDX-License-Identifier: GPL-3.0-or-later

#    ----------------------------------------------------------------------
#    Copyright © 2024, 2025, 2026  Pellegrino Prevete
#
#    All rights reserved
#    ----------------------------------------------------------------------
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

PREFIX ?= /usr/local
_PROJECT=arch-chroot-tools
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT)
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man
LIB_DIR=$(DESTDIR)$(PREFIX)/lib

_INSTALL_FILE=\
  install \
    -vDm644
_INSTALL_DIR=\
  install \
    -vdm755
_INSTALL_EXE=\
  install \
    -vDm755

DOC_FILES=\
  $(wildcard *.rst) \
  $(wildcard *.md)

_BASH_FILES=\
  chroot-shell
  # graphical-environment-runtime-setup

_CHECK_TARGETS=\
  shellcheck
_CHECK_TARGETS_ALL=\
  check \
  $(_CHECK_TARGETS)
_INSTALL_SCRIPTS_TARGETS=\
  install-bash-scripts
INSTALL_DOC_TARGETS=\
  install-doc \
  install-man
_INSTALL_TARGETS=\
  install-scripts \
  $(_INSTALL_DOC_TARGETS)
_INSTALL_TARGETS_ALL=\
  install \
  $(_INSTALL_TARGETS) \
  $(_INSTALL_SCRIPTS_TARGETS)

_PHONY_TARGETS=\
  $(_CHECK_TARGETS_ALL) \
  $(_INSTALL_TARGETS_ALL)
  
all:

check: shellcheck

shellcheck:
	shellcheck -s bash $(_BASH_FILES)

install: $(_INSTALL_TARGETS)

install-scripts: $(_INSTALL_SCRIPTS_TARGETS)

install-bash-scripts:

	for _file in $(_BASH_FILES); do \
	  $(_INSTALL_EXE) \
	    "$(_PROJECT)/$${_file}" \
	    "$(BIN_DIR)/$${_file}"; \
	done

install-doc:

	$(_INSTALL_FILE) \
	  $(DOC_FILES) \
	  -t \
	  "$(DOC_DIR)/"

install-man:

	$(_INSTALL_DIR) \
	  "$(MAN_DIR)/man1"
	rst2man \
	  "man/chroot-shell.1.rst" \
	  "$(MAN_DIR)/man1/chroot-shell.1"
	rst2man \
	  "man/zram-setup.1.rst" \
	  "$(MAN_DIR)/man1/zram-setup.1"
	# rst2man \
	#   "man/graphical-environment-runtime-setup.1.rst" \
	#   "$(MAN_DIR)/man1/graphical-environment-runtime-setup.1"

.PHONY: $(_PHONY_TARGETS)
