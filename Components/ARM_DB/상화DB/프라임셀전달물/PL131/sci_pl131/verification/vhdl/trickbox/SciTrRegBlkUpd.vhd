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
--  File Name              : SciTrRegBlkUpd.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block contains second stage buffer of registers
--               whose contents need to be updated in SCIREFCLK-domain
--
-- --=========================================================================--
  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--------------------------------------------------------------------------------

entity SciTrRegBlkUpd is
  port (
        SCICLK           : in    std_logic; -- SCI Reference Clock
        PRESETn          : in    std_logic; -- Reset input
        TrCRUpdSync      : in    std_logic; -- Sync for TrCRUpdate 
        TrTXPCUpdSync    : in    std_logic; -- Sync for TrTXPCUpdate
        TrRXPCUpdSync    : in    std_logic; -- Sync for TrRXPCUpdate
        TrCTRLUpdSync    : in    std_logic; -- Sync for TrCTRLUpdate
        TrATUpdSync      : in    std_logic; -- Sync for ATUpdate
        TrDTUpdSync      : in    std_logic; -- Sync for DTUpdate
        TrTXBLKGUpdSync  : in    std_logic; -- Sync for TXBLKGUpdat
        TrTXCHGUpdSync   : in    std_logic; -- Sync for TXCHTGUpdate
        TrCKICCUpdSync   : in    std_logic; -- Sync for CLKICCUpdat
        TrBAUDUpdSync    : in    std_logic; -- Sync for BAUDUpdate
        TrVALUEUpdSync   : in    std_logic; -- Sync for VALUEUpdate
        TrRXCHGUpdSync   : in    std_logic; -- Sync for RXCHGUpdate
        TrRXBLKGUpdSync  : in    std_logic; -- Sync for RXBLKGUpdate
        TrJitUpdSync     : in    std_logic; -- Sync for JitUpdate
        TrJitPatUpdSync  : in    std_logic; -- Sync for JitPatUpdate
        SCITrCR          : in    std_logic_vector(15 downto 0); -- I stg CR
        SCITrTXPC        : in    std_logic_vector(3 downto 0);  -- I stg TXRET 
        SCITrRXPC        : in    std_logic_vector(3 downto 0);  -- I stg RXRET
        SCITrCTRL        : in    std_logic_vector(7 downto 0);  -- I stg ErEn
        SCITrAT          : in    std_logic_vector(15 downto 0); -- I stg ATIME
        SCITrDT          : in    std_logic_vector(15 downto 0); -- I stg DTIME
        SCITrTXBLKG      : in    std_logic_vector(7 downto 0);  -- I stg TXBLKG
        SCITrTXCHG       : in    std_logic_vector(7 downto 0);  -- I stg TXCHG
        SCITrCKICC       : in    std_logic_vector(15 downto 0); -- I stg CLKIC
        SCITrBAUD        : in    std_logic_vector(15 downto 0); -- I stg BAUD
        SCITrVALUE       : in    std_logic_vector(7 downto 0);  -- I stg VALUE
        SCITrRXCHG       : in    std_logic_vector(7 downto 0);  -- I stg RXCHG
        SCITrRXBLKG      : in    std_logic_vector(7 downto 0);  -- I stg RXBLKG
        SCITrJit         : in    std_logic_vector(15 downto 0); -- I stg Jit
        SCITrJitPat      : in    std_logic_vector(9 downto 0);  -- I stg JitCnt
        SCICLKErEn       : out   std_logic; -- SCICLK Er massege En	
        TXPtimErEn       : out   std_logic; -- TXPtim Er massege En 
        TXPErEn          : out   std_logic; -- TXPEr  Er massege En 
        TXPtimWdErEn     : out   std_logic; -- TXPtimWd Er massege En 
        RXPErEn          : out   std_logic; -- RXPEr massege En 
        RXCtimErEn       : out   std_logic; -- RXCtimEr massege En 
        RXBtimErEn       : out   std_logic; -- RXBtimEr massege En 
        StartBitErEn     : out   std_logic; -- StartBitEr massege En 
        TrBoxEn          : out   std_logic; -- Trickbox enable
        TrTXEn           : out   std_logic; -- Transmit enable 
        TrRXEn           : out   std_logic; -- Receive enable
        TrDebugEn        : out   std_logic; -- Debug message on
        TrCDETEn         : out   std_logic; -- Card DETECT En
        TrTXPEn          : out   std_logic; -- TXP force Error enable
        TrRXPEn          : out   std_logic; -- RXP force Error enable 
        TrTXPStEn        : out   std_logic; -- TX parity state
        TrRXPStEn        : out   std_logic; -- RX parity state
        TrTXNAKEn        : out   std_logic; -- TX hand shaking on
        TrRXNAKEn        : out   std_logic; -- RX hand shaking on
        SCIDEACREQ       : out   std_logic; -- SCI deactivation Req
        TrDackREn        : out   std_logic; -- SCI deactivation read
        SCANMODE         : out   std_logic; -- scanmode enable
        nSCIRST          : out   std_logic; -- reset
        TrSENSE          : out   std_logic; -- Data line SENSE
        TrSCICLKEn       : out   std_logic; -- SCICLKOUT from trickbox enable
        TrRSyTXPC        : out   std_logic_vector(3 downto 0);  -- II stg TXTRY
        TrRSyRXPC        : out   std_logic_vector(3 downto 0);  -- II stg RXTRY
        TrRSyAT          : out   std_logic_vector(15 downto 0); -- II stg ATIME
        TrRSyDT          : out   std_logic_vector(15 downto 0); -- II stg DTIME
        TrTXRSyBLKG      : out   std_logic_vector(7 downto 0);  -- II stg TXBG
        TrTXRSyCHG       : out   std_logic_vector(7 downto 0);  -- II stg TXCHG
        TrRSyCKICC       : out   std_logic_vector(15 downto 0); -- II stg CLKICC
        TrRSyBAUD        : out   std_logic_vector(15 downto 0); -- II stg BAUD
        TrRSyVALUE       : out   std_logic_vector(7 downto 0);  -- II stg VALUE
        TrRXRSyCHG       : out   std_logic_vector(7 downto 0);  -- II stg RXCHG
        TrRXRSyBLKG      : out   std_logic_vector(7 downto 0);  -- II stg RXBG
        TrRSyRFCK        : out   std_logic_vector(7 downto 0);  -- II stg REFCK
        TrRSyWV          : out   std_logic_vector(7 downto 0);  -- II stg WV
        TrRSyJit         : out   std_logic_vector(15 downto 0); -- II stg JitP
        TrRSyJitPat      : out   std_logic_vector(9 downto 0)   -- II stg JitCt
       );
