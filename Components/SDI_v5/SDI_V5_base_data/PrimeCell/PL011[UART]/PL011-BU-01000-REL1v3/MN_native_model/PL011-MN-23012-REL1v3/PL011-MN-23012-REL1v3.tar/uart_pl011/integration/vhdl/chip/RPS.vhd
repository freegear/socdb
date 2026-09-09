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
-- File Name              : RPS.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Structural architecture of Reference Peripherals:
--           Interrupt Controller, Remap and Pause Controller, and
--           Timers modules.
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library uut;
use     uut.all;

entity RPS is
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;

        Pause            : out   std_logic; -- Pause mode entered
        Remap            : out   std_logic; -- Reset memory map in use

        PSELRPC          : in    std_logic; -- Remap and Pause

        PSELUUT          : in    std_logic; -- Unit Under Test

        PENABLE          : in    std_logic;
        PADDR            : in    std_logic_vector(31 downto 0);
        PWRITE           : in    std_logic;
        PWDATA           : in    std_logic_vector(31 downto 0);
        PRDATA           : out   std_logic_vector(31 downto 0);

        -- UART - LINK signals
        UARTRXD          : in  std_logic;      -- UART Receive input
        SIRIN            : in  std_logic;      -- SiR receive input
        nUARTCTS         : in  std_logic;      -- Modem CTS
        nUARTDCD         : in  std_logic;      -- Modem DCD
        nUARTDSR         : in  std_logic;      -- Modem DSR
        nUARTRI          : in  std_logic;      -- Modem RI
        UARTTXD          : out std_logic;      -- UART Transmit line
        nSIROUT          : out std_logic;      -- SiR Transmit line
        nUARTOut2        : out std_logic;      -- Modem Out2
        nUARTOut1        : out std_logic;      -- Modem Out1
        nUARTRTS         : out std_logic;      -- Modem RTS
        nUARTDTR         : out std_logic       -- Modem DTR
       );

end RPS;

-- ---------------------------------------------------------------------

-- --======================= ARCHITECTURE ============================--

architecture Structural of RPS is

-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Central multiplexer - peripherals to bridge
-- ---------------------------------------------------------------------
component MuxP2B
  port (
        PSELRPC          : in    std_logic;
        PSELUUT          : in    std_logic;

        PRDATARPC        : in    std_logic_vector(31 downto 0);
        PRDATAUUT        : in    std_logic_vector(31 downto 0);

        PRDATA           : out   std_logic_vector(31 downto 0)
       );
end component;

-- ---------------------------------------------------------------------
-- The reset and pause controller
-- ---------------------------------------------------------------------
component RemPause
  port (
        PCLK             : in  std_logic;
        PRESETn          : in  std_logic;
        PENABLE          : in  std_logic;
        PSELRPC          : in  std_logic;
        PADDR            : in  std_logic_vector(5 downto 2);
        PWRITE           : in  std_logic;
        PWDATA           : in  std_logic_vector(7 downto 0);
        PRDATA           : out std_logic_vector(7 downto 0);

        nFIQ             : in  std_logic; -- FIQ interrupt input
        nIRQ             : in  std_logic; -- IRQ interrupt input
        Pause            : out std_logic; -- Pause mode entered
        Remap            : out std_logic  -- Reset memory map in use
       );
end component;

