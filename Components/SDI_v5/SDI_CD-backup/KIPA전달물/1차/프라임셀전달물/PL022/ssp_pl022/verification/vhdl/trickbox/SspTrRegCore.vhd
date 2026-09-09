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
--  File Name              : SspTrRegCore.vhd.rca
--  File Revision          : 1.2
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
-- Purpose      : This block contains the Registers in the SSPTrickBox
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrRegCore is
  port (
        PCLK             : in    std_logic;  -- APB bus clock
        PRESETn          : in    std_logic;  -- APB bus Reset 
        SSPTBCR0Wr       : in    std_logic;  -- Write enable for SSPTBCR0
        SSPTBCR1Wr       : in    std_logic;  -- Write enable for SSPTBCR1
        SSPTBCR2Wr       : in    std_logic;  -- Write enable for SSPTBCR2
        SSPTBSRWr        : in    std_logic;  -- Write enable for SSPTBSR
        SSPTBPREWr       : in    std_logic;  -- Write enable for SSPTBPRE
        SSPTBTDRWr       : in    std_logic;  -- Write enable for SSPTBTDR
        SSPTBRDRWr       : in    std_logic;  -- Write enable for SSPTBRDR
        SSPTBSETPINSWr   : in    std_logic;  -- Write enable for SSPTBSETPINS
        SSPTBCLKREGWr    : in    std_logic;  -- Write enable for SSPTBCLKREG
        SSPTBCLKREG1Wr   : in    std_logic;  -- Write enable for SSPTBCLKREG1
        SSPTBDMACRWrEn   : in    std_logic;  -- Write Enable for UTDMACR
        PWDATAIn         : in    std_logic_vector(15 downto 0);
                                             -- Int PWDATA
        SSPTXDMACLRStag4 : in    std_logic;  -- For UARTTXDMACLR
        SSPRXDMACLRStag4 : in    std_logic;  -- For UARTRXDMACLR
        CR0Update        : out   std_logic;  -- Update trigger of Cntl Reg0 
        CR1Update        : out   std_logic;  -- Update trigger of Cntl Reg1 
        SSPTBCR0         : out   std_logic_vector(15 downto 0);
                                             -- Cntl Reg0 
        SSPTBCR1         : out   std_logic_vector(5 downto 0);
                                             -- Cntl Reg1 
        SSPTBCR2         : out   std_logic_vector(10 downto 0);
                                             -- Cntl Reg2 
        SSPTBSR          : out   std_logic_vector(10 downto 0);
                                             -- SSPTBSR 
        SSPTBCLKREG      : out   std_logic_vector(15 downto 0) 
                                 := "0000000000000000";
                                	     -- SSPTBCLKREG 
        SSPTBCLKREG1     : out   std_logic_vector(15 downto 0) 
                                 := "0000000000000000";
                                             -- SSPTBCLKREG1
        SSPTBSETPINS     : out   std_logic_vector(6 downto 0);
                                             -- Clk Cntl Reg
        SSPTBPRE         : out   std_logic_vector(3 downto 0);
                                             -- Prescale Reg 
        SSPTDMACR        : out   std_logic_vector(1 downto 0)
                                             -- DMACR bits
       );
end SspTrRegCore;

-- -----------------------------------------------------------------------------
--
--                               SspTrRegCore
--                               ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This block contains the registers in the SSPTrickBox. The writable 
-- registers are SSPTBCR0, SSPTBCR1,SSPTBCR1,  SSPTBTDR, SSPTBRDR, SSPTBPRE,
-- SSPTBBCLREG, SSPTBSETPINS and SSPICR. 
-- Out of these, writes to SSPTBTDR go to the Transmit FIFO register. 
-- The entire contents of SSPTBCR0 and two bit of SSPTBCR1 need to be 
-- synchronised to the SSPCLK domain. These registers contain bit fields that 
-- need to remain coherent during the synchronisation process. Use of double 
-- synchronisation does not guarantee this. Hence, a two-buffer synchronisation
-- technique is used for synchronisation. The first stage required for this
-- technique is implemented in this module. In the case of SSPTBCR1, 2 bits need
-- to be synchronised to the SSPCLK domain. These bits are single-bit fields
-- and hence double sunchronisation is used to synchronise these bits to the
-- SSPCLK domain. 
-- The first buffer is written to, when the write enable input for the 
-- corresponding register is asserted. 
--
-- -----------------------------------------------------------------------------

