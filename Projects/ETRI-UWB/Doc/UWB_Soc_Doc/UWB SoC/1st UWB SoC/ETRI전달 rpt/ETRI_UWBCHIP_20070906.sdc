#####################################################

#  Created by Design Compiler write_sdc on Thu Sep  6 00:57:38 2007

#####################################################
set sdc_version 1.4
##TOP##
create_clock -name "MPllOut" -period 1.262 -waveform {0 0.631} [get_pins {uPlatform/uCore/PMTop/PMPLL/MPll/FOUT}]
create_generated_clock -name "MClk198" -source [get_pins {uPlatform/uCore/PMTop/PMPLL/MPll/FOUT}] -divide_by 4 [get_pins {uPlatform/uCore/PMTop/PMCtl/SRCMUX/Y}]
create_generated_clock -name "MAC132" -source [get_pins {uPlatform/uCore/PMTop/PMPLL/MPll/FOUT}] -divide_by 6 [get_pins {uPlatform/uCore/PMTop/PMCtl/MSRCMUX/Y}]
create_generated_clock -name "MSRCLK198" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/SRCMUX/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/SRCBUF/Y}]
create_generated_clock -name "CpuClkOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/SRCBUF/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/CPUBUF/Y}]
create_generated_clock -name "SysClk" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/SRCBUF/Y}] -divide_by 2 [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock1/Y}]

#create_generated_clock -name "SysClkOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock1/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/SYSBUF/Y}]
create_generated_clock -name "SysClkOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock1/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/U10/Y}]

#create_generated_clock -name "DDRClk1xOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock1/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/DDR1XBUF/Y}]
create_generated_clock -name "DDRClk1xOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock1/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/U6/Y}]

create_generated_clock -name "nDDRClk1xOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock1/Y}] -divide_by 1 -invert [get_pins {uPlatform/uCore/PMTop/PMCtl/IDDR1XBUF/Y}]
create_generated_clock -name "DDRClk2xOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/SRCBUF/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/DDR2XBUF/Y}]
create_generated_clock -name "nDDRClk2xOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/SRCBUF/Y}] -divide_by 1 -invert [get_pins {uPlatform/uCore/PMTop/PMCtl/IDDR2XBUF/Y}]
create_generated_clock -name "PeriClk" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock1/Y}] -divide_by 2 [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock3/Y}]

#create_generated_clock -name "PeriClkOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock3/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/PERI1XBUF/Y}]
create_generated_clock -name "PeriClkOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock3/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/U5/Y}]

#create_generated_clock -name "PeriClk2xOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock1/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/PERI2XBUF/Y}]
create_generated_clock -name "PeriClk2xOut" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_clock1/Y}] -divide_by 1 [get_pins {uPlatform/uCore/PMTop/PMCtl/U8/Y}]

##MAC##
create_generated_clock -name "MAC66CLK" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/MSRCMUX/Y}] -divide_by 2 [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_MacClk/Y}]
create_generated_clock -name "MAC33CLK" -source [get_pins {uPlatform/uCore/PMTop/PMCtl/MSRCMUX/Y}] -divide_by 4 [get_pins {uPlatform/uCore/PMTop/PMCtl/fix_MacCpuClk/Y}]

##PCI##
create_clock -name "PCI_CLK" -period 1.262 -waveform {0 0.631} [get_pins {P_PCI_CLKi/C}]

##Modem##
create_clock -name "ECLK" -period 26.4 -waveform {0 13.2} [get_pins {uUWBTOP/eCLK}]
create_clock -name "TCLK" -period 44 -waveform {0 22} [get_pins {uUWBTOP/TCLK}]

#create_clock -name "iCLKx2" -period 3.3 -waveform {0 1.65} [get_pins {uUWBTOP/I_H2TOP/I_H2CGEN/iCLKx2}]
create_clock -name "iCLKx2" -period 3.3 -waveform {0 1.65} [get_pins {uUWBTOP/I_H2TOP/I_H2IP/U_iCLKx2/Y}]
#create_clock -name "iCLK4" -period 6.6 -waveform {0 3.3} [get_pins {uUWBTOP/I_H2TOP/I_H2CGEN/iCLK4}]
create_generated_clock -name "iCLK4" -source  [get_pins {uUWBTOP/I_H2TOP/I_H2IP/U_iCLKx2/Y}] -divide_by 2  [get_pins {uUWBTOP/I_H2TOP/I_H2CGEN/U3/Y}]
#create_generated_clock -name "iCLK4" -source  [get_pins {uUWBTOP/I_H2TOP/I_H2CGEN/iCLKx2}]  -divide_by 2  [get_pins {uUWBTOP/I_H2TOP/I_H2CGEN/iCLK4}]

#create_clock -name "MAC_PCLK" -period 13.2 -waveform {0 6.6} [get_pins {uUWBTOP/I_H2TOP/mac_pclk}]
create_generated_clock -name "MAC_PCLK" -source  [get_pins {uUWBTOP/I_H2TOP/I_H2CGEN/iCLK4}] -divide_by 2 [get_pins {uUWBTOP/I_H2TOP/I_H2CORE/U32/Y}]


create_clock -name "PLLCLK" -period 1.65 -waveform {0 0.825} [get_pins {uUWBTOP/I_H2TOP/I_H2IP/I_PLL/FOUT}]
create_clock -name "vc_PCLK" -period 3.3 -waveform {0 1.65} 
create_clock -name "vc_iCLK4" -period 6.6 -waveform {0 3.3} 

create_clock -name "mac1us_clk" -period 1000 -waveform {0 500} [get_pins {uUWBTOP/MACTOP_MODULE/A_MACCORE_TOP/B_PC/C_SFC/sys_uclk}]

set_input_delay 10 -max -clock "vc_PCLK" [get_ports {SDATA}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {SDATA}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {MDATA[0]}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {MDATA[0]}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {MDATA[1]}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {MDATA[1]}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {MDATA[2]}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {MDATA[2]}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {MDATA[3]}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {MDATA[3]}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {MDATA[4]}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {MDATA[4]}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {MDATA[5]}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {MDATA[5]}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {MDATA[6]}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {MDATA[6]}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {MDATA[7]}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {MDATA[7]}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {RXEN}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {RXEN}]
set_input_delay 10 -max -clock "vc_PCLK" [get_ports {TXEN}]
set_input_delay 3 -min -clock "vc_PCLK" [get_ports {TXEN}]

set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_INTD}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_INTD}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_INTC}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_INTC}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_INTB}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_INTB}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_INTA}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_INTA}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_TRDY}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_TRDY}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_STOP}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_STOP}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_PERR}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_PERR}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_PAR}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_PAR}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_IRDY}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_IRDY}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_FRAME}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_FRAME}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_DEVSEL}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_DEVSEL}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_CBE[0]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_CBE[0]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_CBE[1]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_CBE[1]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_CBE[2]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_CBE[2]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_CBE[3]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_CBE[3]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[0]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[0]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[1]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[1]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[2]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[2]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[3]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[3]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[4]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[4]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[5]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[5]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[6]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[6]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[7]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[7]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[8]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[8]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[9]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[9]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[10]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[10]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[11]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[11]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[12]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[12]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[13]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[13]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[14]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[14]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[15]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[15]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[16]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[16]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[17]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[17]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[18]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[18]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[19]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[19]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[20]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[20]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[21]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[21]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[22]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[22]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[23]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[23]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[24]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[24]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[25]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[25]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[26]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[26]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[27]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[27]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[28]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[28]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[29]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[29]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[30]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[30]}]
set_input_delay 3.0288 -max -clock "PCI_CLK" [get_ports {PCI_AD[31]}]
set_input_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[31]}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {SPI_nSS}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {SPI_nSS}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {SPI_SCK}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {SPI_SCK}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {SPI_SDI}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {SPI_SDI}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {SPI_SDO}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {SPI_SDO}]
set_input_delay 1.5144 -max -clock "CpuClkOut" [get_ports {ARMICE_TDI}]
set_input_delay 0 -min -clock "CpuClkOut" [get_ports {ARMICE_TDI}]
set_input_delay 1.5144 -max -clock "CpuClkOut" [get_ports {ARMICE_TMS}]
set_input_delay 0 -min -clock "CpuClkOut" [get_ports {ARMICE_TMS}]
set_input_delay 1.5144 -max -clock "CpuClkOut" [get_ports {ARMICE_TCK}]
set_input_delay 0 -min -clock "CpuClkOut" [get_ports {ARMICE_TCK}]
set_input_delay 1.5144 -max -clock "CpuClkOut" [get_ports {ARMICE_nTRST}]
set_input_delay 0 -min -clock "CpuClkOut" [get_ports {ARMICE_nTRST}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_RnB1}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_RnB1}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_RnB0}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_RnB0}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_nCE1}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_nCE1}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_ALE}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_ALE}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_CLE}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_CLE}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_IO[0]}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[0]}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_IO[1]}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[1]}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_IO[2]}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[2]}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_IO[3]}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[3]}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_IO[4]}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[4]}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_IO[5]}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[5]}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_IO[6]}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[6]}]
set_input_delay 10.096 -max -clock "PeriClk2xOut" [get_ports {NF_IO[7]}]
set_input_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[7]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_nCS[0]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_nCS[0]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_nCS[1]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_nCS[1]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_nCS[2]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_nCS[2]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_nCS[3]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_nCS[3]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[0]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[0]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[1]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[1]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[2]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[2]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[3]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[3]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[4]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[4]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[5]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[5]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[6]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[6]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[7]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[7]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[8]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[8]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[9]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[9]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[10]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[10]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[11]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[11]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[12]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[12]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[13]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[13]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[14]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[14]}]
set_input_delay 4.0384 -max -clock "SysClkOut" [get_ports {SMC_DATA[15]}]
set_input_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[15]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR3_0[0]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR3_0[0]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR3_0[1]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR3_0[1]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR3_0[2]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR3_0[2]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR3_0[3]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR3_0[3]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR26_20[20]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR26_20[20]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR26_20[21]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR26_20[21]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR26_20[22]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR26_20[22]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR26_20[23]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR26_20[23]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR26_20[24]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR26_20[24]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR26_20[25]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR26_20[25]}]
set_input_delay 4.0384 -max -clock "MPllOut" [get_ports {SMC_ADDR26_20[26]}]
set_input_delay 0 -min -clock "MPllOut" [get_ports {SMC_ADDR26_20[26]}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {GPIO0[0]}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[0]}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {GPIO0[1]}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[1]}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {GPIO0[2]}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[2]}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {GPIO0[3]}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[3]}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {GPIO0[4]}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[4]}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {GPIO0[5]}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[5]}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {GPIO0[6]}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[6]}]
set_input_delay 4.0384 -max -clock "PeriClkOut" [get_ports {GPIO0[7]}]
set_input_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[7]}]

