-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciTrPtoS.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           MMCI Trickbox Parallel to serial convertor/
--           Transmitter module
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrPtoS is
  port (
-- Inputs
        MMCICLK          : in    std_logic; -- MMCI Bus clock
        nMMCIRST         : in    std_logic; -- APB Bus reset
        ResponseBits     : in    std_logic_vector(1 downto 0);
                                            -- Response bits from
                                            -- cmd Reg
        CmdEnable        : in    std_logic; -- Enable for command path
        CmdRespCnt       : in    std_logic_vector(31 downto 0);
                                            -- Counter to indicate when
                                            -- response is to be sent
        MMCITBCmdRespWr  : in    std_logic; -- Write En for CmdInd Reg
        MMCITBResp0Wr    : in    std_logic; -- Write En for Response
                                            -- Reg 0
        MMCITBResp1Wr    : in    std_logic; -- Write En for Response
                                            -- Reg 1
        MMCITBResp2Wr    : in    std_logic; -- Write En for Response
                                            -- Reg 2
        MMCITBResp3Wr    : in    std_logic; -- Write En for Response
                                            -- Reg 3
        CRC7             : in    std_logic_vector(6 downto 0);
                                            -- CRC7 calculated value
        CrcBufferBit     : in    std_logic; -- Buffer bit for CRC7
        CmdCrcErr        : in    std_logic; -- To induce incorrect
                                            -- crcs with Command
                                            -- Response
        DataEn           : in    std_logic; -- Data Tx/Rx Enable Bit
        DataDirection    : in    std_logic; -- Direction of Data
                                            -- 0-From Contoller
                                            -- 1-From card
        DataMode         : in    std_logic; -- 0-Block Mode
                                            -- 1-Stream Mode
        DataLength       : in    std_logic_vector(15 downto 0);
                                            -- Number of bytes of Data
        Blocklen         : in    std_logic_vector(3 downto 0);
                                            -- Number of bytes in a
                                            -- block
        MDCStg2WrEn      : in    std_logic; -- Indicates any write to
                                            -- MMCIDataCtrl register
        TxFRdData        : in    std_logic_vector(31 downto 0);
                                            -- Data from Tx FIFO
        CRC160           : in    std_logic_vector(15 downto 0);
                                            -- CRC16 for data line 0
        DCrcBufferBit    : in    std_logic_vector(3 downto 0);
                                            -- Buffer bit for CRC16,
                                            -- One/line
        DataTimeCnt      : in    std_logic_vector(31 downto 0);
                                            -- Timer for data
                                            -- transmission
        TokenTimeCnt     : in    std_logic_vector(15 downto 0);
                                            -- Timer for token
                                            -- transmission
        BsyTimeCnt       : in    std_logic_vector(15 downto 0);
                                            -- Timer for Busy duration
        DataRxd          : in    std_logic; -- Indicates Data has
                                            -- been rxd
        TokenErrBit      : in    std_logic; -- 1-Send incorrect token
        DataCrcErr       : in    std_logic; -- To induce incorrect
                                            -- crcs on data lines
        SendResponse     : in    std_logic; -- Qualifies sending of
                                            -- response
        RxCommand        : in    std_logic; -- Qualifies command
                                            -- reception
        PWDATAIn         : in    std_logic_vector(31 downto 0);
                                            -- Internal version of APB
                                            -- Write
                                            -- Data Bus
-- Outputs
        TokenSent        : out   std_logic; -- Indicates token has
                                            -- been sent
        TkCntOver        : out   std_logic; -- Qualifies Token
        TxFRd            : out   std_logic; -- Read enable to Tx FIFO
        TCRC7En          : out   std_logic; -- CRC7 calculation enable
        TCRC16En         : out   std_logic; -- CRC16 calculation enable
        BlkEnd           : out   std_logic; -- Indicates the end of blk
        MMCICMD          : out   std_logic; -- MMCI Comand serial output
        MMCIDAT          : out   std_logic  -- MMCI serial data output
       );
end MmciTrPtoS;

