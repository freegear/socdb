-- --=================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999, 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- ---------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : tb_Sdram_256M.vhd,v
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--
-- ---------------------------------------------------------------------
--   Purpose : Test bench for the VSDRAM.
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

library tbench;
use     tbench.timing.all;
use     tbench.timingmaster.all;

library common;
use     common.defsmaster.all;

library uut;

library trickbox;

library N64M_x16;
library N64M_x8;
library N256M_x16;
library N256M_x8;

entity tb_Sdram_256M is
end tb_Sdram_256M;
-- =========================== ARCHITECTURE ========================= --

architecture structural of tb_Sdram_256M is


-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant ORBUS : std_logic := '0';
-- If this bit is set, then testbench will have a OR bus configuration
-- Else, by default, it will be a MUX implementation

-- ---------------------------------------------------------------------
-- Note on PARAMETERS
-- * Verbosity       : To suppress messages other than error messages,
--                     Verbosity has to be cleared.
-- * HaltOnMismatch  : If HaltOnMismatch is set the simulation halts
--                     when it detects any error.
-- * XonSig          : XonSig set enables signals to be unknown values,
--                     otherwise signals will take default values.
-- * SuppressOnReset : SuppressOnReset suppresses all protocol checking
--                     on a slave's output signals.
-- * Databuswidth    : Databuswidth can be set to 64 or 32, depending
--                     upon the device to be tested.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

constant WIDTH         : integer := 32;
constant ADDWIDTH      : integer := 10 + WIDTH/64;
constant DQMWIDTH      : integer := WIDTH/8;
constant HCLKPeriod    : time := Tclk;
constant HCLKPhaseTime : time := HCLKPeriod / 2;
constant HCLKSkew      : time := 3 ns;
constant HOLDDELAY     : time := 2 ns;

component ahbslave_tb
generic(
	INFILE                 : string;
        Verbosity              : integer;
        HaltOnMismatch         : integer;
        XonSig                 : integer;
        tclkl                  : time;
        tclkh                  : time;
        Databuswidth           : integer;
        ahbslave_tb_TimingFile : string
	);
  port(
       HREADY        : in  std_logic;
       HRDATA        : in  std_logic_vector(63 downto 0);
       HRESP         : in  std_logic_vector(1 downto 0);
       HSPLIT        : in  std_logic_vector(15 downto 0);
       VRG0          : inout std_logic_vector(31 downto 0);
       VRG1          : inout std_logic_vector(31 downto 0);
       VRG2          : inout std_logic_vector(31 downto 0);
       VRG3          : inout std_logic_vector(31 downto 0);
       VRG4          : inout std_logic_vector(31 downto 0);
       VRG5          : inout std_logic_vector(31 downto 0);
       VRG6          : inout std_logic_vector(31 downto 0);
       VRG7          : inout std_logic_vector(31 downto 0);
       HCLK          : out std_ulogic;
       HRESETn       : out std_ulogic;
       HADDR         : out std_logic_vector(31 downto 0);
       HTRANS        : out std_logic_vector(1 downto 0);
       HMASTER       : out std_logic_vector(3 downto 0);
       HMASTLOCK     : out std_logic;
       HWRITE        : out std_logic;
       HSIZE         : out std_logic_vector(2 downto 0);
       HBURST        : out std_logic_vector(2 downto 0);
       HPROT         : out std_logic_vector(3 downto 0);
       HWDATA        : out std_logic_vector(63 downto 0)
      );
end  component;

component decoder0
  port(
       HADDR        : in    std_logic_vector(31 downto 0);
       HSEL         : out   std_logic_vector(15 downto 0);
       DefSlaveSel  : out   std_logic
      );
end  component;

component decoder1
  port(
       HADDR        : in    std_logic_vector(31 downto 0);
       HSEL         : out   std_logic_vector(15 downto 0);
       DefSlaveSel  : out   std_logic
      );
end  component;

-- ---------------------------------------------------------------------
-- Trickbox instantiation
-- ---------------------------------------------------------------------

 component SdramTrick
   port(
        HCLK        : in std_logic;
        HRESETn     : in std_logic;
        HSIZE       : in std_logic_vector(2 downto 0);
        HBURST      : in std_logic_vector(2 downto 0);
        HTRANS      : in std_logic_vector(1 downto 0);
        HWRITE      : in std_logic;
        HSEL        : in std_logic;
        HREADYIn    : in std_logic;

        SREFAck     : in std_logic;
        CKE         : in std_logic_vector(3 downto 0);
        nRAS        : in std_logic;
        nCAS        : in std_logic;
        nCS         : in std_logic_vector(3 downto 0);
        nWE         : in std_logic;
        ExtBusReq   : in std_logic;
        AddrOut     : in std_logic_vector(13 downto 0);
        HADDR       : in std_logic_vector(ADDWIDTH downto 0);
        HWDATA      : in std_logic_vector(WIDTH-1 downto 0);

        nPOR        : out std_logic;
        ExtBusGnt   : out std_logic;
        SREFReq     : out std_logic;
        HREADYOut   : out std_logic;
        HRESP       : out std_logic_vector(1 downto 0);
        HRDATA      : out std_logic_vector(WIDTH-1 downto 0);
        BIGENDIAN   : out std_logic

       );
end component;

component Sdram
  port(
       HCLK         : in  std_logic;
       CLKIn        : in  std_logic;
       HRESETn      : in  std_logic;
       nPOR         : in  std_logic;
       SREFReq      : in  std_logic;
       ExtBusGnt    : in  std_logic;
       ExtCtlGnt    : in  std_logic;
       DataIn       : in  std_logic_vector(WIDTH-1 downto 0);
       HSIZE3       : in  std_logic_vector(1 downto 0);
       HWRITE3      : in  std_logic;
       HTRANS3      : in std_logic_vector(1 downto 0);
       HBURST3      : in std_logic_vector(2 downto 0);
       HREADYin3    : in std_logic;
       HSELram3     : in std_logic;
       HSELreg3     : in std_logic;
       HADDR3       : in std_logic_vector(28 downto 0);
       HWDATA3      : in std_logic_vector(WIDTH-1 downto 0);
       BIGENDIAN    : in std_logic;

       HSIZE2       : in std_logic_vector(1 downto 0);
       HWRITE2      : in std_logic;
       HTRANS2      : in std_logic_vector(1 downto 0);
       HBURST2      : in std_logic_vector(2 downto 0);
       HREADYin2    : in std_logic;
       HSELram2     : in std_logic;
       HADDR2       : in std_logic_vector(28 downto 0);
       HWDATA2      : in std_logic_vector(WIDTH-1 downto 0);

       HSIZE1       : in std_logic_vector(1 downto 0);
       HWRITE1      : in std_logic;
       HTRANS1      : in std_logic_vector(1 downto 0);
       HBURST1      : in std_logic_vector(2 downto 0);
       HREADYin1    : in std_logic;
       HSELram1     : in std_logic;
       HADDR1       : in std_logic_vector(28 downto 0);
       HWDATA1      : in std_logic_vector(WIDTH-1 downto 0);

       HSIZE0       : in std_logic_vector(1 downto 0);
       HWRITE0      : in std_logic;
       HTRANS0      : in std_logic_vector(1 downto 0);
       HBURST0      : in std_logic_vector(2 downto 0);
       HREADYin0    : in std_logic;
       HSELram0     : in std_logic;
       HADDR0       : in std_logic_vector(28 downto 0);
       HWDATA0      : in std_logic_vector(WIDTH-1 downto 0);

       SCANIN       : in std_logic;
       SCANENABLE   : in std_logic;
       HRDATA3      : out std_logic_vector(WIDTH-1 downto 0);
       HRESP3       : out std_logic_vector(1 downto 0);
       HREADYout3   : out std_logic;

       HRDATA2      : out std_logic_vector(WIDTH-1 downto 0);
       HRESP2       : out std_logic_vector(1 downto 0);
       HREADYout2   : out std_logic;

       HRDATA1      : out std_logic_vector(WIDTH-1 downto 0);
       HRESP1       : out std_logic_vector(1 downto 0);
       HREADYout1   : out std_logic;

       HRDATA0      : out std_logic_vector(WIDTH-1 downto 0);
       HRESP0       : out std_logic_vector(1 downto 0);
       HREADYout0   : out std_logic;

       SREFAck      : out std_logic;
       DataOut      : out std_logic_vector(WIDTH-1 downto 0);
       DQMOut       : out std_logic_vector(DQMWIDTH-1 downto 0);
       nCSOut       : out std_logic_vector(3 downto 0);
       AddrOut      : out std_logic_vector(14 downto 0);
       CKEOut       : out std_logic_vector(3 downto 0);
       nRASOut      : out std_logic;
       nCASOut      : out std_logic;
       nWEOut       : out std_logic;
       DataEn       : out std_logic;
       CLKOut       : out std_logic;
       ExtBusReq    : out std_logic;
       ExtCtlReq    : out std_logic;
       SCANOUT      : out std_logic
      );
