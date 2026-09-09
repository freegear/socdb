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
#- File Revision          : 1.5
#- 
#- Release Information    : ADK_REL1v1
#- 
#- -------------------------------------------------------------------
#- Purpose : 
#-           ADK ElementsAHB top level README file 
#-
#- --===============================================================--

Introduction
------------

This directory contains the AHB infrastructure components contained
within ADK, collectively known as "ElementsAHB".

Models are written in both VHDL and Verilog.


Arbiter15
----------

Arbiter15 is not shipped with this release of the ADK.


MuxS2M and MuxS2M16slot
-----------------------

The default MuxS2M supports 7 slaves plus the default slave. If the
design needs to support up to 15 slaves plus the default slave, then
MuxS2M16slot can be used. Both muxes have the same entity name, but 
only one of them is in use at any time using the current makefile
set-up. It is suggested to swap the HDL files by renaming MuxS2M.v(hd)
file to MuxS2M8slot.v(hd) and then rename MuxS2M16slot.v(hd) file to
MuxS2M.v(hd). Where appropriate, the design files previously using 
the smaller mux will require updating.


Please refer to the ADK Technical Reference Manual and User Guide for
further details on the use of these components.
 
======================== End of README.txt ===========================
