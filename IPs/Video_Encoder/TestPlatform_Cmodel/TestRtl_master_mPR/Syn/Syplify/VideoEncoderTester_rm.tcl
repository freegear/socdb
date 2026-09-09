set_global_assignment -name ROOT "|VideoEncoderTester" -remove 
set_global_assignment -name FAMILY -remove 
set_global_assignment -section_id CLK_27MHZ_setting -name DUTY_CYCLE "50.00" -remove 
set_instance_assignment -entity VideoEncoderTester -to CLK_27MHZ -name GLOBAL_SIGNAL ON -remove 
set_instance_assignment -entity VideoEncoderTester -to CLK_27MHZ -name USE_CLOCK_SETTINGS CLK_27MHZ_setting -remove 
set_global_assignment -section_id CLK_27MHZ_setting -name FMAX_REQUIREMENT "185.3MHZ" -remove 
set_global_assignment -section_id ACLK_setting -name DUTY_CYCLE "50.00" -remove 
set_instance_assignment -entity VideoEncoderTester -to ACLK -name GLOBAL_SIGNAL ON -remove 
set_instance_assignment -entity VideoEncoderTester -to ACLK -name USE_CLOCK_SETTINGS ACLK_setting -remove 
set_global_assignment -section_id ACLK_setting -name FMAX_REQUIREMENT "173.7MHZ" -remove 
set_global_assignment -name TAO_FILE "myresults.tao" -remove
set_global_assignment -name SOURCES_PER_DESTINATION_INCLUDE_COUNT "1000" -remove 
set_global_assignment -name ROUTER_REGISTER_DUPLICATION ON -remove 
set_global_assignment -name REMOVE_DUPLICATE_LOGIC "OFF" -remove 
set_global_assignment -name REMOVE_DUPLICATE_REGISTERS "OFF" -remove 
set_global_assignment -name REMOVE_REDUNDANT_LOGIC_CELLS "ON" -remove 
set_global_assignment -name APEX20K_OPTIMIZATION_TECHNIQUE SPEED -remove 
set_global_assignment -name STRATIX_OPTIMIZATION_TECHNIQUE SPEED -remove 
set_global_assignment -name STRATIXII_OPTIMIZATION_TECHNIQUE SPEED -remove 
set_global_assignment -name INCLUDE_EXTERNAL_PIN_DELAYS_IN_FMAX_CALCULATIONS OFF -remove 
set_global_assignment -name MAX_SCC_SIZE 50 -remove 
set_global_assignment -name EDA_RESYNTHESIS_TOOL "AMPLIFY" -remove
