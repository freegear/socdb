#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
#-	 ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name		  : Components_EASY_ML.mk,v
#- File Revision	  : 1.2
#-
#- Release Information	  : ADK_REL1v1
#-
#- ---------------------------------------------------------------------
#- Purpose :
#-	     List of ADK components to be included in makefiles
#-
#- --=================================================================--
             
COMPONENTS =    A922T \
	        dmac_pl081 \
                BusMatrix \
                ElementsAHB \
                ElementsAPB \
                gpio_pl061 \
                InternalMemory \
                Interrupt \
                ResetCntl \
                smc_pl092 \
                RemapPause \
                Timers \
                Watchdog \
	        uart_pl011 \
	        ebi_pl220 \
                mpmc_pl172 \
                mmc_pl181 \
                sci_pl131 \
		ssp_pl022 \
		aaci_pl041\
		rtc_pl031