end SciTrRegBlkUpd;

--------------------------------------------------------------------------------
--
--                   SciTrRegBlkUpd
--                   ===============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module contains the second stage buffers for the 
-- registers. 
-- Data on the corresponding first stage inputs are clocked into the 
-- second stage buffers when their corresponding WrEn signals are 
-- asserted. The WrEn signals are generated by XORing the UpdateSync 
-- input with the internal delayed version of that signal. 
--
--
--------------------------------------------------------------------------------

--=============================== ARCHITECTURE ===============================--

architecture synth of SciTrRegBlkUpd  is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

signal TrRSyCR         : std_logic_vector(15 downto 0);
-- 2nd stage buffer for SCITrCR

signal NextTrRSyCR     : std_logic_vector(15 downto 0);
-- D-input for SCITrCR

signal iTrRSyTXPC      : std_logic_vector(3 downto 0);
-- 2nd stage buffer for SCITrTXPC

signal NextTrRSyTXPC   : std_logic_vector(3 downto 0);
-- D-input for SCITrTXPC

signal iTrRSyRXPC      : std_logic_vector(3 downto 0);
-- 2nd stage buffer for SCITrRXPC

signal NextTrRSyRXPC   : std_logic_vector(3 downto 0);
-- D-input for SCITrRXPC

signal iTrRSyCTRL      : std_logic_vector(7 downto 0);
-- 2nd stage buffer for TrCTRL

signal NextTrRSyCTRL   : std_logic_vector(7 downto 0);
-- D-input for TrCTRL

signal iTrRSyAT        : std_logic_vector(15 downto 0);
-- 2nd stage buffer for SCIATIME

signal NextTrRSyAT     : std_logic_vector(15 downto 0);
-- D-input for SCITrAT

signal iTrRSyDT        : std_logic_vector(15 downto 0);
-- 2nd stage buffer for SCITrDT

