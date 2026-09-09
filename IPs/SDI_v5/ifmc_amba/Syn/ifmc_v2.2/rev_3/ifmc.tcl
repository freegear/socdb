
cmp start_batch

project start_batch

project start_batch fpga_fmc
cmp add_assignment "" "" "" ROOT "|fpga_fmc"
cmp add_assignment "" "" "" FAMILY "EXCALIBUR_ARM"
cmp add_assignment "fpga_fmc" "" "" DEVICE "EPXA10F1020C1"
project add_assignment "" "fpga_fmc" "" "" "EDA_DESIGN_ENTRY_SYNTHESIS_TOOL" "SYNPLIFY"
project add_assignment "" "eda_design_synthesis" "" "" "EDA_USE_LMF" "synplcty.lmf"
project add_assignment "" "clk_setting" "" "" "DUTY_CYCLE" "50"
project add_assignment "fpga_fmc" "" "" "clk" "GLOBAL_SIGNAL" "ON"
project add_assignment "fpga_fmc" "" "" "clk" "USE_CLOCK_SETTINGS" "clk_setting"
project add_assignment "" "clk_setting" "" "" "FMAX_REQUIREMENT" "50.0MHZ"
project add_assignment "" "" "" "" "TAO_FILE" "myresults.tao"
project add_assignment "" "" "" "" "SOURCES_PER_DESTINATION_INCLUDE_COUNT" "1000"
project add_assignment "" "" "" "" "ROUTER_REGISTER_DUPLICATION" "ON"
project add_assignment "fpga_fmc" "" "clk"  "sda"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sm_idle"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sm_initialize"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sm_get_addr"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sm_addr_dummy"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sm_clr_counter"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sm_get_data"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sm_data_dummy"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sm_stop"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "scl_lpf"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sda_lpf"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "clkout"  "TCO_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "scl"  "TSU_REQUIREMENT"  "20.000ns"
project add_assignment "fpga_fmc" "" "clk"  "sda"  "TSU_REQUIREMENT"  "20.000ns"

# False path constraints 

# Multicycle constraints 

# Path delay constraints 

project end_batch fpga_fmc

project end_batch

cmp end_batch