-- ============================= ARCHITECTURE ================================--

architecture behavioural of SspTrRegCore  is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iSSPTBPRE               : std_logic_vector(3 downto 0);
-- SSPTBPRE 
  
signal NextSSPTBPRE            : std_logic_vector(3 downto 0);
-- D-input of iSSPTBPRE
  
signal iSSPTBCR0               : std_logic_vector(15 downto 0);
-- SSPTBCR0 First stage buffer

signal NextSSPTBCR0            : std_logic_vector(15 downto 0);
-- D-input of iSSPTBCR0

signal iSSPTBCR1               : std_logic_vector(5 downto 0);
-- SSPTBCR1 Register

signal iSSPTBCR2               : std_logic_vector(10 downto 0);
-- SSPTBCR2 Register

signal NextSSPTBCR1            : std_logic_vector(5 downto 0);
-- D-input of iSSPTBCR1

signal NextSSPTBCR2            : std_logic_vector(10 downto 0);
-- D-input of iSSPTBCR2

signal iSSPTBSR                : std_logic_vector(10 downto 0);
-- SSPTBSR First stage buffer

signal NextSSPTBSR             : std_logic_vector(10 downto 0);
-- D-input of iSSPTBSR

signal iSSPTBSETPINS           : std_logic_vector(6 downto 0);
-- SSPTBSETPINS First stage buffer

signal NextSSPTBSETPINS        : std_logic_vector(6 downto 0);
-- D-input of iSSPTBSETPINS

signal iSSPTBCLKREG            : std_logic_vector(15 downto 0) 
                                 := "0000000000000000";
-- SSPTBCLKREG First stage buffer

signal iSSPTBCLKREG1           : std_logic_vector(15 downto 0) 
                                 := "0000000000000000";
-- SSPTBCLKREG1 First stage buffer

signal NextSSPTBCLKREG         : std_logic_vector(15 downto 0) 
                                 := "0000000000000000";
-- D-input of iSSPTBCLKREG         

signal NextSSPTBCLKREG1        : std_logic_vector(15 downto 0) 
                                 := "0000000000000000";
-- D-input of iSSPTBCLKREG1        

signal iCR0Update              : std_logic;
-- Internal copy of CR0Update output

signal iCR1Update              : std_logic;
-- Internal copy of CR1Update output

signal NextCR0Update           : std_logic;
-- D-input of iCR0Update

signal NextCR1Update           : std_logic;
-- D-input of iCR1Update

signal SSPTXDMACLR             : std_logic;
-- SSPTXDMACLR

signal SSPRXDMACLR             : std_logic;
-- SSPRXDMACLR

signal NextSSPTXDMACLR           : std_logic;
-- D-input of TXDMACLR
  
signal NextSSPRXDMACLR           : std_logic;
-- D-input of RXDMACLR

-- -----------------------------------------------------------------------------
-- 
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Connect local copies to output signals
-- -----------------------------------------------------------------------------
-- SSPTBCR0
SSPTBCR0         <= iSSPTBCR0;

-- SSPTBCR1
SSPTBCR1         <= iSSPTBCR1;

-- SSPTBCR2
SSPTBCR2         <= iSSPTBCR2;

-- SSPTBSR
SSPTBSR          <= iSSPTBSR;

-- SSPTBSETPINS
SSPTBSETPINS     <= iSSPTBSETPINS;