-- -----------------------------------------------------------------------------
--
--                                 MmciTrPtoS
--                                 ==========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--   This module supports the logic from transmission of cmd Response
-- and Crc tokens and block/stream mode data.The bits to transmitted
-- is stored in respective registers and the MmciTrPtoS module converts
-- this parallel data into a serial one and transmits them on the
-- respective bus.This module is controlled by the data tx/rx
-- handshakes, to ensure the correct timing of tokens, Response and data
-- This module also gets inputs from the crc generators, aiding them in
-- transmitting the correct crc with command responses and block mode
-- data.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of MmciTrPtoS is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal CmdBit           : std_logic;
-- Command Bit that is to be transmitted serailly

signal CmdCnt           : std_logic_vector(7 downto 0) := "00000000";
-- Counter to keep track of command fields

signal CmdShiftReg      : std_logic_vector(31 downto 0);
-- Shift Register for serial transmission of command bits

signal IntCmdIndex      : std_logic_vector(5 downto 0);
-- Internally stored command index

signal IntRespReg0      : std_logic_vector(31 downto 0);
-- Internally stored response 0 value

signal IntRespReg1      : std_logic_vector(31 downto 0);
-- Internally stored response 1 value

signal IntRespReg2      : std_logic_vector(31 downto 0);
-- Internally stored response 2 value

signal IntRespReg3      : std_logic_vector(23 downto 0);
-- Internally stored response 3 value

signal TokenBit         : std_logic;
-- It holds the token bit that is to be transmitted

signal TokenShiftReg    : std_logic_vector(4 downto 0);
-- ShiftRegister for Token transmission

signal TokenCnt         : std_logic_vector(2 downto 0) := "111";
-- Counts the transmitted token bits

signal CRC16Check       : std_logic := '0';
-- Indicates whether the data was received correctly

signal DelTokenSent     : std_logic;
-- Delayed TokenSent

signal DelMMCIDAT0      : std_logic;
-- Delayed MMCIDAT(0)

signal iMMCIDAT0        : std_logic;
-- Local copy of MMCIDAT(0)

signal IntBlocklen      : std_logic_vector(3 downto 0)  := "0000";
-- Internal copy of Block length

signal IntBlkCnt        : std_logic_vector(11 downto 0) :=
                                                   "000000000000";
-- Internally computed block count value

signal BlkCnt           : std_logic_vector(11 downto 0) :=
                                                   "000000000000";
-- Counts down the number of bytes in a block

signal IntDataLength    : std_logic_vector(15 downto 0) :=
                                                   "1111111111111111";
-- Internal copy of DataLength

signal DataCnt          : std_logic_vector(15 downto 0) :=
                                                   "0000000000000000";
-- Counts down the number of data bytes rxd or txd

signal WrdCnt           : std_logic_vector(1 downto 0)  := "00";
-- Count to indicate reception/txn of a Word of data

signal BitCnt           : std_logic_vector(2 downto 0)  := "111";
-- Counts up on reception/txn of each bit of data

signal DataBit0         : std_logic;
-- Holds the data bit to be txd on line 0

signal DataReg          : std_logic_vector(31 downto 0);
-- Holds the data word read from the Tx FIFO

signal NextDataReg      : std_logic_vector(31 downto 0);
-- D-Input to DataReg

signal DataShiftReg     : std_logic_vector(31 downto 0);
-- Holds the data to be shifted out

signal iBlkEnd          : std_logic;
-- Signal used to separate any two blocks by 2 clocks

signal IntTxFRd         : std_logic;
-- Internal version of TxFRd

signal DelTxFRd         : std_logic;
-- Delayed IntTxFRd

signal iTxFRd           : std_logic;
-- local copy of TxFRd

signal iCRC16En         : std_logic;
-- local copy of CRC16En

signal iCRC7En          : std_logic;
-- local copy of TCRC7En

signal DelCRC7En        : std_logic;
-- Delayed version of iCRC7En

signal iTokenSent       : std_logic;
-- local copy of output TokenSent

signal NextTokenSent    : std_logic;
-- D-Input to iTokenSent

signal CntOver          : std_logic;
-- Used to qualify the time from which CmdRespCnt becomes zero

signal LoadOver         : std_logic;
-- Used to indicate that loading of counters is over