end component;

component Defslave
  port(
       HCLK         : in     std_logic;
       HRESETn      : in     std_logic;
       HSEL         : in     std_logic;
       HTRANS       : in     std_logic;
       HRESP        : out    std_logic_vector(1 downto 0);
       HREADYIn     : in     std_logic;
       HREADYOut    : out    std_logic;
       HRDATAOut    : out    std_logic_vector(63 downto 0)
      );
end component;

component BusWatch
  generic (
           HaltOnMismatch : boolean;
           Verbosity      : boolean;
           Tclk           : time;
           Tovtr          : time;
           Tohtr          : time;
           Tova           : time;
           Toha           : time;
           Tovctl         : time;
           Tohctl         : time;
           Tovwd          : time;
           Tohwd          : time;
           Tovreq         : time;
           Tohreq         : time;
           Tovlck         : time;
           Tohlck         : time
          );
  port (
        HCLK      : in std_logic;
        HRESETn   : in std_logic;
        HTRANS    : in T_trans;
        HADDR     : in T_addr;
        HSIZE     : in T_size;
        HBURST    : in T_burst;
        HBUSREQx  : in std_logic;
        HGRANTx   : in std_logic;
        HREADY    : in T_line;
        HLOCKx    : in T_line;
        HWDATA    : in T_data;
        HPROT     : in T_prot;
        HWRITE    : in T_line;
        HRESP     : in T_resp
       );
end component;

component SdramNec64Mx16
  port(
       clk          :  in std_logic;
       cke          :  in std_logic;
       csbar        :  in std_logic;
       rasbar       :  in std_logic;
       casbar       :  in std_logic;
       webar        :  in std_logic;
       dqm          :  in std_logic_vector(1 downto 0);
       a            :  in std_logic_vector(13 downto 0);

       dq           :  inout std_logic_vector(15 downto 0)
      );
end component;

component SdramNec64Mx8
  port(
       clk          :  in std_logic;
       cke          :  in std_logic;
       csbar        :  in std_logic;
       rasbar       :  in std_logic;
       casbar       :  in std_logic;
       webar        :  in std_logic;
       dqm          :  in std_logic;
       a            :  in std_logic_vector(13 downto 0);

       dq           :  inout std_logic_vector(7 downto 0)
      );
end component;

component SdramNec256Mx16
  port(
       clk          :  in std_logic;
       cke          :  in std_logic;
       csbar        :  in std_logic;
       rasbar       :  in std_logic;
       casbar       :  in std_logic;
       webar        :  in std_logic;
       dqm          :  in std_logic_vector(1 downto 0);
       a            :  in std_logic_vector(12 downto 0);
       ba           :  in std_logic_vector(1 downto 0);

       dq           :  inout std_logic_vector(15 downto 0)
      );
end component;

component SdramNec256Mx8
  port(
       clk          :  in std_logic;
       cke          :  in std_logic;
       csbar        :  in std_logic;
       rasbar       :  in std_logic;
       casbar       :  in std_logic;
       webar        :  in std_logic;
       dqm          :  in std_logic;
       a            :  in std_logic_vector(12 downto 0);
       ba           :  in std_logic_vector(1 downto 0);

       dq           :  inout std_logic_vector(7 downto 0)
      );
end component;

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal HCLK3        : std_ulogic;
signal HRESETn3     : std_ulogic;
signal HADDR3       : std_logic_vector(31 downto 0);
signal HRDATA3      : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAIn3    : std_logic_vector(63 downto 0);
signal HWDATA3      : std_logic_vector(63 downto 0);
signal dummyDATA    : std_logic_vector(31 downto 0)
                    := to_stdlogicvector(X"00000000");
signal HSEL3        : std_logic_vector(15 downto 0);
signal HMASTLOCK3   : std_logic;
signal HWRITE3      : std_logic;
signal HSIZE3       : std_logic_vector(2 downto 0);
signal HBURST3      : std_logic_vector(2 downto 0);
signal HPROT3       : std_logic_vector(3 downto 0);
signal HTRANS3      : std_logic_vector(1 downto 0);
signal HRESP3       : std_logic_vector(1 downto 0);
signal HREADY3      : std_logic;
signal HSPLITIn3    : std_logic_vector(15 downto 0):="0000000000000000";
signal HMASTER3     : std_logic_vector(3 downto 0);
signal VRG30        : std_logic_vector(31 downto 0);
signal VRG31        : std_logic_vector(31 downto 0);
signal VRG32        : std_logic_vector(31 downto 0);
signal VRG33        : std_logic_vector(31 downto 0);
signal VRG34        : std_logic_vector(31 downto 0);
signal VRG35        : std_logic_vector(31 downto 0);
signal VRG36        : std_logic_vector(31 downto 0);
signal VRG37        : std_logic_vector(31 downto 0);
signal HSPLITOut3   : std_logic_vector(15 downto 0);
signal HREADYOut31  : std_logic;
signal HRDATAOut31  : std_logic_vector(WIDTH-1 downto 0);
signal HRESPOut31   : std_logic_vector(1 downto 0);
signal HREADYOut32  : std_logic;
signal HRDATAOut32  : std_logic_vector(WIDTH-1 downto 0);
signal HRESPOut32   : std_logic_vector(1 downto 0);
signal HREADYOut3   : std_logic;
signal HRDATAOut3   : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAOutIn3 : std_logic_vector(63 downto 0);
signal HRESPOut3    : std_logic_vector(1 downto 0);
signal DelHSEL3     : std_logic_vector(15 downto 0);
signal DefSlaveSel3 : std_logic;
signal DelDefSel3   : std_logic;
signal iHREADYMUX3  : std_logic;
signal HREADYMUX3   : std_logic;
signal HREADYOR3    : std_logic;
signal HRESPOR3     : std_logic_vector(1 downto 0);
signal HRESPMUX3    : std_logic_vector(1 downto 0);
signal HRDATAMUX3   : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAOR3    : std_logic_vector(WIDTH-1 downto 0);
signal iVRG30       : std_logic_vector(31 downto 0);
signal iVRG31       : std_logic_vector(31 downto 0);
signal iVRG32       : std_logic_vector(31 downto 0);
signal iVRG33       : std_logic_vector(31 downto 0);

