#!/usr/bin/env make -f

# pocket-piap-extras-rpi2-us Makefile
# adapted from BASH repo template
# ..................................
# Copyright (c) 2017, Kendrick Walls
# ..................................
# Licensed under MIT (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# ..........................................
# http://www.github.com/reactive-firewall/bash-repo/LICENSE.md
# ..........................................
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


ifeq "$(ECHO)" ""
	ECHO=echo
endif

ifeq "$(LINK)" ""
	LINK=ln -sf
endif

ifeq "$(MAKE)" ""
	MAKE=make
endif

ifeq "$(WAIT)" ""
	WAIT=wait
endif

ifeq "$(INSTALL)" ""
	INSTALL=install
	ifeq "$(INST_OWN)" ""
		INST_OWN=-o root -g staff
	endif
	ifeq "$(INST_OPTS)" ""
		INST_OPTS=-m 755
	endif
endif

ifeq "$(LOG)" ""
	LOG=no
endif

ifeq "$(LOG)" "no"
	QUIET=@
endif

ifeq "$(DO_FAIL)" ""
	DO_FAIL=$(ECHO) "ok"
endif

PHONY: must_be_root cleanup

build:
	$(QUIET)$(MAKE) --directory=./pocket-piap-extras-rpi2-us -f ./makefile install
	$(QUIET)$(ECHO) "Done."

init:
	$(QUIET)$(ECHO) "$@: Done."

install: must_be_root build
	$(QUIET)dpkg --install ./pocket-piap-extras-rpi2-us_0.2.8_amd64.deb
	$(QUITE)$(WAIT)
	$(QUIET)$(ECHO) "$@: Done."

uninstall: ./pocket-piap-extras-rpi2-us_0.2.8_amd64.deb
	$(QUIET)dpkg --purge ./pocket-piap-extras-rpi2-us_0.2.8_amd64.deb
	$(QUITE)$(WAIT)
	$(QUIET)$(ECHO) "$@: Done."

purge: clean uninstall
	$(QUIET)$(ECHO) "$@: Done."

./pocket-piap-extras-rpi2-us_0.2.8_amd64.deb: build
	$(QUIET)$(ECHO) "Done."

test: cleanup
	$(QUIET)bash ./tests/test_*sh
	$(QUIET)$(ECHO) "$@: Done."

test-tox: cleanup
	$(QUIET)$(ECHO) "$@: N/A."

test-style: cleanup
	$(QUIET)$(ECHO) "$@: N/A."

cleanup:
	$(QUIET)rm -f tests/*~ 2>/dev/null || true
	$(QUIET)rm -f bin/*~ 2>/dev/null || true
	$(QUIET)rm -f bin/*/*~ 2>/dev/null || true
	$(QUIET)rm -f *.DS_Store 2>/dev/null || true
	$(QUIET)rm -f bin/*.DS_Store 2>/dev/null || true
	$(QUIET)rm -f bin/*/*.DS_Store 2>/dev/null || true
	$(QUIET)rm -f ./*/*~ 2>/dev/null || true
	$(QUIET)rm -f ./*~ 2>/dev/null || true
	$(QUIET)rm -f ./.*~ 2>/dev/null || true
	$(QUIET)rm -Rf ./.tox/ 2>/dev/null || true
	$(QUIET)$(MAKE) --directory=./pocket-piap-extras-rpi2-us -f ./makefile clean || true

clean: cleanup
	$(QUIET)$(ECHO) "$@: Done."

must_be_root:
	$(QUIET)runner=`whoami` ; \
	if test $$runner != "root" ; then echo "You are not root." ; exit 1 ; fi

%:
	$(QUIET)$(ECHO) "No Rule Found For $@" ; $(WAIT) ;

