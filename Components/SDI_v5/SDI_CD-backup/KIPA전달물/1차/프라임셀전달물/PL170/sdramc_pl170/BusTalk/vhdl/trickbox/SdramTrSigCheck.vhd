--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : $RCS: $
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--
--  ----------------------------------------------------------------------------
--  Purpose       : This block checks for different conditions and commands
--                  issued by the Controller.
--  ----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library Std_DevelopersKit;
use std_developerskit.std_IOpak.all;

entity SdramTrSigCheck is
port ( 
      HCLK        : in   std_logic; -- Clock Input from AHB
      HRESETn     : in   std_logic; -- Reset from AHB 
      nPOR        : in   std_logic; -- Power On Reset 
      ReadSel     : in   std_logic; -- Read Select from the top module 
      WriteSel    : in   std_logic; -- Write Select from the top module 
      DIn         : in   std_logic_vector(31 downto 0); 
                                    -- Data Input from the top module  
      CKE         : in   std_logic_vector(3 downto 0); 
                                    -- Clock Enable Pin to memory device
      nRAS        : in   std_logic; -- nRAS output from the memory module 
      nCAS        : in   std_logic; -- nCAS output from the memory module 
      nCS         : in   std_logic_vector(3 downto 0); -- Chip Select 
      nWE         : in   std_logic; -- nWE output from the memory module 
      A10         : in   std_logic; -- Addr(10) output from the memory module 
      A5          : in   std_logic; -- Addr(5) output from the memory module 
      A6          : in   std_logic; -- Addr(6) output from the memory module 

      DOut        : out  std_logic_vector(31 downto 0);
                                    -- Data Output to the top module 
      ModeBit     : out  std_logic;  -- SDRAM Select 
      ExtBusWidth : out  std_logic  -- 32-32 / 32-16 Selection Bit
     ); 
end SdramTrSigCheck;

-- ----------------------------------------------------------------------------
--
--                      SdramTrSigCheck
--                      ================
--      
-- ----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module checks for the diffrent command issued by the UUT. It checks the
-- Refresh command Width and also the cycles taken between two consecutive 
-- Refresh command. It also checks for the correctness of Refresh cycle 
-- frequency.
--
--===========================ARCHITECTURE=======================================
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------
 
architecture behavioural of SdramTrSigCheck is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
signal NextPALL              : std_logic;
-- D-Input to PALL

signal NextNOP               : std_logic;
-- D-Input to NOP

signal NextModeBit           : std_logic;
-- D-Input to ModeBit

signal NextExtBusWidth           : std_logic;
-- D-Input to ExtBusWidth

signal NextModeRegCommand    : std_logic;
-- D-Input to ModeRegCommand

signal NextRegCount          : std_logic_vector(6 downto 0);
-- D-Input to RegCount

signal nReset                : std_logic;

signal NextRefCount          : std_logic_vector(3 downto 0);

signal NextExpRefCycles      : std_logic_vector(15 downto 0);

signal NextInitCheckEn       : std_logic;

signal ValidRefCommand       : std_logic;

signal NextRefCommand        : std_logic;

signal NextRefWidth          : std_logic_vector(2 downto 0);

signal NextDataReg           : std_logic_vector(31 downto 0);

signal NextSREF              : std_logic;
-- D-Input to SREF

-- -----------------------------------------------------------------------------
-- Register declarations
-- -----------------------------------------------------------------------------
signal  SREF                 : std_logic;
-- SREF command Detect Ouptut

signal  PresentState         : std_logic_vector(2 downto 0);

signal  NextState            : std_logic_vector(2 downto 0);

signal  InitSeqSt            : std_logic;

signal  NextInitSeqSt        : std_logic;

signal  RefCommand           : std_logic;

signal  DelayRefCommand      : std_logic;

signal  RefWidth             : std_logic_vector(2 downto 0);

signal  NextRefStatus        : std_logic;

signal  RefStatus            : std_logic;

