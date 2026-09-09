#
# Makefile for the kernel block device drivers.
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#
# Note 2! The CFLAGS definition is now inherited from the
# parent makefile.
#

all: links first_rule

L_TARGET := block.a
L_OBJS   := ll_rw_blk.o genhd.o
M_OBJS   :=
MOD_LIST_NAME := BLOCK_MODULES

LK	  = README.fd README.hd README.ide README.md \
	    ide_modes.h ide-cd.c ide-tape.c ide-tape.h \
	    linear.c loop.c md.c raid0.c raid1.c raid5.c rd.c

# Architecture dependencies

ifeq ($(MACHINE),arc)
  FLOPPY = fd1772.o fd1772dma.o
  FLOPPYMOD = fd1772_mod.o
endif

ifeq ($(MACHINE),a5k)
  FLOPPY = floppy.o
  FLOPPYMOD = floppy.o
endif

ifeq ($(MACHINE),rpc)
  FLOPPY = floppy.o
  FLOPPYMOD = floppy.o
endif

# Common dependencies

ifdef FLOPPY
  ifeq ($(CONFIG_BLK_DEV_FD),y)
    L_OBJS += $(FLOPPY)
  else
    ifeq ($(CONFIG_BLK_DEV_FD),m)
      M_OBJS += $(FLOPPYMOD)
    endif
  endif
endif

ifeq ($(CONFIG_BLK_DEV_PART),y)
  L_OBJS += adfspart.o
endif

ifeq ($(CONFIG_BLK_DEV_RAM),y)
  L_OBJS += rd.o
else
  ifeq ($(CONFIG_BLK_DEV_RAM),m)
    M_OBJS += rd.o
  endif
endif

ifeq ($(CONFIG_BLK_DEV_LOOP),y)
  L_OBJS += loop.o
else
  ifeq ($(CONFIG_BLK_DEV_LOOP),m)
    M_OBJS += loop.o
  endif
endif

ifeq ($(CONFIG_BLK_DEV_HD),y)
  L_OBJS += hd.o
endif

ifeq ($(CONFIG_BLK_DEV_IDE),y)
  L_OBJS += ide.o
endif

ifeq ($(CONFIG_BLK_DEV_IDE_ICSIDE),y)
  L_OBJS += ide-ics.o
else
  ifeq ($(CONFIG_BLK_DEV_IDE_ICSIDE),m)
    M_OBJS += ide-ics.o
  endif
endif

ifeq ($(CONFIG_BLK_DEV_IDE_RAPIDE),y)
  L_OBJS += ide-rapide.o
else
  ifeq ($(CONFIG_BLK_DEV_IDE_RAPIDE),m)
    M_OBJS += ide-rapide.o
  endif
endif

ifeq ($(CONFIG_BLK_DEV_IDECD),y)
  L_OBJS += ide-cd.o
endif

ifeq ($(CONFIG_BLK_DEV_IDETAPE),y)
  L_OBJS += ide-tape.o
endif

ifeq ($(CONFIG_BLK_DEV_IDEFLOPPY),y)
L_OBJS += ide-floppy.o
endif

ifeq ($(CONFIG_BLK_DEV_XD),y)
  L_OBJS += mfmhd.o mfm.o
else
  ifeq ($(CONFIG_BLK_DEV_XD),m)
    M_OBJS += mfmhd_mod.o
  endif
endif

ifeq ($(CONFIG_BLK_DEV_MD),y)
LX_OBJS += md.o

ifeq ($(CONFIG_MD_LINEAR),y)
L_OBJS += linear.o
else
  ifeq ($(CONFIG_MD_LINEAR),m)
  M_OBJS += linear.o
  endif
endif

ifeq ($(CONFIG_MD_STRIPED),y)
L_OBJS += raid0.o
else
  ifeq ($(CONFIG_MD_STRIPED),m)
  M_OBJS += raid0.o
  endif
endif

ifeq ($(CONFIG_MD_MIRRORING),y)
L_OBJS += raid1.o
else
  ifeq ($(CONFIG_MD_MIRRORING),m)
  M_OBJS += raid1.o
  endif
endif

ifeq ($(CONFIG_MD_RAID5),y)
L_OBJS += raid5.o
else
  ifeq ($(CONFIG_MD_RAID5),m)
  M_OBJS += raid5.o
  endif
endif

endif

include $(TOPDIR)/Rules.make

fastdep: links

fd1772_mod.o: $(FLOPPY)
	ld -r -o $@ $(FLOPPY)

mfmhd_mod.o: mfmhd.o mfm.o
	ld -r -o $@ mfmhd.o mfm.o

.PHONY: links
links:
	-@for f in $(LK); do \
		if [ ! -e $$f ]; then \
		    echo "ln -s ../../../../drivers/block/$$f ."; \
		    ln -s ../../../../drivers/block/$$f .; \
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

%.o: %.S
	$(CC) $(CFLAGS) -E $< | tr ';$$' '\n#' > ..tmp.s
	$(CC) $(CFLAGS) -c -o $@ ..tmp.s
	$(RM) ..tmp.s
