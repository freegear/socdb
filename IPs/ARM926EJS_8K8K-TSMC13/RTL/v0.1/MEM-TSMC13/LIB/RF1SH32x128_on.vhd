--------------------------------------------------------------------------
--      CONFIDENTIAL AND PROPRIETARY SOFTWARE/DATA OF ARTISAN COMPONENTS, INC.
--      
--      Copyright (c) 2006 Artisan Components, Inc.  All Rights Reserved.
--      
--      Use of this Software/Data is subject to the terms and conditions of
--      the applicable license agreement between Artisan Components, Inc. and
--      Taiwan Semiconductor Manufacturing Company Ltd..  In addition, this Software/Data
--      is protected by copyright law and international treaties.
--      
--      The copyright notice(s) in this Software/Data does not indicate actual
--      or intended publication of this Software/Data.
--      name:			RF-SP-HS Register File Generator
--           			TSMC CL013G-FSG Process
--      version:		2003Q4V1
--      comment:		
--      configuration:	 -instname "RF1SH32x128_on" -words 32 -bits 128 -frequency 100 -ring_width 2 -mux 1 -drive 4 -write_mask on -wp_size 8 -top_layer met6 -power_type rings -horiz met3 -vert met2 -cust_comment "" -left_bus_delim "[" -right_bus_delim "]" -pwr_gnd_rename "VDD:VDD,GND:VSS" -prefix "" -pin_space 0.0 -name_case upper -check_instname on -diodes on -inside_ring_type GND
--
--      VHDL model for Synchronous Single-Port Register File
--
--      Instance:       RF1SH32x128_on
--      Address Length: 32
--      Word Width:     128
--      Pipeline:       No
--
--      Creation Date:  2006-12-19 03:42:11Z
--      Version:        2003Q4V1
--
--      Verified With:  Model Technology VCOM V-System VHDL
--			Version 5.2c
--
--      Modeling Assumptions: This model supports full gate-level simulaton
--          including proper x-handling and timing check behavior.  It is
--          VITAL_LEVEL1 compliant.  Unit delay timing is included in the
--          model. Back-annotation of SDF (v2.1) is supported.  SDF can be
--          created utilyzing the delay calculation views provided with this
--          generator and supported delay calculators.  For netlisting
--          simplicity, buses are not exploded.  All buses are modeled
--          [MSB:LSB].  To operate properly, this model must be used with the
--          Artisan's Vhdl packages.
--
--      Modeling Limitations: To be compatible with Synopsys/VSS in term of
--	    SDF back-annotation, this model has to be Vital Level0 compliant.
--	    This feature may result in degraded performances.
--
--      Known Bugs: None.
--
--      Known Work Arounds: N/A
--------------------------------------------------------------------------
-------------------
use std.all;
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_timing.all;
use IEEE.VITAL_primitives.all;
use WORK.vlibs.all; 

Package RF1SH32x128_on_pkgs is
  component rdwr_RF1SH32x128_on
    generic(
	TimingChecksOn: BOOLEAN := TRUE;
	tperiod_CLK  : VitalDelayType;
	tpw_CLK_negedge: VitalDelayType;
	tpw_CLK_posedge: VitalDelayType;
	tipd_CLK: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CEN: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WEN: VitalDelayArrayType01(15 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_A: VitalDelayArrayType01(4 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_D: VitalDelayArrayType01(127 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CEN_CLK_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CEN_CLK_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WEN_CLK_posedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(1.000 ns));
	tsetup_WEN_CLK_negedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_posedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_negedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_posedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_negedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(1.000 ns));
	thold_CEN_CLK_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CEN_CLK_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WEN_CLK_posedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(0.500 ns));
	thold_WEN_CLK_negedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_posedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_negedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_posedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_negedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(0.500 ns));
	tpd_CLK_Q	: VitalDelayArrayType01(127 downto 0) := (others => (1.0 ns, 1.0 ns));
	PortName	: string
    );
    port ( 
	CLK: in std_logic;
	CEN: in std_logic;
	WEN: in std_logic_vector(15 downto 0);
	A: in std_logic_vector(4 downto 0);
	D: in std_logic_vector(127 downto 0);
	Q: out std_logic_vector(127 downto 0);
	Read: out std_logic:='0';
	Write: out std_logic:='0';
	GtpRst  : in std_logic;
	Am  : out std_logic_vector;
	Bm  : out std_logic_vector;
	Dm  : out std_logic_vector;
	Qi  : in std_logic_vector
    );
end component; 
 component RF1SH32x128_on
    generic(
	tperiod_CLK  : VitalDelayType := 2.000 ns;
	tpw_CLK_negedge: VitalDelayType := 1.000 ns;
	tpw_CLK_posedge: VitalDelayType := 1.000 ns;
	tipd_CLK: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CEN: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WEN: VitalDelayArrayType01(15 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_A: VitalDelayArrayType01(4 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_D: VitalDelayArrayType01(127 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CEN_CLK_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CEN_CLK_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WEN_CLK_posedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(1.000 ns));
	tsetup_WEN_CLK_negedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_posedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_negedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_posedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_negedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(1.000 ns));
	thold_CEN_CLK_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CEN_CLK_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WEN_CLK_posedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(0.500 ns));
	thold_WEN_CLK_negedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_posedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_negedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_posedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_negedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(0.500 ns));

	tpd_CLK_Q: VitalDelayArrayType01(127 downto 0):=(others=>(1.0 ns,1.0 ns));
	TimingChecksOn: BOOLEAN := TRUE
    );
    port ( 
	CLK: in std_logic;
	CEN: in std_logic;
	WEN: in std_logic_vector(15 downto 0);
	A: in std_logic_vector(4 downto 0);
	D: in std_logic_vector(127 downto 0);
	Q: out std_logic_vector(127 downto 0)
    );
 end component; 
