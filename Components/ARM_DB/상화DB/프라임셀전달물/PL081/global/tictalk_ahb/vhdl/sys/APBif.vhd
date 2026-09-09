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
-- File Name              : APBif.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Converts AHB peripheral transfers to APB transfers
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

entity APBif is
  port(
    HCLK      : in  std_logic;
    HRESETn   : in  std_logic;
    HADDR     : in  std_logic_vector(31 downto 0);
    HTRANS    : in  std_logic_vector(1 downto 0);
    HWRITE    : in  std_logic;
    HWDATA    : in  std_logic_vector(31 downto 0);
    HSELAPBif : in  std_logic;
    HREADYin  : in  std_logic;

    HRDATA    : out std_logic_vector(31 downto 0);
    HREADYout : out std_logic;
    HRESP     : out std_logic_vector(1 downto 0);

    PRDATA    : in  std_logic_vector(31 downto 0);

    PWDATA    : out std_logic_vector(31 downto 0);
    PENABLE   : out std_logic;
    PSELIC    : out std_logic; -- APB Interrupt Controller
    PSELUUT   : out std_logic; -- APB Unit Under Test
    PSELRPC   : out std_logic; -- Remap and Pause
    PADDR     : out std_logic_vector(31 downto 0);
    PWRITE    : out std_logic
    );
end APBif;

architecture synth of APBif is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- This constant defines the size of the peripheral address bus:
  constant PADDRWIDTH : integer  := 16;

-- APBIF states:
--  ST_IDLE     is APB bus idle state entered on reset
--  ST_READ     is read setup
--  ST_RENABLE  is read enable
--  ST_WWAIT    is write wait state
--  ST_WRITE    is write setup
--  ST_WENABLE  is write enable
--  ST_WRITEP   is write setup with pending transfer
--  ST_WENABLEP is write enable with pending transfer
  constant ST_IDLE     : std_logic_vector(3 downto 0) := "0000";
  constant ST_READ     : std_logic_vector(3 downto 0) := "0001";
  constant ST_RENABLE  : std_logic_vector(3 downto 0) := "0100";
  constant ST_WWAIT    : std_logic_vector(3 downto 0) := "1001";
  constant ST_WRITE    : std_logic_vector(3 downto 0) := "1010";
  constant ST_WENABLE  : std_logic_vector(3 downto 0) := "1110";
  constant ST_WRITEP   : std_logic_vector(3 downto 0) := "1011";
  constant ST_WENABLEP : std_logic_vector(3 downto 0) := "1111";

-- EASY Peripherals address decoding values:
-- Interrupt Controller - 0x80000000 to 0x83FFFFFF
-- APB UUT              - 0x84000000 to 0x87FFFFFF
-- Remap & Pause        - 0x88000000 to 0x8BFFFFFF
  constant ICBASE     : std_logic_vector(29 downto 26) := "0000";
  constant UUTBASE    : std_logic_vector(29 downto 26) := "0001";
  constant RPCBASE    : std_logic_vector(29 downto 26) := "0010";

-- HTRANS transfer type signal encoding
  constant TRN_IDLE   : std_logic_vector(1 downto 0) := "00";
  constant TRN_BUSY   : std_logic_vector(1 downto 0) := "01";
  constant TRN_NONSEQ : std_logic_vector(1 downto 0) := "10";
  constant TRN_SEQ    : std_logic_vector(1 downto 0) := "11";