signal NextTrRSyDT     : std_logic_vector(15 downto 0);
-- D-input for SCITrDT

signal iTrTXRSyBLKG    : std_logic_vector(7 downto 0);
-- 2nd stage buffer for SCITrTXBLKG

signal NextTrTXRSyBLKG : std_logic_vector(7 downto 0);
-- D-input for SCITrTXBLKG

signal iTrTXRSyCHG     : std_logic_vector(7 downto 0);
-- 2nd stage buffer for SCITrTXCHG

signal NextTrTXRSyCHG  : std_logic_vector(7 downto 0);
-- D-input for SCITrTXCHG

signal iTrRSyCKICC     : std_logic_vector(15 downto 0);
-- 2nd stage buffer for SCITrCKICC

signal NextTrRSyCKICC  : std_logic_vector(15 downto 0);
-- D-input for SCITrCKICC

signal iTrRSyBAUD      : std_logic_vector(15 downto 0);
-- 2nd stage buffer for SCITrBAUD

signal NextTrRSyBAUD   : std_logic_vector(15 downto 0);
-- D-input for SCITrBAUD

signal iTrRSyVALUE     : std_logic_vector(7 downto 0);
-- 2nd stage buffer for SCITrRSyVALUE

signal NextTrRSyVALUE  : std_logic_vector(7 downto 0);
-- D-input for VALUE

signal iTrRXRSyCHG     : std_logic_vector(7 downto 0);
-- 2nd stage buffer for SCITrRXCHG

signal NextTrRXRSyCHG  : std_logic_vector(7 downto 0);
-- D-input for SCITrRXCHG

signal iTrRXRSyBLKG    : std_logic_vector(7 downto 0);
-- 2nd stage buffer for SCITrRXBLKG

signal NextTrRXRSyBLKG : std_logic_vector(7 downto 0);
-- D-input for SCITrRXBLKG

signal iTrRSyJit       : std_logic_vector(15 downto 0);
-- 2nd stage buffer for SCITrJit

signal NextTrRSyJit    : std_logic_vector(15 downto 0);
-- D-input for SCITrJit

signal iTrRSyJitPat    : std_logic_vector(9 downto 0);
-- 2nd stage buffer for SCITrJitPat

signal NextTrRSyJitPat : std_logic_vector(9 downto 0);
-- D-input for SCITrJitPat

--------------------------------------------------------------------------------
-- Delayed version of UpdateSyncs 
--------------------------------------------------------------------------------

signal DTrCRUpdtSyn     : std_logic;
-- Delayed version of TrCRUpdSync

signal DTrTXPCUpdtSyn   : std_logic;	
-- Delayed version of TrTXPCUpdSync	

signal DTrRXPCUpdtSyn   : std_logic;	
-- Delayed version of TrRXPCUpdSync	

signal DTrCTRLUpdtSyn   : std_logic;	
-- Delayed version of TrCTRLUpdSync	

signal DTrATUpdtSyn     : std_logic;	
-- Delayed version of TrATUpdSync	

signal DTrDTUpdtSyn     : std_logic;	
-- Delayed version of TrDTUpdSync	

signal DTrTXBLKGUpdtSyn : std_logic;	
-- Delayed version of TrTXBLKGUpdSync	

signal DTrTXCHGUpdtSyn  : std_logic;	
-- Delayed version of TrTXCHGUpdSync	

signal DTrCKICCUpdtSyn  : std_logic;	
-- Delayed version of TrCKICCUpdSync	

signal DTrBAUDUpdtSyn   : std_logic;	
-- Delayed version of TrBAUDUpdSync	

signal DTrVALUEUpdtSyn  : std_logic;	
-- Delayed version of TrVALUEUpdSync	

signal DTrRXCHGUpdtSyn  : std_logic;	
-- Delayed version of TrRXCHGUpdSync	

signal DTrRXBLKGUpdtSyn : std_logic;	
-- Delayed version of TrRXBLKGUpdSync

signal DTrJitUpdtSyn    : std_logic;	
-- Delayed version of TrJitUpdSync

signal DTrJitPatUpdtSyn : std_logic;	
-- Delayed version of TrJitPatUpdSync

--------------------------------------------------------------------------------
-- Load signals for second stage buffers 
--------------------------------------------------------------------------------
signal TrRSyCRWrEn      : std_logic;
-- Load signal for 2nd stage SCITrCR buffer 

