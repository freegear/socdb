#!/bin/csh -f
################################################################################
# This confidential and proprietary software may be used only as
# authorised by a licensing agreement from ARM Limited
#   (C) COPYRIGHT 2000-2001 ARM Limited
#       ALL RIGHTS RESERVED
# The entire notice above must be reproduced on all authorised
# copies and copies may only be made to the extent permitted
# by a licensing agreement from ARM Limited.
#
################################################################################
# Version and Release Control Information:
#
# File Name           : verilogNLSlibmap.csh,v
# File Revision       : 1.4
#
# Release Information : ADK_REL1v1
#
################################################################################
# Purpose             : To create a EASYlibmap file to point at HDL libraries 
#
#                       Located in the /modeltech directory.         
#                                                                        
################################################################################

set PERIPH = $argv[1]

cat <<EOF >EASYlibmap
EOF

foreach comp ($argv[2-$#argv])
  if ( -d ${ADK}/design/${comp}/${HDL_NETL}/netlist ) then
    if (-f ${ADK}/design/${comp}/${HDL_NETL}/netlist/EASYlibmap) then
      grep '\-L' ${ADK}/design/${comp}/${HDL_NETL}/netlist/EASYlibmap >> EASYlibmap
    else
      echo "-L ${ADK}/design/${comp}/${HDL_NETL}/netlist/work" >> EASYlibmap
    endif
  else
    if (-f ${ADK}/design/${comp}/${HDL_NETL}/rtl_source/EASYlibmap) then
      grep '\-L' ${ADK}/design/${comp}/${HDL_NETL}/rtl_source/EASYlibmap >> EASYlibmap
    else
      echo "-L ${ADK}/design/${comp}/${HDL_NETL}/rtl_source/work" >> EASYlibmap
    endif
  endif
end

if (${PERIPH} == "EASY_ML") then
   echo "-L ${DIR_ARM922T}/work" >> EASYlibmap
endif
if (${PERIPH} == "EASY_ARM7") then
   echo "-L ${DIR_ARM7TDMI}/work" >> EASYlibmap
endif

if ( -d ${ADK}/design/${PERIPH}/${HDL_NETL}/netlist ) then
  echo "-L ${ADK}/design/${PERIPH}/${HDL_NETL}/netlist/work" >> EASYlibmap
else
  echo "-L ${ADK}/design/${PERIPH}/${HDL_NETL}/rtl_source/work" >> EASYlibmap
endif
