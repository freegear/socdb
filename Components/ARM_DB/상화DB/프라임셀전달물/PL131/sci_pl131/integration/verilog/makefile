#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.2
#-
#- Release Information    : PrimeCell(TM)-PL131-REL1v0
#-
#- ---------------------------------------------------------------------
#- Purpose :
#-           A makefile to initiate TicTalk simulations 
#- --=================================================================--

# list of directories to make. Order is important
DIRS = sys chip trickbox ticbox tbench

TEST_ENV = TICTALK

# BETA Release Note : Known Issue
# To run Modelsim Netlist simulation use AMBA = APB
# To run all other simulations use AMBA = AHB

AMBA = AHB
#AMBA = APB

include $(GLOBAL)/$(SIMULATOR)/DirSimMakefile.mk

################################ End ###################################
