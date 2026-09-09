#----------------------------------------------------------------------
#--  This confidential and proprietary software may be used only as
#--  authorised by a licensing agreement from ARM Limited
#--    (C) COPYRIGHT 2001-2002 ARM Limited
#--        ALL RIGHTS RESERVED
#--  The entire notice above must be reproduced on all authorised
#--  copies and copies may only be made to the extent permitted
#--  by a licensing agreement from ARM Limited.
#--
#-- Version and Release Control Information:
#--
#-- File Name     : $RCSfile: arm946example_constraints.tcl,v $
#-- File Revision : $Revision: 1.1 $
#--
#-- Release Information : $State: Rel $
#--
#----------------------------------------------------------------------
#
# Purpose 	: Constraint file for the ARM946E_8888
#


if { $signoff} {
    # Define postlayout clock latency values (from STA report)
    set latency_fmax 0.000  ;# CLK fastest @ max
    set latency_fmin 0.000  ;# CLK fastest @ min
}

# all min/max delays                                             


set_output_delay 0 -min -clock CLK [all_outputs]
set_output_delay [expr ( ${clk_period} * 0.1 - $latency_fmax ) ]  -max -clock CLK [all_outputs]
set_output_delay [expr ( ${clk_period} * 0.1 - $latency_fmax ) ]  -max -clock CLK [all_outputs]

# AHB interface                                              

set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list HADDR ]  
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list HTRANS ] 
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list HBURST ]  
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list HWRITE ]   
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list HSIZE ]  
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list HPROT ]  
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list HWDATA ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list HBUSREQ ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list HLOCK ]

# Coprocessor interface                                      

set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list CPCLKEN ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list CPINSTR ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list CPDOUT ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list CPPASS ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list CPLATECANCEL ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list CPTBIT ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list nCPMREQ ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list nCPTRANS ]
  
# Debug interface                                            

set_output_delay [expr ( ${clk_period} - ((1 - 0.40) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list COMMRX ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.40) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list COMMTX ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.40) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGACK ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.55) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGRQI ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGINSTREXEC ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.20) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGRNG ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.35) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGTDO ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.75) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGIR ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGSCREG ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGTAPSM ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.60) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGnTDOEN ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.80) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list DBGSDIN ]

# ETM interface                                              

set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMBIGEND ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMHIVECS ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMnWAIT ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMIA ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMInMREQ ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMISEQ ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMITBIT ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMIABORT ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMID31To25 ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMID15To11 ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMDA ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMWDATA ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMDMAS ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMDMORE ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMDnMREQ ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMDnRW ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMDSEQ ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMRDATA ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMDABORT ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMCHSD ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMCHSE ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMLATECANCEL ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMPASS ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMDBGACK ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMINSTREXEC ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMRNGOUT ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMINSTRVALID ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMPROCID ]
set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list ETMPROCIDWR ]

# Misc Signals                                               

set_output_delay [expr ( ${clk_period} - ((1 - 0.70) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list BIGENDOUT ]

# Scan Interface                                             

set_output_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) - $latency_fmax)] -max -clock CLK [ list SO ]

# All min delay                                              

set_input_delay [expr (0 + $latency_fmin)] -min -clock CLK [remove_from_collection [all_inputs] CLK]

set_input_delay 0.0 -max -clock CLK [ list DCacheSize ]
set_input_delay 0.0 -max -clock CLK [ list ICacheSize ]
set_drive 0 DCacheSize
set_drive 0 ICacheSize

# AHB interface                                              

# the following are for a 1:1 CLK HCLK ratio 
set_input_delay [expr ( ${clk_period} - ((1 - 0.60) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list HREADY ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.60) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list HRESP ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.60) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list HRDATA ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.60) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list HGRANT ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list HRESETn ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.15) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list HCLKEN ]

# Misc Signals                                               

set_input_delay [expr ( ${clk_period} - ((1 - 0.85) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list nFIQ ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.85) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list nIRQ ]

# Initialisation Control                                     

set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list VINITHI ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list INITRAM ]

# Coprocessor interface signals                              

set_input_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list CPDIN ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list CHSDE ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list CHSEX ]

# TCM Interface
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list PhyITCMSize ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list PhyDTCMSize ]

# Debug interface                                            

set_input_delay [expr ( ${clk_period} - ((1 - 0.65) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list DBGEN ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.80) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list EDBGRQ ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.85) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list DBGEXT ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list DBGIEBKPT ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list DBGDEWPT ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.75) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list DBGnTRST ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list DBGTCKEN ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.75) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list DBGTDI ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.75) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list DBGTMS ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list DBGSDOUT ]

set_input_delay [expr ( ${clk_period} - ((1 - 0.65) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list TAPID ] 

# ETM interface                                              

set_input_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list ETMEN ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list ETMFIFOFULL ]

# Scan Interface                                             

set_input_delay [expr ( ${clk_period} - ((1 - 0.50) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list SI ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list SCANEN ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list TESTMODE ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list SERIALEN ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list TESTEN ]
set_input_delay [expr ( ${clk_period} - ((1 - 0.10) * ${io_clk_period}) + $latency_fmax)] -max -clock CLK [ list INnotEXTEST ]

remove_input_delay CLK

