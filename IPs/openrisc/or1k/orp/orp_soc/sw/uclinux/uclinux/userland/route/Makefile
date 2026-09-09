
CC = or32-uclibc-gcc
LD = or32-uclibc-gcc
STRIP = or32-uclibc-strip

ROUTE = route
ROUTEOBJS = route.o

IFCONFIG = ifconfig
IFCONFIGOBJS = ifconfig.o

ARP = arp
ARPOBJS = arp.o

CFLAGS += -D_GNU_SOURCE -D__USE_BSD -Wall -Werror-implicit-function-declaration -Ilib/ -Iinclude
LDFLAGS += -r -d

LIBROUTE = lib/libroute.a

all: $(ROUTE) $(IFCONFIG) $(ARP)

$(ROUTE): $(ROUTEOBJS) $(LIBROUTE)
	$(LD) $(LDFLAGS) -o $@ $(ROUTEOBJS) $(LIBNET) $(LIBROUTE) $(LDLIBS)
	$(STRIP) -g $@

$(IFCONFIG): $(IFCONFIGOBJS) $(LIBROUTE)
	$(LD) $(LDFLAGS) -o $@ $(IFCONFIGOBJS) $(LIBNET) $(LIBROUTE) $(LDLIBS)
	$(STRIP) -g $@

$(ARP): $(ARPOBJS) $(LIBROUTE) 
	$(LD) $(LDFLAGS) -o $@ $(ARPOBJS) $(LIBNET) $(LIBROUTE) $(LDLIBS)
	$(STRIP) -g $@

clean:
	-rm -f $(ROUTE) $(IFCONFIG) $(ARP) *.gdb *.o
	$(MAKE) -C lib clean

$(LIBROUTE):
	$(MAKE) -C lib


