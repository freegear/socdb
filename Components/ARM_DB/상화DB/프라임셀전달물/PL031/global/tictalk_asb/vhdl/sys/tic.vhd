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
-- File Name              : tic.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v2
--
-- ---------------------------------------------------------------------
-- Purpose : Test Interface Controller for an AMBA system
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;

library common ;
use     common.params.all ;

entity TIC is
  port(
       -- AMBA input signals
       AGNTtic       : in    std_ulogic;
       BCLK          : in    std_ulogic;
       BD            : in    std_logic_vector(31 downto 0) ;
       BnRES         : in    std_ulogic;
       BWAIT         : in    std_logic;
       BERROR        : in    std_logic;
       BLAST         : in    std_logic;

       -- AMBA output signals
       AREQtic       : out   std_ulogic;
       BTRAN         : out   std_logic_vector(1 downto 0);
       BA            : out   std_logic_vector(31 downto 0) ;
       BWRITE        : out   std_logic;
       BSIZE         : out   std_logic_vector(1 downto 0);
       BPROT         : out   std_logic_vector(1 downto 0);
       BLOK          : out   std_logic;

       -- External test port interface 
       TREQA         : in    std_ulogic;  -- Test Request A
       TREQB         : in    std_ulogic;  -- Test Request B
       TACK          : out   std_ulogic;  -- Test Acknowledge
         
       -- Output signals to control the data path of the
       -- memory interface
       TestMode      : out  std_ulogic;   -- Overide normal operation
       TicoutLen     : out  std_ulogic;   -- Latch read data
       Ticouten      : out  std_ulogic;   -- Drive out read data
       Ticinen       : out  std_ulogic    -- Drive in write data
       );
end TIC ;


------------------------------------------------------------------------
-- The TIC consists of four main blocks:
--   Test Vector State Machine - Uses the TREQA and TREQB signals
--     to decide which type of vector is being applied on the 
--     external TBUS.
--   Address and Control Registers - Holds values for the address
--     and control signals and includes an address incrementer for
--     burst accesses.
--   External Memory Interface - Generates the four control signals
--     which interface to the external memory interface.
--   AMBA Bus Master Interface - Includes the AMBA bus master
--     state machine and the tri-state control of the AMBA
--     bus signals.
------------------------------------------------------------------------

architecture synth of tic is

type t_mstate is (IDLE, BUSIDLE, HOLD, HANDOVER, ACTIVE, RETRACT);
type t_vec    is (IDLE, START, ADDRVEC, WRITEVEC, READVEC, TURNAROUND);


-- Signal Definitions
-- Aliases for output signals
signal AREQtici                                 : std_ulogic;
signal BTRANi                                   : std_logic_vector
                                                          (1 downto 0);
signal BAi                                      : std_logic_vector
                                                         (31 downto 0) ;
signal BWRITEi                                  : std_logic;
signal BSIZEi                                   : std_logic_vector
                                                          (1 downto 0);
signal BPROTi                                   : std_logic_vector
                                                          (1 downto 0);
signal BLOKi                                    : std_logic;
signal TACKi                                    : std_ulogic;
signal TestModei, TicoutLeni                    : std_ulogic;
signal Ticouteni, Ticineni                      : std_ulogic;

--   Test Vector State Machine 
signal SyncTREQA, SyncTREQB                     : std_ulogic;
signal RequestBus                               : std_ulogic;
signal LastVector, CurrentVector, NextVector    : t_vec;

--   Address and Control Registers
signal ControlVector                            : std_ulogic;
signal Incrm, Overflow, IncrmReg                : std_ulogic;
signal SeqOnly, SeqOnlyReg                      : std_ulogic;
signal PROTint, SIZEint, PROTintReg, SIZEintReg : std_logic_vector
                                                          (1 downto 0);
