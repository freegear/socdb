# Run with quartus_sh -t <x_cons.tcl>
set_global_assignment -name ROOT "|VideoEncoderTester"
set_global_assignment -name FAMILY "STRATIX II"
set_global_assignment -name DEVICE "EP2S180F1020C4"
set_global_assignment -section_id VideoEncoderTester -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "SYNPLIFY"
set_global_assignment -section_id eda_design_synthesis -name EDA_USE_LMF synplcty.lmf
set_global_assignment -section_id CLK_27MHZ_setting -name DUTY_CYCLE "50.00" 
set_instance_assignment -entity VideoEncoderTester -to CLK_27MHZ -name GLOBAL_SIGNAL ON
set_instance_assignment -entity VideoEncoderTester -to CLK_27MHZ -name USE_CLOCK_SETTINGS CLK_27MHZ_setting 
set_global_assignment -section_id CLK_27MHZ_setting -name FMAX_REQUIREMENT "185.3MHZ"
set_global_assignment -section_id ACLK_setting -name DUTY_CYCLE "50.00" 
set_instance_assignment -entity VideoEncoderTester -to ACLK -name GLOBAL_SIGNAL ON
set_instance_assignment -entity VideoEncoderTester -to ACLK -name USE_CLOCK_SETTINGS ACLK_setting 
set_global_assignment -section_id ACLK_setting -name FMAX_REQUIREMENT "173.7MHZ"
set_global_assignment -name TAO_FILE "myresults.tao"
set_global_assignment -name SOURCES_PER_DESTINATION_INCLUDE_COUNT "1000" 
set_global_assignment -name ROUTER_REGISTER_DUPLICATION ON
set_global_assignment -name REMOVE_REDUNDANT_LOGIC_CELLS "ON"
# set_global_assignment -name FITTER_EFFORT "STANDARD FIT"
set_global_assignment -name APEX20K_OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name STRATIX_OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name STRATIXII_OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name INCLUDE_EXTERNAL_PIN_DELAYS_IN_FMAX_CALCULATIONS OFF
set_global_assignment -name MAX_SCC_SIZE 50
set_global_assignment -name EDA_RESYNTHESIS_TOOL "AMPLIFY"

# False path constraints 

# Multicycle constraints 

# Path delay constraints 
