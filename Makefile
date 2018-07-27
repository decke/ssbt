#
# ssbt Makefile
#

PREFIX?=/usr/local
BINDIR=$(DESTDIR)$(PREFIX)/sbin
LIBDIR=$(DESTDIR)$(PREFIX)/lib/ssbt
RCDIR=$(DESTDIR)$(PREFIX)/etc/rc.d

CP=/bin/cp
INSTALL=/usr/bin/install
MKDIR=/bin/mkdir

PROG=ssbt
MAN=$(PROG).8

install:
	$(MKDIR) -p $(BINDIR)
	$(INSTALL) -m 555 $(PROG) $(BINDIR)/

	$(MKDIR) -p $(LIBDIR)
	$(INSTALL) lib/* $(LIBDIR)/

	$(MKDIR) -p $(RCDIR)
	$(INSTALL) -m 555 rc.d/* $(RCDIR)/

.MAIN: clean
clean: ;
