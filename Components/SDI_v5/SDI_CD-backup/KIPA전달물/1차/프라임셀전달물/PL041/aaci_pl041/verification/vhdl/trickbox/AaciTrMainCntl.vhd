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
-- File Name              : AaciTrMainCntl.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This block consists of the main Transmit/Receive control
--           Logic and the main state machine which tracks the for
--           different slots.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.AaciTrPackage.all;

-- ---------------------------------------------------------------------

entity AaciTrMainCntl is
  port (
-- Inputs
        -- APB signals
        BITCLKIn         : in    std_logic; -- Serial bit clock
        nAACIBITCLKRST   : in    std_logic; -- APB Bus Reset
        -- BITCLK Enable signals
        AACITrEnBSync    : in    std_logic; -- AACI trickbox enable
        TxEnSync         : in    std_logic; -- Transmit Enable
        RxEnSync         : in    std_logic; -- Receive Enable
        BtClkESync       : in    std_logic; -- BITCLK Enable
        WintGenSync      : in    std_logic; -- Wake up INTR generate
        -- AC link signals
        AACISYNC         : in    std_logic; -- Serial syncclock
        AACISDATAIN      : in    std_logic; -- Serial transmit input
        TxFRdDataIn      : in    std_logic_vector(19 downto 0);
                                            -- Data to transmit
        AACITrBtClkPrd   : in    std_logic_vector(15 downto 0);
-- Outputs
        TxFRdPtrInc      : out   std_logic; -- Tx FIFO read ptr incr.
        RxFWr            : out   std_logic; -- Rx FIFO write enable
        AACISDATAOUT     : out   std_logic; -- Serial transmit output
        RxFWrData        : out   std_logic_vector(19 downto 0);
                                            -- Rx FIFO write data
        SlotState        : out   std_logic_vector(3 downto 0)
                                            -- Slot number state
       );
end AaciTrMainCntl;

-- ---------------------------------------------------------------------
--
--                           AaciTrMainCntl
--                           ==============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This block constitutes the main transmit / receive control logic in
-- the AACITrickbox.
--   Transmit data is first loaded into a 20-bit temporary transmit
-- register. Depending on the state machine state this is loaded in to
-- the Transmit Shift Register at the start of the slot and bits are
-- shifted out onto the AACISDATAOUT line (MSBit first). The shifting is
-- done on every positive edge of the BITCLK.
-- Each entry into the FIFO is slot data. As the slot data maximum width
-- is 20 bits, the FIFO data width size is the 20 bit. The test code has
-- to left justify the data for the tag slot by four bits. Similarly
-- for the different TSIZE in the AACI TXCR registers test code has to
-- ensure that the data is left justified correctly according to TSIZE
-- given below
--    T S I Z E      L E F T J U S T I F I C A T I O N
--     18 bits              2 bits
--     16 bits              4 bits
--     12 bits              8 bits
--     20 bits              0 bits
--   Receive data sampled on the AACISDATAIN input is shifted into an
-- internal shift register and when a complete slot is received,
-- received data is loaded in to the the receive buffer before being
-- loaded to the FIFO. The FIFO data width for the recieve FIFO is also
-- 20 bits as the every slot data is 20 bits except the tag slot
-- data(which is 16 bit). For the tag slot the 16 bit data is appended
-- with 4 zeros to make it valid 20 bit data. So the software should
-- look into the only lower 16 bits for the tag slot.
--
-- The description of the Main state machine is given at the begining of
-- the state machine
--
-- ---------------------------------------------------------------------

-- --========================= ARCHITECTURE ==========================--

architecture behavioural of AaciTrMainCntl is

-- ---------------------------------------------------------------------
--  Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal iSlotState       : std_logic_vector(3 downto 0);
-- Main State machine states. These changes through different states
-- as the AC link slot states from slot 0 to slot 12

