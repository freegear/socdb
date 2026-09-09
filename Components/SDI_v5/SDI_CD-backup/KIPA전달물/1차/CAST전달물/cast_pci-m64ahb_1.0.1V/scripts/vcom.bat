#!/bin/csh -f
#----------------------------------------------------------------------
#--
#-- Copyright (c) 2003 CAST, Inc.
#--
#-- Please review the terms of the license agreement before using this
#-- file.  If you are not an authorized user, please destroy this source
#-- code file and notify CAST immediately that you inadvertently received
#-- an unauthorized copy.
#------------------------------------------------------------------------
#--
#--  Project       : PCI-M64AHB
#--
#--  File          : compile_mti.do
#--
#--  Dependencies  : 
#--
#--  Model Type:   : Modelsim Script file
#--
#--  Description   : Modelsim library compile script for PCI-M32 core 
#--
#--  Designer      : AS
#--
#--  QA Engineer   : 
#--
#--  Creation Date : 1-November-2003
#--
#--  Last Update   : 20-November-2003
#--
#--  Version       : 1.0
#------------------------------------------------------------------------
#  Execute by typing "do compile_mti.do" on modelsim's command line
#------------------------------------------------------------------------
#
#
#  Create library work
#
vlib work
# copy test vector file to the working directory
#
#file copy -force ../tb/ram_burst.vec ./ram_burst.vec
#file copy -force ../tb/t64_t1.vec ./t64_t1.vec
#file copy -force ../tb/t64_t2.vec ./t64_t2.vec
#
#  Compile design files
#
#
# I/O buffers

vlog -work work {../src/m64core/pci_gclkbuf.v} 
vlog -work work {../src/m64core/pci_ibuf.v}    
vlog -work work {../src/m64core/pci_iobuf.v}   
vlog -work work {../src/m64core/pci_obuf.v}    
vlog -work work {../src/m64core/pci_obufoc.v}  
vlog -work work {../src/m64core/pci_obuft.v}   
#
# M64 Core source files
vlog -work work +incdir+../src/ahb/ {../src/m64core/pci_chkpar64.v}          
vlog -work work +incdir+../src/ahb/ {../src/m64core/pci_genpar64.v}         
vlog -work work {../src/m64core/pci_cead.v}             

vlog -work work {../src/m64core/pci_barreg.v}           
vlog -work work +incdir+../src/ahb/ {../src/m64core/pci_cfgebar.v}     
vlog -work work +incdir+../src/ahb/ {../src/m64core/pci_cfgspace.v}         

vlog -work work {../src/m64core/pci_genframe.v}  
vlog -work work {../src/m64core/pci_genreq64.v}  
vlog -work work {../src/m64core/pci_genirdy.v}          
vlog -work work {../src/m64core/pci_gendevsel.v}        
vlog -work work {../src/m64core/pci_genack64.v}          
vlog -work work +incdir+../src/ahb/ {../src/m64core/pci_genotad.v}          
vlog -work work +incdir+../src/ahb/ {../src/m64core/pci_genotcbe.v}           
vlog -work work {../src/m64core/pci_gentrdy.v}          
vlog -work work {../src/m64core/pci_genstop.v}           
vlog -work work +incdir+../src/ahb/ {../src/m64core/pci_mtfsm64.v}          
vlog -work work +incdir+../src/ahb/ {../src/m64core/pci_m64core.v}          

#
# M64AHB 
#
vlog -work work {../src/ahb/psync.v}
vlog -work work {../src/ahb/dma64_fiforam.v}  
vlog -work work {../src/ahb/dma64wrfifo.v}  
vlog -work work {../src/ahb/dma64rdfifo.v}  
vlog -work work {../src/ahb/dma64txctrl.v}  
vlog -work work {../src/ahb/dma64regs.v}  
vlog -work work {../src/ahb/fifosram.v}
vlog -work work {../src/ahb/fifo_async.v}
vlog -work work +incdir+../src/ahb/ {../src/ahb/t64ahb.v}
vlog -work work {../src/ahb/intctrl.v}
vlog -work work {../src/ahb/mailbox.v}
vlog -work work {../src/ahb/mailboxblk.v}
vlog -work work {../src/ahb/ahbslave.v}
vlog -work work {../src/ahb/ahbmaster.v}
vlog -work work {../src/ahb/dma64ahb.v}
vlog -work work +incdir+../src/ahb/ {../src/ahb/mt64ahb.v}
vlog -work work {../src/ahb/pcim64ahb.v}
vlog -work work {../src/ahb/pcim64ahbw.v}
#
# Testbench compile
#
vlog -work work +incdir+../tb {../tb/pci_master64model.v}
vlog -work work +incdir+../tb {../tb/pci64_busmonitor.v}
vlog -work work {../tb/pci_arbiter_model.v} 
vlog -work work +incdir+../tb {../tb/pci_target64model.v}
vlog -work work +incdir+../tb {../tb/ahbslaveram_model.v}
vlog -work work +incdir+../tb {../tb/pci_m64w_tb.v} 
#
# Load design for simulation (batch mode)
#
#vsim -c pcim64ahbw_tb -do "run -all; quit"
#
# Load design for simulation (interactive mode)
#
#vsim pcim64ahbw_tb 
#
# open waveform window
#do ../scripts/wave_mti.do 
#
# simulate
#run -all   