-- UART    
component Uart
  port (
        PCLK          : in  std_logic;      -- APB Bus Clock
        UARTCLK       : in  std_logic;      -- Main UART Clock
        PRESETn       : in  std_logic;      -- AMBA Bus reset
        nUARTRST      : in  std_logic;      -- UART Reset
        PSEL          : in  std_logic;      -- APB Peripheral select
        PENABLE       : in  std_logic;      -- APB Peripheral enable
        PWRITE        : in  std_logic;      -- APB Peripheral write
        PADDR         : in  std_logic_vector(11 downto 2);
                                            -- APB Addr bus
        PWDATA        : in  std_logic_vector(15 downto 0);
                                            -- APB write databus
        UARTRXD       : in  std_logic;      -- UART Receive input
        SIRIN         : in  std_logic;      -- SiR receive input
        nUARTCTS      : in  std_logic;      -- Modem CTS
        nUARTDCD      : in  std_logic;      -- Modem DCD
        nUARTDSR      : in  std_logic;      -- Modem DSR
        nUARTRI       : in  std_logic;      -- Modem RI
        UARTTXDMACLR  : in  std_logic;      -- Transmit DMA Clear
        UARTRXDMACLR  : in  std_logic;      -- Receive DMA Clear

        PRDATA        : out std_logic_vector(15 downto 0);
                                            -- Read databus
        UARTTXD       : out std_logic;      -- UART Transmit line
        nSIROUT       : out std_logic;      -- SiR Transmit line
        UARTMSINTR    : out std_logic;      -- Modem status interrupt
        UARTRXINTR    : out std_logic;      -- UART Receive interrupt
        UARTTXINTR    : out std_logic;      -- UART Transmit interrupt
        UARTRTINTR    : out std_logic;      -- Receive Timeout interrupt
        UARTEINTR     : out std_logic;      -- Combined Error interrupt
        UARTINTR      : out std_logic;      -- Combined interrupt
        nUARTOut2     : out std_logic;      -- Modem Out2
        nUARTOut1     : out std_logic;      -- Modem Out1
        nUARTRTS      : out std_logic;      -- Modem RTS
        nUARTDTR      : out std_logic;      -- Modem DTR
        UARTTXDMASREQ : out std_logic;      -- Transmit DMA single request
        UARTTXDMABREQ : out std_logic;      -- Transmit DMA burst request
        UARTRXDMASREQ : out std_logic;      -- Receive DMA single request
        UARTRXDMABREQ : out std_logic;      -- Receive DMA burst request

        -- Scan test dummy signals; not connected until scan insertion
        SCANENABLE     : in  std_logic;     -- Test Mode input
        SCANINPCLK     : in  std_logic;     -- Scan chain input
        SCANINUCLK     : in  std_logic;     -- Scan chain input
        SCANOUTPCLK    : out std_logic;     -- Scan chain output
        SCANOUTUCLK    : out std_logic      -- Scan chain output
       );
end component;


-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant UARTCLK_PERIOD    : time := 100 ns;
-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

signal PRDATAUUT        : std_logic_vector(31 downto 0);
signal PRDATARPC        : std_logic_vector(31 downto 0);
signal nFIQInt          : std_logic := '1';
signal nIRQInt          : std_logic := '1';

-- ---------------------------------------------------------------------
-- Uart Signals 
-- ---------------------------------------------------------------------

signal UARTCLK       : std_logic := '0';
signal nUARTRST      : std_logic;
signal UARTTXDMACLR  : std_logic;
signal UARTRXDMACLR  : std_logic;
signal UARTMSINTR    : std_logic;
signal UARTRXINTR    : std_logic;
signal UARTTXINTR    : std_logic;
signal UARTRTINTR    : std_logic;
signal UARTEINTR     : std_logic;
signal UARTINTR      : std_logic;
signal UARTTXDMASREQ : std_logic;
signal UARTTXDMABREQ : std_logic;
signal UARTRXDMASREQ : std_logic;
signal UARTRXDMABREQ : std_logic;
signal SCANENABLE    : std_logic;
signal SCANINPCLK    : std_logic;
signal SCANINUCLK    : std_logic;
signal SCANOUTPCLK   : std_logic;
signal SCANOUTUCLK   : std_logic;
signal nUARTRST1     : std_logic;
signal nUARTRST2     : std_logic;

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Tie down non-primary inputs to the UART to prevent X-propagation
-- during netlist simulations.
-- ---------------------------------------------------------------------
UARTTXDMACLR <= '0';
UARTRXDMACLR <= '0';
SCANENABLE   <= '0';
SCANINPCLK   <= '0';
SCANINUCLK   <= '0';

UARTCLK <= not UARTCLK after UARTCLK_PERIOD/2;

