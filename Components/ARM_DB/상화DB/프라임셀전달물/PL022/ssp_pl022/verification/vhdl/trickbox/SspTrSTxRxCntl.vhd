-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SspTrSTxRxCntl.vhd.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--
-- -----------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------
 
-- Purpose          : This block consists of Master's Transmit/Receive
--                    control state machine.
 
-- --=========================================================================--
--  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrSTxRxCntl is
  port (
-- Inputs
        SSPCLK          : in std_logic;	       -- Main SSP clock
        nSSPRES         : in std_logic;	       -- Muxed reset (from nSSPRST)
        ClkEnable       : in std_logic;        -- Clock enable
        SSESync         : in std_logic;	       -- SSP enable
        SSPCLKDIV       : in std_logic;	       -- Pre-scaler output
        TxDataAvlblSync : in std_logic;	       -- Tx data available
        Nibmode         : in std_logic;	       -- Nibble mode count
        DSS             : in std_logic_vector(3 downto 0);
                                               -- Bits per frame
        FRF             : in std_logic_vector(1 downto 0);
                                               -- Frame format
        SCR             : in std_logic_vector(7 downto 0);
                                               -- Serial clock rate
        SPO             : in std_logic;	       -- SCLK polarity
        SPH             : in std_logic;	       -- SCLK phase
        SPISFRMEn       : in std_logic;        -- SFRM de-assertion Enable bit
                                               -- in SPI(SPH = 1) continous mode
        ESFRM           : in std_logic_vector(7 downto 0);
                                               -- For Extended SFRM Test
        FRC             : in std_logic;        -- For Free running SCLK Test
        TxFRdDataIn     : in std_logic_vector(15 downto 0);
                                               -- Lft justified
        SSPRXD          : in std_logic;	       -- Loopback muxed SSPRXD
        OD              : in std_logic;        -- Out put disable bit
        STxFRdPtrInc    : out std_logic;       -- Tx FIFO read ptr incr.
        SRxFWr          : out std_logic;       -- Rx FIFO write enable
        STxRxBSY        : out std_logic;       -- SSP Tx/Rx controller busy
        SSPOE           : out std_logic;       -- Output enable for SSPTXD
        SSPTXD          : out std_logic;       -- Serial transmit output
        SCLK            : out std_logic;       -- Serial clock
        SFRM            : out std_logic;       -- Serial frame
        RxFWrData       : out std_logic_vector(15 downto 0)	
                                               -- Rx FIFO write data
       );
end SspTrSTxRxCntl;

-- -----------------------------------------------------------------------------
-- -------------------------------------------------------------------------
--
--                              SspMTxRxCntl
--                              ============
--
-- -------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This block constitutes the Master's transmit / receive control logic in
-- SSP. Transmit data is first loaded into a 16-bit Transmit Shift Register.
-- and bits are shifted out onto the SSPTXD output line (MSBit first).
--  Receive data sampled on the RXDSSIn input is shifted into an internal
-- shift register and when a complete frame is received, received data is
-- copied into a receive buffer from the shift register. When the last data
-- bit is sampled on the RXDSSIn input, it is copied into the Receive
-- Buffer along with the contents of the receive shift register. Thus, the
-- receive shift register is 15 bits wide and the receive buffer is 16 bits
-- wide.
--  Interaction with the Transmit FIFO occurs through the STxFRdPtrInc
-- signal. This signal is toggled at the beginning of the frame after the
-- transmit data has been copied into the Transmit Shift register. In order
-- to ensure that the signal gets synchronised to PCLK and is seen by the
-- Transmit FIFO, the signal is kept stable for the duration of the frame.
-- As the frequency of PCLK is equal to or greater than that of SSPCLK, this
-- signal is assured to be seen in the PCLK domain. In TI mode, STxFRdPtrInc
-- signal gets toggled at the first rising edge of SCLK after the SFRM pulse
-- as we are assured that it denotes the start of a new data. In NM mode,
-- this signal is toggled when the slave transmits the MSB to master. In SPI
-- mode, the signal is toggled at the next edge of SCLK after MSB of a new
-- data has been transmitted out.
--  Interaction with the Receive FIFO occurs through the SRxFWr signal which
-- is also toggled at the instant where the last bit is being received.
--  The BitPeriodCnt counter in this module is an 8-bit down counter that
-- is used to time the phase duration of SCLK. This counter is clocked by
-- SSPCLK and counts down with every SSPCLKDIV pulse. To time one SCLK
-- phase duration, this counter is loaded with the SCR value and when the
-- count reaches zero, one SCLK phase duration is said to have elapsed.
-- When the Nibmode input is asserted,this counter counts down by 17 (0x11)
-- with every SSPCLKDIV pulse. Thus in the nibble mode, the 8-bit counter
-- counts down as two 4-bit counters.
--  The BitCnt counter counts the number of bits that have been transmitted
-- and received. For the TI Synchronous serial frame format and the
-- Motorola SPI frame format, this counter is initially loaded with DSS and
-- is decremented by 1 after one bit has been transmitted and received. In
-- the National Microwire frame format, this counter is loaded with 7 at
-- the start of transmission and is loaded with DSS at the start of
-- reception.
--  The SSPOE output signal is the output enable signal for the SSPTXD
-- output.  This signal is meant to drive the output enable pin of the pad
-- to which SSPTXD is connected. To account for pad delays, SSPOE is
-- asserted one SCLK phase time  before and after SSPTXD is supposed to be
-- valid.
-- The synchronised MS signal determines whether the SSPTXD, SSPOE, SRxFWr,
-- STxFRdPtrInc and STxRxBSY signals of master or slave is to be driven out.
 
-- -----------------------------------------------------------------------------

--============================== ARCHITECTURE ================================--

architecture synth of SspTrSTxRxCntl is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
signal SspTxRxCntlState     : std_logic_vector(5 downto 0);
-- Slave State Register
 
signal SspTxRxCntlNextState : std_logic_vector(5 downto 0);
-- Slave State Register
 
signal NextSTxRxBSY         : std_logic;
-- TxRxBSY signal in Slave mode
 
signal NextSSPOE            : std_logic;
-- SSPOE signal in Slave mode
 
signal NextSSPTXD           : std_logic;
-- D-input of SSPTXD signal in Slave mode
 
signal NextSCLK             : std_logic;
-- D-input of SCLK output signal
 
signal NextSFRM             : std_logic;
-- D-input of SFRM Output signal
 
signal NextSTxFRdPtrInc     : std_logic;
-- D-input of TXFIFO Read Pointer Increment signal in Slave mode
 
signal NextSRxFWr           : std_logic;
-- RXFIFO Write signal in Slave mode
 
signal NextRxFWrData        : std_logic_vector(15 downto 0);
-- D-input of RXFIFO Write data bus in to test Slave
 
signal BitPeriodCnt         : std_logic_vector(7 downto 0);
-- Bit Period Counter
 
signal NextBitPeriodCnt     : std_logic_vector(7 downto 0);
-- D-input of Bit Period Counter
 
signal BitCnt               : std_logic_vector(3 downto 0);
-- BitCounter
 