signal TrRSyTXPCWrEn    : std_logic;	
-- Load signal for 2nd stage SCITrTXPC buffer

signal TrRSyRXPCWrEn    : std_logic;	
-- Load signal for 2nd stage SCITrRXPC buffer

signal TrRSyCTRLWrEn    : std_logic;	
-- Load signal for 2nd stage SCITrCTRL buffer

signal TrRSyATWrEn      : std_logic;
-- Load signal for 2nd stage SCITrAT buffer

signal TrRSyDTWrEn      : std_logic;
-- Load signal for 2nd stage SCITrDT buffer

signal TrTXRSyBLKGWrEn  : std_logic;
-- Load signal for 2nd stage buffer SCITrTXBLKG buffer

signal TrTXRSyCHGWrEn   : std_logic;
-- Load signal for 2nd stage SCITrTXCHG buffer

signal TrRSyCKICCWrEn   : std_logic;	
-- Load signal for 2nd stage SCITrCKICC buffer

signal TrRSyBAUDWrEn    : std_logic;
-- Load signal for 2nd stage SCITrBAUD buffer

signal TrRSyVALUEWrEn   : std_logic;	
-- Load signal for 2nd stage SCITrVALUE buffer

signal TrRXRSyCHGWrEn   : std_logic;
-- Load signal for 2nd stage SCITrRXCHG buffer

signal TrRXRSyBLKGWrEn  : std_logic;	
-- Load signal for 2nd stage SCITrRXBLKG buffer

signal TrRSyJitWrEn     : std_logic;	
-- Load signal for 2nd stage SCITrJit buffer

signal TrRSyJitPatWrEn  : std_logic;	
-- Load signal for 2nd stage SCITrJitPat buffer

