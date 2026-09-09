# Synplicity, Inc. constraint file
# C:\Project\ETRI_UWB\synplify\ETRI_UWBFPGA.sdc
# Written on Tue May 15 23:44:28 2007
# by Synplify Pro, Synplify Pro 8.6.2 Scope Editor

#
# Collections
#

#
# Clocks
#
define_clock            -name {CLK}  -freq 70.000 -clockgroup default_clkgroup_0
define_clock            -name {n:CLK100M}  -freq 70.000 -clockgroup default_clkgroup_0
define_clock            -name {n:CLK200M}  -freq 140.000 -clockgroup default_clkgroup_0
define_clock            -name {DDR_DQS[0]}  -freq 140.000 -clockgroup default_clkgroup_1
define_clock            -name {DDR_DQS[1]}  -freq 140.000 -clockgroup default_clkgroup_1
define_clock            -name {CLK33M}  -freq 33.000 -clockgroup default_clkgroup_2
define_clock -disable   -name {VIF_CLK}  -freq 33.000 -clockgroup default_clkgroup_3
define_clock            -name {n:CLK50M}  -freq 35.000 -clockgroup default_clkgroup_0
define_clock            -name {n:DDR_DQSI[0]}  -freq 140.000 -clockgroup default_clkgroup_1
define_clock            -name {n:DDR_DQSI[1]}  -freq 140.000 -clockgroup default_clkgroup_1
define_clock -disable   -name {USB_xcvr_clk}  -freq 70.000 -clockgroup default_clkgroup_4

#
# Clock to Clock
#

#
# Inputs/Outputs
#

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
define_attribute          {nRESET} xc_loc {AH19}
define_attribute          {CLK} xc_loc {J19}
define_attribute          {CLK33M} xc_loc {P20}
define_attribute          {ROM_ADDR[0]} xc_loc {AT38}
define_attribute          {ROM_ADDR[1]} xc_loc {AU38}
define_attribute          {ROM_ADDR[2]} xc_loc {AN34}
define_attribute          {ROM_ADDR[3]} xc_loc {AN33}
define_attribute          {ROM_ADDR[4]} xc_loc {AP37}
define_attribute          {ROM_ADDR[5]} xc_loc {AP36}
define_attribute          {ROM_ADDR[6]} xc_loc {AH29}
define_attribute          {ROM_ADDR[7]} xc_loc {AG28}
define_attribute          {ROM_ADDR[8]} xc_loc {AR39}
define_attribute          {ROM_ADDR[9]} xc_loc {AT39}
define_attribute          {ROM_ADDR[10]} xc_loc {AN35}
define_attribute          {ROM_ADDR[11]} xc_loc {AP35}
define_attribute          {ROM_ADDR[12]} xc_loc {AL35}
define_attribute          {ROM_ADDR[13]} xc_loc {AM35}
define_attribute          {ROM_ADDR[14]} xc_loc {AR38}
define_attribute          {ROM_ADDR[15]} xc_loc {AR37}
define_attribute          {ROM_ADDR[16]} xc_loc {AJ32}
define_attribute          {ROM_ADDR[17]} xc_loc {AK33}
define_attribute          {ROM_ADDR[18]} xc_loc {AG30}
define_attribute          {ROM_ADDR[19]} xc_loc {AH30}
define_attribute          {ROM_DATA[0]} xc_loc {J32}
define_attribute          {ROM_DATA[1]} xc_loc {K32}
define_attribute          {ROM_DATA[2]} xc_loc {G36}
define_attribute          {ROM_DATA[3]} xc_loc {G37}
define_attribute          {ROM_DATA[4]} xc_loc {E37}
define_attribute          {ROM_DATA[5]} xc_loc {E38}
define_attribute          {ROM_DATA[6]} xc_loc {H35}
define_attribute          {ROM_DATA[7]} xc_loc {J35}
define_attribute          {ROM_DATA[8]} xc_loc {M30}
define_attribute          {ROM_DATA[9]} xc_loc {M31}
define_attribute          {ROM_DATA[10]} xc_loc {E39}
define_attribute          {ROM_DATA[11]} xc_loc {F39}
define_attribute          {ROM_DATA[12]} xc_loc {J34}
define_attribute          {ROM_DATA[13]} xc_loc {K34}
define_attribute          {ROM_DATA[14]} xc_loc {F38}
define_attribute          {ROM_DATA[15]} xc_loc {G38}
define_attribute          {ROM_nCS} xc_loc {K33}
define_attribute          {ROM_nOE} xc_loc {L33}
define_attribute          {DDR_CLK} xc_loc {AP19}
define_attribute          {DDR_nCLK} xc_loc {AR18}
define_attribute          {DDR_CKE} xc_loc {AL23}
define_attribute          {DDR_CSB} xc_loc {AG23}
define_attribute          {DDR_RASB} xc_loc {AU17}
define_attribute          {DDR_CASB} xc_loc {AN17}
define_attribute          {DDR_WEB} xc_loc {AH23}
define_attribute          {DDR_BADDR[0]} xc_loc {AH22}
define_attribute          {DDR_BADDR[1]} xc_loc {AM17}
define_attribute          {DDR_ADDR[0]} xc_loc {AP16}
define_attribute          {DDR_ADDR[1]} xc_loc {AR16}
define_attribute          {DDR_ADDR[2]} xc_loc {AV23}
define_attribute          {DDR_ADDR[3]} xc_loc {AU23}
define_attribute          {DDR_ADDR[4]} xc_loc {AT16}
define_attribute          {DDR_ADDR[5]} xc_loc {AC20}
define_attribute          {DDR_ADDR[6]} xc_loc {AC22}
define_attribute          {DDR_ADDR[7]} xc_loc {AW15}
define_attribute          {DDR_ADDR[8]} xc_loc {AW16}
define_attribute          {DDR_ADDR[9]} xc_loc {AF23}
define_attribute          {DDR_ADDR[10]} xc_loc {AE23}
define_attribute          {DDR_ADDR[11]} xc_loc {AL16}
define_attribute          {DDR_ADDR[12]} xc_loc {AK17}
define_attribute          {DDR_DQ[0]} xc_loc {AD21}
define_attribute          {DDR_DQ[1]} xc_loc {AE22}
define_attribute          {DDR_DQ[2]} xc_loc {AG17}
define_attribute          {DDR_DQ[3]} xc_loc {AH17}
define_attribute          {DDR_DQ[4]} xc_loc {AF21}
define_attribute          {DDR_DQ[5]} xc_loc {AG22}
define_attribute          {DDR_DQ[6]} xc_loc {AT20}
define_attribute          {DDR_DQ[7]} xc_loc {AU20}
define_attribute          {DDR_DQ[8]} xc_loc {AM20}
define_attribute          {DDR_DQ[9]} xc_loc {AM21}
define_attribute          {DDR_DQ[10]} xc_loc {AT19}
define_attribute          {DDR_DQ[11]} xc_loc {AR21}
define_attribute          {DDR_DQ[12]} xc_loc {AT21}
define_attribute          {DDR_DQ[13]} xc_loc {AL18}
define_attribute          {DDR_DQ[14]} xc_loc {AM18}
define_attribute          {DDR_DQ[15]} xc_loc {AR22}
define_attribute          {DDR_DQM[0]} xc_loc {AR23}
define_attribute          {DDR_DQM[1]} xc_loc {AT23}
define_attribute          {DDR_DQS[0]} xc_loc {AK23}
define_attribute          {DDR_DQS[1]} xc_loc {AV17}
define_attribute          {UART_TXD[0]} xc_loc {K9}
define_attribute          {UART_RXD[0]} xc_loc {L10}
define_attribute          {UART_TXD[1]} xc_loc {L11}
define_attribute          {UART_RXD[1]} xc_loc {K11}
define_attribute          {NF_IO[0]} xc_loc {AJ34}
define_attribute          {NF_IO[1]} xc_loc {AH33}
define_attribute          {NF_IO[2]} xc_loc {AH32}
define_attribute          {NF_IO[3]} xc_loc {AG32}
define_attribute          {NF_IO[4]} xc_loc {AF31}
define_attribute          {NF_IO[5]} xc_loc {AE26}
define_attribute          {NF_IO[6]} xc_loc {AD26}
define_attribute          {NF_IO[7]} xc_loc {AE32}
define_attribute          {NF_CLE} xc_loc {AD27}
define_attribute          {NF_ALE} xc_loc {AC27}
define_attribute          {NF_nCE0} xc_loc {AD29}
define_attribute          {NF_nRE} xc_loc {AC28}
define_attribute          {NF_nWE} xc_loc {AE31}
define_attribute          {NF_RnB0} xc_loc {AF33}
define_attribute          {ARMICE_nSRST} xc_loc {AF19}
define_attribute          {ARMICE_nTRST} xc_loc {N20}
define_attribute          {ARMICE_TCK} xc_loc {J20}
define_attribute          {ARMICE_RTCK} xc_loc {M20}
define_attribute          {ARMICE_TMS} xc_loc {M22}
define_attribute          {ARMICE_TDI} xc_loc {K19}
define_attribute          {ARMICE_TDO} xc_loc {L19}
define_attribute          {ARMICE_nSRST} xc_pullup {1}

