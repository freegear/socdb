-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : VicCpuif.vhd.rca
-- File Revision          : 1.17
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block generates the handshaking signals to the CPU and
--           generates the signals to control the priority logic
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity VicCpuif is
  port (
-- Inputs
        HCLK             : in    std_logic; -- Bus Clock
        HRESETn          : in    std_logic; -- AHB Reset

-- Vector address from Ahbif
        VectAddr0        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 0
        VectAddr1        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 1
        VectAddr2        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 2
        VectAddr3        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 3
        VectAddr4        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 4
        VectAddr5        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 5
        VectAddr6        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 6
        VectAddr7        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 7
        VectAddr8        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 8
        VectAddr9        : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 9
        VectAddr10       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 10
        VectAddr11       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 11
        VectAddr12       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 12
        VectAddr13       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 13
        VectAddr14       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 14
        VectAddr15       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 15
        VectAddr16       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 16
        VectAddr17       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 17
        VectAddr18       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 18
        VectAddr19       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 19
        VectAddr20       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 20
        VectAddr21       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 21
        VectAddr22       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 22
        VectAddr23       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 23
        VectAddr24       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 24
        VectAddr25       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 25
        VectAddr26       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 26
        VectAddr27       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 27
        VectAddr28       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 28
        VectAddr29       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 29
        VectAddr30       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 30
        VectAddr31       : in    std_logic_vector(31 downto 0);
                                            -- Vector address for interrupt
                                            -- source 31
        VICVECTADDRIN    : in    std_logic_vector(31 downto 0);
                                            -- Vector address for Daisy chained
                                            -- interrupt
-- Signals from interrupt processing
        IRQRequest       : in    std_logic; -- IRQ interrupt request
        IRQReqLevel      : in    std_logic_vector(3 downto 0);
                                            -- Priority level of the interrupt
                                            -- request
        IRQPort          : in    std_logic_vector(5 downto 0);
                                            -- Source of new interrupt request.
                                            -- Binary coded
                                            -- 0 to 31, VICINTSOURCE(0 to 31),
                                            -- 32 is the Daisy chain input
-- Interrupt handling control from AHB interface
        IRQSWAck         : in    std_logic; -- Software interrupt
                                            -- acknowledgement
        IRQSWClear       : in    std_logic; -- Software interrupt clear
-- Vic handshaking inputs
        nVICSYNCEN       : in    std_logic; -- Synchronous setting of
                                            -- handshaking
        VICIRQACK        : in    std_logic; -- IRQ acknowledge from CPU
-- Test logic control
        ITEN             : in    std_logic; -- Integration test enable
-- Force signal values when ITEN is high
        IRQACKForceVal   : in    std_logic; -- Force value for IRQACK
        VADDRINForceVal  : in    std_logic_vector(31 downto 0);
                                            -- Force value for daisy chain
                                            -- address input
        VADDRVForceVal   : in    std_logic; -- Force value for VICVECTADDRV
        ACKOUTForceVal   : in    std_logic; -- Force value for IRQACKOUT
        VADDRForceVal    : in    std_logic_vector(31 downto 0);
                                            -- Force value for vector address
                                            -- output

-- Outputs

        VICIRQACKOUT     : out   std_logic; -- Vic handshaking output for
                                            -- cascaded
                                            -- interrupt controller
-- Signals to Interrupt processing
        CurrentPriority  : out   std_logic_vector(15 downto 0);
                                            -- Current interrupt priority
        VICVectAddrVal   : out   std_logic_vector(31 downto 0);
                                            -- Address value for software read
-- Vic handshaking outputs
        VICVECTADDRV     : out   std_logic; -- Address valid signal
        VICVECTADDROUT   : out   std_logic_vector(31 downto 0);
                                            -- Vectored address out line
-- Read back value for integration test
        IRQACKTestVal    : out   std_logic; -- Integration test value of
                                            -- VICIRQACK
        VADDRINTestVal   : out   std_logic_vector(31 downto 0);
                                            -- Integration test value of
                                            -- VICVECTADDRIN
        VADDRVTestVal    : out   std_logic; -- Integration test value of
                                            -- VICVECTADDRV
        ACKOUTTestVal    : out   std_logic; -- Integration test value of
                                            -- VICIRQACKOUT
        VADDRTestVal     : out   std_logic_vector(31 downto 0)
                                            -- Integration test value of
                                            -- VICVECTADDROUT
       );
