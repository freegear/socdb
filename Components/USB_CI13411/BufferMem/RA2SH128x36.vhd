--------------------------------------------------------------------------
--      CONFIDENTIAL AND PROPRIETARY SOFTWARE/DATA OF ARTISAN COMPONENTS, INC.
--      
--      Copyright (c) 2007 Artisan Components, Inc.  All Rights Reserved.
--      
--      Use of this Software/Data is subject to the terms and conditions of
--      the applicable license agreement between Artisan Components, Inc. and
--      Taiwan Semiconductor Manufacturing Company, Ltd..  In addition, this Software/Data
--      is protected by copyright law and international treaties.
--      
--      The copyright notice(s) in this Software/Data does not indicate actual
--      or intended publication of this Software/Data.
--      name:			SRAM-DP-HS SRAM Generator
--           			TSMC CL013G Process
--      version:		2005Q2V1
--      comment:		
--      configuration:	 -instname RA2SH128x36 -words 128 -bits 36 -frequency 100 -ring_width 4 -mux 4 -drive 6 -write_mask off -wp_size 8 -top_layer met6 -power_type rings -horiz met3 -vert met2 -cust_comment "" -left_bus_delim "[" -right_bus_delim "]" -pwr_gnd_rename "VDD:VDD,GND:VSS" -prefix "" -pin_space 0.0 -name_case upper -check_instname on -diodes on -inside_ring_type GND
--
--      VHDL model for Synchronous Dual-Port Ram
--
--      Instance:       RA2SH128x36
--      Address Length: 128
--      Word Width:     36
--      Pipeline:       No
--
--      Creation Date:  2007-02-06 02:26:37Z
--      Version:        2005Q2V1
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

