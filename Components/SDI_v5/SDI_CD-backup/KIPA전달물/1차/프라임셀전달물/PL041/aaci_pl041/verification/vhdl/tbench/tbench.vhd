-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : tbench.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Top level of the AACI Compliance TestBench. This file 
--           instantiates the AACI module, the AACI trickbox and the 
--           Read Data Mux.
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library tbench;
use     tbench.timing.all;

library uut;

library trickbox;

entity tbench is
end tbench;

architecture test of tbench is

component apbslave_tb
generic
     (
      PRDATA_mask       : string;
      INFILE            : string;
      Verbosity         : integer;
      HaltOnMismatch    : integer;
      tclks             : time;
      tclkl             : time;
      tclkh             : time
     );
port (
      PRESETn           : out   std_logic;
      PCLK              : out   std_logic;
      PADDR             : out   std_logic_vector(31 downto 0);
      PWRITE            : out   std_logic;
      PENABLE           : out   std_logic;
      PSEL              : out   std_logic;
      PSELT             : out   std_logic;
      PWDATA            : out   std_logic_vector(31 downto 0);
      PRDATA            : in    std_logic_vector(31 downto 0);
      VRG0              : inout std_logic_vector(31 downto 0);
      VRG1              : inout std_logic_vector(31 downto 0);
      VRG2              : inout std_logic_vector(31 downto 0);
      VRG3              : inout std_logic_vector(31 downto 0);
      VRG4              : inout std_logic_vector(31 downto 0);
      VRG5              : inout std_logic_vector(31 downto 0);
      VRG6              : inout std_logic_vector(31 downto 0);
      VRG7              : inout std_logic_vector(31 downto 0)
     );
end component;

component  Aaci
port (
      -- Inputs
      PCLK              : in    std_logic;
      AACIBITCLK        : in    std_logic;
      nAACIBITCLK       : in    std_logic;
      PRESETn           : in    std_logic;
      nAACIBITCLKRST    : in    std_logic;
      nFAACIBITCLKRST   : in    std_logic;
      PSEL              : in    std_logic;
      PENABLE           : in    std_logic;
      PWRITE            : in    std_logic;
      AACIDMACLRRX      : in    std_logic;
      AACIDMACLRTX      : in    std_logic;
      SCANENABLE        : in    std_logic;
      SCANINPCLK        : in    std_logic;
      SCANINBITCLK      : in    std_logic;
      SCANINnBITCLK     : in    std_logic;
      AACISDATAIN       : in    std_logic;
      PADDR             : in    std_logic_vector(11 downto 2);
      PWDATA            : in    std_logic_vector(31 downto 0);
      AACIRESET         : out   std_logic;
      AACISYNC          : out   std_logic;
      AACITXINTR1       : out   std_logic;
      AACITXINTR2       : out   std_logic;
      AACITXINTR3       : out   std_logic;
      AACITXINTR4       : out   std_logic;
      AACIRXINTR1       : out   std_logic;
      AACIRXINTR2       : out   std_logic;
      AACIRXINTR3       : out   std_logic;
      AACIRXINTR4       : out   std_logic;
      AACIORINTR1       : out   std_logic;
      AACIORINTR2       : out   std_logic;
      AACIORINTR3       : out   std_logic;
      AACIORINTR4       : out   std_logic;
      AACIURINTR1       : out   std_logic;
      AACIURINTR2       : out   std_logic;
      AACIURINTR3       : out   std_logic;
      AACIURINTR4       : out   std_logic;
      AACITXCINTR1      : out   std_logic;
      AACITXCINTR2      : out   std_logic;
      AACITXCINTR3      : out   std_logic;
      AACITXCINTR4      : out   std_logic;
      AACIRXTOINTR1     : out   std_logic;
      AACIRXTOINTR2     : out   std_logic;
      AACIRXTOINTR3     : out   std_logic;
      AACIRXTOINTR4     : out   std_logic;
      AACIWINTR         : out   std_logic;
      AACIGPIOINTR      : out   std_logic;
      AACIS12RXINTR     : out   std_logic;
      AACIS12TXINTR     : out   std_logic;
      AACIS2RXINTR      : out   std_logic;
      AACIS2TXINTR      : out   std_logic;
      AACIS1RXINTR      : out   std_logic;
      AACIS1TXINTR      : out   std_logic;
      AACIRXTOFEINTR1   : out   std_logic;
      AACIRXTOFEINTR2   : out   std_logic;
      AACIRXTOFEINTR3   : out   std_logic;
      AACIRXTOFEINTR4   : out   std_logic;
      AACIINTR          : out   std_logic;
      AACIDMASREQRX     : out   std_logic;
      AACIDMALSREQRX    : out   std_logic;
      AACIDMABREQRX     : out   std_logic;
      AACIDMALBREQRX    : out   std_logic;
      AACIDMABREQTX     : out   std_logic;
      SCANOUTPCLK       : out   std_logic;
      SCANOUTBITCLK     : out   std_logic;
      SCANOUTnBITCLK    : out   std_logic;
      AACISDATAOUT      : out   std_logic;
      PRDATA            : out   std_logic_vector(31 downto 0)
      );
