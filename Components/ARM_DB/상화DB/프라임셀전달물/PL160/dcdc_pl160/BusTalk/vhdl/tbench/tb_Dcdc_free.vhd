-- --=========================================================================--
-- This confidential and proprietary software may be used only
-- as authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1999 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised copies
-- and copies may only be made to the extent permitted by a
-- licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
-- Version and Release Control Information:
--
-- File Name              : tb_Dcdc_free.vhd,v
-- File Revision          : 1.3
--
-- Release Information    : PL160-REL1v1
--
-- --=========================================================================--

-- -----------------------------------------------------------------------------
--   Purpose : Top level instantiating the APB Slave Test 
--             Bench and the Dcdc module.    
-- -----------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

library tbench;

library common;

library uut;
-- use uut.all;

entity tb_Dcdc_free is
end tb_Dcdc_free;

architecture test of tb_Dcdc_free is

  component apbslave_tb
  generic
         (
          PRDATA_mask                : string;
	  INFILE                 : string;
          Verbosity              : integer;
          HaltOnMismatch         : integer;
          tclkl                  : integer;
          tclkh                  : integer
          );
  port(
       BnRES       : out std_logic;
       BCLK        : out std_logic;
       PADDR       : out std_logic_vector(31 downto 0);
       PWRITE      : out std_logic;
       PENABLE     : out std_logic;
       PSEL        : out std_logic; 
       PWDATA      : out std_logic_vector(31 downto 0);
       PRDATA      : in  std_logic_vector(31 downto 0);
       VRG0        : inout std_logic_vector(31 downto 0);
       VRG1        : inout std_logic_vector(31 downto 0);
       VRG2        : inout std_logic_vector(31 downto 0);
       VRG3        : inout std_logic_vector(31 downto 0);
       VRG4        : inout std_logic_vector(31 downto 0);
       VRG5        : inout std_logic_vector(31 downto 0);
       VRG6        : inout std_logic_vector(31 downto 0);
       VRG7        : inout std_logic_vector(31 downto 0)
       );
  end  component;

--  UUT instantiation comes here

  component  Dcdc
  port (

       --  The following signals are compulsory on an APB slave:

        DCDCCLK       : in     std_logic; 
        PCLK          : in     std_logic;
	SCANMODE      : in     std_logic;
        BnRES         : in     std_logic;
        nDCDCRST      : in     std_logic;
        PSEL          : in     std_logic;
        PENABLE       : in     std_logic;
        PWRITE        : in     std_logic;
	
        PADDR         : in     std_logic_vector(7 downto 2);   
        PWDATA        : in     std_logic_vector(7 downto 0);

        DCDCDRIVE1IN  : in     std_logic;
        DCDCDRIVE0IN  : in     std_logic;
        DCDCFB1       : in     std_logic;
        DCDCFB0       : in     std_logic;
        DCDCDR1SEL    : in     std_logic;
        DCDCDR0SEL    : in     std_logic;
            
        PRDATA        : out    std_logic_vector(7 downto 0);
        DCDCDRIVEOE   : out    std_logic;
        DCDCDRIVE1OUT : out    std_logic;
        DCDCDRIVE0OUT : out    std_logic
      ) ;
  end  component;

  signal BCLK         : std_logic;
  signal DCDCCLK      : std_logic;
  signal SCANMODE     : std_logic;
  signal BnRES        : std_logic;
  signal nDCDCRST     : std_logic;
  signal nDCDCRSTint  : std_logic;
  signal PADDR        : std_logic_vector(31 downto 0);
  signal PWRITE       : std_logic;
  signal PENABLE      : std_logic;
  signal PSEL         : std_logic; 
  signal PWDATA       : std_logic_vector(31 downto 0);
  signal PRDATA       : std_logic_vector(31 downto 0) := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
  signal PRDATA0      : std_logic_vector(31 downto 0) := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

  signal VRG0         : std_logic_vector(31 downto 0);
  signal VRG1         : std_logic_vector(31 downto 0);  
  signal VRG2         : std_logic_vector(31 downto 0);
  signal VRG3         : std_logic_vector(31 downto 0);
  signal VRG4         : std_logic_vector(31 downto 0);
  signal VRG5         : std_logic_vector(31 downto 0);
  signal VRG6         : std_logic_vector(31 downto 0);
  signal VRG7         : std_logic_vector(31 downto 0);


