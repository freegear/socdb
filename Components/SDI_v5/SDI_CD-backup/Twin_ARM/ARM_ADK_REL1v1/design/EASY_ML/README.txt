#- --===============================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#- -------------------------------------------------------------------
#- 
#- Version and Release Control Information:
#- 
#- File Name              : README.txt,v
#- File Revision          : 1.2
#- 
#- Release Information    : ADK_REL1v1
#- 
#- -------------------------------------------------------------------
#- Purpose : 
#-           ADK EASY_ML top level README file 
#-
#- --===============================================================--

Introduction
------------

This directory contains the ADK EASY_ML top-level design.  This is an
example AMBA system displaying the use of Multi-Layer AHB.  It
contains instantiations of an ARM922 CPU macrocell and a File Reader
Bus Master to provide bus stimulus, plus a number of AHB and APB slave
devices.

NOTE: The simulation model of the ARM922 (referred to as the "Design
      Sign-off Model" or "DSM") is supplied separately by ARM under
      a separate license to ADK.

The structure is organised as a standalone ADK component similar
to the PrimeCell Peripherals supplied by ARM.

Models are written in both VHDL and Verilog.

Please refer to the ADK Technical Reference Manual and User Guide for
further details on the use of this component.
 
======================== End of README.txt ===========================