signal HCLK2        : std_ulogic;
signal HRESETn2     : std_ulogic;
signal HADDR2       : std_logic_vector(31 downto 0);
signal HRDATA2      : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAIn2    : std_logic_vector(63 downto 0);
signal HWDATA2      : std_logic_vector(63 downto 0);
signal HSEL2        : std_logic_vector(15 downto 0);
signal HMASTLOCK2   : std_logic;
signal HWRITE2      : std_logic;
signal HSIZE2       : std_logic_vector(2 downto 0);
signal HBURST2      : std_logic_vector(2 downto 0);
signal HPROT2       : std_logic_vector(3 downto 0);
signal HTRANS2      : std_logic_vector(1 downto 0);
signal HRESP2       : std_logic_vector(1 downto 0);
signal HREADY2      : std_logic;
signal HSPLITIn2    : std_logic_vector(15 downto 0):="0000000000000000";
signal HMASTER2     : std_logic_vector(3 downto 0);
signal VRG20        : std_logic_vector(31 downto 0);
signal VRG21        : std_logic_vector(31 downto 0);
signal VRG22        : std_logic_vector(31 downto 0);
signal VRG23        : std_logic_vector(31 downto 0);
signal VRG24        : std_logic_vector(31 downto 0);
signal VRG25        : std_logic_vector(31 downto 0);
signal VRG26        : std_logic_vector(31 downto 0);
signal VRG27        : std_logic_vector(31 downto 0);
signal HSPLITOut2   : std_logic_vector(15 downto 0);
signal HREADYOut21  : std_logic;
signal HRDATAOut21  : std_logic_vector(WIDTH-1 downto 0);
signal HRESPOut21   : std_logic_vector(1 downto 0);
signal HREADYOut22  : std_logic;
signal HRDATAOut22  : std_logic_vector(WIDTH-1 downto 0);
signal HRESPOut22   : std_logic_vector(1 downto 0);
signal HREADYOut2   : std_logic;
signal HRDATAOut2   : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAOutIn2 : std_logic_vector(63 downto 0);
signal HRESPOut2    : std_logic_vector(1 downto 0);
signal DelHSEL2     : std_logic_vector(15 downto 0);
signal DefSlaveSel2 : std_logic;
signal DelDefSel2   : std_logic;
signal iHREADYMUX2  : std_logic;
signal HREADYMUX2   : std_logic;
signal HREADYOR2    : std_logic;
signal HRESPOR2     : std_logic_vector(1 downto 0);
signal HRESPMUX2    : std_logic_vector(1 downto 0);
signal HRDATAMUX2   : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAOR2    : std_logic_vector(WIDTH-1 downto 0);
signal iVRG20       : std_logic_vector(31 downto 0);
signal iVRG21       : std_logic_vector(31 downto 0);
signal iVRG22       : std_logic_vector(31 downto 0);
signal iVRG23       : std_logic_vector(31 downto 0);

signal HCLK1        : std_ulogic;
signal HRESETn1     : std_ulogic;
signal HADDR1       : std_logic_vector(31 downto 0);
signal HRDATA1      : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAIn1    : std_logic_vector(63 downto 0);
signal HWDATA1      : std_logic_vector(63 downto 0);
signal HSEL1        : std_logic_vector(15 downto 0);
signal HMASTLOCK1   : std_logic;
signal HWRITE1      : std_logic;
signal HSIZE1       : std_logic_vector(2 downto 0);
signal HBURST1      : std_logic_vector(2 downto 0);
signal HPROT1       : std_logic_vector(3 downto 0);
signal HTRANS1      : std_logic_vector(1 downto 0);
signal HRESP1       : std_logic_vector(1 downto 0);
signal HREADY1      : std_logic;
signal HSPLITIn1    : std_logic_vector(15 downto 0):="0000000000000000";
signal HMASTER1     : std_logic_vector(3 downto 0);
signal VRG10        : std_logic_vector(31 downto 0);
signal VRG11        : std_logic_vector(31 downto 0);
signal VRG12        : std_logic_vector(31 downto 0);
signal VRG13        : std_logic_vector(31 downto 0);
signal VRG14        : std_logic_vector(31 downto 0);
signal VRG15        : std_logic_vector(31 downto 0);
signal VRG16        : std_logic_vector(31 downto 0);
signal VRG17        : std_logic_vector(31 downto 0);
signal HSPLITOut1   : std_logic_vector(15 downto 0);
signal HREADYOut11  : std_logic;
signal HRDATAOut11  : std_logic_vector(WIDTH-1 downto 0);
signal HRESPOut11   : std_logic_vector(1 downto 0);
signal HREADYOut12  : std_logic;
signal HRDATAOut12  : std_logic_vector(WIDTH-1 downto 0);
signal HRESPOut12   : std_logic_vector(1 downto 0);
signal HREADYOut1   : std_logic;
signal HRDATAOut1   : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAOutIn1 : std_logic_vector(63 downto 0);
signal HRESPOut1    : std_logic_vector(1 downto 0);
signal DelHSEL1     : std_logic_vector(15 downto 0);
signal DefSlaveSel1 : std_logic;
signal DelDefSel1   : std_logic;
signal iHREADYMUX1  : std_logic;
signal HREADYMUX1   : std_logic;
signal HREADYOR1    : std_logic;
signal HRESPOR1     : std_logic_vector(1 downto 0);
signal HRESPMUX1    : std_logic_vector(1 downto 0);
signal HRDATAMUX1   : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAOR1    : std_logic_vector(WIDTH-1 downto 0);
signal iVRG10       : std_logic_vector(31 downto 0);
signal iVRG11       : std_logic_vector(31 downto 0);
signal iVRG12       : std_logic_vector(31 downto 0);
signal iVRG13       : std_logic_vector(31 downto 0);

signal HCLK0        : std_ulogic;
signal HRESETn0     : std_ulogic;
signal HADDR0       : std_logic_vector(31 downto 0);
signal HRDATA0      : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAIn0    : std_logic_vector(63 downto 0);
signal HWDATA0      : std_logic_vector(63 downto 0);
signal HSEL0        : std_logic_vector(15 downto 0);
signal HMASTLOCK0   : std_logic;
signal HWRITE0      : std_logic;
signal HSIZE0       : std_logic_vector(2 downto 0);
signal HBURST0      : std_logic_vector(2 downto 0);
signal HPROT0       : std_logic_vector(3 downto 0);
signal HTRANS0      : std_logic_vector(1 downto 0);
signal HRESP0       : std_logic_vector(1 downto 0);
signal HREADY0      : std_logic;
signal HSPLITIn0    : std_logic_vector(15 downto 0):="0000000000000000";
signal HMASTER0     : std_logic_vector(3 downto 0);
signal VRG00        : std_logic_vector(31 downto 0);
signal VRG01        : std_logic_vector(31 downto 0);
signal VRG02        : std_logic_vector(31 downto 0);
signal VRG03        : std_logic_vector(31 downto 0);
signal VRG04        : std_logic_vector(31 downto 0);
signal VRG05        : std_logic_vector(31 downto 0);
signal VRG06        : std_logic_vector(31 downto 0);
signal VRG07        : std_logic_vector(31 downto 0);
signal HSPLITOut0   : std_logic_vector(15 downto 0);
signal HREADYOut01  : std_logic;
signal HRDATAOut01  : std_logic_vector(WIDTH-1 downto 0);
signal HRESPOut01   : std_logic_vector(1 downto 0);
signal HREADYOut02  : std_logic;
signal HRDATAOut02  : std_logic_vector(WIDTH-1 downto 0);
signal HRESPOut02   : std_logic_vector(1 downto 0);
signal HREADYOut0   : std_logic;
signal HRDATAOut0   : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAOutIn0 : std_logic_vector(63 downto 0);
signal HRESPOut0    : std_logic_vector(1 downto 0);
signal DelHSEL0     : std_logic_vector(15 downto 0);
signal DefSlaveSel0 : std_logic;
signal DelDefSel0   : std_logic;
signal iHREADYMUX0  : std_logic;
signal HREADYMUX0   : std_logic;
signal HREADYOR0    : std_logic;
signal HRESPOR0     : std_logic_vector(1 downto 0);
signal HRESPMUX0    : std_logic_vector(1 downto 0);
signal HRDATAMUX0   : std_logic_vector(WIDTH-1 downto 0);
signal HRDATAOR0    : std_logic_vector(WIDTH-1 downto 0);
signal iVRG00       : std_logic_vector(31 downto 0);
signal iVRG01       : std_logic_vector(31 downto 0);
signal iVRG02       : std_logic_vector(31 downto 0);
signal iVRG03       : std_logic_vector(31 downto 0);

