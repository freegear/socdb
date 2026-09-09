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
# File Name           : vhdlNLSlibmap.csh,v
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                            Copyright (C) 2000 ARM Ltd.
;                            ARM Ltd. Confidential
;
;  Filename : EASYlibmap
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Generated library mappings for EASY components
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[library]

EOF

foreach comp ($argv[2-$#argv])
  if ( -d ${ADK}/design/${comp}/${HDL_NETL}/netlist ) then
    if (-f ${ADK}/design/${comp}/${HDL_NETL}/netlist/EASYlibmap) then
      grep '=' ${ADK}/design/${comp}/${HDL_NETL}/netlist/EASYlibmap|grep -v 'others =' >> EASYlibmap
    else
      echo "${comp} = ${ADK}/design/${comp}/${HDL_NETL}/netlist/work" >> EASYlibmap
    endif
  else
    if (-f ${ADK}/design/${comp}/${HDL_NETL}/rtl_source/EASYlibmap) then
      grep '=' ${ADK}/design/${comp}/${HDL_NETL}/rtl_source/EASYlibmap|grep -v 'others =' >> EASYlibmap
    else
      echo "${comp} = ${ADK}/design/${comp}/${HDL_NETL}/rtl_source/work" >> EASYlibmap
    endif
  endif
end

if ( -d ${ADK}/design/${PERIPH}/${HDL_NETL}/netlist ) then
  echo "${PERIPH} = ${ADK}/design/${PERIPH}/${HDL_NETL}/netlist/work" >> EASYlibmap
else
  echo "${PERIPH} = ${ADK}/design/${PERIPH}/${HDL_NETL}/rtl_source/work" >> EASYlibmap
endif

echo '' >> EASYlibmap
echo 'libvhdl = $LIB_VHDL/work' >> EASYlibmap

echo '' >> EASYlibmap
echo 'others = $GLOBAL/modelsim/libmap' >> EASYlibmap
echo '' >> EASYlibmap
