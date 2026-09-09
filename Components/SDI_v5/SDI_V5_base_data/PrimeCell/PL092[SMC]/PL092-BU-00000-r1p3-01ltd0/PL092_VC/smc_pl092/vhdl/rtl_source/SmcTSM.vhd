-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SmcTSM.vhd.rca
-- File Revision          : 1.22
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           TSM is used to control the read and write transactions from the
--           SmcCore to the external memory device.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SmcPackage.all;

-- -----------------------------------------------------------------------------
entity SmcTSM is
  port (
-- Inputs
        HCLK             : in    std_logic; -- Bus Clock
        HRESETn          : in    std_logic; -- Module Reset
        HTransRegCo      : in    std_logic_vector(1 downto 0);
                                            -- Registered HTRANS signal from
                                            -- AHB interface block
        BM               : in    std_logic; -- Burst ROM device indication
        MemWrReq         : in    std_logic; -- New write initiation signal
        MemRdReq         : in    std_logic; -- New read initiation signal
        WtdWrReq         : in    std_logic; -- Write request which comes while
                                            -- current write request is being
                                            -- processed
        WtdRdReq         : in    std_logic; -- Read request which comes while
                                            -- current read request is being
                                            -- processed
        SMBUSGNT         : in    std_logic; -- Bus Grant signal from DBI
        CntEnd           : in    std_logic; -- Indicates completion of the
                                            -- access time or turnaround time
        DelayEnd         : in    std_logic; -- Indicates completion of the
                                            -- enable delay {for WEN & OEN}
        WaitEn           : in    std_logic; -- Enable for external wait mode
        BankCmpCo        : in    std_logic; -- Signal which checks if the
                                            -- successive transfers are to
                                            -- the same bank
        WaitToutErr      : in    std_logic; -- SMWAIT Timeout Error
        BMlenEnd         : in    std_logic; -- Burst length termination signal
                                            -- during burst reads
        BufWrOver        : in    std_logic; -- Buffer storage completion signal
                                            -- during write transfers and
                                            -- indicates that the buffer is full
        MemWrOver        : in    std_logic; -- Write completion signal to
                                            -- indicate that all data packets
                                            -- have been flushed to the device
        MemRdOver        : in    std_logic; -- This signal indicates that the
                                            -- all data packets are read from
                                            -- the memory device at the end of
                                            -- read access time
        MemRdOverCo      : in    std_logic; -- Combinational version of the
                                            -- MemRdOver
        BufByPassCo      : in    std_logic; -- This signal is used to indicate
                                            -- that the HSIZE = MSIZE and the
                                            -- RdWrBuf can be bypassed during
                                            -- transfers
        HBurstRegCo      : in    std_logic_vector(2 downto 0);
                                            -- Registered HBURST signal from
                                            -- AHB interface block
        AhbRdEn          : in    std_logic; -- Enabling signal to route data to
                                            -- HRDATA bus on read completion
        AhbRdOver        : in    std_logic; -- Signal to indicate the completion
                                            -- of read by AHB
        HSizeRegCo       : in    std_logic_vector(1 downto 0);
                                            -- Registered AHB Transfer Size
        MW               : in    std_logic_vector(1 downto 0);
                                            -- The memory width bits selection
                                            -- from one of the bank registers
        MWCfgDone        : in    std_logic; -- Register bit indicating the
                                            -- completion of the MW bits
                                            -- programming after reset
        CntEZEnd         : in    std_logic; -- Timer counter expiry signal when
                                            -- count values are zero
        OEnCntEZ         : in    std_logic; -- Signal to indicate that the
                                            -- OEnCount delay value is equal
                                            -- to zero
        WEnCntEZ         : in    std_logic; -- Signal to indicate that the
                                            -- WrEnCount delay value is equal
                                            -- to zero
        RBLE             : in    std_logic; -- Byte lane enabled device
        BnkAddStrCo      : in    std_logic_vector(2 downto 0);
                                            -- Stored value of the current 
                                            -- Bank Address
-- Outputs
        SmcState         : out   std_logic_vector(3 downto 0);
                                            -- The state machine's current
                                            -- state value
        SMBUSREQ         : out   std_logic; -- Bus Request signal to EBI
        RdCntLdCo        : out   std_logic; -- Load Count value in Timer
                                            -- counter for normal Read
                                            -- Access
        RdBMcntLdCo      : out   std_logic; -- Load Count value in Timer
                                            -- counter for burst Read
                                            -- access
        WrCntLdCo        : out   std_logic; -- Load Count value in Timer
                                            -- counter for Write Access
        TrArCntLdCo      : out   std_logic; -- Load Count value in Timer
                                            -- counter for Turn around cycle
        ZeroIdleCo       : out   std_logic; -- Used to get a 1 cycle turn-
                                            -- around when a RD transfer
                                            -- is initiated after a WR
        OEnCntLdCo       : out   std_logic; -- Load output enable delay
        WEnCntLdCo       : out   std_logic; -- Load Write enable delay
        ExtWrEnCo        : out   std_logic; -- enable signal for generation
                                            -- of write enable and bytelane
                                            -- select
        ExtWrDisCo       : out   std_logic; -- Disabling signal for the
                                            -- write enable and bytelane
                                            -- selects
        XoutEnCo         : out   std_logic; -- Enable signal for the SMOEN
        XoutDisCo        : out   std_logic; -- Disable signal for the SMOEN
        XdatDisCo        : out   std_logic; -- Signal to de-assert the SMDATAEN
                                            -- output lines
        RdXdatEnCo       : out   std_logic; -- Signal to assert the proper
                                            -- byte lanes of external data bus
                                            -- depending on memory width
                                            -- during reads
        WrXdatEnCo       : out   std_logic; -- Signal to assert all the byte
                                            -- lanes of external data bus during
                                            -- a write transfer and during
                                            -- Idle cycles
        AddrIncCo        : out   std_logic; -- Signal for incrementing the
                                            -- memory address SMADDR
        BrstAddIncCo     : out   std_logic; -- Signal for incrementing the
                                            -- SMADDR in advance during burst
                                            -- reads
        BMRdTrans        : out   std_logic; -- This signal indicates that
                                            -- current transfer status is burst
                                            -- mode reads
        SMCsEnCo         : out   std_logic; -- chip select enable
        FastRdOp         : out   std_logic  -- In case of Burst reads when the
                                            -- buffer has more data than
                                            -- required by current AHB transfer,
                                            -- it is possible to provide the
                                            -- subsequent data from the
                                            -- internal buffer if the next
                                            -- sequential addresses are in the
                                            -- same field in zero cycles. So
                                            -- speculative advance reads are
                                            -- not done
       );