-- SSPTBCLKREG
SSPTBCLKREG      <= iSSPTBCLKREG;

-- SSPTBCLKREG1
SSPTBCLKREG1     <= iSSPTBCLKREG1;

-- SSPTBPRE
SSPTBPRE         <= iSSPTBPRE;

 -- CROUpdate
CR0Update  <= iCR0Update;

 -- CR1Update
CR1Update  <= iCR1Update;

 -- SSPTXDMACLR
SSPTDMACR(0)     <= SSPTXDMACLR;

 -- SSPRXDMACLR 
SSPTDMACR(1)     <= SSPRXDMACLR;


-- -----------------------------------------------------------------------------
-- Clocked process for the registers in this block. 
-- -----------------------------------------------------------------------------
p_SSESeq: process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iSSPTBCR0        <= (others => '0');
    iSSPTBCR1        <= (others => '0');
    iSSPTBCR2        <= (others => '0');
    iSSPTBSR         <= (others => '0');
    iSSPTBSETPINS    <= (others => '0');
    iSSPTBPRE        <= (others => '0');
    iSSPTBCLKREG     <= (others => '0');
    iSSPTBCLKREG1    <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    iSSPTBCR1        <= NextSSPTBCR1;
    iSSPTBCR2        <= NextSSPTBCR2;
    iSSPTBCR0        <= NextSSPTBCR0;
    iSSPTBSR         <= NextSSPTBSR;
    iSSPTBSETPINS    <= NextSSPTBSETPINS;
    iSSPTBCLKREG     <= NextSSPTBCLKREG;
    iSSPTBCLKREG1    <= NextSSPTBCLKREG1;
    iSSPTBPRE        <= NextSSPTBPRE;
  end if;
end process p_SSESeq;

-- -----------------------------------------------------------------------------
-- Write interface for First stage buffer.
-- Write into the First stage buffers from the Data bus when the corresponding 
-- write enable signal is asserted. 
-- -----------------------------------------------------------------------------
p_RegComb: process (iSSPTBCR0, iSSPTBCR1,iSSPTBCR2, iSSPTBSR, iSSPTBSETPINS,
                    iSSPTBPRE, SSPTBSETPINSWr, SSPTBPREWr, SSPTBCR0Wr,
                    SSPTBCR1Wr, SSPTBCR2Wr, SSPTBSRWr, SSPTBCLKREGWr, 
                    SSPTBCLKREG1Wr, iSSPTBCLKREG,  iSSPTBCLKREG1, PWDATAIn)
begin
  if (SSPTBCR0Wr = '1') then
    NextSSPTBCR0 <= PWDATAIn;
  else 
    NextSSPTBCR0 <= iSSPTBCR0;
  end if;

  if (SSPTBCR1Wr = '1') then
    NextSSPTBCR1 <= PWDATAIn(5 downto 0);
  else 
    NextSSPTBCR1 <= iSSPTBCR1;
  end if;

  if (SSPTBCR2Wr = '1') then
    NextSSPTBCR2 <= PWDATAIn(10 downto 0);
  else 
    NextSSPTBCR2 <= iSSPTBCR2;
  end if;

  if (SSPTBSRWr = '1') then
    NextSSPTBSR <= PWDATAIn(10 downto 0);
  else 
    NextSSPTBSR <= iSSPTBSR;
  end if;

  if (SSPTBSETPINSWr = '1') then
    NextSSPTBSETPINS <= PWDATAIn(6 downto 0);
  else 
    NextSSPTBSETPINS <= iSSPTBSETPINS;
  end if;
  
  if (SSPTBCLKREGWr = '1') then
    NextSSPTBCLKREG <= PWDATAIn(15 downto 0);
  else 
    NextSSPTBCLKREG <= iSSPTBCLKREG;
  end if;
  
  if (SSPTBCLKREG1Wr = '1') then
    NextSSPTBCLKREG1 <= PWDATAIn(15 downto 0);
  else 
    NextSSPTBCLKREG1 <= iSSPTBCLKREG1;
  end if;
  
  if (SSPTBPREWr = '1') then
    NextSSPTBPRE <= PWDATAIn(3 downto 0);
  else 
    NextSSPTBPRE <= iSSPTBPRE;
  end if;
