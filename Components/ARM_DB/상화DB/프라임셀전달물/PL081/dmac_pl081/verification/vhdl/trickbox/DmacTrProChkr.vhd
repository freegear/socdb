-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacTrProChkr.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is resposible for doing comparison between UUT's O/P
--          signals and Behavioural Trickbox's O/P signals.
--
-- --=========================================================================--
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.DmacTrPackage.all; 

-- -----------------------------------------------------------------------------
 
entity DmacTrProChkr is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB reset
        HBUSREQDMACM     : in    std_logic; -- Bus request signal to AHB1
        HLOCKDMACM       : in    std_logic; -- HLOCK signal as driven by AHB1
        HTRANSM          : in    std_logic_vector(1 downto 0);
                                            -- Type of transfer on AHB1
        HADDRM           : in    std_logic_vector(31 downto 0);
                                            -- AHB1 address bus
        HSIZEM           : in    std_logic_vector(2 downto 0);
                                            -- Width of transfer on AHB1
        HBURSTM          : in    std_logic_vector(2 downto 0);
                                            -- Burst length on AHB1
        HPROTM           : in    std_logic_vector(3 downto 0);
                                            -- Protection information on AHB1
        HWRITEM          : in    std_logic; -- Transfer direction on AHB1
        HWDATAM          : in    std_logic_vector(31 downto 0);
                                            -- Write data on AHB1
        -- DMA response signals
        DMACCLR          : in    std_logic_vector(15 downto 0);
                                            -- DMA request clear
        DMACTC           : in    std_logic_vector(15 downto 0);
                                            -- DMA terminal count
        -- DMA interrupt request signals
        DMACINTERR       : in    std_logic; -- DMA error interrupt
                                            -- request
        DMACINTTC        : in    std_logic; -- DMA terminal count
                                            -- interrupt request
        DMACINTR         : in    std_logic; -- DMA combined interrupt
        -- Signals from Trickbox
        HBUSREQMTr       : in    std_logic; -- Bus request signal to AHB1
        HLOCKMTr         : in    std_logic; -- HLOCK signal as driven by AHB1
        HTRANSMTr        : in    std_logic_vector(1 downto 0);
                                            -- Type of transfer on AHB1
        HADDRMTr         : in    std_logic_vector(31 downto 0);
                                            -- AHB1 address bus
        HSIZEMTr         : in    std_logic_vector(2 downto 0);
                                            -- Width of transfer on AHB1
        HBURSTMTr        : in    std_logic_vector(2 downto 0);
                                            -- Burst length on AHB1
        HPROTMTr         : in    std_logic_vector(3 downto 0);
                                            -- Protection information on AHB1
        HWRITEMTr        : in    std_logic; -- Transfer direction on AHB1
        HWDATAMTr        : in    std_logic_vector(31 downto 0);
                                            -- Write data on AHB1
        -- DMA response signals
        DMACCLRTr        : in    std_logic_vector(15 downto 0);
                                            -- DMA request clear
        DMACTCTr         : in    std_logic_vector(15 downto 0);
                                            -- DMA terminal count
        -- DMA interrupt request signals
        DMACINTERRTr     : in    std_logic; -- DMA error interrupt
                                            -- request
        DMACINTTCTr      : in    std_logic; -- DMA terminal count
                                            -- interrupt request
        DMACINTRTr       : in    std_logic; -- DMA combined interrupt
        HREADYINM        : in    std_logic; -- HREADY signal
        HGRANTDMACM      : in    std_logic; -- Grant Signal from Arbiter
        DmacTrEn         : in    std_logic
       );
end DmacTrProChkr;

-- -----------------------------------------------------------------------------
--
--                            DmacTrProChkr
--                            =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module is responsible for checking all UUT signals with the signals 
-- generated by the Behavioural DMAC in Trickbox
--
-- -----------------------------------------------------------------------------
 
-- --=========================== ARCHITECTURE ================================--
 
architecture behavioural of DmacTrProChkr is
 
