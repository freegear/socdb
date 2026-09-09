#!/bin/csh -f

################################################################################
# This confidential and proprietary software may be used only as
# authorised by a licensing agreement from ARM Limited
#   (C) COPYRIGHT 1999 ARM Limited
#       ALL RIGHTS RESERVED
# The entire notice above must be reproduced on all authorised
# copies and copies may only be made to the extent permitted
# by a licensing agreement from ARM Limited.
#
################################################################################
# Version and Release Control Information:
#
# File Name           : run_check_logs.csh,v                                              
# File Revision       : 1.2
#
# Release Information : PL050-REL1v1
#
################################################################################
# Purpose             : Script to check logs for errors and warnings.
#
#                       Located in the /BusTalk/vhdl/tbench directory.
################################################################################

echo "# Checking ./logs/*.log for errors and warnings."

grep -i error logs/*.log > logs/kmi_errors.lst
echo "# Written errors to ./logs/kmi_errors.lst"

grep -i warning logs/*.log > logs/kmi_warnings.lst
echo "# Written warnings to ./logs/kmi_warnings.lst"

####################################### End ####################################
