-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SciTrRegBlk.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block contains fuctional registers of SCI. It also 
--            generates update trigger signal for those registers
--            whose contents need to be updated in SCIREFCLK domain.  
-- --=========================================================================--
  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--------------------------------------------------------------------------------

entity SciTrRegBlk is
  port (
        PCLK             : in    std_logic; -- APB Bus Clock
        PRESETn          : in    std_logic; -- Reset input
        SCITrCRWrEn      : in    std_logic; -- Control Reg Wr En
        SCITrFiLCRWrEn   : in    std_logic; -- FIFO level Wr En
        SCITrTXPCWrEn    : in    std_logic; -- TX retray Wr En
        SCITrRXPCWrEn    : in    std_logic; -- RX retray Wr En
        SCITrCTRLWrEn    : in    std_logic; -- Error En Wr En
        SCITrATWrEn      : in    std_logic; -- ATIME Wr En
        SCITrDTWrEn      : in    std_logic; -- DTIME Wr En
        SCITrTXBLKGWrEn  : in    std_logic; -- TX BLKG Wr En
        SCITrTXCHGWrEn   : in    std_logic; -- TX CHTG Wr En
        SCITrCKICCWrEn   : in    std_logic; -- CLKICC Wr En
        SCITrBAUDWrEn    : in    std_logic; -- BAUD Wr En
        SCITrVALUEWrEn   : in    std_logic; -- VALUE Wr En
        SCITrRXCHGWrEn   : in    std_logic; -- RX CHG Wr En
        SCITrRXBLKGWrEn  : in    std_logic; -- RX BLKG Wr En
        SCITrRFCKWrEn    : in    std_logic; -- REFCLK Reg Wr En
        SCITrWVWrEn      : in    std_logic; -- Error Margin Wr En
        SCITrJitWrEn     : in    std_logic; -- Jit value Wr En
        SCITrJitPatWrEn  : in    std_logic; -- Jit Cnt Wr En
        SCITrRFCNTLWrEn  : in    std_logic; -- REFCLK Cnt Wr En
        SCITrDMAWr       : in    std_logic; -- Write Enable for UTDMACR
        SCITXDMACLRStag2 : in    std_logic; -- For SCITXDMACLR
        SCIRXDMACLRStag2 : in    std_logic; -- For SCIRXDMACLR
        PWDATAIn         : in    std_logic_vector(15 downto 0); -- Int PWDATA
        
        SCITrCR          : out   std_logic_vector(15 downto 0); -- Control reg
        SCITrFiLCR       : out   std_logic_vector(7 downto 0);  -- FIFO level
        SCITrTXPC        : out   std_logic_vector(3 downto 0);  -- TX Retray
        SCITrRXPC        : out   std_logic_vector(3 downto 0);  -- RX Retray
        SCITrCTRL        : out   std_logic_vector(7 downto 0);  -- Error En 
        SCITrAT          : out   std_logic_vector(15 downto 0); -- ACTtim reg
        SCITrDT          : out   std_logic_vector(15 downto 0); -- DEACTtim reg
        SCITrTXBLKG      : out   std_logic_vector(7 downto 0);  -- TX BLKG reg
        SCITrTXCHG       : out   std_logic_vector(7 downto 0);  -- TX CHG reg
        SCITrCKICC       : out   std_logic_vector(15 downto 0); -- CLKICC reg
        SCITrBAUD        : out   std_logic_vector(15 downto 0); -- BAUD reg
        SCITrVALUE       : out   std_logic_vector(7 downto 0);  -- VALUE reg
        SCITrRXCHG       : out   std_logic_vector(7 downto 0);  -- RX CHG reg
        SCITrRXBLKG      : out   std_logic_vector(7 downto 0);  -- RX BLKG reg
        SCITrRFCK        : out   std_logic_vector(15 downto 0); -- REFCLK reg
        SCITrWV          : out   std_logic_vector(7 downto 0);  -- Err Margin 
        SCITrJit         : out   std_logic_vector(15 downto 0); -- Jit value 
        SCITrJitPat      : out   std_logic_vector(9 downto 0);  -- Jit Pat reg
        SCITrRFCNTL      : out   std_logic_vector(2 downto 0);  -- REFCLK Cnt
        TrCRUpdate       : out   std_logic; -- Control reg update trigger
        TrFiLCRUpdate    : out   std_logic; -- FIFO level update trigger
        TrTXPCUpdate     : out   std_logic; -- TX Retray Reg update trigger
        TrRXPCUpdate     : out   std_logic; -- RX Retray Reg update trigger
        TrCTRLUpdate     : out   std_logic; -- Error Enable Reg trigger
        TrATUpdate       : out   std_logic; -- ATIME update trigger
        TrDTUpdate       : out   std_logic; -- DTIME update trigger
        TrTXBGUpdate     : out   std_logic; -- TX BLKG  update trigger
        TrTXCGUpdate     : out   std_logic; -- TX CHG update trigger
        TrCKICUpdate     : out   std_logic; -- CLKICC update trigger
        TrBAUDUpdate     : out   std_logic; -- BAUD update trigger
        TrVALUpdate      : out   std_logic; -- VALUE update trigger
        TrRXCGUpdate     : out   std_logic; -- RX CHG  update trigger
        TrRXBGUpdate     : out   std_logic; -- RX BLKG update trigger
        TrRFCKUpdate     : out   std_logic; -- REFCLK Reg update trigger
        TrWVUpdate       : out   std_logic; -- Error Margin Reg update trigger
        TrJitUpdate      : out   std_logic; -- Jit value Reg update trigger
        TrJitPUpdate     : out   std_logic;  -- Jit Cnt update trigger
        SCITDMACR        : out   std_logic_vector(1 downto 0) --TX DMA Clear
       );
