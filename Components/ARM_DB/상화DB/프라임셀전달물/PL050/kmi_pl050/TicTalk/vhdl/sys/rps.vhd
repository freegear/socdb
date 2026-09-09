--------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : rps.vhd,v
--  File Revision          : 1.2
--  
--  Release Information    : PL050-REL1v1
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose          : Reference Peripheral instantiations
--
--------------------------------------------------------------------------------

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

  component Kmi
   port (
        PCLK         : in    std_logic;
        KMIREFCLK    : in    std_logic;
        BnRES        : in    std_logic;
        nKMIRST      : in    std_logic;
        PSEL         : in    std_logic;
        PENABLE      : in    std_logic;
        PWRITE       : in    std_logic;
        PADDRH       : in    std_logic_vector(7 downto 6);
        PADDRL       : in    std_logic_vector(4 downto 2);
        PWDATA       : in    std_logic_vector(7 downto 0);
        PRDATA       : out   std_logic_vector(7 downto 0);
        SCANMODE     : in    std_logic;
        KMICLKIN     : in    std_logic;
        KMIDATAIN    : in    std_logic;
        nKMICLKEN    : out   std_logic;
        nKMIDATAEN   : out   std_logic;
        KMITXINTR    : out   std_logic;
        KMIRXINTR    : out   std_logic;
        KMIINTR      : out   std_logic
        );
  end component;

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
-- KMI Signals
----------------------------------------  
  signal PRDATAKMI     : std_logic_vector(7 downto 0) ;
  signal SCANMODE      : std_logic;
  signal nKMIRST       : std_logic;
  signal nKMIRSTint    : std_logic;
  signal KMICLKIN      : std_logic;
  signal KMIDATAIN     : std_logic;
  signal nKMICLKEN     : std_logic;
  signal nKMIDATAEN    : std_logic;
  signal KMITXINTR     : std_logic;
  signal KMIRXINTR     : std_logic;
  signal KMIINTR       : std_logic;

  signal PENABLE       : std_logic;

begin


  VSS <= '0';
  SCANMODE <= '0';
  ReadFill <= (others => '0');

  NFIQ_Local <= '1';
  NIRQ_Local <= '1';

  KMICLKIN  <= '1';
  KMIDATAIN <= '1';

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
  
 -- create nKMIRST by synchronizing BnRES
 process (BCLK, BnRES)
 begin
   if (BnRES = '0') then
     nKMIRST    <= '0';
     nKMIRSTint <= '0';
   elsif (BCLK'event and BCLK = '1') then
     nKMIRSTint <= BnRES;
     nKMIRST    <= nKMIRSTint;
   end if;
 end process;
  

 uKmi : Kmi 
    port map (
              BnRES       => BnRES,
              PCLK        => BCLK,
              SCANMODE    => SCANMODE,
              nKMIRST     => nKMIRST,
              PADDRH      => to_stdlogicvector(PA(7 downto 6)),
              PADDRL      => to_stdlogicvector(PA(4 downto 2)),
              PRDATA      => PRDATAKMI,
              PWDATA      => to_stdlogicvector(PWDATA(7 downto 0)),
              PSEL        => PSELUUT,
              PENABLE     => PENABLE, 
              PWRITE      => PWRITE,
              KMIREFCLK   => BCLK,  -- (KMIREFCLK needs to be connected to BCLK
              KMICLKIN    => KMICLKIN, 
              KMIDATAIN   => KMIDATAIN,
              nKMICLKEN   => nKMICLKEN,
              nKMIDATAEN  => nKMIDATAEN,
              KMITXINTR   => KMITXINTR,
              KMIRXINTR   => KMIRXINTR,
              KMIINTR     => KMIINTR
             );

 PRDATAUUT <= ReadFill(31 downto 8) & to_stdulogicvector(PRDATAKMI);

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
