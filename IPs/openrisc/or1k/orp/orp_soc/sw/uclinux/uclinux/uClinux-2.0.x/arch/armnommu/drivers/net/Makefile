# File: drivers/net/Makefile
#
# Makefile for the Linux network (ethercard) device drivers.
#

all: links first_rule

LK	= README.eql README.multicast README.tunnel README1.PLIP README2.PLIP \
	  bsd_comp.c dummy.c eql.c loopback.c net_init.c slhc.c slip.c slip.h \
	  8390.h

L_TARGET := net.a
L_OBJS   := auto_irq.o
M_OBJS   :=
MOD_LIST_NAME := NET_MODULES

# Need these to keep track of whether the SLHC module should
# really go in the kernel or a module
CONFIG_SLHC_BUILTIN :=
CONFIG_SLHC_MODULE  :=

ifeq ($(CONFIG_NET),y)
L_OBJS += Space.o net_init.o loopback.o
endif

ifeq ($(CONFIG_TRIO_CS8900),y)
L_OBJS += trioCS8900.o
else
  ifeq ($(CONFIG_TRIO_CS8900),m)
  M_OBJS += trioCS8900.o
  endif
endif

ifeq ($(CONFIG_ETHER1),y)
L_OBJS += ether1.o
else
  ifeq ($(CONFIG_ETHER1),m)
  M_OBJS += ether1.o
  endif
endif

ifeq ($(CONFIG_ETHER3),y)
L_OBJS += ether3.o
else
  ifeq ($(CONFIG_ETHER3),m)
  M_OBJS += ether3.o
  endif
endif

ifeq ($(CONFIG_ETHERC),y)
L_OBJS += etherc.o
else
  ifeq ($(CONFIG_ETHERC),m)
  M_OBJS += etherc.o
  endif
endif

ifeq ($(CONFIG_ETHERH),y)
L_OBJS += etherh.o
CONFIG_8390_BUILTIN=y
else
  ifeq ($(CONFIG_ETHERH),m)
  M_OBJS += etherh.o
  CONFIG_8390_MODULE=y
  endif
endif

ifeq ($(CONFIG_AM79C961A),y)
L_OBJS += am79c961a.o
else
  ifeq ($(CONFIG_AM79C961A),m)
  M_OBJS += am79c961a.o
  endif
endif

ifeq ($(CONFIG_IPIP),y)
L_OBJS += tunnel.o
else
  ifeq ($(CONFIG_IPIP),m)
  M_OBJS += tunnel.o
  endif
endif

ifeq ($(CONFIG_PLIP),y)
L_OBJS += plip.o
else
  ifeq ($(CONFIG_PLIP),m)
  M_OBJS += plip.o
  endif
endif

ifeq ($(CONFIG_PPP),y)
LX_OBJS += ppp.o
CONFIG_SLHC_BUILTIN = y
else
  ifeq ($(CONFIG_PPP),m)
  MX_OBJS += ppp.o
  CONFIG_SLHC_MODULE = y
  endif
endif

ifdef CONFIG_PPP
  M_OBJS += bsd_comp.o
endif

ifeq ($(CONFIG_SLIP),y)
L_OBJS += slip.o
CONFIG_SLHC_BUILTIN = y
else
  ifeq ($(CONFIG_SLIP),m)
  M_OBJS += slip.o
  CONFIG_SLHC_MODULE = y
  endif
endif

ifeq ($(CONFIG_DUMMY),y)
L_OBJS += dummy.o
else
  ifeq ($(CONFIG_DUMMY),m)
  L_OBJS += dummy.o
  endif
endif

# If anything built-in uses slhc, then build it into the kernel also.
# If not, but a module uses it, build as a module.
ifdef CONFIG_SLHC_BUILTIN
LX_OBJS += slhc.o
else
  ifdef CONFIG_SLHC_MODULE
  MX_OBJS += slhc.o
  endif
endif

# If anything built-in uses the 8390, then build it into the kernel also.
# If not, but a module uses it, build as a module.
ifdef CONFIG_8390_BUILTIN
L_OBJS += 8390.o
else
  ifdef CONFIG_8390_MODULE
  M_OBJS += 8390.o
  endif
endif

ifeq ($(CONFIG_EQUALIZER),y)
L_OBJS += eql.o
else
  ifeq ($(CONFIG_EQUALIZER),m)
  M_OBJS += eql.o
  endif
endif

fastdep: links

include $(TOPDIR)/Rules.make

clean:
	rm -f core *.o *.a *.s

net_init.o: ../../../../include/linux/autoconf.h

.PHONY: links
links:
	-@for f in $(LK); do \
		if [ ! -e $$f ]; then \
			echo "ln -s ../../../../drivers/net/$$f .";\
			ln -s ../../../../drivers/net/$$f .; \
		fi; \
	done

mrproper:
	-@for f in $(LK); do \
		if [ -L $$f ]; then \
			echo $(RM) $$f; \
			$(RM) $$f; \
		elif [ -f $$f ]; then \
			echo not removing $$f; \
		fi; \
	done
	$(RM) ppp.ver