signal  nPORTrick     : std_logic;
signal  nPORStart     : std_logic;
signal  InitnPORDone  : std_logic;
signal  nPOR          : std_logic;

signal  CLKOut        : std_logic;
signal  SREFReq       : std_logic;
signal  DataIn        : std_logic_vector(WIDTH-1 downto 0);
signal  SREFAck       : std_logic;
signal  DataOut       : std_logic_vector(WIDTH-1 downto 0);
signal  DQMOut        : std_logic_vector(DQMWIDTH-1 downto 0);
signal  nCSOut        : std_logic_vector(3 downto 0);
signal  AddrOut       : std_logic_vector(14 downto 0);
signal  CKEOut        : std_logic_vector(3 downto 0);
signal  nRASOut       : std_logic;
signal  nCASOut       : std_logic;
signal  nWEOut        : std_logic;
signal  DataEn        : std_logic;

signal  ExtClk        : std_logic;
signal  D             : std_logic_vector(WIDTH-1 downto 0);

signal  VCC           : std_logic;
signal  VSS           : std_logic;

signal  DelCKEOut     : std_logic_vector(3 downto 0);
signal  DelnCSOut     : std_logic_vector(3 downto 0);
signal  DelnRASOut    : std_logic;
signal  DelnCASOut    : std_logic;
signal  DelnWEOut     : std_logic;
signal  DelDQMOut     : std_logic_vector(DQMWIDTH-1 downto 0);
signal  DelAddrOut    : std_logic_vector(14 downto 0);
signal  DelD          : std_logic_vector(WIDTH-1 downto 0);

signal  IntCKEOut     : std_logic_vector(3 downto 0);
signal  IntnCSOut     : std_logic_vector(3 downto 0);
signal  IntnRASOut    : std_logic;
signal  IntnCASOut    : std_logic;
signal  IntnWEOut     : std_logic;
signal  IntDQMOut     : std_logic_vector(DQMWIDTH-1 downto 0);
signal  IntAddrOut    : std_logic_vector(14 downto 0);
signal  IntD          : std_logic_vector(WIDTH-1 downto 0);
signal  DSELreg       : std_logic;
signal  IntDSELram    : std_logic;
signal  ExtBusReq     : std_logic;
signal  BusReq        : std_logic;
signal  ExtCtlReq     : std_logic;
signal  RdData        : std_logic_vector(WIDTH-1 downto 0);
signal  ExtBusGnt     : std_logic;
signal  AddrIn0       : std_logic_vector(26 downto 2);
signal  AddrIn1       : std_logic_vector(26 downto 2);
signal  AddrIn2       : std_logic_vector(26 downto 2);
signal  DataIn0       : std_logic_vector(WIDTH-1 downto 0);
signal  DataIn1       : std_logic_vector(WIDTH-1 downto 0);
signal  DataIn2       : std_logic_vector(WIDTH-1 downto 0);
signal  DQM0          : std_logic_vector(DQMWIDTH-1 downto 0);
signal  DQM1          : std_logic_vector(DQMWIDTH-1 downto 0);
signal  DQM2          : std_logic_vector(DQMWIDTH-1 downto 0);
signal  Lock0         : std_logic_vector(15 downto 0);
signal  Lock1         : std_logic_vector(15 downto 0);
signal  Lock2         : std_logic_vector(15 downto 0);
signal  Read          : std_logic_vector(2 downto 0);
signal  Write         : std_logic_vector(2 downto 0);
signal  Pre           : std_logic_vector(2 downto 0);
signal  AutoPre       : std_logic_vector(2 downto 0);
signal  XferOut       : std_logic_vector(2 downto 0);
signal  EndOfXfer     : std_logic_vector(2 downto 0);
signal  Commit        : std_logic_vector(2 downto 0);
signal  SplitProceed  : std_logic_vector(2 downto 0);
signal  SplitEn       : std_logic_vector(2 downto 0);
signal  SplitWait     : std_logic_vector(2 downto 0);

signal  HLOCKM       : std_logic := '0';
signal  HBUSREQM     : std_logic := '1';
signal  HGRANTM      : std_logic := '1';
signal  SCANIN       : std_logic := '0';
signal  SCANENABLE   : std_logic := '0';
signal  SCANOUT      : std_logic;
signal  BIGENDIAN    : std_logic;

signal  ZEROFILL     : std_logic_vector(31 downto 0) := (others => '0');

constant GATE_LEVEL  : std_logic := '0';

-- ---------------------------------------------------------------------
-- Main body of code
-- =================
-- ---------------------------------------------------------------------

begin

  iVRG30  <= VRG30;
  iVRG31  <= VRG31;
  iVRG32  <= VRG32;
  iVRG33  <= VRG33;

  VRG34   <= iVRG30;
  VRG35   <= iVRG31;
  VRG37   <= iVRG33;
  VRG36   <= iVRG32;

  iVRG20  <= VRG20;
  iVRG21  <= VRG21;
  iVRG22  <= VRG22;
  iVRG23  <= VRG23;

  VRG24   <= iVRG20;
  VRG25   <= iVRG21;
  VRG27   <= iVRG23;
  VRG26   <= iVRG22;

  iVRG10  <= VRG10;
  iVRG11  <= VRG11;
  iVRG12  <= VRG12;
  iVRG13  <= VRG13;

  VRG14   <= iVRG10;
  VRG15   <= iVRG11;
  VRG17   <= iVRG13;
  VRG16   <= iVRG12;

  iVRG00  <= VRG00;
  iVRG01  <= VRG01;
  iVRG02  <= VRG02;
  iVRG03  <= VRG03;

  VRG04   <= iVRG00;
  VRG05   <= iVRG01;
  VRG07   <= iVRG03;
  VRG06   <= iVRG02;

  VCC    <= '1';
  VSS    <= '0';

  IntD   <= (others => 'H');

  DelCKEOut  <= CKEOut  after HOLDDELAY;
  DelnCSOut  <= nCSOut  after HOLDDELAY;
  DelnRASOut <= nRASOut after HOLDDELAY;
  DelnCASOut <= nCASOut after HOLDDELAY;
  DelnWEOut  <= nWEOut  after HOLDDELAY;
  DelDQMOut  <= DQMOut  after HOLDDELAY;
  DelAddrOut <= AddrOut after HOLDDELAY;
  DelD       <= D       after HOLDDELAY;

  nPOR       <= (nPORTrick and nPORStart) after 3 ns;

  IntCKEOut  <=   DelCKEOut when (GATE_LEVEL = '0')
             else
                  CKEOut;

  IntnCSOut  <=   DelnCSOut when (GATE_LEVEL = '0')
             else
                  nCSOut;

  IntnRASOut <=   DelnRASOut when (GATE_LEVEL = '0')
             else
                  nRASOut;

  IntnCASOut <=   DelnCASOut when (GATE_LEVEL = '0')
             else
                  nCASOut;

  IntnWEOut  <=   DelnWEOut when (GATE_LEVEL = '0')
             else
                  nWEOut;

  IntDQMOut  <=   DelDQMOut when (GATE_LEVEL = '0')
             else
                  DQMOut;

  IntAddrOut <=   DelAddrOut when (GATE_LEVEL = '0')
             else
                  AddrOut;

  IntD       <=   DelD when (GATE_LEVEL = '0')
             else
                  D;

  DataIn     <=   IntD after 1 ns;