end process p_RegComb;

-- -----------------------------------------------------------------------------
-- The iCR0Update signal toggles with every write to the SSPCR0 register
-- -----------------------------------------------------------------------------
p_UpdtCR0Comb : process (iCR0Update, SSPTBCR0Wr)
begin
  NextCR0Update <= iCR0Update;
  if (SSPTBCR0Wr = '1') then
    NextCR0Update <= not(iCR0Update);
  end if;
end process p_UpdtCR0Comb;

-- -----------------------------------------------------------------------------
-- The iCR1Update signal toggles with every write to the SSPCR0 register
-- -----------------------------------------------------------------------------
p_UpdtCR1Comb : process (iCR1Update, SSPTBCR1Wr)
begin
  NextCR1Update <= iCR1Update;
  if (SSPTBCR1Wr = '1') then
    NextCR1Update <= not(iCR1Update);
  end if;
end process p_UpdtCR1Comb;

-- -----------------------------------------------------------------------------
-- Sequential process for iCR0Update
-- -----------------------------------------------------------------------------
p_UpdtCR0Seq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iCR0Update <= '0';
    iCR1Update <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iCR0Update <= NextCR0Update;
    iCR1Update <= NextCR1Update;
  end if;
end process p_UpdtCR0Seq;

-------------------------------------------------------------------------------
-- Clock PWDATAIn into SSPTDMACR when SSPTBDMACRWrEn is asserted, TX
-------------------------------------------------------------------------------
p_TXDMAComb : process (SSPTBDMACRWrEn,SSPTXDMACLR,PWDATAIn,SSPTXDMACLRStag4) 
begin
  NextSSPTXDMACLR <= SSPTXDMACLR;
 
  if (SSPTBDMACRWrEn = '1') then
    NextSSPTXDMACLR <= PWDATAIn(0);
  elsif(SSPTXDMACLRStag4 = '1') then
    NextSSPTXDMACLR <= '0';
  end if;
end process p_TXDMAComb;

-------------------------------------------------------------------------------
-- Sequential process for SSPTDMACR
-------------------------------------------------------------------------------
p_TXDMASeq :  process(PCLK, PRESETn) 
begin
  if (PRESETn = '0') then
    SSPTXDMACLR <=  '0';
  elsif (PCLK'event and PCLK = '1') then
    SSPTXDMACLR <= NextSSPTXDMACLR;
  end if;
end process p_TXDMASeq;

-------------------------------------------------------------------------------
-- Clock PWDATAIn into SSPTDMACR when SSPTBDMACRWrEn is asserted, RX
-------------------------------------------------------------------------------
p_RXDMAComb : process (SSPTBDMACRWrEn,SSPRXDMACLR,PWDATAIn,SSPRXDMACLRStag4) 
begin
  NextSSPRXDMACLR <= SSPRXDMACLR;
 
  if (SSPTBDMACRWrEn = '1') then
    NextSSPRXDMACLR <= PWDATAIn(1);
  elsif(SSPRXDMACLRStag4 = '1') then
    NextSSPRXDMACLR <= '0';
  end if;
end process p_RXDMAComb;

-------------------------------------------------------------------------------
-- Sequential process for SSPTDMACR
-------------------------------------------------------------------------------
p_RXDMASeq :  process(PCLK, PRESETn) 
begin
  if (PRESETn = '0') then
    SSPRXDMACLR <= '0';
  elsif (PCLK'event and PCLK = '1') then
    SSPRXDMACLR <= NextSSPRXDMACLR;
  end if;
end process p_RXDMASeq;

end behavioural;

-- --==============================  End  ====================================--

