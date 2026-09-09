# Copyright (C) 1991-2006 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.

# Quartus II: Generate Tcl File for Project
# File: stratix1S10kit.tcl
# Generated on: Mon Aug 21 20:26:29 2006

# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "stratix1S10kit"]} {
		puts "Project stratix1S10kit is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists stratix1S10kit]} {
		project_open -revision manik2top stratix1S10kit
	} else {
		project_new -revision manik2top stratix1S10kit
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 5.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "10:15:44  AUGUST 04, 2005"
	set_global_assignment -name LAST_QUARTUS_VERSION 6.0
	set_global_assignment -name IGNORE_CLOCK_SETTINGS OFF
	set_global_assignment -name FMAX_REQUIREMENT "70 MHz"
	set_global_assignment -name MUX_RESTRUCTURE OFF
	set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "<None>"
	set_global_assignment -name FAMILY Stratix
	set_global_assignment -name DSP_BLOCK_BALANCING "SIMPLE 18-BIT MULTIPLIERS"
	set_global_assignment -name STRATIX_OPTIMIZATION_TECHNIQUE BALANCED
	set_global_assignment -name ADV_NETLIST_OPT_SYNTH_WYSIWYG_REMAP ON
	set_global_assignment -name ADV_NETLIST_OPT_SYNTH_GATE_RETIME ON
	set_global_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION ON
	set_global_assignment -name TOP_LEVEL_ENTITY manik_soc
	set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name AUTO_ENABLE_SMART_COMPILE ON
	set_global_assignment -name DEVICE EP1S10F780C6
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
	set_global_assignment -name RESERVE_DATA0_AFTER_CONFIGURATION "USE AS REGULAR IO"
	set_global_assignment -name RESERVE_ASDO_AFTER_CONFIGURATION "AS INPUT TRI-STATED"
	set_global_assignment -name OPTIMIZE_FAST_CORNER_TIMING ON
	set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
	set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
	set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
	set_global_assignment -name FITTER_EFFORT "FAST FIT"
	set_global_assignment -name PHYSICAL_SYNTHESIS_EFFORT EXTRA
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name EDA_SIMULATION_TOOL "<None>"
	set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_NO_OUTPUT_GND "AS INPUT TRI-STATED"
	set_global_assignment -name AUTO_RESTART_CONFIGURATION OFF
	set_global_assignment -name SIMULATION_MODE FUNCTIONAL
	set_global_assignment -name GLITCH_INTERVAL "1 ns"
	set_global_assignment -name ENABLE_DRC_SETTINGS ON
	set_global_assignment -name ENABLE_SIGNALTAP OFF
	set_global_assignment -name USE_SIGNALTAP_FILE "C:\\junk\\MANIK\\synth\\stratix1S10kit\\stp1.stp"
	set_global_assignment -name LOGICLOCK_INCREMENTAL_COMPILE_ASSIGNMENT OFF
	set_global_assignment -name DUTY_CYCLE 50 -section_id baud16_clk
	set_global_assignment -name DUTY_CYCLE 50 -section_id coreclk
	set_global_assignment -name FMAX_REQUIREMENT "70 MHz" -section_id coreclk
	set_global_assignment -name EDA_LMF_FILE synplcty.lmf -section_id eda_design_synthesis
	set_global_assignment -name EDA_INPUT_DATA_FORMAT EDIF -section_id eda_design_synthesis
	set_global_assignment -name EDA_RUN_TOOL_AUTOMATICALLY OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_INCLUDE_VHDL_CONFIGURATION_DECLARATION OFF -section_id eda_simulation
	set_global_assignment -name EDA_MAP_ILLEGAL_CHARACTERS OFF -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT NONE -section_id eda_simulation
	set_global_assignment -name EDA_TRUNCATE_LONG_HIERARCHY_PATHS OFF -section_id eda_simulation
	set_global_assignment -name EDA_MAINTAIN_DESIGN_HIERARCHY OFF -section_id eda_simulation
	set_global_assignment -name LL_ORIGIN LAB_X1_Y1 -section_id "EXunit:EXunit_1"
	set_global_assignment -name LL_HEIGHT 1 -section_id "EXunit:EXunit_1"
	set_global_assignment -name LL_WIDTH 1 -section_id "EXunit:EXunit_1"
	set_global_assignment -name LL_STATE FLOATING -section_id "EXunit:EXunit_1"
	set_global_assignment -name LL_AUTO_SIZE ON -section_id "EXunit:EXunit_1"
	set_global_assignment -name LL_RESERVED OFF -section_id "EXunit:EXunit_1"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "EXunit:EXunit_1"
	set_global_assignment -name LL_SOFT OFF -section_id "EXunit:EXunit_1"
	set_global_assignment -name LL_ORIGIN LAB_X1_Y1 -section_id "iagunit:iagunit_1"
	set_global_assignment -name LL_HEIGHT 1 -section_id "iagunit:iagunit_1"
	set_global_assignment -name LL_WIDTH 1 -section_id "iagunit:iagunit_1"
	set_global_assignment -name LL_STATE FLOATING -section_id "iagunit:iagunit_1"
	set_global_assignment -name LL_AUTO_SIZE ON -section_id "iagunit:iagunit_1"
	set_global_assignment -name LL_RESERVED OFF -section_id "iagunit:iagunit_1"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "iagunit:iagunit_1"
	set_global_assignment -name LL_SOFT OFF -section_id "iagunit:iagunit_1"
	set_global_assignment -name LL_ORIGIN LAB_X1_Y1 -section_id "lpm_mux:\\altera_tech2:TPC_MUX"
	set_global_assignment -name LL_HEIGHT 1 -section_id "lpm_mux:\\altera_tech2:TPC_MUX"
	set_global_assignment -name LL_WIDTH 1 -section_id "lpm_mux:\\altera_tech2:TPC_MUX"
	set_global_assignment -name LL_STATE FLOATING -section_id "lpm_mux:\\altera_tech2:TPC_MUX"
	set_global_assignment -name LL_AUTO_SIZE ON -section_id "lpm_mux:\\altera_tech2:TPC_MUX"
	set_global_assignment -name LL_RESERVED OFF -section_id "lpm_mux:\\altera_tech2:TPC_MUX"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "lpm_mux:\\altera_tech2:TPC_MUX"
	set_global_assignment -name LL_SOFT OFF -section_id "lpm_mux:\\altera_tech2:TPC_MUX"
	set_global_assignment -name LL_ORIGIN LAB_X1_Y1 -section_id "serial:serial_inst"
	set_global_assignment -name LL_HEIGHT 1 -section_id "serial:serial_inst"
	set_global_assignment -name LL_WIDTH 1 -section_id "serial:serial_inst"
	set_global_assignment -name LL_STATE FLOATING -section_id "serial:serial_inst"
	set_global_assignment -name LL_AUTO_SIZE ON -section_id "serial:serial_inst"
	set_global_assignment -name LL_RESERVED OFF -section_id "serial:serial_inst"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "serial:serial_inst"
	set_global_assignment -name LL_SOFT OFF -section_id "serial:serial_inst"
	set_global_assignment -name LL_ORIGIN LAB_X1_Y1 -section_id "ucache:ucache_1"
	set_global_assignment -name LL_HEIGHT 1 -section_id "ucache:ucache_1"
	set_global_assignment -name LL_WIDTH 1 -section_id "ucache:ucache_1"
	set_global_assignment -name LL_STATE FLOATING -section_id "ucache:ucache_1"
	set_global_assignment -name LL_AUTO_SIZE ON -section_id "ucache:ucache_1"
	set_global_assignment -name LL_RESERVED OFF -section_id "ucache:ucache_1"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "ucache:ucache_1"
	set_global_assignment -name LL_SOFT OFF -section_id "ucache:ucache_1"
	set_global_assignment -name LL_ROOT_REGION ON -section_id Root_region
	set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "Design Compiler FPGA" -entity addsub.vhd
	set_global_assignment -name EDA_INPUT_VCC_NAME VDD -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_LMF_FILE dc_fpga.lmf -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "<None>" -entity manikactel.vhd
	set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "Design Compiler FPGA" -entity manikpackage.vhd
	set_global_assignment -name EDA_INPUT_VCC_NAME VDD -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_LMF_FILE dc_fpga.lmf -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "<None>" -entity manikxilinx.vhd
	set_global_assignment -name HEX_FILE "../../gdb-stub/manik-stub.hex"
	set_global_assignment -name VHDL_FILE ../../manikremote/manikremote.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/cores/loader.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/socs/stratix1S10kit/manikconfig.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/cores/gdbstub.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/manikpackage.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/manikaltlib.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/manikaltera.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/manikxilinx.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/manikactel.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/cores/wbsdram.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/cores/gpio.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/cores/ocsyncram.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/cores/serial.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/cores/sram_core.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/cachemem.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/tfflagmod.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/ucache.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/tagmem.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/pipectrl.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/timer.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/addsub.vhd -library work
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/logicop.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/szextend.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/alu.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/aluopdecode.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/immdecode.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/alubsel.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/ifdeunit.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/regfile.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/rfunit.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/iagunit.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/intr.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/sfrs.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/shifter.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/multshift.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/wback.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/dbusmux.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/exunit.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/manik/manik2top.vhd
	set_global_assignment -name VHDL_FILE ../../vhdl/socs/stratix1S10kit/manik_soc.vhd
	set_global_assignment -name HEX_FILE regfileinit.hex
	set_global_assignment -name HEX_FILE zeroinit18.hex
	set_global_assignment -name HEX_FILE zeroinit2kx8.hex
	set_global_assignment -name HEX_FILE zeroinit4kx8.hex
	set_global_assignment -name HEX_FILE zeroinit16k.hex
	set_global_assignment -name SIGNALTAP_FILE "../../gdb-stub/stp1.stp"
	set_global_assignment -name HEX_FILE zeroinit8k.hex
	set_global_assignment -name HEX_FILE zeroinit4kx32.hex
	set_global_assignment -name HEX_FILE zeroinit1kx18.hex
	set_global_assignment -name SIGNALTAP_FILE stp1.stp
	set_global_assignment -name FMAX_REQUIREMENT "1 MHz" -section_id baud16_clk
	set_location_assignment PIN_K17 -to clk_i
	set_location_assignment PIN_AC9 -to reset_i
	set_location_assignment PIN_Y28 -to rxpin
	set_location_assignment PIN_U21 -to txpin
	set_location_assignment PIN_H27 -to seg_led[0]
	set_location_assignment PIN_H28 -to seg_led[1]
	set_location_assignment PIN_L23 -to seg_led[2]
	set_location_assignment PIN_L24 -to seg_led[3]
	set_location_assignment PIN_J25 -to seg_led[4]
	set_location_assignment PIN_J26 -to seg_led[5]
	set_location_assignment PIN_L20 -to seg_led[6]
	set_location_assignment PIN_L19 -to seg_led[7]
	set_location_assignment PIN_B3 -to sram_addr[0]
	set_location_assignment PIN_B5 -to sram_addr[1]
	set_location_assignment PIN_B4 -to sram_addr[2]
	set_location_assignment PIN_C4 -to sram_addr[3]
	set_location_assignment PIN_A5 -to sram_addr[4]
	set_location_assignment PIN_C5 -to sram_addr[5]
	set_location_assignment PIN_D5 -to sram_addr[6]
	set_location_assignment PIN_E6 -to sram_addr[7]
	set_location_assignment PIN_A6 -to sram_addr[8]
	set_location_assignment PIN_B7 -to sram_addr[9]
	set_location_assignment PIN_D6 -to sram_addr[10]
	set_location_assignment PIN_A7 -to sram_addr[11]
	set_location_assignment PIN_D7 -to sram_addr[12]
	set_location_assignment PIN_C6 -to sram_addr[13]
	set_location_assignment PIN_C7 -to sram_addr[14]
	set_location_assignment PIN_B6 -to sram_addr[15]
	set_location_assignment PIN_D8 -to sram_addr[16]
	set_location_assignment PIN_C8 -to sram_addr[17]
	set_location_assignment PIN_H12 -to sram_data[0]
	set_location_assignment PIN_F12 -to sram_data[1]
	set_location_assignment PIN_J12 -to sram_data[2]
	set_location_assignment PIN_M12 -to sram_data[3]
	set_location_assignment PIN_H17 -to sram_data[4]
	set_location_assignment PIN_K18 -to sram_data[5]
	set_location_assignment PIN_H18 -to sram_data[6]
	set_location_assignment PIN_G18 -to sram_data[7]
	set_location_assignment PIN_B8 -to sram_data[8]
	set_location_assignment PIN_A8 -to sram_data[9]
	set_location_assignment PIN_A9 -to sram_data[10]
	set_location_assignment PIN_C9 -to sram_data[11]
	set_location_assignment PIN_E10 -to sram_data[12]
	set_location_assignment PIN_A10 -to sram_data[13]
	set_location_assignment PIN_C10 -to sram_data[14]
	set_location_assignment PIN_B10 -to sram_data[15]
	set_location_assignment PIN_A11 -to sram_data[16]
	set_location_assignment PIN_C11 -to sram_data[17]
	set_location_assignment PIN_D11 -to sram_data[18]
	set_location_assignment PIN_B11 -to sram_data[19]
	set_location_assignment PIN_D10 -to sram_data[20]
	set_location_assignment PIN_G10 -to sram_data[21]
	set_location_assignment PIN_F10 -to sram_data[22]
	set_location_assignment PIN_H11 -to sram_data[23]
	set_location_assignment PIN_G11 -to sram_data[24]
	set_location_assignment PIN_F8 -to sram_data[25]
	set_location_assignment PIN_J9 -to sram_data[26]
	set_location_assignment PIN_J13 -to sram_data[27]
	set_location_assignment PIN_L13 -to sram_data[28]
	set_location_assignment PIN_M11 -to sram_data[29]
	set_location_assignment PIN_L11 -to sram_data[30]
	set_location_assignment PIN_G7 -to sram_data[31]
	set_location_assignment PIN_M18 -to sram_benN[0]
	set_location_assignment PIN_F17 -to sram_benN[1]
	set_location_assignment PIN_J18 -to sram_benN[2]
	set_location_assignment PIN_L17 -to sram_benN[3]
	set_location_assignment PIN_B24 -to sram_csn[0]
	set_location_assignment PIN_B26 -to sram_oen
	set_location_assignment PIN_C24 -to sram_wen
	set_location_assignment PIN_AE4 -to sdram_addr[0]
	set_location_assignment PIN_W12 -to sdram_addr[1]
	set_location_assignment PIN_AC11 -to sdram_addr[2]
	set_location_assignment PIN_W10 -to sdram_addr[3]
	set_location_assignment PIN_AA11 -to sdram_addr[4]
	set_location_assignment PIN_AC10 -to sdram_addr[5]
	set_location_assignment PIN_AB11 -to sdram_addr[6]
	set_location_assignment PIN_AC8 -to sdram_addr[7]
	set_location_assignment PIN_AB10 -to sdram_addr[8]
	set_location_assignment PIN_V11 -to sdram_addr[9]
	set_location_assignment PIN_Y11 -to sdram_addr[10]
	set_location_assignment PIN_AB7 -to sdram_addr[11]
	set_location_assignment PIN_AG19 -to sdram_ba[0]
	set_location_assignment PIN_AF19 -to sdram_ba[1]
	set_location_assignment PIN_AD18 -to sdram_casN
	set_location_assignment PIN_AE18 -to sdram_cke[0]
	set_location_assignment PIN_AG18 -to sdram_csn[0]
	set_location_assignment PIN_AH4 -to sdram_data[0]
	set_location_assignment PIN_AE5 -to sdram_data[1]
	set_location_assignment PIN_AG3 -to sdram_data[2]
	set_location_assignment PIN_AG5 -to sdram_data[3]
	set_location_assignment PIN_AG4 -to sdram_data[4]
	set_location_assignment PIN_AF4 -to sdram_data[5]
	set_location_assignment PIN_AH5 -to sdram_data[6]
	set_location_assignment PIN_AF5 -to sdram_data[7]
	set_location_assignment PIN_AE6 -to sdram_data[8]
	set_location_assignment PIN_AG6 -to sdram_data[9]
	set_location_assignment PIN_AH6 -to sdram_data[10]
	set_location_assignment PIN_AD6 -to sdram_data[11]
	set_location_assignment PIN_AF7 -to sdram_data[12]
	set_location_assignment PIN_AH7 -to sdram_data[13]
	set_location_assignment PIN_AG7 -to sdram_data[14]
	set_location_assignment PIN_AF6 -to sdram_data[15]
	set_location_assignment PIN_AG8 -to sdram_data[16]
	set_location_assignment PIN_AF8 -to sdram_data[17]
	set_location_assignment PIN_AD8 -to sdram_data[18]
	set_location_assignment PIN_AH9 -to sdram_data[19]
	set_location_assignment PIN_AH8 -to sdram_data[20]
	set_location_assignment PIN_AE9 -to sdram_data[21]
	set_location_assignment PIN_AF9 -to sdram_data[22]
	set_location_assignment PIN_AG9 -to sdram_data[23]
	set_location_assignment PIN_AD10 -to sdram_data[24]
	set_location_assignment PIN_AF10 -to sdram_data[25]
	set_location_assignment PIN_AH10 -to sdram_data[26]
	set_location_assignment PIN_AE10 -to sdram_data[27]
	set_location_assignment PIN_AF11 -to sdram_data[28]
	set_location_assignment PIN_AE11 -to sdram_data[29]
	set_location_assignment PIN_AH11 -to sdram_data[30]
	set_location_assignment PIN_AG11 -to sdram_data[31]
	set_location_assignment PIN_AE14 -to sdram_dqm[0]
	set_location_assignment PIN_Y13 -to sdram_dqm[1]
	set_location_assignment PIN_AE7 -to sdram_dqm[2]
	set_location_assignment PIN_AG10 -to sdram_dqm[3]
	set_location_assignment PIN_AH3 -to sdram_rasN
	set_location_assignment PIN_AH19 -to sdram_wen
	set_location_assignment PIN_E15 -to sdram_clk
	set_instance_assignment -name CLOCK_SETTINGS coreclk -to "manik2top:manik|coreclk"
	set_instance_assignment -name CLOCK_SETTINGS baud16_clk -to "serial:serial_inst|baudx16_clk"
	set_instance_assignment -name LL_MEMBER_OF "EXunit:EXunit_1" -to "manik2top:manik|EXunit:EXunit_1" -section_id "EXunit:EXunit_1"
	set_instance_assignment -name LL_MEMBER_OF "iagunit:iagunit_1" -to "manik2top:manik|iagunit:iagunit_1" -section_id "iagunit:iagunit_1"
	set_instance_assignment -name LL_MEMBER_OF "lpm_mux:\\altera_tech2:TPC_MUX" -to "manik2top:manik|iagunit:iagunit_1|lpm_mux:\\altera_tech2:TPC_MUX" -section_id "lpm_mux:\\altera_tech2:TPC_MUX"
	set_instance_assignment -name LL_MEMBER_OF "serial:serial_inst" -to "serial:serial_inst" -section_id "serial:serial_inst"
	set_instance_assignment -name LL_MEMBER_OF "ucache:ucache_1" -to "manik2top:manik|ucache:ucache_1" -section_id "ucache:ucache_1"
	set_instance_assignment -name LL_MEMBER_OF Root_region -to "manik2top:manik|iagunit:iagunit_1|lpm_mux:\\altera_tech2:TPC_MUX|mux_7ud:auto_generated" -section_id Root_region

	# Including default assignments
	set_global_assignment -name EQC_BBOX_MERGE ON
	set_global_assignment -name EQC_LVDS_MERGE ON
	set_global_assignment -name EQC_RAM_UNMERGING ON
	set_global_assignment -name EQC_DFF_SS_EMULATION ON
	set_global_assignment -name EQC_IO_BUFFER_CONVERSION ON
	set_global_assignment -name EQC_RAM_REGISTER_UNPACK ON
	set_global_assignment -name EQC_MAC_REGISTER_UNPACK ON
	set_global_assignment -name EQC_SET_PARTITION_BB_TO_VCC_GND ON
	set_global_assignment -name EQC_STRUCTURE_MATCHING ON
	set_global_assignment -name EQC_AUTO_BREAK_CONE ON
	set_global_assignment -name EQC_POWER_UP_COMPARE OFF
	set_global_assignment -name EQC_AUTO_COMP_LOOP_CUT ON
	set_global_assignment -name EQC_AUTO_INVERSION ON
	set_global_assignment -name EQC_AUTO_TERMINATE ON
	set_global_assignment -name EQC_SUB_CONE_REPORT OFF
	set_global_assignment -name EQC_RENAMING_RULES ON
	set_global_assignment -name EQC_PARAMETER_CHECK ON
	set_global_assignment -name EQC_AUTO_PORTSWAP ON
	set_global_assignment -name EQC_DETECT_DONT_CARES ON
	set_global_assignment -name NUMBER_OF_SOURCES_PER_DESTINATION_TO_REPORT 10
	set_global_assignment -name NUMBER_OF_DESTINATION_TO_REPORT 10
	set_global_assignment -name NUMBER_OF_PATHS_TO_REPORT 200
	set_global_assignment -name DO_MIN_ANALYSIS OFF
	set_global_assignment -name DO_MIN_TIMING OFF
	set_global_assignment -name REPORT_IO_PATHS_SEPARATELY OFF
	set_global_assignment -name CLOCK_ANALYSIS_ONLY OFF
	set_global_assignment -name FLOW_ENABLE_TIMING_CONSTRAINT_CHECK OFF
	set_global_assignment -name DEFAULT_HOLD_MULTICYCLE "SAME AS MULTICYCLE"
	set_global_assignment -name CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS ON
	set_global_assignment -name CUT_OFF_READ_DURING_WRITE_PATHS ON
	set_global_assignment -name CUT_OFF_CLEAR_AND_PRESET_PATHS ON
	set_global_assignment -name CUT_OFF_IO_PIN_FEEDBACK ON
	set_global_assignment -name DO_COMBINED_ANALYSIS OFF
	set_global_assignment -name ANALYZE_LATCHES_AS_SYNCHRONOUS_ELEMENTS OFF
	set_global_assignment -name DO_MINMAX_ANALYSIS_USING_RISEFALL_DELAYS OFF
	set_global_assignment -name ENABLE_RECOVERY_REMOVAL_ANALYSIS OFF
	set_global_assignment -name ENABLE_CLOCK_LATENCY OFF
	set_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER OFF
	set_global_assignment -name START_TIME "0 ns"
	set_global_assignment -name AUTO_USE_SIMULATION_PDB_NETLIST OFF
	set_global_assignment -name ADD_DEFAULT_PINS_TO_SIMULATION_OUTPUT_WAVEFORMS ON
	set_global_assignment -name SETUP_HOLD_DETECTION OFF
	set_global_assignment -name SETUP_HOLD_DETECTION_INPUT_REGISTERS_BIDIR_PINS_DISABLED OFF
	set_global_assignment -name CHECK_OUTPUTS OFF
	set_global_assignment -name SIMULATION_COVERAGE ON
	set_global_assignment -name SIMULATION_COMPLETE_COVERAGE_REPORT_PANEL ON
	set_global_assignment -name SIMULATION_MISSING_1_VALUE_COVERAGE_REPORT_PANEL ON
	set_global_assignment -name SIMULATION_MISSING_0_VALUE_COVERAGE_REPORT_PANEL ON
	set_global_assignment -name GLITCH_DETECTION OFF
	set_global_assignment -name SIM_NO_DELAYS OFF
	set_global_assignment -name SIMULATOR_GENERATE_SIGNAL_ACTIVITY_FILE OFF
	set_global_assignment -name SIMULATION_WITH_GLITCH_FILTERING_WHEN_GENERATING_SAF ON
	set_global_assignment -name SIMULATION_BUS_CHANNEL_GROUPING OFF
	set_global_assignment -name SIMULATION_VDB_RESULT_FLUSH ON
	set_global_assignment -name VECTOR_COMPARE_TRIGGER_MODE INPUT_EDGE
	set_global_assignment -name SIMULATION_NETLIST_VIEWER OFF
	set_global_assignment -name SIMULATION_WITH_GLITCH_FILTERING_IN_NORMAL_FLOW OFF
	set_global_assignment -name HUB_ENTITY_NAME sld_hub
	set_global_assignment -name HUB_INSTANCE_NAME sld_hub_inst
	set_global_assignment -name SIGNALPROBE_ALLOW_OVERUSE OFF
	set_global_assignment -name SIGNALPROBE_DURING_NORMAL_COMPILATION OFF
	set_global_assignment -name PROJECT_SHOW_ENTITY_NAME ON
	set_global_assignment -name VER_COMPATIBLE_DB_DIR export_db
	set_global_assignment -name AUTO_EXPORT_VER_COMPATIBLE_DB OFF
	set_global_assignment -name SMART_RECOMPILE OFF
	set_global_assignment -name FLOW_DISABLE_ASSEMBLER OFF
	set_global_assignment -name FLOW_ENABLE_HCII_COMPARE OFF
	set_global_assignment -name HCII_OUTPUT_DIR hc_output
	set_global_assignment -name SAVE_MIGRATION_INFO_DURING_COMPILATION OFF
	set_global_assignment -name FLOW_ENABLE_IO_ASSIGNMENT_ANALYSIS OFF
	set_global_assignment -name RUN_FULL_COMPILE_ON_DEVICE_CHANGE ON
	set_global_assignment -name MAX_PROCESSORS_USED_FOR_MULTITHREADING 1
	set_global_assignment -name MERGE_HEX_FILE OFF
	set_global_assignment -name GENERATE_SVF_FILE OFF
	set_global_assignment -name GENERATE_ISC_FILE OFF
	set_global_assignment -name GENERATE_JAM_FILE OFF
	set_global_assignment -name GENERATE_JBC_FILE OFF
	set_global_assignment -name GENERATE_JBC_FILE_COMPRESSED ON
	set_global_assignment -name GENERATE_CONFIG_SVF_FILE OFF
	set_global_assignment -name GENERATE_CONFIG_ISC_FILE OFF
	set_global_assignment -name GENERATE_CONFIG_JAM_FILE OFF
	set_global_assignment -name GENERATE_CONFIG_JBC_FILE OFF
	set_global_assignment -name GENERATE_CONFIG_JBC_FILE_COMPRESSED ON
	set_global_assignment -name GENERATE_CONFIG_HEXOUT_FILE OFF
	set_global_assignment -name ISP_CLAMP_STATE_DEFAULT "TRI-STATE"
	set_global_assignment -name POWER_DEFAULT_TOGGLE_RATE 12.5%
	set_global_assignment -name POWER_DEFAULT_INPUT_IO_TOGGLE_RATE 12.5%
	set_global_assignment -name POWER_USE_PVA ON
	set_global_assignment -name POWER_USE_INPUT_FILE "NO FILE"
	set_global_assignment -name POWER_USE_INPUT_FILES OFF
	set_global_assignment -name POWER_VCD_FILTER_GLITCHES ON
	set_global_assignment -name POWER_REPORT_SIGNAL_ACTIVITY ON
	set_global_assignment -name POWER_REPORT_POWER_DISSIPATION ON
	set_global_assignment -name POWER_USE_DEVICE_CHARACTERISTICS TYPICAL
	set_global_assignment -name POWER_USE_VOLTAGE NOMINAL
	set_global_assignment -name POWER_AUTO_COMPUTE_TJ ON
	set_global_assignment -name POWER_TJ_VALUE 25
	set_global_assignment -name POWER_USE_TA_VALUE 25
	set_global_assignment -name POWER_USE_CUSTOM_COOLING_SOLUTION OFF
	set_global_assignment -name POWER_BOARD_TEMPERATURE 25
	set_global_assignment -name EDA_TIMING_ANALYSIS_TOOL "<None>"
	set_global_assignment -name EDA_BOARD_DESIGN_TIMING_TOOL "<None>"
	set_global_assignment -name EDA_BOARD_DESIGN_SYMBOL_TOOL "<None>"
	set_global_assignment -name EDA_BOARD_DESIGN_SIGNAL_INTEGRITY_TOOL "<None>"
	set_global_assignment -name EDA_BOARD_DESIGN_TOOL "<None>"
	set_global_assignment -name EDA_FORMAL_VERIFICATION_TOOL "<None>"
	set_global_assignment -name EDA_RESYNTHESIS_TOOL "<None>"
	set_global_assignment -name EDA_SIMULATION_VCD_OUTPUT_TCL_FILE OFF
	set_global_assignment -name EDA_SIMULATION_VCD_OUTPUT_SIGNALS_TO_TCL_FILE "ALL EXCEPT COMBINATIONAL LOGIC ELEMENT OUTPUTS"
	set_global_assignment -name ENABLE_IP_DEBUG OFF
	set_global_assignment -name SAVE_DISK_SPACE ON
	set_global_assignment -name DISABLE_OCP_HW_EVAL OFF
	set_global_assignment -name DEVICE_FILTER_PACKAGE ANY
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT ANY
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE ANY
	set_global_assignment -name VERILOG_INPUT_VERSION VERILOG_2001
	set_global_assignment -name VHDL_INPUT_VERSION VHDL93
	set_global_assignment -name COMPILATION_LEVEL FULL
	set_global_assignment -name TRUE_WYSIWYG_FLOW OFF
	set_global_assignment -name SMART_COMPILE_IGNORES_TDC_FOR_STRATIX_PLL_CHANGES OFF
	set_global_assignment -name STATE_MACHINE_PROCESSING AUTO
	set_global_assignment -name EXTRACT_VERILOG_STATE_MACHINES ON
	set_global_assignment -name EXTRACT_VHDL_STATE_MACHINES ON
	set_global_assignment -name ADD_PASS_THROUGH_LOGIC_TO_INFERRED_RAMS ON
	set_global_assignment -name MAX_BALANCING_DSP_BLOCKS "-1"
	set_global_assignment -name NOT_GATE_PUSH_BACK ON
	set_global_assignment -name ALLOW_POWER_UP_DONT_CARE ON
	set_global_assignment -name REMOVE_REDUNDANT_LOGIC_CELLS OFF
	set_global_assignment -name REMOVE_DUPLICATE_REGISTERS ON
	set_global_assignment -name IGNORE_CARRY_BUFFERS OFF
	set_global_assignment -name IGNORE_CASCADE_BUFFERS OFF
	set_global_assignment -name IGNORE_GLOBAL_BUFFERS OFF
	set_global_assignment -name IGNORE_ROW_GLOBAL_BUFFERS OFF
	set_global_assignment -name IGNORE_LCELL_BUFFERS OFF
	set_global_assignment -name MAX7000_IGNORE_LCELL_BUFFERS AUTO
	set_global_assignment -name IGNORE_SOFT_BUFFERS ON
	set_global_assignment -name MAX7000_IGNORE_SOFT_BUFFERS OFF
	set_global_assignment -name LIMIT_AHDL_INTEGERS_TO_32_BITS OFF
	set_global_assignment -name AUTO_GLOBAL_CLOCK_MAX ON
	set_global_assignment -name AUTO_GLOBAL_OE_MAX ON
	set_global_assignment -name MAX_AUTO_GLOBAL_REGISTER_CONTROLS ON
	set_global_assignment -name AUTO_IMPLEMENT_IN_ROM OFF
	set_global_assignment -name STRATIX_TECHNOLOGY_MAPPER LUT
	set_global_assignment -name MAX7000_TECHNOLOGY_MAPPER "PRODUCT TERM"
	set_global_assignment -name APEX20K_TECHNOLOGY_MAPPER LUT
	set_global_assignment -name MERCURY_TECHNOLOGY_MAPPER LUT
	set_global_assignment -name FLEX6K_TECHNOLOGY_MAPPER LUT
	set_global_assignment -name FLEX10K_TECHNOLOGY_MAPPER LUT
	set_global_assignment -name STRATIXII_OPTIMIZATION_TECHNIQUE BALANCED
	set_global_assignment -name CYCLONE_OPTIMIZATION_TECHNIQUE BALANCED
	set_global_assignment -name CYCLONEII_OPTIMIZATION_TECHNIQUE BALANCED
	set_global_assignment -name MAXII_OPTIMIZATION_TECHNIQUE BALANCED
	set_global_assignment -name MAX7000_OPTIMIZATION_TECHNIQUE SPEED
	set_global_assignment -name APEX20K_OPTIMIZATION_TECHNIQUE BALANCED
	set_global_assignment -name MERCURY_OPTIMIZATION_TECHNIQUE AREA
	set_global_assignment -name FLEX6K_OPTIMIZATION_TECHNIQUE AREA
	set_global_assignment -name FLEX10K_OPTIMIZATION_TECHNIQUE AREA
	set_global_assignment -name ALLOW_XOR_GATE_USAGE ON
	set_global_assignment -name AUTO_LCELL_INSERTION ON
	set_global_assignment -name CARRY_CHAIN_LENGTH 48
	set_global_assignment -name FLEX6K_CARRY_CHAIN_LENGTH 32
	set_global_assignment -name FLEX10K_CARRY_CHAIN_LENGTH 32
	set_global_assignment -name MERCURY_CARRY_CHAIN_LENGTH 48
	set_global_assignment -name STRATIX_CARRY_CHAIN_LENGTH 70
	set_global_assignment -name STRATIXII_CARRY_CHAIN_LENGTH 70
	set_global_assignment -name CASCADE_CHAIN_LENGTH 2
	set_global_assignment -name PARALLEL_EXPANDER_CHAIN_LENGTH 16
	set_global_assignment -name MAX7000_PARALLEL_EXPANDER_CHAIN_LENGTH 4
	set_global_assignment -name AUTO_CARRY_CHAINS ON
	set_global_assignment -name AUTO_CASCADE_CHAINS ON
	set_global_assignment -name AUTO_PARALLEL_EXPANDERS ON
	set_global_assignment -name AUTO_OPEN_DRAIN_PINS ON
	set_global_assignment -name REMOVE_DUPLICATE_LOGIC ON
	set_global_assignment -name ADV_NETLIST_OPT_RETIME_CORE_AND_IO ON
	set_global_assignment -name AUTO_ROM_RECOGNITION ON
	set_global_assignment -name AUTO_RAM_RECOGNITION ON
	set_global_assignment -name AUTO_DSP_RECOGNITION ON
	set_global_assignment -name AUTO_CLOCK_ENABLE_RECOGNITION ON
	set_global_assignment -name STRICT_RAM_RECOGNITION OFF
	set_global_assignment -name ALLOW_SYNCH_CTRL_USAGE ON
	set_global_assignment -name FORCE_SYNCH_CLEAR OFF
	set_global_assignment -name DONT_TOUCH_USER_CELL OFF
	set_global_assignment -name AUTO_RAM_BLOCK_BALANCING ON
	set_global_assignment -name IP_SHOW_ANALYSIS_MESSAGES OFF
	set_global_assignment -name AUTO_RESOURCE_SHARING OFF
	set_global_assignment -name USE_NEW_TEXT_REPORT_TABLE_FORMAT OFF
	set_global_assignment -name ALLOW_ANY_RAM_SIZE_FOR_RECOGNITION OFF
	set_global_assignment -name ALLOW_ANY_ROM_SIZE_FOR_RECOGNITION OFF
	set_global_assignment -name ALLOW_ANY_SHIFT_REGISTER_SIZE_FOR_RECOGNITION OFF
	set_global_assignment -name MAX7000_FANIN_PER_CELL 100
	set_global_assignment -name IGNORE_DUPLICATE_DESIGN_ENTITY OFF
	set_global_assignment -name MAX_RAM_BLOCKS_M512 "-1"
	set_global_assignment -name MAX_RAM_BLOCKS_M4K "-1"
	set_global_assignment -name MAX_RAM_BLOCKS_MRAM "-1"
	set_global_assignment -name IGNORE_TRANSLATE_OFF OFF
	set_global_assignment -name STRATIXGX_BYPASS_REMAPPING_OF_FORCE_SIGNAL_DETECT_SIGNAL_THRESHOLD_SELECT OFF
	set_global_assignment -name SYNTH_TIMING_DRIVEN_REGISTER_DUPLICATION OFF
	set_global_assignment -name SYNTH_TIMING_DRIVEN_BALANCED_MAPPING OFF
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS OFF
	set_global_assignment -name SHOW_PARAMETER_SETTINGS_TABLES_IN_SYNTHESIS_REPORT ON
	set_global_assignment -name IGNORE_MAX_FANOUT_ASSIGNMENTS OFF
	set_global_assignment -name ADV_NETLIST_OPT_METASTABLE_REGS 2
	set_global_assignment -name OPTIMIZE_POWER_DURING_SYNTHESIS "NORMAL COMPILATION"
	set_global_assignment -name HDL_MESSAGE_LEVEL LEVEL2
	set_global_assignment -name INCREMENTAL_COMPILATION OFF
	set_global_assignment -name AUTO_EXPORT_INCREMENTAL_COMPILATION OFF
	set_global_assignment -name INCREMENTAL_COMPILATION_EXPORT_NETLIST_TYPE POST_FIT
	set_global_assignment -name INCREMENTAL_COMPILATION_EXPORT_ROUTING OFF
	set_global_assignment -name ROUTER_TIMING_OPTIMIZATION_LEVEL NORMAL
	set_global_assignment -name PLACEMENT_EFFORT_MULTIPLIER 1.0
	set_global_assignment -name ROUTER_EFFORT_MULTIPLIER 1.0
	set_global_assignment -name ECO_ALLOW_ROUTING_CHANGES OFF
	set_global_assignment -name BASE_PIN_OUT_FILE_ON_SAMEFRAME_DEVICE OFF
	set_global_assignment -name ENABLE_JTAG_BST_SUPPORT OFF
	set_global_assignment -name MAX7000_ENABLE_JTAG_BST_SUPPORT ON
	set_global_assignment -name RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
	set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS PROGRAMMING PIN"
	set_global_assignment -name STRATIX_UPDATE_MODE STANDARD
	set_global_assignment -name STRATIXII_CONFIGURATION_SCHEME "PASSIVE SERIAL"
	set_global_assignment -name CYCLONEII_CONFIGURATION_SCHEME "ACTIVE SERIAL"
	set_global_assignment -name APEX20K_CONFIGURATION_SCHEME "PASSIVE SERIAL"
	set_global_assignment -name STRATIX_CONFIGURATION_SCHEME "PASSIVE SERIAL"
	set_global_assignment -name CYCLONE_CONFIGURATION_SCHEME "ACTIVE SERIAL"
	set_global_assignment -name MERCURY_CONFIGURATION_SCHEME "PASSIVE SERIAL"
	set_global_assignment -name FLEX6K_CONFIGURATION_SCHEME "PASSIVE SERIAL"
	set_global_assignment -name FLEX10K_CONFIGURATION_SCHEME "PASSIVE SERIAL"
	set_global_assignment -name APEXII_CONFIGURATION_SCHEME "PASSIVE SERIAL"
	set_global_assignment -name USER_START_UP_CLOCK OFF
	set_global_assignment -name ENABLE_VREFA_PIN OFF
	set_global_assignment -name ENABLE_VREFB_PIN OFF
	set_global_assignment -name ENABLE_DEVICE_WIDE_RESET OFF
	set_global_assignment -name ENABLE_DEVICE_WIDE_OE OFF
	set_global_assignment -name FLEX10K_ENABLE_LOCK_OUTPUT OFF
	set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF
	set_global_assignment -name RESERVE_NWS_NRS_NCS_CS_AFTER_CONFIGURATION "USE AS REGULAR IO"
	set_global_assignment -name RESERVE_RDYNBUSY_AFTER_CONFIGURATION "USE AS REGULAR IO"
	set_global_assignment -name RESERVE_DATA7_THROUGH_DATA1_AFTER_CONFIGURATION "USE AS REGULAR IO"
	set_global_assignment -name CRC_ERROR_CHECKING OFF
	set_global_assignment -name OPTIMIZE_HOLD_TIMING "IO PATHS AND MINIMUM TPD PATHS"
	set_global_assignment -name GUARANTEE_MIN_DELAY_CORNER_IO_ZERO_HOLD_TIME ON
	set_global_assignment -name OPTIMIZE_POWER_DURING_FITTING "NORMAL COMPILATION"
	set_global_assignment -name OPTIMIZE_TIMING "NORMAL COMPILATION"
	set_global_assignment -name OPTIMIZE_IOC_REGISTER_PLACEMENT_FOR_TIMING ON
	set_global_assignment -name DISABLE_PLL_COMPENSATION_DELAY_CHANGE_WARNING OFF
	set_global_assignment -name FIT_ONLY_ONE_ATTEMPT OFF
	set_global_assignment -name FINAL_PLACEMENT_OPTIMIZATION AUTOMATICALLY
	set_global_assignment -name FITTER_AGGRESSIVE_ROUTABILITY_OPTIMIZATION AUTOMATICALLY
	set_global_assignment -name SEED 1
	set_global_assignment -name SLOW_SLEW_RATE OFF
	set_global_assignment -name PCI_IO OFF
	set_global_assignment -name TURBO_BIT ON
	set_global_assignment -name WEAK_PULL_UP_RESISTOR OFF
	set_global_assignment -name ENABLE_BUS_HOLD_CIRCUITRY OFF
	set_global_assignment -name AUTO_GLOBAL_MEMORY_CONTROLS OFF
	set_global_assignment -name MIGRATION_CONSTRAIN_CORE_RESOURCES ON
	set_global_assignment -name AUTO_PACKED_REGISTERS_STRATIXII AUTO
	set_global_assignment -name AUTO_PACKED_REGISTERS_MAXII AUTO
	set_global_assignment -name AUTO_PACKED_REGISTERS_CYCLONE AUTO
	set_global_assignment -name AUTO_PACKED_REGISTERS OFF
	set_global_assignment -name AUTO_PACKED_REGISTERS_STRATIX AUTO
	set_global_assignment -name NORMAL_LCELL_INSERT ON
	set_global_assignment -name CARRY_OUT_PINS_LCELL_INSERT ON
	set_global_assignment -name AUTO_DELAY_CHAINS ON
	set_global_assignment -name AUTO_FAST_INPUT_REGISTERS OFF
	set_global_assignment -name AUTO_FAST_OUTPUT_REGISTERS OFF
	set_global_assignment -name AUTO_FAST_OUTPUT_ENABLE_REGISTERS OFF
	set_global_assignment -name AUTO_MERGE_PLLS ON
	set_global_assignment -name IGNORE_MODE_FOR_MERGE OFF
	set_global_assignment -name AUTO_TURBO_BIT ON
	set_global_assignment -name PHYSICAL_SYNTHESIS_LOG_FILE OFF
	set_global_assignment -name PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING OFF
	set_global_assignment -name IO_PLACEMENT_OPTIMIZATION ON
	set_global_assignment -name ALLOW_LVTTL_LVCMOS_INPUT_LEVELS_TO_OVERDRIVE_INPUT_BUFFER OFF
	set_global_assignment -name OVERRIDE_DEFAULT_ELECTROMIGRATION_PARAMETERS OFF
	set_global_assignment -name FITTER_AUTO_EFFORT_DESIRED_SLACK_MARGIN "0 ns"
	set_global_assignment -name ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION AUTO
	set_global_assignment -name ROUTER_REGISTER_DUPLICATION OFF
	set_global_assignment -name ALLOW_SERIES_TERMINATION OFF
	set_global_assignment -name ALLOW_SERIES_WITH_CALIBRATION_TERMINATION OFF
	set_global_assignment -name ALLOW_PARALLEL_TERMINATION OFF
	set_global_assignment -name STRATIXGX_ALLOW_CLOCK_FANOUT_WITH_ANALOG_RESET OFF
	set_global_assignment -name AUTO_GLOBAL_CLOCK ON
	set_global_assignment -name AUTO_GLOBAL_OE ON
	set_global_assignment -name AUTO_GLOBAL_REGISTER_CONTROLS ON
	set_global_assignment -name FITTER_EARLY_TIMING_ESTIMATE_MODE REALISTIC
	set_global_assignment -name STRATIXGX_ALLOW_GIGE_UNDER_FULL_DATARATE_RANGE OFF
	set_global_assignment -name STRATIXGX_ALLOW_RX_CORECLK_FROM_NON_RX_CLKOUT_SOURCE_IN_DOUBLE_DATA_WIDTH_MODE OFF
	set_global_assignment -name STRATIXGX_ALLOW_GIGE_IN_DOUBLE_DATA_WIDTH_MODE OFF
	set_global_assignment -name STRATIXGX_ALLOW_PARALLEL_LOOPBACK_IN_DOUBLE_DATA_WIDTH_MODE OFF
	set_global_assignment -name STRATIXGX_ALLOW_XAUI_IN_SINGLE_DATA_WIDTH_MODE OFF
	set_global_assignment -name STRATIXGX_ALLOW_XAUI_WITH_CORECLK_SELECTED_AT_RATE_MATCHER OFF
	set_global_assignment -name STRATIXGX_ALLOW_XAUI_WITH_RX_CORECLK_FROM_NON_TXPLL_SOURCE OFF
	set_global_assignment -name STRATIXGX_ALLOW_GIGE_WITH_CORECLK_SELECTED_AT_RATE_MATCHER OFF
	set_global_assignment -name STRATIXGX_ALLOW_GIGE_WITHOUT_8B10B OFF
	set_global_assignment -name STRATIXGX_ALLOW_GIGE_WITH_RX_CORECLK_FROM_NON_TXPLL_SOURCE OFF
	set_global_assignment -name STRATIXGX_ALLOW_POST8B10B_LOOPBACK OFF
	set_global_assignment -name STRATIXGX_ALLOW_REVERSE_PARALLEL_LOOPBACK OFF
	set_global_assignment -name STRATIXGX_ALLOW_USE_OF_GXB_COUPLED_IOS OFF
	set_global_assignment -name IO_SSO_CHECKING ON
	set_global_assignment -name DRC_REPORT_TOP_FANOUT ON
	set_global_assignment -name DRC_TOP_FANOUT 50
	set_global_assignment -name DRC_REPORT_FANOUT_EXCEEDING ON
	set_global_assignment -name DRC_FANOUT_EXCEEDING 30
	set_global_assignment -name ASSG_CAT ON
	set_global_assignment -name ASSG_RULE_MISSING_FMAX ON
	set_global_assignment -name ASSG_RULE_MISSING_TIMING ON
	set_global_assignment -name SIGNALRACE_RULE_TRISTATE ON
	set_global_assignment -name SIGNALRACE_RULE_RESET_RACE ON
	set_global_assignment -name HCPY_PLL_MULTIPLE_CLK_NETWORK_TYPES ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_ASYN_RAM ON
	set_global_assignment -name HARDCOPY_FLOW_AUTOMATION MIGRATION_ONLY
	set_global_assignment -name CLK_CAT ON
	set_global_assignment -name CLK_RULE_COMB_CLOCK ON
	set_global_assignment -name CLK_RULE_INV_CLOCK ON
	set_global_assignment -name CLK_RULE_GATING_SCHEME ON
	set_global_assignment -name CLK_RULE_INPINS_CLKNET ON
	set_global_assignment -name CLK_RULE_CLKNET_CLKSPINES ON
	set_global_assignment -name CLK_RULE_CLKNET_CLKSPINES_THRESHOLD 25
	set_global_assignment -name CLK_RULE_MIX_EDGES ON
	set_global_assignment -name RESET_CAT ON
	set_global_assignment -name RESET_RULE_INPINS_RESETNET ON
	set_global_assignment -name RESET_RULE_UNSYNCH_EXRESET ON
	set_global_assignment -name RESET_RULE_IMSYNCH_EXRESET ON
	set_global_assignment -name RESET_RULE_COMB_ASYNCH_RESET ON
	set_global_assignment -name RESET_RULE_UNSYNCH_ASYNCH_DOMAIN ON
	set_global_assignment -name RESET_RULE_IMSYNCH_ASYNCH_DOMAIN ON
	set_global_assignment -name TIMING_CAT ON
	set_global_assignment -name TIMING_RULE_SHIFT_REG ON
	set_global_assignment -name TIMING_RULE_COIN_CLKEDGE ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_COMB_DRIVES_RAM_WE ON
	set_global_assignment -name NONSYNCHSTRUCT_CAT ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_COMBLOOP ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_REG_LOOP ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_DELAY_CHAIN ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_RIPPLE_CLK ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_ILLEGAL_PULSE_GEN ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_MULTI_VIBRATOR ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_SRLATCH ON
	set_global_assignment -name NONSYNCHSTRUCT_RULE_LATCH_UNIDENTIFIED ON
	set_global_assignment -name SIGNALRACE_CAT ON
	set_global_assignment -name ACLK_CAT ON
	set_global_assignment -name ACLK_RULE_NO_SZER_ACLK_DOMAIN ON
	set_global_assignment -name ACLK_RULE_SZER_BTW_ACLK_DOMAIN ON
	set_global_assignment -name ACLK_RULE_IMSZER_ADOMAIN ON
	set_global_assignment -name HCPY_CAT ON
	set_global_assignment -name HCPY_VREF_PINS ON
	set_global_assignment -name STRATIX_FAST_PLL_INCREASE_LOCK_WINDOW OFF
	set_global_assignment -name COMPRESSION_MODE OFF
	set_global_assignment -name CLOCK_SOURCE INTERNAL
	set_global_assignment -name CONFIGURATION_CLOCK_FREQUENCY "10 MHZ"
	set_global_assignment -name CONFIGURATION_CLOCK_DIVISOR 1
	set_global_assignment -name ENABLE_LOW_VOLTAGE_MODE_ON_CONFIG_DEVICE ON
	set_global_assignment -name FLEX6K_ENABLE_LOW_VOLTAGE_MODE_ON_CONFIG_DEVICE OFF
	set_global_assignment -name FLEX10K_ENABLE_LOW_VOLTAGE_MODE_ON_CONFIG_DEVICE ON
	set_global_assignment -name MAX7000S_JTAG_USER_CODE FFFF
	set_global_assignment -name STRATIX_JTAG_USER_CODE FFFFFFFF
	set_global_assignment -name APEX20K_JTAG_USER_CODE FFFFFFFF
	set_global_assignment -name MERCURY_JTAG_USER_CODE FFFFFFFF
	set_global_assignment -name FLEX10K_JTAG_USER_CODE 7F
	set_global_assignment -name MAX7000_JTAG_USER_CODE FFFFFFFF
	set_global_assignment -name MAX7000_USE_CHECKSUM_AS_USERCODE OFF
	set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
	set_global_assignment -name SECURITY_BIT OFF
	set_global_assignment -name USE_CONFIGURATION_DEVICE ON
	set_global_assignment -name STRATIXII_CONFIGURATION_DEVICE AUTO
	set_global_assignment -name APEX20K_CONFIGURATION_DEVICE AUTO
	set_global_assignment -name EXCALIBUR_CONFIGURATION_DEVICE AUTO
	set_global_assignment -name MERCURY_CONFIGURATION_DEVICE AUTO
	set_global_assignment -name FLEX6K_CONFIGURATION_DEVICE AUTO
	set_global_assignment -name FLEX10K_CONFIGURATION_DEVICE AUTO
	set_global_assignment -name CYCLONE_CONFIGURATION_DEVICE AUTO
	set_global_assignment -name STRATIX_CONFIGURATION_DEVICE AUTO
	set_global_assignment -name APEX20K_CONFIG_DEVICE_JTAG_USER_CODE FFFFFFFF
	set_global_assignment -name STRATIX_CONFIG_DEVICE_JTAG_USER_CODE FFFFFFFF
	set_global_assignment -name MERCURY_CONFIG_DEVICE_JTAG_USER_CODE FFFFFFFF
	set_global_assignment -name FLEX10K_CONFIG_DEVICE_JTAG_USER_CODE FFFFFFFF
	set_global_assignment -name EPROM_USE_CHECKSUM_AS_USERCODE OFF
	set_global_assignment -name AUTO_INCREMENT_CONFIG_DEVICE_JTAG_USER_CODE ON
	set_global_assignment -name DISABLE_NCS_AND_OE_PULLUPS_ON_CONFIG_DEVICE OFF
	set_global_assignment -name GENERATE_TTF_FILE OFF
	set_global_assignment -name GENERATE_RBF_FILE OFF
	set_global_assignment -name GENERATE_HEX_FILE OFF
	set_global_assignment -name HEXOUT_FILE_START_ADDRESS 0
	set_global_assignment -name HEXOUT_FILE_COUNT_DIRECTION UP
	set_global_assignment -name RELEASE_CLEARS_BEFORE_TRI_STATES OFF
	set_global_assignment -name ALWAYS_ENABLE_INPUT_BUFFERS OFF
	set_global_assignment -name ENABLE_ASMI_FOR_FLASH_LOADER OFF
	set_global_assignment -name HARDCOPYII_POWER_ON_EXTRA_DELAY OFF
	set_global_assignment -name STRATIXII_EP2S60ES_ALLOW_MRAM_USAGE OFF
	set_global_assignment -name STRATIXII_ALLOW_DUAL_PORT_DUAL_CLOCK_MRAM_USAGE OFF
	set_global_assignment -name STRATIXII_MRAM_COMPATIBILITY ON
	set_global_assignment -name CYCLONEII_M4K_COMPATIBILITY ON
	set_global_assignment -name INVERT_BASE_CLOCK OFF -section_id coreclk
	set_global_assignment -name MULTIPLY_BASE_CLOCK_PERIOD_BY 1 -section_id coreclk
	set_global_assignment -name DIVIDE_BASE_CLOCK_PERIOD_BY 1 -section_id coreclk
	set_global_assignment -name EDA_LAUNCH_CMD_LINE_TOOL OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_USE_RISE_FALL_DELAYS OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_ENABLE_OCV_TIMING_ANALYSIS OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_INCLUDE_VHDL_CONFIGURATION_DECLARATION OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_TRUNCATE_LONG_HIERARCHY_PATHS OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_FLATTEN_BUSES OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_MAP_ILLEGAL_CHARACTERS OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT NONE -section_id eda_design_synthesis
	set_global_assignment -name EDA_GENERATE_TIMING_CLOSURE_DATA OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_GENERATE_POWER_INPUT_FILE OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS NOT_USED -section_id eda_design_synthesis
	set_global_assignment -name EDA_RTL_SIM_MODE NOT_USED -section_id eda_design_synthesis
	set_global_assignment -name EDA_MAINTAIN_DESIGN_HIERARCHY OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_WRITE_DEVICE_CONTROL_PORTS OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_ENABLE_GLITCH_FILTERING OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_WRITE_NODES_FOR_POWER_ESTIMATION OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_SETUP_HOLD_DETECTION_INPUT_REGISTERS_BIDIR_PINS_DISABLED OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_WRITER_DONT_WRITE_TOP_ENTITY OFF -section_id eda_design_synthesis
	set_global_assignment -name EDA_VHDL_ARCH_NAME structure -section_id eda_design_synthesis
	set_global_assignment -name EDA_INPUT_GND_NAME GND -section_id eda_design_synthesis
	set_global_assignment -name EDA_INPUT_VCC_NAME VCC -section_id eda_design_synthesis
	set_global_assignment -name EDA_SHOW_LMF_MAPPING_MESSAGES OFF -section_id eda_design_synthesis
	set_global_assignment -name RESYNTHESIS_RETIMING FULL -section_id eda_design_synthesis
	set_global_assignment -name RESYNTHESIS_OPTIMIZATION_EFFORT NORMAL -section_id eda_design_synthesis
	set_global_assignment -name RESYNTHESIS_PHYSICAL_SYNTHESIS NORMAL -section_id eda_design_synthesis
	set_global_assignment -name USE_GENERATED_PHYSICAL_CONSTRAINTS ON -section_id eda_design_synthesis
	set_global_assignment -name EDA_LAUNCH_CMD_LINE_TOOL OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_USE_RISE_FALL_DELAYS OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_ENABLE_OCV_TIMING_ANALYSIS OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_INCLUDE_VHDL_CONFIGURATION_DECLARATION OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_TRUNCATE_LONG_HIERARCHY_PATHS OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_FLATTEN_BUSES OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_MAP_ILLEGAL_CHARACTERS OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT NONE -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_GENERATE_TIMING_CLOSURE_DATA OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_GENERATE_POWER_INPUT_FILE OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS NOT_USED -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_MAINTAIN_DESIGN_HIERARCHY OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_WRITE_DEVICE_CONTROL_PORTS OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_ENABLE_GLITCH_FILTERING OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_WRITE_NODES_FOR_POWER_ESTIMATION OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_INPUT_GND_NAME GND -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_INPUT_DATA_FORMAT EDIF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_SHOW_LMF_MAPPING_MESSAGES OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_RUN_TOOL_AUTOMATICALLY OFF -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name RESYNTHESIS_RETIMING FULL -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name RESYNTHESIS_OPTIMIZATION_EFFORT NORMAL -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name RESYNTHESIS_PHYSICAL_SYNTHESIS NORMAL -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name USE_GENERATED_PHYSICAL_CONSTRAINTS ON -entity addsub.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_LAUNCH_CMD_LINE_TOOL OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_USE_RISE_FALL_DELAYS OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_ENABLE_OCV_TIMING_ANALYSIS OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_INCLUDE_VHDL_CONFIGURATION_DECLARATION OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_TRUNCATE_LONG_HIERARCHY_PATHS OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_FLATTEN_BUSES OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_MAP_ILLEGAL_CHARACTERS OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT NONE -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_GENERATE_TIMING_CLOSURE_DATA OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_GENERATE_POWER_INPUT_FILE OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS NOT_USED -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_MAINTAIN_DESIGN_HIERARCHY OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_WRITE_DEVICE_CONTROL_PORTS OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_ENABLE_GLITCH_FILTERING OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_WRITE_NODES_FOR_POWER_ESTIMATION OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_INPUT_GND_NAME GND -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_INPUT_DATA_FORMAT EDIF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_SHOW_LMF_MAPPING_MESSAGES OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name EDA_RUN_TOOL_AUTOMATICALLY OFF -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name RESYNTHESIS_RETIMING FULL -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name RESYNTHESIS_OPTIMIZATION_EFFORT NORMAL -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name RESYNTHESIS_PHYSICAL_SYNTHESIS NORMAL -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name USE_GENERATED_PHYSICAL_CONSTRAINTS ON -entity manikpackage.vhd -section_id eda_design_synthesis
	set_global_assignment -name INVERT_BASE_CLOCK OFF -section_id baud16_clk
	set_global_assignment -name MULTIPLY_BASE_CLOCK_PERIOD_BY 1 -section_id baud16_clk
	set_global_assignment -name DIVIDE_BASE_CLOCK_PERIOD_BY 1 -section_id baud16_clk
	set_global_assignment -name PARTITION_IMPORT_ASSIGNMENTS ON -section_id Top
	set_global_assignment -name PARTITION_IMPORT_EXISTING_ASSIGNMENTS REPLACE_CONFLICTING -section_id Top
	set_global_assignment -name PARTITION_IMPORT_EXISTING_LOGICLOCK_REGIONS REPLACE_CONFLICTING -section_id Top
	set_global_assignment -name PARTITION_IMPORT_PIN_ASSIGNMENTS ON -section_id Top
	set_global_assignment -name PARTITION_IMPORT_PROMOTE_ASSIGNMENTS ON -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
