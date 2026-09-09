-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name              : SspTrTxLJustify.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
-- Purpose      : This block takes right-justified read data from the
--                Transmit FIFO and drives out the data left-justified. 
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrTxLJustify is
  port (
        PCLK        : in  std_logic;	                 -- APB bus clock
        PRESETn     : in  std_logic;	                 -- APB bus Reset 
        FRF         : in  std_logic_vector(1 downto 0);  -- Frame format
        DSS         : in  std_logic_vector(3 downto 0);  -- Data size
        MS          : in  std_logic;                     -- Master/Slave select
        TxFRdData   : in  std_logic_vector(15 downto 0); -- From FIFO
        TxFRdDataIn : out std_logic_vector(15 downto 0)  -- To TxRx block
       );
end SspTrTxLJustify;

-- -----------------------------------------------------------------------------
--
--                               SspTrTxLJustify
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  Transmit data written into the transmit FIFO is right justified. In order
-- to facilitate shifting out of data by the transmit state machine, the
-- transmit data is left-justified and driven. The unused bottom bits in the
-- 16-bit data output, is filled with zeros.
--
--  For example, a 4-bit transmit data is stored in the transmit FIFO in the
-- form :
--
--        0  0  0  0  0  0  0  0  0  0  0  0 d3 d2 d1 d0
--
--
-- In the SspTrTxJustify module,this data is left-justfied and driven out in the
-- form :
--
--        d3 d2 d1 d0 0  0  0  0  0  0  0  0  0  0  0  0
--
--   The case of National Microwire Frame format is a special case, in that the
-- transmit data is always 8-bit wide and is independent of the DSS[3:0] (Data
-- Size Select) field in the SSCR0 control register.
--
-- In addition to the functionality described above, the loopback feature is
-- also implemented in this module. When the LBM signal is asserted, the data
-- on the SSPTXD line is driven out on the SSPRXDIn output line. If the LBM
-- signal is de-asserted, the SSPRXD input is routed to the SSPRXDIn output
-- line.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--
 
architecture behavioural of SspTrTxLJustify is

-- -----------------------------------------------------------------------------
-- constant declarations
-- -----------------------------------------------------------------------------
constant ZEROFILL         : std_logic_vector(15 downto 0) :=
                              "0000000000000000";
-- 16-bit Zero vector to zero-fill unused bits in TxFRdDataIn
 
-- -----------------------------------------------------------------------------
-- signal declarations 
-- -----------------------------------------------------------------------------
signal iTxFRdDataIn       : std_logic_vector(15 downto 0);
-- Internal copy of TxFRdDataIn

signal NextTxFRdDataIn    : std_logic_vector(15 downto 0);
-- D-input of TxFRdDataIn

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
 
begin

-- -----------------------------------------------------------------------------
-- Assign local copies to output ports
-- -----------------------------------------------------------------------------
TxFRdDataIn <= iTxFRdDataIn;

-- -----------------------------------------------------------------------------
-- Generate TxFRdDataIn by filling the top bits with significant bits from
-- TxFRdData and by zero-filling the remaining lower order bits.
-- If the Trickbox is programmed to test the Slave interface in the SSP and if 
-- the Frame format is National Microwire, then ignore DSS and use a fixed
-- transmit data width of 8 bits.
-- -----------------------------------------------------------------------------
p_LJustComb : process (TxFRdData, FRF, DSS, iTxFRdDataIn, MS)
begin
  NextTxFRdDataIn <= iTxFRdDataIn;
  if (FRF = "10" and MS = '1') then
    NextTxFRdDataIn <= TxFRdData(7 downto 0) & ZEROFILL(7 downto 0);
  else
    case DSS is
      when "0011" =>
        NextTxFRdDataIn <= TxFRdData(3 downto 0) & ZEROFILL(11 downto 0);
      when "0100" =>
        NextTxFRdDataIn <= TxFRdData(4 downto 0) & ZEROFILL(10 downto 0);
      when "0101" =>
        NextTxFRdDataIn <= TxFRdData(5 downto 0) & ZEROFILL(9 downto 0);
      when "0110" =>
        NextTxFRdDataIn <= TxFRdData(6 downto 0) & ZEROFILL(8 downto 0);
      when "0111" =>
        NextTxFRdDataIn <= TxFRdData(7 downto 0) & ZEROFILL(7 downto 0);
      when "1000" =>
        NextTxFRdDataIn <= TxFRdData(8 downto 0) & ZEROFILL(6 downto 0);
      when "1001" =>
        NextTxFRdDataIn <= TxFRdData(9 downto 0) & ZEROFILL(5 downto 0);
      when "1010" =>
        NextTxFRdDataIn <= TxFRdData(10 downto 0) & ZEROFILL(4 downto 0);
      when "1011" =>
        NextTxFRdDataIn <= TxFRdData(11 downto 0) & ZEROFILL(3 downto 0);
      when "1100" =>
        NextTxFRdDataIn <= TxFRdData(12 downto 0) & ZEROFILL(2 downto 0);
      when "1101" =>
        NextTxFRdDataIn <= TxFRdData(13 downto 0) & ZEROFILL(1 downto 0);
      when "1110" =>
        NextTxFRdDataIn <= TxFRdData(14 downto 0) & ZEROFILL(0);
      when "1111" =>
        NextTxFRdDataIn <= TxFRdData(15 downto 0);
      when others =>
        NextTxFRdDataIn <= (others => '0');
    end case;
  end if;
end process p_LJustComb;

-- -----------------------------------------------------------------------------
-- Sequential process for TxFRdDataIn generation 
-- -----------------------------------------------------------------------------
p_LJustSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iTxFRdDataIn <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    iTxFRdDataIn <= NextTxFRdDataIn;
  end if;
end process p_LJustSeq;
end behavioural;

-- --========================= End ===========================================--