signal LOKint, LOKintReg                        : std_logic;
signal WRITEint, WRITEintReg                    : std_logic;
signal AintReg, Aint, IncAddr                   : std_logic_vector
                                                          (31 downto 0);
signal IncFull                                  : std_logic_vector
                                                          (7 downto 0);

--   External Memory Interface

--   AMBA Bus Master Interface
signal TICTran, TRANint                         : std_logic_vector
                                                          (1 downto 0);
signal CurrentMasterState, NextMasterState      : t_mstate;
signal LBWAIT, LBERROR, LBLAST                  : std_logic;
signal LBWRITE                                  : std_logic;
signal GrantedD2                                : std_ulogic;
signal Granted, DelayedGranted                  : std_ulogic;
signal NtranStart, DatabusEnable                : std_ulogic;



begin

------------------------------------------------------------------------
-- Propogation of internal signals onto outputs
-- Within this design all outputs are generated internally and then 
-- assigned to an output pin. The internal signal is named with an 'i' 
-- at the end of the signal name, so in general it can be assumed that
-- signali == signal.
-- This allows realistic times delays to be added to all outputs at 
-- just one point in the code and also aids making the VHDL and Verilog
-- source look similar.
------------------------------------------------------------------------

  AREQtic   <= AREQtici   after DLPG;
  BTRAN     <= BTRANi     after BUSE;
  BA        <= BAi        after BUSE;
  BWRITE    <= BWRITEi    after BUSE;
  BSIZE     <= BSIZEi     after BUSE;
  BPROT     <= BPROTi     after BUSE;
  BLOK      <= BLOKi      after BUSE;
  TACK      <= TACKi      after GAT3;
  TestMode  <= TestModei  after DLPG;
  TicoutLen <= TicoutLeni after GAT3;
  Ticouten  <= Ticouteni  after DLPG;
  Ticinen   <= Ticineni   after GAT3;