-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal ResetOver        : std_logic := '0';
-- Indication as to Reset is high.

signal LockPulse1       : std_logic;
-- Pulse used to check the assertion of HLOCK for NSEQ

signal DelLockPulse1    : std_logic;
-- Delayed version of LockPulse1

signal DelHLOCK1        : std_logic;
-- Delayed HLOCK

signal CheckEn1         : std_logic;
-- Enable to compare HTRANS

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
 
begin

-- -----------------------------------------------------------------------------
-- The comparison will start from the clock edge when reset occurs
-- -----------------------------------------------------------------------------
p_ResetRegSeq : process (HCLK)
begin
  if (HCLK'event and HCLK = '1') then
    if (HRESETn = '0') then
      ResetOver <= '1';
    end if;
  end if;
end process p_ResetRegSeq;

-- ---------------------------------------------------------------------
-- Latching HGRANTDMACM
-- ---------------------------------------------------------------------
p_DelHGRANT1Seq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    CheckEn1   <= '0';
  elsif (HCLK'event and HCLK = '1' and HREADYINM = '1') then
    CheckEn1   <= HGRANTDMACM;
  end if;
end process p_DelHGRANT1Seq;

-- -----------------------------------------------------------------------------
-- The comparison block
-- -----------------------------------------------------------------------------
p_ProChkComb : process (HCLK)
variable ErrorStr         : string (1 to 255);
begin
  if (HCLK'event and HCLK = '1') then
    if ((DmacTrEn = '1') and (ResetOver = '1')) then
      if (HBUSREQDMACM /= HBUSREQMTr) then
        assert false
        report "DmacTrProChkr1: Mismatch in Bus Request1 Assertion"
        severity error;
      end if;

      if ((HTRANSMTr /= IDLE) and (CheckEn1 = '1')) then
        if (HLOCKDMACM /= HLOCKMTr) then
          assert false
          report "DmacTrProChkr3: Mismatch in HLOCK1 Assertion"
          severity error;
        end if;
      end if;

      if (CheckEn1 = '1') then
        if (HTRANSM /= HTRANSMTr) then
          fprint (ErrorStr, "DmacTrProChkr5: Mismatch in HTRANSM Assertion" &
                            "EXPECTED: %s ACTUAL:%s ",
                  To_HexString(HTRANSMTr), To_HexString(HTRANSM));
          assert false
          report ErrorStr
          severity error;
        end if;
      end if;

      if ((HTRANSM /= NSEQ) and (DelLockPulse1 = '1') and
                                                         (CheckEn1 = '1')) then
        assert false
        report "DmacTrProChkr6: HLOCK1 not asserted for NSEQ"
        severity error;
      end if;

      if ((HTRANSMTr /= IDLE) and (CheckEn1 = '1')) then
        if (HADDRM /= HADDRMTr) then
          fprint (ErrorStr, "DmacTrProChkr9: Mismatch in HADDRM Assertion" &
                            "EXPECTED: %s ACTUAL:%s ",
                  To_HexString(HADDRMTr), To_HexString(HADDRM));
          assert false
          report ErrorStr
          severity error;
        end if;
      end if;

      if ((HTRANSMTr /= IDLE) and (CheckEn1 = '1'))then
        if (HSIZEM /= HSIZEMTr) then
          fprint (ErrorStr, "DmacTrProChkr12: Mismatch in HSIZEM Assertion" &
                            "EXPECTED: %s ACTUAL:%s ",
                  To_HexString(HSIZEMTr), To_HexString(HSIZEM));
          assert false
          report ErrorStr
          severity error;
        end if;
      end if;

      if (HSIZEM > WORD) then
        assert false
        report "DmacTrProChkr13: HSIZEM greater than WORD Access"
        severity error;
      end if;

      if ((HTRANSMTr /= IDLE) and (CheckEn1 = '1')) then
        if (HBURSTM /= HBURSTMTr) then
          fprint (ErrorStr, "DmacTrProChkr16: Mismatch in HBURSTM Assertion" &
                            "EXPECTED: %s ACTUAL:%s ",
                  To_HexString(HBURSTMTr), To_HexString(HBURSTM));
          assert false
          report ErrorStr
          severity error;
        end if;
      end if;

      if ((HBURSTM = WRAP4) or (HBURSTM = WRAP8) or (HBURSTM = WRAP16)) then
        assert false
        report "DmacTrProChkr17: DMAC initiated WRAP Access "
        severity error;
      end if;

      if ((HTRANSMTr /= IDLE) and (CheckEn1 = '1')) then
        if (HPROTM /= HPROTMTr) then
          fprint (ErrorStr, "DmacTrProChkr20: Mismatch in HPROTM Assertion" &
                            "EXPECTED: %s ACTUAL:%s ",
                  To_HexString(HPROTMTr), To_HexString(HPROTM));
          assert false
          report ErrorStr
          severity error;
        end if;
      end if;

      if (HPROTM(0) = '0') then
        assert false
        report "DmacTrProChkr21: HPROTM[0] is driven to 0"
        severity error;
      end if;

      if ((HTRANSMTr /= IDLE) and (CheckEn1 = '1')) then
        if (HWRITEM /= HWRITEMTr) then
          assert false
          report "DmacTrProChkr24: Mismatch in HWRITEM Assertion"
          severity error;
        end if;
      end if;

      if (HWDATAM /= HWDATAMTr) then
        fprint (ErrorStr, "DmacTrProChkr26: Mismatch in HWDATAM Assertion" &
                          "EXPECTED: %s ACTUAL:%s ",
                To_HexString(HWDATAMTr), To_HexString(HWDATAM));
        assert false
        report ErrorStr
        severity error;
      end if;

      if (DMACCLR /= DMACCLRTr) then
        fprint (ErrorStr, "DmacTrProChkr28: Mismatch in DMACCLR Assertion" &
                          "EXPECTED: %s ACTUAL:%s ",
                To_HexString(DMACCLRTr), To_HexString(DMACCLR));
        assert false
        report ErrorStr
        severity error;
      end if;

      if (DMACTC /= DMACTCTr) then
        fprint (ErrorStr, "DmacTrProChkr29: Mismatch in DMACTC Assertion" &
                          "EXPECTED: %s ACTUAL:%s ",
                To_HexString(DMACTCTr), To_HexString(DMACTC));
        assert false
        report ErrorStr
        severity error;
      end if;

      if (DMACINTERR /= DMACINTERRTr) then
        assert false
        report "DmacTrProChkr30: Mismatch in DMACINTERR Assertion"
        severity error;
      end if;

      if (DMACINTTC /= DMACINTTCTr) then
        assert false
        report "DmacTrProChkr31: Mismatch in DMACINTTC Assertion"
        severity error;
      end if;

      if (DMACINTR /= DMACINTRTr) then
        assert false
        report "DmacTrProChkr32: Mismatch in DMACINTR Assertion"
        severity error;
      end if;
    end if;
  end if;
end process p_ProChkComb; 

-- -----------------------------------------------------------------------------
-- Clock Process to register next state signals
-- -----------------------------------------------------------------------------
p_DelHlockSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DelHLOCK1     <= '0';
    DelLockPulse1 <= '0';
  elsif (HCLK'event and HCLK = '1') then
    DelHLOCK1     <= HLOCKDMACM;
    if (LockPulse1 = '1') then
      DelLockPulse1 <= '1';
    elsif (HTRANSMTr = NSEQ) then
      DelLockPulse1 <= '0';
    end if;
  end if;
end process p_DelHlockSeq;

-- -----------------------------------------------------------------------------
-- Lock Pulse generation for HLOCK1
-- -----------------------------------------------------------------------------
LockPulse1 <= '1' when ((DelHLOCK1 = '0') and (HLOCKDMACM = '1'))
           else
              '0';

end behavioural;
 
-- --=============================== End =====================================-- 