define_attribute          {I2S_MCLK} xc_loc {P1}     #	NET "FPGA_CON<160>" LOC = "P1";	
define_attribute          {I2S_MCLK_OE} xc_loc {P2}  #	NET "FPGA_CON<161>" LOC = "P2";	
define_attribute          {I2S_BCLK_O} xc_loc {U8}   #	NET "FPGA_CON<162>" LOC = "U8";	
define_attribute          {I2S_BCLK_I} xc_loc {T8}   #	NET "FPGA_CON<163>" LOC = "T8";	
define_attribute          {I2S_BCLK_OE} xc_loc {V12}  #	NET "FPGA_CON<164>" LOC = "V12";
define_attribute          {I2S_LRCLK_O} xc_loc {V13}  #	NET "FPGA_CON<165>" LOC = "V13";
define_attribute          {I2S_LRCLK_I} xc_loc {N2}  #	NET "FPGA_CON<166>" LOC = "N2";	
define_attribute          {I2S_LRCLK_OE} xc_loc {N3} #	NET "FPGA_CON<167>" LOC = "N3";	
define_attribute          {I2S_SDIN} xc_loc {P4}     #	NET "FPGA_CON<168>" LOC = "P4";	
define_attribute          {I2S_SDOUT} xc_loc {P5}    #	NET "FPGA_CON<169>" LOC = "P5";	
define_attribute          {GPIO0[21]} xc_loc {R6}  #	NET "FPGA_CON<170>" LOC = "R6" L3MODE
define_attribute          {GPIO0[22]} xc_loc {P6}  #	NET "FPGA_CON<171>" LOC = "P6" L3CLOCK
define_attribute          {GPIO0[23]} xc_loc {M1}  #	NET "FPGA_CON<172>" LOC = "M1" L3DATA