Package RA2SH128x36_pkgs is
  component rdwr_RA2SH128x36
    generic(
	TimingChecksOn: BOOLEAN := TRUE;
	tperiod_CLK  : VitalDelayType;
	tpw_CLK_negedge: VitalDelayType;
	tpw_CLK_posedge: VitalDelayType;
	tipd_CLK: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CEN: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WEN: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_A: VitalDelayArrayType01(6 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_D: VitalDelayArrayType01(35 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CEN_CLK_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CEN_CLK_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WEN_CLK_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WEN_CLK_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_A_CLK_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	thold_CEN_CLK_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CEN_CLK_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WEN_CLK_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_WEN_CLK_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_A_CLK_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	tpd_CLK_Q	: VitalDelayArrayType01(35 downto 0) := (others => (1.0 ns, 1.0 ns));
	PortName	: string
    );
    port ( 
	CLK: in std_logic;
	CEN: in std_logic;
	WEN: in std_logic;
	A: in std_logic_vector(6 downto 0);
	D: in std_logic_vector(35 downto 0);
	Q: out std_logic_vector(35 downto 0);
	Read: out std_logic:='0';
	Write: out std_logic:='0';
	GtpRst  : in std_logic;
	Am  : out std_logic_vector;
	Dm  : out std_logic_vector;
	Qi  : in std_logic_vector
    );
end component; 
 component RA2SH128x36
    generic(
	tperiod_CLKA  : VitalDelayType := 2.000 ns;
	tpw_CLKA_negedge: VitalDelayType := 1.000 ns;
	tpw_CLKA_posedge: VitalDelayType := 1.000 ns;
	tipd_CLKA: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CENA: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WENA: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_AA: VitalDelayArrayType01(6 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_DA: VitalDelayArrayType01(35 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CENA_CLKA_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CENA_CLKA_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WENA_CLKA_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WENA_CLKA_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_AA_CLKA_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_AA_CLKA_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_DA_CLKA_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	tsetup_DA_CLKA_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	thold_CENA_CLKA_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CENA_CLKA_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WENA_CLKA_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_WENA_CLKA_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_AA_CLKA_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_AA_CLKA_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_DA_CLKA_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	thold_DA_CLKA_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));

	tpd_CLKA_QA: VitalDelayArrayType01(35 downto 0):=(others=>(1.0 ns,1.0 ns));
	tperiod_CLKB  : VitalDelayType := 2.000 ns;
	tpw_CLKB_negedge: VitalDelayType := 1.000 ns;
	tpw_CLKB_posedge: VitalDelayType := 1.000 ns;
	tipd_CLKB: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CENB: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WENB: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_AB: VitalDelayArrayType01(6 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_DB: VitalDelayArrayType01(35 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CENB_CLKB_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CENB_CLKB_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WENB_CLKB_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WENB_CLKB_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_AB_CLKB_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_AB_CLKB_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_DB_CLKB_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	tsetup_DB_CLKB_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	thold_CENB_CLKB_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CENB_CLKB_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WENB_CLKB_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_WENB_CLKB_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_AB_CLKB_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_AB_CLKB_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_DB_CLKB_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	thold_DB_CLKB_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	tsetup_CLKA_CLKB_posedge_posedge : VitalDelayType := 2.000 ns;
	tsetup_CLKB_CLKA_posedge_posedge : VitalDelayType := 2.000 ns;

	tpd_CLKB_QB: VitalDelayArrayType01(35 downto 0):=(others=>(1.0 ns,1.0 ns));
	TimingChecksOn: BOOLEAN := TRUE
    );
    port ( 
	CLKA: in std_logic;
	CENA: in std_logic;
	WENA: in std_logic;
	AA: in std_logic_vector(6 downto 0);
	DA: in std_logic_vector(35 downto 0);
	QA: out std_logic_vector(35 downto 0);
	CLKB: in std_logic;
	CENB: in std_logic;
	WENB: in std_logic;
	AB: in std_logic_vector(6 downto 0);
	DB: in std_logic_vector(35 downto 0);
	QB: out std_logic_vector(35 downto 0)
    );
 end component; 
End RA2SH128x36_pkgs;
-------------------
use std.all;
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_timing.all;
use IEEE.VITAL_primitives.all;
use WORK.vlibs.all; 
use WORK.lib_cells_pkgs.all;
use WORK.RA2SH128x36_pkgs.all;

  entity rdwr_RA2SH128x36 is
    generic(
	TimingChecksOn: BOOLEAN := TRUE;
	tperiod_CLK  : VitalDelayType;
	tpw_CLK_negedge: VitalDelayType;
	tpw_CLK_posedge: VitalDelayType;
	tipd_CLK: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CEN: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WEN: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_A: VitalDelayArrayType01(6 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_D: VitalDelayArrayType01(35 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CEN_CLK_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CEN_CLK_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WEN_CLK_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WEN_CLK_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_A_CLK_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_A_CLK_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	tsetup_D_CLK_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	thold_CEN_CLK_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CEN_CLK_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WEN_CLK_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_WEN_CLK_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_A_CLK_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_A_CLK_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	thold_D_CLK_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	tpd_CLK_Q	: VitalDelayArrayType01(35 downto 0) := (others => (1.0 ns, 1.0 ns));
	PortName	: string
    );
    port ( 
	CLK: in std_logic;
	CEN: in std_logic;
	WEN: in std_logic;
	A: in std_logic_vector(6 downto 0);
	D: in std_logic_vector(35 downto 0);
	Q: out std_logic_vector(35 downto 0);
	Read: out std_logic:='0';
	Write: out std_logic:='0';
	GtpRst  : in std_logic;
	Am  : out std_logic_vector;
	Dm  : out std_logic_vector;
	Qi  : in std_logic_vector
    );
    attribute VITAL_LEVEL1 of rdwr_RA2SH128x36 : entity is TRUE;
end rdwr_RA2SH128x36;

-------------- -------------- -------------- -------------- --------------
architecture BEHAVIORAL of rdwr_RA2SH128x36 is
  constant ClkPort	: string:=cat("CLK",PortName);
  constant InstPort	: string:="RA2SH128x36";
  signal ANi,MANi	: std_logic_vector(A'range);
  signal ANVio 		: std_logic_vector(A'range);
  signal WENVio, WENi 	: std_logic;
  signal WENib	 	: std_logic;
  signal DTP_INT 	: std_logic;
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
TCH_WEN: TChCellEdges  generic map(tipd_in0=>tipd_WEN, tsetup_in0_clk_posedge_posedge=>tsetup_WEN_CLK_posedge_posedge,
                                thold_in0_clk_posedge_posedge=>thold_WEN_CLK_posedge_posedge, 
				tsetup_in0_clk_negedge_posedge=>tsetup_WEN_CLK_negedge_posedge,
                                thold_in0_clk_negedge_posedge=>thold_WEN_CLK_negedge_posedge, 	
                                TestSignalName=>ClkPort, RefSignalName=>cat("WEN",PortName), 
				TimingChecksOn=>TimingChecksOn, HeaderMsg=>InstPort)
                    port map(in0=>WEN, clk=>GTP_INT, Violation=>WENVio,out0=>WENi);
--------------
TCH_CEN: TChCellEdges  generic map(tipd_in0=>tipd_CEN, tsetup_in0_clk_posedge_posedge=>tsetup_CEN_CLK_posedge_posedge,
                                thold_in0_clk_posedge_posedge=>thold_CEN_CLK_posedge_posedge, 
				tsetup_in0_clk_negedge_posedge=>tsetup_CEN_CLK_negedge_posedge,
                                thold_in0_clk_negedge_posedge=>thold_CEN_CLK_negedge_posedge, 
                                TestSignalName=>ClkPort, RefSignalName=>cat("CEN",PortName), 
				TimingChecksOn=>TimingChecksOn, HeaderMsg=>InstPort)
                    port map(in0=>CEN, clk=>CLK_INT, Violation=>CENVio,out0=>CENi);
--------------
TA_A_UTI: for i in 0 to 6 generate
TCH_A: TChCellEdges  generic map(tipd_in0=>tipd_A(i), tsetup_in0_clk_posedge_posedge=>tsetup_A_CLK_posedge_posedge(i),
                                thold_in0_clk_posedge_posedge=>thold_A_CLK_posedge_posedge(i), 
				tsetup_in0_clk_negedge_posedge=>tsetup_A_CLK_negedge_posedge(i),
                                thold_in0_clk_negedge_posedge=>thold_A_CLK_negedge_posedge(i),
                                TestSignalName=>ClkPort, RefSignalName=>icat("A","",i), 
				TimingChecksOn=>TimingChecksOn, HeaderMsg=>InstPort)
                    port map(in0=>A(i), clk=>GTP_INT, Violation=>ANVio(i),out0=>MANi(i));
end generate;                      

--------------
D_UTI: for i in 0 to 35 generate
 TCH_D: TChCellEdges  generic map(tipd_in0=>tipd_D(i), tsetup_in0_clk_posedge_posedge=>tsetup_D_CLK_posedge_posedge(i),
                                thold_in0_clk_posedge_posedge=>thold_D_CLK_posedge_posedge(i), 
				tsetup_in0_clk_negedge_posedge=>tsetup_D_CLK_negedge_posedge(i),
                                thold_in0_clk_negedge_posedge=>thold_D_CLK_negedge_posedge(i),
                                TestSignalName=>ClkPort, RefSignalName=>icat("D","",i), 
				TimingChecksOn=>TimingChecksOn, HeaderMsg=>InstPort)
                    port map(in0=>D(i), clk=>DTP_INT, Violation=>DVio(i),out0=>MDi(i));

  Q_AMPS: buf	     generic map(tpd_in0_out0=>tpd_CLK_Q(i))
                     port map(in0=>Qi(i), out0=>Q(i));
end generate;      

--------------
GTP : process(GtpRst, CLK_INT, CENVio)
 Begin
  if((GtpRst'event and GtpRst='0' and CLK_INT /= 'X') or (CLK_INT'event and CLK_INT='0')) then
    GTP_INT <= '0'; 
    DTP_INT <= '0';
  elsif((CENVio='X') or (CLK_INT'event and CLK_INT='X' and CENi = '0')) then
    GTP_INT <= 'X';
    DTP_INT <= 'X';
  elsif(CLK_INT'event and CLK_INT='1') then
    GTP_INT <= (CLK_INT and CENib);
   DTP_INT <= (CLK_INT and CENib and WENib);
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
  variable AddI  : std_logic_vector (6 downto 0) ;
	----------------------------------------------------------------------
  begin
    DataVio:=Is_X(DVio); AddVio:=Is_X(ANVio);
    Rd:='0'; Wr:='0';
 
    if(AddVio) then AddI:=(others=>'X');
    else            AddI:=not(ANi);
    end if;

    if(WENVio'event) then
	if(CENi='0' and WENVio='X') then Wr:='X'; end if;
    elsif((GTP_RdWr'last_value/='X' and GTP_RdWr'event) or AddVio or DataVio) then
	case GTP_RdWr is
	    when '1' => 		-- valid rising edge
		if(WENi='0') then Wr:='1';
		elsif(WENi='1') then Rd:='1';
		else Wr:='X'; -- UX
		end if;
	    when 'U'|'X' =>
		if (CENi='X') then
		  if (WENi='1') then Rd:='X';
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
use WORK.RA2SH128x36_pkgs.all;

  entity RA2SH128x36 is
    generic(
	tperiod_CLKA  : VitalDelayType := 2.000 ns;
	tpw_CLKA_negedge: VitalDelayType := 1.000 ns;
	tpw_CLKA_posedge: VitalDelayType := 1.000 ns;
	tipd_CLKA: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CENA: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WENA: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_AA: VitalDelayArrayType01(6 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_DA: VitalDelayArrayType01(35 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CENA_CLKA_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CENA_CLKA_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WENA_CLKA_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WENA_CLKA_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_AA_CLKA_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_AA_CLKA_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_DA_CLKA_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	tsetup_DA_CLKA_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	thold_CENA_CLKA_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CENA_CLKA_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WENA_CLKA_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_WENA_CLKA_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_AA_CLKA_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_AA_CLKA_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_DA_CLKA_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	thold_DA_CLKA_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));

	tpd_CLKA_QA: VitalDelayArrayType01(35 downto 0):=(others=>(1.0 ns,1.0 ns));
	tperiod_CLKB  : VitalDelayType := 2.000 ns;
	tpw_CLKB_negedge: VitalDelayType := 1.000 ns;
	tpw_CLKB_posedge: VitalDelayType := 1.000 ns;
	tipd_CLKB: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_CENB: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_WENB: VitalDelayType01:=(0.000 ns, 0.000 ns);
	tipd_AB: VitalDelayArrayType01(6 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tipd_DB: VitalDelayArrayType01(35 downto 0):=(others=>(0.000 ns, 0.000 ns));
	tsetup_CENB_CLKB_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_CENB_CLKB_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WENB_CLKB_posedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_WENB_CLKB_negedge_posedge: VitalDelayType:=1.000 ns;
	tsetup_AB_CLKB_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_AB_CLKB_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(1.000 ns));
	tsetup_DB_CLKB_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	tsetup_DB_CLKB_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(1.000 ns));
	thold_CENB_CLKB_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_CENB_CLKB_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_WENB_CLKB_posedge_posedge: VitalDelayType:=0.500 ns;
	thold_WENB_CLKB_negedge_posedge: VitalDelayType:=0.500 ns;
	thold_AB_CLKB_posedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_AB_CLKB_negedge_posedge: VitalDelayArrayType(6 downto 0):=(others=>(0.500 ns));
	thold_DB_CLKB_posedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	thold_DB_CLKB_negedge_posedge: VitalDelayArrayType(35 downto 0):=(others=>(0.500 ns));
	tsetup_CLKA_CLKB_posedge_posedge : VitalDelayType := 2.000 ns;
	tsetup_CLKB_CLKA_posedge_posedge : VitalDelayType := 2.000 ns;

	tpd_CLKB_QB: VitalDelayArrayType01(35 downto 0):=(others=>(1.0 ns,1.0 ns));
	TimingChecksOn: BOOLEAN := TRUE
    );
    port ( 
	CLKA: in std_logic;
	CENA: in std_logic;
	WENA: in std_logic;
	AA: in std_logic_vector(6 downto 0);
	DA: in std_logic_vector(35 downto 0);
	QA: out std_logic_vector(35 downto 0);
	CLKB: in std_logic;
	CENB: in std_logic;
	WENB: in std_logic;
	AB: in std_logic_vector(6 downto 0);
	DB: in std_logic_vector(35 downto 0);
	QB: out std_logic_vector(35 downto 0)
    );
    attribute VITAL_LEVEL1 of RA2SH128x36 : entity is TRUE;
end RA2SH128x36;

-----------------------------------------------------------------------------
architecture Structural of RA2SH128x36 is
  signal MEM: MEM_TYPE(127 downto 0, 35 downto 0);
  signal gnd: std_logic:='0';
  signal gndA: std_logic_vector(6 downto 0):=(others=>'0');
  signal gndD: std_logic_vector(35 downto 0):=(others=>'0');
  signal ReadA, WriteA: std_logic;
  signal GtpRstA, BusyWrA, BusyRdA: std_logic:='0';
  signal AmA: std_logic_vector(6 downto 0);
  signal DmA, QiA: std_logic_vector(35 downto 0);
  signal ReadB, WriteB: std_logic;
  signal GtpRstB, BusyWrB, BusyRdB: std_logic:='0';
  signal AmB: std_logic_vector(6 downto 0);
  signal DmB, QiB: std_logic_vector(35 downto 0);

Begin

-----------------------------------------------------------------------------
-- Memory Read/Write Cycles. BusyWr/Rd='X': Timing Violation on Control signals.
-- BusyWr/Rd='1': Valid Wr/Rd Cycle
-- Process to check that the writes on each port are not to the
-- same location.
WR_SAME_LOC : process
  variable WrAWrB, WrARdB, RdAWrB: Boolean:=False;
  variable PQAi, NQAi: std_logic_vector(DmA'range);
  variable PQBi, NQBi: std_logic_vector(DmB'range);
  variable Contention : Boolean := False;
  begin
      wait until (BusyWrA'event and BusyWrA/='0') or (BusyWrB'event and BusyWrB/='0') or
                 (BusyRdA'event and BusyRdA/='0') or (BusyRdB'event and BusyRdB/='0') or
                 AmA'event or AmB'event or DmA'event or DmB'event;
-- 
      WrAWrB:=False;
      WrARdB:=False;
      RdAWrB:=False;

      if(rising_edge(BusyWrA)) then
	  READ_MEM_NEW(AmA, PQAi, MEM);
	  WrAWrB:=(BusyWrB/='0' and AmA=AmB);
	  WrARdB:=(BusyRdB/='0' and AmA=AmB);
	  RdAWrB:=False;
      elsif(rising_edge(BusyRdA)) then
	  READ_MEM_NEW(AmA, NQAi, MEM);
	  RdAWrB:=(BusyWrB/='0' and AmA=AmB);
	  WrAWrB:=False; WrARdB:=False;
      end if;
-- 
      if(rising_edge(BusyWrB)) then
	  READ_MEM_NEW(AmB, PQBi, MEM);
	  WrAWrB:=(BusyWrA/='0' and AmA=AmB);
	  RdAWrB:=(BusyRdA/='0' and AmA=AmB);
	  WrARdB:=False;
      elsif(rising_edge(BusyRdB)) then
	  READ_MEM_NEW(AmB, NQBi, MEM);
	  WrARdB:=(BusyWrA/='0' and AmA=AmB);
	  RdAWrB:=False; WrAWrB:=False;
      end if;

      if(WrAWrB and (rising_edge(BusyWrA) or rising_edge(BusyWrB))) then
	  assert false report " Both Ports writing to same location -  Violation" severity warning ;
      elsif(RdAWrB and (rising_edge(BusyRdA) or rising_edge(BusyWrB))) then
	  assert false report " PortB writing to same location Read by PortA - Violation (PortA)" severity warning ;
      elsif(WrARdB and (rising_edge(BusyWrA) or rising_edge(BusyRdB))) then
	  assert false report " PortA writing to same location Read by PortB - Violation (PortB)" severity warning ;
      end if;

      if(WrAWrB=True) then
	  NQAi:=(others=>'X'); QiA<=DmA;
	  WRITE_MEM(AmA, NQAi, MEM);
      elsif(RdAWrB=True) then
	  NQAi:=(others=>'X');
	  WRITE_MEM(AmA, NQAi, MEM);
	  QiA<=(others=>'X');
      elsif(WrARdB=True) then
	  QiA<=DmA;
      elsif(BusyWrA='X') then
	  NQAi:=(others=>'X'); QiA<=NQAi;
	  WRITE_MEM(AmA, NQAi, MEM);
      elsif(BusyRdA='X') then
	  QiA<=(others=>'X');
      elsif(BusyWrA='1') then
	  WRITE_MEM(AmA, DmA, MEM, Contention);
	  if(Contention) then QiA<=(others=>'X');
	  else QiA<=DmA; end if;
      elsif(BusyRdA='1') then
	  READ_MEM_NEW(AmA, NQAi, MEM);		-- Valid Read Cycle / PortA
	  QiA<=NQAi;
      end if;
-- 
      if(WrAWrB=True) then
	  NQBi:=(others=>'X'); QiB<=DmB;
      elsif(WrARdB=True) then
	  NQBi:=(others=>'X');
	  WRITE_MEM(AmB, NQBi, MEM);
	  QiB<=(others=>'X');
      elsif(RdAWrB=True) then
          QiB<=DmB;
      elsif(BusyWrB='X') then
	  NQBi:=(others=>'X'); QiB<=NQBi;
	  WRITE_MEM(AmB, NQBi, MEM);
      elsif(BusyRdB='X') then
	  QiB<=(others=>'X');
      elsif(BusyWrB='1') then
	  WRITE_MEM(AmB, DmB, MEM, Contention);
	  if(Contention) then QiB<=(others=>'X');
	  else QiB<=DmB; end if;
      elsif(BusyRdB='1') then
	  READ_MEM_NEW(AmB, NQBi, MEM);		-- Valid Read Cycle / PortB
	  QiB<=NQBi;
      end if;
-- 
  end process WR_SAME_LOC;

  BusyRdWrA: process(WriteA, ReadA)
  Begin
      if(WriteA'event and WriteA/='0') then
	  BusyWrA<=WriteA, '0' after tsetup_CLKA_CLKB_posedge_posedge;
	  GtpRstA<='1', '0' after tsetup_CLKA_CLKB_posedge_posedge;
      end if;
      if(ReadA'event and ReadA/='0') then
	  BusyRdA<=ReadA, '0' after tsetup_CLKA_CLKB_posedge_posedge;
	  GtpRstA<='1', '0' after tsetup_CLKA_CLKB_posedge_posedge;
      end if;
  end process BusyRdWRA;

  BusyRdWrB: process(WriteB, ReadB)
  Begin
      if(WriteB'event and WriteB/='0') then
	  BusyWrB<=WriteB, '0' after tsetup_CLKA_CLKB_posedge_posedge;
	  GtpRstB<='1', '0' after tsetup_CLKA_CLKB_posedge_posedge;
      end if;
      if(ReadB'event and ReadB/='0') then
	  BusyRdB<=ReadB, '0' after tsetup_CLKA_CLKB_posedge_posedge;
	  GtpRstB<='1', '0' after tsetup_CLKA_CLKB_posedge_posedge;
      end if;
  end process BusyRdWRB;


  MemPortA: rdwr_RA2SH128x36
    generic map(
	tipd_CLK=>tipd_CLKA,
	tipd_CEN=>tipd_CENA,
	tipd_WEN=>tipd_WENA,
	tipd_A=>tipd_AA,
	tipd_D=>tipd_DA,
	tsetup_CEN_CLK_posedge_posedge=>tsetup_CENA_CLKA_posedge_posedge,
	tsetup_CEN_CLK_negedge_posedge=>tsetup_CENA_CLKA_negedge_posedge,
	tsetup_WEN_CLK_posedge_posedge=>tsetup_WENA_CLKA_posedge_posedge,
	tsetup_WEN_CLK_negedge_posedge=>tsetup_WENA_CLKA_negedge_posedge,
	tsetup_A_CLK_posedge_posedge=>tsetup_AA_CLKA_posedge_posedge,
	tsetup_A_CLK_negedge_posedge=>tsetup_AA_CLKA_negedge_posedge,
	tsetup_D_CLK_posedge_posedge=>tsetup_DA_CLKA_posedge_posedge,
	tsetup_D_CLK_negedge_posedge=>tsetup_DA_CLKA_negedge_posedge,
	thold_CEN_CLK_posedge_posedge=>thold_CENA_CLKA_posedge_posedge,
	thold_CEN_CLK_negedge_posedge=>thold_CENA_CLKA_negedge_posedge,
	thold_WEN_CLK_posedge_posedge=>thold_WENA_CLKA_posedge_posedge,
	thold_WEN_CLK_negedge_posedge=>thold_WENA_CLKA_negedge_posedge,
	thold_A_CLK_posedge_posedge=>thold_AA_CLKA_posedge_posedge,
	thold_A_CLK_negedge_posedge=>thold_AA_CLKA_negedge_posedge,
	thold_D_CLK_posedge_posedge=>thold_DA_CLKA_posedge_posedge,
	thold_D_CLK_negedge_posedge=>thold_DA_CLKA_negedge_posedge,
	tperiod_CLK => tperiod_CLKA,
	tpw_CLK_negedge => tpw_CLKA_negedge,
	tpw_CLK_posedge => tpw_CLKA_posedge,
	tpd_CLK_Q=>tpd_CLKA_QA, 
	PortName => "A",
	TimingChecksOn => TimingChecksOn
    )
    port map ( 
	Q => QA,
	CLK => CLKA,
	CEN => CENA,
	WEN => WENA,
	A => AA,
	D => DA,
	Read => ReadA,
	Write => WriteA,
	GtpRst => GtpRstA,
	AM => AmA,
	DM => DmA,
	Qi => QiA
    );



  MemPortB: rdwr_RA2SH128x36
    generic map(
	tipd_CLK=>tipd_CLKB,
	tipd_CEN=>tipd_CENB,
	tipd_WEN=>tipd_WENB,
	tipd_A=>tipd_AB,
	tipd_D=>tipd_DB,
	tsetup_CEN_CLK_posedge_posedge=>tsetup_CENB_CLKB_posedge_posedge,
	tsetup_CEN_CLK_negedge_posedge=>tsetup_CENB_CLKB_negedge_posedge,
	tsetup_WEN_CLK_posedge_posedge=>tsetup_WENB_CLKB_posedge_posedge,
	tsetup_WEN_CLK_negedge_posedge=>tsetup_WENB_CLKB_negedge_posedge,
	tsetup_A_CLK_posedge_posedge=>tsetup_AB_CLKB_posedge_posedge,
	tsetup_A_CLK_negedge_posedge=>tsetup_AB_CLKB_negedge_posedge,
	tsetup_D_CLK_posedge_posedge=>tsetup_DB_CLKB_posedge_posedge,
	tsetup_D_CLK_negedge_posedge=>tsetup_DB_CLKB_negedge_posedge,
	thold_CEN_CLK_posedge_posedge=>thold_CENB_CLKB_posedge_posedge,
	thold_CEN_CLK_negedge_posedge=>thold_CENB_CLKB_negedge_posedge,
	thold_WEN_CLK_posedge_posedge=>thold_WENB_CLKB_posedge_posedge,
	thold_WEN_CLK_negedge_posedge=>thold_WENB_CLKB_negedge_posedge,
	thold_A_CLK_posedge_posedge=>thold_AB_CLKB_posedge_posedge,
	thold_A_CLK_negedge_posedge=>thold_AB_CLKB_negedge_posedge,
	thold_D_CLK_posedge_posedge=>thold_DB_CLKB_posedge_posedge,
	thold_D_CLK_negedge_posedge=>thold_DB_CLKB_negedge_posedge,
	tperiod_CLK => tperiod_CLKB,
	tpw_CLK_negedge => tpw_CLKB_negedge,
	tpw_CLK_posedge => tpw_CLKB_posedge,
	tpd_CLK_Q=>tpd_CLKB_QB, 
	PortName => "B",
	TimingChecksOn => TimingChecksOn
    )
    port map ( 
	Q => QB,
	CLK => CLKB,
	CEN => CENB,
	WEN => WENB,
	A => AB,
	D => DB,
	Read => ReadB,
	Write => WriteB,
	GtpRst => GtpRstB,
	AM => AmB,
	DM => DmB,
	Qi => QiB
    );

End Structural;
