
# Makefile for kernel/blk_drv/scsi
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#

all: links first_rule

L_TARGET := scsi.a
L_OBJS   :=
M_OBJS   :=
MOD_LIST_NAME := SCSI_MODULES
SCSI_SRCS := $(wildcard $(L_OBJS:%.o=%.c))

LK	  = NCR5380.c NCR5380.h constants.c constants.h hosts.h \
	    ide-scsi.c ide-scsi.h ppa.c \
	    ppa.h scsi.h scsi_ioctl.c scsi_proc.c scsi_syms.c scsicam.c \
	    sd.c sd.h sd_ioctl.c sg.c sr.c sr.h sr_ioctl.c st.c st.h \
	    st_options.h scsi_module.c

ifeq ($(CONFIG_SCSI),y)
L_OBJS += hosts.o scsi.o scsi_ioctl.o constants.o scsicam.o
  ifeq ($(CONFIG_PROC_FS),y)
    L_OBJS += scsi_proc.o
  endif
LX_OBJS += scsi_syms.o
else
  ifeq ($(CONFIG_SCSI),m)
    MX_OBJS += scsi_syms.o
    M_OBJS += scsi_mod.o
  endif
endif

ifeq ($(CONFIG_CHR_DEV_ST),y)
L_OBJS += st.o
else
  ifeq ($(CONFIG_CHR_DEV_ST),m)
  M_OBJS += st.o
  endif
endif

ifeq ($(CONFIG_BLK_DEV_SD),y)
L_OBJS += sd.o sd_ioctl.o
else
  ifeq ($(CONFIG_BLK_DEV_SD),m)
  M_OBJS += sd_mod.o
  endif
endif

ifeq ($(CONFIG_BLK_DEV_SR),y)
L_OBJS += sr.o sr_ioctl.o
else
  ifeq ($(CONFIG_BLK_DEV_SR),m)
  M_OBJS += sr_mod.o
  endif
endif

ifeq ($(CONFIG_CHR_DEV_SG),y)
L_OBJS += sg.o
else
  ifeq ($(CONFIG_CHR_DEV_SG),m)
  M_OBJS += sg.o
  endif
endif

ifeq ($(CONFIG_SCSI_ACORNSCSI_3),y)
L_OBJS += acornscsi.o acornscsi-io.o
LQ=y
else
  ifeq ($(CONFIG_SCSI_ACORNSCSI_3),m)
  M_OBJS += acornscsi_mod.o
  MQ=m
  endif
endif

ifeq ($(CONFIG_SCSI_CUMANA_1),y)
L_OBJS += cumana_1.o
else
  ifeq ($(CONFIG_SCSI_CUMANA_1),m)
  M_OBJS += cumana_1.o
  endif
endif

ifeq ($(CONFIG_SCSI_CUMANA_2),y)
L_OBJS += cumana_2.o
LQ=y
LE=y
else
  ifeq ($(CONFIG_SCSI_CUMANA_2),m)
  M_OBJS += cumana_2_mod.o
  MQ=m
  endif
endif

ifeq ($(CONFIG_SCSI_ECOSCSI),y)
L_OBJS += ecoscsi.o
else
  ifeq ($(CONFIG_SCSI_ECOSCSI),m)
  M_OBJS += ecoscsi.o
  endif
endif

ifeq ($(CONFIG_SCSI_EESOXSCSI),y)
L_OBJS += eesox.o
LQ=y
LE=y
else
  ifeq ($(CONFIG_SCSI_EESOXSCSI),m)
  M_OBJS += eesox_mod.o
  endif
endif

ifeq ($(CONFIG_SCSI_OAK1),y)
L_OBJS += oak.o
else
  ifeq ($(CONFIG_SCSI_OAK1),m)
  M_OBJS += oak.o
  endif
endif

ifeq ($(CONFIG_SCSI_PPA),y)
L_OBJS += ppa.o
else
  ifeq ($(CONFIG_SCSI_PPA),m)
  M_OBJS += ppa.o
  endif
endif

ifeq ($(CONFIG_BLK_DEV_IDESCSI),y)
L_OBJS += ide-scsi.o
endif

ifeq ($(CONFIG_SCSI_POWERTECSCSI),y)
L_OBJS += powertec.o
LQ=y
LE=y
else
  ifeq ($(CONFIG_SCSI_POWERTECSCSI),m)
  M_OBJS += powertec_mod.o
  endif
endif

ifeq ($(LE),y)
L_OBJS += fas216.o
endif

ifeq ($(LQ),y)
L_OBJS += queue.o msgqueue.o
#else
#  ifeq ($(MQ),mn)
#  M_OBJS += queue.o msgqueue.o
#  endif
endif

include $(TOPDIR)/Rules.make

fastdep: links

scsi_mod.o: $(MX_OBJS) hosts.o scsi.o scsi_ioctl.o constants.o \
		scsicam.o scsi_proc.o
	$(LD) $(LD_RFLAG) -r -o $@ $(MX_OBJS) hosts.o scsi.o scsi_ioctl.o constants.o scsicam.o scsi_proc.o

sr_mod.o: sr.o sr_ioctl.o
	$(LD) $(LD_RFLAG) -r -o $@ sr.o sr_ioctl.o

sd_mod.o: sd.o sd_ioctl.o
	$(LD) $(LD_RFLAG) -r -o $@ sd.o sd_ioctl.o

acornscsi_mod.o: acornscsi.o acornscsi-io.o queue_mod.o msgqueue_mod.o
	$(LD) $(LD_RFLAG) -r -o $@ acornscsi.o acornscsi-io.o queue_mod.o msgqueue_mod.o

cumana_2_mod.o: cumana_2.o fas216_mod.o queue_mod.o msgqueue_mod.o
	$(LD) $(LD_RFLAG) -r -o $@ cumana_2.o fas216_mod.o queue_mod.o msgqueue_mod.o

powertec_mod.o: powertec.o fas216_mod.o queue_mod.o msgqueue_mod.o
	$(LD) $(LD_RFLAG) -r -o $@ powertec.o fas216_mod.o queue_mod.o msgqueue_mod.o

eesox_mod.o: eesox.o fas216_mod.o queue_mod.o msgqueue_mod.o
	$(LD) $(LD_RFLAG) -r -o $@ eesox.o fas216_mod.o queue_mod.o msgqueue_mod.o

fas216_mod.c: fas216.c
	ln -s fas216.c $@

queue_mod.c: queue.c
	ln -s queue.c $@

msgqueue_mod.c: msgqueue.c
	ln -s msgqueue.c $@

%.o: %.S
	$(CC) $(CFLAGS) -E $< | tr ';$$' '\n#' > ..tmp.s
	$(CC) $(CFLAGS) -c -o $@ ..tmp.s
	$(RM) ..tmp.s

.PHONY: links
links:
	-@for f in $(LK); do \
		if [ ! -e $$f ]; then \
			echo "ln -s ../../../../drivers/scsi/$$f ."; \
			ln -s ../../../../drivers/scsi/$$f .; \
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
