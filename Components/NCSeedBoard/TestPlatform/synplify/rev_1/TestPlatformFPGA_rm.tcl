set_global_assignment -name TOP_LEVEL_ENTITY "|TestPlatformFPGA" -remove 
set_global_assignment -name FAMILY -remove 
set_global_assignment -name TAO_FILE "myresults.tao" -remove
set_global_assignment -name SOURCES_PER_DESTINATION_INCLUDE_COUNT "1000" -remove 
set_global_assignment -name ROUTER_REGISTER_DUPLICATION ON -remove 
set_global_assignment -name REMOVE_DUPLICATE_LOGIC "OFF" -remove 
set_global_assignment -name REMOVE_DUPLICATE_REGISTERS "OFF" -remove 
set_global_assignment -name REMOVE_REDUNDANT_LOGIC_CELLS "OFF" -remove 
set_global_assignment -name REMOVE_DUPLICATE_REGISTERS "OFF" -remove 
set_global_assignment -name REMOVE_DUPLICATE_LOGIC "OFF" -remove 
set_global_assignment -name APEX20K_OPTIMIZATION_TECHNIQUE SPEED -remove 
set_global_assignment -name STRATIX_OPTIMIZATION_TECHNIQUE SPEED -remove 
set_global_assignment -name STRATIXII_OPTIMIZATION_TECHNIQUE SPEED -remove 
set_global_assignment -name INCLUDE_EXTERNAL_PIN_DELAYS_IN_FMAX_CALCULATIONS OFF -remove 
set_global_assignment -name MAX_SCC_SIZE 50 -remove 
#set_global_assignment -name EDA_RESYNTHESIS_TOOL "AMPLIFY" -remove
create_relative_clock -base_clock Clock_setting -multiply 4 -divide 1 -duty_cycle 50.00 |TestPlatformCore:Core|MMCTop:MMCTop|mmc_Prescaler:Prescaler|MMC_CLKOUT_c_setting -target |TestPlatformCore:Core|MMCTop:MMCTop|mmc_Prescaler:Prescaler|MMC_CLKOUT_c -disable
create_base_clock SD_DQS\[1\]_setting -fmax 50.0mhz -duty_cycle 50.00 -target SD_DQS\[1\] -disable
create_relative_clock -base_clock SD_DQS\[1\]_setting -duty_cycle 50.00 SD_DQS\[0\]_setting -target SD_DQS\[0\] -disable
create_relative_clock -base_clock Clock_setting -multiply 2 -divide 1 -duty_cycle 50.00 |TestPlatformCore:Core|ClockResetGen_2s_1s_0_500000_1s:ClockResetGen|SD_CLK_c_setting -target |TestPlatformCore:Core|ClockResetGen_2s_1s_0_500000_1s:ClockResetGen|SD_CLK_c -disable
create_base_clock Clock_setting -fmax 56.0mhz -duty_cycle 50.00 -target Clock -disable
