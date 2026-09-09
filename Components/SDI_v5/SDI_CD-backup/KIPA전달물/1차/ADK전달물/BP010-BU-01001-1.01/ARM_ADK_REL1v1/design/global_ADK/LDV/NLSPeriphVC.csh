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
# File Name           : NLSPeriphVC.csh,v
# File Revision       : 1.3
#
# Release Information : ADK_REL1v1
#
################################################################################
# Purpose             : To create a PERIPH.vc file for Verilog-XL simulation
#
################################################################################

cat <<EOF > ${PERIPH}_nls.vc
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/
/*;                     Copyright (C) 2001 ARM Ltd.                */
/*;                     ARM Ltd. Confidential                      */
/*;                                                                */
/*;  Filename : ${PERIPH}_nls.vc                                   */
/*;                                                                */
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/
/*;                                                                */
/*;  Generated library mappings for EASY components                */
/*;                                                                */
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

EOF

if (-d ${ADK}/design/${PERIPH}/verilog/netlist) then
  set dirname = netlist
else
  set dirname = rtl_source
endif

foreach comp ($argv)
  if !(`echo ${comp}|grep Package` == "") then
    echo "+incdir+${ADK}/design/${PERIPH}/verilog/${dirname}" >> ${PERIPH}_nls.vc
  else if (`echo ${comp}|grep global_ADK` == "") then
    echo "${ADK}/design/${PERIPH}/verilog/${dirname}/${comp}" >> ${PERIPH}_nls.vc
  endif
end

