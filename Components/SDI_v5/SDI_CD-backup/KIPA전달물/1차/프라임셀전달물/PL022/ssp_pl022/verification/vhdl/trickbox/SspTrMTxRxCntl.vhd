-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
--  Version and Release Control Information:
--
--  File Name              : SspTrMTxRxCntl.vhd.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--
-- -----------------------------------------------------------------------------
-- Purpose          : This block consists of the main Transmit/Receive
--                    control Logic.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
-- -----------------------------------------------------------------------------
 
entity SspTrMTxRxCntl is
  port(
       PRESETn         : in Std_logic;  -- APB Bus Reset 
       SCLK            : in std_logic;  -- Serial clock
       SFRM            : in std_logic;  -- Serial frame
       SSTBESync       : in std_logic;  -- SSPTB enable
       TxDataAvlblSync : in std_logic;  -- Tx data available
       DSS             : in std_logic_vector(3 downto 0);
                                        -- Bits per frame
       FRF             : in std_logic_vector(1 downto 0);
                                        -- Frame format
       SCR             : in std_logic_vector(7 downto 0);
                                        -- Serial clock rate
       SPO             : in std_logic;  -- SCLK polarity
       SPH             : in std_logic;  -- SCLK phase
       TxFRdDataIn     : in std_logic_vector(15 downto 0); 
                                        -- Lft justified
       SSPRXD          : in std_logic;  -- Loopback muxed SSPRXD
       OD              : in std_logic;  -- Master/Slave select bit
       TxFRdPtrInc     : out std_logic; -- Tx FIFO read ptr incr.
       RxFWr           : out std_logic; -- Rx FIFO write enable
       TxRxBSY         : out std_logic; -- SSP Tx/Rx controller busy
       ChkTxBSY        : out std_logic; -- SSP Tx controller busy
       SSPTXD          : out std_logic; -- Serial transmit output
       RxFWrData       : out std_logic_vector(15 downto 0)
                                        -- Rx FIFO write data
      );
end SspTrMTxRxCntl;

-- -----------------------------------------------------------------------------
--
--                            SspTrMTxRxCntl
--                            ============
--
-- ----------------------------------------------------------------------------- 
-- Overview
-- ========
--
--  This block constitutes the main transmit / receive control logic in the
-- SSPTrickbox. Transmit data is first loaded into a 16-bit Transmit Shift 
-- Register and bits are shifted out onto the SSPTXD output line (MSBit first).
--  Receive data sampled on the RXDSSIn input is shifted into an internal
-- shift register and when a complete frame is received, received data is
-- copied into a receive buffer from the shift register. When the last data
-- bit is sampled on the RXDSSIn input, it is copied into the Receive
-- Buffer along with the contents of the receive shift register. Thus, the
-- receive shift register is 15 bits wide and the receive buffer is 16 bits
-- wide.
--  Interaction with the Transmit FIFO occurs through the TxFRdPtrInc
-- signal.This signal is asserted when half the number of the bits of a frame 
-- are transmitted. In order to ensure that the signal gets synchronised to PCLK
-- and is seen by the Transmit FIFO, the signal is kept asserted for multiple 
-- clocks.
-- The deassertion of the TxFRdPtrInc signal is done, when the TxData is loaded
-- into the shift register. 
-- Thus the TxFRdPtrInc signal is kept asserted for 4 SSPCLK periods. Since
-- the assumption is that the frequency of PCLK is equal to or greater than
-- that of SSPCLK, this signal is assured to be seen in the PCLK domain.
-- This corresponds to a worst case minimum of one half of 4 bits i.e. 2
-- bit periods.This corresponds to 4 SSPCLK periods.
--  Interaction with the Receive FIFO occurs through the RxFWr signal which
-- is also asserted for a minimum of two SCLK periods. 
--
-- -----------------------------------------------------------------------------

-- ============================= ARCHITECTURE ================================--

architecture behavioural of SspTrMTxRxCntl is

