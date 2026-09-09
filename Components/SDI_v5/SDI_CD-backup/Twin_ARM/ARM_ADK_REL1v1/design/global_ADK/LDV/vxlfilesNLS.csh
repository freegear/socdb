#!/bin/tcsh -f
################################################################################
# This confidential and proprietary software may be used only as
# authorised by a licensing agreement from ARM Limited
#   (C) COPYRIGHT 2001 ARM Limited
#       ALL RIGHTS RESERVED
# The entire notice above must be reproduced on all authorised
# copies and copies may only be made to the extent permitted
# by a licensing agreement from ARM Limited.
#
################################################################################
# Version and Release Control Information:
#
# File Name           : vxlfilesNLS.csh,v
# File Revision       : 1.7
#
# Release Information : ADK_REL1v1
#
################################################################################
# Purpose             : To create a vxl.files.nls file to point at HDL libraries 
#
################################################################################

set PERIPH = $argv[1]

cat <<EOF > vxl.files.nls
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/
/*;                     Copyright (C) 2001 ARM Ltd.                */
/*;                     ARM Ltd. Confidential                      */
/*;                                                                */
/*;  Filename : vxl.files.nls                                      */
/*;                                                                */
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/
/*;                                                                */
/*;  Generated library mappings for EASY components                */
/*;                                                                */
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

EOF

\rm -f vxl.files.nls.tmp
touch vxl.files.nls.tmp

foreach comp ($argv[2-$#argv])
  if !( -d ${ADK}/design/${comp}/${HDL_NETL}/netlist ) then
    if ( -f ${ADK}/design/${comp}/${HDL_NETL}/rtl_source/vxl.files.nls) then
      grep '\-f' ${ADK}/design/${comp}/${HDL_NETL}/rtl_source/vxl.files.nls >> vxl.files.nls.tmp
    else
      echo "-f ${ADK}/design/${comp}/${HDL_NETL}/rtl_source/${comp}_nls.vc" >> vxl.files.nls.tmp
    endif
  else
    if (-f ${ADK}/design/${comp}/${HDL_NETL}/netlist/vxl.files.nls) then
      grep '\-f' ${ADK}/design/${comp}/${HDL_NETL}/netlist/vxl.files.nls >> vxl.files.nls.tmp
    else
      echo "-f ${ADK}/design/${comp}/${HDL_NETL}/netlist/${comp}_nls.vc" >> vxl.files.nls.tmp
    endif
  endif
end

if (${PERIPH} == "EASY_ML") then
   echo "-f ${DIR_ARM922T}/ARM922T_nls.vc" >> vxl.files.nls.tmp
endif

if (${PERIPH} == "EASY_ARM7") then
   echo "-f ${DIR_ARM7TDMI}/ARM7TDMI_nls.vc" >> vxl.files.nls.tmp
endif

sort vxl.files.nls.tmp |uniq >> vxl.files.nls
\rm -f vxl.files.nls.tmp

echo ""  >> vxl.files.rtl
if !( -d ${ADK}/design/${PERIPH}/${HDL_NETL}/netlist ) then
  echo "-f ${ADK}/design/${PERIPH}/${HDL_NETL}/rtl_source/${PERIPH}_nls.vc" >> vxl.files.nls
else
  echo "-f ${ADK}/design/${PERIPH}/${HDL_NETL}/netlist/${PERIPH}_nls.vc" >> vxl.files.nls
endif

echo ""  >> vxl.files.nls
echo "-y ${ADK}/design/global_ADK/verilog"  >> vxl.files.nls
