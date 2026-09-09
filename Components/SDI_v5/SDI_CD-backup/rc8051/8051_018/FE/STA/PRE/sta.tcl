read_verilog /user/cklee/PRJ/8051_018/FE/SCAN/SCAN_DB/rc8051RtlTop_scan.v.out
current_design rc8051RtlTop
link
#################read_sdc###############################
read_sdc /user/cklee/PRJ/8051_018/FE/SYN/rc8051RtlTop.sdc_sta

current_design rc8051RtlTop

##################################################
#set_case_analysis       0   scan_en
#set_case_analysis       0   asic_test
set_case_analysis       0   BistMode
###################################################
#set_propagated_clock                  [all_clocks]
###################################################
# Set_False_Path
###################################################
#set timing_disable_clock_gating_checks true


#set_false_path -from                    TCK
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
write_sdc rc8051RtlTop_pre.sdc
exit