signal  RefCount             : std_logic_vector(3 downto 0);

signal  RefCycles            : std_logic_vector(15 downto 0);

signal  NextRefCycles        : std_logic_vector(15 downto 0);

signal  ModeRegCheck         : std_logic;

signal  NextModeRegCheck     : std_logic;

signal  InitCheckEn          : std_logic;

signal  ModeRegCommand       : std_logic;

signal  ModeRegCount         : std_logic_vector(6 downto 0);

signal  PhaseRefEn           : std_logic;

signal  NextPhaseRefEn       : std_logic;

signal  RefCheckEn           : std_logic;

signal  NextRefCheckEn       : std_logic;

signal  RefErrStat           : std_logic;

signal  NextRefErrStat       : std_logic;

signal  NOP                  : std_logic;
-- NOP command Detect Ouptut

signal  ExpRefCycles         : std_logic_vector(15 downto 0);

signal  DataReg              : std_logic_vector(31 downto 0);

signal  PALL                 : std_logic;
-- PALL command Detect Ouptut

signal  RefIgnore            : std_logic_vector(2 downto 0); 

signal  NextRefIgnore        : std_logic_vector(2 downto 0);

signal  iModeBit             : std_logic;
-- Internal copy of the ModeBit

signal  iExtBusWidth         : std_logic;
-- Internal copy of the ExtBusWidth

-- -----------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
-- ----------------------------------------------------------------------------
begin
-- ---------------------------------------------------------------------------
-- Refresh Check Error Status 
-- ---------------------------------------------------------------------------
p_RefErrStatComb : process (ExpRefCycles, ValidRefCommand, RefIgnore, 
                            RefCheckEn, RefCycles, RefErrStat, WriteSel, DIn)
begin
  if (WriteSel = '1' and DIn(10) = '1') then
    NextRefErrStat <= '0';
  elsif (ValidRefCommand = '1' and (RefIgnore = "000") and RefCheckEn = '1') then
      if ((RefCycles < (unsigned(ExpRefCycles) - 2)) or 
          (RefCycles > (unsigned(ExpRefCycles) + 2))) then
        NextRefErrStat <= '1';
      end if;
  else
    NextRefErrStat <= RefErrStat;
  end if;
end process p_RefErrStatComb; 

