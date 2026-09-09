--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only
--  as authorised by a licensing agreement from ARM Limited
--  (C) COPYRIGHT 1998 ARM Limited
--  ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised copies
--  and copies may only be made to the extent permitted by a
--  licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information :
--
--
--  Filename            : KmiTrRegFile.vhd,v
--
--  File Revision       : 1.1
--
--  Release Information : PL050-REL1v1
--
-- ----------------------------------------------------------------------------
-- Purpose : This block holds the different registers within the TrickBox.
--           It also generates the TrickBox Fifo Status signals.
--
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity KmiTrRegFile is
  port (
        WrenTXREG   : in std_logic; -- Transmit Register Write from APB 
        WrenCnREG   : in std_logic; -- Control Register Write from APB 
        WrenCLKL    : in std_logic; -- Clock Low Time Value Write from APB
        WrenCLKH    : in std_logic; -- Clock High Time Value Write from APB
        WrenDSI     : in std_logic; -- DSI Write from APB
        WrenDHI     : in std_logic; -- DHI Write from APB
        WrenDSO     : in std_logic; -- DSO Write from APB
        WrenDHO     : in std_logic; -- DHO Write from APB
        WrenREFCLK  : in std_logic; -- REFCLK write from APB
        WrenRG      : in std_logic; -- RG  Write from APB
        WrenCLKDIV  : in std_logic; -- CLKDIV Write from APB
        WrenTIMOUT  : in std_logic; -- TIMOUT Write from APB 
        WrenMODEREG : in std_logic; -- MODEREG write from APB
        DataAvl     : in std_logic; -- Receive Register Write from Rx Block
        RdUpdateRx  : in std_logic; -- To Read Next Data in RXFF
        RdUpdateTx  : in std_logic; -- To Read Next Data in TXFF
        PWDataIn    : in std_logic_vector(15 downto 0); -- Muxed Data from APB
        RXDATAIN    : in std_logic_vector(7 downto 0); -- Data from Rx 
        PCLK        : in std_logic;   -- APB Clock
        BnRES       : in std_logic;   -- APB Reset
        KmiTrRXFF   : out std_logic; -- Receiver Buffer Full
        KmiTrRXFE   : out std_logic; -- Receiver Buffer Empty
        KmiTrRXFH   : out std_logic; -- Receiver Buffer More Than Half Full
        KmiTrTXFF   : out std_logic; -- Transmitter Buffer Full
        KmiTrTXFE   : out std_logic; -- Transmitter Buffer Empty
        KmiTrTXFH   : out std_logic; -- Transmitter Buffer Less Than Half Full
        KmiTrRXREG  : out std_logic_vector(7 downto 0); -- Receiver Buffer
        KmiTrTXREG  : out std_logic_vector(7 downto 0); -- Transmitter Buffer
        KmiTrCnREG  : out std_logic_vector(4 downto 0); -- Control Register
        KmiTrCLKL   : out std_logic_vector(8 downto 0); -- Clock Low Time Reg
        KmiTrCLKH   : out std_logic_vector(8 downto 0); -- Clock High Time Reg
        KmiTrDSI    : out std_logic_vector(15 downto 0); -- DSI Tim. Param.
        KmiTrDHI    : out std_logic_vector(15 downto 0); -- DSI Tim. Param.
        KmiTrDSO    : out std_logic_vector(15 downto 0); -- DSI Tim. Param.
        KmiTrDHO    : out std_logic_vector(15 downto 0); -- DSI Tim. Param.
        KmiTrREFCLK : out std_logic_vector(7 downto 0); -- REFCLK Register
        KmiTrRG     : out std_logic_vector(15 downto 0); -- DSI Tim. Param.
        KmiTrCLKDIV : out std_logic_vector(7 downto 0); -- Clock Divisor value
        KmiTrTIMOUT : out std_logic_vector(4 downto 0); -- Time Out Value
        KmiTrMODEREG: out std_logic_vector(3 downto 0)  -- CLK/Reset Register
       );
end KmiTrRegFile;

-- ----------------------------------------------------------------------------
--
--                           KmiTrRegFile
--                           ============
--
-- ----------------------------------------------------------------------------
--
-- Overview
-- ========
-- The different registers within the TrickBox are implemented here. Write 
-- to these registers will update the contents. 
-- 
-- ----------------------------------------------------------------------------
--
--========================== ARCHITECTURE ====================================
--

architecture behavioural of KmiTrRegFile is

