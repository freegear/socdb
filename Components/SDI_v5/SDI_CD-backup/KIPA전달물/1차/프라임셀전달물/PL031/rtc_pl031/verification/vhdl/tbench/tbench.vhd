-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : tbench.vhd.rca
-- File Revision       : 1.8
-- 
-- Release Information : PrimeCell(TM)-PL031-REL1v0
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : Top level of the Rtc Compliance TestBench
--
--                       This file instantiates the Rtc module, the Rtc trickbox
--                       and the Read Data Mux. In this test bench, the CLK1HZ
--                       frequency is set to be different from the PCLK 
--                       frequency. Free-running tests should be run on this 
--                       testbench.
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library tbench;
use tbench.timing.all;

library uut;

library trickbox;

entity tbench is
end tbench;

-- ---------------------------------------------------------------------
--
--                               tbench
--                               ======
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--  Top level testbench.This file integrates the Rtc, Rtc trickbox and
-- the APB interface modules to enable system level testing.
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE ===========================--

architecture structural of tbench is
  
-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
  
  component apbslave_tb
  generic
         (
           PRDATA_mask    : string;
           INFILE         : string;
           Verbosity      : integer;
           HaltOnMismatch : integer;
           tclks          : time;
           tclkl          : time;
           tclkh          : time
         );
  port (
         PRESETn          : out   std_logic;
         PCLK             : out   std_logic;
         PADDR            : out   std_logic_vector(31 downto 0);
         PWRITE           : out   std_logic;
         PENABLE          : out   std_logic;
         PSEL             : out   std_logic;
         PSELT            : out   std_logic;
         PWDATA           : out   std_logic_vector(31 downto 0);
         PRDATA           : in    std_logic_vector(31 downto 0);
         VRG0             : inout std_logic_vector(31 downto 0);
         VRG1             : inout std_logic_vector(31 downto 0);
         VRG2             : inout std_logic_vector(31 downto 0);
         VRG3             : inout std_logic_vector(31 downto 0);
         VRG4             : inout std_logic_vector(31 downto 0);
         VRG5             : inout std_logic_vector(31 downto 0);
         VRG6             : inout std_logic_vector(31 downto 0);
         VRG7             : inout std_logic_vector(31 downto 0)
       );
  end component;

  component  Rtc
  port (

        PCLK         : in  std_logic; 
        PRESETn      : in  std_logic;
        PWRITE       : in  std_logic;
        PSEL         : in  std_logic;
        PENABLE      : in  std_logic;
        PADDR        : in  std_logic_vector(11 downto 2);   
        PWDATA       : in  std_logic_vector(31 downto 0);
        PRDATA       : out std_logic_vector(31 downto 0);
        CLK1HZ       : in  std_logic;
        nRTCRST      : in  std_logic;
        nPOR         : in  std_logic;
        SCANENABLE   : in  std_logic;
        SCANINPCLK   : in  std_logic;
        SCANINCLK1HZ : in  std_logic;
        SCANOUTPCLK  : out std_logic;
        SCANOUTCLK1HZ: out std_logic;
        RTCINTR      : out std_logic
      ) ;
  end  component;

  component  RtcTrick
  port (
        -- APB bus signals
        PCLK        : in    std_logic;
        PRESETn     : in    std_logic;
        PENABLE     : in    std_logic;
        PSELT       : in    std_logic;
        PWRITE      : in    std_logic;
        PADDR       : in    std_logic_vector(7 downto 2);
        PWData      : in    std_logic_vector(15 downto 0);
        PRData      : out   std_logic_vector(15 downto 0);
 
        -- RTC clock and reset signals
        CLK1HZ      : out   std_logic;
        nRTCRST     : out   std_logic;
        nPOR        : out   std_logic;
        
        -- RTC Interrupt signal
        RTCINTR     : in    std_logic;
        
        -- SCAN signals
        SCANMODE    : out   std_logic
       );
  end component;

  component apbmux
  port (
         PCLK             : in    std_logic;
         PRESETn          : in    std_logic;
         PSEL             : in    std_logic;
         PSELT            : in    std_logic;
         PRData0          : in    std_logic_vector(31 downto 0);
         PRData1          : in    std_logic_vector(31 downto 0);
         PRData           : out   std_logic_vector(31 downto 0)
       );
  end component;
  
  -----------------------------------------------------------------------------
  -- If the XonPSEL constant is set to '0' (default), an 'X' appearing
  -- on the PSEL line, the PWRITE or the PADDR will be converted to '0'.
  -- If this constant is set to '1', the PSEL, PWRITE and the PADDR 
  -- generated internally by the testbench are passed on unmodified. 
  -----------------------------------------------------------------------------
  constant XonPSEL    : std_logic := '0';

  signal PCLK         : std_logic;
  signal PRESETn        : std_logic;
  signal PADDR        : std_logic_vector(31 downto 0);
  signal I_PADDR      : std_logic_vector(31 downto 0); 
                                                              
  signal PWRITE       : std_logic;
  signal I_PWRITE     : std_logic; 
  signal PENABLE      : std_logic;
  signal PSEL         : std_logic; 
  signal I_PSEL       : std_logic; 
  signal PSELT        : std_logic; 
  signal I_PSELT      : std_logic; 
  signal PRDATA0      : std_logic_vector(31 downto 0);
  signal PRDATA1      : std_logic_vector(31 downto 0);
  signal PRDATA       : std_logic_vector(31 downto 0)
                        := "00000000000000000000000000000000";
  signal PWDATA       : std_logic_vector(31 downto 0);

  signal CLK1HZ       : std_logic;
  signal nRTCRST      : std_logic;
  signal nPOR         : std_logic;
  signal RTCINTR      : std_logic;
  signal SCANMODE     : std_logic;
  signal SCANINPCLK   : std_logic;
  signal SCANINCLK1HZ : std_logic;
  signal SCANOUTPCLK  : std_logic;
  signal SCANOUTCLK1HZ: std_logic;
  signal SCANENABLE   : std_logic;
 
  signal RtcRdData    : std_logic_vector(31 downto 0);
  signal TrickRdData  : std_logic_vector(15 downto 0);
 
  -- Read Fill vector
  signal ReadFill     : std_logic_vector(31 downto 0);

  signal VRG0         : std_logic_vector(31 downto 0);
  signal VRG1         : std_logic_vector(31 downto 0);  
  signal VRG2         : std_logic_vector(31 downto 0);
  signal VRG3         : std_logic_vector(31 downto 0);
  signal VRG4         : std_logic_vector(31 downto 0);
  signal VRG5         : std_logic_vector(31 downto 0);
  signal VRG6         : std_logic_vector(31 downto 0);
  signal VRG7         : std_logic_vector(31 downto 0);
 