-- DCDC SIGNAL Declarations.
  
  signal DCDCDRIVE1IN    : std_logic ;
  signal DCDCDRIVE0IN    : std_logic ;
  signal DCDCFB1         : std_logic ;
  signal DCDCFB0         : std_logic ;
  signal DCDCDR1SEL      : std_logic ;
  signal DCDCDR0SEL      : std_logic ;
  signal DCDCDRIVEOE     : std_logic;
  signal DCDCDRIVE1OUT   : std_logic;
  signal DCDCDRIVE0OUT   : std_logic;
  signal PRDATADCDC      : std_logic_vector(7 downto 0);

  constant DCDCCLKPeriod     : integer := 40;
  constant DCDCCLKPhase_time : time    := (DCDCCLKPeriod/2) * 1 ns;

  
begin
    
    nDCDCRST                <= nDCDCRSTint;
    SCANMODE                <= '0';

--  Non-AMBA inputs/outputs connected to Virtual registers (VR); In the example
--  config.h we've defined R0 and R1 as outputs and R2 and R3 as inputs.
--  What follows is just a connection example:

    DCDCDRIVE0IN            <= VRG0 (0);              --  R0 bit 0
    DCDCDRIVE1IN            <= VRG0 (1);              --  R0 bit 1
    DCDCFB0                 <= VRG1 (0);              --  R1 bit 0
    DCDCFB1                 <= VRG1 (1);              --  R1 bit 1
    DCDCDR0SEL              <= VRG2 (0);              --  R2 bit 0
    DCDCDR1SEL              <= VRG2 (1);              --  R2 bit 0

    
    VRG3 (0)                <= DCDCDRIVE0OUT;             --  R3 bit 0
    VRG3 (1)                <= DCDCDRIVE1OUT;             --  R3 bit 1
    VRG3 (2)                <= DCDCDRIVEOE;               --  R3 bit 2

--  All the unconnected Virtual Register inputs should be set to zero:

    VRG3 (31 downto 3) <= (others => '0');
    VRG4 (31 downto 0) <= (others => '0');
    VRG5 (31 downto 0) <= (others => '0');
    VRG6 (31 downto 0) <= (others => '0');
    VRG7 (31 downto 0) <= (others => '0');

  -- create nDCDCRST by synchronizing BnRES
  process (DCDCCLK, BnRES)
  begin 
    if (BnRES = '0') then
      nDCDCRSTint <= '0';
    elsif (DCDCCLK'event and DCDCCLK = '1') then
      nDCDCRSTint <= BnRES;
    end if;
  end process;


  -- purpose: Generates the Free Running DCDC CLK'
  p_DCDCCLKGen : process
  begin  -- process p_DCDCCLKGen
    DCDCCLK <= '0';
    wait for DCDCCLKPhase_time;
    DCDCCLK <= '1';
    wait for DCDCCLKPhase_time;
  end process p_DCDCCLKGen;

    
  u_apbslv_tb : apbslave_tb 
    generic map (PRDATA_mask => "FFFFFFFF",
                 INFILE => "infile.bif",
                 Verbosity => 0,
                 HaltOnMismatch => 0,
                 tclkl => 10,
                 tclkh => 10
                )
  port map ( 
            BnRES       => BnRES,
            BCLK        => BCLK,
            PADDR       => PADDR,
            PWRITE      => PWRITE,
            PENABLE     => PENABLE,
            PSEL        => PSEL,
            PRDATA      => PRDATA0,
            PWDATA      => PWDATA,            
            VRG0        => VRG0,
            VRG1        => VRG1,
            VRG2        => VRG2,
            VRG3        => VRG3,
            VRG4        => VRG4,
            VRG5        => VRG5,
            VRG6        => VRG6,
            VRG7        => VRG7
           );

  u_Dcdc : Dcdc  
  port map (
            DCDCCLK       => DCDCCLK,
            PCLK          => BCLK,
            BnRES         => BnRES,
            nDCDCRST      => nDCDCRST,
	    SCANMODE      => SCANMODE,
            PSEL          => PSEL,
            PENABLE       => PENABLE,
            PWRITE        => PWRITE,
            PADDR         => PADDR(7 downto 2),  --(7 downto 2),   
            PWDATA        => PWDATA(7 downto 0),
            DCDCDRIVE0IN  => DCDCDRIVE0IN, 
            DCDCDRIVE1IN  => DCDCDRIVE1IN, 
            DCDCFB0       => DCDCFB0, 
            DCDCFB1       => DCDCFB1, 
            DCDCDR0SEL    => DCDCDR0SEL, 
            DCDCDR1SEL    => DCDCDR1SEL, 
            PRDATA        => PRDATADCDC,
            DCDCDRIVE0OUT => DCDCDRIVE0OUT, 
            DCDCDRIVE1OUT => DCDCDRIVE1OUT, 
            DCDCDRIVEOE   => DCDCDRIVEOE 
           );
      

   PRDATA0 <= "000000000000000000000000" & PRDATADCDC;
end test;

-- --================================= End ===================================--
