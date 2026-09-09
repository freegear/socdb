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
-- File Name              : easy.vhd,v
-- File Revision          : 1.2
-- 
-- Release Information    : PL160-REL1v1
--  
-- --=========================================================================--

-- -----------------------------------------------------------------------------
-- Purpose : Structural architecture of Example Amba SYstem (EASY).
-- 
-- -----------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

library sys ;
use     sys.all ;

library chip;
use     chip.all;

entity easy is
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

       TREQA      : in     std_ulogic; -- TIC Interface
       TREQB      : in     std_ulogic;
       TACK       : out    std_ulogic;

       nTRST      : in     std_logic;
       TCK        : in     std_logic;            -- JTAG connections
       TDI        : in     std_logic;
       TMS        : in     std_logic;
       TDO        : out    std_logic;

       REFXTAL    : in     std_ulogic          
       ) ;

end easy ;

architecture Structural of easy is

  -- The ASB master arbiter
  component arbiter
    port
    (
     AREQARM       : in     std_ulogic;
     AREQtic       : in     std_ulogic;
     AREQ001       : in     std_ulogic;
     AREQ002       : in     std_ulogic;

     BCLK          : in     std_ulogic; 
     BnRES         : in     std_ulogic;
     Pause         : in     std_ulogic;
     
     BWAIT         : in     std_logic;
     BLOK          : in     std_logic;

     AGNTARM       : out    std_ulogic ;
     AGNTTic       : out    std_ulogic; 
     AGNT001       : out    std_ulogic;
     AGNT002       : out    std_ulogic
    );
  end component;

  -- The ASB decoder with/without decode cycles (comment out the component to be used)
  component decoder
