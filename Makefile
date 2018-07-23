#
# ssbt Makefile
#

PREFIX?=/usr/local
BINDIR=$(DESTDIR)$(PREFIX)/sbin
LIBDIR=$(DESTDIR)$(PREFIX)/lib/ssbt
MANDIR=$(DESTDIR)$(PREFIX)/man/man8
RCDIR=$(DESTDIR)$(PREFIX)/etc/rc.d

CP=/bin/cp
INSTALL=/usr/bin/install
MKDIR=/bin/mkdir

PROG=ssbt
MAN=$(PROG).8

install:
	$(MKDIR) -p $(BINDIR)
	$(INSTALL) -m 544 $(PROG) $(BINDIR)/

	$(MKDIR) -p $(LIBDIR)
	$(INSTALL) lib/* $(LIBDIR)/

	$(MKDIR) -p $(RCDIR)
	$(INSTALL) -m 555 rc.d/* $(RCDIR)/

	$(MKDIR) -p $(MANDIR)
	gzip -fk $(MAN)
	$(INSTALL) $(MAN).gz $(MANDIR)/
	rm -f -- $(MAN).gz

.MAIN: clean
clean: ;