end SciTrRegBlk;


--------------------------------------------------------------------------------
--
--                   SciTrRegBlk
--                   ===========
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This block contains the  registers for the SCI trickbox. Write data from
-- the PWDATAIn bus is clocked in when the appropriate write enable signal is
-- asserted.
--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--

architecture synth of SciTrRegBlk  is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

signal  iSCITrCR         : std_logic_vector(15 downto 0);
-- Internal copy of SCITrCR 

signal  NextSCITrCR      : std_logic_vector(15 downto 0);
-- D-input of SCITrCR 

signal  iSCITrFiLCR      : std_logic_vector(7 downto 0);
--Internal copy of SCITrFiLCR

signal  NextSCITrFiLCR   : std_logic_vector(7 downto 0);
-- D-input of SCITrFiLCR 

signal  iSCITrTXPC       : std_logic_vector(3 downto 0);
--internal copy of SCITrTXPC

signal  NextSCITrTXPC    : std_logic_vector(3 downto 0);
-- D-input of SCITrTXPC 

signal  iSCITrRXPC       : std_logic_vector(3 downto 0);
--internal copy of SCITrRXPC

signal  NextSCITrRXPC    : std_logic_vector(3 downto 0);
-- D-input of SCITrRXPC 

signal  iSCITrCTRL       : std_logic_vector(7 downto 0);
--internal copy of SCITrCTRL

signal  NextSCITrCTRL    : std_logic_vector(7 downto 0);
-- D-input of SCITrCTRL

signal  iSCITrAT         : std_logic_vector(15 downto 0);
--internal copy of SCITrAT 

signal  NextSCITrAT      : std_logic_vector(15 downto 0);
-- D-input of SCITrAT 

signal  iSCITrDT         : std_logic_vector(15 downto 0);	
--internal copy of SCITrDT

signal  NextSCITrDT      : std_logic_vector(15 downto 0);	
-- D-input of SCITrDT

signal  iSCITrTXBLKG     : std_logic_vector(7 downto 0);
--internal copy of SCITrTXBLKG

signal  NextSCITrTXBLKG  : std_logic_vector(7 downto 0);
-- D-input of SCITrTXBLKG 

signal  iSCITrTXCHG      : std_logic_vector(7 downto 0);
--internal copy of SCITrTXCHG

signal  NextSCITrTXCHG   : std_logic_vector(7 downto 0);
-- D-input of SCITrTXCHG 

signal  iSCITrCKICC      : std_logic_vector(15 downto 0);
--internal copy of SCITrCKICC

signal  NextSCITrCKICC   : std_logic_vector(15 downto 0);
-- D-input of SCITrCKICC 

signal  iSCITrBAUD       : std_logic_vector(15 downto 0);
--internal copy of SCITrBAUD

signal  NextSCITrBAUD    : std_logic_vector(15 downto 0);
-- D-input of SCITrBAUD 

