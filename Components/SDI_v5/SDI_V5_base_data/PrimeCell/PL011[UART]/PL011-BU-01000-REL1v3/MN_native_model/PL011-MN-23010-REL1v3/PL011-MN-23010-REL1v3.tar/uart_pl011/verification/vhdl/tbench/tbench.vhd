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
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose : Top level of the Uart Compliance TestBench
--           This file instantiates the Uart module, the Uart trickbox
--           and the Read Data Mux.
--
-- --=================================================================--

library ieee;
use ieee.std_logic_1164.all;

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
--  Top level testbench.This file integrates the Uart, Uart trickbox and
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
  
  component  UartTrick
  port (
        -- APB bus signals
        PCLK          : in    std_logic;
        PRESETn       : in    std_logic;
        PENABLE       : in    std_logic;
        PSELT         : in    std_logic;
        PWRITE        : in    std_logic;
        PADDR         : in    std_logic_vector(7 downto 2);
        PWData        : in    std_logic_vector(7 downto 0);
        PRData        : out   std_logic_vector(7 downto 0);
        
        -- CLOCK AND RESET 
        nUARTRST      : out   std_logic;
        UARTCLK       : out   std_logic;
 
        -- UART Modem Control Signals
        nUARTOut2     : in   std_logic;
        nUARTOut1     : in   std_logic;
        nUARTRTS      : in   std_logic;
        nUARTDTR      : in   std_logic; 
        nUARTCTS      : out   std_logic;
        nUARTDCD      : out   std_logic;
        nUARTDSR      : out   std_logic;
        nUARTRI       : out   std_logic;        
 
        -- UART Data Signals
        UARTTXD       : in    std_logic;
        UARTRXD       : out   std_logic;
        
        -- Infra-Red Data Signals
        nSIROUT       : in    std_logic;
        SIRIN         : out   std_logic;
 
        -- UART Interrupt Signals
        UARTMSINTR    : in    std_logic;
        UARTRXINTR    : in    std_logic;
        UARTTXINTR    : in    std_logic;
        UARTRTINTR    : in    std_logic;
        UARTINTR      : in    std_logic;
        UARTEINTR     : in    std_logic;

        -- DMA signals
        UARTTXDMASREQ : in   std_logic;
        UARTTXDMABREQ : in   std_logic;
        UARTRXDMASREQ : in   std_logic;
        UARTRXDMABREQ : in   std_logic;
        UARTTXDMACLR  : out std_logic;  
        UARTRXDMACLR  : out std_logic;   

     
        -- SCAN signals
        SCANMODE     : out   std_logic

       );
  end component;


  component Uart
   port (
        PCLK          : in    std_logic;
        PRESETn       : in    std_logic;
        PADDR         : in    std_logic_vector(11 downto 2);
        nUARTRST      : in    std_logic;
        PRDATA        : out   std_logic_vector(15 downto 0);
        PWDATA        : in    std_logic_vector(15 downto 0);
        PSEL          : in    std_logic;
        PENABLE       : in    std_logic;
        PWRITE        : in    std_logic;
        UARTCLK       : in    std_logic;
        UARTMSINTR    : out   std_logic;
        UARTRXINTR    : out   std_logic;
        UARTTXINTR    : out   std_logic;
        UARTRTINTR    : out   std_logic;
        UARTINTR      : out   std_logic;
        UARTEINTR     : out   std_logic;
        nUARTCTS      : in    std_logic;
        nUARTDCD      : in    std_logic;
        nUARTDSR      : in    std_logic;
        nUARTRI       : in    std_logic;
        nUARTOut2     : out   std_logic;
        nUARTOut1     : out   std_logic;
        nUARTRTS      : out   std_logic;  
        nUARTDTR      : out   std_logic;
        UARTRXD       : in    std_logic;
        SIRIN         : in    std_logic;
        UARTTXDMACLR  : in    std_logic;
        UARTRXDMACLR  : in    std_logic;
        UARTTXDMASREQ : out   std_logic; 
        UARTTXDMABREQ : out   std_logic; 
        UARTRXDMASREQ : out   std_logic; 
        UARTRXDMABREQ : out   std_logic; 

        UARTTXD       : out   std_logic;
        nSIROUT       : out   std_logic;
        SCANINPCLK    : in    std_logic;
        SCANINUCLK    : in    std_logic;
        SCANENABLE    : in    std_logic;
        SCANOUTPCLK   : out   std_logic;
        SCANOUTUCLK   : out   std_logic
        );
  end component;

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
-- If the XonPSEL constant is set to '0' (default), an 'X' appearing
-- on the PSEL line will be converted to '0'. If this constant is set
-- to '1', the PSEL generated internally by the testbench is passed on
-- unmodified.
-- ---------------------------------------------------------------------
  constant XonPSEL                  : std_logic := '0';

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