------------------------------------------------------------------------
-- TIC Vector State Machine
-- This state machine tracks which type of test vector is being applied
-- according to the TREQA and TREQB signals. When in test mode TREQA 
-- and TREQB are only considered valid when TACK is HIGH.
------------------------------------------------------------------------

  -- Synchronisation of TREQA and TREQB prior to entering test
  -- This allows a switch from an internal clock to an external
  -- test clock prior to test. Once test is entered the system 
  -- clock should be switched to TCLK, hence TREQA and TREQ will 
  -- be synchronous.

  treq_sync : process (BCLK)
  begin
    if (BCLK'event and BCLK = '0') then
      SyncTREQA <= TREQA;
      SyncTREQB <= TREQB;
    end if;
  end process;


  vector_sm_reg : process(BCLK, BnRES)
  begin 
    if (BnRES = '0') then 
      CurrentVector <= IDLE; 
    elsif (BCLK'event and BCLK = '0') then -- Falling edge state machine
      CurrentVector <= NextVector;   
    end if;
  end process;


  vector_sm_comb : process(CurrentVector, SyncTREQA, SyncTREQB, TREQA, 
                           TREQB, TACKi)
  begin 
    case CurrentVector is 
      when IDLE => 
        if (SyncTREQA = '1' and SyncTREQB = '0') then
          -- If any clock switching is required, then the signal 
          -- that indicates that the clock switch has occured should
          -- be used as an extra condition to move to START
          NextVector <= START;  -- Move to start using synced TREQA/B
        else 
          NextVector <= IDLE;
        end if; 

      when START => 
        if (TACKi = '0') then                 -- Remain in START until
          NextVector <= START;                -- granted on the bus
        elsif (TREQA = '1' and TREQB = '1') then
          NextVector <= ADDRVEC;              -- Wait for Address vector
        else 
          NextVector <= START;
        end if; 

      when ADDRVEC => 
        if (TACKi = '0') then
          NextVector <= ADDRVEC;
        elsif (TREQA = '1' and TREQB = '1') then
          NextVector <= ADDRVEC;
        elsif (TREQA = '1' and TREQB = '0') then
          NextVector <= WRITEVEC;
        elsif (TREQA = '0' and TREQB = '1') then
          NextVector <= READVEC;
        else                                  -- TREQA = '0' and 
                                              -- TREQB = '0'
          NextVector <= IDLE;                 -- Exit from test 
        end if; 

      when WRITEVEC => 
        if (TACKi = '0') then
          NextVector <= WRITEVEC;
        elsif (TREQA = '0' and TREQB = '1') then
          NextVector <= READVEC;
        elsif (TREQA = '1' and TREQB = '0') then
          NextVector <= WRITEVEC;
        else 
          NextVector <= ADDRVEC;
        end if; 

      when READVEC => 
        if (TACKi = '0') then
          NextVector <= READVEC;
        elsif (TREQA = '0' and TREQB = '1') then
          NextVector <= READVEC;
        else                                 -- Cannot go directly from 
          NextVector <= TURNAROUND;          -- read to write.
        end if; 

      when TURNAROUND => 
        if (TACKi = '0') then
          NextVector <= TURNAROUND;
        elsif (TREQA = '0' and TREQB = '1') then
          NextVector <= READVEC;
        elsif (TREQA = '1' and TREQB = '0') then
          NextVector <= WRITEVEC;
        else 
          NextVector <= ADDRVEC;
        end if; 

      when others =>                         --  others will be never 
                                             --  reached
          NextVector <= IDLE;

    end case; 
  end process; 

   -- LastVector is needed to detect control vectors
   -- A vector is only consider to be applied when TACK is high

  lastvector_sm_reg : process(BCLK, BnRES)
  begin 
    if (BnRES = '0') then 
      LastVector <= IDLE; 
    elsif (BCLK'event and BCLK = '0') then
      if (TACKi = '1') then
        LastVector <= CurrentVector;  
      end if;
    end if;
  end process;

  -- Request access to the bus once the START vector state is entered
  -- and keep requesting access until the IDLE state is re-entered at 
  -- the end of the test. The TIC does not back off the bus for address
  -- vectors as the data bus is used to move the address from the 
  -- external memory interface into the TIC address registers.

  RequestBus_comb : process (CurrentVector)
  begin
    if (CurrentVector = IDLE) then
      RequestBus   <= '0';
    else
      RequestBus   <= '1';
    end if;
  end process;

  -- RequestBus must be re-timed to generate the AMBA request signal  

  areq_reg : process (BCLK)
  begin
    if (BCLK'event and BCLK = '1') then
      AREQtici <= RequestBus;
    end if;
  end process;

  -- TACK is always LOW unless the TIC is granted on the bus,
  -- in which case the BWAIT signal is used to generate TACK.
  -- Using 'CurrentMasterState' ensures the test interface is
  -- waited in the case of a Retract from a slave.

  -- If the TIC requires more than one cycle for an Address
  -- vector to propagate through the pads, through the external
  -- memory interface and be setup to the address/control 
  -- registers then the TACK signal can be modified to signal
  -- that the current cycle has not completed and an additional
  -- cycle of address vector is required.

  tack_comb : process (CurrentMasterState, LBWAIT)
  begin
    if (CurrentMasterState = ACTIVE) then
      TACKi <= not LBWAIT;
    else
      TACKi <= '0';
    end if;
  end process;


------------------------------------------------------------------------
-- Address and Control Registers 
------------------------------------------------------------------------
-- The Address and Control Registers hold values for the address
-- and control signals that are to be used for the bus transfers.
------------------------------------------------------------------------
-- Both the address and control registers are constructed using a 
-- falling edge D-type to hold the address/control values, but also 
-- include a transparent latch to allow the adddres/control information
-- to propogate onto the bus during the address/control vector.
-- This structure is used to avoid the critical 
-- path from BWAIT -> LBWAIT -> TACK -> NextVector -> ControlVector
-- 
-- If the system is only to be used at low clock frequencies then it
-- is possible to replace the latch/reg structure with a single rising
-- edge D-type. 
------------------------------------------------------------------------

  -- Control vector detection
  -- Used to distinguish between address vectors and control vectors.

  controlvec : process (LastVector, CurrentVector, NextVector)
  begin
      if (LastVector = ADDRVEC and CurrentVector = ADDRVEC 
      and (NextVector = READVEC or NextVector = WRITEVEC)) then
          ControlVector <= '1';
      else
          ControlVector <= '0';
     end if;
   end process;


   control_lat : process (BnRES, BCLK, ControlVector, BD, IncrmReg,
                          PROTintReg, LOKintReg, SIZEintReg, 
                          SeqOnlyReg) 
   begin
     if (BnRES = '0') then
       Incrm   <= '0' ;
       PROTint <= "11";
       LOKint  <= '0' ;
       SIZEint <= "10";
       SeqOnly <= '0';
     elsif (BCLK = '1') then
       if (ControlVector = '1') then
         if (BD(0) = '1') then               -- Check it is valid
           SeqOnly <= BD(8);
           Incrm   <= BD(7);
           PROTint <= BD(6 downto 5);
           LOKint  <= BD(4);
           SIZEint <= BD(3 downto 2);
         else
           SeqOnly <= SeqOnlyReg;
           Incrm   <= IncrmReg;
           PROTint <= PROTintReg;
           LOKint  <= LOKintReg;
           SIZEint <= SIZEintReg;
         end if;
       end if;
     end if;
   end process;

   control_reg : process (BCLK)
   begin
      if (BCLK'event and BCLK = '0') then
           IncrmReg   <= Incrm;
           PROTintReg <= PROTint;
           LOKintReg  <= LOKint;
           SIZEintReg <= SIZEint;
           SeqOnlyReg <= SeqOnly;
      end if;
   end process;

   -- The write signal is generated from the vector type.
   -- A latch/register combination is required to ensure
   -- the write remains glitch free throughout the transfer.

   write_lat : process (BnRES, BCLK, LBWAIT, NextVector, WRITEintReg)
   begin
     if (BnRES = '0') then
       WRITEint   <= '0';
     elsif (BCLK = '1') then
       if (LBWAIT = '0' and NextVector = WRITEVEC) then
         WRITEint <= '1';
       elsif (LBWAIT = '0' and NextVector = READVEC) then
         WRITEint <= '0';
       else
         WRITEint <= WRITEintReg;
       end if;
     end if;
    end process;

   write_reg : process (BCLK)         
   begin
      if (BCLK'event and BCLK = '0') then
           WRITEintReg  <= WRITEint;
      end if;
   end process;

  -- There are three different possible sources of address:-
  --     BD      - New address vector from the data bus.
  --               Used when an address vector occurs (which 
  --               is not a control vector).
  --     IncAddr - Incremented address for burst transfers
  --               Used for a read which is completeing and 
  --               is followed by either another read or a  
  --               turnaround vector (which is every case for a read).
  --               and a write which is completeing and is followed 
  --               by either another write or a read.
  --     AintReg - Hold current value.
  --               Used for all other cases.

  addressreg_sel : process (BnRES, BCLK, BD, IncAddr, AintReg,
                            ControlVector, CurrentVector, NextVector,
                            CurrentMasterState, LBWAIT, Incrm) 
                                                     -- Address control
   begin                                
     if (BnRES = '0') then
          Aint    <= (others=>'0');      
     elsif (BCLK = '1') then
      if (ControlVector = '1') then
          Aint    <= AintReg;
      elsif (CurrentVector = ADDRVEC) then    -- Address and not control
          Aint    <= BD;
      elsif (CurrentVector = READVEC) then
        if (CurrentMasterState = ACTIVE and LBWAIT = '0' and 
                                                      Incrm = '1') then
          Aint    <= IncAddr;
        else
          Aint    <= AintReg;
        end if;
      elsif (CurrentVector = WRITEVEC) then
        if ((CurrentMasterState = ACTIVE and LBWAIT = '0' and 
                                                      Incrm = '1') and
            (NextVector = READVEC or NextVector = WriteVec)) then
          Aint    <= IncAddr;
        else
          Aint    <= AintReg;
        end if;
      else
          Aint    <= AintReg;
      end if;
    end if;
  end process; 

   -- The address register is used to hold the value which has been 
   -- driven onto the bus in the HIGH phase of BCLK.

   address_reg : process (BCLK)
   begin
      if (BCLK'event and BCLK = '0') then
           AintReg   <= Aint;
      end if;
   end process;

------------------------------------------------------------------------
-- Address Incrementer
-- This section is the TIC address incrementer.
-- When the incrementer overflows it simply wraps around to the original
-- value. The number of bits in the address incrementor could be 
-- variable, but the recommended size is 8 bits, allowing word bursts 
-- upto 1 kbyte boundaries
------------------------------------------------------------------------

Increment: process (AintReg,SIZEint)
begin
  -- Byte increment
  if (SIZEInt = "00") then
      IncAddr( 7 downto 0) <= AintReg( 7 downto 0) + "1"; 
      IncAddr(31 downto 8) <= AintReg(31 downto 8);

  -- Halfword increment
  elsif (SIZEInt = "01") then
      IncAddr(0)           <= AintReg(0);
      IncAddr( 8 downto 1) <= AintReg( 8 downto 1) + "1"; 
      IncAddr(31 downto 9) <= AintReg(31 downto 9);

  -- Word increment
  else
      IncAddr( 1 downto 0)  <= AintReg( 1 downto 0);
      IncAddr( 9 downto 2)  <= AintReg( 9 downto 2) + "1"; 
      IncAddr(31 downto 10) <= AintReg(31 downto 10);
  end if;
end process;

-- Overflow detect. When the incrementer overflows the next transfer 
-- must be signalled as Non-sequential.

IncFull      <= (others=>'1');       --# set constant to all 1's

IncremOverflow: process(AintReg, SIZEint, IncFull)
begin
  if ((SIZEint = "00" and (AintReg(7 downto 0) = IncFull))  or 
      (SIZEint = "01" and (AintReg(8 downto 1) = IncFull))  or 
      (SIZEint = "10" and (AintReg(9 downto 2) = IncFull))) then 
    Overflow <='1';
  else
    Overflow <='0';
  end if;
end process;


------------------------------------------------------------------------
-- External Bus Interface Control
-- This section generates the four signals (TestMode, TicoutLen, 
--                                          Ticouten, Ticinen) that 
-- control the external bus interface when it is being used
-- for TIC testing.
--       TestMode  - Overide normal operation
--       TicoutLen - Latch read data, active LOW.
--       Ticouten  - Drive out read data (from BD to TBUS), active LOW.
--       Ticinen   - Drice in write data (from TBUS to BD), active LOW.
------------------------------------------------------------------------


  -- Test Mode Generation signal
  -- The TestMode signal indicates that the test interface 
  -- believes that it is in the process of testing the system. If the
  -- TIC does lose mastership of the bus then TestMode will remain 
  -- asserted as the external tester may still be driving on to the 
  -- TBUS and it is import that the external bus interface does not 
  -- switch back to normal operation.
  -- TestMode is entered when the TIC is granted the bus

  testmode_sm_reg : process(BCLK, BnRES)
  begin 
    if (BnRES = '0') then
      TestModei <=  '0';
    elsif (BCLK'event and BCLK = '0') then  -- falling edge triggered
      if (TestModei = '0' and RequestBus = '1' and Granted = '1') then
         TestModei <= '1';          -- Enter TestMode
      elsif (TestModei = '1' and NextVector = IDLE) then
         TestModei <= '0';          -- Exit TestMode
      end if;
   end if;
  end process;

  -- Ticouten is active low and controls whent the external memory
  -- interface drives read data from the internal BD bus out on to 
  -- the external TBUS. Data is driven out from the rising edge of BCLK
  -- in the read cycle and remains driven past the end of the transfer
  -- until the rising edge of clock after the transfer has completed.
  -- A read or burst of reads will always be followed by a Turnaround
  -- vector, which prevents bus clash on the external TBUS.

  tbdrive : process (BCLK, BnRES)
  begin
    if (BnRES = '0') then
      Ticouteni <= '1';
    elsif (BCLK'event and BCLK = '1') then
      if (CurrentVector = READVEC) then
        Ticouteni <= '0';
      else
        Ticouteni <= '1';
      end if;      
    end if;      
  end process;


  -- TicoutLen changes after the falling edge of BCLK, as it 
  -- follows the Vector state machine. TicoutLen can glitch
  -- after the falling egde of BCLK, but must be valid before
  -- the rising egde.

  ReadDataLatchEnable: process (BnRES, CurrentVector)
  begin
    if (BnRES = '0') then
      TicoutLeni <= '1';
    elsif (CurrentVector = READVEC) then
      Ticoutleni <= '0';            -- open output latches on reads
    else
      TicoutLeni <= '1';
    end if;
  end process;

 
  -- The TicinEn signal is an active LOW signal that enables the 
  -- tri-state bufffers within the external bus interface, so that 
  -- they can drive from the external TBUS onto the internal BD data 
  -- bus. This signal must go active in two cases, when an Address 
  -- Vector is being applied and when a Write Vector is being applied. 

  -- It is important that the data bus is not driven when the TIC is not
  -- the bus master, so the 'CurrentMasterState' is used to confirm
  -- that the TIC currently owns the bus.
  -- For the Address Vector the data bus is driven throughout the entire
  -- clock cycle. Data bus clash will not occur as every read cycle is 
  -- followed by a Turnaround vector. In the case when bus master 
  -- handover occurs data bus clash is avoided as the data bus is only 
  -- driven in the ACTIVE state.
  -- For Write vectors the TIC must obey the AMBA specification and 
  -- therefore the DatabusEnable signal from the AMBA interface section
  -- is used to generate TicinEn

  bddrive : process (BnRES, DatabusEnable, CurrentVector, 
                     CurrentMasterState)
  begin
    if (BnRES = '0') then
      TicinEni <= '1';
    elsif (CurrentMasterState = ACTIVE) then
      if (CurrentVector = ADDRVEC) then
        TicinEni <= '0';
      elsif (CurrentVector = WRITEVEC) then
        TicinEni <= not DatabusEnable;
      else 
        TicinEni <= '1';
      end if;
    else
      TicinEni <= '1';
    end if;
  end process;

------------------------------------------------------------------------
-- AMBA Bus Interface 
-- The AMBA bus interface comprises the following sections:
--   Transfer Type (BTRAN) generation
--   Address and Control Tri-state buffers
--   Data tri-state buffer control
--   Main bus master state machine
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Transfer Type (BTRAN) generation
------------------------------------------------------------------------

  -- TICTran indicates the transfer type that the TIC would 
  -- perform if it was always granted the bus.

  -- Only indicate sequential when an incremented address is going to 
  -- be used. The cases when an incremented address are used are:-
  --  o A read which is followed by either another read 
  --  o A write which is followed by either another write

  -- Do not need to worry if the TIC has lost mastership of the bus
  -- because the HANDOVER state will ensure that the address is 
  -- rebroadcast onto the bus before the transfer.

  TICTran_gen: process (CurrentVector, NextVector, Incrm, Overflow, 
                        SeqOnly)
  begin
    if (NextVector = READVEC) then
      if (CurrentVector = READVEC and Incrm = '1' and OverFlow = '0') 
                                                                    then
        TICTran <= "11";                    -- S-TRAN
      else
        TICTran <= '1' & SeqOnly;           -- N-TRAN or S-TRAN
      end if;
    elsif (NextVector = WRITEVEC) then
      if (CurrentVector = WRITEVEC and Incrm = '1' and OverFlow = '0') 
                                                                    then
        TICTran <= "11";                    -- S-TRAN
      else
        TICTran <= '1' & SeqOnly;           -- N-TRAN or S-TRAN
      end if;
    else            -- NextVector = TURNAROUND, ADDRVEC, START or IDLE
      TICTran <= "00";                      -- A-TRAN
    end if;
  end process;


  BTran_gen: process (CurrentMasterState, TICTran)
  begin
    if (CurrentMasterState = ACTIVE or CurrentMasterState = BUSIDLE or 
        CurrentMasterState = HANDOVER) then
        TRANint <= TICTran;
    else
        TRANint <= "00";                      -- A-TRAN
    end if;
  end process;

  tritran : process (AGNTtic, BCLK, TRANint) 
  begin 
  if (AGNTtic = '1' and BCLK = '1') then    -- test mode, drive signals
      BTRANi <= TRANint ;
    else
      BTRANi <= "ZZ" ;
    end if;
  end process;


------------------------------------------------------------------------
-- Address and Control Tri-state buffers
------------------------------------------------------------------------

  delay_gnt : process (BCLK)
  begin
    if (BCLK'event and BCLK = '0') then
      DelayedGranted <= Granted ;              -- to detect turnaround 
                                               -- phase for BA
    end if;
  end process;

  triaddr : process (Granted, DelayedGranted, 
                     Aint, SIZEint, PROTint, WRITEint, LOKint)
  begin
    if (Granted = '1' and DelayedGranted = '1') then   -- test mode, 
                                                       -- drive signals
      BAi     <= Aint     ;            -- avoiding first clock phase
      BSIZEi  <= SIZEint  ;            -- after AGNT
      BPROTi  <= PROTint  ; 
      BWRITEi <= WRITEint ;
      BLOKi   <= LOKint   ;
    else                               -- not test mode, tristate all
      BAi     <= (others => 'Z') ;
      BSIZEi  <= "ZZ"            ;
      BPROTi  <= "ZZ"            ;
      BWRITEi <= 'Z'             ;
      BLOKi   <= 'Z'             ;
    end if;
  end process;

------------------------------------------------------------------------
-- Data tri-state buffer control
------------------------------------------------------------------------

  -- Data bus is driven during the ACTIVE state of write vectors, 
  -- except for the first BCLK LOW phase of Non-sequential transfers. 
  -- NtranStart will go HIGH for the first phase of Non-sequential write
  -- transfers.

  Ntran_detect : process (BCLK, LBWAIT, TRANInt, WRITEint)
  begin
    if (BCLK = '1') then
      if (LBWAIT = '0' and TRANInt = "10" and WRITEint = '1') then
        NtranStart <= '1';
      else
        NtranStart <= '0';
      end if;
    end if;
  end process;

  DatabusEnable_comb : process (BCLK, CurrentMasterState, 
                                CurrentVector, NtranStart)
  begin
    if ((CurrentMasterState = ACTIVE) and (CurrentVector = WRITEVEC) 
        and (BCLK = '1' or NtranStart = '0')) then
      DatabusEnable <= '1';
    else
      DatabusEnable <= '0';
    end if;
  end process;


------------------------------------------------------------------------
-- Main bus master state machine
------------------------------------------------------------------------
   
  slave_latch : process(BCLK, BWAIT, BLAST, BERROR)
  begin 
    if (BCLK = '0') then
      LBWAIT  <= BWAIT ;                 -- latch slave responses
      LBLAST  <= BLAST ;
      LBERROR <= BERROR ;
    end if; 
  end process;

  -- The granted state machine defaults to not granted during reset, 
  -- but this output may be overridden in the case when the TIC ends up
  -- being the default bus master during reset.

  granted_sm : process(BCLK, BnRES)
  begin 
    if (BnRES = '0') then                
      GrantedD2  <= '0' ;               -- Default to TIC not Granted 
    elsif (BCLK'event and BCLK = '1') then      
      GrantedD2 <= (((not BWAIT) and AGNTtic) or    
                 (Granted and BWAIT)) ;   -- wait cycle no change
    end if; 
  end process; 

  -- Override during reset.
  granted_comb : process(BnRES, GrantedD2, AGNTtic)
  begin 
    if (BnRES = '0' and AGNTtic = '1') then   -- system with TIC default
      Granted <= '1' ; 
    else
      Granted <= GrantedD2 ;
   end if;
  end process; 

  -- Usually the bus master state machine would have two reset states,
  -- but the TIC does not differentiate between IDLE and BUSIDLE and 
  -- driving of Address/Control is generated directly from Granted, 
  -- so a single reset state can be used. 

  master_sm_reg : process(BCLK, BnRES)
  begin 
    if (BnRES = '0') then  
      CurrentMasterState <= IDLE; 
    elsif (BCLK'event and BCLK = '0') then 
      CurrentMasterState <= NextMasterState ; 
    end if; 
  end process;


  master_sm_comb : process(CurrentMasterState, Granted, RequestBus, 
                           LBWAIT, LBLAST, LBERROR)

  begin 
    case CurrentMasterState is 
      when IDLE => 
        if (Granted and (not RequestBus)) = '1' then 
          NextMasterState <= BUSIDLE; 
        elsif (Granted and RequestBus) = '1' then 
          NextMasterState <= HANDOVER; 
        elsif ((not Granted) and RequestBus) = '1' then 
          NextMasterState <= HOLD; 
        else 
          NextMasterState <= IDLE;   -- not GRANTED and not RequestBus
        end if; 

      when BUSIDLE  => 
        if ((not Granted) and (not RequestBus)) = '1' then 
          NextMasterState <= IDLE; 
        elsif (Granted and RequestBus) = '1' then 
          NextMasterState <= ACTIVE; 
        elsif ((not Granted) and RequestBus) = '1' then 
          NextMasterState <= HOLD; 
        else
          NextMasterState <= BUSIDLE;   -- GRANTED and not RequestBus
        end if; 

      when HOLD => 
        if (Granted) = '1' then 
          NextMasterState <= HANDOVER; 
        else               
          NextMasterState <= HOLD;      -- not GRANTED
        end if;

      when HANDOVER => 
        if (Granted) = '1' then 
          NextMasterState <= ACTIVE;
        else
          NextMasterState <= HOLD;      -- not GRANTED
        end if; 

      when ACTIVE => 
        if ((Granted and LBWAIT and LBLAST and LBERROR) = '1') then 
          NextMasterState <= RETRACT; 
        elsif ((Granted and LBWAIT) = '1') then 
          NextMasterState <= ACTIVE; 
        elsif ((Granted and RequestBus) = '1') then 
          NextMasterState <= ACTIVE; 
        elsif (Granted = '1') then 
          NextMasterState <= BUSIDLE; 
        elsif ((not Granted) and RequestBus) = '1' then 
          NextMasterState <= HOLD; 
        else 
          NextMasterState <= IDLE;      -- not GRANTED
        end if; 

      when RETRACT => 
        if (GRANTED) = '1' then 
          NextMasterState <= HANDOVER; 
        else                
          NextMasterState <= HOLD;      -- not GRANTED
        end if; 

      when others =>                 --  others will be never reached
          NextMasterState <= CurrentMasterState; 
    end case; 
  end process; 

end synth;

-- --============================== End ==============================--