signal iTkCntOver       : std_logic;
-- Used to qualify the time from which TokenTimeCnt becomes zero

signal BsyCntOver       : std_logic;
-- Used to qualify the time from which BsyTimeCnt becomes zero

signal LoadCounters     : std_logic;
-- Enables the loading of DataCount and BlockCount before the Tx starts

signal DtTimeCntOver    : std_logic;
-- Indicates that the DataTimerCounter has run down to zero

signal DelDtTCntOver    : std_logic;
-- Delayed version of DtTimeCntOver

signal StBitSent        : std_logic;
-- Indicates that start bit has been txd

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
-- Driving Command path and Crc enable
-- -----------------------------------------------------------------------------
MMCICMD    <= CmdBit when SendResponse = '1'
          else
             'Z';

-- -----------------------------------------------------------------------------
-- Generating Crc computation enable.There exists a two clock latency
-- between the bit being transmitted and computing crc inclusive of the
-- transmitted bit.This latency forces the Tx module to hold the enable
-- high for one extra clock than usual, so the actual enable is an or of
-- iCRC7En and DelCRC7En.
-- -----------------------------------------------------------------------------
TCRC7En   <= iCRC7En or DelCRC7En;

-- -----------------------------------------------------------------------------
-- Writes to command and response registers
-- -----------------------------------------------------------------------------
p_RegisterWr : process (PWDATAIn, MMCITBCmdRespWr, MMCITBResp0Wr,
                        MMCITBResp1Wr, MMCITBResp2Wr, MMCITBResp3Wr)
begin
  if (MMCITBCmdRespWr = '1') then
    IntCmdIndex   <= PWDATAIn(5 downto 0);
  elsif (MMCITBResp0Wr = '1') then
    IntRespReg0   <= PWDATAIn(31 downto 0);
  elsif (MMCITBResp1Wr = '1') then
    IntRespReg1   <= PWDATAIn(31 downto 0);
  elsif (MMCITBResp2Wr = '1') then
    IntRespReg2   <= PWDATAIn(31 downto 0);
  elsif (MMCITBResp3Wr = '1') then
    IntRespReg3   <= PWDATAIn(23 downto 0);
  end if;