--  component decoder_mindec
  port
    (
     BCLK         : in     std_ulogic;
     BTRAN        : in     std_logic_vector(1 downto 0);
--  comment out BSIZE when using component decoder_mindec
     BSIZE        : in     std_logic_vector(1 downto 0);
     BnRES        : in     std_ulogic;
     BA           : in     std_logic_vector(31 downto 0);
     Remap        : in     std_ulogic ;

     BWAIT        : inout  std_logic ;
     BLAST        : inout  std_logic ;
     BERROR       : inout  std_logic ;

     DSELIntMem   : out    std_ulogic ;
     DSELExtMem   : out    std_ulogic ;
     DSELIntCn    : out    std_ulogic ;
     DSELPeri     : out    std_ulogic ;
     DSELARMTest  : out    std_ulogic 
     );
  end component;

  -- The bus mode controller
  component res_cntl
    port
    (
       BCLK     : in    std_ulogic;

       POReset   : in    std_ulogic;

       BnRES     : out   std_ulogic
     );
  end component;

  -- The test interface controller
  component tic
  port(
       AGNTtic        : in    std_ulogic ;
       BCLK           : in    std_ulogic ;
       BD             : in    std_logic_vector( 31 downto 0 ) ;
       BnRES          : in    std_ulogic;
       BWAIT          : in    std_logic;
       BERROR         : in    std_logic;
       BLAST          : in    std_logic;
       TREQA          : in    std_ulogic ;
       TREQB          : in    std_ulogic ;

       AREQtic        : out  std_ulogic := '0';
       TACK           : out  std_ulogic;
       TestMode       : out  std_ulogic;
       TicoutLen      : out  std_ulogic;
       Ticouten       : out  std_ulogic;
       Ticinen        : out  std_ulogic;
       BA             : out  std_logic_vector( 31 downto 0 ) ;
       BTRAN          : out  std_logic_vector(1 downto 0);
       BLOK           : inout   std_logic;
       BSIZE          : out   std_logic_vector(1 downto 0);
       BPROT          : out   std_logic_vector(1 downto 0);
       BWRITE         : out   std_logic
       ) ;
  end component;

  --  An example External Bus Interface
  component SMI 
  port(
       -- AMBA signals
       BnRES        : in     std_ulogic;

       BWRITE       : in     std_logic;
       BSIZE        : in     std_logic_vector(1 downto 0);
       BA           : in     std_logic_vector(30 downto 0);
       DSEL         : in     std_ulogic;
       Remap        : in     std_ulogic;
       TestMode     : in     std_ulogic; 
       Ticinen      : in     std_ulogic;
       Ticouten     : in     std_ulogic; 
       TicoutLen    : in     std_ulogic; 

       BD          : inout  std_logic_vector(31 downto 0);

       BWAIT       : inout  std_logic;
       BLAST       : inout  std_logic;
       BERROR      : inout  std_logic;

       -- AMBA clock
       BCLK        : in     std_ulogic;

       -- external signals
       XWAIT        : in     std_logic;
       XnGBE        : in     std_logic;
       
       XA           : out    std_logic_vector(30 downto 0);
       XD           : inout  std_logic_vector(31 downto 0);
       XCLK         : out    std_logic;
       XCSN         : out    std_logic_vector(7 downto 0);
       XWEN         : out    std_ulogic_vector(3 downto 0);
       XOEN         : out    std_logic       
       ) ;
  end component;

  -- On-chip clock driver 
  component pll 
  port(
       XCLKIN       : in     std_logic;   -- external clock input
       BCLK         : out    std_ulogic
       );
  end component;

  -- The AMBA peripheral bus bridge, interrupt controller, reset controller and
  -- free running counter.
  component rps
  port(
         BCLK     : in     std_ulogic;
         BnRES    : in     std_ulogic;
	 Pause    : out    std_ulogic;
	 ReMap    : out    std_ulogic;

         PRDATA      : out    std_ulogic_vector(31 downto 0);
         PWDATA      : in     std_ulogic_vector(31 downto 0);

         PA          : in    std_ulogic_vector(15 downto 0); 
         PWRITE      : in    std_ulogic;
         PSTB        : in    std_ulogic;
           
         PSELRPC     : in    std_ulogic; -- Reset & Halt
         PSELIC      : in    std_ulogic; -- Interrupt Controllers  
         PSELUUT     : in    std_ulogic; -- Unit Under Test

          -- Peripheral Reference Clock
         REFCLK      : in    std_ulogic

       ) ;
  end component ;

  -- The APB bridge
  component apbif     
     port (
           BCLK     	: in     std_ulogic;
           BA       	: in     std_logic_vector(31 downto 0);
           BnRES     	: in     std_ulogic;
           BWRITE   	: in     std_logic;
           DSEL     	: in     std_ulogic;

           BD       	: inout  std_logic_vector(31 downto 0);
           PRDATA       : in     std_ulogic_vector(31 downto 0);
           PWDATA       : out    std_ulogic_vector(31 downto 0);

           BWAIT    	: out    std_logic;
           BERROR   	: out    std_logic;
           BLAST    	: out    std_logic;
           
           PA       	: out    std_ulogic_vector(15 downto 0); 
           PWRITE   	: out    std_ulogic;
           PSTB     	: out    std_ulogic;
           
           PSELRPC      : out    std_ulogic; -- Reset & Halt
           PSELIC       : out    std_ulogic; -- Interrupt Controllers
           PSELUUT      : out    std_ulogic  -- Unit Under Test
           );
  end component;
  
  -- AMBA buswatcher
  component amba_buswatch
    port(
         AGNTARM   :  in    std_ulogic;
         AREQARM   :  in    std_ulogic;
       
         BA        :  in    std_logic_vector(31 downto 0);
         BCLK      :  in    std_ulogic;
         BD        :  in    std_logic_vector(31 downto 0);
         BERROR    :  in    std_logic;
         BLAST     :  in    std_logic;
         BLOK      :  in    std_logic;
         BPROT     :  in    std_logic_vector(1 downto 0);
         BnRES     :  in    std_ulogic;
         BSIZE     :  in    std_logic_vector(1 downto 0);
         BTRAN     :  in    std_logic_vector(1 downto 0);
         BWAIT     :  in    std_logic;
         BWRITE    :  in    std_logic;

         DSELAPB   :  in    std_ulogic
         );
  end component;

-------------------------------------------------------------------------------
--  Signal declarations
-------------------------------------------------------------------------------

