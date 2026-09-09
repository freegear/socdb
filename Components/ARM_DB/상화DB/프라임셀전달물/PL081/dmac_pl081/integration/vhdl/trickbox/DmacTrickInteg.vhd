-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacTrickInteg.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is the top level of the Dmac.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.DmacTrPackage.all;

-- -----------------------------------------------------------------------------

entity DmacTrickInteg is
  port (
-- Inputs
        -- Clock and reset
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB reset
        -- AHB slave signals
        HSELDMACTr       : in    std_logic; -- Trickbox Select from AHB3
        HWRITE           : in    std_logic; -- Transfer direction
        HTRANS           : in    std_logic; -- Type of transfer on AHB
                                            -- Only HTRANS(1) of the 
                                            -- slave AHB should connect
        HADDR            : in    std_logic_vector(20 downto 2);
                                            -- AHB address bus
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- The width of the transfer on
                                            -- AHB3
        HREADYIN         : in    std_logic; -- Transfer done response on AHB
        HREADYINM        : in    std_logic; -- Transfer done response on AHB
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB slave write data
        -- AHB master signals
        HBUSREQDMAM      : in    std_logic; -- Bus request signal to the
                                            -- AHB arbiter 
        HLOCKDMAM        : in    std_logic; -- Indicates locked-burst
                                            -- request on AHB 
        HTRANSM          : in    std_logic_vector(1 downto 0);
                                            -- Type of transfer on AHB
        HADDRM           : in    std_logic_vector(31 downto 0);
                                            -- AHB1 address bus
        HSIZEM           : in    std_logic_vector(2 downto 0);
                                            -- Width of transfer on AHB
        HBURSTM          : in    std_logic_vector(2 downto 0);
                                            -- Burst length on AHB
        HPROTM           : in    std_logic_vector(3 downto 0);
                                            -- Protection information on AHB
        HWRITEM          : in    std_logic; -- Transfer direction on AHB
        HWDATAM          : in    std_logic_vector(31 downto 0);
                                            -- Write data on AHB
-- Outputs
        -- AHB master signals
        HREADYOUT        : out   std_logic; -- Transfer done response for AHB3
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Transfer response for AHB3
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read Data for AHB 3
        HGRANTDMAM       : out   std_logic; -- AHB bus grant for master
        HRESPM           : out   std_logic_vector(1 downto 0);
                                            -- Transfer response for AHB
        HREADYOUTM       : out   std_logic; -- Transfer done response for AHB
        HRDATAM          : out   std_logic_vector(31 downto 0)
                                            -- Read Data for AHB Master
       );
end DmacTrickInteg;

-- -----------------------------------------------------------------------------
--
--                              DmacTrickInteg
--                              ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the Trickbox. This block instantiates the
-- following functional sub-blocks in the trickbox.
--      - DmacTrBehaviour
--      - DmacTrProChkr
--      - DmacTrPeriph
--      - DmacTrMem
--      - DmacTrGntGen
--
-- -----------------------------------------------------------------------------
 
 
-- --=========================== ARCHITECTURE ================================--
 
architecture structural of DmacTrickInteg is
 
-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component DmacTrMem
  port (
        HCLK              : in    std_logic;
        HRESETn           : in    std_logic;
        HADDR             : in    std_logic_vector
                                            (SLAVEADDRHB downto SLAVEADDRLB);
        HSELREG           : in    std_logic;
        HWRITE            : in    std_logic;
        HTRANS            : in    std_logic_vector(1 downto 0);
        HSIZE             : in    std_logic_vector(2 downto 0);
        HWDATA            : in    std_logic_vector(31 downto 0);
        HREADYIN          : in    std_logic;
        HADDRM            : in    std_logic_vector
                                            (MASTERADDRHB downto MASTERADDRLB);
        HSELMEM           : in    std_logic;
        HWRITEM           : in    std_logic;
        HTRANSM           : in    std_logic_vector(1 downto 0);
        HBURSTM           : in    std_logic_vector(2 downto 0);
        HSIZEM            : in    std_logic_vector(2 downto 0);
        HWDATAM           : in    std_logic_vector(31 downto 0);
        HREADYINM         : in    std_logic;
        HREADYOUT         : out   std_logic;
        HRESP             : out   std_logic_vector(1 downto 0);
        HRDATA            : out   std_logic_vector(31 downto 0);
        HREADYOUTM        : out   std_logic;
        HRESPM            : out   std_logic_vector( 1 downto 0);
        HRDATAM           : out   std_logic_vector(31 downto 0)
       );