-- HRESP transfer response signal encoding
  constant RSP_OKAY  : std_logic_vector(1 downto 0) := "00";
  constant RSP_ERROR : std_logic_vector(1 downto 0) := "01";
  constant RSP_RETRY : std_logic_vector(1 downto 0) := "10";
  constant RSP_SPLIT : std_logic_vector(1 downto 0) := "11";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
  signal Valid        : std_logic; -- Module is selected with valid
                                   -- transfer
  signal ACRegEn      : std_logic; -- Enable for address and control
                                   -- registers
  signal HaddrReg     : std_logic_vector(31 downto 0);
                                   -- HADDR register
  signal HwriteReg    : std_logic; -- HWRITE register
  signal HaddrMux     : std_logic_vector(31 downto 0);
                                   -- HADDR multiplexer

  signal NextState    : std_logic_vector(3 downto 0);
                                   -- State machine
  signal CurrentState : std_logic_vector(3 downto 0);

  signal HreadyNext   : std_logic; -- HREADYout register input
  signal iHREADYout   : std_logic; -- HREADYout register

  signal PselICInt    : std_logic; -- Internal PSELIC
  signal PselUUTInt   : std_logic; -- Internal PSELUUT
  signal PselRPCInt   : std_logic; -- Internal PSELRPC

  signal APBEn        : std_logic; -- Enable for APB output registers

  signal PWDATAEn     : std_logic; -- PWDATA Register enable
  signal PenableNext  : std_logic; -- PENABLE register input
  signal PselICMux    : std_logic; -- PSEL multiplexer values
  signal PselUUTMux   : std_logic;
  signal PselRPCMux   : std_logic;
  signal iPSELIC      : std_logic; -- Internal PSEL outputs
  signal iPSELUUT     : std_logic;
  signal iPSELRPC     : std_logic;
  signal iPADDR       : std_logic_vector(PADDRWIDTH - 1 downto 0);
                                   -- Registered internal PADDR
  signal PwriteNext   : std_logic; -- PWRITE register input

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
begin

-- ---------------------------------------------------------------------
-- Valid transfer detection
-- ---------------------------------------------------------------------
-- Valid AHB transfers only take place when a non-sequential or
-- sequential transfer is shown on HTRANS - an idle or busy transfer
-- should be ignored.

  Valid <= '1' when (HSELAPBif = '1' and HREADYin = '1' and
                     (HTRANS = TRN_NONSEQ or HTRANS = TRN_SEQ))
           else '0';

-- ---------------------------------------------------------------------
-- Address and control registers
-- ---------------------------------------------------------------------
-- Registers are used to store the address and control signals from
-- the address phase for use in the data phase of the transfer.
-- Only enabled when the HREADYin input is HIGH and the module is
-- addressed.

  ACRegEn <= HSELAPBif and HREADYin;

  p_ACRegSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      HaddrReg  <= (others => '0');
      HwriteReg <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if ACRegEn = '1' then
        HaddrReg  <= HADDR;
        HwriteReg <= HWRITE;
      end if;
    end if;
  end process p_ACRegSeq;

-- The address source used depends on the source of the current APB
-- transfer. If the transfer is being generated from:
-- - the pipeline registers, then the address source is HaddrReg
-- - the AHB inputs, the the address source is HADDR.
--
-- The HaddrMux multiplexer is used to select the appropriate address
-- source. A new read, sequential read following another read, or a
-- read following a write with no pending transfer are the only
-- transfers that are generated directly from the AHB inputs. All other
-- transfers are generated from the pipeline registers.

  HaddrMux <= HADDR when (NextState = ST_READ and
                          (CurrentState = ST_IDLE or
                           CurrentState = ST_RENABLE or
                           CurrentState = ST_WENABLE))
              else HaddrReg;

-- ---------------------------------------------------------------------
-- Next state logic for APB state machine
-- ---------------------------------------------------------------------
-- Generates next state from CurrentState and AHB inputs.

-- Due to write transfers having an extra setup state, the pending
-- states are used to indicate that there is a transfer in the pipeline
-- that has not been
-- started on the APB.
-- Read transfers start immediately, so pending states are not needed.

  p_NextStateComb : process (CurrentState, Valid, HWRITE, HwriteReg)
  begin
    case CurrentState is

      when ST_IDLE =>                -- Idle state
        if Valid = '1' then
          if HWRITE = '1' then
            NextState <= ST_WWAIT;
          else
            NextState <= ST_READ;
          end if;
        else
          NextState   <= ST_IDLE;
        end if;

      when ST_READ =>                -- Read setup
        NextState     <= ST_RENABLE;

      when ST_WWAIT =>               -- Hold for one cycle before write
        if Valid = '1' then
          NextState   <= ST_WRITEP;
        else
          NextState   <= ST_WRITE;
        end if;

      when ST_WRITE =>               -- Write setup
        if Valid = '1' then
          NextState   <= ST_WENABLEP;
        else
          NextState   <= ST_WENABLE;
        end if;

      when ST_WRITEP =>              -- Write setup with pending
                                     -- transfer
        NextState     <= ST_WENABLEP;

      when ST_RENABLE =>             -- Read enable
        if Valid = '1' then
          if HWRITE = '1' then
            NextState <= ST_WWAIT;
          else
            NextState <= ST_READ;
          end if;
        else
          NextState   <= ST_IDLE;
        end if;

      when ST_WENABLE =>             -- Write enable
        if Valid = '1' then
          if HWRITE = '1' then
            NextState <= ST_WWAIT;
          else
            NextState <= ST_READ;
          end if;
        else
          NextState   <= ST_IDLE;
        end if;

      when ST_WENABLEP =>            -- Write enable with pending
                                     -- transfer
        if HwriteReg = '1' then
          if Valid = '1' then
            NextState <= ST_WRITEP;
          else
            NextState <= ST_WRITE;
          end if;
        else
          NextState   <= ST_READ;
        end if;

      when others =>
        NextState     <= ST_IDLE;    -- Return to idle on FSM error

    end case;
  end process p_NextStateComb;