end process p_RegisterWr;
-- -----------------------------------------------------------------------------
-- Command Response Transmission logic.Once the trickbox receives a
-- command which requires a response, the SendResponse handshake goes
-- high and the process waits till the RespTimer runs to zero, then
-- depending on the CmdCnt value the respective fields of Command
-- Response are transmitted. The CmdCnt is also qualified with the
-- ResponseBits, which indicate whether the response is a short one or
-- long one.For Short response, the fields txd are, start bit, Tx bit,
-- Command Index as stored in CmdResponse register, card status as
-- stored in the Response0 register and finally the CRC7 value computed
-- for the above bits and then the end bit.For long response the
-- enabling of crc computation is done at the start of the card status,
-- and the card status transmission involves the bits in Response0,
-- Response1, Response2 and Response3 registers.
-- -----------------------------------------------------------------------------
p_TxCmdlogic : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    CmdCnt        <= "00000000";
    CmdBit        <= 'Z';
    CmdShiftReg   <= (others => '0');
    iCRC7En       <= '0';
    CntOver       <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (SendResponse = '1' and CmdEnable = '1') then
      if (CmdRespCnt = "00000000000000000000000000000001"
          and CntOver = '0') then
        CntOver <= '1';
        iCRC7En <= '1';
      elsif (CntOver = '1') then
        if (CmdCnt = "00000000") then
          CmdCnt <= unsigned(CmdCnt) + 1;
          CmdBit <= '0';
          if (ResponseBits = "01") then
            CmdShiftReg(31 downto 25)
                 <= ('0' & IntCmdIndex(5 downto 0));
          else
            CmdShiftReg(31 downto 25) <= ('0' & "111111");
            iCRC7En <= '0';
          end if;
        elsif (CmdCnt = "00000111" and ResponseBits = "11") then
          CmdBit <= '1';
          CmdCnt <= unsigned(CmdCnt) + 1;
        elsif (CmdCnt = "00001000") then
         -- common to both Short and long responses
          CmdCnt     <= unsigned(CmdCnt) + 1;
          CmdShiftReg(31 downto 1)  <= IntRespReg0(30 downto 0);
          CmdBit     <= IntRespReg0(31);
          iCRC7En    <= '1';
        elsif (CmdCnt = "00101000") then
          CmdCnt     <= unsigned(CmdCnt) + 1;
          if (ResponseBits = "01") then
            CmdBit   <= CrcBufferBit;
          else
            CmdBit   <= IntRespReg1(31);
          end if;
        elsif (CmdCnt = "00101001") then
          CmdCnt     <= unsigned(CmdCnt) + 1;
          if (ResponseBits = "01") then
            iCRC7En  <= '0';
            if (CmdCrcErr = '1') then
              CmdShiftReg(31 downto 25) <= "1110101";
              CmdBit <= '1';
            else
              CmdShiftReg(31 downto 26) <= (CRC7(4 downto 0) & '1');
              CmdBit <= CRC7(5);
            end if;
          else
            CmdShiftReg(31 downto 2)  <= IntRespReg1(29 downto 0);
            CmdBit <= IntRespReg1(30);
          end if;
        elsif (CmdCnt = "00101111" and ResponseBits = "01") then
          CmdCnt   <= "00000000";
          CntOver  <= '0';
          CmdBit   <= '1';
        elsif (CmdCnt = "01001000" and ResponseBits = "11") then
          CmdCnt   <= unsigned(CmdCnt) + 1;
          CmdShiftReg(31 downto 1) <= IntRespReg2(30 downto 0);
          CmdBit   <= IntRespReg2(31);
        elsif (CmdCnt = "01101000" and ResponseBits = "11") then
          CmdCnt   <= unsigned(CmdCnt) + 1;
          CmdShiftReg(31 downto 9) <= IntRespReg3(22 downto 0);
          CmdBit   <= IntRespReg3(23);
        elsif (CmdCnt = "10000000" and ResponseBits = "11") then
          CmdCnt   <= unsigned(CmdCnt) + 1;
          CmdBit   <= CrcBufferBit;
        elsif (CmdCnt = "10000001" and ResponseBits = "11") then
          CmdCnt   <= unsigned(CmdCnt) + 1;
          iCRC7En  <= '0';
          if (CmdCrcErr = '1') then
            CmdShiftReg(31 downto 26) <= "110001";
            CmdBit <= '1';
          else
            CmdShiftReg(31 downto 26) <= (CRC7(4 downto 0) & '1');
            CmdBit <= CRC7(5);
          end if;
        elsif (CmdCnt = "10000111" and ResponseBits = "11") then
          CmdCnt   <= "00000000";
          CntOver  <= '0';
          CmdBit   <= '1';
        else
          CmdBit <= CmdShiftReg(31);
          CmdShiftReg(31 downto 1) <= CmdShiftReg(30 downto 0);
          CmdShiftReg(0) <= '0';
          CmdCnt <= unsigned(CmdCnt) + 1;
        end if;
      else
        CmdBit <= 'Z';
      end if;
    end if;
  end if;
end process p_TxCmdlogic;

-- -----------------------------------------------------------------------------
-- Delayed version of CRC7 enable
-- -----------------------------------------------------------------------------
p_DelCRC7En : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelCRC7En  <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelCRC7En  <= iCRC7En;
  end if;
end process p_DelCRC7En;