-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------
   
begin

  -- Connect all the scan inputs to '0' to prevent interference with
  -- functional mode tests.
     SCANENABLE     <= '0';
     SCANINPCLK     <= '0';
     SCANINCLK1HZ   <= '0';
  
  ReadFill <= (others => '0');

  PSEL  <= '0' when (XonPSEL = '0' and I_PSEL = 'X') 
        else
           I_PSEL;

  PSELT <= '0' when (XonPSEL = '0' and I_PSELT = 'X') 
        else
           I_PSELT;

  PWRITE<= '0' when (XonPSEL = '0' and I_PWRITE = 'X') 
        else
           I_PWRITE;

  p_PADDR : process (I_PADDR)
  begin
    for i in 0 to 31 loop
      if ((XonPSEL = '0') and (I_PADDR(i) = 'X')) then  
          PADDR(i) <= '0';
      else
        PADDR(i) <= I_PADDR(i);
      end if;
    end loop;
  end process p_PADDR;

  --  All the unconnected Virtual Register inputs should be set to zero:
  VRG0 (31 downto 0) <= (others => '0');
  VRG1 (31 downto 0) <= (others => '0');
  VRG2 (31 downto 0) <= (others => '0');
  VRG3 (31 downto 0) <= (others => '0');
  VRG4 (31 downto 0) <= (others => '0');
  VRG5 (31 downto 0) <= (others => '0');
  VRG6 (31 downto 0) <= (others => '0');
  VRG7 (31 downto 0) <= (others => '0');
   
  u_apbslv_tb : apbslave_tb
    generic map (
                 PRDATA_mask    => "FFFFFFFF",
                 INFILE         => "../../bustest/invec/infile.bif", 
                 Verbosity      => 0,
                 HaltOnMismatch => 0,
                 tclks          => Tclks,
                 tclkl          => Tclkl,
                 tclkh          => Tclkh
                )
  port map (
             PRESETn          => PRESETn,
             PCLK             => PCLK,
             PADDR            => I_PADDR,
             PWRITE           => I_PWRITE,
             PENABLE          => PENABLE,
             PSEL             => I_PSEL,
             PSELT            => I_PSELT,
             PRDATA           => PRDATA,
             PWDATA           => PWDATA,
             VRG0             => VRG0,
             VRG1             => VRG1,
             VRG2             => VRG2,
             VRG3             => VRG3,
             VRG4             => VRG4,
             VRG5             => VRG5,
             VRG6             => VRG6,
             VRG7             => VRG7
           );

  uut : Rtc  
  port map (
            PCLK                => PCLK,
            PRESETn             => PRESETn,
            PWRITE              => PWRITE,
            PSEL                => PSEL,
            PENABLE             => PENABLE,
            PADDR(11 downto 2)  => PADDR(11 downto 2),
            PWDATA              => PWDATA,
            PRDATA              => RtcRdData,
            CLK1HZ              => CLK1HZ,
            nRTCRST             => nRTCRST,
            nPOR                => nPOR,
            SCANENABLE          => SCANMODE,
            SCANINPCLK          => SCANINPCLK,
            SCANINCLK1HZ        => SCANINCLK1HZ, 
            SCANOUTPCLK         => SCANOUTPCLK,
            SCANOUTCLK1HZ       => SCANOUTCLK1HZ,
            RTCINTR             => RTCINTR
           );

u_RtcTrick : RtcTrick
  port map (
            PCLK         => PCLK,
            PRESETn      => PRESETn,
            PENABLE      => PENABLE,
            PSELT        => PSELT,
            PWRITE       => PWRITE,
            PADDR        => PADDR(7 downto 2),
            PWData       => PWData(15 downto 0),
            PRData       => TrickRdData,
            CLK1HZ       => CLK1HZ,
            nRTCRST      => nRTCRST,
            nPOR         => nPOR,
            RTCINTR      => RTCINTR,
            SCANMODE     => SCANMODE
           );

  PRDATA0 <= RtcRdData;
  PRDATA1 <= ReadFill(31 downto 16) & TrickRdData;
 
  u_apbmux : apbmux
  port map (
             PCLK             => PCLK,
             PRESETn          => PRESETn,
             PSEL             => PSEL,
             PSELT            => PSELT,
             PRData0          => PRDATA0,
             PRData1          => PRDATA1,
             PRData           => PRDATA
           );
   
end structural;

-- --================================= End ===================================--
