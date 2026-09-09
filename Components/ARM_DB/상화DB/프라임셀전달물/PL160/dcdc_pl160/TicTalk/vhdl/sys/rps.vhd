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
-- File Name              : rps.vhd,v
-- File Revision          : 1.2
--  
-- Release Information    : PL160-REL1v1
--  
-- --=========================================================================--

-- -----------------------------------------------------------------------------
-- Purpose : Reference Peripheral instantiations
-- 
-- -----------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

--#Synth off
library common;
use     common.params.all;
--#Synth on

library sys;
use     sys.all;

library uut;
use     uut.all;

entity rps is
    port(
         BCLK     : in     std_ulogic;
         BnRES    : in     std_ulogic;
         Pause    : out    std_ulogic;
         ReMap    : out    std_ulogic;

         PRDATA   : out    std_ulogic_vector(31 downto 0);
         PWDATA   : in     std_ulogic_vector(31 downto 0);

         PA       : in    std_ulogic_vector(15 downto 0); 
         PWRITE   : in    std_ulogic;
         PSTB     : in    std_ulogic;
           
         PSELRPC  : in    std_ulogic; -- Reset & Halt
         PSELIC   : in    std_ulogic; -- Interrupt Controllers         

         PSELUUT  : in    std_ulogic; -- Unit Under Test

          -- Peripheral Reference Clock
         REFCLK   : in    std_ulogic

         ) ;

end rps ;

architecture Structural of rps is

  -- The reset/pause controller
 component rem_pause
    port(
         BnRES      : in     std_ulogic;

         PWRITE     : in     std_ulogic;
         PSEL       : in     std_ulogic ;
         PSTB       : in     std_ulogic;
         PA         : in     std_ulogic_vector(5 downto 0); 

         NFIQ        : in     std_ulogic;
         NIRQ        : in     std_ulogic;

         PWDATA      : in     std_ulogic_vector(15 downto 0);
         PRDATA      : out    std_ulogic_vector(15 downto 0);

         Pause       : out    std_ulogic ;
         ReMap       : out    std_ulogic
         );
   end component;


  component  Dcdc
  port (

       --  The following signals are compulsory on an APB slave:

        DCDCCLK        : in     std_logic; 
        PCLK           : in     std_logic;
	SCANMODE       : in     std_logic;
        BnRES          : in     std_logic;
        nDCDCRST       : in     std_logic;
        PSEL           : in     std_logic;
        PENABLE        : in     std_logic;
        PWRITE         : in     std_logic;
	
        PADDR          : in     std_logic_vector(7 downto 2);   
        PWDATA         : in     std_logic_vector(7 downto 0);

        DCDCDRIVE1IN   : in     std_logic;
        DCDCDRIVE0IN   : in     std_logic;
        DCDCFB1        : in     std_logic;
        DCDCFB0        : in     std_logic;
        DCDCDR1SEL     : in     std_logic;
        DCDCDR0SEL     : in     std_logic;
            
        PRDATA         : out    std_logic_vector(7 downto 0);
        DCDCDRIVEOE    : out    std_logic;
        DCDCDRIVE1OUT  : out    std_logic;
        DCDCDRIVE0OUT  : out    std_logic
      ) ;
  end  component;


  component APBMux
    port (
          PRDATA      : out    std_ulogic_vector(31 downto 0);

          PWRITE      : in    std_ulogic;

          PSELRPC     : in    std_ulogic; -- Reset & Halt
          PSELUUT     : in    std_ulogic; -- Unit Under Test

          PRDATARPC   : in    std_ulogic_vector(15 downto 0);
          PRDATAUUT   : in    std_ulogic_vector(31 downto 0)

          ) ;

  end component;

-------------------------------------------------------------------------------

----------------------------------------
-- RMC System Signals
----------------------------------------  
  signal NFIQ_Local    : std_logic;
  signal NIRQ_Local    : std_logic;
  signal RTCINT        : std_ulogic;
  
  signal PRDATARPC     : std_ulogic_vector(15 downto 0) ;
  signal PRDATAUUT     : std_ulogic_vector(31 downto 0) ;
  signal ReadFill      : std_ulogic_vector(31 downto 0) ;
  signal VSS           : std_ulogic;