signal  iSCITrVALUE      : std_logic_vector(7 downto 0);
--internal copy of SCIVALUE

signal  NextSCITrVALUE   : std_logic_vector(7 downto 0);
-- D-input of SCITrVALUE 

signal  iSCITrRXCHG      : std_logic_vector(7 downto 0);
--internal copy of SCITrRXCHG

signal  NextSCITrRXCHG   : std_logic_vector(7 downto 0);
-- D-input of SCITrRXCHG 

signal  iSCITrRXBLKG     : std_logic_vector(7 downto 0);
--internal copy of SCIBLKGUARD

signal  NextSCITrRXBLKG  : std_logic_vector(7 downto 0);
-- D-input of SCITrRXBLKG 

signal  iSCITrRFCK       : std_logic_vector(15 downto 0) := "0000000000010100";
--internal copy of SCITrRFCK

signal  NextSCITrRFCK    : std_logic_vector(15 downto 0) := "0000000000010100";
-- D-input of SCITrRFCK 

signal  iSCITrWV         : std_logic_vector(7 downto 0);
--internal copy of SCITrWV

signal  NextSCITrWV      : std_logic_vector(7 downto 0);
-- D-input of SCITrWV 

signal  iSCITrJit        : std_logic_vector(15 downto 0);
--internal copy of SCITrJit

signal  NextSCITrJit     : std_logic_vector(15 downto 0);
-- D-input of SCITrJit 

signal  iSCITrJitPat     : std_logic_vector(9 downto 0);
--internal copy of SCITrJitPat

signal  NextSCITrJitPat  : std_logic_vector(9 downto 0);
-- D-input of SCITrJitPat 

signal  iSCITrRFCNTL     : std_logic_vector(2 downto 0) := "000";
--internal copy of SCITrRFCNTL

signal  NextSCITrRFCNTL  : std_logic_vector(2 downto 0) := "000" ;
-- D-input of SCITrRFCNTL 

signal  iTrCRUpdate      : std_logic;
-- Internal copy of Update trigger for SCITrCR register

signal  NextTrCRUpdate   : std_logic;
-- D-input of iTrCRUpdate

signal  iTrTXPCUpdate    : std_logic;
-- Internal copy of Update trigger for SCITrTXPC register

signal  NextTrTXPCUpdate : std_logic;
-- D-input of iTrTXPCUpdate

signal  iTrRXPCUpdate    : std_logic;
-- Internal copy of Update trigger for SCITrRXPC register

signal  NextTrRXPCUpdate : std_logic;
-- D-input of iTrRXPCUpdate

signal  iTrCTRLUpdate    : std_logic;
-- Internal copy of Update trigger for TrCTRLUpdate register

signal  NextTrCTRLUpdate : std_logic;
-- D-input of iTrCTRLUpdate 

signal  iTrATUpdate      : std_logic;
-- Internal copy of Update trigger for SCRTrATIME register

signal  NextTrATUpdate   : std_logic;
-- D-input of iTrATUpdate

signal  iTrDTUpdate      : std_logic;	
-- Internal copy of Update trigger for SCRTrDT register

signal  NextTrDTUpdate   : std_logic;	
-- D-input of iTrDTUpdate 

signal  iTrTXBGUpdate    : std_logic;	
-- Internal copy of Update trigger for TrSCIBLKG register

signal  NextTrTXBGUpdate : std_logic;	
-- D-input of iTrTXBGUpdate

signal  iTrTXCGUpdate    : std_logic;	
-- Internal copy of Update trigger for TrSCICHG register

signal  NextTrTXCGUpdate : std_logic;	
-- D-input of iTrTXCGUpdate

signal  iTrCKICUpdate    : std_logic;	
-- Internal copy of Update trigger for TrSCICKICC register

signal  NextTrCKICUpdate : std_logic;	
-- D-input of iTrCKICUpdate

signal  iTrBAUDUpdate    : std_logic;	
-- Internal copy of Update trigger for TrSCIBAUD register

signal  NextTrBAUDUpdate : std_logic;	
-- D-input of iTrBAUDUpdate

signal  iTrVALUpdate     : std_logic;	
-- Internal copy of Update trigger for TrSCIVALUE register

signal  NextTrVALUpdate  : std_logic;	
-- D-input of iTrVALUpdate

