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
# File Name           : EASY_NLS_loaddb.csh,v
# File Revision       : 1.4
#
# Release Information : ADK_REL1v1
#
################################################################################
# Purpose             : To create a file to point at db files of
#                       sub-blocks in the design 
#
################################################################################

set EASY = $argv[1]

cat <<EOF > ${EASY}_subload.cmd
/*********************************************************************/
/*                       Copyright (C) 2001 ARM Ltd.                 */
/*                       ARM Ltd. Confidential                       */
/*                                                                   */
/*  Filename : ${EASY}_subload.cmd                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  Generated db locations for sub-blocks in EASY top-level          */
/*                                                                   */
/*********************************************************************/

EOF

foreach comp ($argv[2-$#argv])
  if ( -d ${ADK}/design/${comp}/synopsys ) then
    set dbfiles = `ls ${ADK}/design/${comp}/synopsys/db/*_${TEST_METH}_${HDL_SOURCE}_${HDL_NETL}.db`
    echo $comp $dbfiles
    if ( "${dbfiles}" != "" ) then
      foreach dbfile (${dbfiles})
        # Do not include CPU AHB wrappers - they are instead included
        # in a top-level file which instantiates both the wrapper and
        # the CPU itself
	if ( "`echo ${dbfile} | grep Wrap`" == "" ) then
	  echo "read -format db ${dbfile}" >> ${EASY}_subload.cmd
	  echo "set_dont_touch current_design" >> ${EASY}_subload.cmd
	  echo "" >> ${EASY}_subload.cmd
	endif
      end
    else
      echo ""
      echo "WARNING: No db file(s) found for component " ${comp}
      echo "         Black boxes will be used for top-level synthesis"
      echo ""
    endif
  endif
end
