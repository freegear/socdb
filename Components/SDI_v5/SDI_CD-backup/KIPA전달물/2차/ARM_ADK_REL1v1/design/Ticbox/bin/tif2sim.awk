#!/bin/csh -f
################################################################################
# This confidential and proprietary software may be used only as
# authorised by a licensing agreement from ARM Limited
#   (C) COPYRIGHT 1998 ARM Limited
#       ALL RIGHTS RESERVED
# The entire notice above must be reproduced on all authorised
# copies and copies may only be made to the extent permitted
# by a licensing agreement from ARM Limited.
#
################################################################################
# Version and Release Control Information:
#
# File Name           : tif2sim.awk,v                                              
# File Revision       : 1.1
#
# Release Information : ADK_REL1v1
#
################################################################################
# Purpose             : This awk script converts a tif file for a VHDL
#                       simulation environment into a sim file format for the
#                       Verilog tb_tic test bench simulation.
#                       Usage:  awk -f tif2sim
################################################################################

# Replace beginning ; with a Verilog commenting //
/^;/ { printf "\n// "; 
       for (i = 2; i <= NF; i = i + 1) { printf "%s ", $i};
       printf "\n" }

/^A/ { printf "A(32'h%s);\n", $2}

/^W/ { printf "W(32'h%s);\n", $2}

/^R/ { printf "R(32'h%s, 32'h%s);\n", $2 ,$3}

/^L/ { printf "L(32'd%s);\n", $2}

/^E/ { printf "E(32'h%s);\n", $2}