-- ---------------------------------------------------------------------
-- State machine
-- ---------------------------------------------------------------------
-- Changes state on rising edge of HCLK.

  p_CurrentStateSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      CurrentState <= ST_IDLE;
    elsif (HCLK'event and HCLK = '1') then
      CurrentState <= NextState;
    end if;
  end process p_CurrentStateSeq;

-- ---------------------------------------------------------------------
-- HREADYout generation
-- ---------------------------------------------------------------------
-- A registered version of HREADYout is used to improve output timing.
-- Wait states are inserted during:
--  ST_READ
--  ST_WRITEP
--  ST_WENABLEP when the currently pending transfer is a read, or
--              when the currently driven AHB transfer is a read.

  HreadyNext <= '0' when (NextState = ST_READ or
                          NextState = ST_WRITEP or
                          (NextState = ST_WENABLEP and
                          (HWRITE = '0' or HwriteReg = '0')))
               else '1';

  p_iHREADYoutSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      iHREADYout <= '0';
    elsif (HCLK'event and HCLK = '1') then
      iHREADYout <= HreadyNext;
    end if;
  end process p_iHREADYoutSeq;

-- ---------------------------------------------------------------------
-- APB address decoding for slave devices
-- ---------------------------------------------------------------------
-- Decodes the address from HaddrMux, which only changes during a read
-- or write cycle.
-- When an address is used that is not in any of the ranges specified,
--  operation of the system continues, but no PSEL lines are set, so no
--  peripherals are selected during the read/write transfer.
-- Operation of PWDATA, PWRITE, PENABLE and PADDR continues as normal.

  p_AddressDecodeComb : process (HaddrMux)
  begin
    case HaddrMux(29 downto 26) is
      when ICBASE  =>
        PselICInt  <= '1';
        PselUUTInt <= '0';
        PselRPCInt <= '0';
      when UUTBASE  =>
        PselICInt  <= '0';
        PselUUTInt <= '1';
        PselRPCInt <= '0';
      when RPCBASE =>
        PselICInt  <= '0';
        PselUUTInt <= '0';
        PselRPCInt <= '1';
      when others  =>
        PselICInt  <= '0';
        PselUUTInt <= '0';
        PselRPCInt <= '0';
    end case;
  end process p_AddressDecodeComb;

-- ---------------------------------------------------------------------
-- APB enable generation
-- ---------------------------------------------------------------------
-- APBEn is set when starting an access on the APB, and is used to
-- enable the PSEL, PWRITE and PADDR APB output registers.

  APBEn <= '1' when (NextState = ST_READ or NextState = ST_WRITE or
                     NextState = ST_WRITEP)
           else '0';

-- ---------------------------------------------------------------------
-- Registered HWDATA for writes (PWDATA)
-- ---------------------------------------------------------------------
-- Write wait state allows a register to be used to hold PWDATA.
-- Register enabled when PWRITE output is set HIGH.

  PWDATAEn <= PwriteNext;

  p_PWDATASeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      PWDATA <= (others => '0');
    elsif (HCLK'event and HCLK = '1') then
      if PWDATAEn = '1' then
        PWDATA <= HWDATA;
      end if;
    end if;
  end process p_PWDATASeq;

-- ---------------------------------------------------------------------
-- PENABLE generation
-- ---------------------------------------------------------------------
-- PENABLE output is set HIGH during any of the three ENABLE states.

  PenableNext <= '1' when (NextState = ST_RENABLE or
                           NextState = ST_WENABLE or
                           NextState = ST_WENABLEP)
                 else '0';

  p_PENABLESeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      PENABLE <= '0';
    elsif (HCLK'event and HCLK = '1') then
      PENABLE <= PenableNext;
    end if;
  end process p_PENABLESeq;

-- ---------------------------------------------------------------------
-- iPSEL generation
-- ---------------------------------------------------------------------
-- Set outputs with internal values when in READ or WRITE states
-- (APBEn HIGH).
-- Reset outputs when APB transfer has ended.
-- Hold  outputs at all other times.

  p_PselMuxComb : process (APBEn, PselICInt, PselUUTInt, PselRPCInt,
                           NextState, iPSELIC, iPSELUUT, iPSELRPC)
  begin
    if (APBEn = '1') then
      PselICMux  <= PselICInt;
      PselUUTMux <= PselUUTInt;
      PselRPCMux <= PselRPCInt;
    elsif (NextState = ST_IDLE or NextState = ST_WWAIT) then
      PselICMux  <= '0';
      PselUUTMux <= '0';
      PselRPCMux <= '0';
    else
      PselICMux  <= iPSELIC;
      PselUUTMux <= iPSELUUT;
      PselRPCMux <= iPSELRPC;
    end if;
  end process p_PselMuxComb;

-- Drives PSEL outputs with internal multiplexer versions.

  p_PSELSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      iPSELIC  <= '0';
      iPSELUUT <= '0';
      iPSELRPC <= '0';
    elsif (HCLK'event and HCLK = '1') then
      iPSELIC  <= PselICMux;
      iPSELUUT <= PselUUTMux;
      iPSELRPC <= PselRPCMux;
    end if;
  end process p_PSELSeq;

-- ---------------------------------------------------------------------
-- Registered HADDR for reads and writes (iPADDR)
-- ---------------------------------------------------------------------
-- HaddrMux is used, as the generation time of the APB address is
-- different for reads and writes, so both the direct and registered
-- HADDR input need to be used.
-- HaddrMux is captured by an APBEn enabled register to generate iPADDR.
-- Signal iPADDR is used so that only (PADDRWIDTH - 1) of PADDR is
-- driven.
-- iPADDR driven on State Machine change to READ or WRITE, with reset
-- to zero.

  p_iPADDRSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      iPADDR <= (others => '0');
    elsif (HCLK'event and HCLK = '1') then
      if (APBEn = '1') then
        iPADDR <= HaddrMux(PADDRWIDTH - 1 downto 0);
      end if;
    end if;
  end process p_iPADDRSeq;

-- ---------------------------------------------------------------------
-- PWRITE generation
-- ---------------------------------------------------------------------
-- PwriteNext is captured by an APBEn enabled register to generate
-- PWRITE, and is generated from NextState (set HIGH during a write
-- cycle). PWRITE output only changes when APB is accessed.

  PwriteNext <= '1' when (NextState = ST_WRITE or
                          NextState = ST_WRITEP)
                else '0';

  p_PWRITESeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      PWRITE <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if (APBEn = '1') then
        PWRITE <= PwriteNext;
      end if;
    end if;
  end process p_PWRITESeq;

-- ---------------------------------------------------------------------
-- APB output drivers
-- ---------------------------------------------------------------------
-- Drive outputs with internal signals.

  PADDR(PADDRWIDTH - 1 downto 0) <= iPADDR;

  PSELIC  <= iPSELIC;
  PSELUUT <= iPSELUUT;
  PSELRPC <= iPSELRPC;

-- ---------------------------------------------------------------------
-- AHB output drivers
-- ---------------------------------------------------------------------
-- PRDATA is only ever driven during a read, so it can be directly
-- copied to HRDATA to reduce the output data delay onto the AHB.

  HRDATA <= PRDATA;

-- Drives the output port with the internal version, and sets it LOW at
-- all other times when the module is not selected.

  HREADYout <= iHREADYout;

-- The response will always be OKAY to show that the transfer has been
-- performed successfully.

  HRESP <= RSP_OKAY;


end synth;

-- --============================== End ==============================--
