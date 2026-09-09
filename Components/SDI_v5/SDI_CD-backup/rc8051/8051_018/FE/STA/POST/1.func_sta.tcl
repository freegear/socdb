read_verilog  /user/cklee/PRJ/8051_018/ToFE/0701/rc8051RtlTop.vv
current_design rc8051RtlTop
link

#################################################
#################Clock############################

set_operating_conditions -analysis_type bc_wc -max slow -min fast
#set_wire_load_mode "segmented"
##################read_sdc##############################
##read_sdc /prj6/sm1806/FE/SYN/NET_DB/epsc_top_acs.sdc
##################read_sdf##############################
##read_sdf -analysis_type bc_wc /prj6/sm1806/FE/SDF/PRE/epsc_top_pre.sdf
##################read_spf##############################
read_parasitics /user/cklee/PRJ/8051_018/ToFE/0701/rc8051RtlTop.spf > read_parasitics.rpt

current_design rc8051RtlTop
##################clock_drfine##########################
create_clock -name clk -p  20 -w [list 0 10 ] [get_ports {clk}]

##################input_delay########################
set_input_delay 1 -clock "clk" [remove_from_collection [all_inputs] [find port "rom*"]]
set_input_delay 1.5 -clock "clk" [find port "rom_data_i*"]

##################output_delay#######################
set_output_delay 1 -clock "clk" [all_outputs]


##################uncertainty########################
#set_clock_uncertainty 0.3 [all_clocks]
set_max_transition 1.0                  [current_design]
#set_max_fanout 8  [remove_from_collection [remove_from_collection [all_inputs] [find port "*clk*"]] [find port "*rst*"]]
#set_max_fanout 8  [current_design]

##################################################
set_case_analysis       0   scan_en
set_case_analysis       0   test_mode
set_case_analysis       0   BistMode
###################################################
set_propagated_clock                  [all_clocks]
###################################################
# Set_False_Path
###################################################
#set timing_disable_clock_gating_checks true


set_false_path -from                    scan_en
set_false_path -from                    BistMode
set_false_path -from                    test_mode
set_false_path -from                    rst_p

###add_false_path option#################################
################Report#############################
report_clock		                                                > ./report_func/sta_clock.rpt
report_case_analysis   			                                > ./report_func/sta_clocki_case.rpt
check_timing -verbose -no_clock        			                > ./report_func/sta_no_clock.rpt
report_constraint -verbose -max_delay -all_violators                    > ./report_func/sta_max_delay.rpt
report_constraint -verbose -min_delay -all_violators                    > ./report_func/sta_min_delay.rpt
report_constraint -verbose -min_pulse_width -all_violators              > ./report_func/sta_min_pulse_width0.rpt
report_constraint -verbose -recovery -all_violators                     > ./report_func/sta_recovery.rpt
report_constraint -verbose -removal -all_violators                      > ./report_func/sta_removal.rpt
report_reference                                                        > ./report_func/sta_reference.rpt
report_constraint -verbose -max_transition -all_violators               > ./report_func/sta_max_transition.rpt
report_constraint -verbose -max_fanout -all_violators                   > ./report_func/sta_max_fanout.rpt
report_analysis_coverage -status_details untested                       > ./report_func/report_analysis_coverage.rpt


#current_design rc8051RtlTop
#write_sdc rc8051RtlTop_pre.sdc
exit
