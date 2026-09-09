read_db ./ELAB_DB/rc8051_elab.db
current_design DW_mult_pipe_a_width8_b_width8_num_stages5_stall_mode1_rst_mode1 //make black box mul
remove_design DW_mult_pipe_a_width8_b_width8_num_stages5_stall_mode1_rst_mode1  //erase black box mul 
read_db ./ELAB_DB/DW_mult_pipe_a_width8_b_width8_num_stages5_stall_mode1_rst_mode1.db // Synopsys dw mul

current_design rc8051RtlTop
link
#-------operation mode------------------------
set_operating_conditions  -max_library "slow" -max "slow" -min_library "fast" -min "fast" //max min libary use
set_wire_load_mode "enclosed" // get by virtual wire 
#-------clock define--------------------------
create_clock -name clk -p  20 -w [list 0 10 ] [get_ports {clk}] // 50MHz
set_dont_touch_network [all_clocks] 
set_dont_touch_network  rst_p

#-------constraints--------------------------
set_clock_latency 1.5 clk
set_clock_transition 0.5 clk
set_clock_uncertainty 0.3 clk
set_input_delay 1 -clock "clk" [remove_from_collection [all_inputs] [find port "rom*"]]
set_input_delay 10 -clock "clk" [find port "rom_data_i*"]

set_output_delay 1 -clock "clk" [all_outputs] // put 1ns delay
set_max_transition 1 [current_design]
#set_max_fanout 40 rc8051RtlTop

set_fix_multiple_port_nets -all
set_fix_multiple_port_nets -feedthroughs -constants -outputs -buffer_constants

#-------false path& dont use_0.13um----------------
#set_dont_use "slow/*XL"
#set_dont_use "fast/*XL"
#set_dont_use "slow/*DFFN*"
#set_dont_use "fast/*DFFN*"
########not use Cell_0.18um#######################
set_dont_use "slow/DFFN*"
set_dont_use "slow/CLK*"
set_dont_use "slow/JK*"
set_dont_use "slow/*XL" ;# don't use low power cells.
set_dont_use "slow/DLY*" ;# dont'use DLY cell, -> 2004.03.15.23:00 change

set_dont_use "fast/DFFN*"
set_dont_use "fast/CLK*"
set_dont_use "fast/JK*"
set_dont_use "fast/*XL" ;# don't use low power cells.
set_dont_use "fast/DLY*" ;# dont'use DLY cell, -> 2004.03.15.23:00 change
#because of its poor driving ability.
#set_dont_use "slow/CMPR*"
#set_dont_use "slow/ADD*"
#set_dont_use "slow/SD*"
set_dont_use "slow/*TL*"
##########################################



#-------insert pad & compile----------------
set_port_is_pad *
insert_pads

current_design rc8051RtlTop

compile -scan
source eliminate_backslash.tcl
source screener.tcl
tsmc_naming_rule


write -f verilog -hier -o ./SYN_DB/rc8051RtlTop_compile.v
write -f db -hier -o ./SYN_DB/rc8051RtlTop_compil.db
write_sdc rc8051RtlTop.sdc
exit