set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG10}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG9}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG8}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG7}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG6}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG5}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG4}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG3}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG2}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG1}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SIG0}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RF_SPI_CLK}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RxGainQ[0]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RxGainQ[1]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RxGainQ[2]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RxGainQ[3]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RxGainQ[4]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {RxGainQ[5]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {Rx_FixAtten}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {TxAtten[0]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {TxAtten[1]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {TxAtten[2]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {TxAtten[3]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {TxAtten[4]}]
set_output_delay 1 -clock "vc_iCLK4" [get_ports {TxAtten[5]}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {SDATA}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {SDATA}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {MDATA[0]}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {MDATA[0]}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {MDATA[1]}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {MDATA[1]}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {MDATA[2]}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {MDATA[2]}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {MDATA[3]}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {MDATA[3]}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {MDATA[4]}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {MDATA[4]}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {MDATA[5]}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {MDATA[5]}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {MDATA[6]}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {MDATA[6]}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {MDATA[7]}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {MDATA[7]}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {DATAEN}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {DATAEN}]
set_output_delay 2 -max -clock "vc_PCLK" [get_ports {PHYACTIVE}]
set_output_delay 0 -min -clock "vc_PCLK" [get_ports {PHYACTIVE}]

set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_INTD}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_INTD}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_INTC}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_INTC}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_INTB}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_INTB}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_INTA}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_INTA}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_TRDY}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_TRDY}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_STOP}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_STOP}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_PERR}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_PERR}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_PAR}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_PAR}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_IRDY}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_IRDY}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_FRAME}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_FRAME}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_DEVSEL}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_DEVSEL}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_CBE[0]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_CBE[0]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_CBE[1]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_CBE[1]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_CBE[2]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_CBE[2]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_CBE[3]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_CBE[3]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[0]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[0]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[1]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[1]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[2]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[2]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[3]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[3]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[4]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[4]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[5]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[5]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[6]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[6]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[7]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[7]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[8]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[8]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[9]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[9]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[10]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[10]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[11]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[11]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[12]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[12]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[13]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[13]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[14]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[14]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[15]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[15]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[16]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[16]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[17]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[17]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[18]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[18]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[19]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[19]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[20]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[20]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[21]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[21]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[22]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[22]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[23]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[23]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[24]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[24]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[25]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[25]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[26]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[26]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[27]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[27]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[28]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[28]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[29]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[29]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[30]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[30]}]
set_output_delay 10.096 -max -clock "PCI_CLK" [get_ports {PCI_AD[31]}]
set_output_delay 0 -min -clock "PCI_CLK" [get_ports {PCI_AD[31]}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {SPI_nSS}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {SPI_nSS}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {SPI_SCK}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {SPI_SCK}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {SPI_SDI}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {SPI_SDI}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {SPI_SDO}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {SPI_SDO}]
set_output_delay 3.786 -max -clock "CpuClkOut" [get_ports {ARMICE_TDO}]
set_output_delay 0 -min -clock "CpuClkOut" [get_ports {ARMICE_TDO}]
set_output_delay 3.786 -max -clock "CpuClkOut" [get_ports {ARMICE_RTCK}]
set_output_delay 0 -min -clock "CpuClkOut" [get_ports {ARMICE_RTCK}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_RnB1}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_RnB1}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_nCE1}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_nCE1}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_ALE}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_ALE}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_CLE}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_CLE}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_IO[0]}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[0]}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_IO[1]}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[1]}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_IO[2]}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[2]}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_IO[3]}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[3]}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_IO[4]}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[4]}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_IO[5]}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[5]}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_IO[6]}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[6]}]
set_output_delay 5.048 -max -clock "PeriClk2xOut" [get_ports {NF_IO[7]}]
set_output_delay 0 -min -clock "PeriClk2xOut" [get_ports {NF_IO[7]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_nWR[0]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_nWR[0]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_nWR[1]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_nWR[1]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_nOE}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_nOE}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_nCS[0]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_nCS[0]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_nCS[1]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_nCS[1]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_nCS[2]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_nCS[2]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_nCS[3]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_nCS[3]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[0]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[0]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[1]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[1]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[2]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[2]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[3]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[3]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[4]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[4]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[5]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[5]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[6]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[6]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[7]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[7]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[8]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[8]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[9]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[9]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[10]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[10]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[11]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[11]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[12]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[12]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[13]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[13]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[14]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[14]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_DATA[15]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_DATA[15]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR3_0[0]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR3_0[0]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR3_0[1]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR3_0[1]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR3_0[2]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR3_0[2]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR3_0[3]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR3_0[3]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[4]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[4]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[5]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[5]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[6]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[6]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[7]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[7]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[8]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[8]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[9]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[9]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[10]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[10]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[11]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[11]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[12]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[12]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[13]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[13]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[14]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[14]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[15]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[15]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[16]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[16]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[17]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[17]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[18]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[18]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR[19]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR[19]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR26_20[20]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR26_20[20]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR26_20[21]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR26_20[21]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR26_20[22]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR26_20[22]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR26_20[23]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR26_20[23]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR26_20[24]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR26_20[24]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR26_20[25]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR26_20[25]}]
set_output_delay 5.048 -max -clock "SysClkOut" [get_ports {SMC_ADDR26_20[26]}]
set_output_delay 0 -min -clock "SysClkOut" [get_ports {SMC_ADDR26_20[26]}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {GPIO0[0]}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[0]}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {GPIO0[1]}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[1]}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {GPIO0[2]}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[2]}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {GPIO0[3]}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[3]}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {GPIO0[4]}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[4]}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {GPIO0[5]}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[5]}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {GPIO0[6]}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[6]}]
set_output_delay 10.096 -max -clock "PeriClkOut" [get_ports {GPIO0[7]}]
set_output_delay 0 -min -clock "PeriClkOut" [get_ports {GPIO0[7]}]
set_output_delay 5.048 -max -clock "DDRClk2xOut" [get_ports {DDR_DQS[0]}]
set_output_delay 0 -min -clock "DDRClk2xOut" [get_ports {DDR_DQS[0]}]
set_output_delay 5.048 -max -clock "DDRClk2xOut" [get_ports {DDR_DQS[1]}]
set_output_delay 0 -min -clock "DDRClk2xOut" [get_ports {DDR_DQS[1]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_DQM[0]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_DQM[0]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_DQM[1]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_DQM[1]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[0]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[0]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[1]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[1]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[2]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[2]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[3]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[3]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[4]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[4]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[5]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[5]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[6]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[6]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[7]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[7]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[8]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[8]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[9]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[9]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[10]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[10]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[11]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[11]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[12]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[12]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[13]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[13]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[14]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[14]}]
set_output_delay 5.048 -max -clock "nDDRClk2xOut" [get_ports {DDR_DQ[15]}]
set_output_delay 0 -min -clock "nDDRClk2xOut" [get_ports {DDR_DQ[15]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[0]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[0]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[1]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[1]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[2]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[2]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[3]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[3]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[4]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[4]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[5]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[5]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[6]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[6]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[7]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[7]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[8]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[8]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[9]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[9]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[10]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[10]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[11]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[11]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_ADDR[12]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_ADDR[12]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_BADDR[0]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_BADDR[0]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_BADDR[1]}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_BADDR[1]}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_WEB}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_WEB}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_CASB}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_CASB}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_RASB}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_RASB}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_CSB}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_CSB}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_CKE}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_CKE}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_nCLK}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_nCLK}]
set_output_delay 5.048 -max -clock "DDRClk1xOut" [get_ports {DDR_CLK}]
set_output_delay 0 -min -clock "DDRClk1xOut" [get_ports {DDR_CLK}]


set_false_path\
	-from    [get_ports {PRST}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]
set_false_path\
	-from    [get_ports {PMODE[0]}]
set_false_path\
	-from    [get_ports {CLKMODE}]
set_false_path\
	-from    [get_pins {uPlatform/uCore/PMTop/RstCtl/CPUBUF/Y}]
set_false_path\
	-from    [get_pins {uPlatform/uCore/PMTop/RstCtl/MACBUF/Y}]
set_false_path\
	-from    [get_pins {uPlatform/uCore/PMTop/RstCtl/DMABUF/Y}]
set_false_path\
	-from    [get_pins {uPlatform/uCore/PMTop/RstCtl/PCIBUF/Y}]
set_false_path\
	-from    [get_pins {uPlatform/uCore/PMTop/RstCtl/NANDBUF/Y}]
set_false_path\
	-from    [get_pins {uPlatform/uCore/PMTop/RstCtl/DDRBUF/Y}]
set_false_path\
	-from    [get_pins {uPlatform/uCore/PMTop/RstCtl/I2SBUF/Y}]
set_false_path\
	-from    [get_pins {uPlatform/uCore/PMTop/RstCtl/UARTBUF/Y}]
set_false_path\
	-from    [get_pins {uPlatform/uCore/PMTop/RstCtl/ETCBUF/Y}]
