#  
# This is an automatically generated script file for loading the instrumented 
# design into Identify (used mostly for Identify testing purposes) 
# 
compile include "./"
compile include "C:/Program Files/Synplicity/fpga_862/lib"
compile option -v2001 1
compile devicelib "C:/Program Files/Synplicity/fpga_862/lib/xilinx/unisim.v"
compile add -verilog -work work  "D:/ETRI_UWB/ADK_PCI_BOARD/synplify/rev_2_identify/instr_sources/SevenSegment.v"
compile add -verilog -work work  "D:/ETRI_UWB/ADK_PCI_BOARD/synplify/rev_2_identify/instr_sources/PCI_FPGA.v"
compile add "D:/ETRI_UWB/ADK_PCI_BOARD/synplify/rev_2_identify/instr_sources/syn_dics.v"
compile toplevel PCI_FPGA
instrumentation new rev_2_identify
instrumentation load rev_2_identify
device family virtex4 
