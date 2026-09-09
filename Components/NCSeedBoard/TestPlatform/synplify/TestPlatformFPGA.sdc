# Synplicity, Inc. constraint file
# D:\projects\FPGADemo\TestPlatform\synplify\TestPlatformFPGA.sdc
# Written on Fri Nov 17 10:28:24 2006
# by Synplify Pro, Synplify Pro 8.6.2 Scope Editor

#
# Collections
#

#
# Clocks
#
define_clock            -name {Clock}  -freq 56.000 -clockgroup default_clkgroup_0
define_clock            -name {i:Core.ClockResetGen.BUSClk_reg}  -freq 28.000 -clockgroup default_clkgroup_0
define_clock            -name {i:Core.ClockResetGen.APBClk_div}  -freq 7.000 -clockgroup default_clkgroup_0
define_clock            -name {SD_DQS[0]}  -freq 50.000 -clockgroup default_clkgroup_1
define_clock            -name {SD_DQS[1]}  -freq 50.000 -clockgroup default_clkgroup_1
define_clock            -name {i:Core.MMCTop.Prescaler.MMC_CLK}  -freq 14.000 -clockgroup default_clkgroup_0
define_clock            -name {i:Core.LCDClk}  -freq 14.000 -clockgroup default_clkgroup_0

#
# Clock to Clock
#

#
# Inputs/Outputs
#
define_input_delay -disable      -default -improve 0.00 -route 0.00
define_output_delay -disable     -default -improve 0.00 -route 0.00
define_output_delay -disable     {EXT_ADDR[19:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {EXT_CSb} -improve 0.00 -route 0.00
define_input_delay -disable      {EXT_DATA[15:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {EXT_DATA[15:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {EXT_OEb} -improve 0.00 -route 0.00
define_output_delay -disable     {EXT_WEb} -improve 0.00 -route 0.00
define_input_delay -disable      {I2C_SCL} -improve 0.00 -route 0.00
define_output_delay -disable     {I2C_SCL} -improve 0.00 -route 0.00
define_input_delay -disable      {I2C_SDA} -improve 0.00 -route 0.00
define_output_delay -disable     {I2C_SDA} -improve 0.00 -route 0.00
define_output_delay -disable     {LCDClk} -improve 0.00 -route 0.00
define_output_delay -disable     {LCDData[23:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {LCDDataEn} -improve 0.00 -route 0.00
define_output_delay -disable     {LCDHSync} -improve 0.00 -route 0.00
define_output_delay -disable     {LCDVSync} -improve 0.00 -route 0.00
define_output_delay -disable     {led_4094clk} -improve 0.00 -route 0.00
define_output_delay -disable     {led_4094d} -improve 0.00 -route 0.00
define_output_delay -disable     {led_4094oe} -improve 0.00 -route 0.00
define_output_delay -disable     {led_4094str[3:0]} -improve 0.00 -route 0.00
define_input_delay -disable      {MMC_CLKOUT} -improve 0.00 -route 0.00
define_output_delay -disable     {MMC_CLKOUT} -improve 0.00 -route 0.00
define_input_delay -disable      {MMC_CMD} -improve 0.00 -route 0.00
define_output_delay -disable     {MMC_CMD} -improve 0.00 -route 0.00
define_input_delay -disable      {MMC_DAT[7:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {MMC_DAT[7:0]} -improve 0.00 -route 0.00
define_input_delay -disable      {RESETn} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_ADDR[12:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_BADDR[1:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_CASB} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_CKE} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_CLK} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_CSB} -improve 0.00 -route 0.00
define_input_delay -disable      {SD_DQ[15:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_DQ[15:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_DQM[1:0]} -improve 0.00 -route 0.00
define_input_delay -disable      {SD_DQS[1:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_DQS[1:0]} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_nCLK} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_RASB} -improve 0.00 -route 0.00
define_output_delay -disable     {SD_WEB} -improve 0.00 -route 0.00
define_input_delay -disable      {UART_RXD} -improve 0.00 -route 0.00
define_output_delay -disable     {UART_TXD} -improve 0.00 -route 0.00

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