-- -----------------------------------------------------------------------------
-- Token transmission logic.This process gets triggered when a block
-- mode of data has been received and the TokenTimer has run down to
-- zero.The token shiftregister is loaded with the token value to be txd
-- and after the transmission of the token the MMCIDAT(0) line is held
-- high till the BsyTimeCnt is not zero.
-- -----------------------------------------------------------------------------
p_TxTkBsylogic : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    TokenCnt   <= "111";
    TokenBit   <= '0';
    iTkCntOver <= '0';
    BsyCntOver <= '0';
    TokenShiftReg  <= "00000";
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (MDCStg2WrEn = '1') then
      iTkCntOver <= '0';
      BsyCntOver <= '0';
      TokenBit   <= 'Z';
    elsif (DataDirection = '0' and DataMode = '0' and DataEn = '1') then
      if (DataRxd = '1') then
        if (TokenTimeCnt = "0000000000000001" and
            iTkCntOver = '0') then
          iTkCntOver <= '1';
          TokenCnt   <= "100";
          TokenBit   <= '0';
          if (TokenErrBit = '1') then
            TokenShiftReg    <= "10110";
          else
            if (CRC16Check = '0') then
              TokenShiftReg  <= "10110";
            else
              TokenShiftReg  <= ("010" & '1' & '0');
            end if;
          end if;
        elsif (iTkCntOver = '1') then
          if (TokenCnt = "000") then
            if (BsyTimeCnt = "0000000000000001") then
              TokenBit   <= '1';
              BsyCntOver <= '1';
              TokenCnt   <= "111";
            else
              TokenBit   <= '0';
            end if;
          elsif (BsyCntOver = '1') then
            iTkCntOver <= '0';
            BsyCntOver <= '0';
            TokenBit   <= 'Z';
          else
            TokenBit <= TokenShiftReg(4);
            TokenShiftReg(4 downto 1) <= TokenShiftReg(3 downto 0);
            TokenShiftReg(0) <= '0';
            TokenCnt <= unsigned(TokenCnt) - 1;
          end if;
        end if;
      end if;
    else
      iTkCntOver <= '0';
      BsyCntOver <= '0';
      TokenBit   <= 'Z';
    end if;
  end if;
end process p_TxTkBsylogic;

-- -----------------------------------------------------------------------------
-- Checking CRC16 to determine Crc error status
-- -----------------------------------------------------------------------------
p_CRC16Check : process (CRC160)
begin
    if (CRC160 = "0000000000000000") then
      CRC16Check <= '1';
    else
      CRC16Check <= '0';
    end if;
end process p_CRC16Check;

-- -----------------------------------------------------------------------------
-- Combinational logic for generation of TokenSent
-- -----------------------------------------------------------------------------
p_NextTokenSent : process (MMCICLK, nMMCIRST, MDCStg2WrEn)
begin
  if (nMMCIRST = '0' or MDCStg2WrEn = '1') then
    NextTokenSent <= '1';
  elsif (DataEn = '1' and DataDirection = '0' and DataRxd = '1' and
        DataMode = '0') then
    if (iMMCIDAT0 = '0' and DelMMCIDAT0 = 'Z') then
      NextTokenSent <= '0';
    elsif (iMMCIDAT0 = 'Z' and DelMMCIDAT0 = '1') then
      NextTokenSent <= '1';
    else
      NextTokenSent <= iTokenSent;
    end if;
  end if;
end process p_NextTokenSent;