end component;

component  AaciTrick
port (
      -- APB bus signals
      PCLK              : in    std_logic;  
      PRESETn           : in    std_logic;  
      PSEL              : in    std_logic;  
      PSELCOM           : in    std_logic;  
      PENABLE           : in    std_logic; 
      PWRITE            : in    std_logic;  
      PADDR             : in    std_logic_vector(11 downto 2);
      PWDATA            : in    std_logic_vector(31 downto 0);
                                           
      AACIDMASREQRX     : in    std_logic;
      AACIDMALSREQRX    : in    std_logic;
      AACIDMABREQRX     : in    std_logic;
      AACIDMALBREQRX    : in    std_logic;
      AACIDMABREQTX     : in    std_logic;

      -- Interrupt signals
      AACIINTR          : in    std_logic;
      AACITXINTR1       : in    std_logic;
      AACITXINTR2       : in    std_logic;
      AACITXINTR3       : in    std_logic;
      AACITXINTR4       : in    std_logic;
      AACIRXINTR1       : in    std_logic;
      AACIRXINTR2       : in    std_logic;
      AACIRXINTR3       : in    std_logic;
      AACIRXINTR4       : in    std_logic;
      AACIORINTR1       : in    std_logic;
      AACIORINTR2       : in    std_logic;
      AACIORINTR3       : in    std_logic;
      AACIORINTR4       : in    std_logic;
      AACITXCINTR1      : in    std_logic;
      AACITXCINTR2      : in    std_logic;
      AACITXCINTR3      : in    std_logic;
      AACITXCINTR4      : in    std_logic;
      AACIURINTR1       : in    std_logic;
      AACIURINTR2       : in    std_logic;
      AACIURINTR3       : in    std_logic;
      AACIURINTR4       : in    std_logic;
      AACIRXTOINTR1     : in    std_logic;
      AACIRXTOINTR2     : in    std_logic;
      AACIRXTOINTR3     : in    std_logic;
      AACIRXTOINTR4     : in    std_logic;
      AACIWINTR         : in    std_logic;
      AACIGPIOINTR      : in    std_logic;
      AACIS1RXINTR      : in    std_logic;
      AACIS2RXINTR      : in    std_logic;
      AACIS12RXINTR     : in    std_logic;
      AACIS1TXINTR      : in    std_logic;
      AACIS2TXINTR      : in    std_logic;
      AACIS12TXINTR     : in    std_logic;
      AACIRXTOFEINTR1   : in    std_logic;
      AACIRXTOFEINTR2   : in    std_logic;
      AACIRXTOFEINTR3   : in    std_logic;
      AACIRXTOFEINTR4   : in    std_logic;

      -- AC LINK signals and related signals
      AACIRESET         : in    std_logic;  
      AACISYNC          : in    std_logic;  
      AACISDATAIN       : in    std_logic;  
      AACISDATAOUT      : out   std_logic;  
      AACIBITCLK        : out   std_logic;  
      AACIDMACLRRX      : out   std_logic;
      AACIDMACLRTX      : out   std_logic;
      -- Reset outputs
      nAACIBITCLKRST    : out   std_logic;  
      nFAACIBITCLKRST   : out   std_logic;  
      -- APB o/p signal
      PRDATA            : out   std_logic_vector(31 downto 0)
      );
end component;
 
component  apbmux
port (
      PCLK              : in    std_logic;
      PRESETn           : in    std_logic;
      PSEL              : in    std_logic;
      PSELT             : in    std_logic;
      PRData0           : in    std_logic_vector(31 downto 0);
      PRData1           : in    std_logic_vector(31 downto 0);
      PRData            : out   std_logic_vector(31 downto 0)
     );
end component;

  ---------------------------------------------------------------------
  -- If the XonPSEL constant is set to '0' (default), an 'X' appearing
  -- on the PSEL line will be converted to '0'. If this constant is set
  -- to '1', the PSEL generated internally by the testbench is passed on
  -- unmodified.
  ---------------------------------------------------------------------