-- ---------------------------------------------------------------------
-- HREADY, HRESP and HRDATA selection
-- ---------------------------------------------------------------------
  HREADY3   <= HREADYOR3 when (ORBUS = '1')
            else
               HREADYMUX3;

  HRESP3    <= HRESPOR3 when (ORBUS = '1')
            else
                HRESPMUX3;

  HRDATA3   <=  HRDATAOR3 when (ORBUS = '1')
            else
               HRDATAMUX3;

  HRDATAIn3 <= (dummyDATA & HRDATA3);

  HREADY2   <= HREADYOR2 when (ORBUS = '1')
            else
               HREADYMUX2;

  HRESP2    <= HRESPOR2 when (ORBUS = '1')
            else
                HRESPMUX2;

  HRDATA2   <=  HRDATAOR2 when (ORBUS = '1')
            else
               HRDATAMUX2;

  HRDATAIn2 <= (dummyDATA & HRDATA2);

  HREADY1   <= HREADYOR1 when (ORBUS = '1')
            else
               HREADYMUX1;

  HRESP1    <= HRESPOR1 when (ORBUS = '1')
            else
                HRESPMUX1;

  HRDATA1   <=  HRDATAOR1 when (ORBUS = '1')
            else
               HRDATAMUX1;

  HRDATAIn1 <= (dummyDATA & HRDATA1);

  HREADY0   <= HREADYOR0 when (ORBUS = '1')
            else
               HREADYMUX0;

  HRESP0    <= HRESPOR0 when (ORBUS = '1')
            else
                HRESPMUX0;

  HRDATA0   <=  HRDATAOR0 when (ORBUS = '1')
            else
               HRDATAMUX0;

  HRDATAIn0 <= (dummyDATA & HRDATA0);

-- ---------------------------------------------------------------------
-- For MUX-bus implementations
-- ---------------------------------------------------------------------
  HREADYMUX3  <= iHREADYMUX3;

  iHREADYMUX3 <= HREADYOut32 when (DelHSEL3(2) = '1')
              else
                 HREADYOut31 when (DelHSEL3(1) = '1')
              else
                 HREADYOut31 when (DelHSEL3(0) = '1')
              else
                 HREADYOut3  when DelDefSel3 = '1'
              else
                 '0';

  HRESPMUX3  <= HRESPOut32 when (DelHSEL3(2) = '1')
             else
                HRESPOut31 when (DelHSEL3(1) = '1')
             else
                HRESPOut31 when (DelHSEL3(0) = '1')
             else
                HRESPOut3  when DelDefSel3 = '1'
             else
                "00";

  HRDATAMUX3 <= HRDATAOut32 when (DelHSEL3(2) = '1')
             else
                HRDATAOut31 when (DelHSEL3(1) = '1')
             else
                HRDATAOut31 when (DelHSEL3(0) = '1')
             else
                HRDATAOut3  when DelDefSel3 = '1'
             else
                (others => '0');

  HREADYMUX2  <= iHREADYMUX2;

  iHREADYMUX2 <= HREADYOut21 when (DelHSEL2(0) = '1')
              else
                 HREADYOut2  when DelDefSel2 = '1'
              else
                 '0';

  HRESPMUX2  <= HRESPOut21 when (DelHSEL2(0) = '1')
             else
                HRESPOut2  when DelDefSel2 = '1'
             else
                "00";

  HRDATAMUX2 <= HRDATAOut21 when (DelHSEL2(0) = '1')
             else
                HRDATAOut2  when DelDefSel2 = '1'
             else
                (others => '0');

  HREADYMUX1  <= iHREADYMUX1;

  iHREADYMUX1 <= HREADYOut11 when (DelHSEL1(0) = '1')
              else
                 HREADYOut1  when DelDefSel1 = '1'
              else
                 '0';

  HRESPMUX1  <= HRESPOut11 when (DelHSEL1(0) = '1')
             else
                HRESPOut1  when DelDefSel1 = '1'
             else
                "00";

  HRDATAMUX1 <= HRDATAOut11 when (DelHSEL1(0) = '1')
             else
                HRDATAOut1  when DelDefSel1 = '1'
             else
                (others => '0');

  HREADYMUX0  <= iHREADYMUX0;

  iHREADYMUX0 <= HREADYOut01 when (DelHSEL0(0) = '1')
              else
                HREADYOut0  when DelDefSel0 = '1'
              else
                '0';

  HRESPMUX0  <= HRESPOut01 when (DelHSEL0(0) = '1')
             else
                HRESPOut0  when DelDefSel0 = '1'
             else
                "00";

  HRDATAMUX0 <= HRDATAOut01 when (DelHSEL0(0) = '1')
             else
               HRDATAOut0  when DelDefSel0 = '1'
             else
               (others => '0');

-- ---------------------------------------------------------------------
-- For OR bus implementations
-- ---------------------------------------------------------------------
  HRESPOR3  <= HRESPOut32 or HRESPOut31 or HRESPOut3;

  HREADYOR3 <= HREADYOut32 or HREADYOut31 or HREADYOut3;

  HRDATAOR3 <= HRDATAOut32 or HRDATAOut31 or HRDATAOut3;

  HRESPOR2  <= HRESPOut21 or HRESPOut2;

  HREADYOR2 <= HREADYOut21 or HREADYOut2;

  HRDATAOR2 <= HRDATAOut21 or HRDATAOut2;

  HRESPOR1  <= HRESPOut11 or HRESPOut1;

  HREADYOR1 <= HREADYOut11 or HREADYOut1;

  HRDATAOR1 <= HRDATAOut11 or HRDATAOut1;

  HRESPOR0  <= HRESPOut01 or HRESPOut0;

  HREADYOR0 <= HREADYOut01 or HREADYOut0;

  HRDATAOR0 <= HRDATAOut01 or HRDATAOut0;