signal NextBitCnt           : std_logic_vector(3 downto 0);
-- D-input of Bit Counter
 
signal SCLKCnt              : std_logic_vector(7 downto 0);
-- It counts the SCLK during Extended SFRM
 
signal NextSCLKCnt          : std_logic_vector(7 downto 0);
-- D - input of SCLKCnt;

signal TxShft               : std_logic_vector(15 downto 0);
-- TX Shift Register
 
signal NextTxShft           : std_logic_vector(15 downto 0);
-- D-input of TX Shift Register
 
signal RxShft               : std_logic_vector(14 downto 0);
-- RX Shift Register
 
signal NextRxShft           : std_logic_vector(14 downto 0);
-- D-input of RX Shift Register

signal BitPeriodCmp         : std_logic;
-- bit period comparator
 
signal BitCmpHalf           : std_logic;
-- bit period half comparator
 
signal BitCmp               : std_logic;
-- Bit comparator
 
signal SSPRXDIn             : std_logic;
-- Internal Input data line

signal LocalSTxRxBSY        : std_logic;
-- Internal signal of STxRxBSY

signal LocalSSPOE           : std_logic;
-- Local signal to SSPOE

signal LocalSSPTXD          : std_logic;
-- Local signal to SSPTXD

signal LocalSCLK            : std_logic;
-- Local signal to SCLK

signal LocalSFRM            : std_logic;
-- Local signal to SFRM

signal LocalSTxFRdPtrInc    : std_logic;
-- Local signal to STxFRdPtrInc

signal LocalSRxFWr          : std_logic;
-- Local signal to SRxFWr

signal LocalRxFWrData       : std_logic_vector (15 downto 0);
-- Local signal to RxFWrData 

--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------
    
begin

-- -----------------------------------------------------------------------------
-- Assign Bit Comparator and Bit Period Comparator
-- -----------------------------------------------------------------------------
BitPeriodCmp <= '1' when BitPeriodCnt(7 downto 0) = "00000000" 
             else
                '0';

BitCmpHalf   <= '1' when BitCnt(3 downto 0) = ('0' & DSS(3 downto 1))
             else
                '0';

BitCmp       <= '1' when BitCnt(3 downto 0) = "0000"
             else
                '0';

SSPRXDIn     <= '0' when (OD = '1')
             else
                SSPRXD;

STxRxBSY     <= LocalSTxRxBSY;
SSPOE        <= LocalSSPOE;
SSPTXD       <= LocalSSPTXD;
SCLK         <= LocalSCLK;
SFRM         <= LocalSFRM;
STxFRdPtrInc <= LocalSTxFRdPtrInc;
SRxFWr       <= LocalSRxFWr;
RxFWrData    <= LocalRxFWrData;