--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Generation of delayed versions of the Update trigger inputs.
--------------------------------------------------------------------------------
p_DelUpdateSeq : process (SCICLK, PRESETn)
begin
  if (PRESETn = '0') then
    DTrCRUpdtSyn     <= '0';
    DTrTXPCUpdtSyn   <= '0';
    DTrRXPCUpdtSyn   <= '0';
    DTrCTRLUpdtSyn   <= '0';
    DTrATUpdtSyn     <= '0';	
    DTrDTUpdtSyn     <= '0';	
    DTrTXBLKGUpdtSyn <= '0';	
    DTrTXCHGUpdtSyn  <= '0';	
    DTrCKICCUpdtSyn  <= '0';	
    DTrBAUDUpdtSyn   <= '0';	
    DTrVALUEUpdtSyn  <= '0';	
    DTrRXCHGUpdtSyn  <= '0';	
    DTrRXBLKGUpdtSyn <= '0';	
  elsif (SCICLK'event and SCICLK = '1') then
    DTrCRUpdtSyn     <= TrCRUpdSync;
    DTrTXPCUpdtSyn   <= TrTXPCUpdSync;	
    DTrRXPCUpdtSyn   <= TrRXPCUpdSync;	
    DTrCTRLUpdtSyn   <= TrCTRLUpdSync;	
    DTrATUpdtSyn     <= TrATUpdSync;
    DTrDTUpdtSyn     <= TrDTUpdSync;	
    DTrTXBLKGUpdtSyn <= TrTXBLKGUpdSync;	
    DTrTXCHGUpdtSyn  <= TrTXCHGUpdSync;	
    DTrCKICCUpdtSyn  <= TrCKICCUpdSync;	
    DTrBAUDUpdtSyn   <= TrBAUDUpdSync;	
    DTrVALUEUpdtSyn  <= TrVALUEUpdSync;	
    DTrRXCHGUpdtSyn  <= TrRXCHGUpdSync;	
    DTrRXBLKGUpdtSyn <= TrRXBLKGUpdSync;	
    DTrJitUpdtSyn    <= TrJitUpdSync;	
    DTrJitPatUpdtSyn <= TrJitPatUpdSync;	
  end if;
end process p_DelUpdateSeq;

--------------------------------------------------------------------------------
-- Generation of load signals for the second stage buffers.
--------------------------------------------------------------------------------
TrRSyCRWrEn       <= DTrCRUpdtSyn     xor TrCRUpdSync;

TrRSyTXPCWrEn     <= DTrTXPCUpdtSyn   xor TrTXPCUpdSync;	

TrRSyRXPCWrEn     <= DTrRXPCUpdtSyn   xor TrRXPCUpdSync;	

TrRSyCTRLWrEn     <= DTrCTRLUpdtSyn   xor TrCTRLUpdSync;	

TrRSyATWrEn       <= DTrATUpdtSyn     xor TrATUpdSync;

TrRSyDTWrEn       <= DTrDTUpdtSyn     xor TrDTUpdSync;	

TrTXRSyBLKGWrEn   <= DTrTXBLKGUpdtSyn xor TrTXBLKGUpdSync;	

TrTXRSyCHGWrEn    <= DTrTXCHGUpdtSyn  xor TrTXCHGUpdSync;	

TrRSyCKICCWrEn    <= DTrCKICCUpdtSyn  xor TrCKICCUpdSync;	

TrRSyBAUDWrEn     <= DTrBAUDUpdtSyn   xor TrBAUDUpdSync;	

TrRSyVALUEWrEn    <= DTrVALUEUpdtSyn  xor TrVALUEUpdSync;	

TrRXRSyCHGWrEn    <= DTrRXCHGUpdtSyn  xor TrRXCHGUpdSync;	

TrRXRSyBLKGWrEn   <= DTrRXBLKGUpdtSyn xor TrRXBLKGUpdSync;	

TrRSyJitWrEn      <= DTrJitUpdtSyn    xor TrJitUpdSync;

TrRSyJitPatWrEn   <= DTrJitPatUpdtSyn xor TrJitPatUpdSync;

--------------------------------------------------------------------------------
-- Write into the second stage buffers.
--------------------------------------------------------------------------------
  
NextTrRSyCR         <= SCITrCR     when (TrRSyCRWrEn = '1')
                    else
                       TrRSyCR; 

NextTrRSyTXPC       <= SCITrTXPC   when (TrRSyTXPCWrEn = '1')
                    else
                       iTrRSyTXPC; 

NextTrRSyRXPC       <= SCITrRXPC   when (TrRSyRXPCWrEn = '1')
                    else
                       iTrRSyRXPC; 

NextTrRSyCTRL       <= SCITrCTRL   when (TrRSyCTRLWrEn = '1')
                    else
                       iTrRSyCTRL; 

NextTrRSyAT         <= SCITrAT     when (TrRSyATWrEn = '1')
                    else
                       iTrRSyAT; 

NextTrRSyDT         <= SCITrDT     when (TrRSyDTWrEn = '1')
                    else
                       iTrRSyDT; 

NextTrTXRSyBLKG     <= SCITrTXBLKG when (TrTXRSyBLKGWrEn = '1')
                    else
                       iTrTXRSyBLKG; 

NextTrTXRSyCHG      <= SCITrTXCHG  when (TrTXRSyCHGWrEn = '1')
                    else
                       iTrTXRSyCHG; 

NextTrRSyCKICC      <= SCITrCKICC  when (TrRSyCKICCWrEn = '1')
                    else
                       iTrRSyCKICC; 

NextTrRSyBAUD       <= SCITrBAUD   when (TrRSyBAUDWrEn = '1')
                    else
                       iTrRSyBAUD; 

NextTrRSyVALUE      <= SCITrVALUE  when (TrRSyVALUEWrEn = '1')
                    else
                       iTrRSyVALUE; 

NextTrRXRSyCHG      <= SCITrRXCHG  when (TrRXRSyCHGWrEn = '1')
                    else
                       iTrRXRSyCHG; 

NextTrRXRSyBLKG     <= SCITrRXBLKG when (TrRXRSyBLKGWrEn = '1')
                    else
                       iTrRXRSyBLKG; 

NextTrRSyJit        <= SCITrJit    when (TrRSyJitWrEn = '1')
                    else
                       iTrRSyJit; 

NextTrRSyJitPat     <= SCITrJitPat when (TrRSyJitPatWrEn = '1')
                    else
                       iTrRSyJitPat; 


--------------------------------------------------------------------------------
-- Sequential process for write
--------------------------------------------------------------------------------
p_RegWrSeq : process(SCICLK, PRESETn)
begin
  if (PRESETn = '0') then
    TrRSyCR      <= "0000000000000000"; 
    iTrRSyTXPC   <= "0000"; 
    iTrRSyRXPC   <= "0000"; 
    iTrRSyCTRL   <= "00000000"; 
    iTrRSyAT     <= "0000000000000000"; 
    iTrRSyDT     <= "0000000000000000"; 
    iTrTXRSyBLKG <= "00000000"; 
    iTrTXRSyCHG  <= "00000000"; 
    iTrRSyCKICC  <= "0000000000000000"; 
    iTrRSyBAUD   <= "0000000000000000"; 
    iTrRSyVALUE  <= "00000000"; 
    iTrRXRSyCHG  <= "00000000"; 
    iTrRXRSyBLKG <= "00000000"; 
    iTrRSyJit    <= "0000000000000000"; 
    iTrRSyJitPat <= "0000000000"; 
  elsif (SCICLK' event and SCICLK = '1') then
    TrRSyCR      <=  NextTrRSyCR;
    iTrRSyTXPC   <=  NextTrRSyTXPC;
    iTrRSyRXPC   <=  NextTrRSyRXPC;
    iTrRSyCTRL   <=  NextTrRSyCTRL;
    iTrRSyAT     <=  NextTrRSyAT;
    iTrRSyDT     <=  NextTrRSyDT;
    iTrTXRSyBLKG <=  NextTrTXRSyBLKG;
    iTrTXRSyCHG  <=  NextTrTXRSyCHG;
    iTrRSyCKICC  <=  NextTrRSyCKICC;
    iTrRSyBAUD   <=  NextTrRSyBAUD;
    iTrRSyVALUE  <=  NextTrRSyVALUE;
    iTrRXRSyCHG  <=  NextTrRXRSyCHG;
    iTrRXRSyBLKG <=  NextTrRXRSyBLKG;
    iTrRSyJit    <=  NextTrRSyJit;
    iTrRSyjitPat <=  NextTrRSyJitPat;
  end if;  
end process p_RegWrSeq; 

--------------------------------------------------------------------------------
-- Generation of Control signals for Trick Box and Error message Enable 
--------------------------------------------------------------------------------
TrBoxEn      <= TrRSyCR(0);
TrTXEn       <= TrRSyCR(1);
TrRXEn       <= TrRSyCR(2);
TrDebugEn    <= TrRSyCR(3);
TrCDETEn     <= TrRSyCR(4);
TrTXPEn      <= TrRSyCR(5);
TrRXPEn      <= TrRSyCR(6);
TrTXPStEn    <= TrRSyCR(7);
TrRXPStEn    <= TrRSyCR(8);
TrTXNAKEn    <= TrRSyCR(9);
TrRXNAKEn    <= TrRSyCR(10);
SCIDEACREQ   <= TrRSyCR(11);
SCANMODE     <= TrRSyCR(12);
nSCIRST      <= TrRSyCR(13);
TrSENSE      <= TrRSyCR(14);
TrSCICLKEn   <= TrRSyCR(15);
SCICLKErEn   <= iTrRSyCTRL(0);
TXPtimErEn   <= iTrRSyCTRL(1);
TXPErEn      <= iTrRSyCTRL(2);
TXPtimWdErEn <= iTrRSyCTRL(3);
RXPErEn      <= iTrRSyCTRL(4);
RXCtimErEn   <= iTrRSyCTRL(5);
RXBtimErEn   <= iTrRSyCTRL(6);
StartBitErEn <= iTrRSyCTRL(7);

-------------------------------------------------------------------------------
-- Connect local copies to outputs
-------------------------------------------------------------------------------
TrRSyTXPC    <=  iTrRSyTXPC;
TrRSyRXPC    <=  iTrRSyRXPC;
TrRSyAT      <=  iTrRSyAT;
TrRSyDT      <=  iTrRSyDT;
TrTXRSyBLKG  <=  iTrTXRSyBLKG;
TrTXRSyCHG   <=  iTrTXRSyCHG;
TrRSyCKICC   <=  iTrRSyCKICC;
TrRSyBAUD    <=  iTrRSyBAUD;
TrRSyVALUE   <=  iTrRSyVALUE;
TrRXRSyCHG   <=  iTrRXRSyCHG;
TrRXRSyBLKG  <=  iTrRXRSyBLKG;
TrRSyJit     <=  iTrRSyJit;
TrRSyJitPat  <=  iTrRSyJitPat;

end synth; 

-- --========================= End of SspTrRegCore ===========================--




