-- ---------------------------------------------------------------------
-- Central multiplexer - peripherals to bridge - Instantiation
-- ---------------------------------------------------------------------
uMuxP2B : MuxP2B
  port map (
            PSELUUT          => PSELUUT,
            PSELRPC          => PSELRPC,

            PRDATAUUT        => PRDATAUUT,
            PRDATARPC        => PRDATARPC,

            PRDATA           => PRDATA
           );

-- ---------------------------------------------------------------------
-- The reset and pause controller Instantiation
-- ---------------------------------------------------------------------
uRemPause : RemPause
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            PENABLE          => PENABLE,
            PSELRPC          => PSELRPC,
            PADDR            => PADDR(5 downto 2),
            PWRITE           => PWRITE,
            PWDATA           => PWDATA(7 downto 0),
            PRDATA           => PRDATARPC(7 downto 0),

            nFIQ             => nFIQInt,
            nIRQ             => nIRQInt,
            Pause            => Pause,
            Remap            => Remap
           );

-- Drive unused output read data bits LOW.
PRDATARPC(31 downto 8)  <= (others => '0');
PRDATAUUT(31 downto 16) <= (others => '0');

-- ---------------------------------------------------------------------
-- Create nUARTRST by synchronising the negation to UARTCLK
-- ---------------------------------------------------------------------
  p_nUARTRST1 : process(PRESETn, UARTCLK)
  begin
    if (PRESETn = '0') then
      nUARTRST1 <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      nUARTRST1 <= '1';
    end if;
  end process p_nUARTRST1;
  
  p_nUARTRST2 : process(PRESETn, UARTCLK)
  begin
    if (PRESETn = '0') then
      nUARTRST2 <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      nUARTRST2 <= nUARTRST1;
    end if;
  end process p_nUARTRST2;

  p_nUARTRST3 : process(PRESETn, UARTCLK)
  begin
    if (PRESETn = '0') then
      nUARTRST <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      nUARTRST <= nUARTRST2;
    end if;
  end process p_nUARTRST3;

-- ---------------------------------------------------------------------
-- UART instance
-- ---------------------------------------------------------------------
uut : Uart
  port map (
            PCLK         => PCLK,
            PRESETn      => PRESETn,
            nUARTRST     => nUARTRST,
            PSEL         => PSELUUT,
            PWRITE       => PWRITE,
            PENABLE      => PENABLE,
            PADDR        => PADDR(11 downto 2),
            PWDATA       => PWDATA(15 downto 0),
            UARTCLK      => UARTCLK,
            PRDATA       => PRDATAUUT(15 downto 0),
            nUARTCTS     => nUARTCTS,
            nUARTDCD     => nUARTDCD,
            nUARTDSR     => nUARTDSR,
            nUARTRI      => nUARTRI,
            nUARTOut2    => nUARTOut2,
            nUARTOut1    => nUARTOut1,
            nUARTRTS     => nUARTRTS,
            nUARTDTR     => nUARTDTR,
            UARTRXD      => UARTRXD,
            SIRIN        => SIRIN,
            UARTTXDMACLR => UARTTXDMACLR,
            UARTRXDMACLR => UARTRXDMACLR,
            UARTTXDMASREQ => UARTTXDMASREQ,
            UARTTXDMABREQ => UARTTXDMABREQ,
            UARTRXDMASREQ => UARTRXDMASREQ,
            UARTRXDMABREQ => UARTRXDMABREQ,
            UARTMSINTR   => UARTMSINTR,
            UARTTXD      => UARTTXD,
            UARTRXINTR   => UARTRXINTR,
            nSIROUT      => nSIROUT,
            UARTTXINTR   => UARTTXINTR,
            UARTRTINTR   => UARTRTINTR,
            UARTINTR     => UARTINTR,
            UARTEINTR    => UARTEINTR,
            SCANINPCLK  => SCANINPCLK,
            SCANINUCLK  => SCANINUCLK,
            SCANOUTPCLK => SCANOUTPCLK,
            SCANOUTUCLK => SCANOUTUCLK,
            SCANENABLE   => SCANENABLE
           );

end Structural;

-- --============================== End ==============================--
