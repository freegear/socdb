# Run with quartus_sh -t <x_cons.tcl>

# Global assignments 
set_global_assignment -name TOP_LEVEL_ENTITY "|TestPlatformFPGA"
set_global_assignment -name FAMILY "STRATIX II"
set_global_assignment -name DEVICE "EP2S180F1508C4"
set_global_assignment -section_id TestPlatformFPGA -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "SYNPLIFY"
set_global_assignment -section_id eda_design_synthesis -name EDA_USE_LMF synplcty.lmf
set_global_assignment -name TAO_FILE "myresults.tao"
set_global_assignment -name SOURCES_PER_DESTINATION_INCLUDE_COUNT "1000" 
set_global_assignment -name ROUTER_REGISTER_DUPLICATION ON
set_global_assignment -name REMOVE_REDUNDANT_LOGIC_CELLS "OFF"
set_global_assignment -name REMOVE_DUPLICATE_REGISTERS "OFF"
set_global_assignment -name REMOVE_DUPLICATE_LOGIC "OFF"
# set_global_assignment -name FITTER_EFFORT "STANDARD FIT"
set_global_assignment -name APEX20K_OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name STRATIX_OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name STRATIXII_OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name INCLUDE_EXTERNAL_PIN_DELAYS_IN_FMAX_CALCULATIONS OFF
set_global_assignment -name MAX_SCC_SIZE 50
#set_global_assignment -name EDA_RESYNTHESIS_TOOL "AMPLIFY"

# Clock assignments 

create_relative_clock -base_clock Clock_setting -multiply 4 -divide 1 -duty_cycle 50.00 |TestPlatformCore:Core|MMCTop:MMCTop|mmc_Prescaler:Prescaler|MMC_CLKOUT_c_setting -target |TestPlatformCore:Core|MMCTop:MMCTop|mmc_Prescaler:Prescaler|MMC_CLKOUT_c
create_base_clock SD_DQS\[1\]_setting -fmax 50.0mhz -duty_cycle 50.00 -target SD_DQS\[1\] 
create_relative_clock -base_clock SD_DQS\[1\]_setting -duty_cycle 50.00 SD_DQS\[0\]_setting -target SD_DQS\[0\]
create_relative_clock -base_clock Clock_setting -multiply 2 -divide 1 -duty_cycle 50.00 |TestPlatformCore:Core|ClockResetGen_2s_1s_0_500000_1s:ClockResetGen|SD_CLK_c_setting -target |TestPlatformCore:Core|ClockResetGen_2s_1s_0_500000_1s:ClockResetGen|SD_CLK_c
create_base_clock Clock_setting -fmax 56.0mhz -duty_cycle 50.00 -target Clock 


# False path constraints 

# Multicycle constraints 

# Path delay constraints 
