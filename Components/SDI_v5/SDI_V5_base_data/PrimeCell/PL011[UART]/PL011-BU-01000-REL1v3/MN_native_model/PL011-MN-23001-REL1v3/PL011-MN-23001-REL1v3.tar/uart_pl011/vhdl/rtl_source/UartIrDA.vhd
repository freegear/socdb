--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartIrDA.vhd.rca
--  File Revision          : 1.14
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--  ----------------------------------------------------------------------------
--  
--  
--  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity UartIrDA is
  port (
        UARTCLK     : in  std_logic;      -- Main UART Clock
        nUARTRST    : in  std_logic;	  -- Muxed reset (from nUARTRST)
        
        Baud16      : in  std_logic;	  -- Bit Period reference
        IrLPBaud16  : in  std_logic;	  -- Low Power pulse width ref
        SIRLPSync   : in  std_logic;	  -- Low power mode enable
        SIRENSync   : in  std_logic;	  -- SIR Enable
        SIRTEST     : in  std_logic;	  -- SIR duplex enabled
        
        StopBaudCnt : in  std_logic;      -- Stop baud counter
        TXBUSY      : in  std_logic;      -- UART Transmitter busy
        RXBUSY      : in  std_logic;	  -- UART Receiver busy
        
        TXD         : in  std_logic;      -- From UART Transmitter
        SIRINSync   : in  std_logic; 	  -- Sync'ed SIR serial input
        UARTRXDSync : in  std_logic;	  -- Synced serial receive input
        
        UARTTXDint  : out std_logic;      -- Made inactive if SIR enabled
        RXD         : out std_logic;	  -- Decoded signal to UART Receiver
        nSIROUTint  : out std_logic	  -- SIR Encoded transmit bit stream
        );
end UartIrDA;
--------------------------------------------------------------------------------
-- Purpose     : This block is the IrDA encoder/decoder
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                     UartIrDA
--                     ========
--
--------------------------------------------------------------------------------
-- Overview
-- ========
--  This block contains the encoder and decoder required to encode
-- and decode the bit stream into a stream compatible with IrDA
-- standards. A '0' is transmitted as a pulse while a '1' is
-- encoded as no pulse. In the normal mode, the pulse is 3 Baud16
-- periods wide. In the low-power mode, the pulse is 3 IrLPBaud16 periods
-- wide. Glitches on the SIRIN line are rejected by oversampling. Both in
-- Normal and Low-Power modes, start bits which are less than one period of
-- IrLPBaud16 are rejected by the glitch rejection logic. 
-- IrDA is a half-duplex protocol by specification. Although this
-- implementation prevents simultaneous transmission and reception in normal
-- mode, software has to ensure that no transmit data is present in the
-- transmit FIFO when IrDA reception is in progress. This is because the
-- UART receive state machine goes to the idle state at the end of every
-- byte of data and there is no way of being sure that there is no further
-- data to be received.
--
--
--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth  of UartIrDA is

--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------
  signal   NextSIROUT      : std_logic; 
  -- D-input for Sirout

  signal   NmSirout        : std_logic;
  -- normal mode output

  signal   NextNmSirout    : std_logic;
  -- D-input for normal mode output

  signal   PdSirout        : std_logic; 
  -- low power mode output

  signal   NextPdSirout    : std_logic;
  -- D-input for low power mode output

  signal   NextUARTTXD     : std_logic; 
  -- D-input for UARTTXDint

  signal   NextRXD         : std_logic;
  -- D-input for iRXD

  signal   iRXD            : std_logic; 
  -- Internal version of RXD

  signal   PdTCload        : std_logic; 
  -- Enable signal for the counter PdTcount

  signal   NextPdTCload    : std_logic;
  -- D-input for the  PdTcount signal

  signal   TCStart         : std_logic; 
  -- Enable signal for the counter Tcount

  signal   NextTCStart     : std_logic; 
  -- D-input for the Tcount signal

  signal   Flag            : std_logic; 
  -- Used to prevent more than one pulse in one bit time in low power mode

  signal   NextFlag        : std_logic;
  -- D-input for the Flag signal

  signal   Rload           : std_logic; 
  -- enable signal for the counter Rcount

  signal   NextRload       : std_logic; 
  -- D-input for the Rload signal

  signal   SIRINStag1      : std_logic; 
  -- 1st sample of SIRINSync

  signal   NextSIRINStag1  : std_logic;
  -- D-input for SIRINStag1 signal;
  
  signal   SIRINStag1a     : std_logic; 
  -- 1st A sample of SIRINSync

  signal   NextSIRINStag1a : std_logic;
  -- D-input for SIRINStag1a signal;
  
  signal   SIRINStag2      : std_logic; 
  -- 2ed sample of SIRINSync

  signal   NextSIRINStag2  : std_logic;
  -- D-input for SIRINStag2 signal;

  signal   SIRINStag2a     : std_logic; 
  -- 2ed A sample of SIRINSync

  signal   NextSIRINStag2a : std_logic;
  -- D-input for SIRINStag2a signal;

  signal   SIRINStag2Final : std_logic; 
  -- Combined value of SIRINStag2

  signal   IrRXBUSY        : std_logic;
  signal   IrTXBUSY        : std_logic;
  -- Used to decide full or half duplex mode

  signal   Tcount          : std_logic_vector(3 downto 0);
  -- Used in transmitter module to determine one bit period

  signal   Rcount          : std_logic_vector(3 downto 0);
  -- Used in the receiver module to determine one bit period

  signal   NextTcount      : std_logic_vector(3 downto 0);
  -- D-input for the counter Tcount

  signal   NextRcount      : std_logic_vector(3 downto 0);
  -- D-input for the counter Rcount

  signal   PdTcount        : std_logic_vector(1 downto 0);
  -- Used in low power mode to determine pulse width

  signal   NextPdTcount    : std_logic_vector(1 downto 0);   
  -- D-input for the counter PdTcount

  signal   TCStartEn       : std_logic;
  -- Used to generate the TCStart signal
  
  signal   SIRENSyncEoc    : std_logic;
  -- SIR enable signal for end of Character