constant XonPSEL        : std_logic := '0';

signal PCLK             : std_logic;
signal PENABLE          : std_logic;
signal PRESETn          : std_logic;
signal PADDR            : std_logic_vector(31 downto 0);
signal I_PADDR          : std_logic_vector(31 downto 0);

signal PSEL             : std_logic;
signal I_PSEL           : std_logic;
signal PSELT            : std_logic;
signal I_PSELT          : std_logic;
signal PWRITE           : std_logic;
signal I_PWRITE         : std_logic;
signal PRDATA0          : std_logic_vector(31 downto 0);
signal PRDATA1          : std_logic_vector(31 downto 0);
signal PRDATA           : std_logic_vector(31 downto 0);
signal PWDATA           : std_logic_vector(31 downto 0);

signal SCANENABLE       : std_logic;
signal SCANMODE         : std_logic;
signal nAACIBITCLKRST   : std_logic;
signal nFAACIBITCLKRST  : std_logic;

signal SCANINPCLK       : std_logic;
signal SCANINBITCLK     : std_logic;
signal SCANINnBITCLK    : std_logic;
signal SCANOUTPCLK      : std_logic;
signal SCANOUTBITCLK    : std_logic;
signal SCANOUTnBITCLK   : std_logic;

signal VRG0             : std_logic_vector(31 downto 0);
signal VRG1             : std_logic_vector(31 downto 0);
signal VRG2             : std_logic_vector(31 downto 0);
signal VRG3             : std_logic_vector(31 downto 0);
signal VRG4             : std_logic_vector(31 downto 0);
signal VRG5             : std_logic_vector(31 downto 0);
signal VRG6             : std_logic_vector(31 downto 0);
signal VRG7             : std_logic_vector(31 downto 0);
 
-- interrupt signals
signal AACIINTR         : std_logic;
signal AACITXINTR1      : std_logic;
signal AACITXINTR2      : std_logic;
signal AACITXINTR3      : std_logic;
signal AACITXINTR4      : std_logic;
signal AACIRXINTR1      : std_logic;
signal AACIRXINTR2      : std_logic;
signal AACIRXINTR3      : std_logic;
signal AACIRXINTR4      : std_logic;
signal AACIORINTR1      : std_logic;
signal AACIORINTR2      : std_logic;
signal AACIORINTR3      : std_logic;
signal AACIORINTR4      : std_logic;
signal AACITXCINTR1     : std_logic;
signal AACITXCINTR2     : std_logic;
signal AACITXCINTR3     : std_logic;
signal AACITXCINTR4     : std_logic;
signal AACIURINTR1      : std_logic;
signal AACIURINTR2      : std_logic;
signal AACIURINTR3      : std_logic;
signal AACIURINTR4      : std_logic;
signal AACIRXTOINTR1    : std_logic;
signal AACIRXTOINTR2    : std_logic;
signal AACIRXTOINTR3    : std_logic;
signal AACIRXTOINTR4    : std_logic;
signal AACIWINTR        : std_logic;
signal AACIGPIOINTR     : std_logic;
signal AACIS1RXINTR     : std_logic;
signal AACIS2RXINTR     : std_logic;
signal AACIS12RXINTR    : std_logic;
signal AACIS1TXINTR     : std_logic;
signal AACIS2TXINTR     : std_logic;
signal AACIS12TXINTR    : std_logic;
signal AACIRXTOFEINTR1  : std_logic;
signal AACIRXTOFEINTR2  : std_logic;
signal AACIRXTOFEINTR3  : std_logic;
signal AACIRXTOFEINTR4  : std_logic;


-- AC link ports
signal AACISYNC         : std_logic;
signal AACIRESET        : std_logic;
signal AACISDATAOUT     : std_logic;
signal AACISDATAIN      : std_logic;
signal AACIBITCLK       : std_logic;
signal nAACIBITCLK      : std_logic;

-- DMA signals
signal AACIDMASREQRX    : std_logic;
signal AACIDMALSREQRX   : std_logic;
signal AACIDMABREQRX    : std_logic;
signal AACIDMALBREQRX   : std_logic;
signal AACIDMABREQTX    : std_logic;
signal AACIDMACLRRX     : std_logic;
signal AACIDMACLRTX     : std_logic;

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- --------------------------------------------------------------------