end SmcTSM;

-- -----------------------------------------------------------------------------
--
--                                   SmcTSM
--                                   ======
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--           The Transfer State Machine (TSM) block controls all the
--           transactions of the SmcCore block to the external memory device.
--           It generates the bus request signal for the control of the external
--           data bus lines. The load signals for the read and write access are
--           generated depending on the type of transfer and the device
--           characteristics. Load signals for the WEN and OEN delay counters
--           are also generated in this block. External bus turnaround cycles
--           are initiated appropriately after a read transfer completion.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of SmcTSM is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
-- The state machine's state value have been declared as constants in the
-- SmcPackage module

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iSmcState        : std_logic_vector(3 downto 0);
-- Local copy of SmcState

signal NextSmcState     : std_logic_vector(3 downto 0);
-- D-input of the SmcState signal

signal iSMBUSREQ        : std_logic;
-- Local copy of Bus request

signal NextSMBUSREQ     : std_logic;
-- d-input of iSMBUSREQ

signal NextSMCsEn       : std_logic;
-- D-input of SMCsEn

signal SMCsEn           : std_logic;
-- Local copy of SMCsEn

signal RdReqStr         : std_logic;
-- The read request is stored till the SMBUSGNT is asserted

signal NextRdReqStr     : std_logic;
-- D-input of RdReqStr

signal WrReqStr         : std_logic;
-- The write request is stored till the SMBUSGNT is asserted

signal NextWrReqStr     : std_logic;
-- D-input of WrReqStr

signal RdRemain         : std_logic;
-- signal to indicate that the read transaction is remaining

signal NextRdRemain     : std_logic;
-- D-input of RdRemain

signal BusDeGnt         : std_logic;
-- Signal to indicate that the Bus has been de-granted before the completion
-- of all transfers

signal NextBusDeGnt     : std_logic;
-- D-input of BusDeGnt

signal Wait1cyc         : std_logic;
-- A signal used for wait in the same state for 1 cycle

signal NextWait1cyc     : std_logic;
-- D-input of Wait1cyc

signal BufWrOvStrT      : std_logic;
-- The buffer WR completion signal is stored till the SMBUSGNT is asserted

signal NextBufWrOvStrT  : std_logic;
-- D-input of BufWrOvStrT

signal iBMRdTrans       : std_logic;
-- Local copy of BMRdTrans

signal NextBMRdTrans    : std_logic;
-- D-input of the iBMRdTrans signal

signal WaitToutErrD1    : std_logic;
-- One clock delayed version of WaitToutErr

signal iFastRdOp        : std_logic;
-- In case of Burst reads when the buffer has more data than required by current
-- AHB transfer, it is possible to provide the subsequent data from the
-- internal buffer if the next sequential addresses are in the same field in
-- zero cycles. So speculative advance reads are not done

signal NextFastRdOp     : std_logic;
-- D-input of the FastRdOp

signal MemRdInd         : std_logic;
-- Indicates a MemRdReq for same bank is detected after a burst is terminated
-- during MEM_RD state in BM cases when the read is NONSEQ so that it can be
-- used for generating BMRdTrans

signal NextMemRdInd     : std_logic;
-- D-input of the MemRdInd

signal RbleD1           : std_logic;
-- One clock delayed version of RBLE

signal MemRdReqQ        : std_logic;
-- One clock delayed version of MemRdReq

signal HTransRegQ       : std_logic_vector(1 downto 0);
-- One clock delayed version of HTransRegCo

signal BnkAddStrQ       : std_logic_vector(2 downto 0);
-- One clock delayed version of BnkAddStrCo

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
-- This signal is used to indicate that currently a burst read transfer is in
-- progress and when this signal is high, the next read data transfer is
-- started in advance so as to save a clock cycle. Burst transfer is broken
-- when a NONSEQ or IDLE is detected.
-- -----------------------------------------------------------------------------
NextBMRdTrans    <= '1' when (((MemRdReq = '1' or RdReqStr = '1' or
                               MemRdInd = '1' or
                              (MemWrOver = '1' and WtdRdReq = '1')) and
                              BM = '1' and iSmcState /= ST_TSM_MEMRD and
                              HBurstRegCo /= SINGLE) or
                              (MemRdReqQ = '1' and BM = '1'
                            and HBurstRegCo /= SINGLE and HTransRegQ = T_NONSEQ
                            and iSmcState = ST_TSM_MEMRD))
                 else
                    '0' when ((((MemRdReq = '1' and HTransRegCo = T_NONSEQ) or
                                MemWrReq = '1') and iSmcState = ST_TSM_MEMRD) or
                              HTransRegCo = T_IDLE or
                              (AhbRdEn = '1' and iBMRdTrans = '1' and  
                               (MemRdReq = '0' or (MemRdReq = '1' and 
                                BankCmpCo = '0'))))
                 else
                    iBMRdTrans;