-- -----------------------------------------------------------------------------
-- Sequential logic for TokenSent
-- -----------------------------------------------------------------------------
p_TokenSent : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    iTokenSent <= '1';
  elsif (MMCICLK'event and MMCICLK = '1') then
    iTokenSent <= NextTokenSent;
  end if;
end process p_TokenSent;

-- -----------------------------------------------------------------------------
-- Delayed version of TokenSent
-- -----------------------------------------------------------------------------
p_DelTokenSent : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelTokenSent <= '1';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelTokenSent <= iTokenSent;
  end if;
end process p_DelTokenSent;

-- -----------------------------------------------------------------------------
-- Delayed version of MMCIDAT(0)
-- -----------------------------------------------------------------------------
p_DelMMCIDAT0 : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelMMCIDAT0 <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (DataEn = '1') then
      DelMMCIDAT0 <= iMMCIDAT0;
    else
      DelMMCIDAT0 <= '0';
    end if;
  end if;
end process p_DelMMCIDAT0;

-- -----------------------------------------------------------------------------
-- The MMCIDAT(0) is used for transmission of token and also data.The
-- signals iTkCntOver and DelDtTCntOver are used to sought out whether
-- token bit or a data bit is transmitted.
-- -----------------------------------------------------------------------------
iMMCIDAT0  <= TokenBit when iTkCntOver = '1'
          else
             DataBit0 when (DataDirection = '1' and DataEn = '1' and
                           (DtTimeCntOver = '1' or DelDtTCntOver = '1'))
          else
             'Z';

-- -----------------------------------------------------------------------------
-- Driving Data path
-- -----------------------------------------------------------------------------
MMCIDAT   <= iMMCIDAT0;

-- -----------------------------------------------------------------------------
-- Assigning outputs with local copies
-- -----------------------------------------------------------------------------
TokenSent        <= iTokenSent;
TkCntOver        <= iTkCntOver;
BlkEnd           <= iBlkEnd;
TxFRd            <= iTxFRd;
TCRC16En         <= iCRC16En;
iTxFRd           <= DelTxFRd;

-- -----------------------------------------------------------------------------
-- Making internal versions of inputs
-- -----------------------------------------------------------------------------
IntDataLength    <= DataLength;
IntBlocklen      <= Blocklen;

-- -----------------------------------------------------------------------------
-- The Command path and Data path FSM's in MMCI handle only a byte wide
-- data at a time.So while transmitting data the MSB of the first byte
-- is txd first followed by MSB of 2nd byte and so on. So, in order
-- to satisfy this the data read from the FIFO has to be properly
-- positioned in the Shift register.
-- -----------------------------------------------------------------------------
NextDataReg(31 downto 24)    <= TxFRdData(7 downto 0);
NextDataReg(23 downto 16)    <= TxFRdData(15 downto 8);
NextDataReg(15 downto 8)     <= TxFRdData(23 downto 16);
NextDataReg(7 downto 0)      <= TxFRdData(31 downto 24);

-- -----------------------------------------------------------------------------
-- Sequential logic for DataReg
-- -----------------------------------------------------------------------------
p_DataReg : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DataReg  <= (others => '0');
  elsif (MMCICLK'event and MMCICLK = '1') then
    DataReg  <= NextDataReg;
  end if;
end process p_DataReg;

-- -----------------------------------------------------------------------------
-- Delayed version of Tx FIFO read enable
-- -----------------------------------------------------------------------------
p_DelTxFRd : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelTxFRd  <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelTxFRd  <= IntTxFRd;
  end if;
end process p_DelTxFRd;

-- -----------------------------------------------------------------------------
-- Block length conversion from powers of two to actual number of bytes
-- -----------------------------------------------------------------------------
p_BlkCntcal : process (IntBlocklen, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    IntBlkCnt <= (others => '0');
  else
    case IntBlocklen is
      when "0000" => IntBlkCnt <= "000000000001";
      when "0001" => IntBlkCnt <= "000000000010";
      when "0010" => IntBlkCnt <= "000000000100";
      when "0011" => IntBlkCnt <= "000000001000";
      when "0100" => IntBlkCnt <= "000000010000";
      when "0101" => IntBlkCnt <= "000000100000";
      when "0110" => IntBlkCnt <= "000001000000";
      when "0111" => IntBlkCnt <= "000010000000";
      when "1000" => IntBlkCnt <= "000100000000";
      when "1001" => IntBlkCnt <= "001000000000";
      when "1010" => IntBlkCnt <= "010000000000";
      when "1011" => IntBlkCnt <= "100000000000";
      when others => IntBlkCnt <= "000000000001";
    end case;
  end if;
end process p_BlkCntcal;

-- -----------------------------------------------------------------------------
-- Generating enable for loading of DataCnt and BlkCnt counters
-- -----------------------------------------------------------------------------
p_LoadCounters : process (DataLength, LoadOver, MDCStg2WrEn,
                          nMMCIRST)
begin
  if (nMMCIRST = '0') then
    LoadCounters <= '0';
  elsif (DataLength'event or MDCStg2WrEn = '1') then
    LoadCounters <= '1';
  elsif (LoadOver = '1') then
    LoadCounters <= '0';
  end if;
end process p_LoadCounters;

-- -----------------------------------------------------------------------------
-- Delayed version of DtTCntOver
-- -----------------------------------------------------------------------------
p_DelDtTCntOver : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelDtTCntOver <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelDtTCntOver <= DtTimeCntOver;
  end if;
end process p_DelDtTCntOver;
-- -----------------------------------------------------------------------------
-- Data transmission logic.This process is activated when the data
-- direction and data enable bits are set and the DataTimer has run down
-- to zero.The data from the Tx FIFO is put into the DataReg and the
-- data in the DataReg is loaded into the ShiftDataReg every time the
-- WrdCnt is "11" and BitCnt is "111" and transmitted.
-- Initially when the LoadCounters is high the DataCnt and BlkCnt are
-- loaded and at the end of every block the BlkCnt is loaded again
-- till the DataCnt reaches zero.For Stream/Non WideBus Block modes the
-- DataCnt, BlkCnt's are decremented with the transmission of every byte
-- The WrdCnt is incremented with every byte, while the BitCnt is
-- BlkCnt's are decremented with the transmission of every byte.The
-- WrdCnt is incremented with every byte, while the BitCnt is
-- incremented with every bit transmitted.For WideBus Block mode the
-- counter increment/decrement is at byte/bit boundary but the BitCnt
-- value at which this is done is "001" as we receive half a byte
-- (4 bits) for every incement of BitCnt.In Block mode Data Transfer,
-- two signals StBitSent and BlkEnd are used, the tBitSent signal holds
-- the BlkCnt at its initial value, while the start bit is being sent,
-- while the lkEnd signal is used to hold the data bus in high impedance
-- for one clk duration in between two blocks.The BlkCnt that is taken
-- into consideration includes provision of 2 bytes for the CRC16 value
-- Even in WideBus Mode the CRC16 is to be sent independently on each of
-- the four lines and hence a normal count pattern (as that of
-- NonWideBus case) is followed for the BitCnt during transmission of
-- CRC16. Also CrcShiftReg take over the shifting out of bits from
-- DataShiftReg during the time CRC16 is being transmitted.
-- The process remains active till the DataCnt reaches zero and the Crc
-- bits have been transmitted.
-- -----------------------------------------------------------------------------
p_TxDatalogic : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0' or DataEn = '0' or DataDirection = '0') then
    DataCnt       <= (others => '0');
    BlkCnt        <= (others => '0');
    WrdCnt        <= "00";
    BitCnt        <= "111";
    IntTxFRd      <= '0';
    DataShiftReg  <= (others => '0');
    iCRC16En      <= '0';
    DataBit0      <= 'Z';
    LoadOver      <= '0';
    DtTimeCntOver <= '0';
    iBlkEnd       <= '0';
    StBitSent     <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (DataEn = '1' and DataDirection = '1') then
     if (LoadCounters = '1' and LoadOver = '0') then
        DataCnt       <= IntDataLength;
        BlkCnt        <= unsigned(IntBlkCnt) + 2;
        WrdCnt        <= "00";
        BitCnt        <= "111";
        LoadOver      <= '1';
        DataBit0      <= 'Z';
        DtTimeCntOver <= '0';
        DataShiftReg  <= (others => '0');
        iCRC16En      <= '0';
        iBlkEnd       <= '0';
        StBitSent     <= '0';
        iCRC16En      <= '0';
     else
      LoadOver <= '0';
      if (DataTimeCnt = "00000000000000000000000000000001" and
         DtTimeCntOver = '0') then
        DtTimeCntOver   <= '1';
      elsif (DtTimeCntOver = '1') then
        if (DataMode = '1') then
          if (DataCnt = IntDataLength and BitCnt = "111") then
            if (StBitSent = '1') then
              DataBit0  <= DataReg(31);
              IntTxFRd  <= not(IntTxFRd);
              DataCnt   <= unsigned(DataCnt) - 1;
              BitCnt    <= unsigned(BitCnt) + 1;
            else
              DataBit0  <= '0';
              DataShiftReg(31 downto 1) <= DataReg(30 downto 0);
              StBitSent <= '1';
            end if;
          elsif (DataCnt = "0000000000000000" and BitCnt = "111") then
            DataBit0      <= '1';
            DtTimeCntOver <= '0';
            StBitSent     <= '0';
            DataCnt       <= IntDataLength;
          else
            if (BitCnt = "111") then
              if (WrdCnt = "11") then
                DataBit0    <= DataReg(31);
                DataShiftReg(31 downto 1) <= DataReg(30 downto 0);
                IntTxFRd    <= not(IntTxFRd);
              else
                DataBit0    <= DataShiftReg(31);
                DataShiftReg(31 downto 1) <= DataShiftReg(30 downto 0);
                DataShiftReg(0)  <= '0';
              end if;
              DataCnt  <= unsigned(DataCnt) - 1;
              WrdCnt   <= unsigned(WrdCnt) + 1;
              BitCnt   <= unsigned(BitCnt) + 1;
            else
              DataBit0  <= DataShiftReg(31);
              DataShiftReg(31 downto 1) <= DataShiftReg(30 downto 0);
              DataShiftReg(0)  <= '0';
              BitCnt <= unsigned(BitCnt) + 1;
            end if;
          end if;
        else
          -- Block Mode Transfer
          if (DataCnt = "0000000000000000" and
              BlkCnt = "000000000000" and BitCnt = "111") then
            DtTimeCntOver  <= '0';
            DataBit0  <= '1';
            WrdCnt    <= "00";
            DataCnt   <= IntDataLength;
            BlkCnt    <= (unsigned(IntBlkCnt) + 2);
          else
            if (BlkCnt = (unsigned(IntBlkCnt) + 2) and
                BitCnt = "111") then
              if (iBlkEnd = '0') then
                if (StBitSent = '0') then
                  iCRC16En  <= '1';
                  DataBit0  <= '0';
                  DataShiftReg(31 downto 1) <= DataReg(30 downto 0);
                  StBitSent <= '1';
                  WrdCnt    <= "00";
                else
                  DataBit0  <= DataReg(31);
                  IntTxFRd  <= not(IntTxFRd);
                  BlkCnt    <= unsigned(BlkCnt) - 1;
                  BitCnt    <= unsigned(BitCnt) + 1;
                  StBitSent <= '0';
                end if;
              else
                DataBit0       <= 'Z';
                iBlkEnd        <= '0';
                DtTimeCntOver  <= '0';
              end if;
            elsif (BlkCnt = "000000000000" and BitCnt = "111") then
              DataBit0  <= '1';
              BlkCnt    <= (unsigned(IntBlkCnt) + 2);
              iBlkEnd   <= '1';
              WrdCnt    <= "00";
            else
              if (BlkCnt = "000000000010" and BitCnt = "111") then
                BitCnt <= unsigned(BitCnt) + 1;
                BlkCnt <= unsigned(BlkCnt) - 1;
                DataBit0 <= DCrcBufferBit(0);
              elsif (BlkCnt = "000000000001" and BitCnt = "000") then
                iCRC16En   <= '0';
                WrdCnt     <= "00";
                BitCnt     <= unsigned(BitCnt) + 1;
                if (DataCrcErr = '1') then
                  DataShiftReg(31 downto 17) <= "111000011110000";
                  DataBit0 <= '1';
                else
                  DataShiftReg(31 downto 18) <= CRC160(13 downto 0);
                  DataBit0 <= CRC160(14);
                end if;
              else
                if (BitCnt = "111") then
                  if (WrdCnt = "11") then
                    DataBit0 <= DataReg(31);
                    DataShiftReg(31 downto 1) <= DataReg(30 downto 0);
                    IntTxFRd <= not(IntTxFRd);
                  else
                    DataBit0 <= DataShiftReg(31);
                    DataShiftReg(31 downto 1)
                             <= DataShiftReg(30 downto 0);
                    DataShiftReg(0) <= '0';
                  end if;
                  BitCnt     <= unsigned(BitCnt) + 1;
                  WrdCnt     <= unsigned(WrdCnt) + 1;
                  BlkCnt     <= unsigned(BlkCnt) - 1;
                  DataCnt    <= unsigned(DataCnt) - 1;
                else
                  DataBit0   <= DataShiftReg(31);
                  DataShiftReg(31 downto 1)
                             <= DataShiftReg(30 downto 0);
                  DataShiftReg(0) <= '0';
                  BitCnt     <= unsigned(BitCnt) + 1;
                end if;
              end if;
            end if;
          end if;
        end if;
      else
        DataBit0 <= 'Z';
      end if;
     end if;
    end if;
  end if;
end process p_TxDatalogic;
end behavioural;

-- --================================== End ==================================--