End RF1SH32x128_on_pkgs;
-------------------
use std.all;
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_timing.all;
use IEEE.VITAL_primitives.all;
use WORK.vlibs.all; 
use WORK.lib_cells_pkgs.all;
use WORK.RF1SH32x128_on_pkgs.all;

  entity rdwr_RF1SH32x128_on is
    generic(
	TimingChecksOn: BOOLEAN := TRUE;
	tperiod_CLK  : VitalDelayType;
	tpw_CLK_negedge: VitalDelayType;
	tpw_CLK_posedge: VitalDelayType;
	tipd_CLK: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CEN: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WEN: VitalDelayArrayType01(15 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_A: VitalDelayArrayType01(4 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_D: VitalDelayArrayType01(127 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CEN_CLK_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CEN_CLK_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WEN_CLK_posedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(1.000 ns));
	tsetup_WEN_CLK_negedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_posedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_negedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_posedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_negedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(1.000 ns));
	thold_CEN_CLK_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CEN_CLK_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WEN_CLK_posedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(0.500 ns));
	thold_WEN_CLK_negedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_posedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_negedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_posedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_negedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(0.500 ns));
	tpd_CLK_Q	: VitalDelayArrayType01(127 downto 0) := (others => (1.0 ns, 1.0 ns));
	PortName	: string
    );
    port ( 
	CLK: in std_logic;
	CEN: in std_logic;
	WEN: in std_logic_vector(15 downto 0);
	A: in std_logic_vector(4 downto 0);
	D: in std_logic_vector(127 downto 0);
	Q: out std_logic_vector(127 downto 0);
	Read: out std_logic:='0';
	Write: out std_logic:='0';
	GtpRst  : in std_logic;
	Am  : out std_logic_vector;
	Bm  : out std_logic_vector;
	Dm  : out std_logic_vector;
	Qi  : in std_logic_vector
    );
    attribute VITAL_LEVEL1 of rdwr_RF1SH32x128_on : entity is TRUE;
end rdwr_RF1SH32x128_on;

