source "C:/Program Files/Synplicity/fpga_81/lib/altera/quartus_cons.tcl"
syn_create_and_open_prj VideoEncoderTester
source $::quartus(binpath)/prj_asd_import.tcl
syn_create_and_open_csf VideoEncoderTester
syn_handle_cons VideoEncoderTester
syn_compile_quartus