end VicCpuif;

-- -----------------------------------------------------------------------------
--
--                                  VicCpuif
--                                  ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This block does the following functionalities
--
-- - It generates the handshake signals for CPU and daisy chain VIC.
--   When the CPU acknowledges the interrupt by VICIRQACK, the VIC generates the
--   VICVECTADDRV stable when the address is stable on the VICVECTADDROUT line.
--   When VICIRQACK is asserted this module generates its IrqAck signal when
--   it is ready to accept the acknowledgement. Once the address is stable,
--   VICVECTADDRV is asserted. When VICIRQACK is deasserted, VICVECTADDRV and
--   nVICIRQ are deasserted.
--   VICIRQACKOUT is generated to inform the cascaded VIC that its interrupt is
--   being serviced. This is done by ORing the software ACK and the accepted
--   VICIRQACK.
-- - Generates the control signals to control priority logic.
--   This block traces the interrupts which are there in the pipeline and are
--   not completely serviced. When the ISR address is read by the CPU, the
--   currently being serviced interrupt is pushed to the stack and the masking
--   is generated. This will mask the other equal and lower priority interrupts.
--   when the interrupt is being serviced. Once the interrupt service is
--   completed, presently serviced priority is cleared and new mask value is
--   generated.
-- - It generates the address to be put on VICVECTADDROUT line.
--   Depending on the interrupt the address is placed on VICVECTADDROUT line.
--   If the daisy chain interrupt is selected then the address on VICVECTADDRIN
--   is placed on VICVECTADDROUT line.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture synth of VicCpuif is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal IRQACKtmux       : std_logic;
-- Test mux signal for VICIRQACK

signal VADDRINtmux      : std_logic_vector(31 downto 0);
-- Test mux signal for VECTADDRIN

signal VADDRVtmux       : std_logic;
-- Test mux signal for VICVECTADDRV

signal ReadyForAck      : std_logic;
-- Signal to ensure VIC has been clocked for acknowledge

signal StackPush        : std_logic;
-- Signal to indicate the stack push

signal StackPop         : std_logic;
-- Signal to indicate the stack pop

signal IrqAck           : std_logic;
-- Validated IRQ acknowledgement

signal VADDRtmux        : std_logic_vector(31 downto 0);
-- Test mux for VICVECTADDROUT

signal ACKOUTtmux       : std_logic;
-- Test mux for VICIRQACKOUT

signal Sync1IRQACK      : std_logic;
-- synchronisation logic for IrqAck

signal Sync2IRQACK      : std_logic;
-- 2nd synchronisation flip-flop

signal Sync3IRQACK      : std_logic;
-- IRQACK delayed by 3 clock edges

signal LastIrqAck       : std_logic;
-- Clocked IrqAck

signal ElyVecAddrMux    : std_logic_vector(31 downto 0);
-- Mux of Vector addr for local IRQs

signal VectAddrMux      : std_logic_vector(31 downto 0);
-- Mux of final Vector address register

signal LastVectAddr     : std_logic_vector(31 downto 0);
-- Register to hold vector address stable

signal IRQPortBit5Q     : std_logic;
-- 5th bit of Registered IRQ port number

signal IRQRequestQ      : std_logic;
-- Registered IRQ request

signal IRQRLevelQ       : std_logic_vector(3 downto 0);
-- Registered level