--------------------------------------------------------------------------------
-- State transition process
--------------------------------------------------------------------------------
seq : process(SSPCLK, nSSPRES) begin
-- When nSSPRES is asserted, transition to the ST_RESET state and
-- wait for the SSP to be enabled.
    
  if ((not(nSSPRES)) = '1') then
    SspTxRxCntlState   <= "110010";
    LocalSTxRxBSY      <= '0';
    LocalSSPOE         <= '0';
    LocalSSPTXD        <= '0';
    LocalSCLK          <= '0';
    LocalSFRM          <= '1';
    LocalSTxFRdPtrInc  <= '0';
    LocalSRxFWr        <= '0';
    SCLKCnt            <= "00000000";
    LocalRxFWrData     <= "0000000000000000";
  elsif (SSPCLK'event and SSPCLK = '1') then
    if (ClkEnable = '1') then
      SspTxRxCntlState  <= SspTxRxCntlNextState;
      LocalSTxRxBSY     <= NextSTxRxBSY;
      LocalSSPOE        <= NextSSPOE;
      LocalSSPTXD       <= NextSSPTXD;
      LocalSCLK         <= NextSCLK;
      LocalSFRM         <= NextSFRM;
      LocalSTxFRdPtrInc <= NextSTxFRdPtrInc;
      LocalSRxFWr       <= NextSRxFWr;
      SCLKCnt           <= NextSCLKCnt;
      LocalRxFWrData    <= NextRxFWrData;
    end if;
  end if;
end process seq;

--------------------------------------------------------------------------------
-- Output and next state logic generation
--------------------------------------------------------------------------------
combo : process (SspTxRxCntlState, Nibmode, DSS, FRF, SCR, SPO, SPH, SSESync, 
                 TxDataAvlblSync, TxFRdDataIn, SSPRXDIn, SSPCLKDIV, 
                 BitPeriodCnt, BitCnt, TxShft, RxShft, BitPeriodCmp, BitCmpHalf,
                 BitCmp, LocalSTxRxBSY, LocalSSPOE, LocalSSPTXD, LocalSCLK, 
                 LocalSFRM, LocalSTxFRdPtrInc, LocalSRxFWr, LocalRxFWrData,
                 SCLKCnt, FRC) 
begin
-- Default assignments
  SspTxRxCntlNextState <= SspTxRxCntlState;
  NextSTxRxBSY         <= LocalSTxRxBSY;
  NextSSPOE            <= LocalSSPOE;
  NextSSPTXD           <= LocalSSPTXD;
  NextSCLK             <= LocalSCLK;
  NextSFRM             <= LocalSFRM;
  NextSCLKCnt          <= SCLKCnt;
  NextSTxFRdPtrInc     <= LocalSTxFRdPtrInc;
  NextSRxFWr           <= LocalSRxFWr;
  NextRxFWrData        <= LocalRxFWrData;
  NextBitPeriodCnt     <= BitPeriodCnt;
  NextBitCnt           <= BitCnt;
  NextTxShft           <= TxShft;
  NextRxShft           <= RxShft;
  -- If the SSP is disabled, then the state machine should terminate
  -- transmission / reception,  initialise the outputs and the 
  -- internal variables and transition to the ST_RESET state.
    
  if ((not(SSESync)) = '1') then
    NextSTxRxBSY         <= '0';
    NextSSPOE            <= '0';
    NextSSPTXD           <= '0';
    NextSCLK             <= (not(FRF(1)) and not(FRF(0)) and SPO);
    NextSFRM             <= not(FRF(0));
    NextSCLKCnt          <= "00000000";
    NextSTxFRdPtrInc     <= '0';
    NextSRxFWr           <= '0';
    NextRxFWrData        <= "0000000000000000";
    NextBitPeriodCnt     <= SCR(7 downto 0);
    NextBitCnt           <= "1111";
    NextTxShft           <= "0000000000000000";
    NextRxShft           <= "000000000000000";
    SspTxRxCntlNextState <= "110010";
  else
    case SspTxRxCntlState is

      -- Wait for data to be available in the transmit FIFO provided the
      -- frame format is not changed.
      when "000000" =>

        -- Texas Instruments' Synchronous Serial Frame format is no
        -- longer the programmed format.
        if ((not(not(FRF(1)) and FRF(0))) = '1') then
          -- National Microwire Frame format selected.
          if ((FRF(1) and not(FRF(0))) = '1') then
            -- Initialise the outputs to their inactive values.
            NextSTxRxBSY         <= '0';
            NextSSPOE            <= '0';
            NextSSPTXD           <= '0';
            NextSCLK             <= '0';
            NextSFRM             <= '1';
            SspTxRxCntlNextState <= "001110";
          -- Motorola SPI Frame format selected.
          elsif ((not(FRF(1)) and not(FRF(0))) = '1') then
            -- Initialise the outputs to their inactive values.
            NextSTxRxBSY         <= '0';
            NextSSPOE            <= '0';
            NextSSPTXD           <= '0';
            NextSCLK             <= SPO;
            NextSFRM             <= '1';
            SspTxRxCntlNextState <= "011100";
          end if;

        -- Transmit data available in the Transmit FIFO.
        elsif ((not(FRF(1)) and FRF(0) and TxDataAvlblSync and
                not(LocalSCLK) and BitPeriodCmp)  = '1') then
          NextSTxRxBSY <= '1';
          NextSSPOE <= '0';
          -- SSPCLKDIV asserted, so start frame now. Load transmit
          -- data into the transmit shift register, initialise
          -- the BitPeriodCnt and BitCnt counters and assert the
          -- STxFRdPtrInc signal for the Transmit FIFO.
          if ((SSPCLKDIV) = '1') then
            NextSCLK                     <= '1';
            NextSFRM                     <= '1';
            NextSTxFRdPtrInc             <= '1';
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            NextBitCnt(3 downto 0)       <= DSS(3 downto 0);
            NextTxShft(15 downto 0)      <= TxFRdDataIn(15 downto 0);
            NextSCLKCnt                  <= ESFRM;
            SspTxRxCntlNextState         <= "001100";
            -- SSPCLKDIV is not currently asserted, so wait for the next
            -- SSPCLKDIV pulse.
          elsif ((not(SSPCLKDIV)) = '1') then
            SspTxRxCntlNextState <= "001101";
          end if;
        elsif ((not(FRF(1)) and FRF(0) and FRC) = '1') then
          -- If FRC bit is set, SCLK is free running even if the Tx FIFO
          -- contains no data
          if ((SSPCLKDIV and  BitPeriodCmp) = '1') then
            NextSCLK         <= not(LocalSCLK);
            NextBitPeriodCnt <= SCR(7 downto 0);
          elsif ((SSPCLKDIV and  not(BitPeriodCmp)) = '1') then
            NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
            SspTxRxCntlNextState <= "000000";
          end if;
        end if;
      -- Wait for a time duration corresponding to one SCLK phase.
      when "000001" =>
        -- One phase of SCLK elapsed, so pull SCLK high and SFRM low.
        -- Clock out the MSBit of the transmit Shift register into
        -- SSPTXD and shift the contents of the shift register left
        -- by one bit position. Also, reload the BitPeriodCnt counter.
        if ((SSPCLKDIV = '1') and (BitPeriodCmp = '1') and (BitCmpHalf = '0')
             and (SCLKCnt = "00000000")) then
          NextSSPTXD                   <= TxShft(15);
          NextSCLK                     <= '1';
          NextSFRM                     <= '0';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextTxShft(15 downto 1)      <= TxShft(14 downto 0); 
          NextTxShft(0 downto 0)       <= "0"; 
          SspTxRxCntlNextState         <= "000011";

        -- One half of the frame has elapsed, so deassert STxFRdPtrInc
        -- and SRxFWr. Shift out the next Transmit bit and reload the
        -- BitPeriodCnt counter.
        elsif ((SSPCLKDIV = '1') and (BitPeriodCmp = '1') and 
               (BitCmpHalf = '1') and (SCLKCnt = "00000000")) then
          NextSSPTXD                   <= TxShft(15);
          NextSCLK                     <= '1';
          NextSTxFRdPtrInc             <= '0';
          NextSRxFWr                   <= '0';
          NextTxShft(15 downto 1)      <= TxShft(14 downto 0); 
          NextTxShft(0 downto 0)       <= "0"; 
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextSCLKCnt                  <= ESFRM;
          SspTxRxCntlNextState         <= "000010";

        elsif ((SSPCLKDIV = '1') and  (BitPeriodCmp = '1') 
                and (SCLKCnt > "00000000")) then
          -- If SCLKCnt is greater than zero then this block will transmit
          -- 'x' on the SSPTXD. This will help to ESFRM Test
          NextSSPTXD           <= 'X';
          NextSCLK             <= '1';
          NextSFRM             <= '1';
          NextBitPeriodCnt     <= SCR(7 downto 0);
          NextSCLKCnt          <= unsigned(SCLKCnt) - 1;
          SspTxRxCntlNextState <= "100000";

        -- When not in nibble mode decrement the BitPeriodCnt
        -- counter by 1 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "000001";

        -- In the Nibble mode, decrement the BitPeriodCnt counter
        -- by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "000001";
        end if;

      -- Wait in this state for a time period corresponding to the high phase 
      -- of SCLK after a bit has been shifted out onto the SSPTXD line.
      when "000011" =>
        -- Time duration, corresponding to the High phase of SCLK after
        -- a bit has been shifted out on the SSPTXD line, has elapsed.
        -- Sample the SSPRXDIn input and shift it into the Receive
        -- shift register. Pull SCLK low and reload BitPeriodCnt.
        -- Decrement the BitCnt counter by 1.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= '0';
          NextBitCnt                   <= unsigned(BitCnt) - 1;
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextRxShft(14 downto 0)      <= (RxShft(13 downto 0) & SSPRXDIn);
          SspTxRxCntlNextState         <= "000001";

        -- When not in nibble mode decrement the BitPeriodCnt
        -- counter by 1 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "000011";

        -- In the Nibble mode, decrement the BitPeriodCnt counter
        -- by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "000011";
        end if;

      -- Wait for a period of time corresponding to one phase of SCLK.
      when "000010" =>

        -- Time duration, corresponding to the High phase of SCLK after
        -- a bit has been shifted out on the SSPTXD line, has elapsed.
        -- Sample the SSPRXDIn input and shift it into the Receive
        -- shift register. Pull SCLK low and reload BitPeriodCnt.
        -- Decrement the BitCnt counter by 1.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= '0';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextRxShft(14 downto 0)      <= (RxShft(13 downto 0) & SSPRXDIn);
          NextBitCnt                   <= unsigned(BitCnt) - 1;
          SspTxRxCntlNextState         <= "000110";

        -- When not in nibble mode decrement the BitPeriodCnt
        -- counter by 1 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "000010";

        -- In the Nibble mode, decrement the BitPeriodCnt counter
        -- by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "000010";
        end if;

      -- Wait for a period of time corresponding to one SCLK phase.
      when "000110" =>

        -- All data bits except the last bit have been 
        -- shifted out/sampled.
        if ((SSPCLKDIV and BitPeriodCmp and BitCmp) = '1') then

          -- More transmit data is available in the Transmit FIFO, so
          -- generate an SFRM pulse during the last bit of the
          -- previous frame, to signal the beginning of the next data
          -- frame. Shift out the last data bit and load the Transmit
          -- shift register with the next transmit data. Also, reload
          -- the BitCnt counter with DSS and the BitPeriodCnt 
          -- counter with SCR.
          if ((TxDataAvlblSync) = '1') then
            NextSSPTXD                   <= TxShft(15);
            NextSCLK                     <= '1';
            NextSFRM                     <= '1';
            NextSTxFRdPtrInc             <= '1';
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            NextTxShft(15 downto 0)      <= TxFRdDataIn(15 downto 0);
            NextBitCnt(3 downto 0)       <= DSS(3 downto 0);
            SspTxRxCntlNextState         <= "000100";

          -- No more transmit data available in the transmit FIFO, so
          -- keep SFRM unchanged (low) and shift out the last Transmit
          -- bit onto the SSPTXD line.
          elsif ((not(TxDataAvlblSync)) = '1') then
            NextSSPTXD                   <= TxShft(15);
            NextSCLK                     <= '1';
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            SspTxRxCntlNextState         <= "000101";
          end if;

        -- When not in nibble mode decrement the BitPeriodCnt
        -- counter by 1 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "000110";

        -- One phase of SCLK elapsed, so pull SCLK high and SFRM low.
        -- Clock out the MSBit of the transmit Shift register into
        -- SSPTXD and shift the contents of the shift register left
        -- by one bit position. Also, reload the BitPeriodCnt counter.
        elsif ((SSPCLKDIV and BitPeriodCmp and not(BitCmp)) = '1') then
          NextSSPTXD                   <= TxShft(15);
          NextSCLK                     <= '1';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextTxShft(15 downto 1)      <= TxShft(14 downto 0); 
          NextTxShft(0 downto 0)       <= "0"; 
          SspTxRxCntlNextState         <= "000010";

        -- In the Nibble mode, decrement the BitPeriodCnt counter
        -- by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "000110";
        end if;

      -- Wait for the first SCLK phase time after SCLK has been pulled low
      -- for the last time.
      when "000111" =>

        -- When not in nibble mode decrement the BitPeriodCnt
        -- counter by 1 on every SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "000111";

        -- In the Nibble mode, decrement the BitPeriodCnt counter
        -- by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "000111";

        --  Reload the BitPeriodCnt counter to wait for one more
        -- SCLK phase time.
        elsif ((SSPCLKDIV and BitPeriodCmp) = '1') then
          if (FRC = '1') then
            NextSCLK          <= '1';
          end if;
          NextBitPeriodCnt     <= SCR(7 downto 0);
          SspTxRxCntlNextState <= "001111";
        end if;

      -- Transmit the last data bit.
      when "000101" =>

        -- Pull SCLK low and then wait for one SCLK period i.e. 2 SCLK
        -- phase times before deasserting SSPOE.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= '0';
          NextSRxFWr                   <= '1';
          NextRxFWrData                <= (RxShft(14 downto 0) & SSPRXDIn);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "000111";

        -- When not in nibble mode decrement the BitPeriodCnt
        -- counter by 1 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "000101";

        -- In the Nibble mode, decrement the BitPeriodCnt counter
        -- by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "000101";
        end if;

      -- While in this state, wait for a time duration corresponding to the
      -- high phase of SCLK after the last bit of the previous frame has been 
      -- shifted out.
      when "000100" =>

        -- Sample the last Rx data bit and load the sampled bit and the
        -- contents of the Receive shift register into the Receive
        -- buffer. Clear the receive shift register and assert the
        -- SRxFWr write enable output to the receive FIFO.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSRxFWr    <= '1';
          NextRxFWrData <= (RxShft(14 downto 0) & SSPRXDIn);
          NextRxShft    <= "000000000000000";

          -- Reload the BitPeriodCnt counter and pull SCLK low for the
          -- second SCLK phase during which SFRM is to be pulled high.
          NextSCLK                     <= '0';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "000001";

        -- When not in nibble mode decrement the BitPeriodCnt
        -- counter by 1 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "000100";

        -- In the Nibble mode, decrement the BitPeriodCnt counter
        -- by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
          elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "000100";
        end if;

      -- Stay in this state for the first SCLK phase during which SFRM is
      -- to be driven high.
      when "001100" =>

        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "001100";

        -- The BitPeriodCnt counter has counted down to 0 i.e. one half
        -- period of SCLK has elapsed. Assert SSPOE one half SCLK
        -- earlier than the time at which SSPTXD is supposed to be
        -- driven with valid data. This is done to account for pad
        -- delays.
        elsif ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSSPOE <= '1';

          -- Reload the BitPeriodCnt counter and pull SCLK low for the
          -- second SCLK phase during which SFRM is to be pulled high.
          NextSCLK                     <= '0';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "000001";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "001100";
        end if;

      -- Transmit Data is available in the transmit FIFO. Wait for the next
      -- pulse on SSPCLKDIV to start the frame.
      when "001101" =>

        -- SSPCLKDIV asserted, so start frame now. Load transmit
        -- data into the transmit shift register, initialise
        -- the BitPeriodCnt and BitCnt counters and assert the
        -- STxFRdPtrInc signal for the Transmit FIFO.
        if ((SSPCLKDIV) = '1') then
          NextSCLK                     <= '1';
          NextSFRM                     <= '1';
          NextSTxFRdPtrInc             <= '1';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextBitCnt(3 downto 0)       <= DSS(3 downto 0);
          NextTxShft(15 downto 0)      <= TxFRdDataIn(15 downto 0);
          SspTxRxCntlNextState         <= "001100";
        end if;

      -- Wait for one last SCLK phase time before de-asserting SSPOE.
      when "001111" =>
        -- De-assert SSPOE and return to idle state.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSTxRxBSY         <= '0';
          NextSSPOE            <= '0';
          if (FRC = '1') then
            NextSCLK         <= '0';
            NextBitPeriodCnt <= SCR(7 downto 0);
          end if;
          SspTxRxCntlNextState <= "000000";

        -- When not in nibble mode decrement the BitPeriodCnt
        -- counter by 1 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "001111";

        -- In the Nibble mode, decrement the BitPeriodCnt counter
        -- by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "001111";
        end if;

        when "100000"=>
          -- This state produces a High phase on SCLK when SCLKcnt is greater
          -- than 0. This is used in the Extended Frame Test
          if ((SSPCLKDIV and  BitPeriodCmp) = '1') then
            NextSCLK             <= '0';
            NextBitPeriodCnt     <= SCR(7 downto 0);
            SspTxRxCntlNextState <= "000001";
          elsif ((SSPCLKDIV = '1') and (BitPeriodCmp = '0')) then
            NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
            SspTxRxCntlNextState <= "100000";
          end if;
      -- Wait for data to be available in the transmit FIFO provided the
      -- frame format is not changed.
      when "001110" =>

        -- National Microwire frame format is no longer the programmed
        -- frame format.
        if ((not(FRF(1) and not(FRF(0)))) = '1') then
          -- Motorola SPI Frame format selected.
          if ((not(FRF(1)) and not(FRF(0))) = '1') then
            -- Initialise the outputs to their inactive values.
            NextSTxRxBSY         <= '0';
            NextSSPOE            <= '0';
            NextSSPTXD           <= '0';
            NextSCLK             <= SPO;
            NextSFRM             <= '1';
            SspTxRxCntlNextState <= "011100";

          -- Texas Instruments' Synchronous Serial frame format
          -- selected.
          elsif ((not(FRF(1)) and FRF(0)) = '1') then
            -- Initialise the outputs to their inactive values.
            NextSTxRxBSY         <= '0';
            NextSSPOE            <= '0';
            NextSSPTXD           <= '0';
            NextSCLK             <= '0';
            NextSFRM             <= '0';
            SspTxRxCntlNextState <= "000000";
          end if;

        -- Transmit Data available in the transmit FIFO.
        elsif ((FRF(1) and not(FRF(0)) and TxDataAvlblSync and 
                BitPeriodCmp and (not(FRC) or LocalSCLK)) = '1') then
          NextSTxRxBSY <= '1';
          -- SSPCLKDIV is not currently asserted, so wait for the next
          -- SSPCLKDIV pulse.
          if ((not(SSPCLKDIV)) = '1') then
            SspTxRxCntlNextState <= "001010";
            -- SSPCLKDIV asserted, so start frame now. Load transmit
            -- data into the transmit shift register, initialise
            -- the BitPeriodCnt and BitCnt counters and assert the
            -- STxFRdPtrInc signal for the Transmit FIFO.
          elsif ((SSPCLKDIV) = '1') then
            NextSSPOE                    <= '1';
            NextSFRM                     <= '0';
            NextSTxFRdPtrInc             <= '1';
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            NextTxShft(15 downto 0)      <= TxFRdDataIn(15 downto 0);
            NextSCLK                     <= '0';
            NextRxShft                   <= "000000000000000";
            SspTxRxCntlNextState         <= "001011";
          end if;
        elsif ((FRF(1) and not(FRF(0)) and FRC) = '1') then
        -- If FRC bit is set, SCLK is Free running even when the Tx FIFO
        -- contains no data
          if ((SSPCLKDIV and BitPeriodCmp)  = '1') then
            NextSCLK         <= not(LocalSCLK);
            NextBitPeriodCnt <= SCR(7 downto 0);
          elsif ((SSPCLKDIV and not(BitPeriodCmp)) = '1') then
            NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
            SspTxRxCntlNextState <= "001110";
          end if;
        end if;
      when "001010" =>
        -- SSPCLKDIV asserted, so start frame now. Load transmit
        -- data into the transmit shift register, initialise
        -- the BitPeriodCnt and BitCnt counters and assert the
        -- STxFRdPtrInc signal for the Transmit FIFO.
        if ((SSPCLKDIV) = '1') then
          NextSSPOE                    <= '1';
          NextSFRM                     <= '0';
          NextSTxFRdPtrInc             <= '1';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextTxShft(15 downto 0)      <= TxFRdDataIn(15 downto 0);
          NextRxShft                   <= "000000000000000";
          NextSCLK                     <= '0';
          SspTxRxCntlNextState         <= "001011";
        end if;

      -- Stay in this state for the first state of SCLK.
      when "001011" =>
        -- One SCLK phase elapsed after SFRM was first asserted. Shift
        -- out the MSBit of the transmit data onto the SSPTXD line
        -- and shift the transmit shift register left by one bit
        -- position.
        
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSSPTXD              <= TxShft(15);
          NextTxShft(15 downto 1) <= TxShft(14 downto 0); 
          NextTxShft(0 downto 0)  <= "0"; 
              
          -- Load 7 into the BitCnt counter because the transmit data
          -- size is always 8 bits in this frame format.
          NextSCLK                     <= '1';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextBitCnt(3 downto 0)       <= "0111";
          SspTxRxCntlNextState         <= "001001";

        -- In the normal mode i.e. when Nibmode is not asserted,
          -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "001011";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "001011";
        end if;

      -- Wait for a time duration corresponding to one phase of SCLK.
      when "001001" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "001001";

        -- Pull SCLK high and reload the BitPeriodCnt counter.
        elsif ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= not(LocalSCLK);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "001000";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "001001";
        end if;

      -- Wait for a time duration corresponding to one phase of SCLK.
      when "001000" =>
        -- Clock out the MSBit from the Transmit shift register onto
        -- the SSPTXD output line and shift the contents of the
        -- Transmit shift register left by one bit position.
        if ((SSPCLKDIV and BitPeriodCmp and not(BitCmp)) = '1') then
          NextSSPTXD                   <= TxShft(15);
          NextSCLK                     <= not(LocalSCLK);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextBitCnt                   <= unsigned(BitCnt) - 1;
          NextTxShft(15 downto 1)      <= TxShft(14 downto 0); 
          NextTxShft(0 downto 0)       <= "0"; 
          SspTxRxCntlNextState         <= "001001";

        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "001000";

        -- All bits in the transmit data have been shifted out.
        elsif ((SSPCLKDIV and BitPeriodCmp and BitCmp) = '1') then
          NextSSPTXD <= '0';
        -- Pull SCLK low and reload the BitPeriodCnt counter.
          NextSCLK                     <= not(LocalSCLK);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "011000";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "001000";
        end if;

      -- Wait for a time duration corresponding to one phase time of SCLK.
      when "011000" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "011000";

        -- De-assert SSPOE, pull SCLK high and reload the BitPeriodCnt
        -- counter.
        elsif ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSSPOE                    <= '0';
          NextSCLK                     <= not(LocalSCLK);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "011001";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "011000";
        end if;
 
      -- Wait for a time duration corresponding to one phase of SCLK.
      when "011001" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "011001";

        -- One SCLK wait period completed between transmission and 
        -- reception. De-assert TxFRdPrtInc and SRxFWr output signals.
        elsif ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSTxFRdPtrInc <= '0';
          NextSRxFWr       <= '0';
              
          -- Clear the Receive shift register to start reception. Load
          -- the BitCnt counter with DSS and the BitPeriodCnt counter
          -- with SCR.
          NextSCLK                     <= not(LocalSCLK);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextBitCnt(3 downto 0)       <= DSS(3 downto 0);
          NextRxShft                   <= "000000000000000";
          SspTxRxCntlNextState         <= "011011";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "011001";
        end if;

      -- Wait for a time duration corresponding to one SCLK phase.
      when "011011" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "011011";

        -- Sample the next bit on the SSPRXDIn line and shift it into
        -- the receive shift register.
        elsif ((SSPCLKDIV and BitPeriodCmp and not(BitCmp)) = '1') then
          NextSCLK                     <= not(LocalSCLK);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextRxShft(14 downto 0)      <= (RxShft(13 downto 0) & SSPRXDIn);
          SspTxRxCntlNextState         <= "011010";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "011011";

        -- Sample the last bit on the SSPRXDIn input and load it into
        -- the Receive buffer along with the contents of the Receive
        -- shift register.
        elsif ((SSPCLKDIV and BitPeriodCmp and BitCmp) = '1') then
          NextSCLK      <= not(LocalSCLK);
          NextSRxFWr     <= '1';
          NextRxFWrData <= (RxShft(14 downto 0) & SSPRXDIn);

          -- No more data available for transmission.
          if ((not(TxDataAvlblSync)) = '1') then
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            SspTxRxCntlNextState         <= "011111";

          -- More transmit data is available in the Transmit FIFO, so
          -- reload the BitPeriodCnt counter with SCR.
          elsif ((TxDataAvlblSync) = '1') then
            NextSSPOE                    <= '1';
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            SspTxRxCntlNextState         <= "011101";
          end if;
        end if;

      -- Wait for a time duration corresponding to one SCLK phase.
      when "011010" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "011010";

        -- Toggle SCLK and reload the BitPeriodCnt counter.
        elsif ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= not(LocalSCLK);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextBitCnt                   <= unsigned(BitCnt) - 1;
          SspTxRxCntlNextState         <= "011011";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "011010";
        end if;

      -- Wait for a period of time corresponding to one SCLK phase.
      when "011110" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "011110";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "011110";

        -- End of frame reached.
        elsif ((SSPCLKDIV and BitPeriodCmp) = '1') then
          -- End of Frame reached, so pull SFRM high.
          NextSTxRxBSY          <= '0';
          NextSFRM             <= '1';
          SspTxRxCntlNextState <= "001110";
        end if;

      -- Wait for a time duration corresponding to one SCLK phase.
      when "011111" =>
        -- Pull SCLK low and reload the BitPeriodCnt counter.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= not(LocalSCLK);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "011110";
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "011111";
        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "011111";
        end if;

      -- Wait for one SCLK phase time before shifting out the next transmit
      -- data.
      when "011101" =>
        -- Clock out the MSBit of the next transmit data onto the SSPTXD
        -- line. Load the transmit shift register with the remaining 15
        -- bits in the transmit data appended with a 0.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSSPTXD              <= TxFRdDataIn(15);
          NextSTxFRdPtrInc        <= '1';
          NextTxShft(15 downto 0) <= (TxFRdDataIn(14 downto 0) & '0');
          -- Load 7 into the BitCnt counter because the transmit data
          -- size is always 8 bits in this frame format.
          NextSCLK                     <= not(LocalSCLK);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextBitCnt(3 downto 0)       <= "0111";
          SspTxRxCntlNextState         <= "001001";

        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "011101";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "011101";
        end if;

      -- Wait for data to be available in the transmit FIFO provided the
      -- frame format is not changed.
      when "011100" =>
        -- Motorola's SPI Frame Format is no longer the programmed frame
        -- format.
        if ((not(not(FRF(1)) and not(FRF(0)))) = '1') then
          -- Texas Instruments' Synchronous Serial Frame format
          -- selected.
          if ((not(FRF(1)) and FRF(0)) = '1') then
            -- Initialise the outputs to their inactive values.
            NextSTxRxBSY         <= '0';
            NextSSPOE            <= '0';
            NextSSPTXD           <= '0';
            NextSCLK             <= '0';
            NextSFRM             <= '0';
            SspTxRxCntlNextState <= "000000";
          -- National Microwire Frame format selected.
          elsif ((FRF(1) and not(FRF(0))) = '1') then
            -- Initialise the outputs to their inactive values.
            NextSTxRxBSY         <= '0';
            NextSSPOE            <= '0';
            NextSSPTXD           <= '0';
            NextSCLK             <= '0';
            NextSFRM             <= '1';
            SspTxRxCntlNextState <= "001110";
          end if;
        -- Transmit data available in the Transmit FIFO.
        elsif ((not(FRF(1)) and not(FRF(0)) and TxDataAvlblSync) = '1') then
          NextSTxRxBSY <= '1';
          -- SSPCLKDIV is not currently asserted, so wait for the next
          -- SSPCLKDIV pulse.
              
          if ((not(SSPCLKDIV)) = '1') then
            SspTxRxCntlNextState <= "010100";
          -- SSPCLKDIV asserted, so start frame now. Load transmit
          -- data into the transmit shift register, initialise
          -- the BitPeriodCnt and BitCnt counters and assert the
          -- STxFRdPtrInc signal for the Transmit FIFO.
          elsif ((SSPCLKDIV) = '1') then
            NextSSPOE                    <= '1';
            NextSFRM                     <= '0';
            NextSTxFRdPtrInc             <= '1';
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            NextBitCnt(3 downto 0)       <= DSS(3 downto 0);
            NextTxShft(15 downto 0)      <= TxFRdDataIn(15 downto 0);
            NextRxShft                   <= "000000000000000";
            SspTxRxCntlNextState         <= "010101";
          end if;
        end if;

      -- Transmit Data is available in the transmit FIFO. Wait for the next
      -- pulse on SSPCLKDIV to start the frame.
      
      when "010100" =>
        -- SSPCLKDIV asserted, so start frame now. Load transmit
        -- data into the transmit shift register, initialise
        -- the BitPeriodCnt and BitCnt counters and assert the
        -- STxFRdPtrInc signal for the Transmit FIFO.
        if ((SSPCLKDIV) = '1') then
          NextSSPOE                    <= '1';
          NextSFRM                     <= '0';
          NextSTxFRdPtrInc             <= '1';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextBitCnt(3 downto 0)       <= DSS(3 downto 0);
          NextTxShft(15 downto 0)      <= TxFRdDataIn(15 downto 0);
          NextRxShft                   <= "000000000000000";
          SspTxRxCntlNextState         <= "010101";
        end if;
  
      -- Stay in this state for the first phase of SCLK.
      when "010101" =>
        -- One SCLK phase elapsed after SFRM was first asserted.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSSPTXD              <= TxShft(15);
          NextTxShft(15 downto 1) <= TxShft(14 downto 0); 
          NextTxShft(0 downto 0)  <= "0"; 
              
          -- Drive the XOR of SPO and SPH on the SCLK line.
          -- Shift the Transmit shift register left by one bit 
          -- position and reload the BitPeriodCnt counter
          -- with SCR.
          NextSCLK                     <= (SPO xor SPH);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "010111";

        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "010101";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "010101";
        end if;

      -- Wait for an SCLK phase after shifting out a bit onto the
      -- SSPTXD line.
      when "010111" =>
        -- Sample SSPRXDIn and shift the sampled data bit into the
        -- receive shift register. Toggle SCLK and decrement the
          -- BitCnt counter by 1.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= (not(SPO xor SPH));
          NextRxShft(14 downto 0)      <= (RxShft(13 downto 0) & SSPRXDIn);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextBitCnt                   <= unsigned(BitCnt) - 1;
          SspTxRxCntlNextState         <= "010110";

        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "010111";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "010111";
        end if;

      -- Wait for an SCLK phase after sampling one bit on the SSPRXDIn
      -- input line.
      when "010110" =>
        -- One half phase of SCLK elapsed, so toggle SCLK.
        -- Clock out the MSBit of the transmit Shift register into
        -- SSPTXD and shift the contents of the shift register left by
        -- one bit position. Also, reload the BitPeriodCnt
        -- counter.
        if ((SSPCLKDIV and BitPeriodCmp and not(BitCmpHalf)) = '1') then
          NextSSPTXD                   <= TxShft(15);
          NextSCLK                     <= (SPO xor SPH);
          NextTxShft(15 downto 1)      <= TxShft(14 downto 0); 
          NextTxShft(0 downto 0)       <= "0"; 
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "010111";

        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "010110";

        -- One half of the frame has elapsed, so deassert STxFRdPtrInc
        -- and SRxFWr. Shift out the next Transmit bit and reload the
        -- BitPeriodCnt counter.
        elsif ((SSPCLKDIV and BitPeriodCmp and BitCmpHalf) = '1') then
          NextSSPTXD                   <= TxShft(15);
          NextSCLK                     <= (SPO xor SPH);
          NextSTxFRdPtrInc             <= '0';
          NextSRxFWr                   <= '0';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextTxShft(15 downto 1)      <= TxShft(14 downto 0); 
          NextTxShft(0 downto 0)       <= "0"; 
          SspTxRxCntlNextState         <= "010010";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "010110";
        end if;

      -- Wait for an SCLK phase after shifting out a bit onto the
      -- SSPTXD line.
      when "010010" =>
        -- Sample SSPRXDIn and shift the sampled data bit into the
        -- receive shift register. Toggle SCLK and decrement the
        -- BitCnt counter by 1.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= (not(SPO xor SPH));
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextRxShft(14 downto 0)      <= (RxShft(13 downto 0) & SSPRXDIn);
          NextBitCnt                   <= unsigned(BitCnt) - 1;
          SspTxRxCntlNextState         <= "010011";

        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "010010";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "010010";
        end if;

      -- Wait for an SCLK phase after sampling one bit on the SSPRXDIn
      -- input line.
      when "010011" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "010011";
        -- One half phase of SCLK elapsed, so toggle SCLK.
        -- Clock out the MSBit of the transmit Shift register into
        -- SSPTXD and shift the contents of the shift register left
        -- by one bit position. Also, reload the BitPeriodCnt
        -- counter.
        elsif ((SSPCLKDIV and BitPeriodCmp and not(BitCmp)) = '1') then
          NextSSPTXD                   <= TxShft(15);
          NextSCLK                     <= (SPO xor SPH);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          NextTxShft(15 downto 1)      <= TxShft(14 downto 0); 
          NextTxShft(0 downto 0)       <= "0"; 
          SspTxRxCntlNextState         <= "010010";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "010011";

        elsif ((SSPCLKDIV and BitPeriodCmp and BitCmp) = '1') then
          -- Shift out the last bit onto the SSPTXD line.
          NextSSPTXD                   <= TxShft(15);
          NextSCLK                     <= (SPO xor SPH);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "010000";
        end if;

      -- Wait for one SCLK phase beforepulling SFRM high again.
      when "010001" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "010001";
        -- End of frame reached, so pull SFRM high and de-assert
        -- STxFRdPtrInc and SRxFWr.
        elsif ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSTxRxBSY         <= '0';
          NextSSPOE            <= '0';
          NextSFRM             <= '1';
          NextSTxFRdPtrInc     <= '0';
          NextSRxFWr           <= '0';
          SspTxRxCntlNextState <= "011100";
        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "010001";
        end if;

      -- Wait for a time duration corresponding to the SCLK phase
      -- after the last Tx bit has been shifted out.
      when "010000" =>
        -- Sample the last Rx bit from the SSPRXD input and clock it
        -- into the receive buffer along with the contents of the
        -- receive shift register.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= (not(SPO xor SPH));
          NextSRxFWr                   <= '1';
          NextRxFWrData                <= (RxShft(14 downto 0) & SSPRXDIn);
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "110000";

        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "010000";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
      elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "010000";
        end if;

      -- Wait for a time duration corresponding to one SCLK phase duration
      -- after the last Rx bit has been sampled from SSPRXD.
        when "110000" =>
        -- All bits shifted out/sampled.
        if ((SSPCLKDIV and BitPeriodCmp) = '1') then
          -- No more transmit data available, so set SSPTXD and
          -- SCLK to their default values.
          if ((not(TxDataAvlblSync)) = '1') then
            NextSSPTXD                   <= '0';
            NextSCLK                     <= SPO;
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            SspTxRxCntlNextState         <= "010001";

          -- More transmit data available in the Transmit FIFO
          -- and SPH is programmed to a value of 0,
          -- so deassert SFRM for one SCLK phase time.
          elsif ((TxDataAvlblSync and not(SPH)) = '1') then
            NextSSPTXD                   <= '0';
            NextSCLK                     <= SPO;
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            SspTxRxCntlNextState         <= "110001";

          -- SPISFRMEn bit is set, so SFRM needs to be deactivated for
          -- one SCLK phase time.
          elsif ((TxDataAvlblSync and  (SPH and SPISFRMEn)) = '1') then
            NextSSPTXD           <= '0';
            NextSCLK             <= SPO;
            NextSFRM             <= '1';
            NextBitPeriodCnt     <= SCR(7 downto 0);
            SspTxRxCntlNextState <= "110011";

          -- More transmit data available in the Transmit FIFO
          -- and the value of SPH is programmed to 1,
          -- so clock in the MSBit of Transmit data onto the TXDSS
          -- line and load the shift register with the next 15 bits
          -- in the Transmit Data, appended with a 0. SFRM
          -- does not need to be de-asserted between 
          -- successive data characters.
          elsif ((TxDataAvlblSync and SPH and not(SPISFRMEn)) = '1') then
            NextSSPTXD              <= TxFRdDataIn(15);
            NextSTxFRdPtrInc        <= '1';
            NextTxShft(15 downto 0) <= (TxFRdDataIn(14 downto 0) & '0');
            NextBitCnt(3 downto 0)  <= DSS(3 downto 0);
            NextRxShft <= "000000000000000";

            -- Drive the XOR of SPO and SPH on the SCLK line.
            -- Shift the Transmit shift register left by one bit 
            -- position and reload the BitPeriodCnt counter
            -- with SCR.
            NextSCLK                     <= (SPO xor SPH);
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            SspTxRxCntlNextState         <= "010111";
          end if;

        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "110000";

        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
          elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt       <= unsigned(BitPeriodCnt) - 17;
            SspTxRxCntlNextState <= "110000";
        end if;
      
      when "110001" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "110001";
        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "110001";
        -- After one SCLK phase time, de-assert SFRM and pull
        -- SCLK to its inactive level.
        elsif ((SSPCLKDIV and BitPeriodCmp) = '1') then
          NextSCLK                     <= SPO;
          NextSFRM                     <= '1';
          NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
          SspTxRxCntlNextState         <= "110011";
        end if;
      
      when "110011" =>
        -- In the normal mode i.e. when Nibmode is not asserted,
        -- decrement  the BitPeriodCnt counter by 1 on every
        -- SSPCLKDIV pulse.
        if ((SSPCLKDIV and not(BitPeriodCmp) and not(Nibmode)) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 1;
          SspTxRxCntlNextState <= "110011";
        -- In the Nibble mode i.e. when Nibmode is asserted, decrement 
        -- the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
        elsif ((SSPCLKDIV and not(BitPeriodCmp) and Nibmode) = '1') then
          NextBitPeriodCnt     <= unsigned(BitPeriodCnt) - 17;
          SspTxRxCntlNextState <= "110011";
        elsif ((BitPeriodCmp) = '1') then
          -- SSPCLKDIV is not currently asserted, so wait for the next
          -- SSPCLKDIV pulse.
          if ((not(SSPCLKDIV)) = '1') then
            SspTxRxCntlNextState <= "010100";
            -- SSPCLKDIV asserted, so start frame now. Load transmit
            -- data into the transmit shift register, initialise
            -- the BitPeriodCnt and BitCnt counters and assert the
            -- STxFRdPtrInc signal for the Transmit FIFO.
          elsif ((SSPCLKDIV) = '1') then
            NextSSPOE                    <= '1';
            NextSFRM                     <= '0';
            NextSTxFRdPtrInc             <= '1';
            NextBitPeriodCnt(7 downto 0) <= SCR(7 downto 0);
            NextBitCnt(3 downto 0)       <= DSS(3 downto 0);
            NextTxShft(15 downto 0)      <= TxFRdDataIn(15 downto 0);
            NextRxShft                   <= "000000000000000";
            SspTxRxCntlNextState         <= "010101";
          end if;
        end if;
        
      when "110010" =>
        -- Texas Instruments' Synchronous Serial frame format
        -- selected and the SSP is enabled.
        if ((not(FRF(1)) and FRF(0) and SSESync) = '1') then
          -- Initialise the outputs to their inactive values.
          NextSTxRxBSY <= '0';
          NextSSPOE <= '0';
          NextSSPTXD <= '0';
          NextSCLK <= '0';
          NextSFRM <= '0';
          SspTxRxCntlNextState <= "000000";
        -- Motorola SPI Frame format selected and the SSP is enabled.
        elsif ((not(FRF(1)) and not(FRF(0)) and SSESync) = '1') then
          -- Initialise the outputs to their inactive values.
          NextSTxRxBSY <= '0';
          NextSSPOE <= '0';
          NextSSPTXD <= '0';
          NextSCLK <= SPO;
          NextSFRM <= '1';
          SspTxRxCntlNextState <= "011100";
        -- National Microwire Frame format selected and the
        -- SSP is enabled.
        elsif ((FRF(1) and not(FRF(0)) and SSESync) = '1') then
          -- Initialise the outputs to their inactive values.
          NextSTxRxBSY         <= '0';
          NextSSPOE            <= '0';
          NextSSPTXD           <= '0';
          NextSCLK             <= '0';
          NextSFRM             <= '1';
          SspTxRxCntlNextState <= "001110";
        end if;

      when others =>
        NextSTxRxBSY         <= '0';
        NextSSPOE            <= '0';
        NextSSPTXD           <= '0';
        NextSCLK             <= (not(FRF(1)) and not(FRF(0)) and SPO);
        NextSFRM             <= not(FRF(0));
        NextSTxFRdPtrInc     <= '0';
        NextSRxFWr           <= '0';
        NextRxFWrData        <= "0000000000000000";
        SspTxRxCntlNextState <= "110010";
    end case;
  end if;
-- Any state overrides...
end process combo;

-- -----------------------------------------------------------------------------
-- Bit period counter.
-- -----------------------------------------------------------------------------
BitPeriodCnt_seq : process(SSPCLK, nSSPRES) 
begin
  -- When nSSPRES is asserted, transition to the ST_RESET state and
  -- wait for the SSP to be enabled.
  if ((not(nSSPRES)) = '1') then
    BitPeriodCnt <= "11111111";
  elsif (SSPCLK'event and SSPCLK = '1') then
    if (ClkEnable = '1') then
      BitPeriodCnt <= NextBitPeriodCnt;
    end if;
  end if;
end process BitPeriodCnt_seq;

-- -----------------------------------------------------------------------------
-- Bit counter
-- -----------------------------------------------------------------------------
BitCnt_seq : process(SSPCLK, nSSPRES) 
begin
  -- When nSSPRES is asserted, transition to the ST_RESET state and
  -- wait for the SSP to be enabled.
  if ((not(nSSPRES)) = '1') then
    BitCnt <= "1111";
  elsif (SSPCLK'event and SSPCLK = '1') then
    if (ClkEnable = '1') then
      BitCnt <= NextBitCnt;
    end if;
  end if;
end process BitCnt_seq;

-- -----------------------------------------------------------------------------
-- Transmit shift register
-- -----------------------------------------------------------------------------
TxShft_seq : process(SSPCLK, nSSPRES) 
begin
  -- When nSSPRES is asserted, transition to the ST_RESET state and
  -- wait for the SSP to be enabled.
  if ((not(nSSPRES)) = '1') then
    TxShft <= "0000000000000000";
  elsif (SSPCLK'event and SSPCLK = '1') then
    if (ClkEnable = '1') then
      TxShft <= NextTxShft;
    end if;
  end if;
end process TxShft_seq;

-- -----------------------------------------------------------------------------
-- Receive shift register
-- -----------------------------------------------------------------------------
RxShft_seq : process(SSPCLK, nSSPRES) 
begin
  -- When nSSPRES is asserted, transition to the ST_RESET state and
  -- wait for the SSP to be enabled.
  if ((not(nSSPRES)) = '1') then
    RxShft <= "000000000000000";
  elsif (SSPCLK'event and SSPCLK = '1') then
    if (ClkEnable = '1') then
      RxShft <= NextRxShft;
    end if;
  end if;
end process RxShft_seq;
end synth;

--------------------------------------------------------------------------------
--  Signals: SspTxRxCntlState<5:0> SspTxRxCntlNextState<5:0> 
--    ST_TIIDLE	        000000
--    ST_TISFRM2	000001
--    ST_TISHIFT1	000011
--    ST_TISTG2        	000010
--    ST_TISHIFT2	000110
--    ST_TISSPOE1	000111
--    ST_TILASTBIT	000101
--    ST_TITXFNE	000100
--    ST_TISFRM1	001100
--    ST_TIDATAAVLBL	001101
--    ST_TISSPOE2	001111
--    ST_NMIDLE	        001110
--    ST_NMDATAAVLBL	001010
--    ST_NMSFRM	        001011
--    ST_NMTXBIT	001001
--    ST_NMTXBIT2	001000
--    ST_NMWAIT1	011000
--    ST_NMWAIT2	011001
--    ST_NMRX1	        011011
--    ST_NMRX2	        011010
--    ST_NMSFRMLAST	011110
--    ST_NMRXLAST	011111
--    ST_NMTXFNE	011101
--    ST_SPIIDLE	011100
--    ST_SPIDATAAVLBL	010100
--    ST_SPISFRM	010101
--    ST_SPITX1        	010111
--    ST_SPIRX1	        010110
--    ST_SPITX2	        010010
--    ST_SPIRX2	        010011
--    ST_SPISFRMEND	010001
--    ST_SPILASTTX	010000
--    ST_SPILASTRX	110000
--    ST_SPISD1	        110001
--    ST_SPISD2	        110011
--    ST_RESET        	110010
--------------------------------------------------------------------------------