begin
 
  SCANENABLE    <= '0';
  SCANINPCLK    <= '0';
  SCANINBITCLK  <= '0';
  SCANINnBITCLK <= '0';

  nAACIBITCLK      <= not AACIBITCLK;

  PSEL  <= '0' when (XonPSEL = '0' and I_PSEL = 'X')
        else
           I_PSEL;
 
  PSELT <= '0' when (XonPSEL = '0' and I_PSELT = 'X')
        else
           I_PSELT;
  PWRITE <= '0' when (XonPSEL = '0' and I_PWRITE = 'X')
       else
          I_PWRITE ;
 
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

uapbslv_tb : apbslave_tb
generic map (
          PRDATA_mask => "FFFFFFFF",
          INFILE => "../../bustest/invec/infile.bif",
          Verbosity => 0,
          HaltOnMismatch => 0,
          tclks => Tclks,
          tclkl => Tclkl,
          tclkh => Tclkh
          )
port map (
          PRESETn             => PRESETn,
          PCLK                => PCLK,
          PADDR               => I_PADDR,
          PWRITE              => I_PWRITE,
          PENABLE             => PENABLE,
          PSEL                => I_PSEL,
          PSELT               => I_PSELT,
          PRDATA              => PRDATA,
          PWDATA              => PWDATA,
          VRG0                => VRG0,
          VRG1                => VRG1,
          VRG2                => VRG2,
          VRG3                => VRG3,
          VRG4                => VRG4,
          VRG5                => VRG5,
          VRG6                => VRG6,
          VRG7                => VRG7
          );

uut : Aaci
port map (
          PCLK                => PCLK,
          AACIBITCLK          => AACIBITCLK,
          nAACIBITCLK         => nAACIBITCLK,
          PRESETn             => PRESETn,
          nAACIBITCLKRST      => nAACIBITCLKRST,
          nFAACIBITCLKRST     => nFAACIBITCLKRST,
          PSEL                => PSEL,
          PENABLE             => PENABLE,
          PWRITE              => PWRITE,
          AACIDMACLRRX        => AACIDMACLRRX,
          AACIDMACLRTX        => AACIDMACLRTX,
          SCANENABLE          => SCANENABLE,
          SCANINPCLK          => SCANINPCLK,
          SCANINBITCLK        => SCANINBITCLK,
          SCANINnBITCLK       => SCANINnBITCLK,
          AACISDATAIN         => AACISDATAIN,
          PADDR               => PADDR(11 downto 2),
          PWDATA              => PWDATA,
          AACIRESET           => AACIRESET,
          AACISYNC            => AACISYNC,
          AACITXINTR1         => AACITXINTR1,
          AACITXINTR2         => AACITXINTR2,
          AACITXINTR3         => AACITXINTR3,
          AACITXINTR4         => AACITXINTR4,
          AACIRXINTR1         => AACIRXINTR1,
          AACIRXINTR2         => AACIRXINTR2,
          AACIRXINTR3         => AACIRXINTR3,
          AACIRXINTR4         => AACIRXINTR4,
          AACIORINTR1         => AACIORINTR1,
          AACIORINTR2         => AACIORINTR2,
          AACIORINTR3         => AACIORINTR3,
          AACIORINTR4         => AACIORINTR4,
          AACIURINTR1         => AACIURINTR1,
          AACIURINTR2         => AACIURINTR2,
          AACIURINTR3         => AACIURINTR3,
          AACIURINTR4         => AACIURINTR4,
          AACITXCINTR1        => AACITXCINTR1,
          AACITXCINTR2        => AACITXCINTR2,
          AACITXCINTR3        => AACITXCINTR3,
          AACITXCINTR4        => AACITXCINTR4,
          AACIRXTOINTR1       => AACIRXTOINTR1,
          AACIRXTOINTR2       => AACIRXTOINTR2,
          AACIRXTOINTR3       => AACIRXTOINTR3,
          AACIRXTOINTR4       => AACIRXTOINTR4,
          AACIWINTR           => AACIWINTR,
          AACIGPIOINTR        => AACIGPIOINTR,
          AACIS12RXINTR       => AACIS12RXINTR,
          AACIS12TXINTR       => AACIS12TXINTR,
          AACIS2RXINTR        => AACIS2RXINTR,
          AACIS2TXINTR        => AACIS2TXINTR,
          AACIS1RXINTR        => AACIS1RXINTR,
          AACIS1TXINTR        => AACIS1TXINTR,
          AACIRXTOFEINTR1     => AACIRXTOFEINTR1,
          AACIRXTOFEINTR2     => AACIRXTOFEINTR2,
          AACIRXTOFEINTR3     => AACIRXTOFEINTR3,
          AACIRXTOFEINTR4     => AACIRXTOFEINTR4,

          AACIINTR            => AACIINTR,
          AACIDMASREQRX       => AACIDMASREQRX,
          AACIDMALSREQRX      => AACIDMALSREQRX,
          AACIDMABREQRX       => AACIDMABREQRX,
          AACIDMALBREQRX      => AACIDMALBREQRX,
          AACIDMABREQTX       => AACIDMABREQTX,
          SCANOUTPCLK         => SCANOUTPCLK,
          SCANOUTBITCLK       => SCANOUTBITCLK,
          SCANOUTnBITCLK      => SCANOUTnBITCLK,
          AACISDATAOUT        => AACISDATAOUT,
          PRDATA              => PRDATA0
         );