signal NewLevelEncoded  : std_logic_vector(15 downto 0);
-- One hot representation of interrupt priority level of interrupt request

signal NxtNewLvlEncoded : std_logic_vector(15 downto 0);
-- D-input of NewLevelEncoded

signal PriorityStack    : std_logic_vector(15 downto 0);
-- Priority level stack

signal NxtPriorityStk   : std_logic_vector(15 downto 0);
-- D-input of Priority Stack flip flop

signal NxtPriorityStk2  : std_logic_vector(15 downto 0);
-- D-input of Priority Stack flip flop

signal NxtElyVecAddrMux : std_logic_vector(31 downto 0);
-- D-input of ElyVecAddrMux

signal NxtLastVectAddr  : std_logic_vector(31 downto 0);
-- D-input of the LastVectAddr

signal LastIrqAckQ      : std_logic;
-- Clocked LastIrqAck

signal IRQSWAckQ        : std_logic;
-- Clocked IRQSWAck

signal VICVECTADDRINQ   : std_logic_vector(31 downto 0);
-- Clocked VICVECTADDRIN

signal VADDRtmuxQ       : std_logic_vector(31 downto 0);
-- Clocked VADDRtmux

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------

-- synopsys translate_on
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Test mux to force input value for IRQACK and VADDRIN signal
-- -----------------------------------------------------------------------------
IRQACKtmux       <= IRQACKForceVal when (ITEN = '1')
                 else
                    VICIRQACK;
VADDRINtmux      <= VADDRINForceVal when (ITEN = '1')
                 else
                    VICVECTADDRIN;

-- -----------------------------------------------------------------------------
-- Connect the Muxed IRQACK and VADDRIN to top level
-- -----------------------------------------------------------------------------
IRQACKTestVal  <= IRQACKtmux;
VADDRINTestVal <= VADDRINForceVal when (ITEN = '1')
               else
                  VICVECTADDRINQ;

-- -----------------------------------------------------------------------------
-- Clock the inputs from VicInterrupt block
-- -----------------------------------------------------------------------------
p_RegVicIntSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    IRQPortBit5Q     <= '0';
    IRQRequestQ      <= '0';
    IRQRLevelQ       <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    IRQPortBit5Q     <= IRQPort(5);
    IRQRequestQ      <= IRQRequest;
    IRQRLevelQ       <= IRQReqLevel;
  end if;
end process p_RegVicIntSeq;

-- -----------------------------------------------------------------------------
-- Generate one-hot representation of new priority level.
-- If there is no new interrupt value initialise the level to zero.
-- -----------------------------------------------------------------------------
p_NewLevelComb : process (IRQRLevelQ, IRQRequestQ)
begin
  if (IRQRequestQ = '1') then
    case IRQRLevelQ is
        when "0000" =>
           NxtNewLvlEncoded <= "0000000000000001";
        when "0001" =>
           NxtNewLvlEncoded <= "0000000000000010";
        when "0010" =>
           NxtNewLvlEncoded <= "0000000000000100";
        when "0011" =>
           NxtNewLvlEncoded <= "0000000000001000";
        when "0100" =>
           NxtNewLvlEncoded <= "0000000000010000";
        when "0101" =>
           NxtNewLvlEncoded <= "0000000000100000";
        when "0110" =>
           NxtNewLvlEncoded <= "0000000001000000";
        when "0111" =>
           NxtNewLvlEncoded <= "0000000010000000";
        when "1000" =>
           NxtNewLvlEncoded <= "0000000100000000";
        when "1001" =>
           NxtNewLvlEncoded <= "0000001000000000";
        when "1010" =>
           NxtNewLvlEncoded <= "0000010000000000";
        when "1011" =>
           NxtNewLvlEncoded <= "0000100000000000";
        when "1100" =>
           NxtNewLvlEncoded <= "0001000000000000";
        when "1101" =>
           NxtNewLvlEncoded <= "0010000000000000";
        when "1110" =>
           NxtNewLvlEncoded <= "0100000000000000";
        when others =>
           NxtNewLvlEncoded <= "1000000000000000";
     end case;
  else
    NxtNewLvlEncoded <= (others => '0');
  end if;
