SHELL = /bin/sh
package = display-dhammapada
Package = $(package)
VERSION = 1.0
UNAME := $(shell uname)

## Path
prefix = /usr
PREFIX = $(prefix)
exec_prefix = /usr
bindir = $(prefix)/bin
datadir = $(prefix)/share/$(package)
icondir = $(prefix)/share/icons/$(package)
docdir = $(prefix)/share/doc/$(package)
mandir = $(prefix)/share/man
man1dir = $(mandir)/man1

## Install
INSTALL_DATA = install -m 644
INSTALL_PROGRAM = install -m 755
MKDIR = install -d -m 755
BIN      = $(package)
BINshort = dhamma
CC      = cc
DP       = dhammapada-english-bps.txt
DPOLD    = dhammapada-english-transl.txt
DPALT    = dhammapada-alternate.txt
DPPL     = dhammapada-polish-transl.txt
DOCS     = changelog copyright INSTALL
MAN1	= $(Package).1
ICON1 = buddha1.png
ICON2 = buddha2.png
ICON3 = enso.png
ICON4 = lotus.png

# package
DISTFILES = display-dhammapada.spec Makefile bin doc icons man src dhammapada debian

all:	options $(BIN)

options:
# These options are used only if CFLAGS
# are not set on the command line or by
# your package manager.
ifeq ($(strip $(CFLAGS)),)
ifeq ($(UNAME), Linux)
OPT = -O2
endif
ifeq ($(UNAME), Darwin)
OPT = -O2 -L/opt/homebrew/Cellar/libiconv/1.17/ -liconv
endif
WARN = -std=c17 -Wall -Wno-unused -Wno-parentheses -pedantic
CFLAGS = $(OPT) $(WARN)
endif

$(BIN): 
	$(CC) $(CFLAGS) -o bin/$(package) src/$(package).c
	
	
clean:
	-rm -f bin/$(package) 
	-rm -rf $(package)-$(VERSION)
	-rm -f ./*bak ./*~
	-rm -f ./*/*.bak ./*/*~

distclean: clean
	-rm -f ../$(package)-$(VERSION).tar.gz

dist:
	test -e $(package)-$(VERSION) || mkdir $(package)-$(VERSION)
	cp -R $(DISTFILES) $(package)-$(VERSION)
	tar czf ../$(package)-$(VERSION).tar.gz $(package)-$(VERSION)
	-rm -rf $(package)-$(VERSION)

installdirs:
	test -e $(DESTDIR)$(bindir)	|| $(MKDIR) -p $(DESTDIR)$(bindir)
	test -e $(DESTDIR)$(datadir)	|| $(MKDIR) -p $(DESTDIR)$(datadir)
	test -e $(DESTDIR)$(docdir)	|| $(MKDIR) -p $(DESTDIR)$(docdir)
	test -e $(DESTDIR)$(icondir)	|| $(MKDIR) -p $(DESTDIR)$(icondir)
	test -e $(DESTDIR)$(mandir)	|| $(MKDIR) -p $(DESTDIR)$(mandir)
	test -e $(DESTDIR)$(man1dir)	|| $(MKDIR) -p $(DESTDIR)$(man1dir)

install: installdirs
	# Install programs
	$(INSTALL_PROGRAM)	bin/$(BIN) 	$(DESTDIR)$(bindir)
	$(INSTALL_PROGRAM)	bin/xdhamma	$(DESTDIR)$(bindir)
	cd $(DESTDIR)$(bindir); \
	ln -fs $(BIN) $(BINshort)
	
	# Install data
	$(INSTALL_DATA)		dhammapada/$(DP)	$(DESTDIR)$(datadir)
	$(INSTALL_DATA)		dhammapada/$(DPOLD)	$(DESTDIR)$(datadir)
	$(INSTALL_DATA)		dhammapada/$(DPALT)	$(DESTDIR)$(datadir)
	$(INSTALL_DATA)		dhammapada/$(DPPL)	$(DESTDIR)$(datadir)

	# Install documentation
	$(INSTALL_DATA) doc/changelog $(DESTDIR)$(docdir)
	$(INSTALL_DATA) doc/changelog.Debian $(DESTDIR)$(docdir)
	$(INSTALL_DATA) doc/copyright $(DESTDIR)$(docdir)
	$(INSTALL_DATA) doc/README $(DESTDIR)$(docdir)

	# Install icons
	$(INSTALL_DATA) icons/$(ICON1) $(DESTDIR)$(icondir)
	$(INSTALL_DATA) icons/$(ICON2) $(DESTDIR)$(icondir)
	$(INSTALL_DATA) icons/$(ICON3) $(DESTDIR)$(icondir)
	$(INSTALL_DATA) icons/$(ICON4) $(DESTDIR)$(icondir)

	# Install man
	$(INSTALL_DATA) man/$(MAN1) $(DESTDIR)$(man1dir)
	$(INSTALL_DATA) man/xdhamma.1 $(DESTDIR)$(man1dir)
	gzip $(DESTDIR)$(man1dir)/$(MAN1)
	gzip $(DESTDIR)$(man1dir)/xdhamma.1
	cd $(DESTDIR)$(man1dir); \
	ln -sf $(MAN1).gz dhamma.1.gz; 
	
uninstall:
	rm -rf $(DESTDIR)$(bindir)/$(BIN) $(DESTDIR)$(bindir)/xdhamma \
	$(DESTDIR)$(bindir)/$(BINshort) $(DESTDIR)$(datadir) \
	$(DESTDIR)$(docdir) $(DESTDIR)$(icondir) \
	$(DESTDIR)$(man1dir)/xdhamma.1.gz $(DESTDIR)$(man1dir)/dhamma.1.gz \
	$(DESTDIR)$(man1dir)/$(MAN1).gz