uAaciTrick : AaciTrick
port map (
          -- APB bus signals
          PCLK                => PCLK,
          PRESETn             => PRESETn,
          PSEL                => PSELT,
          PSELCOM             => PSEL,
          PENABLE             => PENABLE,
          PWRITE              => PWRITE,
          PADDR               => PADDR(11 downto 2),
          PWDATA              => PWDATA,
                                    
          -- DMA request signals
          AACIDMASREQRX       => AACIDMASREQRX,
          AACIDMALSREQRX      => AACIDMALSREQRX,
          AACIDMABREQRX       => AACIDMABREQRX,
          AACIDMALBREQRX      => AACIDMALBREQRX,
          AACIDMABREQTX       => AACIDMABREQTX,
 

          -- Interrupt signals
          AACIINTR            => AACIINTR,
          AACITXINTR1         => AACITXINTR1,
          AACITXINTR2         => AACITXINTR2,
          AACITXINTR3         => AACITXINTR3,
          AACITXINTR4         => AACITXINTR4,
          AACIRXINTR1         => AACIRXINTR1,
          AACIRXINTR2         => AACIRXINTR2,
          AACIRXINTR3         => AACIRXINTR3,
          AACIRXINTR4         => AACIRXINTR4,
          AACIORINTR1         => AACIORINTR1,
          AACIORINTR2         => AACIORINTR2,
          AACIORINTR3         => AACIORINTR3,
          AACIORINTR4         => AACIORINTR4,
          AACITXCINTR1        => AACITXCINTR1,
          AACITXCINTR2        => AACITXCINTR2,
          AACITXCINTR3        => AACITXCINTR3,
          AACITXCINTR4        => AACITXCINTR4,
          AACIURINTR1         => AACIURINTR1,
          AACIURINTR2         => AACIURINTR2,
          AACIURINTR3         => AACIURINTR3,
          AACIURINTR4         => AACIURINTR4,
          AACIRXTOINTR1       => AACIRXTOINTR1,
          AACIRXTOINTR2       => AACIRXTOINTR2,
          AACIRXTOINTR3       => AACIRXTOINTR3,
          AACIRXTOINTR4       => AACIRXTOINTR4,
          AACIWINTR           => AACIWINTR,
          AACIGPIOINTR        => AACIGPIOINTR,
          AACIS1RXINTR        => AACIS1RXINTR,
          AACIS2RXINTR        => AACIS2RXINTR,
          AACIS12RXINTR       => AACIS12RXINTR,
          AACIS1TXINTR        => AACIS1TXINTR,
          AACIS2TXINTR        => AACIS2TXINTR,
          AACIS12TXINTR       => AACIS12TXINTR,
          AACIRXTOFEINTR1     => AACIRXTOFEINTR1,
          AACIRXTOFEINTR2     => AACIRXTOFEINTR2,
          AACIRXTOFEINTR3     => AACIRXTOFEINTR3,
          AACIRXTOFEINTR4     => AACIRXTOFEINTR4,

          AACIRESET           => AACIRESET,
          AACISYNC            => AACISYNC,
          AACISDATAIN         => AACISDATAOUT,
          AACISDATAOUT        => AACISDATAIN,
          AACIBITCLK          => AACIBITCLK,  

          nAACIBITCLKRST      => nAACIBITCLKRST, 
          nFAACIBITCLKRST     => nFAACIBITCLKRST, 
          AACIDMACLRRX        => AACIDMACLRRX,
          AACIDMACLRTX        => AACIDMACLRTX,
          PRDATA              => PRDATA1
         );

uapbmux : apbmux
port map (
          PCLK                => PCLK,
          PRESETn             => PRESETn,
          PSEL                => PSEL,
          PSELT               => PSELT,
          PRData0             => PRDATA0,
          PRData1             => PRDATA1,
          PRData              => PRDATA
         );

end test;

-- --============================ End ================================--


