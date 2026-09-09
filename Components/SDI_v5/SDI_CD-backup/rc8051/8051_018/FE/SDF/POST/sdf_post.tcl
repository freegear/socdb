#############################################################################
# create directory for intermediate files
#############################################################################
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
read_parasitics  /user/cklee/PRJ/8051_018/ToFE/0701/rc8051RtlTop.spf

current_design  rc8051RtlTop
write_sdf -context verilog -version 2.1 temp.sdf

sh pt_postprocessor.pl -s temp.sdf -o rc8051RtlTop.sdf
sh rm temp.sdf

quit