define_attribute          {I2C_SCLi} xc_loc {N5}   #	NET "FPGA_CON<175>" LOC = "N5";
define_attribute          {I2C_SDAi} xc_loc {M2}   #	NET "FPGA_CON<176>" LOC = "M2";
define_attribute          {I2C_SCLo} xc_loc {M3}   #	NET "FPGA_CON<177>" LOC = "M3";
define_attribute          {I2C_SDAo} xc_loc {L3}   #	NET "FPGA_CON<178>" LOC = "L3";
define_attribute          {I2C_nSCLEn} xc_loc {L4} #	NET "FPGA_CON<179>" LOC = "L4";
define_attribute          {I2C_NSDAEn} xc_loc {K1} #	NET "FPGA_CON<180>" LOC = "K1";

define_attribute          {GPIO0[20]} xc_loc {F28}
define_attribute          {GPIO0[24]} xc_loc {AL21}
define_attribute          {GPIO0[25]} xc_loc {AK21}
define_attribute          {GPIO0[26]} xc_loc {AK19}
define_attribute          {GPIO0[27]} xc_loc {AJ19}
define_attribute          {BOOTNAND} xc_loc {AL19}
define_attribute          {BOOTCSSWAP} xc_loc {AL20}
define_attribute          {SevenSegmentControl[0]} xc_loc {J9}
define_attribute          {SevenSegmentControl[1]} xc_loc {J10}
define_attribute          {SevenSegmentControl[2]} xc_loc {B6}
define_attribute          {SevenSegmentControl[3]} xc_loc {A6}
define_attribute          {SevenSegmentControl[4]} xc_loc {E7}
define_attribute          {SevenSegmentControl[5]} xc_loc {D7}
define_attribute          {SevenSegmentControl[6]} xc_loc {D16}
define_attribute          {SevenSegmentControl[7]} xc_loc {E16}
define_attribute          {SevenSegmentCommon[0]} xc_loc {C8}
define_attribute          {SevenSegmentCommon[1]} xc_loc {B8}
define_attribute          {SevenSegmentCommon[2]} xc_loc {B11}
define_attribute          {SevenSegmentCommon[3]} xc_loc {B12}
define_attribute          {CLK200M_Out} xc_loc {B26}
define_attribute          {CLK100M_Out} xc_loc {A26}
define_attribute          {CLK50M_Out} xc_loc {E28}
define_attribute          {MacIntSrc[0]} xc_loc {H9}
define_attribute          {MacIntSrc[1]} xc_loc {F15}
define_attribute          {HADDR_M0[0]} xc_loc {G11}
define_attribute          {HADDR_M0[1]} xc_loc {F11}
define_attribute          {HADDR_M0[2]} xc_loc {A15}
define_attribute          {HADDR_M0[3]} xc_loc {B15}
define_attribute          {HADDR_M0[4]} xc_loc {D9}
define_attribute          {HADDR_M0[5]} xc_loc {C9}
define_attribute          {HADDR_M0[6]} xc_loc {G12}
define_attribute          {HADDR_M0[7]} xc_loc {G13}
define_attribute          {HADDR_M0[8]} xc_loc {J12}
define_attribute          {HADDR_M0[9]} xc_loc {H12}
define_attribute          {HADDR_M0[10]} xc_loc {E14}
define_attribute          {HADDR_M0[11]} xc_loc {F14}
define_attribute          {HADDR_M0[12]} xc_loc {F8}
define_attribute          {HADDR_M0[13]} xc_loc {E8}
define_attribute          {HADDR_M0[14]} xc_loc {A8}
define_attribute          {HADDR_M0[15]} xc_loc {A9}
define_attribute          {HADDR_M0[16]} xc_loc {H10}
define_attribute          {HADDR_M0[17]} xc_loc {G10}
define_attribute          {HADDR_M0[18]} xc_loc {C15}
define_attribute          {HADDR_M0[19]} xc_loc {D15}
define_attribute          {HADDR_M0[20]} xc_loc {C7}
define_attribute          {HADDR_M0[21]} xc_loc {B7}
define_attribute          {HADDR_M0[22]} xc_loc {D12}
define_attribute          {HADDR_M0[23]} xc_loc {C12}
define_attribute          {HADDR_M0[24]} xc_loc {F9}
define_attribute          {HADDR_M0[25]} xc_loc {E9}
define_attribute          {HADDR_M0[26]} xc_loc {H13}
define_attribute          {HADDR_M0[27]} xc_loc {J14}
define_attribute          {HADDR_M0[28]} xc_loc {C10}
define_attribute          {HADDR_M0[29]} xc_loc {B10}
define_attribute          {HADDR_M0[30]} xc_loc {F13}
define_attribute          {HADDR_M0[31]} xc_loc {E13}
define_attribute          {HTRANS_M0[0]} xc_loc {A10}
define_attribute          {HTRANS_M0[1]} xc_loc {A11}
define_attribute          {HWRITE_M0[0]} xc_loc {C14}
define_attribute          {HSIZE_M0[0]} xc_loc {D14}
define_attribute          {HSIZE_M0[1]} xc_loc {D10}
define_attribute          {HSIZE_M0[2]} xc_loc {D11}
define_attribute          {HBURST_M0[0]} xc_loc {C13}
define_attribute          {HBURST_M0[1]} xc_loc {B13}
define_attribute          {HBURST_M0[2]} xc_loc {E11}
define_attribute          {HPROT_M0[0]} xc_loc {E12}
define_attribute          {HPROT_M0[1]} xc_loc {A13}
define_attribute          {HPROT_M0[2]} xc_loc {A14}
define_attribute          {HPROT_M0[3]} xc_loc {T11}
define_attribute          {HWDATA_M0[0]} xc_loc {U12}
define_attribute          {HWDATA_M0[1]} xc_loc {R8}
define_attribute          {HWDATA_M0[2]} xc_loc {R9}
define_attribute          {HWDATA_M0[3]} xc_loc {P7}
define_attribute          {HWDATA_M0[4]} xc_loc {N7}
define_attribute          {HWDATA_M0[5]} xc_loc {M6}
define_attribute          {HWDATA_M0[6]} xc_loc {L6}
define_attribute          {HWDATA_M0[7]} xc_loc {N8}
define_attribute          {HWDATA_M0[8]} xc_loc {P9}
define_attribute          {HWDATA_M0[9]} xc_loc {M7}
define_attribute          {HWDATA_M0[10]} xc_loc {M8}
define_attribute          {HWDATA_M0[11]} xc_loc {U13}
define_attribute          {HWDATA_M0[12]} xc_loc {T13}
define_attribute          {HWDATA_M0[13]} xc_loc {R11}
define_attribute          {HWDATA_M0[14]} xc_loc {P11}
define_attribute          {HWDATA_M0[15]} xc_loc {G1}
define_attribute          {HWDATA_M0[16]} xc_loc {F1}
define_attribute          {HWDATA_M0[17]} xc_loc {K6}
define_attribute          {HWDATA_M0[18]} xc_loc {J6}
define_attribute          {HWDATA_M0[19]} xc_loc {G2}
define_attribute          {HWDATA_M0[20]} xc_loc {G3}
define_attribute          {HWDATA_M0[21]} xc_loc {J5}
define_attribute          {HWDATA_M0[22]} xc_loc {H5}
define_attribute          {HWDATA_M0[23]} xc_loc {L8}
define_attribute          {HWDATA_M0[24]} xc_loc {K7}
define_attribute          {HWDATA_M0[25]} xc_loc {R12}
define_attribute          {HWDATA_M0[26]} xc_loc {P12}
define_attribute          {HWDATA_M0[27]} xc_loc {E1}
define_attribute          {HWDATA_M0[28]} xc_loc {E2}
define_attribute          {HWDATA_M0[29]} xc_loc {T14}
define_attribute          {HWDATA_M0[30]} xc_loc {R14}
define_attribute          {HWDATA_M0[31]} xc_loc {D1}
define_attribute          {HRDATA_M0[0]} xc_loc {D2}
define_attribute          {HRDATA_M0[1]} xc_loc {E3}
define_attribute          {HRDATA_M0[2]} xc_loc {E4}
define_attribute          {HRDATA_M0[3]} xc_loc {N10}
define_attribute          {HRDATA_M0[4]} xc_loc {M10}
define_attribute          {HRDATA_M0[5]} xc_loc {T15}
define_attribute          {HRDATA_M0[6]} xc_loc {R16}
define_attribute          {HRDATA_M0[7]} xc_loc {F3}
define_attribute          {HRDATA_M0[8]} xc_loc {F4}
define_attribute          {HRDATA_M0[9]} xc_loc {N12}
define_attribute          {HRDATA_M0[10]} xc_loc {M11}
define_attribute          {HRDATA_M0[11]} xc_loc {G5}
define_attribute          {HRDATA_M0[12]} xc_loc {F5}
define_attribute          {HRDATA_M0[13]} xc_loc {G6}
define_attribute          {HRDATA_M0[14]} xc_loc {G7}
define_attribute          {HRDATA_M0[15]} xc_loc {J7}
define_attribute          {HRDATA_M0[16]} xc_loc {H7}
define_attribute          {HRDATA_M0[17]} xc_loc {F6}
define_attribute          {HRDATA_M0[18]} xc_loc {E6}
define_attribute          {HRDATA_M0[19]} xc_loc {C2}
define_attribute          {HRDATA_M0[20]} xc_loc {C3}
define_attribute          {HRDATA_M0[21]} xc_loc {D5}
define_attribute          {HRDATA_M0[22]} xc_loc {D6}
define_attribute          {HRDATA_M0[23]} xc_loc {D4}
define_attribute          {HRDATA_M0[24]} xc_loc {C4}
define_attribute          {HRDATA_M0[25]} xc_loc {C5}
define_attribute          {HRDATA_M0[26]} xc_loc {B5}
define_attribute          {HRDATA_M0[27]} xc_loc {B3}
define_attribute          {HRDATA_M0[28]} xc_loc {A3}
define_attribute          {HRDATA_M0[29]} xc_loc {A4}
define_attribute          {HRDATA_M0[30]} xc_loc {A5}
define_attribute          {HRDATA_M0[31]} xc_loc {W12}
define_attribute          {HREADY_OUT_M0} xc_loc {Y13}
define_attribute          {HRESP_M0[0]} xc_loc {Y11}
define_attribute          {HRESP_M0[1]} xc_loc {AA11}
define_attribute          {HADDR_S0[0]} xc_loc {AD6}
define_attribute          {HADDR_S0[1]} xc_loc {AE6}
define_attribute          {HADDR_S0[2]} xc_loc {AE4}
define_attribute          {HADDR_S0[3]} xc_loc {AF4}
define_attribute          {HADDR_S0[4]} xc_loc {AE1}
define_attribute          {HADDR_S0[5]} xc_loc {AF1}
define_attribute          {HADDR_S0[6]} xc_loc {AD11}
define_attribute          {HADDR_S0[7]} xc_loc {AC12}
define_attribute          {HADDR_S0[8]} xc_loc {AE2}
define_attribute          {HADDR_S0[9]} xc_loc {AE3}
define_attribute          {HADDR_S0[10]} xc_loc {AC7}
define_attribute          {HADDR_S0[11]} xc_loc {AD7}
define_attribute          {HADDR_S0[12]} xc_loc {AD9}
define_attribute          {HADDR_S0[13]} xc_loc {AC10}
define_attribute          {HADDR_S0[14]} xc_loc {AC14}
define_attribute          {HADDR_S0[15]} xc_loc {AB15}
define_attribute          {HADDR_S0[16]} xc_loc {AC13}
define_attribute          {HADDR_S0[17]} xc_loc {AB13}
define_attribute          {HADDR_S0[18]} xc_loc {AD4}
define_attribute          {HADDR_S0[19]} xc_loc {AD5}
define_attribute          {HADDR_S0[20]} xc_loc {AD1}
define_attribute          {HADDR_S0[21]} xc_loc {AD2}
define_attribute          {HADDR_S0[22]} xc_loc {AB8}
define_attribute          {HADDR_S0[23]} xc_loc {AC8}
define_attribute          {HADDR_S0[24]} xc_loc {AC4}
define_attribute          {HADDR_S0[25]} xc_loc {AC5}
define_attribute          {HADDR_S0[26]} xc_loc {AB10}
define_attribute          {HADDR_S0[27]} xc_loc {AB11}
define_attribute          {HADDR_S0[28]} xc_loc {AA8}
define_attribute          {HADDR_S0[29]} xc_loc {AB7}
define_attribute          {HADDR_S0[30]} xc_loc {AC2}
define_attribute          {HADDR_S0[31]} xc_loc {AC3}
define_attribute          {HTRANS_S0[0]} xc_loc {AB1}
define_attribute          {HTRANS_S0[1]} xc_loc {AB2}
define_attribute          {HWRITE_S0} xc_loc {AB5}
define_attribute          {HSIZE_S0[0]} xc_loc {AB6}
define_attribute          {HSIZE_S0[1]} xc_loc {AA5}
define_attribute          {HSIZE_S0[2]} xc_loc {AA6}
define_attribute          {HBURST_S0[0]} xc_loc {AA13}
define_attribute          {HBURST_S0[1]} xc_loc {AA14}
define_attribute          {HBURST_S0[2]} xc_loc {AA1}
define_attribute          {HPROT_S0[0]} xc_loc {Y1}
define_attribute          {HPROT_S0[1]} xc_loc {AB3}
define_attribute          {HPROT_S0[2]} xc_loc {AA3}
define_attribute          {HPROT_S0[3]} xc_loc {Y2}
define_attribute          {HWDATA_S0[0]} xc_loc {Y3}
define_attribute          {HWDATA_S0[1]} xc_loc {AA4}
define_attribute          {HWDATA_S0[2]} xc_loc {Y4}
define_attribute          {HWDATA_S0[3]} xc_loc {Y6}
define_attribute          {HWDATA_S0[4]} xc_loc {Y7}
define_attribute          {HWDATA_S0[5]} xc_loc {W1}
define_attribute          {HWDATA_S0[6]} xc_loc {W2}
define_attribute          {HWDATA_S0[7]} xc_loc {V2}
define_attribute          {HWDATA_S0[8]} xc_loc {V3}
define_attribute          {HWDATA_S0[9]} xc_loc {W4}
define_attribute          {HWDATA_S0[10]} xc_loc {V4}
define_attribute          {HWDATA_S0[11]} xc_loc {AT3}
define_attribute          {HWDATA_S0[12]} xc_loc {AU3}
define_attribute          {HWDATA_S0[13]} xc_loc {AT5}
define_attribute          {HWDATA_S0[14]} xc_loc {AT6}
define_attribute          {HWDATA_S0[15]} xc_loc {AP4}
define_attribute          {HWDATA_S0[16]} xc_loc {AP5}
define_attribute          {HWDATA_S0[17]} xc_loc {AP6}
define_attribute          {HWDATA_S0[18]} xc_loc {AR6}
define_attribute          {HWDATA_S0[19]} xc_loc {AM6}
define_attribute          {HWDATA_S0[20]} xc_loc {AM7}
define_attribute          {HWDATA_S0[21]} xc_loc {AR4}
define_attribute          {HWDATA_S0[22]} xc_loc {AT4}
define_attribute          {HWDATA_S0[23]} xc_loc {AR2}
define_attribute          {HWDATA_S0[24]} xc_loc {AR3}
define_attribute          {HWDATA_S0[25]} xc_loc {AU1}
define_attribute          {HWDATA_S0[26]} xc_loc {AU2}
define_attribute          {HWDATA_S0[27]} xc_loc {AR1}
define_attribute          {HWDATA_S0[28]} xc_loc {AT1}
define_attribute          {HWDATA_S0[29]} xc_loc {AK8}
define_attribute          {HWDATA_S0[30]} xc_loc {AL8}
define_attribute          {HWDATA_S0[31]} xc_loc {AL5}
define_attribute          {HRDATA_S0[0]} xc_loc {AM5}
define_attribute          {HRDATA_S0[1]} xc_loc {AN4}
define_attribute          {HRDATA_S0[2]} xc_loc {AN5}
define_attribute          {HRDATA_S0[3]} xc_loc {AJ7}
define_attribute          {HRDATA_S0[4]} xc_loc {AK7}
define_attribute          {HRDATA_S0[5]} xc_loc {AH9}
define_attribute          {HRDATA_S0[6]} xc_loc {AH10}
define_attribute          {HRDATA_S0[7]} xc_loc {AN2}
define_attribute          {HRDATA_S0[8]} xc_loc {AN3}
define_attribute          {HRDATA_S0[9]} xc_loc {AK6}
define_attribute          {HRDATA_S0[10]} xc_loc {AL6}
define_attribute          {HRDATA_S0[11]} xc_loc {AK4}
define_attribute          {HRDATA_S0[12]} xc_loc {AL4}
define_attribute          {HRDATA_S0[13]} xc_loc {AP1}
define_attribute          {HRDATA_S0[14]} xc_loc {AP2}
define_attribute          {HRDATA_S0[15]} xc_loc {AM1}
define_attribute          {HRDATA_S0[16]} xc_loc {AM2}
define_attribute          {HRDATA_S0[17]} xc_loc {AL3}
define_attribute          {HRDATA_S0[18]} xc_loc {AM3}
define_attribute          {HRDATA_S0[19]} xc_loc {AE11}
define_attribute          {HRDATA_S0[20]} xc_loc {AE12}
define_attribute          {HRDATA_S0[21]} xc_loc {AG10}
define_attribute          {HRDATA_S0[22]} xc_loc {AF11}
define_attribute          {HRDATA_S0[23]} xc_loc {AK2}
define_attribute          {HRDATA_S0[24]} xc_loc {AK3}
define_attribute          {HRDATA_S0[25]} xc_loc {AJ5}
define_attribute          {HRDATA_S0[26]} xc_loc {AJ6}
define_attribute          {HRDATA_S0[27]} xc_loc {AH4}
define_attribute          {HRDATA_S0[28]} xc_loc {AJ4}
define_attribute          {HRDATA_S0[29]} xc_loc {AH7}
define_attribute          {HRDATA_S0[30]} xc_loc {AG8}
define_attribute          {HRDATA_S0[31]} xc_loc {AF8}
define_attribute          {HREADY_IN_S0} xc_loc {AF9}
define_attribute          {HRESP_S0[0]} xc_loc {AK1}
define_attribute          {HRESP_S0[1]} xc_loc {AL1}
define_attribute          {HSEL_S0} xc_loc {AJ1}
define_attribute          {HADDR_S1[0]} xc_loc {AM13}
define_attribute          {HADDR_S1[1]} xc_loc {AN14}
define_attribute          {HADDR_S1[2]} xc_loc {AV9}
define_attribute          {HADDR_S1[3]} xc_loc {AW9}
define_attribute          {HADDR_S1[4]} xc_loc {AV12}
define_attribute          {HADDR_S1[5]} xc_loc {AW12}
define_attribute          {HADDR_S1[6]} xc_loc {AV7}
define_attribute          {HADDR_S1[7]} xc_loc {AV8}
define_attribute          {HADDR_S1[8]} xc_loc {AU11}
define_attribute          {HADDR_S1[9]} xc_loc {AU12}
define_attribute          {HADDR_S1[10]} xc_loc {AT9}
define_attribute          {HADDR_S1[11]} xc_loc {AT10}
define_attribute          {HADDR_S1[12]} xc_loc {AU13}
define_attribute          {HADDR_S1[13]} xc_loc {AV13}
define_attribute          {HADDR_S1[14]} xc_loc {AP9}
define_attribute          {HADDR_S1[15]} xc_loc {AR9}
define_attribute          {HADDR_S1[16]} xc_loc {AP12}
define_attribute          {HADDR_S1[17]} xc_loc {AR12}
define_attribute          {HADDR_S1[18]} xc_loc {AT8}
define_attribute          {HADDR_S1[19]} xc_loc {AU8}
define_attribute          {HADDR_S1[20]} xc_loc {AL13}
define_attribute          {HADDR_S1[21]} xc_loc {AL14}
define_attribute          {HADDR_S1[22]} xc_loc {AU6}
define_attribute          {HADDR_S1[23]} xc_loc {AU7}
define_attribute          {HADDR_S1[24]} xc_loc {AP11}
define_attribute          {HADDR_S1[25]} xc_loc {AN12}
define_attribute          {HADDR_S1[26]} xc_loc {AJ12}
define_attribute          {HADDR_S1[27]} xc_loc {AH13}
define_attribute          {HADDR_S1[28]} xc_loc {AN10}
define_attribute          {HADDR_S1[29]} xc_loc {AM11}
define_attribute          {HADDR_S1[30]} xc_loc {AL10}
define_attribute          {HADDR_S1[31]} xc_loc {AM10}
define_attribute          {HTRANS_S1[0]} xc_loc {AW6}
define_attribute          {HTRANS_S1[1]} xc_loc {AW7}
define_attribute          {HWRITE_S1} xc_loc {AW4}
define_attribute          {HSIZE_S1[0]} xc_loc {AW5}
define_attribute          {HSIZE_S1[1]} xc_loc {AK11}
define_attribute          {HSIZE_S1[2]} xc_loc {AL11}
define_attribute          {HBURST_S1[0]} xc_loc {AV3}
define_attribute          {HBURST_S1[1]} xc_loc {AV4}
define_attribute          {HBURST_S1[2]} xc_loc {AR7}
define_attribute          {HPROT_S1[0]} xc_loc {AR8}
define_attribute          {HPROT_S1[1]} xc_loc {AN7}
define_attribute          {HPROT_S1[2]} xc_loc {AP7}
define_attribute          {HPROT_S1[3]} xc_loc {AN15}
define_attribute          {HWDATA_S1[0]} xc_loc {AM15}
define_attribute          {HWDATA_S1[1]} xc_loc {AK9}
define_attribute          {HWDATA_S1[2]} xc_loc {AL9}
define_attribute          {HWDATA_S1[3]} xc_loc {AN8}
define_attribute          {HWDATA_S1[4]} xc_loc {AN9}
define_attribute          {HWDATA_S1[5]} xc_loc {AJ9}
define_attribute          {HWDATA_S1[6]} xc_loc {AJ10}
define_attribute          {HWDATA_S1[7]} xc_loc {AU5}
define_attribute          {HWDATA_S1[8]} xc_loc {AV5}
define_attribute          {HWDATA_S1[9]} xc_loc {AT33}
define_attribute          {HWDATA_S1[10]} xc_loc {AR33}
define_attribute          {HWDATA_S1[11]} xc_loc {AJ30}
define_attribute          {HWDATA_S1[12]} xc_loc {AK31}
define_attribute          {HWDATA_S1[13]} xc_loc {AM30}
define_attribute          {HWDATA_S1[14]} xc_loc {AL30}
define_attribute          {HWDATA_S1[15]} xc_loc {AM31}
define_attribute          {HWDATA_S1[16]} xc_loc {AL31}
define_attribute          {HWDATA_S1[17]} xc_loc {AP24}
define_attribute          {HWDATA_S1[18]} xc_loc {AR24}
define_attribute          {HWDATA_S1[19]} xc_loc {AP32}
define_attribute          {HWDATA_S1[20]} xc_loc {AN32}
define_attribute          {HWDATA_S1[21]} xc_loc {AN30}
define_attribute          {HWDATA_S1[22]} xc_loc {AP31}
define_attribute          {HWDATA_S1[23]} xc_loc {AK29}
define_attribute          {HWDATA_S1[24]} xc_loc {AJ29}
define_attribute          {HWDATA_S1[25]} xc_loc {AT24}
define_attribute          {HWDATA_S1[26]} xc_loc {AT25}
define_attribute          {HWDATA_S1[27]} xc_loc {AW34}
define_attribute          {HWDATA_S1[28]} xc_loc {AV34}
define_attribute          {HWDATA_S1[29]} xc_loc {AW30}
define_attribute          {HWDATA_S1[30]} xc_loc {AW31}
define_attribute          {HWDATA_S1[31]} xc_loc {AV33}
define_attribute          {HRDATA_S1[0]} xc_loc {AU33}
define_attribute          {HRDATA_S1[1]} xc_loc {AP25}
define_attribute          {HRDATA_S1[2]} xc_loc {AP26}
define_attribute          {HRDATA_S1[3]} xc_loc {AT31}
define_attribute          {HRDATA_S1[4]} xc_loc {AT30}
define_attribute          {HRDATA_S1[5]} xc_loc {AU25}
define_attribute          {HRDATA_S1[6]} xc_loc {AV25}
define_attribute          {HRDATA_S1[7]} xc_loc {AR31}
define_attribute          {HRDATA_S1[8]} xc_loc {AR32}
define_attribute          {HRDATA_S1[9]} xc_loc {AL26}
define_attribute          {HRDATA_S1[10]} xc_loc {AM27}
define_attribute          {HRDATA_S1[11]} xc_loc {AU31}
define_attribute          {HRDATA_S1[12]} xc_loc {AU32}
define_attribute          {HRDATA_S1[13]} xc_loc {AV28}
define_attribute          {HRDATA_S1[14]} xc_loc {AU28}
define_attribute          {HRDATA_S1[15]} xc_loc {AW32}
define_attribute          {HRDATA_S1[16]} xc_loc {AV32}
define_attribute          {HRDATA_S1[17]} xc_loc {AW25}
define_attribute          {HRDATA_S1[18]} xc_loc {AW26}
define_attribute          {HRDATA_S1[19]} xc_loc {AP29}
define_attribute          {HRDATA_S1[20]} xc_loc {AN29}
define_attribute          {HRDATA_S1[21]} xc_loc {AN27}
define_attribute          {HRDATA_S1[22]} xc_loc {AN28}
define_attribute          {HRDATA_S1[23]} xc_loc {AL28}
define_attribute          {HRDATA_S1[24]} xc_loc {AM28}
define_attribute          {HRDATA_S1[25]} xc_loc {AP27}
define_attribute          {HRDATA_S1[26]} xc_loc {AR27}
define_attribute          {HRDATA_S1[27]} xc_loc {AV30}
define_attribute          {HRDATA_S1[28]} xc_loc {AU30}
define_attribute          {HRDATA_S1[29]} xc_loc {AR26}
define_attribute          {HRDATA_S1[30]} xc_loc {AT26}
define_attribute          {HRDATA_S1[31]} xc_loc {AW29}
define_attribute          {HREADY_IN_S1} xc_loc {AV29}
define_attribute          {HRESP_S1[0]} xc_loc {AV27}
define_attribute          {HRESP_S1[1]} xc_loc {AW27}
define_attribute          {HSEL_S1} xc_loc {AT29}
define_attribute          {adin[0]} xc_loc {R31}
define_attribute          {adin[1]} xc_loc {R32}
define_attribute          {adin[2]} xc_loc {P34}
define_attribute          {adin[3]} xc_loc {P35}
define_attribute          {adin[4]} xc_loc {T29}
define_attribute          {adin[5]} xc_loc {U28}
define_attribute          {adin[6]} xc_loc {P36}
define_attribute          {adin[7]} xc_loc {P37}
define_attribute          {adin[8]} xc_loc {N37}
define_attribute          {adin[9]} xc_loc {N38}
define_attribute          {adin[10]} xc_loc {N39}
define_attribute          {adin[11]} xc_loc {P39}
define_attribute          {adin[12]} xc_loc {R34}
define_attribute          {adin[13]} xc_loc {T34}
define_attribute          {adin[14]} xc_loc {T31}
define_attribute          {adin[15]} xc_loc {U30}
define_attribute          {adin[16]} xc_loc {R36}
define_attribute          {adin[17]} xc_loc {T36}
define_attribute          {adin[18]} xc_loc {T33}
define_attribute          {adin[19]} xc_loc {U32}
define_attribute          {adin[20]} xc_loc {R37}
define_attribute          {adin[21]} xc_loc {R38}
define_attribute          {adin[22]} xc_loc {R39}
define_attribute          {adin[23]} xc_loc {T39}
define_attribute          {adin[24]} xc_loc {V25}
define_attribute          {adin[25]} xc_loc {U26}
define_attribute          {adin[26]} xc_loc {V27}
define_attribute          {adin[27]} xc_loc {U27}
define_attribute          {adin[28]} xc_loc {T35}
define_attribute          {adin[29]} xc_loc {U35}
define_attribute          {adin[30]} xc_loc {U33}
define_attribute          {adin[31]} xc_loc {V33}
define_attribute          {adout[0]} xc_loc {T38}
define_attribute          {adout[1]} xc_loc {U38}
define_attribute          {adout[2]} xc_loc {V29}
define_attribute          {adout[3]} xc_loc {V30}
define_attribute          {adout[4]} xc_loc {U36}
define_attribute          {adout[5]} xc_loc {U37}
define_attribute          {adout[6]} xc_loc {V32}
define_attribute          {adout[7]} xc_loc {W32}
define_attribute          {adout[8]} xc_loc {W26}
define_attribute          {adout[9]} xc_loc {W27}
define_attribute          {adout[10]} xc_loc {V34}
define_attribute          {adout[11]} xc_loc {V35}
define_attribute          {adout[12]} xc_loc {V37}
define_attribute          {adout[13]} xc_loc {V38}
define_attribute          {adout[14]} xc_loc {V39}
define_attribute          {adout[15]} xc_loc {W39}
define_attribute          {adout[16]} xc_loc {W34}
define_attribute          {adout[17]} xc_loc {W35}
define_attribute          {adout[18]} xc_loc {W36}
define_attribute          {adout[19]} xc_loc {W37}
define_attribute          {adout[20]} xc_loc {Y37}
define_attribute          {adout[21]} xc_loc {Y38}
define_attribute          {adout[22]} xc_loc {Y39}
define_attribute          {adout[23]} xc_loc {AA39}
define_attribute          {adout[24]} xc_loc {AA36}
define_attribute          {adout[25]} xc_loc {Y36}
define_attribute          {adout[26]} xc_loc {Y33}
define_attribute          {adout[27]} xc_loc {Y34}
define_attribute          {adout[28]} xc_loc {AB36}
define_attribute          {adout[29]} xc_loc {AB37}
define_attribute          {adout[30]} xc_loc {AB38}
define_attribute          {adout[31]} xc_loc {AA38}
define_attribute          {arb_gnt_b[1]} xc_loc {D34}
define_attribute          {arb_gnt_b[2]} xc_loc {D35}
define_attribute          {arb_gnt_b[3]} xc_loc {C37}
define_attribute          {arb_gnt_b[4]} xc_loc {C38}
define_attribute          {arb_req_b[1]} xc_loc {E34}
define_attribute          {arb_req_b[2]} xc_loc {F34}
define_attribute          {arb_req_b[3]} xc_loc {F35}
define_attribute          {arb_req_b[4]} xc_loc {G35}
define_attribute          {cbein_b[0]} xc_loc {D36}define_attribute          {cbein_b[1]} xc_loc {D37}
define_attribute          {cbein_b[2]} xc_loc {H33}
define_attribute          {cbein_b[3]} xc_loc {H34}
define_attribute          {cbeout_b[0]} xc_loc {E36}
define_attribute          {cbeout_b[1]} xc_loc {F36}
define_attribute          {cbeout_b[2]} xc_loc {C39}
define_attribute          {cbeout_b[3]} xc_loc {D39}
define_attribute          {devselin_b} xc_loc {H37}
define_attribute          {devselout_b} xc_loc {H38}
define_attribute          {framein_b} xc_loc {N30}
define_attribute          {frameout_b} xc_loc {P29}
define_attribute          {idsel} xc_loc {L34}
define_attribute          {intaout_b} xc_loc {L35}
define_attribute          {irdyin_b} xc_loc {J36}
define_attribute          {irdyout_b} xc_loc {J37}
define_attribute          {parin} xc_loc {K36}
define_attribute          {parout} xc_loc {L36}
define_attribute          {perrin_b} xc_loc {H39}
define_attribute          {perrout_b} xc_loc {J39}
define_attribute          {serrout_b} xc_loc {M33}
define_attribute          {stopin_b} xc_loc {N32}
define_attribute          {stopout_b} xc_loc {R28}
define_attribute          {trdyin_b} xc_loc {R29}
define_attribute          {trdyout_b} xc_loc {M35}
define_attribute          {oe_ad} xc_loc {N35}
define_attribute          {oe_cbe} xc_loc {K37}
define_attribute          {oe_devsel} xc_loc {K38}
define_attribute          {oe_frame} xc_loc {N33}
define_attribute          {oe_irdy} xc_loc {N34}
define_attribute          {oe_par} xc_loc {P31}
define_attribute          {oe_perr} xc_loc {P32}
define_attribute          {oe_req} xc_loc {K39}
define_attribute          {oe_stop} xc_loc {L39}
define_attribute          {oe_trdy} xc_loc {L38}
define_attribute          {PCI_INTAb} xc_loc {M38}
define_attribute          {PCI_INTBb} xc_loc {M36}
define_attribute          {PCI_INTCb} xc_loc {M37}
define_attribute          {PCI_INTDb} xc_loc {AP34}
define_attribute          {pci_clk} xc_loc {AR34}
define_attribute          {pci_reset} xc_loc {AV35}

#
# I/O standards
#

#
# Compile Points
#

#
# Other Constraints
#
