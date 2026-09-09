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
-- File Name              : MmciTrStoP.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           MMCI Trickbox Serial to parallel convertor and receiver
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrStoP is
  port (
-- Inputs
        MMCICLK          : in    std_logic; -- MMCI Bus Clock
        nMMCIRST         : in    std_logic; -- APB Bus Reset
        DataLength       : in    std_logic_vector(15 downto 0);
                                            -- Number of data bytes to
                                            -- be rxd
        Blocklen         : in    std_logic_vector(3 downto 0);
                                            -- Num of bytes in a block
        RxCommand        : in    std_logic; -- Qualifies cmd reception
        SendResponse     : in    std_logic; -- Qualifies resp
                                            -- transmission
        CmdEnable        : in    std_logic; -- Cmd Path Enable
        DataEn           : in    std_logic; -- Data Path Enable
        DataDirection    : in    std_logic; -- Direction of data
        DataMode         : in    std_logic; -- Mode of Data-Block,
                                            -- Stream
        TokenSent        : in    std_logic; -- Qualifies token bits
        MDCStg2WrEn      : in    std_logic; -- Indictes any write to
                                            -- DataCtrl register.
        CRC7             : in    std_logic_vector(6 downto 0);
                                            -- Computed CRC7 value
        CRC160           : in    std_logic_vector(15 downto 0);
                                            -- Computed CRC16 value
        MMCICMDIn        : in    std_logic; -- MMCI Command Path
        MMCIDATIn        : in    std_logic; -- MMCI Data Path
-- Outputs
        MMCITBRxdCIndS2  : out   std_logic_vector(5 downto 0);
                                            -- Command Index received
        MMCITBRxdCArgS2  : out   std_logic_vector(31 downto 0);
                                            -- Command argument recd
        MTBCIUpdate      : out   std_logic; -- Updt signal for Cmd Ind
        MTBCAUpdate      : out   std_logic; -- Updt signal for Cmd Arg
        DataCnt          : out   std_logic_vector(15 downto 0);
                                            -- Indicates num of bytes
                                            -- of data remaining
        BitCnt           : out   std_logic_vector(2 downto 0);
                                            -- Counts each bit of
                                            -- data rxd
        RxFWr            : out   std_logic; -- WrEnable for Rx FIFO
        CmdCrcErrStat    : out   std_logic; -- Error Status of Cmd CRC
        CTxBitCheckErr   : out   std_logic; -- Indicates any Tx
                                            -- Bit Error
        RCRC7En          : out   std_logic; -- Enable for CRC7
        RCRC16En         : out   std_logic; -- Enable for CRC16
        DataRxd          : out   std_logic; -- Qualifies that data
                                            -- reception is over
        RxFWrData        : out   std_logic_vector(32 downto 0)
                                            -- Rx Fifo write data
       );
end MmciTrStoP;

-- -----------------------------------------------------------------------------
--
--                                 MmciTrStoP
--                                 ==========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--  MmciTrStoP is the serial to parallel convertor block.It starts to
-- receive command and data bits, once the startbit is received and then
-- shifts these bits till the end bit is received or a word boundary is
-- reached (in case of data) . It then moves the shift register contents
-- to respective registers.
-- -----------------------------------------------------------------------------
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of MmciTrStoP is

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
-- Command Bit received

signal DelCmdBit        : std_logic;
-- Delayed version of Command Bit received

signal CmdSBit          : std_logic;
-- Qualifies start bit of Command path

signal DataBit0         : std_logic;
-- Data Bit received on line 0

signal DelDataBit0      : std_logic;
-- Delayed version of Data Bit received on line 0

signal DataSBit0        : std_logic;
-- Qualifies start bit of data on line 0

signal CTxBitCheck      : std_logic;
-- Qualifies the reception of Transmit bit in command field

signal CStartStoP       : std_logic;
-- Qualifies the reception of Command Bits

signal DelCStartStoP    : std_logic;
-- Delayed version of CStartStoP

signal DelCmdSBit       : std_logic;
-- Delayed version of CmdSbit

signal DelCTxBitCheck   : std_logic;
-- Delayed version of CTxBitCheck

signal DStartStoP0      : std_logic;
-- Qualifies the reception of Data Bits on line 0

signal DelDStartStoP0   : std_logic;
-- Delayed version of DStartStoP0

signal DelDataSBit0     : std_logic;
-- Delayed version of DataSBit0