signal PCLK             : std_logic;
signal PENABLE          : std_logic;
signal PRESETn          : std_logic;
signal PADDR            : std_logic_vector(31 downto 0);
signal I_PADDR          : std_logic_vector(31 downto 0);

signal PWRITE           : std_logic;
signal PSEL             : std_logic;
signal I_PSEL           : std_logic;
signal I_PWRITE         : std_logic;
signal PSELT            : std_logic;
signal I_PSELT          : std_logic;
signal PRDATA0          : std_logic_vector(31 downto 0);
signal PRDATA1          : std_logic_vector(31 downto 0);
signal PRDATA           : std_logic_vector(31 downto 0);
signal PWDATA           : std_logic_vector(31 downto 0);

signal VRG0             : std_logic_vector(31 downto 0);
signal VRG1             : std_logic_vector(31 downto 0);
signal VRG2             : std_logic_vector(31 downto 0);
signal VRG3             : std_logic_vector(31 downto 0);
signal VRG4             : std_logic_vector(31 downto 0);
signal VRG5             : std_logic_vector(31 downto 0);
signal VRG6             : std_logic_vector(31 downto 0);
signal VRG7             : std_logic_vector(31 downto 0);

signal UARTCLK          : std_logic; 
signal nUARTCTS         : std_logic; 
signal nUARTDCD         : std_logic; 
signal nUARTDSR         : std_logic;
signal nUARTRI          : std_logic;
signal nUARTOut2        : std_logic;
signal nUARTOut1        : std_logic;
signal nUARTRTS         : std_logic;
signal nUARTDTR         : std_logic;
signal UARTTXD          : std_logic; 
signal UARTRXD          : std_logic; 
signal nSIROUT          : std_logic; 
signal SIRIN            : std_logic; 
signal UARTTXDMACLR     : std_logic;
signal UARTRXDMACLR     : std_logic;
signal UARTTXDMASREQ    : std_logic;
signal UARTTXDMABREQ    : std_logic;
signal UARTRXDMASREQ    : std_logic;
signal UARTRXDMABREQ    : std_logic;
signal UARTMSINTR       : std_logic; 
signal UARTRXINTR       : std_logic; 
signal UARTTXINTR       : std_logic; 
signal UARTRTINTR       : std_logic;
signal UARTINTR         : std_logic;
signal UARTEINTR        : std_logic;
  
signal SCANMODE         : std_logic;
signal SCANINPCLK       : std_logic;
signal SCANINUCLK       : std_logic;
signal SCANOUTPCLK      : std_logic;
signal SCANOUTUCLK      : std_logic;
signal SCANENABLE       : std_logic;

signal nUARTRST         : std_logic;
signal nUARTRSTint      : std_logic;

signal ReadFill         : std_logic_vector(31 downto 0);

