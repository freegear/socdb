#----------------------------------------------------------------------
#
# Copyright (c) 2003 CAST, Inc.
#
# Please review the terms of the license agreement before using this
# file.  If you are not an authorized user, please destroy this source
# code file and notify CAST immediately that you inadvertently received
# an unauthorized copy.
#----------------------------------------------------------------------
#
#  Project       : PCI-M64
#
#  Description   : PCI 64/66 - AHB interface core
#
#  File          : exemplar_virtex.tcl
#
#  Purpose       : Exemplar script for Xilinx Virtex technology
#
#  Designer      : Tony
#
#  QA Engineer   : 
#
#  Creation Date : 24-November-2003
#
#  Last Update   : 24-November-2003
#
#  Version       : 1.0.1V
#----------------------------------------------------------------------
#
puts "Setting up the Part"
set part 2V1000fg456
set process 6
set wire_table xcv2-1000-6_wc
set virtex_map_iob_registers TRUE
load_library xcv2
#
puts "Reading files"

read -technology "xcv2"  { 
../src/ahb/pcim64ahbw.v
../src/m64core/pci_gclkbuf.v
../src/m64core/pci_ibuf.v
../src/m64core/pci_iobuf.v
../src/m64core/pci_obuf.v
../src/m64core/pci_obufoc.v
../src/m64core/pci_obuft.v
../src/m64core/pci_chkpar64.v
../src/m64core/pci_genpar64.v
../src/m64core/pci_cead.v
../src/m64core/pci_barreg.v
../src/m64core/pci_cfgebar.v
../src/m64core/pci_cfgspace.v
../src/m64core/pci_genframe.v
../src/m64core/pci_genreq64.v
../src/m64core/pci_genirdy.v
../src/m64core/pci_gendevsel.v
../src/m64core/pci_genack64.v
../src/m64core/pci_genotad.v
../src/m64core/pci_genotcbe.v
../src/m64core/pci_gentrdy.v
../src/m64core/pci_genstop.v
../src/m64core/pci_mtfsm64.v
../src/m64core/pci_m64core.v
../src/ahb/psync.v
../src/ahb/dma64_fiforam.v
../src/ahb/dma64wrfifo.v  
../src/ahb/dma64rdfifo.v  
../src/ahb/dma64txctrl.v  
../src/ahb/dma64regs.v
../src/ahb/fifosram.v
../src/ahb/fifo_async.v
../src/ahb/t64ahb.v
../src/ahb/intctrl.v
../src/ahb/mailbox.v
../src/ahb/mailboxblk.v
../src/ahb/ahbslave.v
../src/ahb/ahbmaster.v
../src/ahb/dma64ahb.v
../src/ahb/mt64ahb.v
../src/ahb/pcim64ahb.v
}

#
puts "Optimizing for chip"
set macro TRUE
set chip TRUE
set delay TRUE
set hierarchy_preserve TRUE
set register2register 30
set input2register 7
set register2output 11
optimize .work.pcim64ahbw.INTERFACE -target xcv2 -chip -delay -effort quick -hierarchy preserve 
optimize_timing .work.pcim64ahbw.INTERFACE
# 
puts "Reports..."
report_area
#
puts "EDIF output"
set output_file ./pcim64ahbw.edf
auto_write pcim64ahbw.edf -format edif
#
# End of file
