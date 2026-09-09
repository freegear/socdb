#!/bin/csh -f
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
# File Name           : vxlfilesRTL.csh,v
# File Revision       : 1.6
#
# Release Information : ADK_REL1v1
#
################################################################################
# Purpose             : To create a vxl.files.rtl file to point at HDL libraries 
#
################################################################################

set PERIPH = $argv[1]

cat <<EOF > vxl.files.rtl
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/
/*;                     Copyright (C) 2001 ARM Ltd.                */
/*;                     ARM Ltd. Confidential                      */
/*;                                                                */
/*;  Filename : vxl.files.rtl                                      */
/*;                                                                */
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/
/*;                                                                */
/*;  Generated library mappings for EASY components                */
/*;                                                                */
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

EOF

\rm -f vxl.files.rtl.tmp
touch vxl.files.rtl.tmp

foreach comp ($argv[2-$#argv])
  if ( -f ${ADK}/design/${comp}/${HDL_SOURCE}/rtl_source/vxl.files.rtl) then
    grep '\-f' ${ADK}/design/${comp}/${HDL_SOURCE}/rtl_source/vxl.files.rtl >> vxl.files.rtl.tmp
  else
    echo "-f ${ADK}/design/${comp}/${HDL_SOURCE}/rtl_source/${comp}_rtl.vc" >> vxl.files.rtl.tmp
  endif
end

if (${PERIPH} == "EASY_ML") then
   echo "-f ${DIR_ARM922T}/ARM922T_rtl.vc" >> vxl.files.rtl.tmp
endif

if (${PERIPH} == "EASY_ARM7") then
   echo "-f ${DIR_ARM7TDMI}/ARM7TDMI_rtl.vc" >> vxl.files.rtl.tmp
endif

sort vxl.files.rtl.tmp |uniq >> vxl.files.rtl
\rm -f vxl.files.rtl.tmp

echo ""  >> vxl.files.rtl
echo "-f ${ADK}/design/${PERIPH}/${HDL_SOURCE}/rtl_source/${PERIPH}_rtl.vc" >> vxl.files.rtl

echo ""  >> vxl.files.rtl
echo "-y ${ADK}/design/global_ADK/verilog"  >> vxl.files.rtl

