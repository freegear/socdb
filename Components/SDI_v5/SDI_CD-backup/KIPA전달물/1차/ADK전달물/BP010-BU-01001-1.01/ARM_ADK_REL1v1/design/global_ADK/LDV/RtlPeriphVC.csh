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
# File Name           : RtlPeriphVC.csh,v
# File Revision       : 1.4
#
# Release Information : ADK_REL1v1
#
################################################################################
# Purpose             : To create a PERIPH.vc file for Verilog-XL simulation
#
################################################################################

cat <<EOF > ${PERIPH}_rtl.vc
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/
/*;                     Copyright (C) 2001 ARM Ltd.                */
/*;                     ARM Ltd. Confidential                      */
/*;                                                                */
/*;  Filename : ${PERIPH}_rtl.vc                                   */
/*;                                                                */
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/
/*;                                                                */
/*;  Generated library mappings for EASY components                */
/*;                                                                */
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

EOF

foreach comp ($argv)
  if !(`echo ${comp}|grep Package` == "") then
    echo "+incdir+${ADK}/design/${PERIPH}/verilog/rtl_source" >> ${PERIPH}_rtl.vc
  else if (`echo ${comp}|grep global_ADK` == "") then
    echo "${ADK}/design/${PERIPH}/verilog/rtl_source/${comp}" >> ${PERIPH}_rtl.vc
  endif
end

