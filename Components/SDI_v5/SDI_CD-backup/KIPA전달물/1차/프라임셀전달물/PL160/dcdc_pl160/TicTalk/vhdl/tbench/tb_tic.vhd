-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1999 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name              : tb_tic.vhd,v
-- File Revision          : 1.3
--  
-- Release Information    : PL160-REL1v1
--  
-- --=========================================================================--

-- -----------------------------------------------------------------------------
-- Purpose : Test bench to test out the EASY microcontroller through
--           the TIC interface.
-- 
-- -----------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

library Chip;
use     Chip.all;

library tbench;
use     tbench.all;

entity tb_tic is
end tb_tic ;

architecture test of tb_tic is


  component easy
    port(
         XCLKIN     : in     std_logic;
         XnGBE      : in     std_logic;
         Reset      : in     std_logic;
         XWAIT      : in     std_logic;

         XD         : inout  std_logic_vector(31 downto 0);

         XA         : out    std_logic_vector(30 downto 0);
         XCLK       : out    std_logic;
         XCSN       : out    std_logic_vector(7 downto 0);
         XOEN       : out    std_logic;
         XWEN       : out    std_ulogic_vector(3 downto 0);

         TREQA     : in     std_ulogic; -- TIC Interface
         TREQB     : in     std_ulogic;
         TACK      : out    std_ulogic;

         nTRST     : in     std_ulogic;                     -- JTAG connections
         TCK       : in     std_logic;            
         TDI       : in     std_logic;
         TMS       : in     std_logic;
         TDO       : out    std_logic;
 
         REFXTAL   : in     std_ulogic

         ) ;
  end component ;

  component ticbox
    port(
         START          : in     std_ulogic;
         TCLK          : in     std_ulogic;
         TACK          : in     std_ulogic;
         
         TBUS          : inout  std_logic_vector( 31 downto 0 ) ;

         TREQA         : out    std_ulogic;
         TREQB         : out    std_ulogic
         ) ;
  end component ;

  signal XCLKIN      : std_logic;
  signal XnGBE       : std_logic;
  signal Reset      : std_logic;
  signal nReset     : std_logic;
  signal XWAIT      : std_logic;

  signal XD         : std_logic_vector(31 downto 0);

  signal XA          : std_logic_vector(30 downto 0);
  signal XCLK        : std_logic;
  signal XCSN        : std_logic_vector(7 downto 0);
  signal XOEN        : std_logic;
  signal XWEN        : std_ulogic_vector(3 downto 0);

  signal TREQA      : std_logic; -- TIC Interface
  signal TREQB      : std_logic;
  signal TACK       : std_logic;

  signal nTRST      : std_ulogic;           -- JTAG connections
  signal TCK        : std_logic;           
  signal TDI        : std_logic;
  signal TMS        : std_logic;
  signal TDO        : std_logic;
  
----------------------------------------
-- EASY related connections
----------------------------------------
  signal REFXTAL    : std_ulogic;
 
  signal START      :std_ulogic;

  constant  period    : time := 100 ns;
  constant  PhaseTime : time := period/2 ;
  constant  ApplyTime : time := 1.3*PhaseTime ;
  constant  REFXTALperiod   : time := 100 ns;

begin

  u_easy : easy
    port map(
             XCLKIN     => XCLKIN,
             XnGBE      => XnGBE,
             Reset      => Reset,
             XWAIT      => XWAIT,

             XD         => XD,

             XA         => XA,
             XCLK       => XCLK,
             XCSN       => XCSN,
             XOEN       => XOEN,
             XWEN       => XWEN,

             TREQA      => TREQA,
             TREQB      => TREQB,
             TACK       => TACK,
            
             nTRST      => nTRST,
             TCK        => TCK,
             TDI        => TDI,
             TMS        => TMS,
             TDO        => TDO,

             REFXTAL    => REFXTAL

             ) ;

  XnGBE <= '0';
  XWAIT <= '0' ;                         -- no external waits

    u_ticbox : ticbox
    port map(
             START,  
             TCLK      => XCLK,
             TACK      => TACK,
             TBUS      => XD,
             TREQA     => TREQA,
             TREQB     => TREQB
             ) ;

  ClockGen : process
  begin
    XCLKIN <= '0';
    wait for PhaseTime ;
    XCLKIN <= '1';
    wait for PhaseTime ;
  end process ClockGen ;

  p_REFXTAL : process
    constant REFXTALPhaseTime : time := REFXTALperiod/2 ;
  begin
    REFXTAL <= '0' ;
    wait for REFXTALPhaseTime ;
    REFXTAL <= '1' ;
    wait for REFXTALPhaseTime ;
  end process p_REFXTAL ;

  nReset <= not Reset;

  Stimulus : process

  variable Dbv    : bit_vector(31 downto 0);
  variable hexstring : string(1 to 8);

  begin
    Reset <= '0' ;
    START <= '0' ;
    for i in 1 to 4 loop
      wait on XCLK ;
    end loop ;
    Reset <= '1' ;
    for i in 1 to 20 loop
      wait on XCLK ;
    end loop ;
    Reset <= '0' ;
      wait for period + ApplyTime;   -- To apply signals on the low phase of BCLK;
    START <= '1';
    wait for period;
    wait until ((XCLK'event and XCLK='1') and TREQA ='0' and TREQB = '0' and TACK = '0');
    START <= '0';
    assert false report "Test sequence completed" severity failure;
    end process Stimulus;      
  
end test ;

-- --================================= End ===================================--
