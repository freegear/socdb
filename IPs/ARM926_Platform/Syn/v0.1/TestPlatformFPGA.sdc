# Synplicity, Inc. constraint file
# D:\Project\ARM926_Platform\Syn\v0.1\TestPlatformFPGA.sdc
# Written on Thu Dec 07 20:46:34 2006
# by Synplify Pro, Synplify Pro 8.6.2 Scope Editor

#
# Collections
#

#
# Clocks
#
define_clock            -name {Clock}  -freq 200.000 -clockgroup default_clkgroup_0
define_clock            -name {i:Core.ClockResetGen.BUSCLK_reg}  -freq 200.000 -clockgroup default_clkgroup_0
define_clock -disable   -name {i:Core.ClockResetGen.SD_CLK_c_c}  -freq 100.000 -clockgroup default_clkgroup_0
define_clock -disable   -name {i:Core.ClockResetGen.SD_CLK_i_0}  -freq 100.000 -clockgroup default_clkgroup_0
define_clock -disable   -name {i:Core.ClockResetGen.APBClk}  -freq 100.000 -clockgroup default_clkgroup_0
define_clock            -name {SD_DQS[0]}  -freq 100.000 -clockgroup default_clkgroup_1
define_clock            -name {SD_DQS[1]}  -freq 100.000 -clockgroup default_clkgroup_1
define_clock            -name {i:Core.MMCTop.Prescaler.MMC_CLK}  -freq 100.000 -clockgroup default_clkgroup_0

#
# Clock to Clock
#

#
# Inputs/Outputs
#
define_input_delay -disable      -default -improve 0.00 -route 0.00
define_output_delay -disable     -default -improve 0.00 -route 0.00
define_output_delay              {SD_ADDR[12:0]} -improve 0.00 -route 0.00
define_output_delay              {SD_BADDR[1:0]} -improve 0.00 -route 0.00
define_output_delay              {SD_CASB} -improve 0.00 -route 0.00
define_output_delay              {SD_CKE} -improve 0.00 -route 0.00
define_output_delay              {SD_CLK} -improve 0.00 -route 0.00
define_output_delay              {SD_CSB} -improve 0.00 -route 0.00
define_input_delay               {SD_DQ[15:0]} -improve 0.00 -route 0.00
define_output_delay              {SD_DQ[15:0]} -improve 0.00 -route 0.00
define_output_delay              {SD_DQM[1:0]} -improve 0.00 -route 0.00
define_input_delay               {SD_DQS[1:0]} -improve 0.00 -route 0.00
define_output_delay              {SD_DQS[1:0]} -improve 0.00 -route 0.00
define_output_delay              {SD_nCLK} -improve 0.00 -route 0.00
define_output_delay              {SD_RASB} -improve 0.00 -route 0.00
define_output_delay              {SD_WEB} -improve 0.00 -route 0.00
define_input_delay               {UART_RXD} -improve 0.00 -route 0.00
define_output_delay              {UART_TXD} -improve 0.00 -route 0.00
define_output_delay              {EXT_ADDR[19:0]} -improve 0.00 -route 0.00
define_output_delay              {EXT_CSb} -improve 0.00 -route 0.00
define_input_delay               {EXT_DATA[15:0]} -improve 0.00 -route 0.00
define_output_delay              {EXT_DATA[15:0]} -improve 0.00 -route 0.00
define_output_delay              {EXT_OEb} -improve 0.00 -route 0.00
define_output_delay              {EXT_WEb} -improve 0.00 -route 0.00
define_input_delay               {I2C_SCL} -improve 0.00 -route 0.00
define_output_delay              {I2C_SCL} -improve 0.00 -route 0.00
define_input_delay               {I2C_SDA} -improve 0.00 -route 0.00
define_output_delay              {I2C_SDA} -improve 0.00 -route 0.00
define_output_delay              {LCDClk} -improve 0.00 -route 0.00
define_output_delay              {LCDData[23:0]} -improve 0.00 -route 0.00
define_output_delay              {LCDDataEn} -improve 0.00 -route 0.00
define_output_delay              {LCDHSync} -improve 0.00 -route 0.00
define_output_delay              {LCDVSync} -improve 0.00 -route 0.00
define_output_delay              {led_4094clk} -improve 0.00 -route 0.00
define_output_delay              {led_4094d} -improve 0.00 -route 0.00
define_output_delay              {led_4094oe} -improve 0.00 -route 0.00
define_output_delay              {led_4094str[3:0]} -improve 0.00 -route 0.00
define_input_delay               {MMC_CLKOUT} -improve 0.00 -route 0.00
define_output_delay              {MMC_CLKOUT} -improve 0.00 -route 0.00
define_input_delay               {MMC_CMD} -improve 0.00 -route 0.00
define_output_delay              {MMC_CMD} -improve 0.00 -route 0.00
define_input_delay               {MMC_DAT[7:0]} -improve 0.00 -route 0.00
define_output_delay              {MMC_DAT[7:0]} -improve 0.00 -route 0.00
define_input_delay               {RESETn} -improve 0.00 -route 0.00

#
# Registers
#

#
# Multicycle Path
#

#
# False Path
#

#
# Path Delay
#

#
# Attributes
#

#
# I/O standards
#

#
# Compile Points
#

#
# Other Constraints
#