-- -----------------------------------------------------------------------------
--  Constant declarations
-- -----------------------------------------------------------------------------
constant NWDSS   :std_logic_vector (3 downto 0) := "1000";
-- DSS for National Microwire Mode Transmission 
  
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal LocalTxRxBSY      : std_logic;
-- Internal SspTrickbox busy 

signal iTxRxBSY          : std_logic;
-- Internal SspTrickbox busy 

signal iChkTxBSY         : std_logic;
-- Internal SspTrickbox TX. busy 

signal LocalSSPTXD       : std_logic;
-- Internal SspTrickbox Transmit signal

signal LocalTxFRdPtrInc  : std_logic;
-- Internal TxFIFO Pointer increment signal 

signal LocalRxFWr        : std_logic;
-- Internal RxFIFO Write signal 

signal DelayRxFWr        : std_logic;
--  Delayed RxFIFO Write signal 

signal LocalRxFWrData    : std_logic_vector (15 downto 0);
-- Internal  RxFIFO Write Data  

signal DelayTxFRdPtrInc  : std_logic;
-- Delayed TxFIFO Pointer increment signal 

signal LocalSFRM         : std_logic;
-- Internal Serial Frame

signal NEWTITxEn         : std_logic;
-- New TI Transmit  Serial Frame

signal NEWTIRxEn         : std_logic;
-- New TI receive  Serial Frame

signal TxShft            : std_logic_vector (15 downto 0);
-- Transmit Shift register 

signal RxShft            : std_logic_vector (15 downto 0);
-- receive Shift register 

signal TxCount           : std_logic_vector (3 downto 0);       
-- Transmit Data  counter 

signal RxCount           : std_logic_vector (3 downto 0);       
-- Receive  Data  counter 

signal HDSS              : std_logic_vector (3 downto 0);
-- DSS divide by 2 value 

signal NWRDSS            : std_logic_vector (3 downto 0);
-- NW receive DSS  
signal NWTXEn            : std_logic;  
-- National microwire Transmit enable 

signal NWRXEn            : std_logic;  
-- National microwire Receive enable 

signal NewMSFRM          : std_logic;  
-- New Motorola Mode SFRM 

signal NewMRST           : std_logic;  
-- Reset for NewMSRM 

signal NewTXF            : std_logic;   
-- New Nmicrowire TXFlag 

signal SSPRXDIn          : std_logic;
-- Internal SSPRXD

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- ----------------------------------------------------------------------------
-- Local signal assignment
-- -----------------------------------------------------------------------------
iTxRxBSY    <= LocalTxRxBSY and SSTBESync ;
TxFRdPtrInc <= LocalTxFRdPtrInc;
RxFWr       <= LocalRxFWr;
RxFWrData   <= LocalRxFWrData;
HDSS        <= ('0' & DSS(3 downto 1)); 
NWRDSS      <= (unsigned(DSS) - 1); 
LocalSFRM   <= SFRM after 3 ns;
TxRxBSY     <= iTxRxBSY; 
ChkTxBSY    <= iChkTxBSY; 

-- -----------------------------------------------------------------------------
-- When SSP is disabled , drives zero on SSPXDIn , otherwise drives SSPRXD on
-- SSPRXDIn
-- -----------------------------------------------------------------------------
SSPRXDIn    <= '0'        when (OD = '1')
            else
                SSPRXD; 

-- ----------------------------------------------------------------------------
-- Tristate  TXD line - when there is no transmission
-- --------------------------------------------------------------------------- 
SSPTXD      <= LocalSSPTXD   when   ((iTxRxBSY = '1') and (not (FRF = "10")))
                                 or ((iTxRxBSY = '1') and (NWTxEn ='1'))
            else 
              'Z'; 