set_clock_transition -rise 0.4 [get_clocks {MPllOut}]
set_clock_transition -fall 0.4 [get_clocks {MPllOut}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {MPllOut}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {MPllOut}]
set_clock_transition -rise 0.4 [get_clocks {MClk198}]
set_clock_transition -fall 0.4 [get_clocks {MClk198}]
set_clock_uncertainty  0.25 -setup [get_clocks {MClk198}]
set_clock_uncertainty  0.3 -hold [get_clocks {MClk198}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {MClk198}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {MClk198}]
set_clock_transition -rise 0.4 [get_clocks {MAC132}]
set_clock_transition -fall 0.4 [get_clocks {MAC132}]
set_clock_uncertainty  0.25 -setup [get_clocks {MAC132}]
set_clock_uncertainty  0.3 -hold [get_clocks {MAC132}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {MAC132}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {MAC132}]
set_clock_transition -rise 0.4 [get_clocks {MSRCLK198}]
set_clock_transition -fall 0.4 [get_clocks {MSRCLK198}]
set_clock_uncertainty  0.25 -setup [get_clocks {MSRCLK198}]
set_clock_uncertainty  0.3 -hold [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {MSRCLK198}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {MSRCLK198}]
set_clock_transition -rise 0.4 [get_clocks {CpuClkOut}]
set_clock_transition -fall 0.4 [get_clocks {CpuClkOut}]
set_clock_uncertainty  0.25 -setup [get_clocks {CpuClkOut}]
set_clock_uncertainty  0.3 -hold [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {CpuClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {CpuClkOut}]
set_clock_transition -rise 0.4 [get_clocks {SysClk}]
set_clock_transition -fall 0.4 [get_clocks {SysClk}]
set_clock_uncertainty  0.25 -setup [get_clocks {SysClk}]
set_clock_uncertainty  0.3 -hold [get_clocks {SysClk}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {SysClk}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {SysClk}]
set_clock_transition -rise 1 [get_clocks {SysClkOut}]
set_clock_transition -fall 1 [get_clocks {SysClkOut}]
set_clock_uncertainty  0.5 -setup [get_clocks {SysClkOut}]
set_clock_uncertainty  0.25 -hold [get_clocks {SysClkOut}]
##set_clock_latency  3 -max [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {SysClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {SysClkOut}]
set_clock_transition -rise 0.4 [get_clocks {DDRClk1xOut}]
set_clock_transition -fall 0.4 [get_clocks {DDRClk1xOut}]
set_clock_uncertainty  0.25 -setup [get_clocks {DDRClk1xOut}]
set_clock_uncertainty  0.3 -hold [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {DDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {DDRClk1xOut}]
set_clock_transition -rise 0.4 [get_clocks {nDDRClk1xOut}]
set_clock_transition -fall 0.4 [get_clocks {nDDRClk1xOut}]
set_clock_uncertainty  0.25 -setup [get_clocks {nDDRClk1xOut}]
set_clock_uncertainty  0.3 -hold [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {nDDRClk1xOut}]
set_clock_transition -rise 0.4 [get_clocks {DDRClk2xOut}]
set_clock_transition -fall 0.4 [get_clocks {DDRClk2xOut}]
set_clock_uncertainty  0.25 -setup [get_clocks {DDRClk2xOut}]
set_clock_uncertainty  0.3 -hold [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {DDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {DDRClk2xOut}]
set_clock_transition -rise 0.4 [get_clocks {nDDRClk2xOut}]
set_clock_transition -fall 0.4 [get_clocks {nDDRClk2xOut}]
set_clock_uncertainty  0.25 -setup [get_clocks {nDDRClk2xOut}]
set_clock_uncertainty  0.3 -hold [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {nDDRClk2xOut}]
set_clock_transition -rise 0.4 [get_clocks {PeriClk}]
set_clock_transition -fall 0.4 [get_clocks {PeriClk}]
set_clock_uncertainty  0.25 -setup [get_clocks {PeriClk}]
set_clock_uncertainty  0.3 -hold [get_clocks {PeriClk}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {PeriClk}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {PeriClk}]
set_clock_transition -rise 0.4 [get_clocks {PeriClkOut}]
set_clock_transition -fall 0.4 [get_clocks {PeriClkOut}]
set_clock_uncertainty  0.25 -setup [get_clocks {PeriClkOut}]
set_clock_uncertainty  0.3 -hold [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {PeriClkOut}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {PeriClkOut}]
set_clock_transition -rise 0.4 [get_clocks {PeriClk2xOut}]
set_clock_transition -fall 0.4 [get_clocks {PeriClk2xOut}]
set_clock_uncertainty  0.25 -setup [get_clocks {PeriClk2xOut}]
set_clock_uncertainty  0.3 -hold [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {PeriClk2xOut}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {PeriClk2xOut}]
set_clock_transition -rise 0.4 [get_clocks {MAC66CLK}]
set_clock_transition -fall 0.4 [get_clocks {MAC66CLK}]
set_clock_uncertainty  0.25 -setup [get_clocks {MAC66CLK}]
set_clock_uncertainty  0.3 -hold [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {CLK33M}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {nRESET}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {ScanEn}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {BistEn}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {BClk}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DFT_NC}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {TestMode[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {TestMode[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {TestMode[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[4]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[5]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[6]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[7]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[8]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[9]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[10]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[11]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[12]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[13]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[14]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[15]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {GPIO0[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {GPIO0[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {GPIO0[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {GPIO0[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {GPIO0[4]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {GPIO0[5]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {GPIO0[6]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {GPIO0[7]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[20]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[21]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[22]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[23]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[24]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[25]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[26]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[4]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[5]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[6]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[7]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[8]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[9]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[10]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[11]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[12]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[13]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[14]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[15]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {RXD_0}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {RXD_1}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {TXD_1}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {I2C_SDA}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {I2C_SCL}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_IO[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_IO[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_IO[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_IO[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_IO[4]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_IO[5]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_IO[6]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_IO[7]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_CLE}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_ALE}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_nCE1}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_RnB0}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {NF_RnB1}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {ARMICE_nSRST}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {ARMICE_nTRST}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {ARMICE_TCK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {ARMICE_TMS}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {ARMICE_TDI}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SPI_SDO}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SPI_SDI}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SPI_SCK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {SPI_nSS}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {I2S_MCLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {I2S_BCLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {I2S_LRCLK}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {I2S_SDO}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {I2S_SDI}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[0]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[1]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[2]}]\
	-to      [get_clocks {MAC66CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[3]}]\
	-to      [get_clocks {MAC66CLK}]
set_clock_transition -rise 0.4 [get_clocks {MAC33CLK}]
set_clock_transition -fall 0.4 [get_clocks {MAC33CLK}]
set_clock_uncertainty  0.25 -setup [get_clocks {MAC33CLK}]
set_clock_uncertainty  0.3 -hold [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {CLK33M}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {nRESET}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {ScanEn}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {BistEn}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {BClk}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DFT_NC}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {TestMode[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {TestMode[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {TestMode[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[4]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[5]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[6]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[7]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[8]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[9]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[10]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[11]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[12]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[13]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[14]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[15]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {GPIO0[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {GPIO0[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {GPIO0[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {GPIO0[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {GPIO0[4]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {GPIO0[5]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {GPIO0[6]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {GPIO0[7]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[20]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[21]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[22]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[23]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[24]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[25]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[26]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[4]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[5]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[6]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[7]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[8]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[9]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[10]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[11]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[12]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[13]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[14]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[15]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {RXD_0}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {RXD_1}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {TXD_1}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {I2C_SDA}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {I2C_SCL}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_IO[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_IO[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_IO[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_IO[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_IO[4]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_IO[5]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_IO[6]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_IO[7]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_CLE}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_ALE}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_nCE1}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_RnB0}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {NF_RnB1}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {ARMICE_nSRST}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {ARMICE_nTRST}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {ARMICE_TCK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {ARMICE_TMS}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {ARMICE_TDI}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SPI_SDO}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SPI_SDI}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SPI_SCK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {SPI_nSS}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {I2S_MCLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {I2S_BCLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {I2S_LRCLK}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {I2S_SDO}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {I2S_SDI}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[0]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[1]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[2]}]\
	-to      [get_clocks {MAC33CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[3]}]\
	-to      [get_clocks {MAC33CLK}]
set_clock_transition -rise 0.4 [get_clocks {PCI_CLK}]
set_clock_transition -fall 0.4 [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MSEL[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MSEL[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {PRST}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {TXEN}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {RXEN}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {PCLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {PHYACTIVE}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DATAEN}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {CCASTATUS}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MDATA[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MDATA[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MDATA[2]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MDATA[3]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MDATA[4]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MDATA[5]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MDATA[6]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {MDATA[7]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SDATA}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {nRST}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {eCLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {CLKSEL[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {CLKSEL[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {TCLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {RFSEL}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {PMODE[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {PMODE[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {CLKMODE}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {CLK33M}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {nRESET}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {ScanEn}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {BistEn}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {BClk}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DFT_NC}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {TestMode[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {TestMode[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {TestMode[2]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[2]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[3]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[4]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[5]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[6]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[7]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[8]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[9]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[10]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[11]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[12]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[13]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[14]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[15]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {GPIO0[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {GPIO0[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {GPIO0[2]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {GPIO0[3]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {GPIO0[4]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {GPIO0[5]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {GPIO0[6]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {GPIO0[7]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[20]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[21]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[22]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[23]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[24]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[25]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[26]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[2]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[3]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[2]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[3]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[4]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[5]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[6]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[7]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[8]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[9]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[10]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[11]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[12]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[13]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[14]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[15]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[2]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[3]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {RXD_0}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {RXD_1}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {TXD_1}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {I2C_SDA}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {I2C_SCL}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_IO[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_IO[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_IO[2]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_IO[3]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_IO[4]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_IO[5]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_IO[6]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_IO[7]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_CLE}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_ALE}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_nCE1}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_RnB0}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {NF_RnB1}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {ARMICE_nSRST}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {ARMICE_nTRST}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {ARMICE_TCK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {ARMICE_TMS}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {ARMICE_TDI}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SPI_SDO}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SPI_SDI}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SPI_SCK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {SPI_nSS}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {I2S_MCLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {I2S_BCLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {I2S_LRCLK}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {I2S_SDO}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {I2S_SDI}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[0]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[1]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[2]}]\
	-to      [get_clocks {PCI_CLK}]
set_false_path\
	-from    [get_ports {EXT_INT[3]}]\
	-to      [get_clocks {PCI_CLK}]
set_clock_transition -rise 1 [get_clocks {ECLK}]
set_clock_transition -fall 1 [get_clocks {ECLK}]
set_clock_uncertainty  0.5 -setup [get_clocks {ECLK}]
set_clock_uncertainty  0.25 -hold [get_clocks {ECLK}]
#set_clock_latency  1 -max [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {CLK33M}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {nRESET}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {ScanEn}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {BistEn}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {BClk}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DFT_NC}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {TestMode[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {TestMode[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {TestMode[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[4]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[5]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[6]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[7]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[8]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[9]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[10]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[11]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[12]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[13]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[14]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[15]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {GPIO0[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {GPIO0[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {GPIO0[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {GPIO0[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {GPIO0[4]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {GPIO0[5]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {GPIO0[6]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {GPIO0[7]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[20]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[21]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[22]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[23]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[24]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[25]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[26]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[4]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[5]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[6]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[7]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[8]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[9]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[10]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[11]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[12]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[13]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[14]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[15]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {RXD_0}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {RXD_1}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {TXD_1}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {I2C_SDA}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {I2C_SCL}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_IO[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_IO[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_IO[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_IO[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_IO[4]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_IO[5]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_IO[6]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_IO[7]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_CLE}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_ALE}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_nCE1}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_RnB0}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {NF_RnB1}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {ARMICE_nSRST}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {ARMICE_nTRST}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {ARMICE_TCK}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {ARMICE_TMS}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {ARMICE_TDI}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SPI_SDO}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SPI_SDI}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SPI_SCK}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {SPI_nSS}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {I2S_MCLK}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {I2S_BCLK}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {I2S_LRCLK}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {I2S_SDO}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {I2S_SDI}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {EXT_INT[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {EXT_INT[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {EXT_INT[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {EXT_INT[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {ECLK}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {ECLK}]
set_clock_transition -rise 1 [get_clocks {TCLK}]
set_clock_transition -fall 1 [get_clocks {TCLK}]
set_clock_uncertainty  0.5 -setup [get_clocks {TCLK}]
set_clock_uncertainty  0.25 -hold [get_clocks {TCLK}]
#set_clock_latency  3 -max [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {vc_PCLK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {CLK33M}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {nRESET}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {ScanEn}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {BistEn}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {BClk}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DFT_NC}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {TestMode[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {TestMode[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {TestMode[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[4]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[5]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[6]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[7]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[8]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[9]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[10]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[11]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[12]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[13]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[14]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[15]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {GPIO0[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {GPIO0[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {GPIO0[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {GPIO0[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {GPIO0[4]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {GPIO0[5]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {GPIO0[6]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {GPIO0[7]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[20]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[21]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[22]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[23]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[24]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[25]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[26]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[4]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[5]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[6]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[7]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[8]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[9]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[10]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[11]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[12]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[13]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[14]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[15]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {RXD_0}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {RXD_1}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {TXD_1}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {I2C_SDA}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {I2C_SCL}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_IO[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_IO[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_IO[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_IO[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_IO[4]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_IO[5]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_IO[6]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_IO[7]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_CLE}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_ALE}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_nCE1}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_RnB0}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {NF_RnB1}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {ARMICE_nSRST}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {ARMICE_nTRST}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {ARMICE_TCK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {ARMICE_TMS}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {ARMICE_TDI}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SPI_SDO}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SPI_SDI}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SPI_SCK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {SPI_nSS}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {I2S_MCLK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {I2S_BCLK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {I2S_LRCLK}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {I2S_SDO}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {I2S_SDI}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {EXT_INT[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {EXT_INT[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {EXT_INT[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {EXT_INT[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {TCLK}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {TCLK}]
set_clock_transition -rise 1 [get_clocks {iCLK4}]
set_clock_transition -fall 1 [get_clocks {iCLK4}]
set_clock_uncertainty  0.5 -setup [get_clocks {iCLK4}]
set_clock_uncertainty  0.25 -hold [get_clocks {iCLK4}]
set_clock_uncertainty -to iCLK4 -from iCLKx2 0.3 -rise
#set_clock_latency  3 -max [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {CLK33M}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {nRESET}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {ScanEn}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {BistEn}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {BClk}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DFT_NC}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {TestMode[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {TestMode[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {TestMode[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[4]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[5]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[6]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[7]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[8]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[9]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[10]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[11]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[12]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[13]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[14]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQ[15]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQS[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {DDR_DQS[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {GPIO0[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {GPIO0[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {GPIO0[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {GPIO0[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {GPIO0[4]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {GPIO0[5]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {GPIO0[6]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {GPIO0[7]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[20]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[21]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[22]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[23]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[24]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[25]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[26]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[4]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[5]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[6]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[7]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[8]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[9]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[10]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[11]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[12]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[13]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[14]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_DATA[15]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_nCS[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_nCS[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_nCS[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SMC_nCS[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {RXD_0}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {RXD_1}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {TXD_1}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {I2C_SDA}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {I2C_SCL}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_IO[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_IO[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_IO[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_IO[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_IO[4]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_IO[5]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_IO[6]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_IO[7]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_CLE}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_ALE}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_nCE1}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_RnB0}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {NF_RnB1}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {ARMICE_nSRST}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {ARMICE_nTRST}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {ARMICE_TCK}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {ARMICE_TMS}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {ARMICE_TDI}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SPI_SDO}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SPI_SDI}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SPI_SCK}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {SPI_nSS}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {I2S_MCLK}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {I2S_BCLK}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {I2S_LRCLK}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {I2S_SDO}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {I2S_SDI}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {EXT_INT[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {EXT_INT[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {EXT_INT[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {EXT_INT[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {iCLK4}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {iCLK4}]
set_clock_transition -rise 1 [get_clocks {iCLKx2}]
set_clock_transition -fall 1 [get_clocks {iCLKx2}]
set_clock_uncertainty  0.5 -setup [get_clocks {iCLKx2}]
set_clock_uncertainty  0.25 -hold [get_clocks {iCLKx2}]
set_clock_uncertainty -to iCLKx2 -from iCLK4 0.3 -rise
#set_clock_latency  3 -max [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {CLK33M}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {nRESET}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {ScanEn}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {BistEn}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {BClk}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DFT_NC}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {TestMode[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {TestMode[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {TestMode[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[4]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[5]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[6]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[7]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[8]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[9]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[10]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[11]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[12]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[13]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[14]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQ[15]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQS[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {DDR_DQS[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {GPIO0[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {GPIO0[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {GPIO0[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {GPIO0[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {GPIO0[4]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {GPIO0[5]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {GPIO0[6]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {GPIO0[7]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[20]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[21]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[22]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[23]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[24]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[25]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[26]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[4]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[5]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[6]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[7]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[8]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[9]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[10]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[11]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[12]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[13]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[14]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_DATA[15]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_nCS[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_nCS[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_nCS[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SMC_nCS[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {RXD_0}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {RXD_1}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {TXD_1}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {I2C_SDA}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {I2C_SCL}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_IO[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_IO[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_IO[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_IO[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_IO[4]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_IO[5]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_IO[6]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_IO[7]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_CLE}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_ALE}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_nCE1}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_RnB0}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {NF_RnB1}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {ARMICE_nSRST}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {ARMICE_nTRST}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {ARMICE_TCK}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {ARMICE_TMS}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {ARMICE_TDI}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SPI_SDO}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SPI_SDI}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SPI_SCK}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {SPI_nSS}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {I2S_MCLK}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {I2S_BCLK}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {I2S_LRCLK}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {I2S_SDO}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {I2S_SDI}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {EXT_INT[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {EXT_INT[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {EXT_INT[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {EXT_INT[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {iCLKx2}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {iCLKx2}]
set_clock_transition -rise 1 [get_clocks {PLLCLK}]
set_clock_transition -fall 1 [get_clocks {PLLCLK}]
set_clock_uncertainty  0.5 -setup [get_clocks {PLLCLK}]
set_clock_uncertainty  0.25 -hold [get_clocks {PLLCLK}]
#set_clock_latency  1 -max [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_clocks {MAC_PCLK}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {CLK33M}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {nRESET}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {ScanEn}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {BistEn}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {BClk}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DFT_NC}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {TestMode[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {TestMode[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {TestMode[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[4]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[5]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[6]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[7]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[8]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[9]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[10]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[11]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[12]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[13]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[14]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQ[15]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {DDR_DQS[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {GPIO0[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {GPIO0[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {GPIO0[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {GPIO0[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {GPIO0[4]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {GPIO0[5]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {GPIO0[6]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {GPIO0[7]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[20]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[21]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[22]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[23]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[24]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[25]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR26_20[26]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_ADDR3_0[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[4]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[5]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[6]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[7]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[8]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[9]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[10]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[11]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[12]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[13]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[14]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_DATA[15]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SMC_nCS[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {RXD_0}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {RXD_1}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {TXD_1}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {I2C_SDA}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {I2C_SCL}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_IO[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_IO[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_IO[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_IO[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_IO[4]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_IO[5]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_IO[6]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_IO[7]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_CLE}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_ALE}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_nCE1}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_RnB0}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {NF_RnB1}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {ARMICE_nSRST}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {ARMICE_nTRST}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {ARMICE_TCK}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {ARMICE_TMS}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {ARMICE_TDI}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SPI_SDO}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SPI_SDI}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SPI_SCK}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {SPI_nSS}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {I2S_MCLK}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {I2S_BCLK}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {I2S_LRCLK}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {I2S_SDO}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {I2S_SDI}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {EXT_INT[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {EXT_INT[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {EXT_INT[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {EXT_INT[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_CLKi}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_BRIDGE_GNT}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[4]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[5]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[6]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[7]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[8]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[9]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[10]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[11]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[12]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[13]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[14]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[15]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[16]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[17]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[18]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[19]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[20]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[21]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[22]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[23]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[24]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[25]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[26]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[27]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[28]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[29]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[30]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_AD[31]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_ARB_REQ[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[0]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[1]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[2]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_CBE[3]}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_IDSEL}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_DEVSEL}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_FRAME}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_IRDY}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_PAR}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_PERR}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_STOP}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_TRDY}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_INTA}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_INTB}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_INTC}]\
	-to      [get_clocks {PLLCLK}]
set_false_path\
	-from    [get_ports {PCI_INTD}]\
	-to      [get_clocks {PLLCLK}]
set_clock_transition -rise 1 [get_clocks {MAC_PCLK}]
set_clock_transition -fall 1 [get_clocks {MAC_PCLK}]
#set_clock_latency  3 -max [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_clocks {MAC_PCLK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_clocks {MAC_PCLK}]
set_clock_uncertainty  0.5 -setup [get_clocks {vc_PCLK}]
set_clock_uncertainty  0.25 -hold [get_clocks {vc_PCLK}]
#set_clock_latency  6 -max [get_clocks {vc_PCLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_clocks {vc_PCLK}]
set_clock_uncertainty  0.5 -setup [get_clocks {vc_iCLK4}]
set_clock_uncertainty  0.25 -hold [get_clocks {vc_iCLK4}]
#set_clock_latency  3 -max [get_clocks {vc_iCLK4}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_CLK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_CLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_CLK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_CLK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_CLK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_CLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_CLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_CLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_nCLK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_nCLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_nCLK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_nCLK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_nCLK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_nCLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_nCLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_nCLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_CKE}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_CKE}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_CKE}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_CKE}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_CKE}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_CKE}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_CKE}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_CKE}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_CSB}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_CSB}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_CSB}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_CSB}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_CSB}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_CSB}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_CSB}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_CSB}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_RASB}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_RASB}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_RASB}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_RASB}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_RASB}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_RASB}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_RASB}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_RASB}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_CASB}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_CASB}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_CASB}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_CASB}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_CASB}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_CASB}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_CASB}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_CASB}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_WEB}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_WEB}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_WEB}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_WEB}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_WEB}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_WEB}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_WEB}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_WEB}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_BADDR[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_BADDR[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_BADDR[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_BADDR[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_BADDR[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_BADDR[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_BADDR[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_BADDR[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_BADDR[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_BADDR[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_BADDR[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_BADDR[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_BADDR[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_BADDR[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_BADDR[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_BADDR[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[12]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[12]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[12]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[12]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[12]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[12]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[12]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[12]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[11]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[11]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[11]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[11]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[11]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[11]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[11]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[11]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[10]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[10]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[10]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[10]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[10]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[10]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[10]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[10]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[9]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[9]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[9]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[9]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[9]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[9]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[9]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[9]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[8]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[8]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[8]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[8]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[8]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[8]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[8]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[8]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[7]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[7]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[7]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[7]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[7]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[7]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[7]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[7]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[6]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[6]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[6]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[6]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[6]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[6]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[6]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[6]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[5]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[5]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[5]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[5]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[5]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[5]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[4]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[4]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[4]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[4]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[4]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[4]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_ADDR[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_ADDR[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_ADDR[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_ADDR[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_ADDR[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_ADDR[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_ADDR[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_ADDR[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[15]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[15]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[15]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[15]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[15]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[15]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[15]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[15]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[14]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[14]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[14]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[14]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[14]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[14]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[14]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[14]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[13]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[13]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[13]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[13]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[13]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[13]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[13]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[13]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[12]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[12]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[12]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[12]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[12]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[12]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[12]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[12]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[11]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[11]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[11]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[11]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[11]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[11]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[11]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[11]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[10]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[10]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[10]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[10]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[10]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[10]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[10]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[10]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[9]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[9]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[9]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[9]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[9]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[9]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[9]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[9]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[8]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[8]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[8]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[8]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[8]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[8]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[8]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[8]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[7]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[7]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[7]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[7]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[7]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[7]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[7]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[7]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[6]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[6]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[6]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[6]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[6]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[6]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[6]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[6]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[5]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[5]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[5]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[5]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[5]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[5]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[4]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[4]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[4]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[4]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[4]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[4]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQ[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQ[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQ[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQ[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQ[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQ[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQ[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQ[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQM[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQM[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQM[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQM[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQM[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQM[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQM[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQM[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQM[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQM[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQM[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQM[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQM[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQM[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQM[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQM[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQS[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQS[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQS[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQS[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQS[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQS[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQS[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQS[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DDR_DQS[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {DDR_DQS[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {DDR_DQS[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {DDR_DQS[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {DDR_DQS[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {DDR_DQS[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DDR_DQS[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DDR_DQS[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {GPIO0[7]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {GPIO0[7]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {GPIO0[7]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {GPIO0[7]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {GPIO0[7]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {GPIO0[7]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {GPIO0[7]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {GPIO0[7]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {GPIO0[6]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {GPIO0[6]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {GPIO0[6]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {GPIO0[6]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {GPIO0[6]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {GPIO0[6]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {GPIO0[6]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {GPIO0[6]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {GPIO0[5]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {GPIO0[5]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {GPIO0[5]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {GPIO0[5]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {GPIO0[5]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {GPIO0[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {GPIO0[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {GPIO0[5]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {GPIO0[4]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {GPIO0[4]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {GPIO0[4]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {GPIO0[4]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {GPIO0[4]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {GPIO0[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {GPIO0[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {GPIO0[4]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {GPIO0[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {GPIO0[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {GPIO0[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {GPIO0[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {GPIO0[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {GPIO0[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {GPIO0[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {GPIO0[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {GPIO0[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {GPIO0[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {GPIO0[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {GPIO0[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {GPIO0[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {GPIO0[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {GPIO0[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {GPIO0[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {GPIO0[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {GPIO0[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {GPIO0[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {GPIO0[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {GPIO0[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {GPIO0[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {GPIO0[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {GPIO0[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {GPIO0[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {GPIO0[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {GPIO0[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {GPIO0[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {GPIO0[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {GPIO0[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {GPIO0[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {GPIO0[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR26_20[26]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR26_20[26]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR26_20[26]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR26_20[26]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR26_20[26]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR26_20[26]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR26_20[26]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR26_20[26]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR26_20[25]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR26_20[25]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR26_20[25]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR26_20[25]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR26_20[25]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR26_20[25]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR26_20[25]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR26_20[25]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR26_20[24]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR26_20[24]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR26_20[24]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR26_20[24]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR26_20[24]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR26_20[24]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR26_20[24]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR26_20[24]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR26_20[23]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR26_20[23]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR26_20[23]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR26_20[23]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR26_20[23]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR26_20[23]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR26_20[23]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR26_20[23]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR26_20[22]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR26_20[22]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR26_20[22]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR26_20[22]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR26_20[22]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR26_20[22]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR26_20[22]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR26_20[22]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR26_20[21]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR26_20[21]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR26_20[21]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR26_20[21]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR26_20[21]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR26_20[21]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR26_20[21]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR26_20[21]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR26_20[20]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR26_20[20]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR26_20[20]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR26_20[20]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR26_20[20]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR26_20[20]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR26_20[20]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR26_20[20]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[19]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[19]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[19]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[19]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[19]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[19]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[19]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[19]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[18]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[18]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[18]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[18]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[18]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[18]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[18]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[18]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[17]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[17]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[17]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[17]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[17]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[17]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[17]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[17]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[16]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[16]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[16]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[16]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[16]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[16]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[16]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[16]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[15]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[15]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[15]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[15]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[15]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[15]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[15]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[15]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[14]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[14]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[14]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[14]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[14]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[14]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[14]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[14]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[13]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[13]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[13]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[13]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[13]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[13]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[13]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[13]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[12]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[12]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[12]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[12]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[12]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[12]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[12]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[12]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[11]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[11]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[11]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[11]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[11]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[11]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[11]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[11]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[10]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[10]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[10]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[10]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[10]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[10]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[10]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[10]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[9]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[9]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[9]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[9]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[9]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[9]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[9]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[9]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[8]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[8]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[8]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[8]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[8]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[8]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[8]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[8]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[7]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[7]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[7]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[7]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[7]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[7]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[7]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[7]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[6]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[6]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[6]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[6]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[6]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[6]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[6]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[6]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[5]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[5]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[5]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[5]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[5]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[5]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR[4]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR[4]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR[4]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR[4]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR[4]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR[4]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR3_0[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR3_0[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR3_0[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR3_0[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR3_0[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR3_0[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR3_0[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR3_0[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR3_0[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR3_0[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR3_0[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR3_0[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR3_0[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR3_0[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR3_0[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR3_0[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR3_0[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR3_0[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR3_0[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR3_0[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR3_0[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR3_0[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR3_0[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR3_0[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_ADDR3_0[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_ADDR3_0[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_ADDR3_0[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_ADDR3_0[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_ADDR3_0[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_ADDR3_0[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_ADDR3_0[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_ADDR3_0[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[15]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[15]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[15]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[15]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[15]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[15]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[15]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[15]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[14]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[14]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[14]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[14]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[14]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[14]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[14]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[14]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[13]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[13]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[13]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[13]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[13]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[13]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[13]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[13]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[12]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[12]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[12]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[12]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[12]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[12]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[12]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[12]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[11]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[11]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[11]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[11]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[11]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[11]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[11]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[11]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[10]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[10]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[10]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[10]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[10]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[10]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[10]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[10]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[9]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[9]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[9]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[9]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[9]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[9]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[9]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[9]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[8]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[8]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[8]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[8]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[8]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[8]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[8]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[8]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[7]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[7]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[7]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[7]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[7]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[7]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[7]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[7]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[6]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[6]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[6]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[6]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[6]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[6]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[6]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[6]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[5]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[5]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[5]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[5]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[5]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[5]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[4]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[4]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[4]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[4]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[4]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[4]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_DATA[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_DATA[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_DATA[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_DATA[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_DATA[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_DATA[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_DATA[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_DATA[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_nCS[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_nCS[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_nCS[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_nCS[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_nCS[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_nCS[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_nCS[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_nCS[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_nCS[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_nCS[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_nCS[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_nCS[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_nCS[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_nCS[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_nCS[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_nCS[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_nCS[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_nCS[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_nCS[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_nCS[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_nCS[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_nCS[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_nCS[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_nCS[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_nCS[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_nCS[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_nCS[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_nCS[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_nCS[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_nCS[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_nCS[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_nCS[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_nOE}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_nOE}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_nOE}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_nOE}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_nOE}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_nOE}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_nOE}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_nOE}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_nWR[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_nWR[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_nWR[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_nWR[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_nWR[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_nWR[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_nWR[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_nWR[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SMC_nWR[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SMC_nWR[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SMC_nWR[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SMC_nWR[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SMC_nWR[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SMC_nWR[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SMC_nWR[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SMC_nWR[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {TXD_0}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {TXD_0}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {TXD_0}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {TXD_0}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {TXD_0}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {TXD_0}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {TXD_0}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {TXD_0}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RXD_1}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {RXD_1}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {RXD_1}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {RXD_1}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {RXD_1}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {RXD_1}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RXD_1}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RXD_1}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {TXD_1}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {TXD_1}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {TXD_1}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {TXD_1}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {TXD_1}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {TXD_1}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {TXD_1}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {TXD_1}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {I2C_SDA}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {I2C_SDA}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {I2C_SDA}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {I2C_SDA}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {I2C_SDA}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {I2C_SDA}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {I2C_SDA}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {I2C_SDA}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {I2C_SCL}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {I2C_SCL}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {I2C_SCL}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {I2C_SCL}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {I2C_SCL}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {I2C_SCL}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {I2C_SCL}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {I2C_SCL}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_IO[7]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_IO[7]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_IO[7]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_IO[7]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_IO[7]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_IO[7]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_IO[7]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_IO[7]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_IO[6]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_IO[6]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_IO[6]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_IO[6]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_IO[6]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_IO[6]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_IO[6]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_IO[6]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_IO[5]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_IO[5]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_IO[5]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_IO[5]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_IO[5]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_IO[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_IO[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_IO[5]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_IO[4]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_IO[4]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_IO[4]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_IO[4]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_IO[4]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_IO[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_IO[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_IO[4]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_IO[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_IO[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_IO[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_IO[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_IO[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_IO[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_IO[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_IO[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_IO[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_IO[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_IO[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_IO[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_IO[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_IO[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_IO[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_IO[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_IO[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_IO[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_IO[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_IO[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_IO[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_IO[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_IO[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_IO[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_IO[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_IO[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_IO[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_IO[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_IO[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_IO[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_IO[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_IO[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_CLE}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_CLE}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_CLE}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_CLE}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_CLE}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_CLE}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_CLE}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_CLE}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_ALE}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_ALE}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_ALE}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_ALE}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_ALE}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_ALE}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_ALE}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_ALE}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_nCE0}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_nCE0}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_nCE0}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_nCE0}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_nCE0}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_nCE0}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_nCE0}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_nCE0}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_nCE1}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_nCE1}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_nCE1}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_nCE1}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_nCE1}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_nCE1}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_nCE1}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_nCE1}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_nRE}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_nRE}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_nRE}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_nRE}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_nRE}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_nRE}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_nRE}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_nRE}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_nWE}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_nWE}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_nWE}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_nWE}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_nWE}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_nWE}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_nWE}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_nWE}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {NF_RnB1}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {NF_RnB1}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {NF_RnB1}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {NF_RnB1}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {NF_RnB1}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {NF_RnB1}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {NF_RnB1}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {NF_RnB1}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {ARMICE_nSRST}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {ARMICE_nSRST}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {ARMICE_nSRST}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {ARMICE_nSRST}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {ARMICE_nSRST}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {ARMICE_nSRST}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {ARMICE_nSRST}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {ARMICE_nSRST}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {ARMICE_RTCK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {ARMICE_RTCK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {ARMICE_RTCK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {ARMICE_RTCK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {ARMICE_RTCK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {ARMICE_RTCK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {ARMICE_RTCK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {ARMICE_RTCK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {ARMICE_TDO}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {ARMICE_TDO}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {ARMICE_TDO}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {ARMICE_TDO}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {ARMICE_TDO}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {ARMICE_TDO}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {ARMICE_TDO}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {ARMICE_TDO}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SPI_SDO}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SPI_SDO}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SPI_SDO}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SPI_SDO}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SPI_SDO}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SPI_SDO}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SPI_SDO}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SPI_SDO}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SPI_SDI}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SPI_SDI}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SPI_SDI}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SPI_SDI}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SPI_SDI}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SPI_SDI}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SPI_SDI}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SPI_SDI}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SPI_SCK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SPI_SCK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SPI_SCK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SPI_SCK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SPI_SCK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SPI_SCK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SPI_SCK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SPI_SCK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SPI_nSS}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {SPI_nSS}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {SPI_nSS}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {SPI_nSS}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {SPI_nSS}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {SPI_nSS}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SPI_nSS}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SPI_nSS}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {I2S_MCLK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {I2S_MCLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {I2S_MCLK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {I2S_MCLK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {I2S_MCLK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {I2S_MCLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {I2S_MCLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {I2S_MCLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {I2S_BCLK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {I2S_BCLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {I2S_BCLK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {I2S_BCLK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {I2S_BCLK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {I2S_BCLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {I2S_BCLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {I2S_BCLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {I2S_LRCLK}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {I2S_LRCLK}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {I2S_LRCLK}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {I2S_LRCLK}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {I2S_LRCLK}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {I2S_LRCLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {I2S_LRCLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {I2S_LRCLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {I2S_SDO}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {I2S_SDO}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {I2S_SDO}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {I2S_SDO}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {I2S_SDO}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {I2S_SDO}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {I2S_SDO}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {I2S_SDO}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {I2S_SDI}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {I2S_SDI}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {I2S_SDI}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {I2S_SDI}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {I2S_SDI}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {I2S_SDI}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {I2S_SDI}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {I2S_SDI}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {EXT_INT[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {EXT_INT[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {EXT_INT[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {EXT_INT[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {EXT_INT[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {EXT_INT[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {EXT_INT[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {EXT_INT[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {EXT_INT[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {EXT_INT[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {EXT_INT[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {EXT_INT[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {EXT_INT[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {EXT_INT[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {EXT_INT[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {EXT_INT[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {EXT_INT[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {EXT_INT[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {EXT_INT[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {EXT_INT[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {EXT_INT[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {EXT_INT[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {EXT_INT[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {EXT_INT[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {EXT_INT[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {EXT_INT[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {EXT_INT[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {EXT_INT[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {EXT_INT[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {EXT_INT[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {EXT_INT[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {EXT_INT[0]}]
set_clock_uncertainty  0.25 -setup [get_ports {PCI_CLKi}]
set_clock_uncertainty  0.4 -hold [get_ports {PCI_CLKi}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_CLKo}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_RESET}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_BRIDGE_REQ}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[31]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[30]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[29]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[28]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[27]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[26]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[25]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[24]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[23]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[22]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[21]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[20]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[19]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[18]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[17]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[16]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[15]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[14]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[13]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[12]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[11]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[10]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[9]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[8]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[7]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[6]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[5]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[4]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[3]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[2]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[1]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_AD[0]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_ARB_GNT[3]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_ARB_GNT[2]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_ARB_GNT[1]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_ARB_GNT[0]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_CBE[3]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_CBE[2]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_CBE[1]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_CBE[0]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_DEVSEL}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_FRAME}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_IRDY}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_PAR}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_PERR}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_SERR}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_STOP}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_TRDY}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_INTA}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_INTB}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_INTC}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {ECLK}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {TCLK}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {iCLKx2}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {PLLCLK}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {iCLK4}]\
	-to      [get_ports {PCI_INTD}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {TXEN}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RXEN}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {rs_sysfifo_en}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {sfc_sf_start}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {PCLK}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {PHYACTIVE}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {DATAEN}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {CCASTATUS}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {MDATA[7]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {MDATA[6]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {MDATA[5]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {MDATA[4]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {MDATA[3]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {MDATA[2]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {MDATA[1]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {MDATA[0]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {SDATA}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {LED[1]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {LED[0]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {TxAtten[5]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {TxAtten[4]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {TxAtten[3]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {TxAtten[2]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {TxAtten[1]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {TxAtten[0]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {Rx_FixAtten}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RxGainQ[5]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RxGainQ[4]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RxGainQ[3]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RxGainQ[2]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RxGainQ[1]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RxGainQ[0]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {BandSel[1]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {BandSel[0]}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SPI_CLK}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG0}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG1}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG2}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG3}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG4}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG5}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG6}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG7}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG8}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG9}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {RF_SIG10}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {cdy_div4clk}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {cdy_div8clk}]
set_false_path\
	-from    [get_clocks {MPllOut}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {MClk198}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {MAC132}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {MSRCLK198}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {CpuClkOut}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {SysClk}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {SysClkOut}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {DDRClk1xOut}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {nDDRClk1xOut}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {DDRClk2xOut}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {nDDRClk2xOut}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {PeriClk}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {PeriClkOut}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {PeriClk2xOut}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {MAC66CLK}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {MAC33CLK}]\
	-to      [get_ports {cdy_div16clk}]
set_false_path\
	-from    [get_clocks {PCI_CLK}]\
	-to      [get_ports {cdy_div16clk}]
set_clock_uncertainty  0.25 -setup [get_pins {uUWBTOP/I_H2TOP/mac_pclk}]
set_clock_uncertainty  0.3 -hold [get_pins {uUWBTOP/I_H2TOP/mac_pclk}]
set_clock_uncertainty  0.25 -setup [get_pins \
{uUWBTOP/MACTOP_MODULE/A_MACCORE_TOP/B_PC/C_SFC/sys_uclk}]
set_clock_uncertainty  0.3 -hold [get_pins \
{uUWBTOP/MACTOP_MODULE/A_MACCORE_TOP/B_PC/C_SFC/sys_uclk}]
set_max_fanout 4 [current_design]
set_max_transition 1 [current_design]
set_operating_conditions "ss_1p08v_125c" -library \
"scx2_tsmc_cl013g_ss_1p08v_125c"
set_wire_load_mode "enclosed" 
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {CLK33M}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {nRESET}]
set_case_analysis 1 [get_ports {nRESET}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {ScanEn}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {BistEn}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {BClk}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DFT_NC}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {TestMode[2]}]
set_case_analysis 0 [get_ports {TestMode[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {TestMode[1]}]
set_case_analysis 0 [get_ports {TestMode[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {TestMode[0]}]
set_case_analysis 0 [get_ports {TestMode[0]}]
set_load -pin_load 0.018904 [get_ports {DDR_CLK}]
set_load -pin_load 0.018904 [get_ports {DDR_nCLK}]
set_load -pin_load 0.018904 [get_ports {DDR_CKE}]
set_load -pin_load 0.018904 [get_ports {DDR_CSB}]
set_load -pin_load 0.018904 [get_ports {DDR_RASB}]
set_load -pin_load 0.018904 [get_ports {DDR_CASB}]
set_load -pin_load 0.018904 [get_ports {DDR_WEB}]
set_load -pin_load 0.018904 [get_ports {DDR_BADDR[1]}]
set_load -pin_load 0.018904 [get_ports {DDR_BADDR[0]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[12]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[11]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[10]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[9]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[8]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[7]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[6]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[5]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[4]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[3]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[2]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[1]}]
set_load -pin_load 0.018904 [get_ports {DDR_ADDR[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[15]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[15]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[14]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[14]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[13]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[13]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[12]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[12]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[11]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[11]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[10]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[10]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[9]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[9]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[8]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[8]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[7]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[7]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[6]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[6]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[5]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[5]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[4]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[4]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[3]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[2]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[1]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQ[0]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQ[0]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQM[1]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQM[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQS[1]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQS[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DDR_DQS[0]}]
set_load -pin_load 0.018904 [get_ports {DDR_DQS[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {GPIO0[7]}]
set_load -pin_load 0.018904 [get_ports {GPIO0[7]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {GPIO0[6]}]
set_load -pin_load 0.018904 [get_ports {GPIO0[6]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {GPIO0[5]}]
set_load -pin_load 0.018904 [get_ports {GPIO0[5]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {GPIO0[4]}]
set_load -pin_load 0.018904 [get_ports {GPIO0[4]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {GPIO0[3]}]
set_load -pin_load 0.018904 [get_ports {GPIO0[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {GPIO0[2]}]
set_load -pin_load 0.018904 [get_ports {GPIO0[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {GPIO0[1]}]
set_load -pin_load 0.018904 [get_ports {GPIO0[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {GPIO0[0]}]
set_load -pin_load 0.018904 [get_ports {GPIO0[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR26_20[26]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR26_20[26]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR26_20[25]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR26_20[25]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR26_20[24]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR26_20[24]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR26_20[23]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR26_20[23]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR26_20[22]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR26_20[22]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR26_20[21]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR26_20[21]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR26_20[20]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR26_20[20]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[19]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[18]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[17]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[16]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[15]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[14]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[13]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[12]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[11]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[10]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[9]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[8]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[7]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[6]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[5]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR[4]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR3_0[3]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR3_0[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR3_0[2]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR3_0[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR3_0[1]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR3_0[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_ADDR3_0[0]}]
set_load -pin_load 0.018904 [get_ports {SMC_ADDR3_0[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[15]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[15]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[14]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[14]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[13]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[13]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[12]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[12]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[11]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[11]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[10]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[10]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[9]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[9]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[8]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[8]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[7]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[7]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[6]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[6]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[5]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[5]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[4]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[4]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[3]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[2]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[1]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_DATA[0]}]
set_load -pin_load 0.018904 [get_ports {SMC_DATA[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_nCS[3]}]
set_load -pin_load 0.018904 [get_ports {SMC_nCS[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_nCS[2]}]
set_load -pin_load 0.018904 [get_ports {SMC_nCS[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_nCS[1]}]
set_load -pin_load 0.018904 [get_ports {SMC_nCS[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SMC_nCS[0]}]
set_load -pin_load 0.018904 [get_ports {SMC_nCS[0]}]
set_load -pin_load 0.018904 [get_ports {SMC_nOE}]
set_load -pin_load 0.018904 [get_ports {SMC_nWR[1]}]
set_load -pin_load 0.018904 [get_ports {SMC_nWR[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {RXD_0}]
set_load -pin_load 0.018904 [get_ports {TXD_0}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {RXD_1}]
set_load -pin_load 0.018904 [get_ports {RXD_1}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {TXD_1}]
set_load -pin_load 0.018904 [get_ports {TXD_1}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {I2C_SDA}]
set_load -pin_load 0.018904 [get_ports {I2C_SDA}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {I2C_SCL}]
set_load -pin_load 0.018904 [get_ports {I2C_SCL}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_IO[7]}]
set_load -pin_load 0.018904 [get_ports {NF_IO[7]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_IO[6]}]
set_load -pin_load 0.018904 [get_ports {NF_IO[6]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_IO[5]}]
set_load -pin_load 0.018904 [get_ports {NF_IO[5]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_IO[4]}]
set_load -pin_load 0.018904 [get_ports {NF_IO[4]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_IO[3]}]
set_load -pin_load 0.018904 [get_ports {NF_IO[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_IO[2]}]
set_load -pin_load 0.018904 [get_ports {NF_IO[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_IO[1]}]
set_load -pin_load 0.018904 [get_ports {NF_IO[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_IO[0]}]
set_load -pin_load 0.018904 [get_ports {NF_IO[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_CLE}]
set_load -pin_load 0.018904 [get_ports {NF_CLE}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_ALE}]
set_load -pin_load 0.018904 [get_ports {NF_ALE}]
set_load -pin_load 0.018904 [get_ports {NF_nCE0}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_nCE1}]
set_load -pin_load 0.018904 [get_ports {NF_nCE1}]
set_load -pin_load 0.018904 [get_ports {NF_nRE}]
set_load -pin_load 0.018904 [get_ports {NF_nWE}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_RnB0}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {NF_RnB1}]
set_load -pin_load 0.018904 [get_ports {NF_RnB1}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {ARMICE_nSRST}]
set_case_analysis 1 [get_ports {ARMICE_nSRST}]
set_load -pin_load 0.018904 [get_ports {ARMICE_nSRST}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {ARMICE_nTRST}]
set_case_analysis 1 [get_ports {ARMICE_nTRST}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {ARMICE_TCK}]
set_load -pin_load 0.018904 [get_ports {ARMICE_RTCK}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {ARMICE_TMS}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {ARMICE_TDI}]
set_load -pin_load 0.018904 [get_ports {ARMICE_TDO}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SPI_SDO}]
set_load -pin_load 0.018904 [get_ports {SPI_SDO}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SPI_SDI}]
set_load -pin_load 0.018904 [get_ports {SPI_SDI}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SPI_SCK}]
set_load -pin_load 0.018904 [get_ports {SPI_SCK}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SPI_nSS}]
set_load -pin_load 0.018904 [get_ports {SPI_nSS}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {I2S_MCLK}]
set_load -pin_load 0.018904 [get_ports {I2S_MCLK}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {I2S_BCLK}]
set_load -pin_load 0.018904 [get_ports {I2S_BCLK}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {I2S_LRCLK}]
set_load -pin_load 0.018904 [get_ports {I2S_LRCLK}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {I2S_SDO}]
set_load -pin_load 0.018904 [get_ports {I2S_SDO}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {I2S_SDI}]
set_load -pin_load 0.018904 [get_ports {I2S_SDI}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {EXT_INT[3]}]
set_load -pin_load 0.018904 [get_ports {EXT_INT[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {EXT_INT[2]}]
set_load -pin_load 0.018904 [get_ports {EXT_INT[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {EXT_INT[1]}]
set_load -pin_load 0.018904 [get_ports {EXT_INT[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {EXT_INT[0]}]
set_load -pin_load 0.018904 [get_ports {EXT_INT[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_CLKi}]
set_load -pin_load 0.018904 [get_ports {PCI_CLKo}]
set_load -pin_load 0.018904 [get_ports {PCI_RESET}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_BRIDGE_GNT}]
set_load -pin_load 0.018904 [get_ports {PCI_BRIDGE_REQ}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[31]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[31]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[30]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[30]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[29]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[29]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[28]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[28]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[27]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[27]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[26]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[26]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[25]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[25]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[24]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[24]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[23]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[23]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[22]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[22]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[21]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[21]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[20]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[20]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[19]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[19]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[18]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[18]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[17]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[17]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[16]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[16]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[15]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[15]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[14]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[14]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[13]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[13]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[12]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[12]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[11]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[11]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[10]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[10]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[9]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[9]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[8]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[8]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[7]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[7]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[6]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[6]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[5]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[5]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[4]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[4]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[3]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[2]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[1]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_AD[0]}]
set_load -pin_load 0.018904 [get_ports {PCI_AD[0]}]
set_load -pin_load 0.018904 [get_ports {PCI_ARB_GNT[3]}]
set_load -pin_load 0.018904 [get_ports {PCI_ARB_GNT[2]}]
set_load -pin_load 0.018904 [get_ports {PCI_ARB_GNT[1]}]
set_load -pin_load 0.018904 [get_ports {PCI_ARB_GNT[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_ARB_REQ[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_ARB_REQ[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_ARB_REQ[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_ARB_REQ[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_CBE[3]}]
set_load -pin_load 0.018904 [get_ports {PCI_CBE[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_CBE[2]}]
set_load -pin_load 0.018904 [get_ports {PCI_CBE[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_CBE[1]}]
set_load -pin_load 0.018904 [get_ports {PCI_CBE[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_CBE[0]}]
set_load -pin_load 0.018904 [get_ports {PCI_CBE[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_IDSEL}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_DEVSEL}]
set_load -pin_load 0.018904 [get_ports {PCI_DEVSEL}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_FRAME}]
set_load -pin_load 0.018904 [get_ports {PCI_FRAME}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_IRDY}]
set_load -pin_load 0.018904 [get_ports {PCI_IRDY}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_PAR}]
set_load -pin_load 0.018904 [get_ports {PCI_PAR}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_PERR}]
set_load -pin_load 0.018904 [get_ports {PCI_PERR}]
set_load -pin_load 0.018904 [get_ports {PCI_SERR}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_STOP}]
set_load -pin_load 0.018904 [get_ports {PCI_STOP}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_TRDY}]
set_load -pin_load 0.018904 [get_ports {PCI_TRDY}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_INTA}]
set_load -pin_load 0.018904 [get_ports {PCI_INTA}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_INTB}]
set_load -pin_load 0.018904 [get_ports {PCI_INTB}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_INTC}]
set_load -pin_load 0.018904 [get_ports {PCI_INTC}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCI_INTD}]
set_load -pin_load 0.018904 [get_ports {PCI_INTD}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PF_AHVDD}]
set_load -pin_load 0.018904 [get_ports {PF_AHVDD}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PF_AHVSS}]
set_load -pin_load 0.018904 [get_ports {PF_AHVSS}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PF_AHVDDG}]
set_load -pin_load 0.018904 [get_ports {PF_AHVDDG}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PF_AHVSSG}]
set_load -pin_load 0.018904 [get_ports {PF_AHVSSG}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PF_DVDD}]
set_load -pin_load 0.018904 [get_ports {PF_DVDD}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PF_DVSS}]
set_load -pin_load 0.018904 [get_ports {PF_DVSS}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MSEL[1]}]
set_case_analysis 0 [get_ports {MSEL[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MSEL[0]}]
set_case_analysis 0 [get_ports {MSEL[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PRST}]
set_load -pin_load 0.018904 [get_ports {PRST}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {TXEN}]
set_load -pin_load 0.018904 [get_ports {TXEN}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {RXEN}]
set_load -pin_load 0.018904 [get_ports {RXEN}]
set_load -pin_load 0.018904 [get_ports {rs_sysfifo_en}]
set_load -pin_load 0.018904 [get_ports {sfc_sf_start}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PCLK}]
set_load -pin_load 0.018904 [get_ports {PCLK}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PHYACTIVE}]
set_load -pin_load 0.018904 [get_ports {PHYACTIVE}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DATAEN}]
set_load -pin_load 0.018904 [get_ports {DATAEN}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {CCASTATUS}]
set_load -pin_load 0.018904 [get_ports {CCASTATUS}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MDATA[7]}]
set_load -pin_load 0.018904 [get_ports {MDATA[7]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MDATA[6]}]
set_load -pin_load 0.018904 [get_ports {MDATA[6]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MDATA[5]}]
set_load -pin_load 0.018904 [get_ports {MDATA[5]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MDATA[4]}]
set_load -pin_load 0.018904 [get_ports {MDATA[4]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MDATA[3]}]
set_load -pin_load 0.018904 [get_ports {MDATA[3]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MDATA[2]}]
set_load -pin_load 0.018904 [get_ports {MDATA[2]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MDATA[1]}]
set_load -pin_load 0.018904 [get_ports {MDATA[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {MDATA[0]}]
set_load -pin_load 0.018904 [get_ports {MDATA[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {SDATA}]
set_load -pin_load 0.018904 [get_ports {SDATA}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {nRST}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {eCLK}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {CLKSEL[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {CLKSEL[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {TCLK}]
set_load -pin_load 0.018904 [get_ports {LED[1]}]
set_load -pin_load 0.018904 [get_ports {LED[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {RFSEL}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PMODE[1]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {PMODE[0]}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {CLKMODE}]
set_load -pin_load 0.018904 [get_ports {TxAtten[5]}]
set_load -pin_load 0.018904 [get_ports {TxAtten[4]}]
set_load -pin_load 0.018904 [get_ports {TxAtten[3]}]
set_load -pin_load 0.018904 [get_ports {TxAtten[2]}]
set_load -pin_load 0.018904 [get_ports {TxAtten[1]}]
set_load -pin_load 0.018904 [get_ports {TxAtten[0]}]
set_load -pin_load 0.018904 [get_ports {Rx_FixAtten}]
set_load -pin_load 0.018904 [get_ports {RxGainQ[5]}]
set_load -pin_load 0.018904 [get_ports {RxGainQ[4]}]
set_load -pin_load 0.018904 [get_ports {RxGainQ[3]}]
set_load -pin_load 0.018904 [get_ports {RxGainQ[2]}]
set_load -pin_load 0.018904 [get_ports {RxGainQ[1]}]
set_load -pin_load 0.018904 [get_ports {RxGainQ[0]}]
set_load -pin_load 0.018904 [get_ports {BandSel[1]}]
set_load -pin_load 0.018904 [get_ports {BandSel[0]}]
set_load -pin_load 0.018904 [get_ports {RF_SPI_CLK}]
set_load -pin_load 0.018904 [get_ports {RF_SIG0}]
set_load -pin_load 0.018904 [get_ports {RF_SIG1}]
set_load -pin_load 0.018904 [get_ports {RF_SIG2}]
set_load -pin_load 0.018904 [get_ports {RF_SIG3}]
set_load -pin_load 0.018904 [get_ports {RF_SIG4}]
set_load -pin_load 0.018904 [get_ports {RF_SIG5}]
set_load -pin_load 0.018904 [get_ports {RF_SIG6}]
set_load -pin_load 0.018904 [get_ports {RF_SIG7}]
set_load -pin_load 0.018904 [get_ports {RF_SIG8}]
set_load -pin_load 0.018904 [get_ports {RF_SIG9}]
set_load -pin_load 0.018904 [get_ports {RF_SIG10}]
set_load -pin_load 0.018904 [get_ports {cdy_div4clk}]
set_load -pin_load 0.018904 [get_ports {cdy_div8clk}]
set_load -pin_load 0.018904 [get_ports {cdy_div16clk}]
set_load -pin_load 20 [get_ports {FOUT}]
set_load -min -pin_load 20 [get_ports {FOUT}]
set_load -pin_load 20 [get_ports {BandSel_LVDS[1]}]
set_load -min -pin_load 20 [get_ports {BandSel_LVDS[1]}]
set_load -pin_load 20 [get_ports {BandSel_LVDS[0]}]
set_load -min -pin_load 20 [get_ports {BandSel_LVDS[0]}]
set_load -pin_load 0.018904 [get_ports {cdx_vcm}]
set_load -pin_load 0.018904 [get_ports {iadcx_aincm}]
set_load -pin_load 0.018904 [get_ports {idacx_iout_m}]
set_load -pin_load 0.018904 [get_ports {idacx_iout_p}]
set_load -pin_load 0.018904 [get_ports {qdacx_iout_m}]
set_load -pin_load 0.018904 [get_ports {qdacx_iout_p}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {leftprd_gnd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {leftprd_vdd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {rghtprd_gnd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {rghtprd_vdd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {cdx_clk_m}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {cdx_clk_p}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {iadcx_ain_m}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {iadcx_ain_p}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {iadcx_rext}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {iqadcx_agnd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {iqadcx_avdd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {qadcx_ain_m}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {qadcx_ain_p}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {idacx_rext}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {iqdacx_agnd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {iqdacx_avdd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {x_atb_m}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {x_atb_p}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {x_guard}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {x_iognd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {x_iovdd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {y_dgnd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {y_dvdd}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {AHVDD}]
set_load -pin_load 0.018904 [get_ports {AHVDD}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {AHVSS}]
set_load -pin_load 0.018904 [get_ports {AHVSS}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {AHVDDG}]
set_load -pin_load 0.018904 [get_ports {AHVDDG}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {AHVSSG}]
set_load -pin_load 0.018904 [get_ports {AHVSSG}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DVDD}]
set_load -pin_load 0.018904 [get_ports {DVDD}]
#set_driving_cell -lib_cell BUFX4 -library scx2_tsmc_cl013g_ss_1p08v_125c -pin \
Y [get_ports {DVSS}]
set_load -pin_load 0.018904 [get_ports {DVSS}]
set_resistance 0 [get_nets {PCI_CLKi}]

set_case_analysis 0 [get_ports {CLKSEL[0]}]
set_case_analysis 0 [get_ports {CLKSEL[1]}]
set_case_analysis 0 [get_ports {PMODE[0]}]
set_case_analysis 0 [get_ports {PMODE[1]}]
set_case_analysis 0 [get_ports {CLKMODE}]

set_case_analysis 0 [get_ports {ScanEn}]
set_case_analysis 0 [get_ports {BistEn}]