end process p_NewLevelComb;

-- -----------------------------------------------------------------------------
-- Clock the one-hot representation of priority level.
-- -----------------------------------------------------------------------------
p_NewLevelSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    NewLevelEncoded  <= "0000000000000000";
  elsif (HCLK'event and HCLK = '1') then
    NewLevelEncoded  <= NxtNewLvlEncoded;
  end if;
end process p_NewLevelSeq;

-- -----------------------------------------------------------------------------
-- Clock the VICVECTADDRIN
-- -----------------------------------------------------------------------------
p_VicAddrVectInSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    VICVECTADDRINQ  <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    VICVECTADDRINQ  <= VICVECTADDRIN;
  end if;
end process p_VicAddrVectInSeq;

-- -----------------------------------------------------------------------------
-- Clock the VADDRtmux
-- -----------------------------------------------------------------------------
p_VADDRtmuxSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    VADDRtmuxQ  <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    VADDRtmuxQ  <= VADDRtmux;
  end if;
end process p_VADDRtmuxSeq;
-- -----------------------------------------------------------------------------
-- Ensure VIC is clocked once before switching IrqAck from 0 to 1
-- If IrqAck was already '1' (LastIrqAck='1'), then ignore. Sync3IRQACK makes
-- sure that the handshaking mechanism going without holding up because of the
-- absent of the interrupt source.
-- -----------------------------------------------------------------------------
ReadyForAck  <= (IRQRequestQ or LastIrqAck or Sync3IRQACK);

-- -----------------------------------------------------------------------------
-- Registering the priority stack
-- -----------------------------------------------------------------------------
p_PriorityStackSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    PriorityStack    <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    PriorityStack    <= NxtPriorityStk2;
  end if;
end process p_PriorityStackSeq;

-- -----------------------------------------------------------------------------
-- Priority Stack
-- When there is write acknowledge then clear the highest interrupt priority
-- indicating that the present interrupt service is completed. And the other
-- interrupt of same priority can be serviced if asserted.
-- -----------------------------------------------------------------------------
p_PriorityStkComb1 : process (StackPop, PriorityStack)
begin
  if (StackPop = '1') then
    if (PriorityStack(0) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111111111111110";
    elsif (PriorityStack(1) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111111111111101";
    elsif (PriorityStack(2) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111111111111011";
    elsif (PriorityStack(3) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111111111110111";
    elsif (PriorityStack(4) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111111111101111";
    elsif (PriorityStack(5) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111111111011111";
    elsif (PriorityStack(6) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111111110111111";
    elsif (PriorityStack(7) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111111101111111";
    elsif (PriorityStack(8) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111111011111111";
    elsif (PriorityStack(9) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111110111111111";
    elsif (PriorityStack(10) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111101111111111";
    elsif (PriorityStack(11) = '1') then
      NxtPriorityStk   <= PriorityStack and "1111011111111111";
    elsif (PriorityStack(12) = '1') then
      NxtPriorityStk   <= PriorityStack and "1110111111111111";
    elsif (PriorityStack(13) = '1') then
      NxtPriorityStk   <= PriorityStack and "1101111111111111";
    elsif (PriorityStack(14) = '1') then
      NxtPriorityStk   <= PriorityStack and "1011111111111111";
    elsif (PriorityStack(15) = '1') then
      NxtPriorityStk   <= PriorityStack and "0111111111111111";
    else
      NxtPriorityStk   <= PriorityStack;
    end if;
  else
    NxtPriorityStk   <= PriorityStack;
  end if;
end process p_PriorityStkComb1;

-- -----------------------------------------------------------------------------
-- Combinatorial logic for pushing the priority to the stack
-- -----------------------------------------------------------------------------
p_PriorityStkComb2 : process (StackPush, NewLevelEncoded, NxtPriorityStk)
begin
  if (StackPush = '1') then
    NxtPriorityStk2  <= (NxtPriorityStk or NewLevelEncoded);
  else
    NxtPriorityStk2  <= NxtPriorityStk;
  end if;
end process p_PriorityStkComb2;

-- -----------------------------------------------------------------------------
-- Connect the priority stack to the CurrentPriority which will be used in the
-- VicInterrupt block. When Address valid is high, set the current priority to
-- zero so that nVICIRQ will be de asserted along with the de assertion
-- of the ADDRV.
-- -----------------------------------------------------------------------------
CurrentPriority  <= PriorityStack when (LastIrqAck = '0')
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Control for Priority stack.
-- Stack push will be either by AHB read from the VICADDRESS or by Vic port
-- handshaking.
-- Stack pop is by writing to the VICADDRESS by the CPU at end of interrupt
-- service routine.
-- -----------------------------------------------------------------------------
StackPush  <= (IRQSWAckQ or (not(LastIrqAckQ) and LastIrqAck));
StackPop   <= IRQSWClear;

-- -----------------------------------------------------------------------------
-- Acknowledge synchronisation logic
-- 3rd flip-flop is used to ensure handshaking going without holding up by
-- the absent of interrupt source
-- -----------------------------------------------------------------------------
p_AckSyncLogicSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    Sync1IRQACK      <= '0';
    Sync2IRQACK      <= '0';
    Sync3IRQACK      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    Sync1IRQACK      <= IRQACKtmux;
    Sync2IRQACK      <= Sync1IRQACK;
    Sync3IRQACK      <= Sync2IRQACK;
  end if;
end process p_AckSyncLogicSeq;

-- -----------------------------------------------------------------------------
-- Decide if double flip-flop synchronisation logic is used
-- When nVICSYNCEN is low, use the clocked VICIRQACK else use the direct
-- VICIRQACK.
-- -----------------------------------------------------------------------------
IrqAck <= (ReadyForAck and ((not(nVICSYNCEN) and Sync2IRQACK) or
          (nVICSYNCEN and IRQACKtmux)));

-- -----------------------------------------------------------------------------
-- Create delay version of IrqAck for edge detection
-- -----------------------------------------------------------------------------
p_DelayIrqAckSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    LastIrqAck       <= '0';
  elsif (HCLK'event and HCLK = '1') then
    LastIrqAck       <= IrqAck;
  end if;
end process p_DelayIrqAckSeq;

-- -----------------------------------------------------------------------------
-- Create delay version of LastIrqAck for pushing the stack
-- -----------------------------------------------------------------------------
p_LastIrqAckSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    LastIrqAckQ      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    LastIrqAckQ      <= LastIrqAck;
  end if;
end process p_LastIrqAckSeq;

-- -----------------------------------------------------------------------------
-- Generate VICVECTADDRV and connect it to the top level
-- -----------------------------------------------------------------------------
VADDRVtmux       <= VADDRVForceVal when (ITEN = '1')
                 else
                    LastIrqAck;

VICVECTADDRV <= VADDRVtmux;

-- -----------------------------------------------------------------------------
-- For Software read back
-- -----------------------------------------------------------------------------
VADDRVTestVal  <= VADDRVtmux;

-- -----------------------------------------------------------------------------
-- Clocking the software acknowledge signal
-- -----------------------------------------------------------------------------
p_IRQSWAckSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    IRQSWAckQ        <= '0';
  elsif (HCLK'event and HCLK = '1') then
    IRQSWAckQ        <= IRQSWAck;
  end if;
end process p_IRQSWAckSeq;

-- -----------------------------------------------------------------------------
-- Cascaded interrupt controller feedback. If the local interrupt is inactive
-- then feedback the VICIRQACKOUT to daisy chained interrupt controller.
-- -----------------------------------------------------------------------------
p_IrqAckmuxComb : process (ITEN, IRQPortBit5Q, IRQSWAck, IrqAck, LastIrqAck,
                           ACKOUTForceVal)
begin
  if (ITEN = '1') then
    ACKOUTtmux       <= ACKOUTForceVal;
  else
    ACKOUTtmux       <= IRQPortBit5Q and (IRQSWAck or (IrqAck and
                        not(LastIrqAck)));
  end if;
end process p_IrqAckmuxComb;

-- -----------------------------------------------------------------------------
-- Connect to AhbIf for read back in the integration test mode
-- -----------------------------------------------------------------------------
ACKOUTTestVal  <= ACKOUTtmux;

-- -----------------------------------------------------------------------------
-- Connect the ACKOUTtmux to top level output
-- -----------------------------------------------------------------------------
VICIRQACKOUT  <= ACKOUTtmux;

-- -----------------------------------------------------------------------------
-- Register the vector address
-- -----------------------------------------------------------------------------
p_EarlyAddrMuxSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    ElyVecAddrMux    <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    ElyVecAddrMux    <= NxtElyVecAddrMux;
  end if;
end process p_EarlyAddrMuxSeq;

-- -----------------------------------------------------------------------------
-- VIC vector address mux
-- Addresses for local IRQ are muxed during priority encoding stage to improve
-- timing of HRDATA
-- -----------------------------------------------------------------------------
p_EarlyAddrMuxComb : process (IRQPort, VectAddr0, VectAddr1, VectAddr2,
                              VectAddr3, VectAddr4, VectAddr5, VectAddr6,
                              VectAddr7, VectAddr8, VectAddr9, VectAddr10,
                              VectAddr11, VectAddr12, VectAddr13,
                              VectAddr14, VectAddr15, VectAddr16,
                              VectAddr17, VectAddr18, VectAddr19,
                              VectAddr20, VectAddr21, VectAddr22,
                              VectAddr23, VectAddr24, VectAddr25,
                              VectAddr26, VectAddr27, VectAddr28,
                              VectAddr29, VectAddr30, VectAddr31)
begin
  case IRQPort(4 downto 0) is
    when "00000" =>
      NxtElyVecAddrMux <= VectAddr0;
    when "00001" =>
      NxtElyVecAddrMux <= VectAddr1;
    when "00010" =>
      NxtElyVecAddrMux <= VectAddr2;
    when "00011" =>
      NxtElyVecAddrMux <= VectAddr3;
    when "00100" =>
      NxtElyVecAddrMux <= VectAddr4;
    when "00101" =>
      NxtElyVecAddrMux <= VectAddr5;
    when "00110" =>
      NxtElyVecAddrMux <= VectAddr6;
    when "00111" =>
      NxtElyVecAddrMux <= VectAddr7;
    when "01000" =>
      NxtElyVecAddrMux <= VectAddr8;
    when "01001" =>
      NxtElyVecAddrMux <= VectAddr9;
    when "01010" =>
      NxtElyVecAddrMux <= VectAddr10;
    when "01011" =>
      NxtElyVecAddrMux <= VectAddr11;
    when "01100" =>
      NxtElyVecAddrMux <= VectAddr12;
    when "01101" =>
      NxtElyVecAddrMux <= VectAddr13;
    when "01110" =>
      NxtElyVecAddrMux <= VectAddr14;
    when "01111" =>
      NxtElyVecAddrMux <= VectAddr15;
    when "10000" =>
      NxtElyVecAddrMux <= VectAddr16;
    when "10001" =>
      NxtElyVecAddrMux <= VectAddr17;
    when "10010" =>
      NxtElyVecAddrMux <= VectAddr18;
    when "10011" =>
      NxtElyVecAddrMux <= VectAddr19;
    when "10100" =>
      NxtElyVecAddrMux <= VectAddr20;
    when "10101" =>
      NxtElyVecAddrMux <= VectAddr21;
    when "10110" =>
      NxtElyVecAddrMux <= VectAddr22;
    when "10111" =>
      NxtElyVecAddrMux <= VectAddr23;
    when "11000" =>
      NxtElyVecAddrMux <= VectAddr24;
    when "11001" =>
      NxtElyVecAddrMux <= VectAddr25;
    when "11010" =>
      NxtElyVecAddrMux <= VectAddr26;
    when "11011" =>
      NxtElyVecAddrMux <= VectAddr27;
    when "11100" =>
      NxtElyVecAddrMux <= VectAddr28;
    when "11101" =>
      NxtElyVecAddrMux <= VectAddr29;
    when "11110" =>
      NxtElyVecAddrMux <= VectAddr30;
    when others =>
      NxtElyVecAddrMux <= VectAddr31;
  end case;
end process p_EarlyAddrMuxComb;

-- -----------------------------------------------------------------------------
-- Store the LastVectAddr after IrqAck is deasserted
-- -----------------------------------------------------------------------------
p_LastVAddrStComb : process (VectAddrMux, LastIrqAck, LastVectAddr)
begin
  if (LastIrqAck = '0') then
    NxtLastVectAddr  <= VectAddrMux;
  else
    NxtLastVectAddr  <= LastVectAddr;
  end if;
end process p_LastVAddrStComb;

-- -----------------------------------------------------------------------------
-- Feedback VIC address for SW read (acknowledge)
-- -----------------------------------------------------------------------------
VICVectAddrVal  <= VectAddrMux;

-- -----------------------------------------------------------------------------
-- Circuit to hold VICVECTADDROUT stable
-- -----------------------------------------------------------------------------
p_VectAddrRegSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    LastVectAddr     <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    LastVectAddr     <= NxtLastVectAddr;
  end if;
end process p_VectAddrRegSeq;

-- -----------------------------------------------------------------------------
-- Mux Output for read by software and to vic handshaking port
-- If there is no IRQ request keep the address unchanged. If the daisy chain
-- interrupt is active then, select the VICADDRIN. If the interrupt is a local
-- one then select the corresponding address.
-- -----------------------------------------------------------------------------
p_VicAddrMuxComb : process (IRQPortBit5Q, IRQRequestQ, VADDRINtmux,
                            ElyVecAddrMux, LastVectAddr)
begin
  if (IRQRequestQ = '0') then
    VectAddrMux      <= LastVectAddr;
  elsif (IRQPortBit5Q = '1') then
    VectAddrMux      <= VADDRINtmux;
  else
    VectAddrMux      <= ElyVecAddrMux;
  end if;
end process p_VicAddrMuxComb;

-- -----------------------------------------------------------------------------
-- Select Vector address output
-- If the ACK was already asserted the output address should keep the same
-- address else select the latest address. If the ITEN is enabled in test mode,
-- then select the content of the VICITOP2 address.
-- -----------------------------------------------------------------------------
p_AddrOutComb : process (ITEN, VectAddrMux, LastVectAddr, VADDRForceVal,
                         LastIrqAck)
begin
  if (ITEN = '1') then
    VADDRtmux        <= VADDRForceVal;
  else
    if (LastIrqAck = '1') then
      VADDRtmux        <= LastVectAddr;
    else
      VADDRtmux        <= VectAddrMux;
    end if;
  end if;
end process p_AddrOutComb;

-- -----------------------------------------------------------------------------
-- Connect to top level
-- -----------------------------------------------------------------------------
VICVECTADDROUT  <= VADDRtmux;

-- -----------------------------------------------------------------------------
-- Connect to Ahbif for integration test read back.
-- -----------------------------------------------------------------------------
VADDRTestVal  <= VADDRtmuxQ;

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------
-- synopsys translate_on

end synth;

-- --================================== End ==================================--
