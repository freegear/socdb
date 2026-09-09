source "C:/Program Files/Synplicity/fpga_862/lib/altera/quartus_cons.tcl"
syn_create_and_open_prj TestPlatformFPGA
source $::quartus(binpath)/prj_asd_import.tcl
syn_create_and_open_csf TestPlatformFPGA
syn_handle_cons TestPlatformFPGA