signal CmdStoreReg      : std_logic_vector(45 downto 0);
-- Register to store the recd command

signal NextMTBRxdCIndS2 : std_logic_vector(5 downto 0);
-- D-Input to MMCITBRxdCIndS2 register

signal iMMCITBRxdCIndS2 : std_logic_vector(5 downto 0);
-- local copy of MMCITBRxdCIndS2 register

signal NextMTBRxdCArgS2 : std_logic_vector(31 downto 0);
-- D-Input to MMCITBRxdCArgS2 register

signal iMMCITBRxdCArgS2 : std_logic_vector(31 downto 0);
-- local copy of MMCITBRxdCArgS2 register

signal iMTBCIUpdate     : std_logic;
-- Update signal for Command Index register

signal NextMTBCIUpdate  : std_logic;
-- D-Input to iMTBCIUpdate

signal iMTBCAUpdate     : std_logic;
-- Update signal for Command Argument register

signal NextMTBCAUpdate  : std_logic;
-- D-Input to iMTBCAUpdate

signal DataReg          : std_logic_vector(31 downto 0);
-- Register to store the recd and shifted data bits

signal ShiftDataReg     : std_logic_vector(31 downto 0);
-- Register to shift the incoming data bits

signal RxCRCBit         : std_logic;
-- Qualifies the reception of CRC bits

signal DataCrcFail      : std_logic;
-- Gives Crc error status of the recd data

signal DelDataRxd       : std_logic;
-- Delayed version of iDataRxd

signal iDataRxd         : std_logic;
-- Qualifies the reception of data bits

signal RCRC160          : std_logic;
-- Internal enable signal for CRC16 Calculation on line 0

signal ZEROFILL         : std_logic_vector(31 downto 0);
-- Register filled with zeros

signal IntRxFWr         : std_logic;
-- Internal write enable for Rx FIFO

signal CmdEBit          : std_logic;
-- Qualifies end bit on commmand line

signal DataEBit0        : std_logic;
-- Qualifies end bit on data line 0

signal IntDataLength    : std_logic_vector(15 downto 0);
-- Number of bytes of data to be recd

signal IntBlocklen      : std_logic_vector(3 downto 0)  := "0000";
-- Number of bytes of data in a block, as powers of 2

signal IntBlkCnt        : std_logic_vector(11 downto 0) :=
                                                     "000000000000";
-- Number of bytes of data in a block, for internal purpose

signal iDataCnt         : std_logic_vector(15 downto 0) :=
                                                     "0000000000000000";
-- Number of bytes of data remaining in the transfer

signal BlkCnt           : std_logic_vector(11 downto 0) :=
                                                     "000000000000";
-- Number of bytes of data in a block

signal WrdCnt           : std_logic_vector(1 downto 0)  := "00";
-- Counts every byte of data recd

signal iBitCnt          : std_logic_vector(2 downto 0)  := "111";
-- Counts every bit of data recd

signal LoadCounters     : std_logic;
-- Enables loading of DataCnt and BlkCnt

signal LoadOver         : std_logic;
-- Indicates that loading of counters is over

signal BytePos          : std_logic_vector(1 downto 0);
-- Used to write data correctly into the Rx FIFO when Blocklen or
-- DataLength < 4

signal NextBytePos      : std_logic_vector(1 downto 0);
-- D-Input to BytePos

signal DataEnd          : std_logic;
-- Indicates end of data in stream mode data transfer

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
--  Filling ZEROFILL register with zeros
-- -----------------------------------------------------------------------------
ZEROFILL <= (others => '0');

-- -----------------------------------------------------------------------------
--  Driving CmdBit with the MMCICMDIn
-- -----------------------------------------------------------------------------
CmdBit   <= MMCICMDIn when (CmdEnable = '1' and RxCommand = '1')
         else
            'Z';

-- -----------------------------------------------------------------------------
--  Driving outputs with local copies
-- ----------------------------------------------------------------------------
MMCITBRxdCIndS2  <= iMMCITBRxdCIndS2;
MMCITBRxdCArgS2  <= iMMCITBRxdCArgS2;
DataCnt          <= iDataCnt;
BitCnt           <= iBitCnt;
MTBCIUpdate      <= iMTBCIUpdate;
MTBCAUpdate      <= iMTBCAUpdate;