-- ----------------------------------------------------------------------------
-- Component Declarations
-- ----------------------------------------------------------------------------
component  KmiTrRXFIFO 
  port (
        PCLK     : in  std_logic;  
        BnRES    : in  std_logic;  
        Write    : in  std_logic;  
        Read     : in  std_logic;  
        DataIn   : in  std_logic_vector(7 downto 0); 
        Ffull    : out std_logic;  
        Fempty   : out std_logic;  
        Fhalfmore: out std_logic;  
        DataOut  : out std_logic_vector(7 downto 0)  
       );
end component;

component KmiTrTXFIFO 
  port (
        PCLK     : in  std_logic;  
        BnRES    : in  std_logic;  
        Write    : in  std_logic;  
        Read     : in  std_logic;  
        DataIn   : in  std_logic_vector(7 downto 0); 
        Ffull    : out std_logic;  
        Fempty   : out std_logic;  
        Fhalfless: out std_logic;  
        DataOut  : out std_logic_vector(7 downto 0)  
       );
end component;

-- ----------------------------------------------------------------------------
-- Signal declaration
-- ---------------------------------------------------------------------------- 
signal iKmiTrCnREG      : std_logic_vector(4 downto 0); 
-- Internal Copy of Control Register
   
signal NextKmiTrCnREG   : std_logic_vector(4 downto 0); 
-- D input to KmiTrCnREG
 
signal iKmiTrCLKL       : std_logic_vector(8 downto 0); 
-- Internal Copy of KmiTrCLKL
   
signal NextKmiTrCLKL    : std_logic_vector(8 downto 0); 
-- D input to KmiTrCLKL
   
signal iKmiTrCLKH       : std_logic_vector(8 downto 0); 
-- Internal Copy of KmiTrCLKH
   
signal NextKmiTrCLKH    : std_logic_vector(8 downto 0); 
-- D input to KmiTrCLKH

signal iKmiTrDSI        : std_logic_vector(15 downto 0); 
-- Internal Copy of DSI Reg
   
signal NextKmiTrDSI     : std_logic_vector(15 downto 0); 
-- D input to DSI Reg

signal iKmiTrDHI        : std_logic_vector(15 downto 0); 
-- Internal Copy of DHI Reg
   
signal NextKmiTrDHI     : std_logic_vector(15 downto 0); 
--  D input to DHI Reg

signal iKmiTrDSO        : std_logic_vector(15 downto 0); 
-- Internal Copy of DSO Reg
   
signal NextKmiTrDSO     : std_logic_vector(15 downto 0); 
-- D input to DSO Reg
   
signal iKmiTrDHO        : std_logic_vector(15 downto 0); 
-- Internal Copy of DHO Reg
   
signal NextKmiTrDHO     : std_logic_vector(15 downto 0); 
-- D input to DHO Reg

signal iKmiTrREFCLK     : std_logic_vector(7 downto 0); 
-- Internal Copy of REFCLK Value
   
signal NextKmiTrREFCLK  : std_logic_vector(7 downto 0); 
-- D input to KmiTrREFCLK
   
signal iKmiTrRG         : std_logic_vector(15 downto 0); 
-- Internal Copy of RG Reg
   
signal NextKmiTrRG      : std_logic_vector(15 downto 0); 
-- D input to RG Reg

signal iKmiTrCLKDIV     : std_logic_vector(7 downto 0); 
-- Internal Copy of Clock Divisor value
   
signal NextKmiTrCLKDIV  : std_logic_vector(7 downto 0); 
-- D input to KmiTrCLKDIV
   
signal iKmiTrTIMOUT     : std_logic_vector(4 downto 0); 
-- Internal Copy of Time Out Value
   
signal NextKmiTrTIMOUT  : std_logic_vector(4 downto 0); 
-- D input to KmiTrTIMOUT
   
signal iKmiTrMODEREG    : std_logic_vector(3 downto 0); 
-- Internal Copy of MODEREG Value
   
signal NextKmiTrMODEREG : std_logic_vector(3 downto 0); 
-- D input to KmiTrMODEREG

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
 
begin

-- -----------------------------------------------------------------------------
-- Component Instantiation
-- -----------------------------------------------------------------------------
uKmiTrTXFIFO : KmiTrTXFIFO
port map (
          PCLK      => PCLK,
          BnRES     => BnRES, 
          Write     => WrenTXREG, 
          Read      => RdUpdateTx,
          DataIn    => PWDataIn(7 downto 0),
          Ffull     => KmiTrTXFF,
          Fempty    => KmiTrTXFE, 
          Fhalfless => KmiTrTXFH,
          DataOut   => KmiTrTXREG
         );

