#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile,v
#- File Revision          : 1.3
#-
#- Release Information    : ADK_REL1v1
#-
#- ---------------------------------------------------------------------
#- Purpose :
#-           A makefile to compile FRBM tests
#-
#- --=================================================================--

ALL_TESTS = IntegrationTest.frd

all: $(ALL_TESTS)

clean:
	@rm -rf *.frd

%: %.fri
	$(ADK)/design/FileReader/bin/fileconv.pl --infile $< --outfile $@.frd

%.frd: %.fri
	$(ADK)/design/FileReader/bin/fileconv.pl --infile $< --outfile $@