-- -----------------------------------------------------------------------------
-- During the Burst reads if the HSIZE < MSize then more data than required
-- is read from the memory. This signal is used to refrain SMC from
-- speculatively starting the next read in advance as the data for the next
-- sequential address could be returned from the buffer
-- -----------------------------------------------------------------------------
NextFastRdOp    <= '1' when (BM = '1' and (HSizeRegCo < MW) and
                             (MemRdReq = '1' or (MemWrOver = '1' and
                                                 WtdRdReq = '1')))
                else
                   '0' when (AhbRdOver = '1')
                else
                   iFastRdOp;

-- -----------------------------------------------------------------------------
-- Sequential process for the various control signals and generation of 1
-- clock delayed version of the appropriate signals
-- -----------------------------------------------------------------------------
p_BmSigSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iBMRdTrans       <= '0';
    WaitToutErrD1    <= '0';
    iFastRdOp        <= '0';
    RbleD1           <= '0';
    MemRdReqQ        <= '0';
    HTransRegQ       <= "00";
    BnkAddStrQ       <= "000";
  elsif (HCLK'event and HCLK = '1') then
    iBMRdTrans       <= NextBMRdTrans;
    WaitToutErrD1    <= WaitToutErr;
    iFastRdOp        <= NextFastRdOp;
    RbleD1           <= RBLE;
    MemRdReqQ        <= MemRdReq;
    HTransRegQ       <= HTransRegCo;
    BnkAddStrQ       <= BnkAddStrCo;
  end if;
end process p_BmSigSeq;

-- -----------------------------------------------------------------------------
-- Combinational logic for main transfer state machine
-- -----------------------------------------------------------------------------
p_TsmComb : process (MemRdReq, MemWrReq, MemWrOver, BufWrOver, MWCfgDone,
                     BankCmpCo, SMBUSGNT, WaitEn, BM,
                     CntEnd, DelayEnd, WaitToutErr, WtdRdReq, WtdWrReq,
                     iSMBUSREQ, iSmcState, WEnCntEZ, OEnCntEZ,
                     BMlenEnd, SMCsEn, RdReqStr, WrReqStr, RdRemain,
                     BusDeGnt, MemRdOver, Wait1cyc, BufWrOvStrT, BufByPassCo,
                     iBMRdTrans, HTransRegCo, WaitToutErrD1, AhbRdEn,
                     iFastRdOp, AhbRdOver, CntEZEnd, MemRdOverCo, RBLE, RbleD1,
                     BnkAddStrQ,BnkAddStrCo)
begin

  NextSmcState     <= iSmcState;
  NextSMCsEn       <= SMCsEn;
  RdXdatEnCo       <= '0';
  WrXdatEnCo       <= '0';
  XdatDisCo        <= '0';
  XoutEnCo         <= '0';
  XoutDisCo        <= '0';
  NextSMBUSREQ     <= iSMBUSREQ;
  RdCntLdCo        <= '0';
  RdBMcntLdCo      <= '0';
  WrCntLdCo        <= '0';
  TrArCntLdCo      <= '0';
  OEnCntLdCo       <= '0';
  WEnCntLdCo       <= '0';
  ExtWrEnCo        <= '0';
  ExtWrDisCo       <= '0';
  AddrIncCo        <= '0';
  ZeroIdleCo       <= '0';
  NextRdReqStr     <= RdReqStr;
  NextWrReqStr     <= WrReqStr;
  NextRdRemain     <= RdRemain;
  NextBusDeGnt     <= BusDeGnt;
  NextWait1cyc     <= Wait1cyc;
  NextBufWrOvStrT  <= BufWrOvStrT;
  BrstAddIncCo     <= '0';
  NextMemRdInd     <= '0';

  case iSmcState is

    -- After reset, the state machine resides in this state. The different
    -- triggering points for the memory transfer are :
    -- 1. When a write transfer is detected, depending on the BufBypass status
    --    the state machine moves to the either the ST_TSM_BUFWR or the
    --    ST_TSM_MEMWR state. If the HSIZE = MSize then the buffer is bypassed
    --    and external write transfer is started immediately, by routing the 
    --    HWDATA directly to the external data bus. The transfer is initiated
    --    only if the external bus is granted.
    --    If the sizes are different then the data is first collected into the
    --    buffer and the state machine positions itself in the ST_TSM_BUFWR.
    --    The bus-request is asserted before moving out.
    -- 2. When a fresh memory read request is initiated, a request for the bus
    --    is issued and when the bus is granted, the CS is asserted with the
    --    start of the read access count. The OEN is asserted depending on the
    --    amount of delay required after the CS assertion. If delay is greater
    --    than 0, then the TSM goes to the ST_TSM_OENCNT state before proceeding
    --    to the ST_TSM_MEMRD state. But in the external wait controlled mode
    --    the OEN is asserted with the CS as the delay value is not
    --    deterministic. In this case and in the case if the delay value is 0
    --    the next state is ST_TSM_MEMRD and ST_TSM_OENCNT state is bypassed.
    -- 3. During read from the memory when the SmcCore is de-granted in between
    --    and few more packets of data are remaining to be fetched, then the TSM
    --    will come in from the ST_TSM_MEMRD state and remain in this state
    --    till the bus is granted to the SmcCore by the DBI. The AHB master will
    --    be waited till bus is granted and all the data packets are read in.
    -- 4. Whenever WaitToutErr occurs during any of the transfers (write or
    --    read) the SmcCore aborts the transactions, de-asserts all the control
    --    signals and stays in the ST_TSM_IDLE state till a new valid tranaction
    --    is initiated on the bus
    when ST_TSM_IDLE =>
      NextBufWrOvStrT  <= '0';
      if (WaitToutErr = '1') then
        NextSmcState     <= ST_TSM_IDLE;
      elsif (MemWrReq = '1' or WrReqStr = '1' or WtdWrReq = '1') then
        NextSMBUSREQ     <= '1';
        NextWait1cyc     <= '1';
        if (BufByPassCo = '1' and SMBUSGNT = '1' and iSMBUSREQ = '1' and 
            Wait1cyc = '1') then
          NextSMCsEn       <= '1';
          WrXdatEnCo       <= '1';
          WrCntLdCo        <= '1';
          NextWrReqStr     <= '0';
          NextWait1cyc     <= '0';
          if (WEnCntEZ = '1' or WaitEn = '1') then
            NextSmcState     <= ST_TSM_MEMWR;
            ExtWrEnCo        <= '1';
          else
            NextSmcState     <= ST_TSM_WENCNT;
            WEnCntLdCo       <= '1';
          end if;
        elsif (BufByPassCo = '1' and SMBUSGNT = '0' and Wait1cyc = '1') then
          NextWrReqStr <= '1';
          NextWait1cyc <= '0';
        elsif (BufByPassCo = '1' and Wait1cyc = '0') then
          NextWrReqStr     <= '1';
          NextWait1cyc     <= '1';
        else
          NextWait1cyc     <= '0';
          NextBufWrOvStrT  <= BufWrOver;
          NextSmcState     <= ST_TSM_BUFWR;
          NextWrReqStr     <= '0';
        end if;
      elsif ((MemRdReq = '1' or RdRemain = '1' or WtdRdReq = '1' or
              RdReqStr = '1') and SMBUSGNT = '0' and Wait1cyc = '1') then
        NextRdReqStr     <= '1';
        NextSMBUSREQ     <= '1';
        NextWait1cyc     <= '0';
        NextSmcState     <= ST_TSM_IDLE;
      elsif ((MemRdReq = '1' or RdRemain = '1' or RdReqStr = '1' or
              (MWCfgDone = '1' and WtdRdReq = '1')) and SMBUSGNT = '1' and 
               iSMBUSREQ = '1' and Wait1cyc = '1') then
        NextSMBUSREQ     <= '1';
        NextRdReqStr     <= '0';
        RdXdatEnCo       <= '1';
        NextSMCsEn       <= '1';
        NextRdRemain     <= '0';
        RdCntLdCo        <= '1';
        NextWait1cyc     <= '0';
        if (OEnCntEZ = '1' or WaitEn = '1') then
          NextSmcState     <= ST_TSM_MEMRD;
          XoutEnCo         <= '1';
        else
          NextSmcState     <= ST_TSM_OENCNT;
          OEnCntLdCo       <= '1';
        end if;
      elsif ((MemRdReq = '1' or RdRemain = '1' or WtdRdReq = '1' or
                  RdReqStr = '1') and Wait1cyc = '0') then
        NextWait1cyc     <= '1';
        NextRdReqStr     <= '1';
        NextSMBUSREQ     <= '1';
      end if;

    -- This is the state where the data from AHB is collected into an internal
    -- buffer due to mismatch in AHB transfer size and memory width. For
    -- example in the case of HSIZE=8-bit and MSize=32-bit, upto a maximum of
    -- 4 bytes can be collected into the buffer before writing into memory.
    -- Once the buffer is full, the SmcCore can start flushing data into the
    -- device. The subsequent state transition depends on when the write enable
    -- can be asserted, either immediately or after some delay.  
    -- Due to dynamic priority arbitration of the external data bus, checks
    -- are performed to ensure that the SmcCore has got the Bus Grant, otherwise
    -- the SmcCore will remain in the same state till the bus is granted again
    when ST_TSM_BUFWR =>
      if (SMBUSGNT = '0') then
        if (BusDeGnt = '0') then
          NextSMBUSREQ     <= '0';
          NextBusDeGnt     <= '1';
          NextSMCsEn       <= '0';
        elsif (BusDeGnt = '1') then
          NextSMBUSREQ     <= '1';
        end if;
        if (BufWrOver = '1') then
          NextBufWrOvStrT  <= '1';
        end if;
      elsif ((BufWrOver = '1' or BufWrOvStrT = '1') and
             ((SMBUSGNT = '1') and (iSMBUSREQ = '1'))) then
        NextBufWrOvStrT  <= '0';
        NextSMCsEn       <= '1';
        WrXdatEnCo       <= '1';
        WrCntLdCo        <= '1';
        NextBusDeGnt     <= '0';
        if ((WEnCntEZ = '1') or (WaitEn = '1')) then
          NextSmcState     <= ST_TSM_MEMWR;
          ExtWrEnCo        <= '1';
        else
          NextSmcState     <= ST_TSM_WENCNT;
          WEnCntLdCo       <= '1';
        end if;
      end if;

    -- In this state the TSM waits for the delay completion indication
    -- so as to assert the WEN
    when ST_TSM_WENCNT =>
      if (DelayEnd = '1') then
        NextSmcState     <= ST_TSM_MEMWR;
        ExtWrEnCo        <= '1';
      end if;

    -- The Write to the memory is in progress in this state. If WaitToutErr
    -- signal is detected, then the SmcCore aborts the transfer and
    -- moves to IDLE state. When the HSIZE > MSIZE, then multiple accesses to
    -- the memory devices are required which is indicated MemWrOver being
    -- de-asserted. The TSM then moves to the ST_TSM_SEQWR so as to de-assert
    -- the WEN output. The CntEnd signal in this state indicates the end of
    -- the WR access time. If the WR is complete & there is a new WR request
    -- or a waited WR request, then the next state is the ST_TSM_BUFWR. If its
    -- the same bank then, CS is kept asserted otherwise it is de-asserted.
    -- On the other hand if a new RD transaction or waited RD is pending, then
    -- the TSM goes to turnaround for 1 HCLK by using the ZeroIdle signal. If
    -- there are no active requests on the AHB then the TSM can move to the
    -- IDLE state. whenever the next state is an IDLE or a WR to a different
    -- bank, then the CS should be disabled one cycle later than the positive
    -- WEN, so the hold from negative WEN to the CS is satisfied
    when ST_TSM_MEMWR =>
      if (Wait1cyc = '0' and WaitToutErr = '1') then
        ExtWrDisCo       <= '1';
        NextWait1cyc     <= '1';
      elsif (Wait1cyc = '1' and (WaitToutErr = '1' or WaitToutErrD1 = '1')) then
        NextSmcState     <= ST_TSM_IDLE;
        NextSMBUSREQ     <= '0';
        XdatDisCo        <= '1';
        NextSMCsEn       <= '0';
        NextWait1cyc     <= '0';
      elsif (CntEnd = '1' or CntEZEnd = '1') then
        NextSmcState     <= ST_TSM_SEQWR;
        ExtWrDisCo       <= '1';
      end if;

    -- The MemWrOver=0 indicates that the HSIZE > MSIZE and multiple
    -- transfers are required to complete the WR transfer. The SMADDR
    -- incremented and depending on the value of WEnCnt the next state is
    -- determined. If the WR transfer is successful as indicated by
    -- MemWrOver=1, then depending on whether any new WR or RD or any
    -- waited WR or RD transfer is initiated, transition to appropriate
    -- state is made. If the next transfer is a WR to different bank, then
    -- the CS is disabled. On the other hand, if the next transfer is a RD
    -- then the next state is ST_TSM_TURNARND for 1 cycle. This is achieved by
    -- the ZeroIdle signal. If on the end of the current WR transfer, no
    -- valid transfers are initiated, then the TSM moves to IDLE state.
    -- Due to dynamic priority arbitration of the external data bus, checks
    -- are performed to ensure that the SmcCore has got the Bus Grant, otherwise
    -- the SmcCore will remain in the same state till the bus is granted again.
    -- The Bus could be de-granted before all the write data packets have been
    -- flushed out to the memory from the internal Buffer in the HSIZE > MSIZE
    -- case. In the event of this, the SMBUSREQ is de-asserted for one HCLK
    -- cycle and again asserted. This is required to satisfy the DBI protocol.
    when ST_TSM_SEQWR =>
      if ( Wait1cyc = '1') then
        NextWait1cyc     <= '0';
        NextSMCsEn       <= '1';
        WrXdatEnCo       <= '1';
        WrCntLdCo        <= '1';
        NextWrReqStr     <= '0';
        if (WEnCntEZ = '1' or WaitEn = '1') then
          NextSmcState     <= ST_TSM_MEMWR;
          ExtWrEnCo        <= '1';
          NextWait1cyc     <= '0';
        else
          NextSmcState     <= ST_TSM_WENCNT;
          WEnCntLdCo       <= '1';
        end if;
      else
        if (MemWrOver = '0' and SMBUSGNT = '0' and BusDeGnt = '0') then
          NextSMBUSREQ     <= '0';
          NextBusDeGnt     <= '1';
          NextSMCsEn       <= '0';
          XdatDisCo        <= '1';
        elsif (MemWrOver = '0' and SMBUSGNT = '0' and
               iSMBUSREQ = '0' and BusDeGnt = '1') then
          NextSMBUSREQ  <= '1';
        elsif (MemWrOver = '0' and SMBUSGNT = '1' and iSMBUSREQ = '1') then
          AddrIncCo        <= '1';
          NextBusDeGnt     <= '0';
          WrCntLdCo        <= '1';
          NextSMCsEn       <= '1';
          WrXdatEnCo       <= '1';
          if (WEnCntEZ = '1' or WaitEn = '1') then
            NextSmcState     <= ST_TSM_MEMWR;
            ExtWrEnCo        <= '1';
          else
            NextSmcState     <= ST_TSM_WENCNT;
            WEnCntLdCo       <= '1';
          end if;
        elsif ((MemWrOver = '1' and WtdWrReq = '1') and SMBUSGNT = '1' and 
                iSMBUSREQ = '1') then
          if (BufByPassCo = '1' and (not(RBLE = '0' and RbleD1 = '1'))) then
            if (BnkAddStrQ /= BnkAddStrCo) then
              NextWait1cyc     <= '1';
            else 
              NextSMCsEn       <= '1';
              WrXdatEnCo       <= '1';
              WrCntLdCo        <= '1';
              NextWrReqStr     <= '0';
              if (WEnCntEZ = '1' or WaitEn = '1') then
                NextSmcState     <= ST_TSM_MEMWR;
                ExtWrEnCo        <= '1';
              else
                NextSmcState     <= ST_TSM_WENCNT;
                WEnCntLdCo       <= '1';
              end if;
            end if;
          elsif (BufByPassCo = '1' and (RBLE = '0' and RbleD1 = '1')) then
            NextSmcState     <= ST_TSM_IDLE;
            NextSMCsEn       <= '0';
            WrXdatEnCo       <= '1';
            NextWrReqStr     <= '1';
            ExtWrDisCo       <= '1';
          else
            NextSmcState     <= ST_TSM_BUFWR;
            if (BankCmpCo = '0') then
              NextSMCsEn       <= '0';
            end if;
          end if;
        elsif ((MemWrOver = '1' and WtdWrReq = '1') and SMBUSGNT = '0') then
          NextSmcState     <= ST_TSM_IDLE;
          NextSMBUSREQ     <= '0';
          NextSMCsEn       <= '0';
          ExtWrDisCo       <= '0';
          XdatDisCo        <= '1';
          NextWrReqStr     <= '1';
        elsif (MemWrOver = '1' and WtdRdReq = '1') then
          NextSmcState     <= ST_TSM_TURNARND;
          ZeroIdleCo       <= '1';
          NextSMCsEn       <= '0';
          XdatDisCo        <= '1';
        elsif (BusDeGnt = '0') then
          NextSmcState     <= ST_TSM_IDLE;
          NextSMBUSREQ     <= '0';
          NextSMCsEn       <= '0';
          ExtWrDisCo       <= '0';
          XdatDisCo        <= '1';
        end if;
      end if;

    -- Turn-Around cycles are required to ensure that there is no conflict
    -- of data on the data Bus. The bus turnaround cycles are carried out when
    -- the SmcCore is in this state. The  number of Turn Around cycles are
    -- determined by the IDCY value programmed corresponding to the particular
    -- memory device.
    -- Bus turnarounds are inserted for the following cases :
    -- 1. after completion of a read transaction and the next transaction
    --    is a WR or a RD to a different bank.
    -- 2. when there is a Wait-Timeout-Error in the external wait controlled
    --    memory RD transfer.
    -- 3. On successfull completion of a RD transfer if there are no more
    --    transfers on the AHB.
    -- 4. One HCLK cycle turn-around is inserted when a RD follows a WR transfer
    -- When the Turn-Around cycles are in progress, if there is any new RD or
    -- or a WR transfer request to the memory, then these requests are stored
    -- These requests will be serviced after the completion of the Turn-Around
    -- Transition to the subsequent state of the TSM from this state depends
    -- on the next transfer to be serviced. If there are no other transfers on
    -- the AHB bus, then the TSM goes to the IDLE state.
    -- Before going into any other state, the SmcCore waits for
    -- the completion of the turn around cycles indicated by CntEnd.
    when ST_TSM_TURNARND =>
      if (MemRdReq = '1') then
        NextRdReqStr     <= '1';
      elsif (MemWrReq = '1') then
        NextWrReqStr     <= '1';
      elsif (BufWrOver = '1') then
        NextBufWrOvStrT  <= '1';
      end if;
      if ((MemWrReq = '1' or WrReqStr = '1' or WtdWrReq = '1') and
          (CntEnd = '1' or CntEZEnd = '1')) then
        if (BufByPassCo = '1' and SMBUSGNT = '1' and iSMBUSREQ = '1') then
          NextSMCsEn       <= '1';
          WrXdatEnCo       <= '1';
          WrCntLdCo        <= '1';
          NextWrReqStr     <= '0';
          NextBufWrOvStrT  <= '0';
          if ((WEnCntEZ = '1') or (WaitEn = '1')) then
            NextSmcState     <= ST_TSM_MEMWR;
            ExtWrEnCo        <= '1';
          else
            NextSmcState     <= ST_TSM_WENCNT;
            WEnCntLdCo       <= '1';
          end if;
        else
          NextSmcState     <= ST_TSM_BUFWR;
          NextWrReqStr     <= '0';
        end if;
      elsif ((MemRdReq = '1' or RdReqStr = '1' or WtdRdReq = '1') and
             (CntEnd = '1' or CntEZEnd = '1') and SMBUSGNT = '1' and 
              iSMBUSREQ = '1') then
        NextRdReqStr     <= '0';
        RdCntLdCo        <= '1';
        NextSMCsEn       <= '1';
        RdXdatEnCo       <= '1';
        if ((WaitEn = '1') or (OEnCntEZ = '1')) then
          NextSmcState     <= ST_TSM_MEMRD;
          XoutEnCo         <= '1';
        else
          NextSmcState     <= ST_TSM_OENCNT;
          OEnCntLdCo       <= '1';
        end if;
      elsif (CntEnd = '1' or CntEZEnd = '1') then
        NextSmcState     <= ST_TSM_IDLE;
        NextSMCsEn       <= '0';
        XdatDisCo        <= '1';
        XoutDisCo        <= '1';
        NextSMBUSREQ     <= '0';
      end if;

    -- TSM waits in this state for the completion of the delay after which
    -- the SMOEN can be asserted.
    when ST_TSM_OENCNT =>
      if (DelayEnd = '1') then
        NextSmcState     <= ST_TSM_MEMRD;
        XoutEnCo         <= '1';
      end if;

    -- During the read transfer the SmcCore is in this state and waits for the
    -- access time completion. On CntEnd assertion, if all the data pkts have
    -- been read (as indicated by MemRdOver=1), then the next state is
    -- enabling the AHB read. If there are still some data pkts left to be read
    -- from the memory device because of the HSIZE to MSIZE differences, then
    -- access counters are enabled again by asserting the address incrementer
    -- signal, AddrIncCo, and the remaining data pkts are read in and stored
    -- till the memory read is complete. In the SMWAIT
    -- control mode if WaitToutErr is encountered then the SmcCore inserts
    -- turnaround cycles and goes to the ST_TSM_TURNARND state.
    -- If the device is a Burst ROM (BM=1), then the HBURST information is used
    -- to perform fast speculative burst reads with the memory address value,
    -- SMADDR, the memory device generated in advance. During the fast burst
    -- read mode the SmcCore's TSM continues to remain in this state.
    -- The various trigger for the state transitions are :
    -- 1. In the External Wait controlled mode, when there is a Wait-Timeout-
    --    Error situation SmcCore will abort the current read transaction,
    --    de-assert all the control signals and insert bus turnaround cycles.
    --    On the other hand if the next transfer is a WR then too the TSM will
    --    move to the ST_TSM_TURNARND state
    -- 2. During burst read operation from the Burst Read capable device (device
    --    which has a normal intial read access time, but fast subsequent access
    --    time, effectively increasing the bandwidth), the SmcCore does
    --    speculative reads which are ahead of real AHB request. When performing
    --    speculative fast burst reads, the SmcCore in parallel also checks for
    --    termination of the Burst read transfer. The burst could have been
    --    aborted due to next transfer which could either be a Write or a Read
    --    to a different bank or a new NONSEQ Read transfer. The next state
    --    transition will depend on all these conditions. If the burst Read
    --    request continues from the AHB, the TSM will continue in this state.
    --    The SMCS & the SMOEN will be kept continuously asserted when doing
    --    burst reads. The initial longer access time is indicated by the
    --    assertion of the RdCntLdCo signals. Whereas the shorter burst access
    --    time is indicated by the assertion of the RdBMcntLdCo signal. Even
    --    the AHB is continuously doing burst reads, the SmcCore aborts the
    --    burst on reaching the Quad-Boundary address of the device. So if the
    --    1st address is aligned, then the SmcCore does 1 initial longer access
    --    and subsequent 3 shorted accesses. The hitting of the Quad-Boundary
    --    address is indicated by the BMlenEnd signal.
    -- 3. There is one exception to the speculative Burst read from the Burst
    --    memory device when the SmcCore does not perform advance speculative
    --    reads. This happens for the case when the HSIZE < MSize and the
    --    RdWrBuf already has cached in more data than required by the current
    --    AHB read address. If the subsequent reads from the AHB are sequential
    --    in the same address range, then the data is already available in the
    --    RdWrBuf and the data is returned with zero wait cycles. This is
    --    indicated by the FastRdOp signal. In this scenario the next
    --    transition is to the ST_TSM_AHBRD state so as to route the data to
    --    the AHB.
    -- 4. In the normal read mode, once the data is read in from the memory
    --    device & the RdWrBuf is full as indicated by MemRdOver=1 the TSM will
    --    move to the ST_TSM_AHBRD state so as to route the data to the AHB.
    -- 5. The value of the OEN delay count of a new read access determines
    --    whether the SMOEN can be asserted immediately or after the delay.
    -- 6. During reads if the External Bus is de-granted with some more reads
    --    yet to be performed from the device, then after the current read is
    --    complete, the RdRemain is asserted, SMBUSREQ is de-asserted and the
    --    subsequent state is ST_TSM_IDLE.
    -- The address increment signal for the Burst address, BrstAddIncCo, is
    -- generated during continuous Burst reads as the read data from the memory
    -- fills the RdWrBuf and the data is routed to the AHB.
    when ST_TSM_MEMRD =>
      NextBufWrOvStrT  <= '0';
      if (WaitToutErr = '1') then
        NextSmcState     <= ST_TSM_TURNARND;
        TrArCntLdCo      <= '1';
        NextSMBUSREQ     <= '0';
        NextSMCsEn       <= '0';
        XoutDisCo        <= '1';
        XdatDisCo        <= '1';
      elsif (AhbRdEn = '1' and iBMRdTrans = '1' and
             (HTransRegCo = T_NONSEQ and MemRdReq = '1' and BankCmpCo = '1') and
             SMBUSGNT = '1' and iSMBUSREQ = '1') then
        RdCntLdCo        <= '1';
        if (OEnCntEZ = '1' or WaitEn = '1') then
          XoutEnCo         <= '1';
        else
          NextSmcState     <= ST_TSM_OENCNT;
          NextMemRdInd     <= '1';
          OEnCntLdCo       <= '1';
          XoutDisCo        <= '1';
        end if;
      elsif (AhbRdEn = '1' and iBMRdTrans = '1' and
             ((((MemRdReq = '1' and BankCmpCo = '0') or MemWrReq = '1') and
              SMBUSGNT = '1' and iSMBUSREQ = '1') or
             (HTransRegCo = T_IDLE or
              (MemRdReq = '0' and MemWrReq = '0')))) then
        NextSmcState     <= ST_TSM_TURNARND;
        TrArCntLdCo      <= '1';
        XdatDisCo        <= '1';
        XoutDisCo        <= '1';
        NextSMCsEn       <= '0';
        if (MemRdReq = '1') then
          NextRdReqStr     <= '1';
        elsif (MemWrReq = '1') then
          NextWrReqStr     <= '1';
        end if;
      elsif (iBMRdTrans = '1' and SMBUSGNT = '1' and iSMBUSREQ = '1') then
        if ((CntEnd = '1' and MemRdOverCo = '0') or
            (CntEZEnd = '1' and MemRdOverCo = '0')) then
          AddrIncCo        <= '1';
          RdBMcntLdCo      <= '1';
        elsif (MemRdOverCo = '1' and iFastRdOp = '0') then
          BrstAddIncCo     <= '1';
          if (BMlenEnd = '0') then
            RdBMcntLdCo      <= '1';
          else
            RdCntLdCo        <= '1';
          end if;
        elsif (MemRdOverCo = '1' and iFastRdOp = '1') then
          NextSmcState     <= ST_TSM_AHBRD;
          XoutDisCo        <= '1';
        end if;
      elsif (((CntEnd = '1' and MemRdOverCo = '0') or
              (CntEZEnd = '1' and MemRdOverCo = '0')) and SMBUSGNT = '1' 
               and iSMBUSREQ = '1') then
        AddrIncCo        <= '1';
        if (WaitEn = '1' or OEnCntEZ = '1') then
          if (BM = '1') then
            RdBMcntLdCo      <= '1';
          else
            RdCntLdCo        <= '1';
          end if;
        else
          NextSmcState     <= ST_TSM_OENCNT;
          RdCntLdCo        <= '1';
          OEnCntLdCo       <= '1';
          XoutDisCo        <= '1';
        end if;
      elsif (((CntEnd = '1' and MemRdOverCo = '0') or
              (CntEZEnd = '1' and MemRdOverCo = '0')) and SMBUSGNT = '0') then
        NextSmcState     <= ST_TSM_TURNARND;
        TrArCntLdCo      <= '1';
        NextRdRemain     <= '1';
        XoutDisCo        <= '1';
        NextSMCsEn       <= '0';
        XdatDisCo        <= '1';
      elsif (MemRdOverCo = '1' and SMBUSGNT = '0' and iBMRdTrans = '1' and
               iFastRdOp = '0') then
        BrstAddIncCo     <= '1';
        NextSmcState     <= ST_TSM_TURNARND;
        TrArCntLdCo      <= '1';
        XoutDisCo        <= '1';
        NextSMCsEn       <= '0';
        XdatDisCo        <= '1';
      elsif (MemRdOverCo = '1') then
        NextSmcState     <= ST_TSM_AHBRD;
        XoutDisCo        <= '1';
        NextSMCsEn       <= '0';
      end if;

    -- This state controls the routing of read data to the HRDATA bus in the
    -- AHB interface block to enable AHB Reads. The various state transition
    -- triggers are :
    -- 1. At the completion of the RD operation, indicated by the MemRdOver,
    --    if the Bus is de-granted, then the TSM transitions to the IDLE state
    --    after de-asserting all the control signals.
    -- 2. When the AHB completes its read operation from the RdWrBuf, indicated
    --    by the AhbRdOver, then depending in whether the next transfer is
    --    continuation of SEQ RDs to the same device or RD to a different Bank
    --    or a WR operation, the state change decisions are taken.
    --    [a] If the next read is to the same bank and if it is External Wait
    --        controlled mode or the OEN delay value is zero then, the SMOEN
    --        is asserted immediately with the SMCS
    --    [b] If during Burst Read operation for the exception case when the
    --        HSIZE < MSize, the RdWrBuf will have cached in more data than
    --        required. The subsequent SEQ read datas are returned from the
    --        internal RdWrBuf. If the subsequent Reads requests from AHB are
    --        still SEQ and if the Quad-Boundary Address location is not yet
    --        reached, then faster read access is initiated. The SMCS & SMOEN
    --        are asserted together.
    --    [c] In the case of a normal non-burst reads, the SMOEN will be
    --        asserted after the OEN count delay is accounted for.
    -- 3. If the next transfer after the completion of the AHB Read is a Write
    --    or a Read to a different bank, then the SmcCore will perform bus
    --    turn-around cycles before starting the memory access. These requests
    --    are stored appropriately.
    -- 4. In the event of not further transfer requests from the AHB, then
    --    Turn-Around cycles are performed.
    when ST_TSM_AHBRD =>
      if (MemRdOver = '1' and SMBUSGNT = '0') then
          NextSmcState     <= ST_TSM_TURNARND;
          TrArCntLdCo      <= '1';
          NextSMCsEn       <= '0';
          XdatDisCo        <= '1';
      elsif (MemRdReq = '1' and BankCmpCo = '1' and SMBUSGNT = '1' and 
             iSMBUSREQ = '1' and (AhbRdOver = '1' or AhbRdEn = '1')) then
        NextWait1cyc     <= '0';
        if (OEnCntEZ = '1' or WaitEn = '1') then
          NextSmcState     <= ST_TSM_MEMRD;
          XoutEnCo         <= '1';
          RdCntLdCo        <= '1';
          NextSMCsEn       <= '1';
        elsif (BMlenEnd = '0' and HTransRegCo = T_SEQ and BM = '1') then
          XoutEnCo         <= '1';
          RdBMcntLdCo      <= '1';
          NextSMCsEn       <= '1';
          NextSmcState     <= ST_TSM_MEMRD;
        else
          NextSmcState     <= ST_TSM_OENCNT;
          RdCntLdCo        <= '1';
          OEnCntLdCo       <= '1';
          XoutDisCo        <= '1';
          NextSMCsEn       <= '1';
        end if;
      elsif ((((MemRdReq = '1' and BankCmpCo = '0') or MemWrReq = '1') and
               SMBUSGNT = '1' and iSMBUSREQ = '1' and (AhbRdOver = '1' or 
               AhbRdEn = '1')) or ((MemRdReq = '1' or MemWrReq = '1') and 
               SMBUSGNT = '0')) then
        NextSmcState     <= ST_TSM_TURNARND;
        TrArCntLdCo      <= '1';
        XdatDisCo        <= '1';
        XoutDisCo        <= '1';
        NextSMCsEn       <= '0';
        if (MemRdReq = '1') then
          NextRdReqStr     <= '1';
        elsif (MemWrReq = '1') then
          NextWrReqStr     <= '1';
        end if;
        NextWait1cyc     <= '0';
      elsif (Wait1cyc = '0') then
        NextWait1cyc     <= '1';
      elsif (Wait1cyc = '1' and (MemRdReq = '0' and MemWrReq = '0')) then
        NextWait1cyc     <= '0';
        NextSmcState     <= ST_TSM_TURNARND;
        TrArCntLdCo      <= '1';
        XdatDisCo        <= '1';
        XoutDisCo        <= '1';
        NextSMCsEn       <= '0';
      end if;

    when others =>
      NextSmcState     <= ST_TSM_IDLE;
  end case;
end process p_TsmComb;

-- -----------------------------------------------------------------------------
-- Sequential process for the various control signals
-- -----------------------------------------------------------------------------
p_CtrlSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iSmcState        <= ST_TSM_IDLE;
    SMCsEn           <= '0';
    iSMBUSREQ        <= '0';
    RdReqStr         <= '0';
    WrReqStr         <= '0';
    RdRemain         <= '0';
    BusDeGnt         <= '0';
    Wait1cyc         <= '0';
    BufWrOvStrT      <= '0';
    MemRdInd         <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iSmcState        <= NextSmcState;
    iSMBUSREQ        <= NextSMBUSREQ;
    SMCsEn           <= NextSMCsEn;
    RdReqStr         <= NextRdReqStr;
    WrReqStr         <= NextWrReqStr;
    RdRemain         <= NextRdRemain;
    BusDeGnt         <= NextBusDeGnt;
    Wait1cyc         <= NextWait1cyc;
    BufWrOvStrT      <= NextBufWrOvStrT;
    MemRdInd         <= NextMemRdInd;
  end if;
end process p_CtrlSeq;

-- -----------------------------------------------------------------------------
-- connect local copies to output
-- -----------------------------------------------------------------------------
SMBUSREQ         <= iSMBUSREQ;
SmcState         <= iSmcState;
SMCsEnCo         <= NextSMCsEn;
BMRdTrans        <= iBMRdTrans;
FastRdOp         <= iFastRdOp;

end synth;

-- --================================== End ==================================--