uKmiTrRXFIFO : KmiTrRXFIFO  
port map (
          PCLK      => PCLK,
          BnRES     => BnRES,
          Write     => DataAvl,
          Read      => RdUpdateRx,
          DataIn    => RXDATAIN,
          Ffull     => KmiTrRXFF,
          Fempty    => KmiTrRXFE,
          Fhalfmore => KmiTrRXFH,
          DataOut   => KmiTrRXREG
         );

 
NextKmiTrCnREG   <= PWDataIn(4 downto 0) when WrenCnREG = '1' 
                 else 
                    iKmiTrCnREG;
 
NextKmiTrCLKL    <= PWDataIn(8 downto 0) when WrenCLKL = '1' 
                 else 
                    iKmiTrCLKL;

NextKmiTrCLKH    <= PWDataIn(8 downto 0) when WrenCLKH = '1' 
                 else 
                    iKmiTrCLKH;

NextKmiTrDSI     <= PWDataIn             when WrenDSI = '1' 
                 else 
                    iKmiTrDSI;

NextKmiTrDHI     <= PWDataIn             when WrenDHI = '1' 
                 else 
                    iKmiTrDHI;

NextKmiTrDSO     <= PWDataIn             when WrenDSO = '1' 
                 else 
                    iKmiTrDSO;

NextKmiTrDHO     <= PWDataIn             when WrenDHO = '1' 
                 else 
                    iKmiTrDHO;

NextKmiTrREFCLK  <= PWDataIn(7 downto 0) when WrenREFCLK = '1' 
                 else 
                    iKmiTrREFCLK;

NextKmiTrRG      <= PWDataIn             when WrenRG = '1' 
                 else 
                    iKmiTrRG;

NextKmiTrCLKDIV  <= PWDataIn(7 downto 0) when WrenCLKDIV = '1' 
                 else 
                    iKmiTrCLKDIV;

NextKmiTrTIMOUT  <= PWDataIn(4 downto 0) when WrenTIMOUT = '1' 
                 else 
                    iKmiTrTIMOUT;

NextKmiTrMODEREG <= PWDataIn(3 downto 0) when WrenMODEREG = '1' 
                 else 
                    iKmiTrMODEREG;

-- ----------------------------------------------------------------------------
-- This process updates various registers at the positive edge of PCLK.
-- ----------------------------------------------------------------------------
p_RegistersSeq : process(PCLK,BnRES)
begin
  if (BnRES = '0') then
    iKmiTrCnREG    <= "00000";  
    iKmiTrCLKL     <= "000000000"; 
    iKmiTrCLKH     <= "000000000"; 
    iKmiTrDSI      <= "0000000000000000"; 
    iKmiTrDHI      <= "0000000000000000"; 
    iKmiTrDSO      <= "0000000000000000";
    iKmiTrDHO      <= "0000000000000000"; 
    iKmiTrREFCLK   <= "00000000"; 
    iKmiTrRG       <= "0000000000000000"; 
    iKmiTrCLKDIV   <= "00000000"; 
    iKmiTrTIMOUT   <= "00000";
    iKmiTrMODEREG  <= "0001";
  elsif (PCLK'event and PCLK = '1') then
    iKmiTrCnREG    <= NextKmiTrCnREG;
    iKmiTrCLKL     <= NextKmiTrCLKL;
    iKmiTrCLKH     <= NextKmiTrCLKH;
    iKmiTrDSI      <= NextKmiTrDSI;
    iKmiTrDHI      <= NextKmiTrDHI;
    iKmiTrDSO      <= NextKmiTrDSO;
    iKmiTrDHO      <= NextKmiTrDHO;
    iKmiTrREFCLK   <= NextKmiTrREFCLK;
    iKmiTrRG       <= NextKmiTrRG;
    iKmiTrCLKDIV   <= NextKmiTrCLKDIV;
    iKmiTrTIMOUT   <= NextKmiTrTIMOUT;
    iKmiTrMODEREG  <= NextKmiTrMODEREG;
  end if;
end process p_RegistersSeq;

KmiTrCnREG    <= iKmiTrCnREG;
KmiTrCLKL     <= iKmiTrCLKL;
KmiTrCLKH     <= iKmiTrCLKH;
KmiTrDSI      <= iKmiTrDSI;
KmiTrDHI      <= iKmiTrDHI;
KmiTrDSO      <= iKmiTrDSO;
KmiTrDHO      <= iKmiTrDHO;
KmiTrREFCLK   <= iKmiTrREFCLK;
KmiTrRG       <= iKmiTrRG;
KmiTrCLKDIV   <= iKmiTrCLKDIV;
KmiTrTIMOUT   <= iKmiTrTIMOUT;
KmiTrMODEREG  <= iKmiTrMODEREG;

end behavioural;  

--========================== End of KmiTrRegFile ==============================