----------------------------------------
-- Arbiter Signals
----------------------------------------
  signal AGNTARM   : std_ulogic;
  signal AGNT001   : std_ulogic;
  signal AGNT002   : std_ulogic;
  signal AGNTtic   : std_ulogic;
  signal AREQARM   : std_ulogic;
  signal AREQ001   : std_ulogic;
  signal AREQ002   : std_ulogic;
  signal AREQtic   : std_ulogic;
  
----------------------------------------
-- ASB Signals
----------------------------------------
  signal BCLK      : std_ulogic ;
  signal BERROR    : std_logic ;
  signal BLAST     : std_logic ;
  signal BnRES     : std_ulogic;
  signal BWAIT     : std_logic ;

  signal BA        : std_logic_vector( 31 downto 0 ) ;
  signal BD        : std_logic_vector( 31 downto 0 ) ;

  signal BTRAN     : std_logic_vector( 1 downto 0 ) ;
  signal BLOK      : std_logic;
  signal BPROT     : std_logic_vector(1 downto 0);
  signal BSIZE     : std_logic_vector(1 downto 0);
  signal BWRITE    : std_logic ;

  -- Signal enumerations for legibility
  signal B_RES_S    : RES_S ;
  signal B_SIZE_S   : SIZE_S ;
  signal B_TRAN_S   : TRAN_S ;

----------------------------------------
--  Decoder Signals
----------------------------------------
  signal DSELExtMem  : std_ulogic ;
  signal DSELIntMem  : std_ulogic ;
  signal DSELIntCn   : std_ulogic ;
  signal DSELARMTest : std_ulogic ;
  signal DSELPeri    : std_ulogic ;
  
----------------------------------------
-- Example System Signals
----------------------------------------  
  signal TestMode      : std_ulogic ;
  signal TicoutLen     : std_ulogic ;
  signal Ticouten      : std_ulogic ;
  signal Ticinen       : std_ulogic ;

  signal Pause         : std_ulogic;
  signal ReMap         : std_ulogic;

----------------------------------------
-- APB Signals
----------------------------------------
  signal PWDATA        : std_ulogic_vector(31 downto 0);
  signal PRDATA        : std_ulogic_vector(31 downto 0);

  signal PA            : std_ulogic_vector(15 downto 0);
  signal PWRITE        : std_ulogic;
  signal PSTB          : std_ulogic;
  signal PSELRPC       : std_ulogic;
  signal PSELUUT       : std_ulogic;
  signal PSELIC        : std_ulogic;
  
  signal REFCLK        : std_ulogic;
  signal Pulldown      : std_ulogic; -- To tie unused inputs low
  signal Pulldown8     : std_ulogic_vector(7 downto 0);
 

