# Synplicity, Inc. constraint file
# D:\ETRI_UWB\ADK_PCI_BOARD\synplify\PCI_FPGA.sdc
# Written on Thu Aug 02 20:28:46 2007
# by Synplify Pro, Synplify Pro 8.6.2 Scope Editor

#
# Collections
#

#
# Clocks
#

#
# Clock to Clock
#

#
# Inputs/Outputs
#
define_input_delay -disable      -default
define_output_delay -disable     -default
define_output_delay -disable     {adin[31:0]}
define_input_delay -disable      {adout[31:0]}
define_input_delay -disable      {arb_gnt_b[4:1]}
define_output_delay -disable     {arb_req_b[4:1]}
define_output_delay -disable     {cbein_b[3:0]}
define_input_delay -disable      {cbeout_b[3:0]}
define_output_delay -disable     {CLK33M}
define_output_delay -disable     {devselin_b}
define_input_delay -disable      {devselout_b}
define_output_delay -disable     {framein_b}
define_input_delay -disable      {frameout_b}
define_output_delay -disable     {idsel}
define_input_delay -disable      {intaout_b}
define_output_delay -disable     {irdyin_b}
define_input_delay -disable      {irdyout_b}
define_output_delay -disable     {led[3:0]}
define_input_delay -disable      {nRESET}
define_input_delay -disable      {nRst}
define_input_delay -disable      {oe_ad}
define_input_delay -disable      {oe_cbe}
define_input_delay -disable      {oe_devsel}
define_input_delay -disable      {oe_frame}
define_input_delay -disable      {oe_irdy}
define_input_delay -disable      {oe_par}
define_input_delay -disable      {oe_perr}
define_input_delay -disable      {oe_req}
define_input_delay -disable      {oe_stop}
define_input_delay -disable      {oe_trdy}
define_output_delay -disable     {parin}
define_input_delay -disable      {parout}
define_input_delay -disable      {PCI_AD[31:0]}
define_output_delay -disable     {PCI_AD[31:0]}
define_input_delay -disable      {PCI_CBE[3:0]}
define_output_delay -disable     {PCI_CBE[3:0]}
define_output_delay -disable     {PCI_CLK[3:0]}
define_input_delay -disable      {PCI_DEVSEL}
define_output_delay -disable     {PCI_DEVSEL}
define_input_delay -disable      {PCI_FRAME}
define_output_delay -disable     {PCI_FRAME}
define_output_delay -disable     {PCI_GNT[4:1]}
define_output_delay -disable     {PCI_IDSEL[3:0]}
define_input_delay -disable      {PCI_INTA}
define_output_delay -disable     {PCI_INTAb}
define_input_delay -disable      {PCI_INTB}
define_output_delay -disable     {PCI_INTBb}
define_input_delay -disable      {PCI_INTC}
define_output_delay -disable     {PCI_INTCb}
define_input_delay -disable      {PCI_INTD}
define_output_delay -disable     {PCI_INTDb}
define_input_delay -disable      {PCI_IRDY}
define_output_delay -disable     {PCI_IRDY}
define_output_delay -disable     {PCI_M66EN}
define_input_delay -disable      {PCI_PAR}
define_output_delay -disable     {PCI_PAR}
define_input_delay -disable      {PCI_PERR}
define_output_delay -disable     {PCI_PERR}
define_input_delay -disable      {PCI_REQ[4:1]}
define_output_delay -disable     {PCI_RESET}
define_output_delay -disable     {PCI_SERR}
define_input_delay -disable      {PCI_STOP}
define_output_delay -disable     {PCI_STOP}
define_input_delay -disable      {PCI_TRDY}
define_output_delay -disable     {PCI_TRDY}
define_output_delay -disable     {perrin_b}
define_input_delay -disable      {perrout_b}
define_input_delay -disable      {serrout_b}
define_output_delay -disable     {SevenSegComm[3:0]}
define_output_delay -disable     {SevenSegCtrl[7:0]}
define_output_delay -disable     {stopin_b}
define_input_delay -disable      {stopout_b}
define_input_delay -disable      {sw[3:0]}
define_output_delay -disable     {trdyin_b}
define_input_delay -disable      {trdyout_b}

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