-------------- -------------- -------------- -------------- --------------
architecture BEHAVIORAL of rdwr_RF1SH32x128_on is
  constant ClkPort	: string:=cat("CLK",PortName);
  constant InstPort	: string:="RF1SH32x128_on";
  signal ANi,MANi	: std_logic_vector(A'range);
  signal ANVio 		: std_logic_vector(A'range);
  signal WENVio, WENi 	: std_logic_vector(WEN'range);
  signal WENib	 	: std_logic_vector(WEN'range);
  signal DTP_INT 	: std_logic_vector(D'range);
  signal CENi           : std_logic;
  signal CENib		: std_logic;
  signal CENVio		: std_logic;
  signal CLK_INT	: std_logic;
  signal GTP_INT	: std_logic:='0';
  signal GTP_RdWr	: std_logic:='0';
  signal Di,MDi		: std_logic_vector(D'range);
  signal DVio		: std_logic_vector(D'range);

--------------
begin
--------------
TPW_CLK: TPwCell   generic map(tipd_clk=>tipd_CLK, tperiod_clk=>tperiod_CLK,
                                tpw_clk_posedge=>tpw_CLK_posedge, tpw_clk_negedge=>tpw_CLK_negedge,
				TimingChecksOn=>TimingChecksOn, TestSignalName=>ClkPort, HeaderMsg=>InstPort)
                    port map(out0=>CLK_INT, clk=>CLK);
--------------
WEN_CELLS: for i in 0 to 15 generate
  TCH_WEN: TChCellEdges   generic map(tipd_in0=>tipd_WEN(i), tsetup_in0_clk_posedge_posedge=>tsetup_WEN_CLK_posedge_posedge(i),
                                thold_in0_clk_posedge_posedge=>thold_WEN_CLK_posedge_posedge(i), 
				tsetup_in0_clk_negedge_posedge=>tsetup_WEN_CLK_negedge_posedge(i),
                                thold_in0_clk_negedge_posedge=>thold_WEN_CLK_negedge_posedge(i), 
                                TestSignalName=>ClkPort, RefSignalName=>icat("WEN","",i), 
				TimingChecksOn=>TimingChecksOn, HeaderMsg=>InstPort)
                    port map(in0=>WEN(i), clk=>GTP_INT, Violation=>WENVio(i),out0=>WENi(i));
end generate;                      
--------------
TCH_CEN: TChCellEdges  generic map(tipd_in0=>tipd_CEN, tsetup_in0_clk_posedge_posedge=>tsetup_CEN_CLK_posedge_posedge,
                                thold_in0_clk_posedge_posedge=>thold_CEN_CLK_posedge_posedge, 
				tsetup_in0_clk_negedge_posedge=>tsetup_CEN_CLK_negedge_posedge,
                                thold_in0_clk_negedge_posedge=>thold_CEN_CLK_negedge_posedge, 
                                TestSignalName=>ClkPort, RefSignalName=>cat("CEN",PortName), 
				TimingChecksOn=>TimingChecksOn, HeaderMsg=>InstPort)
                    port map(in0=>CEN, clk=>CLK_INT, Violation=>CENVio,out0=>CENi);
--------------
TA_A_UTI: for i in 0 to 4 generate
TCH_A: TChCellEdges  generic map(tipd_in0=>tipd_A(i), tsetup_in0_clk_posedge_posedge=>tsetup_A_CLK_posedge_posedge(i),
                                thold_in0_clk_posedge_posedge=>thold_A_CLK_posedge_posedge(i), 
				tsetup_in0_clk_negedge_posedge=>tsetup_A_CLK_negedge_posedge(i),
                                thold_in0_clk_negedge_posedge=>thold_A_CLK_negedge_posedge(i),
                                TestSignalName=>ClkPort, RefSignalName=>icat("A","",i), 
				TimingChecksOn=>TimingChecksOn, HeaderMsg=>InstPort)
                    port map(in0=>A(i), clk=>GTP_INT, Violation=>ANVio(i),out0=>MANi(i));
end generate;                      

--------------
D_UTI: for i in 0 to 127 generate
 TCH_D: TChCellEdges  generic map(tipd_in0=>tipd_D(i), tsetup_in0_clk_posedge_posedge=>tsetup_D_CLK_posedge_posedge(i),
                                thold_in0_clk_posedge_posedge=>thold_D_CLK_posedge_posedge(i), 
				tsetup_in0_clk_negedge_posedge=>tsetup_D_CLK_negedge_posedge(i),
                                thold_in0_clk_negedge_posedge=>thold_D_CLK_negedge_posedge(i),
                                TestSignalName=>ClkPort, RefSignalName=>icat("D","",i), 
				TimingChecksOn=>TimingChecksOn, HeaderMsg=>InstPort)
                    port map(in0=>D(i), clk=>DTP_INT(i), Violation=>DVio(i),out0=>MDi(i));

  Q_AMPS: buf	     generic map(tpd_in0_out0=>tpd_CLK_Q(i))
                     port map(in0=>Qi(i), out0=>Q(i));
end generate;      

--------------
GTP : process(GtpRst, CLK_INT, CENVio)
 Begin
  if((GtpRst'event and GtpRst='0' and CLK_INT /= 'X') or (CLK_INT'event and CLK_INT='0')) then
    GTP_INT <= '0'; 
    DTP_INT(0) <= '0';
    DTP_INT(1) <= '0';
    DTP_INT(2) <= '0';
    DTP_INT(3) <= '0';
    DTP_INT(4) <= '0';
    DTP_INT(5) <= '0';
    DTP_INT(6) <= '0';
    DTP_INT(7) <= '0';
    DTP_INT(8) <= '0';
    DTP_INT(9) <= '0';
    DTP_INT(10) <= '0';
    DTP_INT(11) <= '0';
    DTP_INT(12) <= '0';
    DTP_INT(13) <= '0';
    DTP_INT(14) <= '0';
    DTP_INT(15) <= '0';
    DTP_INT(16) <= '0';
    DTP_INT(17) <= '0';
    DTP_INT(18) <= '0';
    DTP_INT(19) <= '0';
    DTP_INT(20) <= '0';
    DTP_INT(21) <= '0';
    DTP_INT(22) <= '0';
    DTP_INT(23) <= '0';
    DTP_INT(24) <= '0';
    DTP_INT(25) <= '0';
    DTP_INT(26) <= '0';
    DTP_INT(27) <= '0';
    DTP_INT(28) <= '0';
    DTP_INT(29) <= '0';
    DTP_INT(30) <= '0';
    DTP_INT(31) <= '0';
    DTP_INT(32) <= '0';
    DTP_INT(33) <= '0';
    DTP_INT(34) <= '0';
    DTP_INT(35) <= '0';
    DTP_INT(36) <= '0';
    DTP_INT(37) <= '0';
    DTP_INT(38) <= '0';
    DTP_INT(39) <= '0';
    DTP_INT(40) <= '0';
    DTP_INT(41) <= '0';
    DTP_INT(42) <= '0';
    DTP_INT(43) <= '0';
    DTP_INT(44) <= '0';
    DTP_INT(45) <= '0';
    DTP_INT(46) <= '0';
    DTP_INT(47) <= '0';
    DTP_INT(48) <= '0';
    DTP_INT(49) <= '0';
    DTP_INT(50) <= '0';
    DTP_INT(51) <= '0';
    DTP_INT(52) <= '0';
    DTP_INT(53) <= '0';
    DTP_INT(54) <= '0';
    DTP_INT(55) <= '0';
    DTP_INT(56) <= '0';
    DTP_INT(57) <= '0';
    DTP_INT(58) <= '0';
    DTP_INT(59) <= '0';
    DTP_INT(60) <= '0';
    DTP_INT(61) <= '0';
    DTP_INT(62) <= '0';
    DTP_INT(63) <= '0';
    DTP_INT(64) <= '0';
    DTP_INT(65) <= '0';
    DTP_INT(66) <= '0';
    DTP_INT(67) <= '0';
    DTP_INT(68) <= '0';
    DTP_INT(69) <= '0';
    DTP_INT(70) <= '0';
    DTP_INT(71) <= '0';
    DTP_INT(72) <= '0';
    DTP_INT(73) <= '0';
    DTP_INT(74) <= '0';
    DTP_INT(75) <= '0';
    DTP_INT(76) <= '0';
    DTP_INT(77) <= '0';
    DTP_INT(78) <= '0';
    DTP_INT(79) <= '0';
    DTP_INT(80) <= '0';
    DTP_INT(81) <= '0';
    DTP_INT(82) <= '0';
    DTP_INT(83) <= '0';
    DTP_INT(84) <= '0';
    DTP_INT(85) <= '0';
    DTP_INT(86) <= '0';
    DTP_INT(87) <= '0';
    DTP_INT(88) <= '0';
    DTP_INT(89) <= '0';
    DTP_INT(90) <= '0';
    DTP_INT(91) <= '0';
    DTP_INT(92) <= '0';
    DTP_INT(93) <= '0';
    DTP_INT(94) <= '0';
    DTP_INT(95) <= '0';
    DTP_INT(96) <= '0';
    DTP_INT(97) <= '0';
    DTP_INT(98) <= '0';
    DTP_INT(99) <= '0';
    DTP_INT(100) <= '0';
    DTP_INT(101) <= '0';
    DTP_INT(102) <= '0';
    DTP_INT(103) <= '0';
    DTP_INT(104) <= '0';
    DTP_INT(105) <= '0';
    DTP_INT(106) <= '0';
    DTP_INT(107) <= '0';
    DTP_INT(108) <= '0';
    DTP_INT(109) <= '0';
    DTP_INT(110) <= '0';
    DTP_INT(111) <= '0';
    DTP_INT(112) <= '0';
    DTP_INT(113) <= '0';
    DTP_INT(114) <= '0';
    DTP_INT(115) <= '0';
    DTP_INT(116) <= '0';
    DTP_INT(117) <= '0';
    DTP_INT(118) <= '0';
    DTP_INT(119) <= '0';
    DTP_INT(120) <= '0';
    DTP_INT(121) <= '0';
    DTP_INT(122) <= '0';
    DTP_INT(123) <= '0';
    DTP_INT(124) <= '0';
    DTP_INT(125) <= '0';
    DTP_INT(126) <= '0';
    DTP_INT(127) <= '0';
  elsif((CENVio='X') or (CLK_INT'event and CLK_INT='X' and CENi = '0')) then
    GTP_INT <= 'X';
    DTP_INT(0) <= 'X';
    DTP_INT(1) <= 'X';
    DTP_INT(2) <= 'X';
    DTP_INT(3) <= 'X';
    DTP_INT(4) <= 'X';
    DTP_INT(5) <= 'X';
    DTP_INT(6) <= 'X';
    DTP_INT(7) <= 'X';
    DTP_INT(8) <= 'X';
    DTP_INT(9) <= 'X';
    DTP_INT(10) <= 'X';
    DTP_INT(11) <= 'X';
    DTP_INT(12) <= 'X';
    DTP_INT(13) <= 'X';
    DTP_INT(14) <= 'X';
    DTP_INT(15) <= 'X';
    DTP_INT(16) <= 'X';
    DTP_INT(17) <= 'X';
    DTP_INT(18) <= 'X';
    DTP_INT(19) <= 'X';
    DTP_INT(20) <= 'X';
    DTP_INT(21) <= 'X';
    DTP_INT(22) <= 'X';
    DTP_INT(23) <= 'X';
    DTP_INT(24) <= 'X';
    DTP_INT(25) <= 'X';
    DTP_INT(26) <= 'X';
    DTP_INT(27) <= 'X';
    DTP_INT(28) <= 'X';
    DTP_INT(29) <= 'X';
    DTP_INT(30) <= 'X';
    DTP_INT(31) <= 'X';
    DTP_INT(32) <= 'X';
    DTP_INT(33) <= 'X';
    DTP_INT(34) <= 'X';
    DTP_INT(35) <= 'X';
    DTP_INT(36) <= 'X';
    DTP_INT(37) <= 'X';
    DTP_INT(38) <= 'X';
    DTP_INT(39) <= 'X';
    DTP_INT(40) <= 'X';
    DTP_INT(41) <= 'X';
    DTP_INT(42) <= 'X';
    DTP_INT(43) <= 'X';
    DTP_INT(44) <= 'X';
    DTP_INT(45) <= 'X';
    DTP_INT(46) <= 'X';
    DTP_INT(47) <= 'X';
    DTP_INT(48) <= 'X';
    DTP_INT(49) <= 'X';
    DTP_INT(50) <= 'X';
    DTP_INT(51) <= 'X';
    DTP_INT(52) <= 'X';
    DTP_INT(53) <= 'X';
    DTP_INT(54) <= 'X';
    DTP_INT(55) <= 'X';
    DTP_INT(56) <= 'X';
    DTP_INT(57) <= 'X';
    DTP_INT(58) <= 'X';
    DTP_INT(59) <= 'X';
    DTP_INT(60) <= 'X';
    DTP_INT(61) <= 'X';
    DTP_INT(62) <= 'X';
    DTP_INT(63) <= 'X';
    DTP_INT(64) <= 'X';
    DTP_INT(65) <= 'X';
    DTP_INT(66) <= 'X';
    DTP_INT(67) <= 'X';
    DTP_INT(68) <= 'X';
    DTP_INT(69) <= 'X';
    DTP_INT(70) <= 'X';
    DTP_INT(71) <= 'X';
    DTP_INT(72) <= 'X';
    DTP_INT(73) <= 'X';
    DTP_INT(74) <= 'X';
    DTP_INT(75) <= 'X';
    DTP_INT(76) <= 'X';
    DTP_INT(77) <= 'X';
    DTP_INT(78) <= 'X';
    DTP_INT(79) <= 'X';
    DTP_INT(80) <= 'X';
    DTP_INT(81) <= 'X';
    DTP_INT(82) <= 'X';
    DTP_INT(83) <= 'X';
    DTP_INT(84) <= 'X';
    DTP_INT(85) <= 'X';
    DTP_INT(86) <= 'X';
    DTP_INT(87) <= 'X';
    DTP_INT(88) <= 'X';
    DTP_INT(89) <= 'X';
    DTP_INT(90) <= 'X';
    DTP_INT(91) <= 'X';
    DTP_INT(92) <= 'X';
    DTP_INT(93) <= 'X';
    DTP_INT(94) <= 'X';
    DTP_INT(95) <= 'X';
    DTP_INT(96) <= 'X';
    DTP_INT(97) <= 'X';
    DTP_INT(98) <= 'X';
    DTP_INT(99) <= 'X';
    DTP_INT(100) <= 'X';
    DTP_INT(101) <= 'X';
    DTP_INT(102) <= 'X';
    DTP_INT(103) <= 'X';
    DTP_INT(104) <= 'X';
    DTP_INT(105) <= 'X';
    DTP_INT(106) <= 'X';
    DTP_INT(107) <= 'X';
    DTP_INT(108) <= 'X';
    DTP_INT(109) <= 'X';
    DTP_INT(110) <= 'X';
    DTP_INT(111) <= 'X';
    DTP_INT(112) <= 'X';
    DTP_INT(113) <= 'X';
    DTP_INT(114) <= 'X';
    DTP_INT(115) <= 'X';
    DTP_INT(116) <= 'X';
    DTP_INT(117) <= 'X';
    DTP_INT(118) <= 'X';
    DTP_INT(119) <= 'X';
    DTP_INT(120) <= 'X';
    DTP_INT(121) <= 'X';
    DTP_INT(122) <= 'X';
    DTP_INT(123) <= 'X';
    DTP_INT(124) <= 'X';
    DTP_INT(125) <= 'X';
    DTP_INT(126) <= 'X';
    DTP_INT(127) <= 'X';
  elsif(CLK_INT'event and CLK_INT='1') then
    GTP_INT <= (CLK_INT and CENib);
    DTP_INT(0) <= (CLK_INT and CENib and WENib(0));
    DTP_INT(1) <= (CLK_INT and CENib and WENib(0));
    DTP_INT(2) <= (CLK_INT and CENib and WENib(0));
    DTP_INT(3) <= (CLK_INT and CENib and WENib(0));
    DTP_INT(4) <= (CLK_INT and CENib and WENib(0));
    DTP_INT(5) <= (CLK_INT and CENib and WENib(0));
    DTP_INT(6) <= (CLK_INT and CENib and WENib(0));
    DTP_INT(7) <= (CLK_INT and CENib and WENib(0));
    DTP_INT(8) <= (CLK_INT and CENib and WENib(1));
    DTP_INT(9) <= (CLK_INT and CENib and WENib(1));
    DTP_INT(10) <= (CLK_INT and CENib and WENib(1));
    DTP_INT(11) <= (CLK_INT and CENib and WENib(1));
    DTP_INT(12) <= (CLK_INT and CENib and WENib(1));
    DTP_INT(13) <= (CLK_INT and CENib and WENib(1));
    DTP_INT(14) <= (CLK_INT and CENib and WENib(1));
    DTP_INT(15) <= (CLK_INT and CENib and WENib(1));
    DTP_INT(16) <= (CLK_INT and CENib and WENib(2));
    DTP_INT(17) <= (CLK_INT and CENib and WENib(2));
    DTP_INT(18) <= (CLK_INT and CENib and WENib(2));
    DTP_INT(19) <= (CLK_INT and CENib and WENib(2));
    DTP_INT(20) <= (CLK_INT and CENib and WENib(2));
    DTP_INT(21) <= (CLK_INT and CENib and WENib(2));
    DTP_INT(22) <= (CLK_INT and CENib and WENib(2));
    DTP_INT(23) <= (CLK_INT and CENib and WENib(2));
    DTP_INT(24) <= (CLK_INT and CENib and WENib(3));
    DTP_INT(25) <= (CLK_INT and CENib and WENib(3));
    DTP_INT(26) <= (CLK_INT and CENib and WENib(3));
    DTP_INT(27) <= (CLK_INT and CENib and WENib(3));
    DTP_INT(28) <= (CLK_INT and CENib and WENib(3));
    DTP_INT(29) <= (CLK_INT and CENib and WENib(3));
    DTP_INT(30) <= (CLK_INT and CENib and WENib(3));
    DTP_INT(31) <= (CLK_INT and CENib and WENib(3));
    DTP_INT(32) <= (CLK_INT and CENib and WENib(4));
    DTP_INT(33) <= (CLK_INT and CENib and WENib(4));
    DTP_INT(34) <= (CLK_INT and CENib and WENib(4));
    DTP_INT(35) <= (CLK_INT and CENib and WENib(4));
    DTP_INT(36) <= (CLK_INT and CENib and WENib(4));
    DTP_INT(37) <= (CLK_INT and CENib and WENib(4));
    DTP_INT(38) <= (CLK_INT and CENib and WENib(4));
    DTP_INT(39) <= (CLK_INT and CENib and WENib(4));
    DTP_INT(40) <= (CLK_INT and CENib and WENib(5));
    DTP_INT(41) <= (CLK_INT and CENib and WENib(5));
    DTP_INT(42) <= (CLK_INT and CENib and WENib(5));
    DTP_INT(43) <= (CLK_INT and CENib and WENib(5));
    DTP_INT(44) <= (CLK_INT and CENib and WENib(5));
    DTP_INT(45) <= (CLK_INT and CENib and WENib(5));
    DTP_INT(46) <= (CLK_INT and CENib and WENib(5));
    DTP_INT(47) <= (CLK_INT and CENib and WENib(5));
    DTP_INT(48) <= (CLK_INT and CENib and WENib(6));
    DTP_INT(49) <= (CLK_INT and CENib and WENib(6));
    DTP_INT(50) <= (CLK_INT and CENib and WENib(6));
    DTP_INT(51) <= (CLK_INT and CENib and WENib(6));
    DTP_INT(52) <= (CLK_INT and CENib and WENib(6));
    DTP_INT(53) <= (CLK_INT and CENib and WENib(6));
    DTP_INT(54) <= (CLK_INT and CENib and WENib(6));
    DTP_INT(55) <= (CLK_INT and CENib and WENib(6));
    DTP_INT(56) <= (CLK_INT and CENib and WENib(7));
    DTP_INT(57) <= (CLK_INT and CENib and WENib(7));
    DTP_INT(58) <= (CLK_INT and CENib and WENib(7));
    DTP_INT(59) <= (CLK_INT and CENib and WENib(7));
    DTP_INT(60) <= (CLK_INT and CENib and WENib(7));
    DTP_INT(61) <= (CLK_INT and CENib and WENib(7));
    DTP_INT(62) <= (CLK_INT and CENib and WENib(7));
    DTP_INT(63) <= (CLK_INT and CENib and WENib(7));
    DTP_INT(64) <= (CLK_INT and CENib and WENib(8));
    DTP_INT(65) <= (CLK_INT and CENib and WENib(8));
    DTP_INT(66) <= (CLK_INT and CENib and WENib(8));
    DTP_INT(67) <= (CLK_INT and CENib and WENib(8));
    DTP_INT(68) <= (CLK_INT and CENib and WENib(8));
    DTP_INT(69) <= (CLK_INT and CENib and WENib(8));
    DTP_INT(70) <= (CLK_INT and CENib and WENib(8));
    DTP_INT(71) <= (CLK_INT and CENib and WENib(8));
    DTP_INT(72) <= (CLK_INT and CENib and WENib(9));
    DTP_INT(73) <= (CLK_INT and CENib and WENib(9));
    DTP_INT(74) <= (CLK_INT and CENib and WENib(9));
    DTP_INT(75) <= (CLK_INT and CENib and WENib(9));
    DTP_INT(76) <= (CLK_INT and CENib and WENib(9));
    DTP_INT(77) <= (CLK_INT and CENib and WENib(9));
    DTP_INT(78) <= (CLK_INT and CENib and WENib(9));
    DTP_INT(79) <= (CLK_INT and CENib and WENib(9));
    DTP_INT(80) <= (CLK_INT and CENib and WENib(10));
    DTP_INT(81) <= (CLK_INT and CENib and WENib(10));
    DTP_INT(82) <= (CLK_INT and CENib and WENib(10));
    DTP_INT(83) <= (CLK_INT and CENib and WENib(10));
    DTP_INT(84) <= (CLK_INT and CENib and WENib(10));
    DTP_INT(85) <= (CLK_INT and CENib and WENib(10));
    DTP_INT(86) <= (CLK_INT and CENib and WENib(10));
    DTP_INT(87) <= (CLK_INT and CENib and WENib(10));
    DTP_INT(88) <= (CLK_INT and CENib and WENib(11));
    DTP_INT(89) <= (CLK_INT and CENib and WENib(11));
    DTP_INT(90) <= (CLK_INT and CENib and WENib(11));
    DTP_INT(91) <= (CLK_INT and CENib and WENib(11));
    DTP_INT(92) <= (CLK_INT and CENib and WENib(11));
    DTP_INT(93) <= (CLK_INT and CENib and WENib(11));
    DTP_INT(94) <= (CLK_INT and CENib and WENib(11));
    DTP_INT(95) <= (CLK_INT and CENib and WENib(11));
    DTP_INT(96) <= (CLK_INT and CENib and WENib(12));
    DTP_INT(97) <= (CLK_INT and CENib and WENib(12));
    DTP_INT(98) <= (CLK_INT and CENib and WENib(12));
    DTP_INT(99) <= (CLK_INT and CENib and WENib(12));
    DTP_INT(100) <= (CLK_INT and CENib and WENib(12));
    DTP_INT(101) <= (CLK_INT and CENib and WENib(12));
    DTP_INT(102) <= (CLK_INT and CENib and WENib(12));
    DTP_INT(103) <= (CLK_INT and CENib and WENib(12));
    DTP_INT(104) <= (CLK_INT and CENib and WENib(13));
    DTP_INT(105) <= (CLK_INT and CENib and WENib(13));
    DTP_INT(106) <= (CLK_INT and CENib and WENib(13));
    DTP_INT(107) <= (CLK_INT and CENib and WENib(13));
    DTP_INT(108) <= (CLK_INT and CENib and WENib(13));
    DTP_INT(109) <= (CLK_INT and CENib and WENib(13));
    DTP_INT(110) <= (CLK_INT and CENib and WENib(13));
    DTP_INT(111) <= (CLK_INT and CENib and WENib(13));
    DTP_INT(112) <= (CLK_INT and CENib and WENib(14));
    DTP_INT(113) <= (CLK_INT and CENib and WENib(14));
    DTP_INT(114) <= (CLK_INT and CENib and WENib(14));
    DTP_INT(115) <= (CLK_INT and CENib and WENib(14));
    DTP_INT(116) <= (CLK_INT and CENib and WENib(14));
    DTP_INT(117) <= (CLK_INT and CENib and WENib(14));
    DTP_INT(118) <= (CLK_INT and CENib and WENib(14));
    DTP_INT(119) <= (CLK_INT and CENib and WENib(14));
    DTP_INT(120) <= (CLK_INT and CENib and WENib(15));
    DTP_INT(121) <= (CLK_INT and CENib and WENib(15));
    DTP_INT(122) <= (CLK_INT and CENib and WENib(15));
    DTP_INT(123) <= (CLK_INT and CENib and WENib(15));
    DTP_INT(124) <= (CLK_INT and CENib and WENib(15));
    DTP_INT(125) <= (CLK_INT and CENib and WENib(15));
    DTP_INT(126) <= (CLK_INT and CENib and WENib(15));
    DTP_INT(127) <= (CLK_INT and CENib and WENib(15));
  end if;
 End Process;
--------------
  ANi <= not(MANi);
  CENib<= not(CENi);
  WENib<= not(WENi);
  Di  <= MDi;
  GTP_RdWr <= GTP_INT;

--------------
PROCA : process(GTP_RdWr, ANVio, DVio, WENVio)
  variable AddVio, DataVio: boolean;
  variable Rd, Wr : std_logic:='0';
  variable AddI  : std_logic_vector (4 downto 0) ;
	----------------------------------------------------------------------
  begin
    DataVio:=Is_X(DVio); AddVio:=Is_X(ANVio);
    Rd:='0'; Wr:='0';
 
    if(AddVio) then AddI:=(others=>'X');
    else            AddI:=not(ANi);
    end if;

    if((GTP_RdWr'last_value/='X' and GTP_RdWr'event) or AddVio or DataVio or Is_X(WENVio)) then
	case GTP_RdWr is
	    when '1' => 		-- valid rising edge
		if(All_1(WENi)) then Rd:='1';
		else Wr:='1'; -- UX
		end if;
	    when 'U'|'X' =>
		if (CENi='X') then
		  if (All_1(WENi)) then Rd:='X';
		  else Wr:='X'; end if;
		elsif(CLK_INT='X') then
		  AddI:= (others => 'X');
		  Wr:='X';
		else
		  Wr:='X';
		end if;
	    when others =>  null;
	end case;
    end if;

    Read<=Rd; Write<=Wr;
    if(Wr/='0' or Rd/='0') then
	Am<=AddI; Dm<=MDi;
	Bm<=not(WENi);
    end if;
-- 
  end process PROCA ;

--------------
End Behavioral;

--------------
-------------------
use std.all;
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_timing.all;
use IEEE.VITAL_primitives.all;
use WORK.vlibs.all; 
use WORK.lib_cells_pkgs.all;
use WORK.RF1SH32x128_on_pkgs.all;

  entity RF1SH32x128_on is
    generic(
	tperiod_CLK  : VitalDelayType := 2.000 ns;
	tpw_CLK_negedge: VitalDelayType := 1.000 ns;
	tpw_CLK_posedge: VitalDelayType := 1.000 ns;
	tipd_CLK: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CEN: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WEN: VitalDelayArrayType01(15 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_A: VitalDelayArrayType01(4 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_D: VitalDelayArrayType01(127 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CEN_CLK_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CEN_CLK_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WEN_CLK_posedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(1.000 ns));
	tsetup_WEN_CLK_negedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_posedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_negedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_posedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_negedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(1.000 ns));
	thold_CEN_CLK_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CEN_CLK_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WEN_CLK_posedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(0.500 ns));
	thold_WEN_CLK_negedge_posedge: VitalDelayArrayType(15 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_posedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_negedge_posedge: VitalDelayArrayType(4 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_posedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_negedge_posedge: VitalDelayArrayType(127 downto 0):=(others=>(0.500 ns));

	tpd_CLK_Q: VitalDelayArrayType01(127 downto 0):=(others=>(1.0 ns,1.0 ns));
	TimingChecksOn: BOOLEAN := TRUE
    );
    port ( 
	CLK: in std_logic;
	CEN: in std_logic;
	WEN: in std_logic_vector(15 downto 0);
	A: in std_logic_vector(4 downto 0);
	D: in std_logic_vector(127 downto 0);
	Q: out std_logic_vector(127 downto 0)
    );
    attribute VITAL_LEVEL1 of RF1SH32x128_on : entity is TRUE;
end RF1SH32x128_on;

-----------------------------------------------------------------------------
architecture Structural of RF1SH32x128_on is
  signal MEM: MEM_TYPE(31 downto 0, 127 downto 0);
  signal gnd: std_logic:='0';
  signal gndA: std_logic_vector(4 downto 0):=(others=>'0');
  signal gndD: std_logic_vector(127 downto 0):=(others=>'0');
  signal Read, Write: std_logic;
  signal GtpRst, BusyWr, BusyRd: std_logic:='0';
  signal Am: std_logic_vector(4 downto 0);
  signal Dm, Qi: std_logic_vector(127 downto 0);
  signal Bm: std_logic_vector(15 downto 0);

Begin

----------
-- Memory Read/Write Cycles. BusyWr/Rd='X': Timing Violation on Control signals.
-- BusyWr/Rd='1': Valid Wr/Rd Cycle
----------
  WR_SAME_LOC :process (BusyWr, BusyRd, Am, Dm)
  variable contention : boolean := false;
  variable NQi, NDm: std_logic_vector(Dm'range);
  begin
      if(BusyWr='X') then
	  NQi:=(others=>'X');
	  WRITE_MEM(Am, NQi, MEM);	--  Violations
	  Qi<=(others=>'X');
      elsif(BusyRd='X') then
	  Qi<=(others=>'X');
      elsif(BusyWr='1') then 		--  Valid Write Cycle
	  GET_MASKED_VALUE(Am, Dm, Bm, 8, MEM, NDm);
	  WRITE_MEM(Am, NDm, MEM, Contention);
	  if(Contention) then Qi<=(others=>'X');
	  else Qi<=NDm; end if;
      elsif(BusyRd='1') then 		-- Valid Read Cycle
	  READ_MEM_NEW(Am, NQi, MEM);
	  Qi<=NQi;
      end if;
  end process WR_SAME_LOC;
                   

  BusyRdWr: process(Write, Read)
  Begin
      if(Write'event and Write/='0') then
	  BusyWr<=Write, '0' after 2.0 ns;
	  GtpRst<='1', '0' after 2.0 ns;
      end if;
      if(Read'event and Read/='0') then
	  BusyRd<=Read, '0' after 2.0 ns;
	  GtpRst<='1', '0' after 2.0 ns;
      end if;
  end process BusyRdWR;


  MemPort: rdwr_RF1SH32x128_on
    generic map(
	tipd_CLK=>tipd_CLK,
	tipd_CEN=>tipd_CEN,
	tipd_WEN=>tipd_WEN,
	tipd_A=>tipd_A,
	tipd_D=>tipd_D,
	tsetup_CEN_CLK_posedge_posedge=>tsetup_CEN_CLK_posedge_posedge,
	tsetup_CEN_CLK_negedge_posedge=>tsetup_CEN_CLK_negedge_posedge,
	tsetup_WEN_CLK_posedge_posedge=>tsetup_WEN_CLK_posedge_posedge,
	tsetup_WEN_CLK_negedge_posedge=>tsetup_WEN_CLK_negedge_posedge,
	tsetup_A_CLK_posedge_posedge=>tsetup_A_CLK_posedge_posedge,
	tsetup_A_CLK_negedge_posedge=>tsetup_A_CLK_negedge_posedge,
	tsetup_D_CLK_posedge_posedge=>tsetup_D_CLK_posedge_posedge,
	tsetup_D_CLK_negedge_posedge=>tsetup_D_CLK_negedge_posedge,
	thold_CEN_CLK_posedge_posedge=>thold_CEN_CLK_posedge_posedge,
	thold_CEN_CLK_negedge_posedge=>thold_CEN_CLK_negedge_posedge,
	thold_WEN_CLK_posedge_posedge=>thold_WEN_CLK_posedge_posedge,
	thold_WEN_CLK_negedge_posedge=>thold_WEN_CLK_negedge_posedge,
	thold_A_CLK_posedge_posedge=>thold_A_CLK_posedge_posedge,
	thold_A_CLK_negedge_posedge=>thold_A_CLK_negedge_posedge,
	thold_D_CLK_posedge_posedge=>thold_D_CLK_posedge_posedge,
	thold_D_CLK_negedge_posedge=>thold_D_CLK_negedge_posedge,
	tperiod_CLK => tperiod_CLK,
	tpw_CLK_negedge => tpw_CLK_negedge,
	tpw_CLK_posedge => tpw_CLK_posedge,
	tpd_CLK_Q=>tpd_CLK_Q, 
	PortName => "",
	TimingChecksOn => TimingChecksOn
    )
    port map ( 
	Q => Q,
	CLK => CLK,
	CEN => CEN,
	WEN => WEN,
	A => A,
	D => D,
	Read => Read,
	Write => Write,
	GtpRst => GtpRst,
	AM => Am,
	BM => Bm,
	DM => Dm,
	Qi => Qi
    );

End Structural;