-- ---------------------------------------------------------------------------- 
-- Combinational process for SSPTrickbox BSY signal generation      
-- ----------------------------------------------------------------------------
p_BsyCombo: process(NEWTITxEn, NEWTIRxEn, FRF, LocalSFRM, SSPRXDIn)
begin
  if (FRF = "01") then
    LocalTxRxBSY <= NEWTITxEn and NEWTIRxEn;
    iChkTxBSY    <= NEWTITxEn and NEWTIRxEn;
  elsif (FRF = "00" or FRF = "10") then
    iChkTxBSY     <= not (LocalSFRM);
    if (not ((LocalSFRM = '1') and (SSPRXD = 'Z'))) then
      LocalTxRxBSY  <= '1';
    else
      LocalTxRxBSY  <= '0';
    end if; 
  else
    LocalTxRxBSY <= '0';
    iChkTxBSY    <= '0';
  end if;       
end process p_BsyCombo; 

-- ---------------------------------------------------------------------------- 
-- Combinational process for SSPTXD  
-- ----------------------------------------------------------------------------
p_TxdCombo: process(TxShft, TxFRdDataIn, NewMSFRM)
begin
  if (NewMSFRM = '1') then
    LocalSSPTXD <= TxFRdDataIn(15);
  else
    LocalSSPTXD <= TxShft(15);
  end if;
end process p_TxdCombo; 