-- -----------------------------------------------------------------------------
--  Delayed version of CmdBit
-- -----------------------------------------------------------------------------
p_DelayCmdBit : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelCmdBit  <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (CmdEnable = '1') then
      DelCmdBit <= CmdBit;
    else
      DelCmdBit <= '0';
    end if;
  end if;
end process p_DelayCmdBit;

-- -----------------------------------------------------------------------------
--  Process detects the Command path start and end bit
-- -----------------------------------------------------------------------------
p_StartnEndBit : process (CmdBit, DelCmdBit, RxCommand, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    CmdSBit  <= '0';
    CmdEBit  <= '0';
    RCRC7En  <= '0';
  elsif (DelCmdBit = 'Z' and CmdBit = '0' and RxCommand = '1') then
    CmdSBit  <= '1';
    RCRC7En  <= '1';
  elsif (DelCmdBit = '1' and CmdBit = 'Z' and RxCommand = '1'
                                          and CmdEnable = '1') then
    RCRC7En  <= '0';
    CmdEBit  <= '1';
  else
    CmdSBit  <= '0';
    CmdEBit  <= '0';
  end if;
end process p_StartnEndBit;

-- -----------------------------------------------------------------------------
--  Process checks whether a proper Tx bit has been transmitted by MMCI
-- -----------------------------------------------------------------------------
p_CTxBitCheck  : process (CmdSBit, CmdBit, DelCmdSBit)
begin
  if (DelCmdSBit = '1' and CmdSBit = '0') then
    if (CmdBit = '1') then
      CTxBitCheck    <= '1';
    else
      CTxBitCheckErr <= '1';
    end if;
  else
    CTxBitCheck      <= '0';
    CTxBitCheckErr   <= '0';
  end if;
end process p_CTxBitCheck;

-- -----------------------------------------------------------------------------
--  CStartStoP generated by this process qualifies the reception of
-- command bits
-- -----------------------------------------------------------------------------
p_CStartStoP  : process (CTxBitCheck, CmdBit, DelCmdBit, DelCStartStoP,
                         DelCTxBitCheck)
begin
  if (DelCTxBitCheck = '1' and CTxBitCheck = '0') then
    CStartStoP <= '1';
  elsif (CmdBit = 'Z' and DelCmdBit = '1') then
    CStartStoP <= '0';
  else
    CStartStoP <= DelCStartStoP;
  end if;
end process p_CStartStoP;

-- -----------------------------------------------------------------------------
--  Delayed version of CStartStoP
-- -----------------------------------------------------------------------------
p_DelayCStartStoP : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelCStartStoP  <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (CmdEnable = '1') then
      DelCStartStoP <= CStartStoP;
    else
      DelCStartStoP <= '0';
    end if;
  end if;
end process p_DelayCStartStoP;

-- -----------------------------------------------------------------------------
--  Delayed version of CmdSBit
-- -----------------------------------------------------------------------------
p_DelayCmdSBit : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelCmdSBit <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelCmdSBit <= CmdSBit;
  end if;
end process p_DelayCmdSBit;

-- -----------------------------------------------------------------------------
--  Delayed version of CTxBitCheck
-- -----------------------------------------------------------------------------
p_DelayCTxBitCheck : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelCTxBitCheck <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelCTxBitCheck <= CTxBitCheck;
  end if;
end process p_DelayCTxBitCheck;

-- -----------------------------------------------------------------------------
--  Shifting in of the recd command bit
-- -----------------------------------------------------------------------------
p_CmdStoreComb : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    CmdStoreReg <= (others => '0');
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (CStartStoP = '1') then
      CmdStoreReg(45 downto 1) <= CmdStoreReg(44 downto 0);
      CmdStoreReg(0)           <= CmdBit;
    end if;
  end if;
end process p_CmdStoreComb;

-- -----------------------------------------------------------------------------
--  Transfering the respective command fields to their registers
-- -----------------------------------------------------------------------------
p_CmdStoreTransfer : process (CmdEBit, nMMCIRST, CmdStoreReg,
                              iMTBCIUpdate, iMTBCAUpdate,
                              iMMCITBRxdCIndS2, iMMCITBRxdCArgS2)
begin
  if (nMMCIRST = '0') then
    NextMTBRxdCIndS2 <= (others => '0');
    NextMTBRxdCArgS2 <= (others => '0');
    NextMTBCIUpdate  <= '0';
    NextMTBCAUpdate  <= '0';
  elsif (CmdEBit = '1') then
    NextMTBRxdCIndS2 <= CmdStoreReg(45 downto 40);
    NextMTBRxdCArgS2 <= CmdStoreReg(39 downto 8);
    NextMTBCIUpdate  <= not(iMTBCIUpdate);
    NextMTBCAUpdate  <= not(iMTBCAUpdate);
  else
    NextMTBRxdCIndS2 <= iMMCITBRxdCIndS2;
    NextMTBRxdCArgS2 <= iMMCITBRxdCArgS2;
    NextMTBCIUpdate  <= iMTBCIUpdate;
    NextMTBCAUpdate  <= iMTBCAUpdate;
  end if;
end process p_CmdStoreTransfer;

-- -----------------------------------------------------------------------------
--  Clocking the command fields into registers
-- -----------------------------------------------------------------------------
p_CmdRegWr : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    iMMCITBRxdCIndS2 <= (others => '0');
    iMMCITBRxdCArgS2 <= (others => '0');
    iMTBCIUpdate     <= '0';
    iMTBCAUpdate     <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    iMMCITBRxdCIndS2 <= NextMTBRxdCIndS2;
    iMMCITBRxdCArgS2 <= NextMTBRxdCArgS2;
    iMTBCIUpdate     <= NextMTBCIUpdate;
    iMTBCAUpdate     <= NextMTBCAUpdate;
  end if;
end process p_CmdRegWr;

-- -----------------------------------------------------------------------------
--          Data Path related Serial to Parallel conversion.
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Making internal versions
-- -----------------------------------------------------------------------------

IntDataLength <= DataLength;
IntBlocklen   <= Blocklen;
DataRxd       <= iDataRxd;

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
-- Tapping the MMCIDATIn bus
-- -----------------------------------------------------------------------------

DataBit0 <= MMCIDATIn when (DataDirection = '0' and DataEn = '1')
         else
            'Z';

-- -----------------------------------------------------------------------------
-- Delayed version of DataBit
-- -----------------------------------------------------------------------------
p_DelayDataBit : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelDataBit0 <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (DataEn = '1') then
      DelDataBit0 <= DataBit0;
    else
      DelDataBit0 <= '0';
    end if;
  end if;
end process p_DelayDataBit;

-- -----------------------------------------------------------------------------
-- Process detects the Data path start and end bit and also enables the
-- CRC16 calculation for line 0
-- -----------------------------------------------------------------------------
p_DStartnEndBit0 : process (DataBit0, DelDataBit0, nMMCIRST, MDCStg2WrEn)
begin
  if (nMMCIRST = '0' or MDCStg2WrEn = '1') then
    RCRC160 <= '0';
  elsif (DelDataBit0 = 'Z' and DataBit0 = '0') then
    DataSBit0 <= '1';
    if (DataMode = '0') then
      RCRC160 <= '1';
    end if;
  elsif (DelDataBit0 = '1' and DataBit0 = 'Z') then
    DataEBit0 <= '1';
    if (DataMode = '0') then
      RCRC160 <= '0';
    end if;
  else
    DataSBit0 <= '0';
    DataEBit0 <= '0';
  end if;
end process p_DStartnEndBit0;


-- -----------------------------------------------------------------------------
--  Generating the CRC enable
-- -----------------------------------------------------------------------------
p_Crc16En : process (RCRC160, DataMode)
begin
  if (DataMode = '0') then
      RCRC16En <= RCRC160;
  end if;
end process p_Crc16En;

-- -----------------------------------------------------------------------------
--  DStartStoP0 generated by this process qualifies the reception of
-- data bits
-- -----------------------------------------------------------------------------
p_DStartStoP0 : process (DataSbit0, DataBit0, DelDataBit0,
                         DelDStartStoP0)
begin
  if (DelDataSBit0 = '1' and DataSBit0 = '0') then
    DStartStoP0 <= '1';
  elsif (DelDataBit0 = '1' and DataBit0 = 'Z') then
    DStartStoP0 <= '0';
  else
    DStartStoP0 <= DelDStartStoP0;
  end if;
end process p_DStartStoP0;

-- -----------------------------------------------------------------------------
--  Delayed version of DStartStoP0
-- -----------------------------------------------------------------------------
p_DelDStartStoP0 : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelDStartStoP0 <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (DataEn = '1') then
      DelDStartStoP0 <= DStartStoP0;
    else
      DelDStartStoP0 <= '0';
    end if;
  end if;
end process p_DelDStartStoP0;

-- -----------------------------------------------------------------------------
--  Delayed version of DataSBit0
-- -----------------------------------------------------------------------------
p_DelDataSBit0 : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelDataSBit0 <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelDataSBit0 <= DataSBit0;
  end if;
end process p_DelDataSBit0;

-- -----------------------------------------------------------------------------
-- Process to check if correct CRC is recd
-- -----------------------------------------------------------------------------
p_CheckCRC : process (CRC7, CRC160, CmdEBit, DataEBit0, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    CmdCrcErrStat <= '0';
    DataCrcFail   <= '0';
  else
    if (CmdEBit = '1') then
      if (CRC7 = "0001001") then
        CmdCrcErrStat <= '0';
      else
        CmdCrcErrStat <= '1';
      end if;
    end if;

    if (DataEBit0 = '1') then
      if (CRC160 = "0000000000000000") then
        DataCrcFail <= '0';
      else
        DataCrcFail <= '1';
      end if;
    end if;
  end if;
end process p_CheckCRC;

-- -----------------------------------------------------------------------------
-- Process to generate LoadCounters which will enable loading of
-- DataCnt and BlkCnt counters
-- -----------------------------------------------------------------------------
p_LoadCounters : process (MDCStg2WrEn, DataLength, LoadOver,
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
-- The Command path and Data path FSM's in MMCI handle only a byte wide
-- data at a time.So while receiving data the MSB of the first byte
-- is rxd first followed by MSB of 2nd byte and so on.So, in order
-- to satisfy this the data rxd from the MMCI has to be properly
-- positioned while writing into the Rx FIFO.
-- -----------------------------------------------------------------------------
RxFWrData(7 downto 0)   <= DataReg(7 downto 0) when BytePos = "01"
                        else
                           DataReg(15 downto 8) when BytePos = "10"
                        else
                           DataReg(23 downto 16) when BytePos = "11"
                        else
                           DataReg(31 downto 24) when BytePos = "00"
                        else
                           (others => '0');

RxFWrData(15 downto 8)  <= DataReg(7 downto 0) when BytePos = "10"
                        else
                           DataReg(15 downto 8) when BytePos = "11"
                        else
                           DataReg(23 downto 16) when BytePos = "00"
                        else
                           (others => '0');

RxFWrData(23 downto 16) <= DataReg(7 downto 0) when BytePos = "11"
                        else
                           DataReg(15 downto 8) when BytePos = "00"
                        else
                           (others => '0');

RxFWrData(31 downto 24) <= DataReg(7 downto 0) when BytePos = "00"
                        else
                           (others => '0');

-- -----------------------------------------------------------------------------
-- Positioning the data written into the Rx FIFO in cases where
-- Datalength or Blocklen is less than 4, is done using the BytePos
-- signal generated in this process.
-- -----------------------------------------------------------------------------
p_ByteAlign : process (IntDataLength, IntBlkCnt, DataMode, nMMCIRST,
                       iDataCnt, IntRxFWr)
variable status : std_logic := '0';
begin
  if (nMMCIRST = '0' ) then
    NextBytePos <= "00";
  elsif (DataMode = '0') then
    if (IntBlkCnt = "000000000010") then
      NextBytePos <= "10";
    elsif (IntBlkCnt = "000000000001") then
      NextBytePos <= "01";
    else
      NextBytePos <= "00";
    end if;
  elsif (DataMode = '1') then
    if (IntDataLength = "0000000000000011") then
      NextBytePos <= "11";
    elsif (IntDataLength = "0000000000000010") then
      NextBytePos <= "10";
    elsif (IntDataLength = "0000000000000001") then
      NextBytePos <= "01";
    else
      if (IntDataLength > "0000000000000100" and
          iDataCnt < "0000000000000100" and IntRxFWr'event) then
        NextBytePos <= unsigned(iDataCnt(1 downto 0)) + 1;
        status := '1';
      elsif (status = '0' or (status = '1' and IntRxFWr'event)) then
        NextBytePos <= "00";
        status := '0';
      end if;
    end if;
  end if;
end process p_ByteAlign;

-- -----------------------------------------------------------------------------
-- Sequential Process for BytePos
-- -----------------------------------------------------------------------------
BytePosSeq : process (MDCStg2WrEn, MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0' or MDCStg2WrEn = '1') then
    BytePos <= "00";
  elsif (DataMode = '1' and IntDataLength > "0000000000000100") then
    if (iDataCnt = "0000000000000000" and iBitCnt = "110") then
      BytePos <= NextBytePos;
    end if;
  elsif (MMCICLK'event and MMCICLK = '1') then
    BytePos <= NextBytePos;
  end if;
end process BytePosSeq;

-- -----------------------------------------------------------------------------
-- Driving Rx FIFO related signals
-- -----------------------------------------------------------------------------
RxFWrData(32) <= DataCrcFail;
RxFWr         <= IntRxFWr;


-- -----------------------------------------------------------------------------
-- Data Receive logic
-- If the data to be received is in stream mode then with each bit
-- of data rxd data received the WrdCnt is incremented, the dataCnt is
-- decremented.Once a word of data is received, the contents of the
-- Shift register is transfered to the Rx FIFO and the FIFO write enable
-- RxFWr is also toggled.The process ceases action once all the bytes of
-- data have been received, this is ensured by the DStartStoP0
-- qualifying signal going low.
-- If the Data to be received is in Block mode then with each bit of
-- data rxd the bit is shifted in, the BitCnt is incremented by 1.
-- With every byte of data received the WrdCnt is incremented, the
-- dataCnt is decremented and the block count is also decremented.
-- The block length that is taken into consideration excludes the crc
-- bits.Once a word of data is received, the, contents of the Shift
-- register is transfered to the Rx FIFO and the FIFO write enable,
-- RxFWr is also toggled.The process, for block lengths lesserthan a
-- word or otherwise, transfers the contents of the shift register to
-- the FIFO when Block count runs to zero or the Data count runs to 0.
-- At the time when Block count is zero or Data count is zero, the
-- latter having higher priority, the RxCrcBit is set, which qualifies
-- the received bit as CRC bit and the WrdCnt is set to "10" and the
-- process keeps all the counters active till the CRC Bits are
-- received, ie WrdCnt = "11" and BitCnt = "111".Once this is over the
-- RxCrcBit signal is made low.The DStartStoP signal remains high
-- throughout the process activity.The CrcError status is updated each
-- time the CRC16 input to this module changes and at every endbit of
-- data received this crc error status is written as the 33rd bit into
-- the Rx FIFO.
-- In case of Block mode and Wide Bus case a BitCnt of "001" indicates
-- that a byte has been received.But in case of crc bits 16 crc bits
-- have to be received independently on each line and hence we need
-- to set WrdCnt = "10" and wait for the condition WrdCnt = "11" and
-- BitCnt = "111", to receive all the crc bits.The shifting in of data
-- is done four places per clock.
-- -----------------------------------------------------------------------------
p_RxDatlogic : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0' or DataEn = '0' or DataDirection = '1') then
    LoadOver     <= '0';
    IntRxFWr     <= '0';
    DataReg      <= (others => '0');
    ShiftDataReg <= (others => '0');
    iDataCnt     <= (others => '0');
    BlkCnt       <= (others => '0');
    iBitCnt      <= "000";
    WrdCnt       <= "00";
    RxCRCBit     <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (DataDirection = '0' and DataEn = '1') then
      if (LoadCounters = '1' and DataBit0 = 'Z' and LoadOver = '0') then
        iDataCnt <= unsigned(IntDataLength) - 1;
        BlkCnt   <= unsigned(IntBlkCnt) - 1;
        WrdCnt   <= "00";
        iBitCnt  <= "000";
        LoadOver <= '1';
      else
        LoadOver <= '0';
      end if;

      if (DataBit0 = 'Z') then
        DataEnd  <= '0';
        RxCRCBit <= '0';
        WrdCnt   <= "00";
      end if;

      if (DataMode = '1' and DStartStoP0 = '1') then
      -- Stream Mode Data Transfer
        if (iDataCnt = "0000000000000000" and iBitCnt = "111") then
          DataReg(31 downto 1) <= ShiftDataReg(30 downto 0);
          DataReg(0)   <= DataBit0;
          WrdCnt   <= "00";
          iBitCnt  <= "000";
          IntRxFWr <= not(IntRxFWr);
          ShiftDataReg <= (others => '0');
          DataEnd  <= '1';
          iDataCnt <= unsigned(IntDataLength) - 1;
        elsif (DataEnd = '0') then
          if (iBitCnt = "111") then
            if (WrdCnt = "11") then
              DataReg(31 downto 1) <= ShiftDataReg(30 downto 0);
              ShiftDataReg <= (others => '0');
              DataReg(0)   <= DataBit0;
              IntRxFWr     <= not(IntRxFWr);
            else
              ShiftDataReg(0) <= DataBit0;
              ShiftDataReg(31 downto 1) <= ShiftDataReg(30 downto 0);
            end if;
            iBitCnt  <= unsigned(iBitCnt) + 1;
            WrdCnt   <= unsigned(WrdCnt) + 1;
            iDataCnt <= unsigned(iDataCnt) - 1;
          else
            ShiftDataReg(0) <= DataBit0;
            ShiftDataReg(31 downto 1) <= ShiftDataReg(30 downto 0);
            iBitCnt         <= unsigned(iBitCnt) + 1;
          end if;
        end if;
      else
      -- Block Mode Data Transfer
        if (DStartStoP0 = '1' and DataMode = '0') then
          if (iDataCnt = "0000000000000000" and iBitCnt = "111" and
             RxCRCBit = '0') then
            RxCRCBit <= '1';
            WrdCnt   <= "10";
            iBitCnt  <= "000";
            DataReg(31 downto 1) <= ShiftDataReg(30 downto 0);
            DataReg(0)   <= DataBit0;
            ShiftDataReg <= (others => '0');
            IntRxFWr     <= not(IntRxFWr);
            iDataCnt     <= unsigned(IntDataLength) - 1;
          else
            if (BlkCnt = "000000000000" and iBitCnt = "111" and
               RxCRCBit = '0') then
              RxCRCBit <= '1';
              DataReg(31 downto 1) <= ShiftDataReg(30 downto 0);
              DataReg(0)   <= DataBit0;
              ShiftDataReg <= (others => '0');
              IntRxFWr     <= not(IntRxFWr);
              WrdCnt       <= "10";
              iBitCnt      <= "000";
              BlkCnt       <= unsigned(IntBlkCnt) - 1;
              iDataCnt     <= unsigned(iDataCnt) - 1;
            else
              if (iBitCnt = "111") then
                if (WrdCnt = "11") then
                  if (RxCRCBit = '0') then
                    DataReg(31 downto 1) <= ShiftDataReg(30 downto 0);
                    DataReg(0)   <= DataBit0;
                    IntRxFWr     <= not(IntRxFWr);
                    ShiftDataReg <= (others => '0');
                  else
                    RxCRCBit <= '0';
                  end if;
                else
                  if (RxCRCBit = '0') then
                    ShiftDataReg(0) <= DataBit0;
                    ShiftDataReg(31 downto 1)
                                    <= ShiftDataReg(30 downto 0);
                  end if;
                end if;
                  iBitCnt <= unsigned(iBitCnt) + 1;
                  WrdCnt  <= unsigned(WrdCnt) + 1;
                  if (RxCRCBit = '0') then
                    BlkCnt   <= unsigned(BlkCnt) - 1;
                    iDataCnt <= unsigned(iDataCnt) - 1;
                  end if;
              else
                if (RxCRCBit = '0') then
                  ShiftDataReg(0) <= DataBit0;
                  ShiftDataReg(31 downto 1)
                                  <= ShiftDataReg(30 downto 0);
                end if;
                if (DStartStoP0 = '1' and DelDStartStoP0 = '0') then
                    iBitCnt <= "001";
                else
                  iBitCnt <= unsigned(iBitCnt) + 1;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_RxDatlogic;

-- -----------------------------------------------------------------------------
-- Generation of DataRxd, which qualifies the time after which data
-- has been received
-- -----------------------------------------------------------------------------
p_iDataRxd : process (MMCICLK, nMMCIRST, MDCStg2WrEn)
begin
  if (nMMCIRST = '0' or MDCStg2WrEn = '1') then
    iDataRxd <= '0';
  elsif (DataEn = '1' and DataDirection = '0' and TokenSent = '1' and
         DataMode = '0') then
    if (DataBit0 = '0' and DelDataBit0 = 'Z') then
      iDataRxd <= '0';
    elsif (DataBit0 = 'Z' and DelDataBit0 = '1') then
      iDataRxd <= '1';
    else
      iDataRxd <= DelDataRxd;
    end if;
  end if;
end process p_iDataRxd;

-- -----------------------------------------------------------------------------
-- Delayed version of DataRxd
-- -----------------------------------------------------------------------------
p_DelDataRxd : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelDataRxd <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelDataRxd <= iDataRxd;
  end if;
end process p_DelDataRxd;
end behavioural;

-- --================================== End ==================================--
