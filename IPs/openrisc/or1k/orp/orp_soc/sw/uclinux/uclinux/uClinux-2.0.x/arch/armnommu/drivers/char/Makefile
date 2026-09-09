#
# Makefile for the kernel character device drivers.
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#
# Note 2! The CFLAGS definitions are now inherited from the
# parent makes..
#

#
# This file contains the font map for the default font
#

FONTMAPFILE = cp437.uni

# Links to make

LK = conmakehash.c consolemap.c consolemap.h cp437.uni random.c tty_ioctl.c softdog.c

all: links first_rule

L_TARGET := char.a
M_OBJS   :=
L_OBJS   := tty_io.o n_tty.o tty_ioctl.o pty.o mem.o random.o

# architecture options

ifeq ($(CONFIG_SERIAL_TRIO),y)
  L_OBJS += trioserial.o
else
  ifeq ($(CONFIG_SERIAL_TRIO),m)
    M_OBJS += trioserial.o
  endif
endif

ifeq ($(MACHINE),arc)
  ifeq ($(CONFIG_SERIAL),y)
    L_OBJS += serial6850.o
  else
    ifeq ($(CONFIG_SERIAL),m)
      M_OBJS += serial6850.o
    endif
  endif
else
  ifeq ($(CONFIG_SERIAL),y)
    SL = y
  else
    ifeq ($(CONFIG_SERIAL),m)
      SM = m
    endif
  endif
endif

ifeq ($(MACHINE),arc)
  L_OBJS += console.o consoledriver.o keyboard.o keyb_arc.o vc_screen.o selection.o \
		defkeymap.o consolemap.o vt.o
  MOUSE_OBJS =
endif

ifeq ($(MACHINE),a5k)
  L_OBJS += console.o consoledriver.o keyboard.o keyb_arc.o vc_screen.o selection.o \
		defkeymap.o consolemap.o vt.o
  MOUSE_OBJS =
endif

ifeq ($(MACHINE),rpc)
  L_OBJS += console.o consoledriver.o keyboard.o keyb_ps2.o vc_screen.o selection.o \
		defkeymap.o consolemap.o vt.o
ifeq ($(CONFIG_RPCMOUSE),y)
  MOUSE_OBJS = mouse_rpc.o
endif
endif

ifeq ($(MACHINE),ebsa110)
  L_OBJS += console-dummy.o vt-dummy.o
endif

ifeq ($(MACHINE),trio)
  L_OBJS += console-trio.o vt-dummy.o kbd_trio.o
endif


# Common dependencies

ifeq ($(CONFIG_ATOMWIDE_SERIAL),y)
  L_OBJS += serial-atomwide.o
  SL=y
else
  ifeq ($(CONFIG_ATOMWIDE_SERIAL),m)
    M_OBJS += serial-atomwide.o
    SM=m
  endif
endif

ifeq ($(CONFIG_DUALSP_SERIAL),y)
  L_OBJS += serial-dualsp.o
  SL=y
else
  ifeq ($(CONFIG_DUALSP_SERIAL),m)
    M_OBJS += serial-dualsp.o
    SM=m
  endif
endif

ifdef SL
  LX_OBJS += serial.o
else
  ifdef SM
    MX_OBJS += serial.o
  endif
endif

ifeq ($(CONFIG_PRINTER),y)
  L_OBJS += lp.o
else
  ifeq ($(CONFIG_PRINTER),m)
    M_OBJS += lp.o
  endif
endif

ifeq ($(CONFIG_UMISC),y)
# To support third-party modules, misc.c must reside in the kernel
M = y
endif

ifeq ($(CONFIG_MOUSE),y)
  M = y
  L_OBJS += mouse.o $(MOUSE_OBJS)
else
  ifeq ($(CONFIG_MOUSE),m)
    MM = m
    M_OBJS += mouse.o $(MOUSE_OBJS)
  endif
endif

ifeq ($(CONFIG_SOFT_WATCHDOG),y)
M = y
L_OBJS += softdog.o
else
  ifeq ($(CONFIG_SOFT_WATCHDOG),m)
  M_OBJS += softdog.o
  MM = m
  endif
endif

ifdef M
  L_OBJS += misc.o
else
  ifdef MM
    M_OBJS += misc.o
  endif
endif

include $(TOPDIR)/Rules.make

fastdep: links uni_hash.tbl

conmakehash: conmakehash.c
	$(HOSTCC) -o conmakehash conmakehash.c

uni_hash.tbl: $(FONTMAPFILE) conmakehash
	./conmakehash $(FONTMAPFILE) > uni_hash.tbl

.PHONY: links
links:
	-@for f in $(LK); do \
		if [ ! -e $$f ]; then \
			echo "ln -s ../../../../drivers/char/$$f .";\
			ln -s ../../../../drivers/char/$$f .; \
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
	$(RM) conmakehash