-- ---------------------------------------------------------------------------- 
--  Main Transmission Logic . This process is sensetised to SCLK.  
-- ----------------------------------------------------------------------------
p_TxLogicSeq: process(SCLK, PRESETn, SSTBESync) 
begin
  if (PRESETn = '0') then
    LocalTxFRdPtrInc <= '0';
    DelayTxFRdPtrInc <= '0';
    NEWTITxEn        <= '0';
    NewMRST          <= '0'; 
    TxCount          <= "0000";
    TxShft           <= "0000000000000000";
    NWRXEn           <= '0';  
    NewTXF           <= '0';   
  -- When SSPTrickBox is disabled, Reset all the output signals. 
  elsif (SSTBESync = '0') then
    TxShft           <= "0000000000000000";
    TxCount          <= "0000";
    LocalTxFRdPtrInc <= '0';
    DelayTxFRdPtrInc <= '0';
    NEWTITxEn        <= '0';
    NWRXEn           <= '0';  
    NewTXF           <= '0';   
  else
  --  Transmission Logic 
    if (FRF = "01") then
    -- When Frame Format is TI Mode
      if (SCLK'event and SCLK = '1') then
        if ((LocalSFRM = '1') and (TxCount = "0000")) then
         -- When SFRM is high, load the Tx Data into the TX shift Register 
          NEWTITxEn           <= '1';
          TxShft(15 downto 0) <= TxFRdDataIn(15 downto 0); 
        elsif (TxCount = DSS) then
          -- When Tx Counter value equals DSS value and SFRM is high and load 
          -- Next Tx Data into Tx shift register.otherwise reset the Tx shift
          -- register.    
          if (LocalSFRM = '1') then
            NEWTITxEn           <= '1'; 
            TxCount             <= "0000";
            LocalTxFRdPtrInc    <= '1';
            TxShft(15 downto 0) <= TxFRdDataIn(15 downto 0); 
          else
            NEWTITxEn           <= '0'; 
            TxShft(15 downto 0) <="0000000000000000" ; 
            TxCount             <= "0000";
            LocalTxFRdPtrInc    <= '1';
          end if; 
        -- When Tx counter is half the DSS vaule ,then TxFIFO Read Ptr is set  
        elsif (TxCount = HDSS) then 
          TxCount             <= (unsigned(TxCount) + 1);
          TxShft(15 downto 1) <= TxShft(14 downto 0); 
          TxShft(0)           <= '0';
          LocalTxFRdPtrInc <= '1';
        elsif ( NEWTITxEn = '1') then
          TxCount             <= (unsigned(TxCount) + 1);
          TxShft(15 downto 1) <= TxShft(14 downto 0); 
          TxShft(0)           <= '0';
        end if;
      end if;
    end if; 
      -- When frame Format is  Motorola Mode.
      -- In this mode, first bit is transmitted ,Immmediately when SFRM 
      -- becomes low.   
    if (FRF = "00") then
      -- SPI -"00"-mode 
      if ((SPH = '0') and (SPO = '0')) then  
        if (SCLK'event and SCLK = '0') then
          if (LocalSFRM = '0') then
           -- When Tx counter becomes the DSS value, reset the Tx counter    
            if (TxCount = DSS) then
              TxCount             <= "0000"; 
              TxShft(15 downto 0) <= TxFRdDataIn(15 downto 0); 
              -- TxShft           <= "0000000000000000";
            -- When Tx counter is half the DSS vaule, TxFiFO Read Ptr is set  
            elsif (TxCount = HDSS) then
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxShft(14 downto 0);
              TxShft(0)           <= '0';
              LocalTxFRdPtrInc    <= '1';
            elsif (NewMSFRM = '1') then
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxFRdDataIn(14 downto 0);
              TxShft(0)           <= '0';
              NewMRST             <= '1'; 
            else
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxShft(14 downto 0);
              TxShft(0)           <= '0';
              NewMRST             <= '0'; 
            end if;
          end if;
        end if;
          -- SPI mode -"01" 
      elsif ((SPH = '0') and (SPO = '1')) then 
        if (SCLK'event and SCLK = '1') then
          if (LocalSFRM = '0') then
            if (TxCount = DSS) then
              TxCount             <= "0000"; 
              TxShft(15 downto 0) <= TxFRdDataIn(15 downto 0); 
            -- When Tx counter is half of the DSS vaule, then TxFIFO Read Ptr 
            -- is set  
            elsif (TxCount = HDSS) then
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxShft(14 downto 0);
              TxShft(0)           <= '0';
              LocalTxFRdPtrInc    <= '1';
            elsif  (NewMSFRM = '1') then
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxFRdDataIn(14 downto 0);
              TxShft(0)           <= '0';
              NewMRST             <= '1'; 
            else
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxShft(14 downto 0);
              TxShft(0)           <= '0';
              NewMRST             <= '0'; 
            end if;
          end if;
        end if;
        -- SPIMode  - "10" 
      elsif ((SPH = '1') and (SPO = '0')) then 
        if (SCLK'event and SCLK = '1') then
          if (LocalSFRM = '0') then
            if (TxCount = DSS) then
              TxCount             <= "0000"; 
              TxShft(15 downto 0) <= TxFRdDataIn(15 downto 0); 
            -- When Tx counter is half the DSS vaule, TxFIFO Read Ptr is set  
            elsif (TxCount = HDSS) then
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxShft(14 downto 0);
              TxShft(0)           <= '0';
              LocalTxFRdPtrInc <= '1';
            elsif  (NewMSFRM = '1') then
              TxShft(15 downto 0) <= TxFRdDataIn(15 downto 0);
              NewMRST             <= '1'; 
            else
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxShft(14 downto 0);
              TxShft(0)           <= '0';
              NewMRST             <= '0'; 
            end if;
          end if;
        end if;
        -- SPIMode -"11"
      elsif ((SPH = '1') and (SPO = '1')) then 
        if (SCLK'event and SCLK = '0') then
          if (LocalSFRM = '0') then
            if (TxCount = DSS) then
              TxCount             <= "0000"; 
              TxShft(15 downto 0) <= TxFRdDataIn(15 downto 0); 
            -- When Tx Counter is Half the DSS Vaule, TxFIFO Read Ptr is set  
            elsif (TxCount = HDSS) then
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxShft(14 downto 0);
              TxShft(0)           <= '0';
              LocalTxFRdPtrInc <= '1';
            elsif  (NewMSFRM = '1') then
              TxShft(15 downto 0) <= TxFRdDataIn(15 downto 0);
              NewMRST             <= '1'; 
            else
              TxCount             <= (unsigned(TxCount) + 1);
              TxShft(15 downto 1) <= TxShft(14 downto 0);
              TxShft(0)           <= '0';
              NewMRST             <= '0'; 
            end if;
          end if;
        end if;
      end if; 
    end if; 
    -- When the frame format is NationalMicrowire Mode 
    if (FRF = "10") then
      if (SCLK'event and SCLK = '0') then
        if (LocalSFRM = '0') then
          -- When National microwire Tx is enabled, and it is the first bit
          -- to be transmitted , Then load the Tx data into Tx shift Register.
          -- and disable  the NWRXEn bit.  
          if (NWTXEn = '1') and (NewTXF = '0') then
            TxShft(15 downto 0) <= TxFRdDataIn(15 downto 0); 
            NWRXEn              <= '0'; 
            NewTXF              <= '1';
          -- when the Tx count equals the DSS vaule , Reset  the TxCount,  
          -- Tx shift Register and NewTx Flag.  
          elsif (TxCount = DSS) then
            TxCount <= "0000"; 
            TxShft  <= "0000000000000000";
            NewTXF  <= '0';   
          -- When the Tx count equals the one less than DSS vaule , 
          -- then set  the NWRxEn Bit. 
          -- Tx shift Register  
          elsif (TxCount = NWRDSS) then
            TxCount             <= (unsigned(TxCount) + 1);
            TxShft(15 downto 1) <= TxShft(14 downto 0);
            TxShft(0)           <= '0';
            NWRXEn <= '1';  
        -- When Tx Counter is Half the DSS Vaule ,then TxFiFO Read Ptr is set  
          elsif (TxCount = HDSS) then
            TxCount             <= (unsigned(TxCount) + 1);
            TxShft(15 downto 1) <= TxShft(14 downto 0);
            TxShft(0)           <= '0';
            LocalTxFRdPtrInc    <= '1';
          elsif (NewTXF = '1') then 
            TxCount <= (unsigned(TxCount) + 1);
            TxShft(15 downto 1) <= TxShft(14 downto 0);
            TxShft(0)           <= '0';
          end if;
        end if;
      end if;
    end if;
   -- Reset the TX FIFORdPtrInc ,when the TX Count becomes Zero.  
    if (SCLK'event and SCLK = '1') then
      if (LocalTxFRdPtrInc = '1') and (TxCount = "0000") then
        LocalTxFRdPtrInc <=  '0';
      end if;
    end if;
  end if;
end process p_TxLogicSeq;

-- -----------------------------------------------------------------------------
-- Receive Logic
-- -----------------------------------------------------------------------------
p_RxLogicSeq: process(SCLK, PRESETn, SSTBESync) 
begin
  if (PRESETn = '0') then
    LocalRxFWr     <= '0';
    DelayRxFWr     <= '0';
    LocalRxFWrData <= "0000000000000000";
    RxShft         <= "0000000000000000" ;
    RxCount        <= "0000" ;
    NEWTIRxEn      <= '0';
    NWTXEn         <= '0'; 
  -- When SSPTrickBox is disabled , Then Reset the all output signals. 
  elsif (SSTBESync = '0') then
    LocalRxFWr     <= '0';
    DelayRxFWr     <= '0';
    LocalRxFWrData <= "0000000000000000";
    RxShft         <= "0000000000000000" ;
    RxCount        <= "0000" ;
    NEWTIRxEn      <= '0';
    NWTXEn         <= '0';  
    else
     -- When the frame format is TI mode 
      if (FRF ="01") then
        if (SCLK'event and SCLK = '0') then
          if (LocalSFRM = '1' and RxCount = "0000") then
            NEWTIRxEn <= '1';
          -- When Rx counter becomes DDS value , transfer the Rx shift register 
          -- along with last bit into Rx FIFO write data register.  
          elsif (RxCount = DSS) then 
            if (LocalSFRM = '1') then
              NEWTIRxEn      <= '1'; 
              RxCount        <= "0000";
              LocalRxFWrData <= (RxShft(14 downto 0) & SSPRXDIn);
              RxShft         <= "0000000000000000" ;
              LocalRxFWr     <= '1';  
            else
              NEWTIRxEn      <= '0'; 
              RxCount        <= "0000";
              LocalRxFWrData <= (RxShft(14 downto 0) & SSPRXDIn);
              RxShft         <= "0000000000000000" ;
              LocalRxFWr     <= '1';  
            end if; 
          elsif (NEWTIRxEn = '1') then 
            RxShft(0)            <=  SSPRXDIn ;
            RxCount              <= (unsigned(RxCount) + 1);
            RxShft(14 downto 1)  <= RxShft(13 downto 0) ;
          end if;
        end if;
      end if; 
      -- when the  frame format is Motorola Mode 
      if (FRF = "00") then
        -- SPI -"00"
        if ((SPH = '0') and (SPO = '0')) or 
           ((SPH = '1') and (SPO = '1')) then
          if (SCLK'event and SCLK = '1') then
            if (LocalSFRM = '0') then
              RxShft(0)  <=  SSPRXDIn ;
          -- When Rx counter becomes DDS value , transfer the Rx shift register 
          -- along with last bit into Rx FIFO write data register.  
              if (RxCount = DSS) then
                RxCount        <= "0000";
                LocalRxFWrData <= (RxShft(14 downto 0) & SSPRXDIn);
                RxShft         <= "0000000000000000" ;
                LocalRxFWr     <= '1';  
              else
                RxCount              <= (unsigned(RxCount) + 1);
                RxShft(14 downto 1)  <= RxShft(13 downto 0) ;
              end if; 
            end if; 
          end if;
        elsif ((SPH = '0') and (SPO = '1')) or 
               ((SPH = '1') and (SPO = '0')) then
          if (SCLK'event and SCLK = '0') then
            if (LocalSFRM = '0') then
              RxShft(0)  <=  SSPRXDIn ;
          -- When Rx counter becomes DDS value , transfer the Rx shift register 
          -- along with last bit into Rx FIFO write data register.  
              if (RxCount = DSS) then
                RxCount        <= "0000";
                LocalRxFWrData <= (RxShft(14 downto 0) & SSPRXDIn);
                RxShft         <= "0000000000000000" ;
                LocalRxFWr     <= '1';  
              else
                RxCount              <= (unsigned(RxCount) + 1);
                RxShft(14 downto 1)  <= RxShft(13 downto 0) ;
              end if; 
            end if; 
          end if;
        end if;
      end if;
     -- When the frame format is National microwire  
      if (FRF = "10") then
        if (SCLK'event and SCLK = '1') then
          if (LocalSFRM = '0') then
            if (NWRXEn = '1') then
              NWTxEn <= '0';
            end if;
            if (NwTxEn <= '0') then   
              RxShft(0)  <=  SSPRXDIn ;
              if (RxCount = NWDSS) then
                NWTXEn         <= '1';  
                RxCount        <= "0000";
                LocalRxFWrData <= RxShft(15 downto 0) ;
                RxShft         <= "0000000000000000" ;
                LocalRxFWr     <= '1';  
              else
                RxCount              <= (unsigned(RxCount) + 1);
                RxShft(14 downto 1)  <= RxShft(13 downto 0) ;
              end if; 
            end if; 
          end if; 
        end if;
      end if;
    if (LocalRxFWr = '1') and (DelayRxFWr = '0') then
      DelayRxFWr <= '1';
    end if;   
    if ((LocalRxFWr = '1') and (DelayRxFWr = '1') ) then
      DelayRxFWr  <= '0';
      LocalRxFWr  <= '0';            
    end if;
  end if; 
end process p_RxLogicSeq;

-- -----------------------------------------------------------------------------
-- NewSFRM generation for Motorola Mode 
-- -----------------------------------------------------------------------------
p_seqNewMSFRM: process(SFRM, PRESETn, NewMRST, SSTBESync)
begin
  if ((PRESETn = '0') or (NewMRST = '1')) then
    NewMSFRM <= '0'; 
  elsif (SSTBESync = '0') then
    NewMSFRM <= '0'; 
  elsif (SFRM'event and SFRM = '0') then
    if (FRF = "00") then
      NewMSFRM <= '1'; 
    end if;  
  end if;                 
end process p_seqNewMSFRM;

end behavioural;

-- ================================ End ======================================--
 
