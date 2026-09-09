#############################################################################
# create directory for intermediate files
#############################################################################
read_verilog  /user/cklee/PRJ/8051_013/FE/SCAN/SCAN_DB/rc8051RtlTop_scan.v.out

current_design rc8051RtlTop 
link

set_operating_conditions -analysis_type bc_wc -max slow -min fast
set_wire_load_mode "segmented"

read_sdc  /user/cklee/PRJ/8051_013/FE/SYN/rc8051RtlTop.sdc

set_annotated_delay -cell -load_delay cell -min 2.0     -to PI_clk/C
set_annotated_delay -cell -load_delay cell -max 3.0     -to PI_clk/C
set_annotated_transition 0.2 [get_pins PI_clk/C]

set_annotated_delay -cell -load_delay cell -min 2.0     -to PI_rst_p/C
set_annotated_delay -cell -load_delay cell -max 3.0     -to PI_rst_p/C
set_annotated_transition 0.2 [get_pins PI_rst_p/C]

set_annotated_delay -cell -load_delay cell -min 2.0     -to PI_scan_en/C
set_annotated_delay -cell -load_delay cell -max 3.0     -to PI_scan_en/C
set_annotated_transition 0.2 [get_pins PI_scan_en/C]

set_annotated_delay -cell -load_delay cell -min 2.0     -to PI_test_mode/C
set_annotated_delay -cell -load_delay cell -max 3.0     -to PI_test_mode/C
set_annotated_transition 0.2 [get_pins PI_test_mode/C]


set_annotated_delay -cell -load_delay cell -min 1.0     -to U3/Y
set_annotated_delay -cell -load_delay cell -max 1.0     -to U3/Y
set_annotated_transition 0.2 [get_pins U3/Y]

set_annotated_delay -cell -load_delay cell -min 1.0     -to U4/Y
set_annotated_delay -cell -load_delay cell -max 1.0     -to U4/Y
set_annotated_transition 0.2 [get_pins U4/Y]

set_annotated_delay -cell -load_delay cell -min 1.0     -to U185/Y
set_annotated_delay -cell -load_delay cell -max 1.0     -to U185/Y
set_annotated_transition 0.2 [get_pins U185/Y]

set_annotated_delay -cell -load_delay cell -min 1.0     -to U30/Y
set_annotated_delay -cell -load_delay cell -max 1.0     -to U30/Y
set_annotated_transition 0.2 [get_pins U30/Y]

set_annotated_delay -cell -load_delay cell -min 1.0     -to U30/Y
set_annotated_delay -cell -load_delay cell -max 1.0     -to U30/Y
set_annotated_transition 0.2 [get_pins U30/Y]


report_constraint -verbose -max_transition -all_violators  > tran.rpt


current_design  rc8051RtlTop
write_sdf -context verilog -version 2.1 temp.sdf

sh pt_postprocessor.pl -s temp.sdf -o rc8051RtlTop.sdf
sh rm temp.sdf

quit