signal  iTrRXCGUpdate    : std_logic;	
-- Internal copy of Update trigger for SCITrRXCHG register

signal  NextTrRXCGUpdate : std_logic;	
-- D-input of iTrRXCGUpdate

signal  iTrRXBGUpdate    : std_logic;	
-- Internal copy of Update trigger for SCITrRXBLKG register

signal  NextTrRXBGUpdate : std_logic;	
-- D-input of SCITrRXBGUpdate

signal  iTrRFCKUpdate    : std_logic;	
-- Internal copy of Update trigger for TrRFCKUpdate register

signal  NextTrRFCKUpdate : std_logic;	
-- D-input of SCITrRFCKUpdate

signal  iTrWVUpdate      : std_logic;	
-- Internal copy of Update trigger for TrWVUpdate register

signal  NextTrWVUpdate   : std_logic;	
-- D-input of SCITrWVUpdate

signal  iTrJitUpdate     : std_logic;	
-- Internal copy of Update trigger for TrJitUpdate register

signal  NextTrJitUpdate  : std_logic;	
-- D-input of SCITrJitUpdate

signal  iTrJitPUpdate    : std_logic;	
-- Internal copy of Update trigger for TrJitPUpdate register

signal  NextTrJitPUpdate : std_logic;	
-- D-input of SCITrJitPUpdate

signal SCITXDMACLR       : std_logic;
-- SCITXDMACLR

signal SCIRXDMACLR       : std_logic;
-- SCIRXDMACLR

signal NextSCITXDMACLR   : std_logic;
-- D-input of TXDMACLR
  
signal NextSCIRXDMACLR   : std_logic;
-- D-input of RXDMACLR

--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------

begin

-------------------------------------------------------------------------------
-- Combinational logic for all functional registers.When the respective
-- write enable input is asserted, copy the contents of the PWDATAIn bus into
-- the corresponding registers. 
-------------------------------------------------------------------------------

NextSCITrCR        <= PWDATAIn(15 downto 0)  when (SCITrCRWrEn = '1')  
                   else
                      iSCITrCR;   

NextSCITrFiLCR     <= PWDATAIn(7 downto 0)   when (SCITrFiLCRWrEn = '1')  
                   else
                      iSCITrFiLCR;   

NextSCITrTXPC      <= PWDATAIn(3 downto 0)   when (SCITrTXPCWrEn = '1')       
                   else
                      iSCITrTXPC;      

NextSCITrRXPC      <= PWDATAIn(3 downto 0)   when (SCITrRXPCWrEn = '1')       
                   else
                      iSCITrRXPC;      

NextSCITrCTRL      <= PWDATAIn(7 downto 0)   when (SCITrCTRLWrEn = '1')
                   else
                      iSCITrCTRL;

NextSCITrAT        <= PWDATAIn(15 downto 0)  when (SCITrATWrEn = '1')
                   else
                      iSCITrAT;

NextSCITrDT        <= PWDATAIn(15 downto 0)  when (SCITrDTWrEn = '1')
                   else
                      iSCITrDT;

NextSCITrTXBLKG    <= PWDATAIn(7 downto 0)   when (SCITrTXBLKGWrEn = '1')
                   else
                      iSCITrTXBLKG;

NextSCITrTXCHG     <= PWDATAIn(7 downto 0)   when (SCITrTXCHGWrEn = '1')
                   else
                      iSCITrTXCHG;

NextSCITrCKICC     <= PWDATAIn(15 downto 0)  when (SCITrCKICCWrEn = '1')
                   else
                      iSCITrCKICC; 

NextSCITrBAUD      <= PWDATAIn(15 downto 0)  when (SCITrBAUDWrEn = '1')
                   else
                      iSCITrBAUD; 

NextSCITrVALUE     <= PWDATAIn(7 downto 0)   when (SCITrVALUEWrEn = '1')
                   else
                      iSCITrVALUE; 

NextSCITrRXCHG     <= PWDATAIn(7 downto 0)   when (SCITrRXCHGWrEn = '1')
                   else
                      iSCITrRXCHG;

NextSCITrRXBLKG    <= PWDATAIn(7 downto 0)   when (SCITrRXBLKGWrEn = '1')
                   else
                      iSCITrRXBLKG; 