p_RefErrStatSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefErrStat <= '0';
  elsif (HCLK'event and HCLK = '1') then
    RefErrStat <= NextRefErrStat;
  end if;
end process p_RefErrStatSeq;

-- ---------------------------------------------------------------------------
-- Expected Refresh Cycles
-- ---------------------------------------------------------------------------
NextExpRefCycles <= DIn(26 downto 11) when WriteSel = '1'
                 else
                    ExpRefCycles;

p_ExpRefCycSeq : process(HCLK, nReset)
begin
  if (nReset = '0') then
    ExpRefCycles <= (others => '0'); 
  elsif (HCLK'event and HCLK = '1') then
    ExpRefCycles <= NextExpRefCycles;
  end if;
end process p_ExpRefCycSeq;

-- ---------------------------------------------------------------------------
-- Refresh Check Enable 
-- ---------------------------------------------------------------------------
p_RefCheckEnComb : process (PhaseRefEn, ValidRefCommand, RefIgnore, RefCheckEn)
begin
  if (PhaseRefEn = '1') then
    NextRefCheckEn <= '1';
  elsif (ValidRefCommand = '1' and (RefIgnore = "000")) then
    NextRefCheckEn <= '0';
  else
    NextRefCheckEn <= RefCheckEn;
  end if;
end process p_RefCheckEnComb; 

p_RefCheckEnSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefCheckEn <= '0';
  elsif (HCLK'event and HCLK = '1') then
    RefCheckEn <= NextRefCheckEn;
  end if;
end process p_RefCheckEnSeq;

-- ---------------------------------------------------------------------------
-- Phase Delayed Refresh Check Enable
-- ---------------------------------------------------------------------------
p_PhaseRefEnComb : process (WriteSel, DIn)
begin
  if (WriteSel = '1') then
    NextPhaseRefEn <= DIn(9);
  else 
    NextPhaseRefEn <= '0';
  end if;
end process p_PhaseRefEnComb;

p_PhaseRefEnSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    PhaseRefEn <= '0';
  elsif (HCLK'event and HCLK = '1') then
    PhaseRefEn <= NextPhaseRefEn;
  end if;
end process p_PhaseRefEnSeq;

-- ---------------------------------------------------------------------------
-- Refresh Ignore 
-- ---------------------------------------------------------------------------
p_RefIgnoreComb : process (PhaseRefEn, ValidRefCommand, RefIgnore)
begin
  if (PhaseRefEn = '1') then
    NextRefIgnore <= "100";
  elsif (ValidRefCommand = '1' and (RefIgnore /= "000")) then
    NextRefIgnore <= unsigned(RefIgnore) - 1;
  else
    NextRefIgnore <= RefIgnore;
  end if;
end process p_RefIgnoreComb; 

-- ---------------------------------------------------------------------------
-- NextRefIgnore value is assigned to RefIgnore at the negative edge of HCLK
-- to provide half a clock preiod for RefErrStat to be set if the difference
-- between RefCycles and ExpRefCycles is more than 2'b10
-- ---------------------------------------------------------------------------
p_RefIgnoreSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefIgnore <= "000";
  elsif (HCLK'event and HCLK = '0') then
    RefIgnore <= NextRefIgnore;
  end if;
end process p_RefIgnoreSeq;

-- ---------------------------------------------------------------------------
-- Mode Register Command 
-- ---------------------------------------------------------------------------
NextModeRegCommand <= (not(nRAS) and not(nCAS) and not(nWE) and not(nCS(0) and
                       nCS(1) and nCS(2) and nCS(3)) and A5)
                           when (iModeBit = '1')
                   else
                      (not(nRAS) and not(nCAS) and not(nWE) and not(nCS(0) and
                        nCS(1) and nCS(2) and nCS(3)));

p_ModeRegComSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    ModeRegCommand <= '0';
  elsif (HCLK'event and HCLK = '1') then
    ModeRegCommand <= NextModeRegCommand;
  end if;
end process p_ModeRegComSeq;

-- ---------------------------------------------------------------------------
-- Mode Register Command Counter
-- ---------------------------------------------------------------------------
NextRegCount <= (others => '0') when (InitCheckEn = '0')
             else
                unsigned(ModeRegCount) + 1 when ModeRegCommand = '1'
             else
                ModeRegCount;

p_ModeRegCntSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    ModeRegCount <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    ModeRegCount <= NextRegCount;
  end if;
end process p_ModeRegCntSeq;

-- ---------------------------------------------------------------------------
-- Mode Register Command Check
-- ---------------------------------------------------------------------------
p_MdeRegChkComb : process (ModeRegCount, ModeRegCommand, ModeRegCheck, A6, 
                           iModeBit, InitCheckEn)

variable  printstr           : string(1 to 255);

begin

  if (InitCheckEn = '0') then
    NextModeRegCheck <= '0';
  elsif ((ModeRegCount = "0000100") and (iModeBit = '0')) then
    NextModeRegCheck <= '1';
  elsif (iModeBit = '1' and ModeRegCommand = '1') then
    if (ModeRegCount = "1000111") then
      NextModeRegCheck <= '1';  
    end if;
    case ModeRegCount is
      when "0000000" | "0010010" | "0100100" | "0110110" =>
        if (A6 = '1') then
          fprint(printstr,"Time: %s: Error! SCLR expected instead of SCCR",
                 to_string(now));
          assert false
          report printstr
          severity Error;
        end if;
      when others => 
        if (A6 = '0') then  
          fprint(printstr,"Time: %s: Error! SCCR expected instead of SCLR",
                 to_string(now));
          assert false
          report printstr
          severity Error;
        end if;
    end case;
  else
    NextModeRegCheck <= ModeRegCheck;
  end if;
end process p_MdeRegChkComb;
 
p_MdeRegChkSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    ModeRegCheck <= '0';
  elsif (HCLK'event and HCLK = '1') then
    ModeRegCheck <= NextModeRegCheck;
  end if;
end process p_MdeRegChkSeq;

-- ---------------------------------------------------------------------------
-- NOP Condition Check
-- ---------------------------------------------------------------------------
NextNOP <= CKE(0) and CKE(1) and CKE(2) and CKE(3) and not(nCS(0)) and
           not(nCS(1)) and not(nCS(2)) and not(nCS(3)) and nRAS and nCAS
           and nWE;

p_NOPSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    NOP <= '0';
  elsif (HCLK'event and HCLK = '1') then
    NOP <= NextNOP;
  end if;
end process p_NOPSeq;

-- ---------------------------------------------------------------------------
-- Initialization Sequence Check StateMachine
-- ---------------------------------------------------------------------------
p_StateSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    PresentState <= "000";
  elsif (HCLK'event and HCLK = '1') then
    PresentState <= NextState;
  end if;
end process p_StateSeq;

-- ---------------------------------------------------------------------------
-- Initialization Sequence Check Status
-- ---------------------------------------------------------------------------
p_PStateComb : process (PresentState, WriteSel, DIn, InitSeqSt, ModeRegCheck)
begin
  if (WriteSel = '1' and DIn(1) = '1') then
    NextInitSeqSt <= '0'; 
  elsif ((PresentState = "100") and ModeRegCheck = '1') then
    NextInitSeqSt <= '1';
  else
    NextInitSeqSt <= InitSeqSt;
  end if;
 end process p_PStateComb;

 p_PStateSeq : process (HCLK, nReset)
 begin
    if (nReset = '0') then
       InitSeqSt <= '0';
    elsif (HCLK'event and HCLK = '1') then
       InitSeqSt <= NextInitSeqSt;
    end if;
 end process p_PStateSeq;

--  ----------------------------------------------------------------------------
--   Next State logic generation
--  ----------------------------------------------------------------------------
p_NStateComb : process (PresentState, NOP, PALL, RefStatus, ModeRegCheck,
                        InitCheckEn, InitSeqSt )

variable printstr : string(1 to 255);

begin
  NextState <= PresentState;
  case PresentState is
  when "000" => if (InitCheckEn = '1') then
                  NextState <= "001";
                end if;
  when "001" => if (NOP = '1') then
                  NextState <= "010";
                end if;
  when "010" => if (PALL = '1') then
                  NextState <= "011";
                elsif (NOP = '1') then
                  fprint(printstr,
                         "Time: %s: Error! NOP Has Been Issued More Than Once",
                         to_string(now));
                  assert false
                  report printstr
                  severity Error;
                end if;
  when "011" => if (PALL = '1') then
                fprint(printstr,
                       "Time: %s: Error! PALL Has Been Issued More Than Once",
                       to_string(now));
                  assert false
                  report printstr
                  severity Error;
                elsif (NOP = '1') then
                fprint(printstr,
                       "Time: %s: Error! NOP Has Been Issued More Than Once",
                       to_string(now));
                  assert false
                  report printstr
                  severity Error;
                elsif (RefStatus = '1') then
                  NextState <= "100";
                end if;
  when "100" => if (PALL = '1') then
                fprint(printstr,
                       "Time: %s: Error! PALL Has Been Issued More Than Once",
                       to_string(now));
                  assert false
                  report printstr
                  severity Error;
                elsif (NOP = '1') then
                fprint(printstr,
                       "Time: %s: Error! NOP Has Been Issued More Than Once",
                       to_string(now));
                  assert false
                  report printstr
                  severity Error;
                elsif (ModeRegCheck = '1') then
                  NextState <= "000";
                end if;
  when others => NextState <= "000";
  end case;
 end process p_NStateComb;
 
-- ---------------------------------------------------------------------------
-- nReset Generation
-- ---------------------------------------------------------------------------
nReset <= HRESETn and nPOR;

-- ---------------------------------------------------------------------------
-- SDRAM Mode Bit
-- ---------------------------------------------------------------------------
NextModeBit <= DIn(2) when WriteSel = '1' 
            else
               iModeBit;
 
p_ModeBitSeq : process (HCLK, nReset)
begin
  if(nReset = '0') then
    iModeBit <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iModeBit <= NextModeBit;
  end if;
end process p_ModeBitSeq;

ModeBit <= iModeBit;

-- ---------------------------------------------------------------------------
-- ExtBusWidth Selection Bit. This bit set to 1 means the External Bus width
-- is 16 and if set to 0, then External Bus width is 32. Bit 27 of the Signal
-- Status Register is used to set this Signal.
-- ---------------------------------------------------------------------------
NextExtBusWidth <= DIn(27) when WriteSel = '1' 
                else
                   iExtBusWidth;
 
p_ExtBusWidthSeq : process (HCLK, nReset)
begin
  if(nReset = '0') then
    iExtBusWidth <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iExtBusWidth <= NextExtBusWidth;
  end if;
end process p_ExtBusWidthSeq;

ExtBusWidth <= iExtBusWidth;

-- ---------------------------------------------------------------------------
-- InitCheckEn bit
-- ---------------------------------------------------------------------------
NextInitCheckEn <= DIn(0) when (WriteSel = '1') 
                else
                   '0'    when (InitSeqSt = '1')
                else
                   InitCheckEn;

p_InitCheckEnSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    InitCheckEn <= '0';
  elsif (HCLK'event and HCLK = '1') then 
    InitCheckEn <= NextInitCheckEn;
  end if;
end process p_InitCheckEnSeq;

-- ---------------------------------------------------------------------------
-- Sensing The Refresh Command and check for the validity of the command
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Refresh Command Generation
-- ---------------------------------------------------------------------------
NextRefCommand <= not(nRAS) and not(nCAS) and nWE and CKE(0) and CKE(1)
                  and CKE(2) and CKE(3) and ((nCS(0) and nCS(1) and 
                  (nCS(2) xor nCS(3))) or (nCS(2) and nCS(3) and (nCS(1) xor 
                   nCS(0))));

p_RefCommandSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefCommand <= '0';
  elsif (HCLK'event and HCLK = '1') then
    RefCommand <= NextRefCommand;
  end if;
end process p_RefCommandSeq;

-- ---------------------------------------------------------------------------
-- Refresh Command Validity Check
-- ---------------------------------------------------------------------------
p_DelayRefCommSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    DelayRefCommand <= '0';
  elsif (HCLK'event and HCLK = '1') then
    DelayRefCommand <= RefCommand;
  end if;
end process p_DelayRefCommSeq;

NextRefWidth <= "100" when (NextRefCommand = '1' and (nCS(3) = '0') and 
                            (RefWidth = "000"))
             else
                "011" when (NextRefCommand = '1' and (nCS(2) = '0') and 
                            (RefWidth = "100"))
             else
                "010" when (NextRefCommand = '1' and (nCS(1) = '0') and
                            (RefWidth = "011"))
             else
                "001" when (NextRefCommand = '1' and (nCS(0) = '0') and
                            (RefWidth = "010"))
             else
                "000" when (RefWidth = "001")
             else
                RefWidth;
                       
p_NREfWidthSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefWidth <= "000";
  elsif (HCLK'event and HCLK = '1') then
    RefWidth <= NextRefWidth;
  end if;
end process p_NREfWidthSeq;

ValidRefCommand <= '1' when ((iModeBit = '0') and (RefCommand = '0') and 
                             (DelayRefCommand = '1') and (RefWidth = "000")) or
                             (iModeBit = '1' and RefWidth = "000")
                else
                   '0'; 

p_ValRefReq : process (HCLK)

variable  printstr           : string(1 to 255);

begin

  if (HCLK'event and HCLK = '1' and RefCommand = '0' and DelayRefCommand = '1'
      and ValidRefCommand = '0' and iModeBit = '0') then
    fprint(printstr, "Time: %s: Warning! Not Valid Refresh Request",
           to_string(now));
    assert false
    report printstr
    severity Warning;
  end if;
end process p_ValRefReq;

-- ---------------------------------------------------------------------------
-- Refresh Command Counter : Enabled only when InitCheckEn bit is On.
-- ---------------------------------------------------------------------------
NextRefCount <= (others => '0')          when (PresentState /= "011") 
             else
                (unsigned(RefCount) + 1) when (ValidRefCommand = '1') 
             else
                RefCount; 

p_RefCountSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefCount <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    RefCount <= NextRefCount;
  end if;
end process p_RefCountSeq;

-- ---------------------------------------------------------------------------
-- No of Refresh Command Check
-- ---------------------------------------------------------------------------

p_NRefStateComb : process (RefCount, RefStatus, PresentState) 
begin
  if (PresentState = "011") then
    if (RefCount(3) = '1') then
      NextRefStatus <= '1';
    else
      NextRefStatus <= '0';
    end if;
  elsif (PresentState /= "011") then
    NextRefStatus <= '0';
  else
    NextRefStatus <= RefStatus;
  end if;
end process p_NRefStateComb;

p_NRefStateSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefStatus <= '0';
  elsif (HCLK'event and HCLK = '1') then
    RefStatus <= NextRefStatus;
  end if;
end process p_NRefStateSeq;

-- ---------------------------------------------------------------------------
-- No of Cycles between two Refresh Command
-- ---------------------------------------------------------------------------
p_RefCycComb : process (ValidRefCommand, RefCycles)
begin
  if (ValidRefCommand = '1') then
    NextRefCycles <= (others => '0');
  else
    NextRefCycles <= unsigned(RefCycles) + 1;
  end if;
end process p_RefCycComb;

p_RefCycSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefCycles <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    RefCycles <= NextRefCycles;
  end if;
end process p_RefCycSeq;

-- ---------------------------------------------------------------------------
-- PALL Check
-- ---------------------------------------------------------------------------
NextPALL <= not(nRAS) and not(nCAS) and not(nWE) and A10 and not(A5)
                   when iModeBit = '1' 
         else
            not(nRAS) and nCAS and not(nWE) and A10;

p_PALLSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    PALL <= '0';
  elsif (HCLK'event and HCLK = '1') then
    PALL <= NextPALL;
  end if;
end process p_PALLSeq;

-- ---------------------------------------------------------------------------
-- SREF Check
-- ---------------------------------------------------------------------------
NextSREF <= not(nRAS) and not(nCAS) and nWE and not(CKE(0)) and not(CKE(1))
            and not(CKE(2)) and not(CKE(3)) and not(nCS(0)) and not(nCS(1))
            and not(nCS(2)) and not(nCS(3));

p_SREFSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    SREF <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SREF <= NextSREF;
  end if;
end process p_SREFSeq;

-- ---------------------------------------------------------------------------
-- Data Output on ReadSel. Removed the qualification of HCLK with ReadSel 
-- for transfering the DataReg to DOut in the case of AHB. 
-- ---------------------------------------------------------------------------
DOut <= DataReg when (ReadSel = '1' )
     else
        (others => '0');

-- ---------------------------------------------------------------------------
-- Data Register
-- ---------------------------------------------------------------------------
NextDataReg <= "00000" & ExpRefCycles & RefErrStat &  RefCheckEn & CKE & A10 &
                SREF & iModeBit & InitSeqSt & InitCheckEn;

p_DataRegSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    DataReg <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    DataReg <= NextDataReg;
  end if;
end process p_DataRegSeq;

end behavioural;

-- ==================================== End ==================================--