end component;

component DmacTrAhbArb
  port (
        HCLK              : in    std_logic;
        HRESETn           : in    std_logic;
        HREADYINM         : in    std_logic;
        HBUSREQDMAM       : in    std_logic;
        HBURSTM           : in    std_logic_vector(2 downto 0);
        HLOCKDMAM         : in    std_logic;
        HGRANTDMAM        : out   std_logic
        );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Signal declarations
-- ----------------------------------------------------------------------------
signal iHRDATAM         : std_logic_vector(31 downto 0);
signal iHRESPM          : std_logic_vector(1 downto 0);
signal iHREADYOUTM      : std_logic;

signal iHREADYOUT       : std_logic;
signal iHRDATA          : std_logic_vector(31 downto 0);
signal iHRESP           : std_logic_vector(1 downto 0);

signal HTRANSInt        : std_logic_vector(1 downto 0);
signal ReqConfig        : std_logic_vector(17 downto 0);

-- Memory Module signal
signal HSELREGuM0       : std_logic;
signal HREADYOUTuM0     : std_logic;
signal HRESPuM0         : std_logic_vector(1 downto 0);
signal HRDATAuM0        : std_logic_vector(31 downto 0);
signal HADDRMuM0        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
signal HSELMEMuM0       : std_logic;
signal HWRITEMuM0       : std_logic;
signal HTRANSMuM0       : std_logic_vector(1 downto 0);
signal HSIZEMuM0        : std_logic_vector(2 downto 0);
signal HBURSTMuM0       : std_logic_vector(2 downto 0);
signal HWDATAMuM0       : std_logic_vector(31 downto 0);
signal HREADYINMuM0     : std_logic;
signal HREADYOUTMuM0    : std_logic;
signal HRESPMuM0        : std_logic_vector(1 downto 0);
signal HRDATAMuM0       : std_logic_vector(31 downto 0);

signal RegSyncMem0      : std_logic;

signal SyncMem0         : std_logic;

signal NxtRegSyncMem0   : std_logic;

signal NxtSyncMem0      : std_logic;

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
 
HTRANSInt        <= HTRANS & '0';

HSELREGuM0       <= '1' when (HADDR(20 downto 16) = "00001"
                                                    and HSELDMACTr = '1')
                 else
                    '0';


HSELMEMuM0       <= '1';

-- -----------------------------------------------------------------------------
-- Instantiation of Memory module 
-- -----------------------------------------------------------------------------
uM0DmacTrMem : DmacTrMem
  port map (
            HCLK            => HCLK,
            HRESETn         => HRESETn,
            HADDR           => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG         => HSELREGuM0,
            HWRITE          => HWRITE,
            HTRANS          => HTRANSInt,
            HSIZE           => HSIZE,
            HWDATA          => HWDATA,
            HREADYIN        => HREADYIN,
            HREADYOUT       => HREADYOUTuM0,
            HRESP           => HRESPuM0,
            HRDATA          => HRDATAuM0,
            HADDRM          => HADDRMuM0,
            HSELMEM         => HSELMEMuM0,
            HWRITEM         => HWRITEMuM0,
            HTRANSM         => HTRANSMuM0,
            HBURSTM         => HBURSTMuM0,
            HSIZEM          => HSIZEMuM0,
            HWDATAM         => HWDATAMuM0,
            HREADYINM       => HREADYINMuM0,
            HREADYOUTM      => HREADYOUTMuM0,
            HRESPM          => HRESPMuM0,
            HRDATAM         => HRDATAMuM0
           );

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Instantiation of AHB arbiter for AHB 
-- -----------------------------------------------------------------------------
u2DmacTrAhbArb : DmacTrAhbArb
  port map (
            HCLK            => HCLK,
            HRESETn         => HRESETn,
            HREADYINM       => HREADYINM,
            HBUSREQDMAM     => HBUSREQDMAM,
            HBURSTM         => HBURSTM,
            HLOCKDMAM       => HLOCKDMAM,
            HGRANTDMAM      => HGRANTDMAM
           );

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Control Information Latching Block 
-- -----------------------------------------------------------------------------
p_ControlInfoComb : process (ReqConfig, HSELMEMuM0, HADDRM, HWRITEM, HSIZEM, 
                             HBURSTM, HTRANSM, HREADYINM, SyncMem0) 