NextSCITrRFCK      <= PWDATAIn(15 downto 0)  when (SCITrRFCKWrEn = '1')
                   else
                      iSCITrRFCK; 

NextSCITrWV        <= PWDATAIn(7 downto 0)   when (SCITrWVWrEn = '1')
                   else
                      iSCITrWV; 

NextSCITrJit       <= PWDATAIn(15 downto 0)  when (SCITrJitWrEn = '1')
                   else
                      iSCITrJit; 

NextSCITrJitPat    <= PWDATAIn(9 downto 0)   when (SCITrJitPatWrEn = '1')
                   else
                      iSCITrJitPat; 

NextSCITrRFCNTL    <= PWDATAIn(2 downto 0)   when (SCITrRFCNTLWrEn = '1')
                   else
                      iSCITrRFCNTL; 

-------------------------------------------------------------------------------
-- Sequential process for all functional registers.
-------------------------------------------------------------------------------
p_Seq : process(PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iSCITrCR       <= "0000000000000000";	
    iSCITrFiLCR    <= "00000000";
    iSCITrTXPC     <= "0000";
    iSCITrRXPC     <= "0000";
    iSCITrCTRL     <= "00000000";
    iSCITrAT       <= "0000000000000000";	
    iSCITrDT       <= "0000000000000000";	
    iSCITrTXBLKG   <= "00000000";	
    iSCITrTXCHG    <= "00000000";	
    iSCITrCKICC    <= "0000000000000000";	
    iSCITrBAUD     <= "0000000000000000";	
    iSCITrVALUE    <= "00000000";	
    iSCITrRXCHG    <= "00000000";	
    iSCITrRXBLKG   <= "00000000";	
    iSCITrRFCK     <= "0000000000010100"; 
    iSCITrWV       <= "00000000";	
    iSCITrJit      <= "0000000000000000";	
    iSCITrJitPat   <= "0000000000";	
    iSCITrRFCNTL   <= "000";	
  elsif (PCLK'event and PCLK = '1') then
    iSCITrCR       <= NextSCITrCR;
    iSCITrFiLCR    <= NextSCITrFiLCR;
    iSCITrTXPC     <= NextSCITrTXPC;
    iSCITrRXPC     <= NextSCITrRXPC;
    iSCITrCTRL     <= NextSCITrCTRL;
    iSCITrAT       <= NextSCITrAT;
    iSCITrDT       <= NextSCITrDT;
    iSCITrTXBLKG   <= NextSCITrTXBLKG;
    iSCITrTXCHG    <= NextSCITrTXCHG;
    iSCITrCKICC    <= NextSCITrCKICC;
    iSCITrBAUD     <= NextSCITrBAUD;
    iSCITrVALUE    <= NextSCITrVALUE;
    iSCITrRXCHG    <= NextSCITrRXCHG;
    iSCITrRXBLKG   <= NextSCITrRXBLKG;
    iSCITrRFCK     <= NextSCITrRFCK;	
    iSCITrWV       <= NextSCITrWV;	
    iSCITrJit      <= NextSCITrJit;	
    iSCITrJitPat   <= NextSCITrJitPat;	
    iSCITrRFCNTL   <= NextSCITrRFCNTL;	
  end if;
end process p_Seq;

-------------------------------------------------------------------------------
-- Update signal of registers toggles with their corresponding 
-- write to the registers.
-------------------------------------------------------------------------------

NextTrCRUpdate       <= not(iTrCRUpdate)   when (SCITrCRWrEn = '1')  
                     else
                        iTrCRUpdate;   

NextTrTXPCUpdate     <= not(iTrTXPCUpdate) when (SCITrTXPCWrEn = '1')  
                     else
                        iTrTXPCUpdate;   

NextTrRXPCUpdate     <= not(iTrRXPCUpdate) when (SCITrRXPCWrEn = '1')  
                     else
                        iTrRXPCUpdate;   

NextTrCTRLUpdate     <= not(iTrCTRLUpdate) when (SCITrCTRLWrEn = '1')  
                     else
                        iTrCTRLUpdate;   

NextTrATUpdate       <= not(iTrATUpdate)   when (SCITrATWrEn = '1')
                     else
                        iTrATUpdate;

NextTrDTUpdate       <= not(iTrDTUpdate)   when (SCITrDTWrEn = '1')
                     else
                        iTrDTUpdate;

NextTrTXBGUpdate     <= not(iTrTXBGUpdate) when (SCITrTXBLKGWrEn = '1')
                     else
                        iTrTXBGUpdate;

NextTrTXCGUpdate     <= not(iTrTXCGUpdate) when (SCITrTXCHGWrEn = '1')
                     else
                        iTrTXCGUpdate;

NextTrCKICUpdate     <= not(iTrCKICUpdate) when (SCITrCKICCWrEn = '1')
                     else
                        iTrCKICUpdate; 

NextTrBAUDUpdate     <= not(iTrBAUDUpdate) when (SCITrBAUDWrEn = '1')
                     else
                        iTrBAUDUpdate; 

NextTrVALUpdate      <= not(iTrVALUpdate)  when (SCITrVALUEWrEn = '1')
                     else
                        iTrVALUpdate; 

NextTrRXCGUpdate     <= not(iTrRXCGUpdate) when (SCITrRXCHGWrEn = '1')
                     else
                        iTrRXCGUpdate;

NextTrRXBGUpdate     <= not(iTrRXBGUpdate) when (SCITrRXBLKGWrEn = '1')
                     else
                        iTrRXBGUpdate; 

NextTrRFCKUpdate     <= not(iTrRFCKUpdate) when (SCITrRFCKWrEn = '1')
                     else
                        iTrRFCKUpdate; 

NextTrWVUpdate       <= not(iTrWVUpdate)   when (SCITrWVWrEn = '1')
                     else
                        iTrWVUpdate; 

NextTrJitUpdate      <= not(iTrJitUpdate)  when (SCITrJitWrEn = '1')
                     else
                        iTrJitUpdate; 

NextTrJitPUpdate     <= not(iTrJitPUpdate) when (SCITrJitPatWrEn = '1')
                     else
                        iTrJitPUpdate; 

-------------------------------------------------------------------------------
-- Sequential process for all Updates.
-------------------------------------------------------------------------------
p_UpdateSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iTrCRUpdate      <= '0';
    iTrTXPCUpdate    <= '0';
    iTrRXPCUpdate    <= '0';
    iTrCTRLUpdate    <= '0';
    iTrATUpdate      <= '0';
    iTrDTUpdate      <= '0';	
    iTrTXBGUpdate    <= '0';	
    iTrTXCGUpdate    <= '0';	
    iTrCKICUpdate    <= '0';	
    iTrBAUDUpdate    <= '0';	
    iTrVALUpdate     <= '0';	
    iTrRXCGUpdate    <= '0';	
    iTrRXBGUpdate    <= '0';	
    iTrRFCKUpdate    <= '0';	
    iTrWVUpdate      <= '0';	
    iTrJitUpdate     <= '0';	
    iTrJitPUpdate    <= '0';	
  elsif (PCLK'event and PCLK = '1') then
    iTrCRUpdate      <= NextTrCRUpdate;
    iTrTXPCUpdate    <= NextTrTXPCUpdate;
    iTrRXPCUpdate    <= NextTrRXPCUpdate;
    iTrCTRLUpdate    <= NextTrCTRLUpdate;
    iTrATUpdate      <= NextTrATUpdate;
    iTrDTUpdate      <= NextTrDTUpdate;
    iTrTXBGUpdate    <= NextTrTXBGUpdate;
    iTrTXCGUpdate    <= NextTrTXCGUpdate;
    iTrCKICUpdate    <= NextTrCKICUpdate;
    iTrBAUDUpdate    <= NextTrBAUDUpdate;
    iTrVALUpdate     <= NextTrVALUpdate;
    iTrRXCGUpdate    <= NextTrRXCGUpdate;
    iTrRXBGUpdate    <= NextTrRXBGUpdate;
    iTrRFCKUpdate    <= NextTrRFCKUpdate;
    iTrWVUpdate      <= NextTrWVUpdate;
    iTrJitUpdate     <= NextTrJitUpdate;
    iTrJitPUpdate    <= NextTrJitPUpdate;
  end if;
end process p_UpdateSeq;

-- ----------------------------------------------------------------------------
-- Clock PWDATAIn into SCITXDMACLR when SCITrDMAWr is asserted, TX
-- ----------------------------------------------------------------------------
p_TXDMAComb : process (SCITrDMAWr, SCITXDMACLR, PWDATAIn, SCITXDMACLRStag2) 
begin
  NextSCITXDMACLR <= SCITXDMACLR;
 
  if (SCITrDMAWr = '1') then
    NextSCITXDMACLR <= PWDATAIn(1);
  elsif (SCITXDMACLRStag2 = '1') then
    NextSCITXDMACLR <= '0';
  end if;
end process p_TXDMAComb;

-- ----------------------------------------------------------------------------
-- Sequential process for SCITDMACR
-- ----------------------------------------------------------------------------
p_TXDMASeq : process (PCLK, PRESETn) 
begin
  if (PRESETn = '0') then 
    SCITXDMACLR <=  '0';
  elsif (PCLK'event and PCLK = '1') then
    SCITXDMACLR <= NextSCITXDMACLR;
  end if;
end process p_TXDMASeq;

-- ----------------------------------------------------------------------------
-- Clock PWDATAIn into SCITDMACR when SCITrDMAWr is asserted, RX
-- ----------------------------------------------------------------------------
p_RXDMAComb : process (SCITrDMAWr, SCIRXDMACLR, PWDATAIn, SCIRXDMACLRStag2) 
begin
  NextSCIRXDMACLR <= SCIRXDMACLR;
 
  if (SCITrDMAWr = '1') then
    NextSCIRXDMACLR <= PWDATAIn(0);
  elsif (SCIRXDMACLRStag2 = '1') then
    NextSCIRXDMACLR <= '0';
  end if;
end process p_RXDMAComb;

-- ----------------------------------------------------------------------------
-- Sequential process for SCITDMACR
-- ----------------------------------------------------------------------------
p_RXDMASeq : process (PCLK, PRESETn) 
begin
  if (PRESETn = '0') then
    SCIRXDMACLR <= '0';
  elsif (PCLK'event and PCLK = '1') then
    SCIRXDMACLR <= NextSCIRXDMACLR;
  end if;
end process p_RXDMASeq;
-------------------------------------------------------------------------------
-- Connect local copies to outputs
-------------------------------------------------------------------------------

SCITrCR        <= iSCITrCR;

SCITrFiLCR     <= iSCITrFiLCR;

SCITrTXPC      <= iSCITrTXPC;

SCITrRXPC      <= iSCITrRXPC;

SCITrCTRL      <= iSCITrCTRL;

SCITrAT        <= iSCITrAT;

SCITrDT        <= iSCITrDT;

SCITrTXBLKG    <= iSCITrTXBLKG;

SCITrTXCHG     <= iSCITrTXCHG;

SCITrCKICC     <= iSCITrCKICC;

SCITrBAUD      <= iSCITrBAUD;

SCITrVALUE     <= iSCITrVALUE;

SCITrRXCHG     <= iSCITrRXCHG;

SCITrRXBLKG    <= iSCITrRXBLKG;

SCITrRFCK      <= iSCITrRFCK;

SCITrWV        <= iSCITrWV;

SCITrJit       <= iSCITrJit;

SCITrJitPat    <= iSCITrJitPat;

SCITrRFCNTL    <= iSCITrRFCNTL;

TrCRUpdate     <= iTrCRUpdate;

TrTXPCUpdate   <= iTrTXPCUpdate;

TrRXPCUpdate   <= iTrRXPCUpdate;

TrCTRLUpdate   <= iTrCTRLUpdate;

TrATUpdate     <= iTrATUpdate;

TrDTUpdate     <= iTrDTUpdate;

TrTXBGUpdate   <= iTrTXBGUpdate;

TrTXCGUpdate   <= iTrTXCGUpdate;

TrCKICUpdate   <= iTrCKICUpdate;

TrBAUDUpdate   <= iTrBAUDUpdate;

TrVALUpdate    <= iTrVALUpdate;

TrRXCGUpdate   <= iTrRXCGUpdate;

TrRXBGUpdate   <= iTrRXBGUpdate;

TrRFCKUpdate   <= iTrRFCKUpdate;

TrWVUpdate     <= iTrWVUpdate;

TrJitUpdate    <= iTrJitUpdate;

TrJitPUpdate   <= iTrJitPUpdate;

SCITDMACR(1)   <= SCITXDMACLR;
SCITDMACR(0)   <= SCIRXDMACLR;

end synth;

--=================================== End === ==============================--