--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------
  
begin
  
--------------------------------------------------------------------------------
-- Output synchronising with UARTCLK
--------------------------------------------------------------------------------
  p_SyncOut : process(UARTCLK, nUARTRST)
  begin
    if (nUARTRST ='0') then
      UARTTXDint  <= '1';
      nSIROUTint  <= '0';  
      iRXD        <= '1';
    elsif ( UARTCLK'event and UARTCLK ='1') then
      UARTTXDint  <= NextUARTTXD;
      nSIROUTint  <= NextSIROUT;
      iRXD        <= NextRXD;
    end if; 
  end process p_SyncOut;


  p_SIRENSyncEoc : process (UARTCLK, nUARTRST)
  begin
    if (nUARTRST ='0') then
      SIRENSyncEoc <= '0';
    elsif ( UARTCLK'event and UARTCLK ='1') then
        if(StopBaudCnt = '1')  then 
        SIRENSyncEoc <= SIRENSync;
      end if;
    end if;
  end process p_SIRENSyncEoc;

  
--------------------------------------------------------------------------------
-- Output module -- combining normal and powerdown modes
--------------------------------------------------------------------------------
  p_Out : process (SIRENSyncEoc,SIRLPSync,PdSirout,
                   TXD, NmSirout)
  begin
    if (SIRENSyncEoc = '0') then
      NextUARTTXD  <= TXD;
      NextSIROUT   <= '0';  
    else
      NextUARTTXD  <= '1';
      NextSIROUT   <=  (((not SIRLPSync) and (NmSirout)) or ((SIRLPSync) and (PdSirout)));
    end if; 
  end process p_Out;
  
  TCStartEn        <=  '1' when (not((Tcount = "1111") and (TXD = '1')))
                       else
                       '0';
  
--------------------------------------------------------------------------------
-- This process primarily implements the transmitter counter. It is a 4-bit
-- counter enabled by the Baud16 and TCStart signals. When a low level is 
-- detected on the TXD line, the counter is loaded with 15 and the TCStart 
-- bit is set. As long as this bit is set, the counter decrements by 1 on
-- sampling a Baud16 pulse. At the end of the bit period (counter = 15),
-- if the TXD line is sampled low, the TCStart bit is maintained high. The
-- counter decrements by 1 and the whole process repeats for the next bit.
-- If the TXD line is sampled high, the TCStart bit is cleared. To support
-- half duplex mode operation, the TCStart bit and the counter are reset 
-- when the IrRXBUSY signal becomes active.
--------------------------------------------------------------------------------
  p_TransCountLoad : process(SIRENSyncEoc,Tcount,TCStart,TXD,Baud16,IrRXBUSY, 
                             TCStartEn)
  begin
    NextTcount     <= Tcount;
    NextTCStart    <= TCStart;
    if (SIRENSyncEoc ='0') then
      NextTcount   <= "0000";
      NextTCStart  <= '0';
    elsif(IrRXBUSY = '1') then
      NextTcount   <= "0000";
      NextTCStart  <= '0';
    elsif((TXD ='0') and (TCStart ='0')) then
      NextTcount   <= "1111";
      NextTCStart  <= '1';
    elsif ((TCStart = '1') and (Baud16 = '1')) then
      NextTcount   <= (UNSIGNED(Tcount) - 1);
      NextTCStart  <= TCStartEn;
    end if;
  end process p_TransCountLoad;
  
--------------------------------------------------------------------------------
-- Set the transmitter output high for 3 Baud16 periods in normal mode
--------------------------------------------------------------------------------
  p_TransmitterOut1 : process (Tcount,SIRENSyncEoc,SIRLPSync,NmSirout)
  begin
    if (SIRENSyncEoc ='0') then
      NextNmSirout <= '0';  
    elsif ((SIRLPSync = '0') and 
           ((Tcount = "1010") or (Tcount = "1001")    
            or (Tcount = "1000"))) then
      NextNmSirout <= '1';
    elsif (SIRLPSync ='0') then
      NextNmSirout <= '0';
    else
      NextNmSirout <= NmSirout;
    end if;
  end process p_TransmitterOut1;

  p_Transmitter_clk:   process (UARTCLK ,nUARTRST) 
  begin
    if (nUARTRST = '0') then 
      Tcount      <= "0000"; 
      NmSirout    <= '0';
      TCStart     <= '0';
    elsif(UARTCLK'event and UARTCLK = '1') then
      NmSirout    <= NextNmSirout;
      TCStart     <= NextTCStart;
      Tcount      <= NextTcount;
    end if;
  end process p_Transmitter_clk; 
  
--------------------------------------------------------------------------------
-- This process implements the low power section of the transmitter.  
-- In the low power mode, bit period timing commences when the Tcount 
-- counter reaches a value of 10. At this count, the PdTCload is set high. 
-- When the next IrLPBaud16 pulse is sampled, the PdTcount counter is loaded
-- with 3. The transmitter output is driven high and maintained for 3 
-- IrLPBaud16 periods. The PdTCload bit is cleared along with the transmitter
-- output. Simultaneously, a Flag bit is set to prevent reassertion of the 
-- transmitter output within the same bit period, in cases where the 
-- Baud16 frequency is much lower than the IrLPBaud16 frequency.
--------------------------------------------------------------------------------
  p_LowPtransCountLoad : process (SIRENSyncEoc,Tcount,SIRLPSync,PdTcount,
                                   IrLPBaud16,Flag, PdSirout,PdTCload)
  begin
    NextFlag         <= Flag;
    NextPdSirout     <= PdSirout;
    NextPdTcount     <= PdTcount;
    NextPdTCload     <= PdTCload;
    if (SIRENSyncEoc ='0') then
      NextPdTcount   <= "00";
      NextPdSirout   <= '0';
      NextFlag       <= '0'; 
      NextPdTCload   <= '0';
    elsif ((Tcount = "1010") and (SIRLPSync = '1') and 
           (PdTCload ='0') and (Flag = '0')) then
      NextPdTCload <= '1';
    elsif ((PdTCload ='1') and (IrLPBaud16 ='1')
           and (PdSirout ='0')) then
      NextPdTcount   <= "11";  
      NextPdSirout   <= '1';
    elsif ((PdTCload = '1') and (IrLPBaud16 = '1')) then
      if (PdTcount = "01") then
        NextPdSirout <= '0';
        NextFlag     <= '1';
        NextPdTCload <= '0';
      else  
        NextPdTcount <= (UNSIGNED(PdTcount) - 1);     
      end if;
    elsif (Tcount = "1111") then
      NextFlag       <= '0';
    end if;
  end process p_LowPtransCountLoad;

  p_Transmitter_2mclk : process(UARTCLK, nUARTRST)
  begin
    if (nUARTRST = '0') then
      PdTcount    <= "00";
      PdSirout    <= '0';
      PdTCload    <= '0';
      Flag        <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      PdSirout    <= NextPdSirout;
      PdTcount    <= NextPdTcount;
      PdTCload    <= NextPdTCload;
      Flag        <= NextFlag;
    end if;
  end process p_Transmitter_2mclk;

--------------------------------------------------------------------------------
-- This process implements the glitch rejection logic in the receiver section 
-- of the IrDA. 
-- Glitch rejection is performed by sampling the SIRINsync line on the 
-- IrLPBaud16 clock using two pipeline stages. Glitches of width less
-- than one period of IrLPBaud16 are rejected using this method.
-- Signals of width more than one period of IrLPBaud16 but less than two 
-- periods of IrLPBaud16 may or may not be taken as a glitch. Signals of 
-- width more than two IrLPBaud16 periods are taken as valid signals.
--------------------------------------------------------------------------------

  p_deglitcher_clk : process(UARTCLK,nUARTRST)
  begin
    if(nUARTRST = '0') then
      SIRINStag1  <= '1';
      SIRINStag2  <= '1';
      SIRINStag1a <= '1';
      SIRINStag2a <= '1';
    elsif(UARTCLK'event and UARTCLK = '1' ) then
      SIRINStag1  <= NextSIRINStag1;
      SIRINStag2  <= NextSIRINStag2;
      SIRINStag1a <= NextSIRINStag1a;
      SIRINStag2a <= NextSIRINStag2a;
    end if; 
  end process p_deglitcher_clk;  

  -------------------------------------------------------------------
  -- The following detects for a low on SIRINSync of at least 1
  -- IrLPBaud16 cycle with the registers being updated based on 
  -- IrLPBaud16 being equal to 1.
  -------------------------------------------------------------------
  p_deglitcher1 : process(SIRINSync,SIRINStag1,IrLPBaud16)
  begin
    if(IrLPBaud16 = '1') then
      NextSIRINStag1 <= SIRINSync;
    else
      NextSIRINStag1 <= SIRINStag1;
    end if;
  end process p_deglitcher1;
  
  p_deglitcher2 : process(SIRINSync,SIRINStag1,SIRINStag2,IrLPBaud16)
  begin
    if((IrLPBaud16 ='1') and (SIRINStag1 = SIRINSync)) then
      NextSIRINStag2 <= SIRINStag1;
    else
      NextSIRINStag2 <= SIRINStag2;
    end if;
  end process p_deglitcher2;
  
  -------------------------------------------------------------------
  -- The following detects for a low on SIRINSync of at least 1
  -- IrLPBaud16 cycle with the registers being updated based on 
  -- IrLPBaud16 being equal to 0.
  -------------------------------------------------------------------
  p_deglitcher1a : process(SIRINSync, SIRINStag1a, IrLPBaud16)
  begin
    if(IrLPBaud16 = '0') then
      NextSIRINStag1a <= SIRINSync;
    else
      NextSIRINStag1a <= SIRINStag1a;
    end if;
  end process p_deglitcher1a;
  
  p_deglitcher2a : process(SIRINSync, SIRINStag1a, SIRINStag2a, IrLPBaud16)
  begin
    if((IrLPBaud16 ='0') and (SIRINStag1a = SIRINSync)) then
      NextSIRINStag2a <= SIRINStag1a;
    else
      NextSIRINStag2a <= SIRINStag2a;
    end if;
  end process p_deglitcher2a;

  ----------------------------------------------------------------
  -- With the above two detections, should catch all SIRINSync
  -- pulses which are at least 1 IrLPBaud16 pulse wide.
  ----------------------------------------------------------------
  SIRINStag2Final <= '0' when (SIRINStag2 = '0' or
                               SIRINStag2a = '0') else '1';


--------------------------------------------------------------------------------
-- This process converts the valid input bit stream into a stream compatible
-- with IrDA standards. The default value of SIRINStag2Final is 1. When a low is
-- detected on this line, a 4 bit counter Rcount is loaded with a value of 12
-- and the RXD line is pulled low on the next Baud16 clock. The RXD line 
-- is held low until the counter rolls over from 1 to 0.
-- To support half duplex mode of operation, the counters and control signals
-- are reset on sampling the IrTXBUSY line high. The RXD line is also 
-- restored to its default value of high. 
--------------------------------------------------------------------------------

  p_Receiver : process (SIRENSyncEoc,SIRINStag2Final,Baud16, Rcount,Rload,

                        iRXD,IrTXBUSY,UARTRXDSync)
  begin
    NextRXD            <= iRXD;
    NextRload          <= Rload;
    NextRcount         <= Rcount;
    if(SIRENSyncEoc ='0') then
      NextRXD          <= UARTRXDSync;
      NextRload        <= '0';
      NextRcount       <= "0000";
    elsif(IrTXBUSY ='1') then
      NextRXD          <= '1';
      NextRload        <= '0';
      NextRcount       <= "0000";
    elsif((SIRINStag2Final ='0') and (Rload ='0')) then
      NextRload        <= '1';
    elsif((Baud16 ='1') and (Rload ='1')) then  
      if( Rcount = "0000") then
        NextRcount     <= "1100";
        NextRXD        <= '0';
        NextRload      <= Rload;
      elsif(Rcount = "0001") then
        NextRcount     <= "0000";
        NextRload      <= '0';
        NextRXD        <= '1';
      else
        NextRcount     <= (UNSIGNED(Rcount) - 1);
      end if;
    end if;
  end process p_Receiver;

-- The use of the SIRTEST signal in the following two 
-- equations enables full duplex operation in test mode.

  IrRXBUSY  <= (not(SIRTEST)) and (RXBUSY);
  IrTXBUSY  <= (not(SIRTEST)) and (TXBUSY);
  RXD       <= iRXD;

  p_Receiver_clk : process (UARTCLK, nUARTRST)
  begin
    if(nUARTRST ='0') then
      Rload     <= '0';
      Rcount    <= "0000";
    elsif(UARTCLK'event and UARTCLK ='1') then
      Rload     <= NextRload;
      Rcount    <= NextRcount;
    end if;
  end process p_Receiver_clk;

end synth;

--========================== End of UartIrDA =================================--