signal BitCount         : std_logic_vector(4 downto 0);
-- The counter to count the number of the bit in the slot in the frame
-- This is to keep the track of the activity on the AC link

signal iTxFRdPtrInc     : std_logic;
-- Internal TxFIFO read Pointer increment signal
-- This signal communicate with the transmit FIFO control logic

signal iRxFWr           : std_logic;
-- Internal RxFIFO Write signal

signal TxShft           : std_logic_vector(19 downto 0);
-- Transmit Shift register

signal RxShft           : std_logic_vector(19 downto 0);
-- receive Shift register

signal TempRxReg        : std_logic_vector(19 downto 0);
-- Temporary receive Shift register to store the intermediate receive
-- shift register data

signal IntAACISDATAIN   : std_logic;
-- Internal AACISDATAIN used as the serial input of the Rx shift reg

signal IntSYNC          : std_logic;
-- Internal version of the AACISYNC sampled on the negedge of BITCLK

signal SDATAToggle      : std_logic;
-- Toggling signal for SDATOUT for set up and hold time checking

signal IntTxEnSync      : std_logic;
-- Internal sampled version of the TxEnSync on AACISYNC

signal IntRxEnSync      : std_logic;
-- Internal sampled version of the RxEnSync on AACISYNC

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------
function to_integer (
         val : std_logic_vector;
         x : integer := 0
                    ) return integer is
  variable returnint : integer;
  -- Return variable from the function
  variable xtmp      : integer;
  -- Temporary variable
begin
  returnint := 0;
  xtmp := 0;
  if x /= 0 then
    xtmp := 1;
  end if;
  for i in val'range loop
    returnint := returnint + returnint;
      case val(i) is
        when '0'    => null;
        when '1'    => returnint := returnint + 1;
        when others => returnint := returnint + xtmp;
      end case;
  end loop;
  return returnint;
end to_integer;

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- --------------------------------------------------------------------
-- Local signal assignments
-- ---------------------------------------------------------------------
TxFRdPtrInc      <= iTxFRdPtrInc;
RxFWr            <= iRxFWr;
RxFWrData        <= TempRxReg;
SlotState        <= iSlotState;

-- ---------------------------------------------------------------------
-- When AACI is disabled, drives zero on IntAACISDATAIN, otherwise
-- drives AACISDATAIN on IntAACISDATAIN
-- ---------------------------------------------------------------------
IntAACISDATAIN   <= AACISDATAIN when (AACITrEnBSync = '1' and
                                 IntRxEnSync = '1')
                else
                   '0';

-- ---------------------------------------------------------------------
-- Assignment of the AACISDATAOUT from the last bit of the transmit
-- shift register which is controlled by the main transmit/receive 
-- control state machine. but in the absense of the BITCLK the 
-- AACISDATAIN can be made high by the bit WintGen in the control 
-- register of the trickbox.
-- --------------------------------------------------------------------
AACISDATAOUT         <= ((TxShft(19) and SDATAToggle) or WintGenSync)
                     when (AACITrEnBSync = '1' and IntTxEnSync = '1')
                else
                   '0';

-- ---------------------------------------------------------------------
-- AACISDATAOUT Toggling signal generation
-- ---------------------------------------------------------------------
p_SdataOutTogSeq: process (BITCLKIn)
  variable OutDelay  : time;
  -- Output delay
begin
  if (BITCLKIn = '1') then
    SDATAToggle <= BITCLKIn after
                     ((to_integer(AACITrBtClkPrd)/2 * 1 ns) -
                      (to_integer(AACITrBtClkPrd) * 0.15 ns));
  elsif (BITCLKIn = '0') then
    SDATAToggle <= '0' after (to_integer(AACITrBtClkPrd) * 0 ns);
  end if;
end process p_SdataOutTogSeq;

