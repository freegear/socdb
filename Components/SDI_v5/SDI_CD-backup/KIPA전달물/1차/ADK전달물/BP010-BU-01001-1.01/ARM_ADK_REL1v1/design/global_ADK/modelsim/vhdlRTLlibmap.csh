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
# File Name           : vhdlRTLlibmap.csh,v
# File Revision       : 1.16
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
;                            Copyright (C) 2001 ARM Ltd.
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
  if (-f ${ADK}/design/${comp}/${HDL_SOURCE}/rtl_source/EASYlibmap) then
    grep '=' ${ADK}/design/${comp}/${HDL_SOURCE}/rtl_source/EASYlibmap|grep -v 'others =' >> EASYlibmap
  else
    echo "${comp} = ${ADK}/design/${comp}/${HDL_SOURCE}/rtl_source/work" >> EASYlibmap
  endif
end

echo "${PERIPH} = ${ADK}/design/${PERIPH}/${HDL_SOURCE}/rtl_source/work" >> EASYlibmap

echo '' >> EASYlibmap
echo 'others = $GLOBAL/modelsim/libmap' >> EASYlibmap
echo '' >> EASYlibmap
