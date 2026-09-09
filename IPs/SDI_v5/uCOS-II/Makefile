#
# pjk 050603 : uCOSII Main Makefile
#

TOPDIR	:= $(shell if [ "$$PWD" != "" ]; then echo $$PWD; else pwd; fi)
export	TOPDIR

# load other configuration
include $(TOPDIR)/config.mk

# final binary file name       
TARGET_IMAGE = ucos

# linker option
LDSCRIPT := $(TOPDIR)/ld-xscale.lds
LDFLAGS = -nostdlib -static -e reset -T $(LDSCRIPT)
#LDFLAGS += -Bstatic -T $(LDSCRIPT) -Ttext 0xa0000000 
# objcopy option
OCFLAGS = -O binary -R .note -R .comment -S

# uCOSII subdirectorys
SUBDIRS	= SOURCE \
	  $(TARGET)/$(COMPILER) \
	  $(APPLICATION_DIR)/$(COMPILER)/SOURCE

LIBS  =	$(TOPDIR)/$(TARGET)/$(COMPILER)/lib$(PORT).a
LIBS += $(TOPDIR)/SOURCE/lib$(UCOS).a
LIBS += $(TOPDIR)/$(APPLICATION_DIR)/$(COMPILER)/SOURCE/lib$(APP).a
	
OBJS  =	$(TARGET)/$(COMPILER)/start_up.o
PLATFORM_LIBS = -L $(shell dirname `$(CC) $(CFLAGS) -print-libgcc-file-name`) -lgcc
	
all : subdirs $(LIBS) $(LDSCRIPT)
	$(LD) $(LDFLAGS) $(OBJS) $(LIBS) $(PLATFORM_LIBS) -Map $(TARGET_IMAGE).map -o $(TARGET_IMAGE)
	$(OBJCOPY) $(OCFLAGS) $(TARGET_IMAGE) $(TARGET_IMAGE)_bin

subdirs:
		@for dir in $(SUBDIRS) ; do $(MAKE) -C $$dir ; done

depend dep:
		@for dir in $(SUBDIRS) ; do $(MAKE) -C $$dir .depend ; done		
			
clean :
	rm -rf *.o
	rm -rf $(TARGET_IMAGE) $(TARGET_IMAGE)-elf32
	rm -rf $(TARGET_IMAGE).dis $(TARGET_IMAGE).map
	rm -rf *.*.bak header/*.*.bak
	@for dir in $(SUBDIRS) ; do $(MAKE) -C $$dir clean; done