begin
-------------------------------------------------------------------------------
-- The AMBA world
-------------------------------------------------------------------------------

  Pulldown  <= '0';
  Pulldown8 <= (others => '0');
  REFCLK    <= REFXTAL;

  u_smi : SMI
    port map(
             -- AMBA signals
             BnRES        => BnRES,
             BWRITE       => BWRITE,
             BSIZE        => BSIZE,
             BA           => BA(30 downto 0),
             DSEL         => DSELExtMem,
             Remap        => Remap,
             TestMode     => TestMode,
             Ticinen      => Ticinen,
             Ticouten     => Ticouten,
             TicoutLen    => TicoutLen,
             
             BD           => BD,

             BWAIT        => BWAIT,
             BLAST        => BLAST,
             BERROR       => BERROR,

             -- AMBA clock
             BCLK         => BCLK,

             -- external signals
             XWAIT        => XWAIT,
             XnGBE        => XnGBE,
       
             XA           => XA,
             XD           => XD,
             XCLK         => XCLK,
             XCSN         => XCSN,
             XWEN         => XWEN,
             XOEN         => XOEN
             );

  u_pll : pll
    port map (
              XCLKIN       => XCLKIN,
              BCLK         => BCLK
              );

  u_arb : arbiter
    port map (
              AREQARM        => AREQARM,
              AREQtic        => AREQtic,
              AREQ001        => AREQ001,
              AREQ002        => AREQ002,

              BCLK           => BCLK,
              BnRES          => BnRES,
              Pause          => Pause,
              
              BWAIT          => BWAIT,
              BLOK           => BLOK,

              AGNTARM        => AGNTARM,
              AGNTtic        => AGNTtic,
              AGNT001        => AGNT001,
              AGNT002        => AGNT002
              );

  AREQARM <= '0';
  AREQ001 <= '0';
  AREQ002 <= '0';
  
  u_dec : decoder
    port map (
              BA               => BA,
              BCLK             => BCLK,
              BERROR           => BERROR,
              BLAST            => BLAST,
              BnRES            => BnRES,
              BTRAN            => BTRAN,
              BSIZE            => BSIZE,
              BWAIT            => BWAIT,

              Remap            => Remap,

              DSELARMTest      => DSELARMTest,
              DSELIntMem       => DSELIntMem,
              DSELExtMem       => DSELExtMem,
              DSELIntCn        => DSELIntCn,
              DSELPeri         => DSELPeri
              );
  
  u_res_cntl : res_cntl
    port map (
              BCLK    => BCLK,
              POReset  => Reset,
              BnRES    => BnRES
              );

  u_tic : tic
    port map(
             AGNTtic       => AGNTtic,
             BCLK          => BCLK,
             BD            => BD,
             BnRES         => BnRES,
             BWAIT         => BWAIT,
             BERROR        => BERROR,
             BLAST         => BLAST,
             TREQA         => TREQA,
             TREQB         => TREQB,

             AREQtic       => AREQtic,
             TACK          => TACK,
             TestMode       => TestMode,
             TicoutLen      => TicoutLen,
             Ticouten       => Ticouten,
             Ticinen        => Ticinen,
             BA            => BA,
             BTRAN         => BTRAN,
             BLOK         => BLOK,
             BSIZE         => BSIZE,
             BPROT         => BPROT,
             BWRITE        => BWRITE
             );

  u_rps : rps
     port map (
               BCLK     => BCLK,

               BnRES     => BnRES,

               Pause     => Pause,
               ReMap     => ReMap,

               PRDATA   => PRDATA,
               PWDATA   => PWDATA,

               PA        => PA,
               PWRITE    => PWRITE,
               PSTB      => PSTB,  

               PSELRPC   => PSELRPC,
               PSELIC    => PSELIC,
               PSELUUT   => PSELUUT,
             
               REFCLK    => REFCLK
          ) ;

Bridge : apbif
     port map (
               BCLK     	=> BCLK,

               BA       	=> BA,
               BnRES     	=> BnRES,
               BWRITE   	=> BWRITE,

               DSEL     	=> DSELPeri,

               BD       	=> BD,
               PRDATA           => PRDATA,
               PWDATA           => PWDATA,


               BWAIT    	=> BWAIT,
               BERROR   	=> BERROR,
               BLAST    	=> BLAST,

               PA       	=> PA,
               PWRITE   	=> PWRITE,
               PSTB     	=> PSTB,  

               PSELRPC    	=> PSELRPC,
               PSELIC     	=> PSELIC,
               PSELUUT          => PSELUUT
               );

-------------------------------------------------------------------------------
-- Simulation tools (not intended to represent physical hardware)
-------------------------------------------------------------------------------

  u_amba_buswatch : amba_buswatch
    port map(
             AGNTARM   => AGNTARM,
             AREQARM   => AREQARM,
       
             BA        => BA,
             BCLK      => BCLK,
             BD        => BD,
             BERROR    => BERROR,
             BLAST     => BLAST,
             BLOK      => BLOK,
             BPROT     => BPROT,
             BnRES     => BnRES,
             BSIZE     => BSIZE,
             BTRAN     => BTRAN,
             BWAIT     => BWAIT,
             BWRITE    => BWRITE,

             DSELAPB   => DSELPeri
             );
 
  -----------------------------------------------------------------------------
  --  debugging aids - translate bus values to symbols
  -----------------------------------------------------------------------------

  B_TRAN_S  <= To_TRAN_S( BTRAN );
  B_SIZE_S  <= To_SIZE_S( BSIZE );
   
end Structural ;

-- --================================= End ===================================--