-- ---------------------------------------------------------------------
-- Main Transmission/Reception State machine :
-- This state machine operates on the BITCLK. This block contains the
-- main transmission and reception control depending upon the slot state
-- at the AC link.
-- The machine has 14 states. First on reset it goes to the INITIAL
-- state. It waits for the AACISYNC port of AACI to go high to go to
-- SYNC state. This SYNC state is the tag slot of of the frame.
-- This is 16 BITCLK wide and then state machine moves through different
-- states corresponding to the diffferent slots on the AC link. And at
-- the end of the every slot the The data received in the receive shift
-- register is loaded in to the Rx buffer and at the start of the every
-- slot the data from the Tx buffer is loaded in to the Tx shift
-- register.
-- The communication between this state machine and the Tx and Rx FIFO
-- is through the RxFWr for writing into the Rx FIFO and TxFRdPtrInc for
-- reading from the Tx FIFO.
-- The RxFWr is toggled at the end of the every slot and the the data
-- from shift register is loaded in to the receive buffer.
-- And TxFRdPtrInc is toggled at the start of the slot and at the
-- same instant the data from transmit buffer is loaded in to the
-- transmit shift register.
-- The protocol check is also there for the AACISYNC port in the normal
-- transmission and reception. This checks for the AACISYNC port to be
-- high for 16 BITCLK periods and to be low for 240 clock periods. If 
-- not it flags the error messege.
--
-- --------------------------------------------------------------------
p_MainCntrlSeq: process (BITCLKIn, nAACIBITCLKRST, AACITrEnBSync,
                         BtClkESync)
