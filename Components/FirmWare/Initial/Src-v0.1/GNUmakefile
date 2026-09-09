#
# MODULE NAME:    GNUmakefile 
# PROJECT CODE:   F/W
# DESCRIPTION:    Platform/Toolchain independent GNUmakefile
# AUTHOR:         SHMT SOC 2Team
# DATE:           04 December, 2006
#
# SOURCE CONTROL: $Id: GNUmakefile,v 1.33 2001/10/18 10:23:01 integration Exp $
#
# LICENSE:
#    This source code is copyright (c) 2006 shmt Limited.
#    All rights reserved.
#
# REVISION HISTORY:
#
# SOURCE:
#
# ISSUES:
#

SHELL = /bin/sh

###########################################################################
#
# PATTERN RULES
#

ARM_CONFIG = -D__ARM_GCC_USE__

#
# Objects from C
#
%.o: %.c 
#	@echo "Building top"
	$(CC) -march=armv4 $(ARM_CONFIG) -O2 -c $(COMPILER_FLAGS) $(CONFIG_FLAGS) $(OPTIMIZATIONS) $(INCLUDES) $(PLATFORM_INCLUDES) $< -o $@ 2>error.log

#
# Objects from Asm
%.o: %.s 
	$(ASM) -march=armv4 $(ARM_CONFIG) -O2 $(ASM_FLAGS) $< -o $@ 2>error.log

#
# Objects from Asm
%.o: %.asm 
	$(ASM) $(ASM_FLAGS) $(ARM_CONFIG) $< -o $@ 2>error.log

 # Objects from GNU asm
 %.o: %.S 
	$(CC) -march=armv4 $(ARM_CONFIG) -O2 -c $(COMPILER_FLAGS) $(CONFIG_FLAGS) $(OPTIMZATIONS) $(INCLUDES) $(PLATFORM_INCLUDES) $< -o $@ 2>error.log

#
# Asm from C
#
%.s: %.c 
	$(CC) -march=armv4 $(ARM_CONFIG) -O2 -s $(COMPILER_FLAGS) $(CONFIG_FLAGS) $(OPTIMIZATIONS) $(INCLUDES) $(PLATFORM_INCLUDES) $< -o $@

#
# Postprocessed C from Preprocessed C
#
%.e: %.c 
	$(CC) -E $(ARM_CONFIG) $(COMPILER_FLAGS) $(CONFIG_FLAGS) $(OPTIMIZATIONS) $(INCLUDES) $(PLATFORM_INCLUDES) $< -o $@






################################################################################
#
# Architecture: ARM 
# 
################################################################################

#
# Tool Configuration
#


## Tools ##
ifeq ($(INSTRUCTION_SET),THUMB)
CC = tcc
else
CC = arm-elf-gcc
endif

ASM = arm-elf-as
LD = arm-elf-ld

AR = arm-elf-ar
ARFLAGS = rcvs

OBJDUMP = arm-elf-objdump
OBJCOPY = arm-elf-objcopy


## Endian Setting ##
#ifeq ($(ENDIAN), __LITTLE_ENDIAN)
#	ASM_ENDIAN = -littleend
#else 
#	ASM_ENDIAN = -bigend
#endif


#
# Module Configuration
#
LIB_TARGET = libfw.a
PERI_TARGET = peri_objs
API_TARGET = api_objs
FAT32_TARGET = libfat32.a

FPGATEST_TARGET = fpgatest


############################################################################
#
# LIBRARY TARGET RULES AND DEPENDENCIES
#



#all: lib peri api fat fpga
all: lib peri fpga

## Make file include ##
-include lib/lib_make_rules
-include peri/peri_make_rules
#-include fpgatest/api/api_make_rules
#-include fpgatest/rfat32_lib/fat_make_rules
-include fpgatest/fpgatest_make_rules
-include .depend


## Header Files include directory ##
INCLUDES =\
		$(LIB_INCLUDES)		\
		$(PERI_INCLUDES)	\
		$(API_INCLUDES) 	\
		$(FAT_INCLUDES) 	\
		$(FPGATEST_INCLUDES)	

############################################################################
#
# TARGET RULES AND DEPENDENCIES
#


.PHONY: depend dep clean 

# Need to analysis by DJKIM 2006/11/28
depend dep .depend: 
	@set -e; 
	@-$(RM) $@
#	@for i in $(basename $(LIB_SOURCES) $(HAL_SOURCES) .o); do 
	@for i in $(basename $(LIB_SOURCES) .o); do \
		echo "- Generating dependencies for $$i.c"; \
		$(CC) -M $(COMPILER_FLAGS) $(CONFIG_FLAGS) \
			$(INCLUDES) $(PLATFORM_INCLUDES) $$i.c \
			| sed 's!\\!\/!g' | sed 's///g'  \
			| sed "s!\([^.]*\)\.o[ :]*!$$i.o: !g" >> .depend; \
        done;

#clean: lib_clean peri_clean api_clean fat_clean fpgatest_clean
clean: lib_clean peri_clean fpgatest_clean
	-$(RM) error.log *.o *.bin