----------------------------------------
-- DCDC Signals
----------------------------------------  
  signal PRDATADCDC    : std_logic_vector(7 downto 0) ;
  signal DCDCDRIVE0IN  : std_logic := '1';
  signal DCDCDRIVE1IN  : std_logic := '1'; 
  signal DCDCFB1       : std_logic:= '0';
  signal DCDCFB0       : std_logic:= '0';
  signal DCDCDR1SEL    : std_logic:= '0';
  signal DCDCDR0SEL    : std_logic:= '0';
  signal DCDCDRIVEOE   : std_logic;
  signal DCDCDRIVE1OUT : std_logic;
  signal DCDCDRIVE0OUT : std_logic;
  signal SCANMODE      : std_logic := '0';
  signal nDCDCRST      : std_logic;
  signal nDCDCRSTint   : std_logic;
 
  signal PENABLE       : std_ulogic;

begin


  VSS <= '0';
  ReadFill <= (others => '0');

  NFIQ_Local <= '1';
  NIRQ_Local <= '1';


-------------------------------------------------------------------------------
-- The APB world
-------------------------------------------------------------------------------

u_resreg  : rem_pause
    port map (
              BnRES         => BnRES,

              PWRITE        => PWRITE,
              PSEL          => PSELRPC,
              PSTB          => PSTB,
              PA            => PA(5 downto 0),

              NFIQ          => NFIQ_Local,
              NIRQ          => NIRQ_Local,

              PRDATA        => PRDATARPC(15 downto 0),
              PWDATA        => PWDATA(15 downto 0),

              Pause         => Pause,
              ReMap         => ReMap
              ) ;

 -- convert PSTB to PENABLE
 process (BCLK, BnRES)
 begin
   if (BnRES = '0') then
     PENABLE <= '0';
   elsif (BCLK'event and BCLK = '1') then
     PENABLE <= PSTB;
   end if;
 end process;

  
 -- create nDCDCRST by synchronizing BnRES
 process (BCLK, BnRES)
 begin
   if (BnRES = '0') then
     nDCDCRST    <= '0';
     nDCDCRSTint <= '0';
   elsif (BCLK'event and BCLK = '1') then
     nDCDCRSTint <= BnRES;
     nDCDCRST    <= nDCDCRSTint;
   end if;
 end process;


-- Drive DCDC DRIVE SIGNALS LOW AT END OF RESET
-- process (BnRES,BCLK)
    
-- begin  -- process
--     if (BnRES = '1') then
--        DCDCDRIVE1IN    <= '0' after 50 ns;
--        DCDCDRIVE0IN    <= '0' after 50 ns;
--        DCDCFB1         <= '0' after 50 ns;
--        DCDCFB0         <= '0' after 50 ns;
--        DCDCDR1SEL      <= '0' after 50 ns;
--        DCDCDR0SEL      <= '0' after 50 ns;
--        SCANMODE        <= '0' after 50 ns;
        
--     elsif (BCLK'event and BCLK = '1') then
--        DCDCDRIVE1IN    <= '1';
--        DCDCDRIVE0IN    <= '1';
--        DCDCFB1         <= '1';
--        DCDCFB0         <= '1';
--        DCDCDR1SEL      <= '1';
--        DCDCDR0SEL      <= '1';
--        SCANMODE        <= '1';
        
--     end if;
--  end process;

  uDcdc : Dcdc  
  port map (
            DCDCCLK       => BCLK,
            PCLK          => BCLK,
            BnRES         => BnRES,
            nDCDCRST      => nDCDCRST,
	    SCANMODE      => SCANMODE,
            PSEL          => PSELUUT,
            PENABLE       => PENABLE,
            PWRITE        => PWRITE,
            PADDR         => to_stdlogicvector(PA(7 downto 2)),
            PWDATA        => to_stdlogicvector(PWDATA(7 downto 0)),
            PRDATA        => PRDATADCDC, 
            DCDCDRIVE0IN  => DCDCDRIVE0IN, 
            DCDCDRIVE1IN  => DCDCDRIVE1IN, 
            DCDCFB0       => DCDCFB0, 
            DCDCFB1       => DCDCFB1, 
            DCDCDR0SEL    => DCDCDR0SEL, 
            DCDCDR1SEL    => DCDCDR1SEL 
           );


 PRDATAUUT <= ReadFill(31 downto 8) & to_stdulogicvector(PRDATADCDC);

 uAPBMux : APBMux
   port map (     
             PRDATA      => PRDATA,
             PWRITE      => PWRITE,
             PSELRPC     => PSELRPC,
             PSELUUT     => PSELUUT,
             PRDATARPC   => PRDATARPC,
             PRDATAUUT   => PRDATAUUT
             );

end Structural ;

-- --================================= End ===================================--
