#  
# This is an automatically generated script file for loading the instrumented 
# design into Identify (used mostly for Identify testing purposes) 
# 
compile include "./"
compile include "C:/Program Files/Synplicity/fpga_862/lib"
compile option -v2001 1
compile devicelib "C:/Program Files/Synplicity/fpga_862/lib/xilinx/unisim.v"
compile add -verilog -work work  "D:/ETRI_UWB/2007524/synplify1/rev_2_identify/instr_sources/rtl/ISMC/SSRAM8bit.v"
compile add -verilog -work work  "D:/ETRI_UWB/2007524/synplify1/rev_2_identify/instr_sources/rtl/ISMC/SSRAM32bit.v"
compile add -verilog -work work  "D:/ETRI_UWB/2007524/synplify1/rev_2_identify/instr_sources/rtl/ISMC/ismc_ahb.v"
compile add -verilog -work work  "D:/ETRI_UWB/2007524/synplify1/rev_2_identify/instr_sources/model/xilinx/mypll2x.v"
compile add -verilog -work work  "D:/ETRI_UWB/2007524/synplify1/rev_2_identify/instr_sources/rtl/Top/UWB_pci/FPGA1.v"
compile add "D:/ETRI_UWB/2007524/synplify1/rev_2_identify/instr_sources/syn_dics.v"
compile toplevel FPGA1
instrumentation new rev_2_identify
instrumentation load rev_2_identify
device family virtex4 