-- ---------------------------------------------------------------------
-- Latching HSEL
-- ---------------------------------------------------------------------
p_HSEL3Seq : process (HCLK3, HRESETn3)
begin
  if (HRESETn3 = '0') then
    DelHSEL3 <= (others => '0');
    DelDefSel3 <= '1';
  elsif (HCLK3'event and HCLK3 = '1' and HREADY3 = '1') then
    DelHSEL3 <= HSEL3;
    DelDefSel3 <= DefSlaveSel3;
  end if;
end process p_HSEL3Seq;

p_HSEL2Seq : process (HCLK2, HRESETn2)
begin
  if (HRESETn2 = '0') then
    DelHSEL2 <= (others => '0');
    DelDefSel2 <= '1';
  elsif (HCLK2'event and HCLK2 = '1' and HREADY2 = '1') then
    DelHSEL2 <= HSEL2;
    DelDefSel2 <= DefSlaveSel2;
  end if;
end process p_HSEL2Seq;

p_HSEL1Seq : process (HCLK1, HRESETn1)
begin
  if (HRESETn1 = '0') then
    DelHSEL1 <= (others => '0');
    DelDefSel1 <= '1';
  elsif (HCLK1'event and HCLK1 = '1' and HREADY1 = '1') then
    DelHSEL1 <= HSEL1;
    DelDefSel1 <= DefSlaveSel1;
  end if;
end process p_HSEL1Seq;

p_HSEL0Seq : process (HCLK0, HRESETn0)
begin
  if (HRESETn0 = '0') then
    DelHSEL0 <= (others => '0');
    DelDefSel0 <= '1';
  elsif (HCLK0'event and HCLK0 = '1' and HREADY0 = '1') then
    DelHSEL0 <= HSEL0;
    DelDefSel0 <= DefSlaveSel0;
  end if;
end process p_HSEL0Seq;

------------------------------------------------------------------------

u_ahbslv3_tb : ahbslave_tb
generic map(
            INFILE                 => "./infile3.bif",
            Verbosity              => 0,
            HaltOnMismatch         => 0,
            XonSig                 => 0,
            tclkl                  => tclkl,
            tclkh                  => tclkh,
            Databuswidth           => 32,
            ahbslave_tb_TimingFile => ""
	   )
port map(
         HCLK         => HCLK3,
         HRESETn      => HRESETn3,
         HADDR        => HADDR3,
         HTRANS       => HTRANS3,
         HWRITE       => HWRITE3,
         HSIZE        => HSIZE3,
         HBURST       => HBURST3,
         HPROT        => HPROT3,
         HMASTER      => HMASTER3,
         HMASTLOCK    => HMASTLOCK3,
         HWDATA       => HWDATA3,
         HSPLIT       => HSPLITIn3,
         HRDATA       => HRDATAIn3,
         HREADY       => HREADY3,
         HRESP        => HRESP3,
         VRG0         => VRG30,
         VRG1         => VRG31,
         VRG2         => VRG32,
         VRG3         => VRG33,
         VRG4         => VRG34,
         VRG5         => VRG35,
         VRG6         => VRG36,
         VRG7         => VRG37
        );

u_ahbslv2_tb : ahbslave_tb
generic map(
            INFILE                 => "./infile2.bif",
            Verbosity              => 0,
            HaltOnMismatch         => 0,
            XonSig                 => 0,
            tclkl                  => tclkl,
            tclkh                  => tclkh,
            Databuswidth           => 32,
            ahbslave_tb_TimingFile => ""
	   )
port map(
         HCLK         => HCLK2,
         HRESETn      => HRESETn2,
         HADDR        => HADDR2,
         HTRANS       => HTRANS2,
         HWRITE       => HWRITE2,
         HSIZE        => HSIZE2,
         HBURST       => HBURST2,
         HPROT        => HPROT2,
         HMASTER      => HMASTER3,
         HMASTLOCK    => HMASTLOCK3,
         HWDATA       => HWDATA2,
         HSPLIT       => HSPLITIn3,
         HRDATA       => HRDATAIn2,
         HREADY       => HREADY2,
         HRESP        => HRESP2,
         VRG0         => VRG20,
         VRG1         => VRG21,
         VRG2         => VRG22,
         VRG3         => VRG23,
         VRG4         => VRG24,
         VRG5         => VRG25,
         VRG6         => VRG26,
         VRG7         => VRG27
        );

u_ahbslv1_tb : ahbslave_tb
generic map(
            INFILE                 => "./infile1.bif",
            Verbosity              => 0,
            HaltOnMismatch         => 0,
            XonSig                 => 0,
            tclkl                  => tclkl,
            tclkh                  => tclkh,
            Databuswidth           => 32,
            ahbslave_tb_TimingFile => ""
	   )
port map(
         HCLK         => HCLK1,
         HRESETn      => HRESETn1,
         HADDR        => HADDR1,
         HTRANS       => HTRANS1,
         HWRITE       => HWRITE1,
         HSIZE        => HSIZE1,
         HBURST       => HBURST1,
         HPROT        => HPROT1,
         HMASTER      => HMASTER3,
         HMASTLOCK    => HMASTLOCK3,
         HWDATA       => HWDATA1,
         HSPLIT       => HSPLITIn3,
         HRDATA       => HRDATAIn1,
         HREADY       => HREADY1,
         HRESP        => HRESP1,
         VRG0         => VRG10,
         VRG1         => VRG11,
         VRG2         => VRG12,
         VRG3         => VRG13,
         VRG4         => VRG14,
         VRG5         => VRG15,
         VRG6         => VRG16,
         VRG7         => VRG17
        );

u_ahbslv0_tb : ahbslave_tb
generic map(
            INFILE                 => "./infile0.bif",
            Verbosity              => 0,
            HaltOnMismatch         => 0,
            XonSig                 => 0,
            tclkl                  => tclkl,
            tclkh                  => tclkh,
            Databuswidth           => 32,
            ahbslave_tb_TimingFile => ""
	   )
port map(
         HCLK         => HCLK0,
         HRESETn      => HRESETn0,
         HADDR        => HADDR0,
         HTRANS       => HTRANS0,
         HWRITE       => HWRITE0,
         HSIZE        => HSIZE0,
         HBURST       => HBURST0,
         HPROT        => HPROT0,
         HMASTER      => HMASTER3,
         HMASTLOCK    => HMASTLOCK3,
         HWDATA       => HWDATA0,
         HSPLIT       => HSPLITIn3,
         HRDATA       => HRDATAIn0,
         HREADY       => HREADY0,
         HRESP        => HRESP0,
         VRG0         => VRG00,
         VRG1         => VRG01,
         VRG2         => VRG02,
         VRG3         => VRG03,
         VRG4         => VRG04,
         VRG5         => VRG05,
         VRG6         => VRG06,
         VRG7         => VRG07
        );

u_decoder3 : decoder1
port map(
         HADDR       => HADDR3,
         HSEL        => HSEL3,
         DefSlaveSel => DefSlaveSel3
        );

u_decoder1 : decoder0
port map(
         HADDR       => HADDR1,
         HSEL        => HSEL1,
         DefSlaveSel => DefSlaveSel1
        );

u_decoder2 : decoder0
port map(
         HADDR       => HADDR2,
         HSEL        => HSEL2,
         DefSlaveSel => DefSlaveSel2
        );

u_decoder0 : decoder0
port map(
         HADDR       => HADDR0,
         HSEL        => HSEL0,
         DefSlaveSel => DefSlaveSel0
        );

uSdramTrick : SdramTrick
port map(
         HCLK        => HCLK3,
         HRESETn     => HRESETn3,
         HSIZE       => HSIZE3,
         HBURST      => HBURST3,
         HTRANS      => HTRANS3,
         HWRITE      => HWRITE3,
         HSEL        => HSEL3(2),
         HREADYIn    => HREADY3,
         BIGENDIAN   => BIGENDIAN,

         SREFAck     => SREFAck,
         CKE         => CKEOut,
         nRAS        => nRASOut,
         nCAS        => nCASOut,
         nCS         => nCSOut,
         nWE         => nWEOut,
         ExtBusReq   => BusReq,
         AddrOut     => AddrOut(13 downto 0),
         HADDR       => HADDR3(ADDWIDTH downto 0),
         HWDATA      => HWDATA3(WIDTH-1 downto 0),

         nPOR        => nPORTrick,
         ExtBusGnt   => ExtBusGnt,
         SREFReq     => SREFReq,
         HREADYOut   => HREADYOut32,
         HRESP       => HRESPOut32,
         HRDATA      => HRDATAOut32
        );

BusReq    <=  '1' when (ExtBusReq = '1'  or ExtCtlReq = '1')
          else
              '0';
HRDATAOutIn3 <= dummyDATA & HRDATAOut3;
HRDATAOutIn2 <= dummyDATA & HRDATAOut2;
HRDATAOutIn1 <= dummyDATA & HRDATAOut1;
HRDATAOutIn0 <= dummyDATA & HRDATAOut0;

uSdram : Sdram
  port map(
           HCLK       => HCLK3,
           CLKIn      => ExtClk,
           HRESETn    => HRESETn3,
           nPOR       => nPOR,
           SREFReq    => SREFReq,
           ExtBusGnt  => ExtBusGnt,
           ExtCtlGnt  => ExtBusGnt,
           DataIn     => DataIn,

           HSIZE3     => HSIZE3(1 downto 0),
           HWRITE3    => HWRITE3,
           HTRANS3    => HTRANS3,
           HBURST3    => HBURST3,
           HREADYin3  => HREADY3,
           HSELram3   => HSEL3(1),
           HSELreg3   => HSEL3(0),
           HADDR3     => HADDR3(28 downto 0),
           HWDATA3    => HWDATA3(WIDTH-1 downto 0),

           HSIZE2     => HSIZE2(1 downto 0),
           HWRITE2    => HWRITE2,
           HTRANS2    => HTRANS2,
           HBURST2    => HBURST2,
           HREADYin2  => HREADY2,
           HSELram2   => HSEL2(0),
           HADDR2     => HADDR2(28 downto 0),
           HWDATA2    => HWDATA2(WIDTH-1 downto 0),

           HSIZE1     => HSIZE1(1 downto 0),
           HWRITE1    => HWRITE1,
           HTRANS1    => HTRANS1,
           HBURST1    => HBURST1,
           HREADYin1  => HREADY1,
           HSELram1   => HSEL1(0),
           HADDR1     => HADDR1(28 downto 0),
           HWDATA1    => HWDATA1(WIDTH-1 downto 0),

           HSIZE0     => HSIZE0(1 downto 0),
           HWRITE0    => HWRITE0,
           HTRANS0    => HTRANS0,
           HBURST0    => HBURST0,
           HREADYin0  => HREADY0,
           HSELram0   => HSEL0(0),
           HADDR0     => HADDR0(28 downto 0),
           HWDATA0    => HWDATA0(WIDTH-1 downto 0),

           SCANIN     => SCANIN,
           SCANENABLE => SCANENABLE,

           HRDATA3    => HRDATAOut31,
           HRESP3     => HRESPOut31,
           HREADYout3 => HREADYOut31,

           HRDATA2    => HRDATAOut21,
           HRESP2     => HRESPOut21,
           HREADYout2 => HREADYOut21,

           HRDATA1    => HRDATAOut11,
           HRESP1     => HRESPOut11,
           HREADYout1 => HREADYOut11,

           HRDATA0    => HRDATAOut01,
           HRESP0     => HRESPOut01,
           HREADYout0 => HREADYOut01,

           SREFAck    => SREFAck,
           DataOut    => DataOut,
           DQMOut     => DQMOut,
           nCSOut     => nCSOut,
           AddrOut    => AddrOut,
           CKEOut     => CKEOut,
           nRASOut    => nRASOut,
           nCASOut    => nCASOut,
           nWEOut     => nWEOut,
           DataEn     => DataEn,
           CLKOut     => CLKOut,
           ExtBusReq  => ExtBusReq,
           ExtCtlReq  => ExtCtlReq,
           BIGENDIAN  => BIGENDIAN,

           SCANOUT    => SCANOUT
          );

u_Defslave3 : Defslave
port map(
         HCLK      => HCLK3,
         HSEL      => DelDefSel3,
         HRESETn   => HRESETn3,
         HTRANS    => HTRANS3(1),
         HRESP     => HRESPOut3,
         HREADYIn  => HREADY3,
         HREADYOut => HREADYOut3,
         HRDATAOut => HRDATAOutIn3
        );

u_Defslave2 : Defslave
port map(
         HCLK      => HCLK2,
         HSEL      => DelDefSel2,
         HRESETn   => HRESETn2,
         HTRANS    => HTRANS2(1),
         HRESP     => HRESPOut2,
         HREADYIn  => HREADY2,
         HREADYOut => HREADYOut2,
         HRDATAOut => HRDATAOutIn2
        );

u_Defslave1 : Defslave
port map(
         HCLK      => HCLK1,
         HSEL      => DelDefSel1,
         HRESETn   => HRESETn1,
         HTRANS    => HTRANS1(1),
         HRESP     => HRESPOut1,
         HREADYIn  => HREADY1,
         HREADYOut => HREADYOut1,
         HRDATAOut => HRDATAOutIn1
        );

u_Defslave0 : Defslave
port map(
         HCLK      => HCLK0,
         HSEL      => DelDefSel0,
         HRESETn   => HRESETn0,
         HTRANS    => HTRANS0(1),
         HRESP     => HRESPOut0,
         HREADYIn  => HREADY0,
         HREADYOut => HREADYOut0,
         HRDATAOut => HRDATAOutIn0
        );

u_buswatch3 :  BusWatch
  generic map (
               HaltOnMismatch => FALSE,
               Verbosity      => FALSE,
               Tclk           => Tclk,
               Tovtr          => Tovtr,
               Tohtr          => Tohtr,
               Tova           => Tova,
               Toha           => Toha,
               Tovctl         => Tovctl,
               Tohctl         => Tohctl,
               Tovwd          => Tovwd,
               Tohwd          => Tohwd,
               Tovreq         => Tovreq,
               Tohreq         => Tohreq,
               Tovlck         => Tovlck,
               Tohlck         => Tohlck
              )
  port map (
            HCLK      => HCLK3,
            HRESETn   => HRESETn3,
            HTRANS    => HTRANS3,
            HADDR     => HADDR3,
            HSIZE     => HSIZE3,
            HBURST    => HBURST3,
            HBUSREQx  => HBUSREQM,
            HGRANTx   => HGRANTM,
            HREADY    => HREADYMUX3,
            HLOCKx    => HLOCKM,
            HWDATA    => HWDATA3,
            HPROT     => HPROT3,
            HWRITE    => HWRITE3,
            HRESP     => HRESP3
           );

u_buswatch2 :  BusWatch
  generic map (
               HaltOnMismatch => FALSE,
               Verbosity      => FALSE,
               Tclk           => Tclk,
               Tovtr          => Tovtr,
               Tohtr          => Tohtr,
               Tova           => Tova,
               Toha           => Toha,
               Tovctl         => Tovctl,
               Tohctl         => Tohctl,
               Tovwd          => Tovwd,
               Tohwd          => Tohwd,
               Tovreq         => Tovreq,
               Tohreq         => Tohreq,
               Tovlck         => Tovlck,
               Tohlck         => Tohlck
              )
  port map (
            HCLK      => HCLK2,
            HRESETn   => HRESETn2,
            HTRANS    => HTRANS2,
            HADDR     => HADDR2,
            HSIZE     => HSIZE2,
            HBURST    => HBURST2,
            HBUSREQx  => HBUSREQM,
            HGRANTx   => HGRANTM,
            HREADY    => HREADYMUX2,
            HLOCKx    => HLOCKM,
            HWDATA    => HWDATA2,
            HPROT     => HPROT2,
            HWRITE    => HWRITE2,
            HRESP     => HRESP2
           );

u_buswatch1 :  BusWatch
  generic map (
               HaltOnMismatch => FALSE,
               Verbosity      => FALSE,
               Tclk           => Tclk,
               Tovtr          => Tovtr,
               Tohtr          => Tohtr,
               Tova           => Tova,
               Toha           => Toha,
               Tovctl         => Tovctl,
               Tohctl         => Tohctl,
               Tovwd          => Tovwd,
               Tohwd          => Tohwd,
               Tovreq         => Tovreq,
               Tohreq         => Tohreq,
               Tovlck         => Tovlck,
               Tohlck         => Tohlck
              )
  port map (
            HCLK      => HCLK1,
            HRESETn   => HRESETn1,
            HTRANS    => HTRANS1,
            HADDR     => HADDR1,
            HSIZE     => HSIZE1,
            HBURST    => HBURST1,
            HBUSREQx  => HBUSREQM,
            HGRANTx   => HGRANTM,
            HREADY    => HREADYMUX1,
            HLOCKx    => HLOCKM,
            HWDATA    => HWDATA1,
            HPROT     => HPROT1,
            HWRITE    => HWRITE1,
            HRESP     => HRESP1
           );

u_buswatch0 :  BusWatch
  generic map (
               HaltOnMismatch => FALSE,
               Verbosity      => FALSE,
               Tclk           => Tclk,
               Tovtr          => Tovtr,
               Tohtr          => Tohtr,
               Tova           => Tova,
               Toha           => Toha,
               Tovctl         => Tovctl,
               Tohctl         => Tohctl,
               Tovwd          => Tovwd,
               Tohwd          => Tohwd,
               Tovreq         => Tovreq,
               Tohreq         => Tohreq,
               Tovlck         => Tovlck,
               Tohlck         => Tohlck
              )
  port map (
            HCLK      => HCLK0,
            HRESETn   => HRESETn0,
            HTRANS    => HTRANS0,
            HADDR     => HADDR0,
            HSIZE     => HSIZE0,
            HBURST    => HBURST0,
            HBUSREQx  => HBUSREQM,
            HGRANTx   => HGRANTM,
            HREADY    => HREADYMUX0,
            HLOCKx    => HLOCKM,
            HWDATA    => HWDATA0,
            HPROT     => HPROT0,
            HWRITE    => HWRITE0,
            HRESP     => HRESP0
           );
------------------------------------------------------------------------
-- Model the trace delay in the clock fed to the memory devices
------------------------------------------------------------------------
  ExtClk   <= CLKOut after HCLKSkew;

------------------------------------------------------------------------
-- Drive write data from the VSDRAM controller onto the main memory
-- databus when the DataEn signal is asserted.
------------------------------------------------------------------------
  D <= DataOut when (DataEn = '1')
    else
       (others => 'Z');

------------------------------------------------------------------------
-- The memory organisation is as follows:
-- * 4 Chip Selects from the VSDRAM controller used as below:
-- * Slot 0 has  two 64 MBit parts each with 16-bit databus
-- * Slot 1 has four 64 MBit parts each with  8-bit databus
-- * Slot 2 has  two 256 MBit parts each with 16-bit databus
-- * Slot 3 has four 256 MBit parts each with  8-bit databus
------------------------------------------------------------------------
  u0_0_sdram : SdramNec64Mx16
  port map (
            clk    =>  ExtClk,
            cke    =>  IntCKEOut(0),
            csbar  =>  IntnCSOut(0),
            rasbar =>  IntnRASOut,
            casbar =>  IntnCASOut,
            webar  =>  IntnWEOut,
            dqm    =>  IntDQMOut(1 downto 0),
            a      =>  IntAddrOut(13 downto 0),

            dq     =>  IntD(15 downto 0)
           );

  u0_1_sdram : SdramNec64Mx16
  port map (
            clk    =>  ExtClk,
            cke    =>  IntCKEOut(0),
            csbar  =>  IntnCSOut(0),
            rasbar =>  IntnRASOut,
            casbar =>  IntnCASOut,
            webar  =>  IntnWEOut,
            dqm    =>  IntDQMOut(3 downto 2),
            a      =>  IntAddrOut(13 downto 0),

            dq     =>  IntD(31 downto 16)
           );

  u1_0_sdram : SdramNec64Mx8
  port map (
            clk    =>  ExtClk,
            cke    =>  IntCKEOut(1),
            csbar  =>  IntnCSOut(1),
            rasbar =>  IntnRASOut,
            casbar =>  IntnCASOut,
            webar  =>  IntnWEOut,
            dqm    =>  IntDQMOut(0),
            a      =>  IntAddrOut(13 downto 0),

            dq     =>  IntD(7 downto 0)
           );

  u1_1_sdram : SdramNec64Mx8
  port map (
            clk    =>  ExtClk,
            cke    =>  IntCKEOut(1),
            csbar  =>  IntnCSOut(1),
            rasbar =>  IntnRASOut,
            casbar =>  IntnCASOut,
            webar  =>  IntnWEOut,
            dqm    =>  IntDQMOut(1),
            a      =>  IntAddrOut(13 downto 0),

            dq     =>  IntD(15 downto 8)
           );

  u1_2_sdram :SdramNec64Mx8
  port map (
            clk    =>  ExtClk,
            cke    =>  IntCKEOut(1),
            csbar  =>  IntnCSOut(1),
            rasbar =>  IntnRASOut,
            casbar =>  IntnCASOut,
            webar  =>  IntnWEOut,
            dqm    =>  IntDQMOut(2),
            a      =>  IntAddrOut(13 downto 0),

            dq     =>  IntD(23 downto 16)
           );

  u1_3_sdram :SdramNec64Mx8
  port map (
            clk    =>  ExtClk,
            cke    =>  IntCKEOut(1),
            csbar  =>  IntnCSOut(1),
            rasbar =>  IntnRASOut,
            casbar =>  IntnCASOut,
            webar  =>  IntnWEOut,
            dqm    =>  IntDQMOut(3),
            a      =>  IntAddrOut(13 downto 0),

            dq     =>  IntD(31 downto 24)
           );

  u2_0_sdram :SdramNec256Mx16
  port map (
            clk    => ExtClk,
            cke    => IntCKEOut(2),
            csbar  => IntnCSOut(2),
            rasbar => IntnRASOut,
            casbar => IntnCASOut,
            webar  => IntnWEOut,
            dqm    => IntDQMOut(1 downto 0),
            a      => IntAddrOut(12 downto 0),
            ba     => IntAddrOut(14 downto 13),

            dq     => IntD(15 downto 0)
           );

  u2_1_sdram :SdramNec256Mx16
  port map (
            clk    => ExtClk,
            cke    => IntCKEOut(2),
            csbar  => IntnCSOut(2),
            rasbar => IntnRASOut,
            casbar => IntnCASOut,
            webar  => IntnWEOut,
            dqm    => IntDQMOut(3 downto 2),
            a      => IntAddrOut(12 downto 0),
            ba     => IntAddrOut(14 downto 13),

            dq     => IntD(31 downto 16)
           );

  u3_0_sdram :SdramNec256Mx8
  port map (
            clk    => ExtClk,
            cke    => IntCKEOut(3),
            csbar  => IntnCSOut(3),
            rasbar => IntnRASOut,
            casbar => IntnCASOut,
            webar  => IntnWEOut,
            dqm    => IntDQMOut(0),
            a      => IntAddrOut(12 downto 0),
            ba     => IntAddrOut(14 downto 13),

            dq     => IntD(7 downto 0)
           );

  u3_1_sdram :SdramNec256Mx8
  port map (
            clk    => ExtClk,
            cke    => IntCKEOut(3),
            csbar  => IntnCSOut(3),
            rasbar => IntnRASOut,
            casbar => IntnCASOut,
            webar  => IntnWEOut,
            dqm    => IntDQMOut(1),
            a      => IntAddrOut(12 downto 0),
            ba     => IntAddrOut(14 downto 13),

            dq     => IntD(15 downto 8)
           );

  u3_2_sdram :SdramNec256Mx8
  port map (
            clk    => ExtClk,
            cke    => IntCKEOut(3),
            csbar  => IntnCSOut(3),
            rasbar => IntnRASOut,
            casbar => IntnCASOut,
            webar  => IntnWEOut,
            dqm    => IntDQMOut(2),
            a      => IntAddrOut(12 downto 0),
            ba     => IntAddrOut(14 downto 13),

            dq     => IntD(23 downto 16)
           );

  u3_3_sdram :SdramNec256Mx8
  port map (
            clk    => ExtClk,
            cke    => IntCKEOut(3),
            csbar  => IntnCSOut(3),
            rasbar => IntnRASOut,
            casbar => IntnCASOut,
            webar  => IntnWEOut,
            dqm    => IntDQMOut(3),
            a      => IntAddrOut(12 downto 0),
            ba     => IntAddrOut(14 downto 13),

            dq     => IntD(31 downto 24)
           );

process
begin
     nPORStart    <= '0' after 1 ns;
 wait until HCLK3'event and (HCLK3 = '1');
 wait until HCLK3'event and (HCLK3 = '1');
     nPORStart    <= '1' after 1 ns;
 wait;
end process;

end structural;

-- =============================== End ============================== --