signal UartRdData       : std_logic_vector(15 downto 0);
signal TrickRdData      : std_logic_vector(7 downto 0);

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
  SCANINUCLK     <= '0';
  
  ReadFill <= (others => '0');


  PSEL   <= '0' when (XonPSEL = '0' and I_PSEL = 'X')
         else
            I_PSEL;

  PSELT  <= '0' when (XonPSEL = '0' and I_PSELT = 'X')
         else
            I_PSELT;
  
  PWRITE <= '0' when (XonPSEL = '0' and I_PWRITE = 'X')
         else
            I_PWRITE;

  p_PADDR : process (I_PADDR)
  begin
    for i in 0 to 31 loop
      if ((XonPSEL = '0') and (I_PADDR(i) = 'X')) then
          PADDR(i) <= '0';
      else
        PADDR(i)   <= I_PADDR(i);
      end if;
    end loop;
  end process p_PADDR;

  -- All the unconnected Virtual Register inputs should be set to zero:
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

  u_UartTrick : UartTrick
  port map (
             PCLK          => PCLK,
             PRESETn       => PRESETn,
             PENABLE       => PENABLE,
             PSELT         => PSELT,
             PWRITE        => PWRITE,
             PADDR         => PADDR(7 downto 2),
             PWData        => PWData(7 downto 0),
             PRData        => TrickRdData,
             nUARTRST      => nUARTRST,
             UARTCLK       => UARTCLK,
             nUARTOut2     => nUARTOut2,
             nUARTOut1     => nUARTOut1,
             nUARTRTS      => nUARTRTS,
             nUARTDTR      => nUARTDTR, 
             nUARTCTS      => nUARTCTS,
             nUARTDCD      => nUARTDCD,
             nUARTDSR      => nUARTDSR,
             nUARTRI       => nUARTRI,        
             UARTTXD       => UARTTXD,
             UARTRXD       => UARTRXD,
             nSIROUT       => nSIROUT,
             SIRIN         => SIRIN,
             UARTMSINTR    => UARTMSINTR,
             UARTRXINTR    => UARTRXINTR,
             UARTTXINTR    => UARTTXINTR,
             UARTRTINTR    => UARTRTINTR,
             UARTINTR      => UARTINTR,
             UARTEINTR     => UARTEINTR,
             UARTTXDMASREQ => UARTTXDMASREQ,
             UARTTXDMABREQ => UARTTXDMABREQ,
             UARTRXDMASREQ => UARTRXDMASREQ,
             UARTRXDMABREQ => UARTRXDMABREQ,
             UARTTXDMACLR  => UARTTXDMACLR,  
             UARTRXDMACLR  => UARTRXDMACLR,   
             SCANMODE     => SCANMODE
             );
  

  uut : Uart
  port map (
             PCLK          => PCLK,
             PRESETn       => PRESETn,
             PADDR         => PADDR(11 downto 2),
             nUARTRST      => nUARTRST,
             PRDATA        => UartRdData,
             PWDATA        => PWDATA(15 downto 0),
             PSEL          => PSEL,
             PENABLE       => PENABLE,
             PWRITE        => PWRITE,
             UARTCLK       => UARTCLK,
             UARTMSINTR    => UARTMSINTR,
             UARTRXINTR    => UARTRXINTR,
             UARTTXINTR    => UARTTXINTR,
             UARTRTINTR    => UARTRTINTR,
             UARTINTR      => UARTINTR,
             UARTEINTR     => UARTEINTR,
             nUARTCTS      => nUARTCTS,
             nUARTDCD      => nUARTDCD,
             nUARTDSR      => nUARTDSR,
             nUARTRI       => nUARTRI,
             nUARTOut2     => nUARTOut2,
             nUARTOut1     => nUARTOut1,
             nUARTRTS      => nUARTRTS,  
             nUARTDTR      => nUARTDTR,
             UARTRXD       => UARTRXD,
             SIRIN         => SIRIN,
             UARTTXDMACLR  => UARTTXDMACLR,
             UARTRXDMACLR  => UARTRXDMACLR,
             UARTTXDMASREQ => UARTTXDMASREQ, 
             UARTTXDMABREQ => UARTTXDMABREQ, 
             UARTRXDMASREQ => UARTRXDMASREQ, 
             UARTRXDMABREQ => UARTRXDMABREQ, 
             UARTTXD       => UARTTXD,
             nSIROUT       => nSIROUT,
             SCANINPCLK    => SCANINPCLK,
             SCANINUCLK    => SCANINUCLK,
             SCANENABLE    => SCANENABLE,
             SCANOUTPCLK   => SCANOUTPCLK,
             SCANOUTUCLK   => SCANOUTUCLK
             );
  
  PRData0 <= ReadFill(31 downto 16) & UartRdData;
  PRData1 <= ReadFill(31 downto 8) & TrickRdData;
 
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

-- --============================== End ==============================--