begin
  NxtSyncMem0              <= SyncMem0; 

  if (HSELMEMuM0 = '1') then
    HADDRMuM0        <= HADDRM(MASTERADDRHB downto MASTERADDRLB);
    HWRITEMuM0       <= HWRITEM;
    HTRANSMuM0       <= HTRANSM;
    HSIZEMuM0        <= HSIZEM;
    HBURSTMuM0       <= HBURSTM;
    HREADYINMuM0     <= HREADYINM;
  else
    HADDRMuM0        <= (others =>'0');
    HWRITEMuM0       <= '0';
    HTRANSMuM0       <= (others =>'0');
    HSIZEMuM0        <= (others =>'0');
    HBURSTMuM0       <= (others =>'0');
    HREADYINMuM0     <= '0';
  end if;
        
  if (HREADYINM = '1') then
    if (HSELMEMuM0 = '1') then
      NxtSyncMem0      <= '1';
    else
      NxtSyncMem0      <= '0';
    end if;
  end if;

end process p_ControlInfoComb;

-- -----------------------------------------------------------------------------
-- Sync Sequential Block 
-- -----------------------------------------------------------------------------
p_SyncSeq  : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SyncMem0          <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SyncMem0          <= NxtSyncMem0;
  end if;
end process p_SyncSeq;

-- -----------------------------------------------------------------------------
-- Read Write Data assignment Block
-- -----------------------------------------------------------------------------
p_DataComb : process (SyncMem0, HREADYOUTMuM0, HRESPMuM0, HRDATAMuM0,
                      HWDATAM, ReqConfig, HRESETn )
begin   
  if (HRESETn = '0') then
    iHREADYOUTM        <= '1';
    iHRESPM            <= (others => '0');
    iHRDATAM           <= (others => '0');

  end if; 

  if (SyncMem0 = '1') then
    HWDATAMuM0       <= HWDATAM;
    iHREADYOUTM      <= HREADYOUTMuM0;
    iHRESPM          <= HRESPMuM0;
    iHRDATAM         <= HRDATAMuM0;
  else
    HWDATAMuM0       <= (others => '0');
  end if;

end process p_DataComb;

-- -----------------------------------------------------------------------------
-- RegSync Generation Block  
-- -----------------------------------------------------------------------------
p_RegAssignComb  : process(HSELREGuM0, RegSyncMem0)
begin
  NxtRegSyncMem0   <= RegSyncMem0;

  if (HSELREGuM0 = '1') then
    NxtRegSyncMem0   <= '1';
  else
    NxtRegSyncMem0   <= '0';
  end if; 
    
end process p_RegAssignComb; 

-- -----------------------------------------------------------------------------
-- RegSync Sequential Block  
-- -----------------------------------------------------------------------------
p_RegSeq  : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegSyncMem0       <= '0';
  elsif (HCLK'event and HCLK = '1') then
    RegSyncMem0       <= NxtRegSyncMem0;
  end if;
end process p_RegSeq;

-- -----------------------------------------------------------------------------
-- Read Write Data combo block.
-- -----------------------------------------------------------------------------
p_RegDataComb : process(RegSyncMem0, HREADYOUTuM0, HRESPuM0, HRDATAuM0, HRESETn)
begin
    
  if (HRESETn = '0') then
    iHREADYOUT     <= '1';
    iHRESP         <= (others => '0');
    iHRDATA        <= (others => '0');
  end if;

  if (RegSyncMem0 = '1') then
    iHREADYOUT     <= HREADYOUTuM0;
    iHRESP         <= HRESPuM0;
    iHRDATA        <= HRDATAuM0;
  end if;

end process p_RegDataComb;

-- -----------------------------------------------------------------------------
-- Assigning the internal signals to the outputs
-- -----------------------------------------------------------------------------
HREADYOUT        <= iHREADYOUT;       
HRESP            <= iHRESP;
HRDATA           <= iHRDATA;
HREADYOUTM       <= iHREADYOUTM;       
HRESPM           <= iHRESPM;
HRDATAM          <= iHRDATAM;

end structural;
 
-- --================================== End ==================================--