begin
  if (nAACIBITCLKRST = '0') then
    BitCount      <= "00000";
    iSlotState    <= ST_INITIAL;
    iTxFRdPtrInc  <= '0';
    iRxFWr        <= '0';
    TxShft        <= "00000000000000000000";
    TempRxReg     <= "00000000000000000000";
  elsif (AACITrEnBSync = '0' or BtClkESync = '0') then
    BitCount      <= "00000";
    iSlotState    <= ST_INITIAL;
    TxShft        <= "00000000000000000000";
    TempRxReg     <= "00000000000000000000";
  elsif (BITCLKIn'event and BITCLKIn = '1') then
    case iSlotState is
      when ST_INITIAL =>
      -- Waiting for AACISYNC to go high
        if (IntSYNC = '1') then
          IntTxEnSync  <= TxEnSync;
          IntRxEnSync  <= RxEnSync;
          BitCount     <= "00000";
          iSlotState   <= ST_SYNC;
          if (TxEnSync = '1') then
            TxShft       <= TxFRdDataIn;
            iTxFRdPtrInc <= not iTxFRdPtrInc;
          end if;
        end if;

      when ST_SYNC =>
      -- Slot0 data
        if (IntSYNC = '1' and BitCount /= "01111") then
          TxShft(19 downto 1) <= TxShft(18 downto 0);
          TxShft(0)           <= '0';
          BitCount            <= (unsigned(BitCount) + 1);
        elsif (IntSYNC = '0') then
          if (BitCount /= "01111") then
            assert false
              report "AACITB1 : The AACISYNC is not high for 16 BITCLK"
                                &" periods"
              severity error;
          else
            iSlotState   <= ST_SLOT1;
            BitCount     <= "00000";
            if (IntTxEnSync = '1') then
              TxShft       <= TxFRdDataIn;
              iTxFRdPtrInc <= not iTxFRdPtrInc;
            end if;
            if (IntRxEnSync = '1') then
              TempRxReg    <= "0000" & RxShft(15 downto 0);
              iRxFWr       <= not iRxFWr;
            end if;
          end if;
        end if;

      when ST_SLOT1 | ST_SLOT2 | ST_SLOT3 | ST_SLOT4
          | ST_SLOT5 | ST_SLOT6 | ST_SLOT7 | ST_SLOT8 | ST_SLOT9
          | ST_SLOT10 | ST_SLOT11 =>
        if (IntSYNC = '1') then
          assert false
            report "AACITB2 : The AACISYNC is HIGH for NON-SYNC Region "
            severity error;
        elsif (BitCount = "10011") then
          BitCount      <= "00000";
          if (IntTxEnSync = '1') then
            TxShft        <= TxFRdDataIn;
            iTxFRdPtrInc  <= not iTxFRdPtrInc;
          end if;
          if (IntRxEnSync = '1') then
            TempRxReg     <= RxShft;
            iRxFWr        <= not iRxFWr;
          end if;
          case iSlotState is
            when ST_SLOT1 =>
                            iSlotState <= ST_SLOT2;
            when ST_SLOT2 =>
                            iSlotState <= ST_SLOT3;
            when ST_SLOT3 =>
                            iSlotState <= ST_SLOT4;
            when ST_SLOT4 =>
                            iSlotState <= ST_SLOT5;
            when ST_SLOT5 =>
                            iSlotState <= ST_SLOT6;
            when ST_SLOT6 =>
                            iSlotState <= ST_SLOT7;
            when ST_SLOT7 =>
                            iSlotState <= ST_SLOT8;
            when ST_SLOT8 =>
                            iSlotState <= ST_SLOT9;
            when ST_SLOT9 =>
                            iSlotState <= ST_SLOT10;
            when ST_SLOT10 =>
                            iSlotState <= ST_SLOT11;
            when ST_SLOT11 =>
                            iSlotState <= ST_SLOT12;
            when others    => null;
          end case;
        else
          TxShft(19 downto 1) <= TxShft(18 downto 0);
          BitCount            <= (unsigned(BitCount) + 1);
          TxShft(0)           <= '0';
        end if;

      when ST_SLOT12     =>
      -- Slot12 data
        if (IntSYNC = '1'and BitCount /= "10011") then
          assert false
            report "AACITB3 : The AACISYNC is HIGH for NON-SYNC Region "
            severity error;
        elsif (IntSYNC = '1' and BitCount = "10011") then
          IntTxEnSync  <= TxEnSync;
          IntRxEnSync  <= RxEnSync;
          iSlotState   <= ST_SYNC;
          BitCount     <= "00000";
          if (TxEnSync = '1') then
            TxShft       <= TxFRdDataIn;
            iTxFRdPtrInc <= not iTxFRdPtrInc;
          end if;
          if (IntRxEnSync = '1') then
            TempRxReg    <= RxShft;
            iRxFWr       <= not iRxFWr;
          end if;
        else
          TxShft(19 downto 1) <= TxShft(18 downto 0);
          BitCount            <= (unsigned(BitCount) + 1);
          TxShft(0)           <= '0';
        end if;

      when others =>
      -- Error condition
        assert false
          report "AACITB4 : Invalid state of the Tx and Rx FIFO Control"
                                 & " machine"
          severity error;
    end case;
  end if;
end process p_MainCntrlSeq;

-- ---------------------------------------------------------------------
-- Receive Logic capturing the AACISDATAIN on every falling edge of
-- BITCLK
-- ---------------------------------------------------------------------
p_RxLogicSeq : process (BITCLKIn, nAACIBITCLKRST, AACITrEnBSync)
begin
  if (nAACIBITCLKRST = '0' or AACITrEnBSync = '0') then
    RxShft         <= "00000000000000000000";
  elsif (BITCLKIn'event and BITCLKIn = '0') then
    RxShft(19 downto 1) <= RxShft(18 downto 0);
    RxShft(0)           <= IntAACISDATAIN;
  end if;

end process p_RxLogicSeq;

-- ---------------------------------------------------------------------
-- The sampling of AACISYNC on the falling edge of BITCLK
-- ---------------------------------------------------------------------
p_SyncSampSeq : process (BITCLKIn)
begin
  if (BITCLKIn'event and BITCLKIn = '0') then
    IntSYNC     <= AACISYNC;
  end if;

end process p_SyncSampSeq;

end behavioural;

-- ============================== End ================================--

