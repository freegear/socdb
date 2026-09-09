-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SciTrick.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This module is the top level SCI trickbox
--
-- --=========================================================================--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;

--------------------------------------------------------------------------------

entity SciTrick is
  port (
        -- APB bus signals
        PCLK            : in    std_logic;
        PRESETn         : in    std_logic;
        PENABLE         : in    std_logic;
        PSELT           : in    std_logic;
        PWRITE          : in    std_logic;
        PADDR           : in    std_logic_vector(7 downto 2);
        PWData          : in    std_logic_vector(15 downto 0);
        PRData          : out   std_logic_vector(15 downto 0);

        -- Reference clock for the Sci
        SCICLK          : out    std_logic;

        -- Reset and Function Code Bit signal to Sci  
        nSCIRST         : out    std_logic;
     
        -- Card Detect signal to SCI
        SCIDETECT       : out    std_logic;
      
        -- Card control signals 
        SCIVCCEN        : in std_logic;
        nSCICARDRST     : in std_logic;
        SCIFCB          : in std_logic;

        -- Sci Data Signals 
        SCICLKOUT       : out std_logic;            
        SCICLKIN        : in  std_logic;
        SCIDATAOUT      : out std_logic; 
        SCIDATAIN       : in  std_logic; 
 
        -- SCI Interrupt signals 
        SCICARDININTR   : in   std_logic;
        SCICARDOUTINTR  : in   std_logic;
        SCICARDUPINTR   : in   std_logic;
        SCICARDDNINTR   : in   std_logic;
        SCITXERRINTR    : in   std_logic;
        SCIATRSTOUTINTR : in   std_logic;
        SCIATRDTOUTINTR : in   std_logic;
        SCIBLKTOUTINTR  : in   std_logic;
        SCICHTOUTINTR   : in   std_logic;
        SCITXTIDEINTR   : in   std_logic;
        SCIRXTIDEINTR   : in   std_logic;
        SCIRTOUTINTR    : in   std_logic;
        SCIRORINTR      : in   std_logic;
        SCICLKSTPINTR   : in   std_logic;
        SCICLKACTINTR   : in   std_logic;
        SCIINTR         : in   std_logic;
    
        -- PMU signals
        SCIDEACACK      : in     std_logic; 
        SCIDEACREQ      : out    std_logic;
-- DMA Interface signals
        SCITXDMASREQ    : in     std_logic; -- Transmit DMA single request
        SCITXDMABREQ    : in     std_logic; -- Transmit DMA burst  request
        SCIRXDMASREQ    : in     std_logic; -- Receive  DMA single request
        SCIRXDMABREQ    : in     std_logic; -- Receive  DMA burst  request
        SCITXDMACLR     : out    std_logic; -- Transmit DMA request clear
        SCIRXDMACLR     : out    std_logic  -- Receive DMA request clear
       );

end SciTrick;

-- -----------------------------------------------------------------------------
--
--                                  SspTrick
--                                  ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module instantiates the following sub-modules:
--
-- 1.  SciTrApbif       - APB Interface
-- 2.  SciTrRxFIFO      - Receive FIFO
-- 3.  SciTrTxFIFO      - Transmit FIFO 
-- 4.  SciTrREFCLKGen   - Clock generation module
-- 5.  SciTrMux         - Output mux
-- 6.  SciTrTimCheck    - Time checker
-- 7.  SciTrSynctoRFCLK - Synchronisers for signals crossing into RFCLK domain
-- 8.  SciTrSynctoPCLK  - Synchronisers for signals crossing into PCLK domain
-- 9.  SciTrRegBlk      - Register block
-- 10. SciTrRegBlkUpd   - Register update block
-- 11. SciTrTXCntl      - Transmiter
-- 12. SciTrRXCntl      - Receiver 

-- -----------------------------------------------------------------------------
 
-- ============================== ARCHITECTURE ===============================--
 
architecture structural of SciTrick is
 
--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------

component SciTrApbif 
port (
      PCLK             : in    std_logic;
      PRESETn          : in    std_logic;
      PSELT            : in    std_logic;
      PENABLE          : in    std_logic;
      PWRITE           : in    std_logic;
      PADDR            : in    std_logic_vector(7 downto 2);	
      PWDATA           : in    std_logic_vector(15 downto 0);
      RxFRdData        : in    std_logic_vector(8 downto 0);
      SCITrCR          : in    std_logic_vector(15 downto 0);
      SCITrFiLCR       : in    std_logic_vector(7 downto 0);
      SCITrCTRL        : in    std_logic_vector(7 downto 0);
      SCITrTXPC        : in    std_logic_vector(3 downto 0);
      SCITrRXPC        : in    std_logic_vector(3 downto 0);
      SCITrTFF         : in    std_logic;	
      SCITrTFE         : in    std_logic;	
      SCITrTFR         : in    std_logic;
      SCITrRFF         : in    std_logic;
      SCITrRFE         : in    std_logic;
      SCITrRFR         : in    std_logic;
      SCIDEACACK       : in    std_logic;
      SCITrAT          : in    std_logic_vector(15 downto 0);
      SCITrDT          : in    std_logic_vector(15 downto 0);	
      SCITrTXBLKG      : in    std_logic_vector(7 downto 0);
      SCITrTXCHG       : in    std_logic_vector(7 downto 0);
      SCITrCKICC       : in    std_logic_vector(15 downto 0);
      SCITrBAUD        : in    std_logic_vector(15 downto 0);
      SCITrVALUE       : in    std_logic_vector(7 downto 0);	
      SCITrRXCHG       : in    std_logic_vector(7 downto 0);
      SCITrRXBLKG      : in    std_logic_vector(7 downto 0);
      SCITrRFCK        : in    std_logic_vector(15 downto 0);
      SCITrWV          : in    std_logic_vector(7 downto 0);
      SCITrJit         : in    std_logic_vector(15 downto 0);
      SCITrJitPat      : in    std_logic_vector(9 downto 0);
      PCLKOn           : in    std_logic;     
      REFCLKOn         : in    std_logic;  
      SCICARDININTR    : in    std_logic;	
      SCICARDOUTINTR   : in    std_logic;
      SCICARDUPINTR    : in    std_logic;
      SCICARDDNINTR    : in    std_logic;
      SCITXERRINTR     : in    std_logic;
      SCIATRSTOUTINTR  : in    std_logic;
      SCIATRDTOUTINTR  : in    std_logic;
      SCIBLKTOUTINTR   : in    std_logic;
      SCICHTOUTINTR    : in    std_logic;
      SCITXTIDEINTR    : in    std_logic;
      SCIRXTIDEINTR    : in    std_logic;
      SCIRTOUTINTR     : in    std_logic;
      SCIRORINTR       : in    std_logic;
      SCICLKSTPINTR    : in    std_logic;
      SCICLKACTINTR    : in    std_logic;
      SCIINTR          : in    std_logic;
      SCITXDMASREQ     : in    std_logic;
      SCITXDMABREQ     : in    std_logic;
      SCIRXDMASREQ     : in    std_logic;
      SCIRXDMABREQ     : in    std_logic;
      SCITrDATAWrEn    : out   std_logic;	
      SCITrCRWrEn      : out   std_logic;	
      SCITrFiLCRWrEn   : out   std_logic;
      SCITrTXPCWrEn    : out   std_logic;
      SCITrRXPCWrEn    : out   std_logic;
      SCITrCTRLWrEn    : out   std_logic;
      SCITrATWrEn      : out   std_logic;	
      SCITrDTWrEn      : out   std_logic;
      SCITrTXBLKGWrEn  : out   std_logic;
      SCITrTXCHGWrEn   : out   std_logic;
      SCITrCKICCWrEn   : out   std_logic;
      SCITrBAUDWrEn    : out   std_logic;
      SCITrVALUEWrEn   : out   std_logic;
      SCITrRXCHGWrEn   : out   std_logic;
      SCITrRXBLKGWrEn  : out   std_logic;
      SCITrRFCKWrEn    : out   std_logic;
      SCITrWVWrEn      : out   std_logic;
      SCITrJitWrEn     : out   std_logic;
      SCITrJitPatWrEn  : out   std_logic;
      SCITrRFCNTLWrEn  : out   std_logic;   
      RxFRdPtrInc      : out   std_logic;	
      PWDATAIn         : out   std_logic_vector(15 downto 0);
      PRDATA           : out   std_logic_vector(15 downto 0);	
      SCITrDMAWr       : out   std_logic
     );
end component;

component SciTrRegBlk 
port (
      PCLK             : in    std_logic;	
      PRESETn          : in    std_logic;	
      SCITrCRWrEn      : in    std_logic;	
      SCITrFiLCRWrEn   : in    std_logic;	
      SCITrTXPCWrEn    : in    std_logic;
      SCITrRXPCWrEn    : in    std_logic;
      SCITrCTRLWrEn    : in    std_logic;	
      SCITrATWrEn      : in    std_logic;	
      SCITrDTWrEn      : in    std_logic;	
      SCITrTXBLKGWrEn  : in    std_logic;	
      SCITrTXCHGWrEn   : in    std_logic;	
      SCITrCKICCWrEn   : in    std_logic;	
      SCITrBAUDWrEn    : in    std_logic;	
      SCITrVALUEWrEn   : in    std_logic;	
      SCITrRXCHGWrEn   : in    std_logic;	
      SCITrRXBLKGWrEn  : in    std_logic;	
      SCITrRFCKWrEn    : in    std_logic;	
      SCITrWVWrEn      : in    std_logic;	
      SCITrJitWrEn     : in    std_logic;	
      SCITrJitPatWrEn  : in    std_logic;	
      SCITrRFCNTLWrEn  : in    std_logic;
      SCITrDMAWr       : in    std_logic;
      SCITXDMACLRStag2 : in    std_logic;
      SCIRXDMACLRStag2 : in    std_logic;
      PWDATAIn         : in    std_logic_vector(15 downto 0);
      
      SCITrCR          : out   std_logic_vector(15 downto 0);	
      SCITrFiLCR       : out   std_logic_vector(7 downto 0);
      SCITrTXPC        : out   std_logic_vector(3 downto 0);	
      SCITrRXPC        : out   std_logic_vector(3 downto 0);	
      SCITrCTRL        : out   std_logic_vector(7 downto 0);	
      SCITrAT          : out   std_logic_vector(15 downto 0);	
      SCITrDT          : out   std_logic_vector(15 downto 0);	
      SCITrTXBLKG      : out   std_logic_vector(7 downto 0);	
      SCITrTXCHG       : out   std_logic_vector(7 downto 0);	
      SCITrCKICC       : out   std_logic_vector(15 downto 0);	
      SCITrBAUD        : out   std_logic_vector(15 downto 0);	
      SCITrVALUE       : out   std_logic_vector(7 downto 0);	
      SCITrRXCHG       : out   std_logic_vector(7 downto 0);	
      SCITrRXBLKG      : out   std_logic_vector(7 downto 0);	
      SCITrRFCK        : out   std_logic_vector(15 downto 0);	
      SCITrWV          : out   std_logic_vector(7 downto 0);	
      SCITrJit         : out   std_logic_vector(15 downto 0);	
      SCITrJitPat      : out   std_logic_vector(9 downto 0);	
      SCITrRFCNTL      : out   std_logic_vector(2 downto 0);	
      TrCRUpdate       : out   std_logic;	
      TrFiLCRUpdate    : out   std_logic;
      TrTXPCUpdate     : out   std_logic;
      TrRXPCUpdate     : out   std_logic;
      TrCTRLUpdate     : out   std_logic;
      TrATUpdate       : out   std_logic;
      TrDTUpdate       : out   std_logic;
      TrTXBGUpdate     : out   std_logic;
      TrTXCGUpdate     : out   std_logic;
      TrCKICUpdate     : out   std_logic;
      TrBAUDUpdate     : out   std_logic;
      TrVALUpdate      : out   std_logic;
      TrRXCGUpdate     : out   std_logic;
      TrRXBGUpdate     : out   std_logic;	
      TrJitUpdate      : out   std_logic;	
      TrJitPUpdate     : out   std_logic;
      SCITDMACR        : out   std_logic_vector(1 downto 0)
     );
end component;

component SciTrRegBlkUpd 
port (
      SCICLK           : in    std_logic;	
      PRESETn          : in    std_logic;	
      TrCRUpdSync      : in    std_logic;	
      TrTXPCUpdSync    : in    std_logic;
      TrRXPCUpdSync    : in    std_logic;
      TrCTRLUpdSync    : in    std_logic;	
      TrATUpdSync      : in    std_logic;	
      TrDTUpdSync      : in    std_logic;	
      TrTXBLKGUpdSync  : in    std_logic;	
      TrTXCHGUpdSync   : in    std_logic;	
      TrCKICCUpdSync   : in    std_logic;	
      TrBAUDUpdSync    : in    std_logic;	
      TrVALUEUpdSync   : in    std_logic;	
      TrRXCHGUpdSync   : in    std_logic;	
      TrRXBLKGUpdSync  : in    std_logic;	
      TrJitUpdSync     : in    std_logic;	
      TrJitPatUpdSync  : in    std_logic;	
      SCITrCR          : in    std_logic_vector(15 downto 0);	
      SCITrTXPC        : in    std_logic_vector(3 downto 0);	
      SCITrRXPC        : in    std_logic_vector(3 downto 0);	
      SCITrCTRL        : in    std_logic_vector(7 downto 0);	
      SCITrAT          : in    std_logic_vector(15 downto 0);	
      SCITrDT          : in    std_logic_vector(15 downto 0);	
      SCITrTXBLKG      : in    std_logic_vector(7 downto 0);	
      SCITrTXCHG       : in    std_logic_vector(7 downto 0);	
      SCITrCKICC       : in    std_logic_vector(15 downto 0);	
      SCITrBAUD        : in    std_logic_vector(15 downto 0);	
      SCITrVALUE       : in    std_logic_vector(7 downto 0);	
      SCITrRXCHG       : in    std_logic_vector(7 downto 0);	
      SCITrRXBLKG      : in    std_logic_vector(7 downto 0);	
      SCITrJit         : in    std_logic_vector(15 downto 0);	
      SCITrJitPat      : in    std_logic_vector(9 downto 0);	
      SCICLKErEn       : out   std_logic;
      TXPtimErEn       : out   std_logic;
      TXPErEn          : out   std_logic;
      TXPtimWdErEn     : out   std_logic;
      RXPErEn          : out   std_logic;
      RXCtimErEn       : out   std_logic;
      RXBtimErEn       : out   std_logic;
      StartBitErEn     : out   std_logic;
      TrBoxEn          : out std_logic; 
      TrTXEn           : out std_logic; 
      TrRXEn           : out std_logic; 
      TrDebugEn        : out std_logic; 
      TrCDETEn         : out std_logic; 
      TrTXPEn          : out std_logic; 
      TrRXPEn          : out std_logic; 
      TrTXPStEn        : out std_logic;
      TrRXPStEn        : out std_logic;
      TrTXNAKEn        : out std_logic;
      TrRXNAKEn        : out std_logic;
      SCIDEACREQ       : out std_logic;
      TrDackREn        : out std_logic; 
      SCANMODE         : out std_logic; 
      nSCIRST          : out std_logic; 
      TrSENSE          : out std_logic; 
      TrSCICLKEn       : out std_logic; 
      TrRSyTXPC        : out   std_logic_vector(3 downto 0);	
      TrRSyRXPC        : out   std_logic_vector(3 downto 0);	
      TrRSyAT          : out   std_logic_vector(15 downto 0);	
      TrRSyDT          : out   std_logic_vector(15 downto 0);	
      TrTXRSyBLKG      : out   std_logic_vector(7 downto 0);	
      TrTXRSyCHG       : out   std_logic_vector(7 downto 0);	
      TrRSyCKICC       : out   std_logic_vector(15 downto 0);	
      TrRSyBAUD        : out   std_logic_vector(15 downto 0);	
      TrRSyVALUE       : out   std_logic_vector(7 downto 0);	
      TrRXRSyCHG       : out   std_logic_vector(7 downto 0);	
      TrRXRSyBLKG      : out   std_logic_vector(7 downto 0);
      TrRSyJit         : out   std_logic_vector(15 downto 0);
      TrRSyJitPat      : out   std_logic_vector(9 downto 0)
     );
end component;

component SciTrSynctoRFCLK 
port (
      SCICLK           :in    std_logic;	
      PRESETn          :in    std_logic;	
      TxDataAvlbl      :in    std_logic;	
      TrCRUpdate       :in    std_logic;	
      TrTXPCUpdate     :in    std_logic;	
      TrRXPCUpdate     :in    std_logic;	
      TrCTRLUpdate     :in    std_logic;	
      TrATUpdate       :in    std_logic;	
      TrDTUpdate       :in    std_logic;	
      TrTXBGUpdate     :in    std_logic;	
      TrTXCGUpdate     :in    std_logic;	
      TrCKICUpdate     :in    std_logic;	
      TrBAUDUpdate     :in    std_logic;	
      TrVALUpdate      :in    std_logic;	
      TrRXCGUpdate     :in    std_logic;	
      TrRXBGUpdate     :in    std_logic;	
      TrJitUpdate      :in    std_logic;	
      TrJitPUpdate     :in    std_logic;	
      TrCRUpdSync      :out   std_logic;	
      TrTXPCUpdSync    :out   std_logic;	
      TrRXPCUpdSync    :out   std_logic;	
      TrCTRLUpdSync    :out   std_logic;	
      TrATUpdSync      :out   std_logic;	
      TrDTUpdSync      :out   std_logic;	
      TrTXBLKGUpdSync  :out   std_logic;	
      TrTXCHGUpdSync   :out   std_logic;	
      TrCKICCUpdSync   :out   std_logic;	
      TrBAUDUpdSync    :out   std_logic;	
      TrVALUEUpdSync   :out   std_logic;	
      TrRXCHGUpdSync   :out   std_logic;	
      TrRXBLKGUpdSync  :out   std_logic;
      TrJitUpdSync     :out   std_logic;
      TrJitPatUpdSync  :out   std_logic;  
      TxDataAvlblSync  :out   std_logic	
     );
end component;

component SciTrSynctoPCLK 
port (
      TxFRdPtrInc      : in   std_logic;   
      RxFWr            : in   std_logic;       
      PCLK             : in   std_logic;       
      PRESETn          : in   std_logic;      
      TxFRdPtrIncSync  : out  std_logic;   
      RxFWrSync        : out  std_logic   
     );
end component;

component SciTrTxFIFO 
port (
      PCLK             : in    std_logic;	
      PRESETn          : in    std_logic;	
      SCIDRWr          : in    std_logic;	
      TxFRdPtrIncSync  : in    std_logic;	
      PWDATAIn         : in    std_logic_vector(7 downto 0);	
      TxSRLevel        : in    std_logic_vector(3 downto 0);
      SCITrTFR	       : out   std_logic;	
      TxDataAvlbl      : out   std_logic;	
      SCITrTFF	       : out   std_logic;	
      SCITrTFE	       : out   std_logic;	
      TxFRdData	       : out   std_logic_vector(7 downto 0)	
     );
end component;


component SciTrRxFIFO 
port (
      PCLK             : in    std_logic;	
      PRESETn          : in    std_logic;	
      RxFWrSync        : in    std_logic;	
      RxFRdPtrInc      : in    std_logic;	
      RxSRLevel        : in    std_logic_vector(3 downto 0);
      RxFWrData	       : in    std_logic_vector(8 downto 0);	
      SCITrRFR	       : out   std_logic;	
      SCITrRFE	       : out   std_logic;	
      SCITrRFF	       : out   std_logic;	
      RxFRdData	       : out   std_logic_vector(8 downto 0)	
     );
end component;

component SciTrREFCLKGen 
port (
      PCLK             : in    std_logic; 
      PRESETn          : in    std_logic;
      SCICLK           : out   std_logic;
      PCLKOn           : out   std_logic; 
      REFCLKOn         : out   std_logic; 
      SCITrRFCK        : in    std_logic_vector(15 downto 0);
      SCICLKOUT        : out   std_logic;
      SCITrCKICC       : in    std_logic_vector(15 downto 0);
      SCITrRFCNTL      : in    std_logic_vector(2 downto 0);
      TrSCICLKEn       : in    std_logic
     );
end component;

component SciTXCntl 
port (
      SCICLK           : in   std_logic;
      PRESETn          : in   std_logic;
      TrTxEnSync       : in   std_logic;
      TrTxPEnSync      : in   std_logic;
      TrTXPStSync      : in   std_logic;
      TrTXNAKSync      : in   std_logic;
      TrSENSE          : in   std_logic;
      TrRsyTXPC        : in   std_logic_vector(3 downto 0);
      TrRsyCHG         : in   std_logic_vector(7 downto 0);
      TrRsyBLKG        : in   std_logic_vector(7 downto 0);
      TrRsyJit         : in   std_logic_vector(15 downto 0);
      TrRsyJitPat      : in   std_logic_vector(9 downto 0);
      TrRSyBAUD        : in   std_logic_vector(15 downto 0); 
      TrRSyVALUE       : in   std_logic_vector(7 downto 0); 
      TXDataAvlblSync  : in   std_logic;
      TXShiftData      : in   std_logic_vector(7 downto 0);
      TXFRdPtrInc      : out  std_logic;
      SCIDATAOUT       : out  std_logic;
      SCIDATAIN        : in   std_logic;
      TXPtimError      : out  std_logic;
      TXPtimWdError    : out  std_logic;
      TXPError         : out  std_logic
     );
end component; 

component SciTrRXCntl 
port (
      SCICLK           : in   std_logic;   
      PRESETn          : in   std_logic;       
      TrRXEnSync       : in   std_logic;  
      TrRXPEnSync      : in   std_logic; 
      TrRXPStSync      : in   std_logic; 
      TrRsyRXPC        : in   std_logic_vector(3 downto 0);
      TrRsyCHG         : in   std_logic_vector(7 downto 0);
      TrRsyBLKG        : in   std_logic_vector(7 downto 0);
      SCIDATAIN        : in   std_logic;  
      SCIDATAOUT       : out  std_logic; 
      TrRXNAKSync      : in   std_logic;       
      TrSENSE          : in   std_logic;
      TrRSyBAUD        : in   std_logic_vector(15 downto 0);    
      TrRSyVALUE       : in   std_logic_vector(7 downto 0);   
      RXPError         : out  std_logic;
      RXCtimError      : out  std_logic;
      RXBtimError      : out  std_logic;
      StartBitError    : out  std_logic;
      RXShiftData      : out std_logic_vector(8 downto 0);
      RXFWr            : out std_logic      
    );
end component;
 
component SciTrMux 
port (
      SCICLK           :in    std_logic;   
      PRESETn          :in    std_logic;       
      TrTXEn           :in    std_logic;      
      TrRXEn           :in    std_logic;      
      SCIDATAIN        :in    std_logic;   
      TXSCIDATAIN      :out   std_logic;   
      RXSCIDATAIN      :out   std_logic;  
      TXSCIDATAOUT     :in    std_logic;  
      RXSCIDATAOUT     :in    std_logic;  
      SCIDATAOUT       :out   std_logic   
     );
end component;


component SciTrTimCheck 
port (
      SCICLK        : in  std_logic;    
      PRESETn       : in  std_logic;       
      SCIDATAOUT    : in  std_logic;
      SCICLKIN      : in  std_logic;
      DeBugOn       : in  std_logic;
      SCITrRFCK     : in  std_logic_vector(15 downto 0); 
      SCITrWV       : in  std_logic_vector(7 downto 0); 
      SCITrCKICC    : in  std_logic_vector(15 downto 0) := "0000000000000000";
      SCICLKErEn    : in  std_logic;
      TXPtimErEn    : in  std_logic;
      TXPErEn       : in  std_logic;
      TXPtimWdErEn  : in  std_logic;
      RXPErEn       : in  std_logic;
      RXCtimErEn    : in  std_logic;
      RXBtimErEn    : in  std_logic;
      StartBitErEn  : in  std_logic;
      TXPtimError   : in  std_logic;
      TXPtimWdError : in  std_logic;
      TXPError      : in  std_logic;
      RXPError      : in  std_logic;
      RXCtimError   : in  std_logic;
      RXBtimError   : in  std_logic;
      StartBitError : in  std_logic
     );
end component;

component SciTrDMA
 port (
    PCLK                : in    std_logic;
    PRESETn             : in    std_logic;
    SCITXDMACLRStag1	: in    std_logic;
    SCIRXDMACLRStag1	: in    std_logic;
    
    SCITXDMACLR         : out   std_logic;
    SCIRXDMACLR         : out   std_logic;
    SCITXDMACLRStag2	: out   std_logic;
    SCIRXDMACLRStag2	: out   std_logic 
 );
end component;

signal  StartBitError   : std_logic;
signal  iSCICLK         : std_logic;	
signal  TXSCIDATAIN     : std_logic;	
signal  RXSCIDATAIN     : std_logic;	
signal  TXSCIDATAOUT    : std_logic;	
signal  RXSCIDATAOUT    : std_logic;	
signal  SCITrDATAWrEn   : std_logic;	
signal  SCITrCRWrEn     : std_logic;	
signal  SCITrFiLCRWrEn  : std_logic;	
signal  SCITrTXPCWrEn   : std_logic;	
signal  SCITrRXPCWrEn   : std_logic;	
signal  SCITrCTRLWrEn   : std_logic;	
signal  SCITrATWrEn     : std_logic;	
signal  SCITrDTWrEn     : std_logic;	
signal  SCITrTXBLKGWrEn : std_logic;	
signal  SCITrTXCHGWrEn  : std_logic;	
signal  SCITrCKICCWrEn  : std_logic;	
signal  SCITrBAUDWrEn   : std_logic;	
signal  SCITrVALUEWrEn  : std_logic;	
signal  SCITrRXCHGWrEn  : std_logic;	
signal  SCITrRXBLKGWrEn : std_logic;	
signal  SCITrRFCKWrEn   : std_logic;	
signal  SCITrWVWrEn     : std_logic;	
signal  SCITrJitWrEn    : std_logic;	
signal  SCITrjitPatWrEn : std_logic;	
signal  SCITrRFCNTLWrEn : std_logic;
signal  PWDATAIn        : std_logic_vector(15 downto 0);	
signal  SCITrCR         : std_logic_vector(15 downto 0);	
signal  SCITrFiLCR      : std_logic_vector(7 downto 0);	
signal  SCITrTXPC       : std_logic_vector(3 downto 0);	
signal  SCITrRXPC       : std_logic_vector(3 downto 0);	
signal  SCITrCTRL       : std_logic_vector(7 downto 0);	
signal  SCITrAT         : std_logic_vector(15 downto 0);	
signal  SCITrDT         : std_logic_vector(15 downto 0);	
signal  SCITrTXBLKG     : std_logic_vector(7 downto 0);	
signal  SCITrTXCHG      : std_logic_vector(7 downto 0);	
signal  SCITrCKICC      : std_logic_vector(15 downto 0);	
signal  SCITrBAUD       : std_logic_vector(15 downto 0);	
signal  SCITrVALUE      : std_logic_vector(7 downto 0);	
signal  SCITrRXCHG      : std_logic_vector(7 downto 0);	
signal  SCITrRXBLKG     : std_logic_vector(7 downto 0);	
signal  SCITrRFCK       : std_logic_vector(15 downto 0);	
signal  SCITrWV         : std_logic_vector(7 downto 0);	
signal  SCITrJit        : std_logic_vector(15 downto 0);	
signal  SCITrJitPat     : std_logic_vector(9 downto 0);	
signal  SCITrRFCNTL     : std_logic_vector(2 downto 0);
signal  PCLKOn          : std_logic;
signal  REFCLKOn        : std_logic;
signal  TrCRUpdate      : std_logic;	
signal  TrFiLCRUpdate   : std_logic;	
signal  TrTXPCUpdate    : std_logic;
signal  TrRXPCUpdate    : std_logic;
signal  TrCTRLUpdate    : std_logic;	
signal  TrATUpdate      : std_logic;	
signal  TrDTUpdate      : std_logic;	
signal  TrTXBGUpdate    : std_logic;	
signal  TrTXCGUpdate    : std_logic;	
signal  TrCKICUpdate    : std_logic;	
signal  TrBAUDUpdate    : std_logic;	
signal  TrVALUpdate     : std_logic;	
signal  TrRXCGUpdate    : std_logic;	
signal  TrRXBGUpdate    : std_logic;	
signal  TrRFCKUpdate    : std_logic;	
signal  TrWVUpdate      : std_logic;	
signal  TrJitUpdate     : std_logic;	
signal  TrJitPUpdate    : std_logic;	
signal  TrCRUpdSync     : std_logic;
signal  TrTXPCUpdSync   : std_logic;
signal  TrRXPCUpdSync   : std_logic;
signal  TrCTRLUpdSync   : std_logic;
signal  TrATUpdSync     : std_logic;
signal  TrDTUpdSync     : std_logic;
signal  TrTXBLKGUpdSync : std_logic;
signal  TrTXCHGUpdSync  : std_logic;
signal  TrCKICCUpdSync  : std_logic;
signal  TrBAUDUpdSync   : std_logic;
signal  TrVALUEUpdSync  : std_logic;
signal  TrRXCHGUpdSync  : std_logic;
signal  TrRXBLKGUpdSync : std_logic;
signal  TrJitUpdSync    : std_logic;
signal  TrJitPatUpdSync : std_logic;
signal  TxFRdPtrIncSync : std_logic; 
signal  TxFRdPtrInc     : std_logic; 
signal  TxSRLevel       : std_logic_vector(3 downto 0); 
signal  SCITrTFR        : std_logic; 
signal  SCITrTFF        : std_logic; 
signal  SCITrTFE        : std_logic; 
signal  TxFRdData       : std_logic_vector(7 downto 0); 
signal  RxFWrSync       : std_logic; 
signal  RxFWr           : std_logic; 
signal  RxFRdPtrInc     : std_logic; 
signal  RxSRLevel       : std_logic_vector(3 downto 0); 
signal  RxFWrData       : std_logic_vector(8 downto 0); 
signal  SCITrRFR        : std_logic; 
signal  SCITrRFE        : std_logic; 
signal  SCITrRFF        : std_logic; 
signal  RxFRdData       : std_logic_vector(8 downto 0); 
signal  SCICLKErEn      : std_logic;
signal  TXPtimErEn      : std_logic;
signal  TXPErEn         : std_logic;
signal  TXPtimWdErEn    : std_logic;
signal  RXPErEn         : std_logic;
signal  RXCtimErEn      : std_logic;
signal  RXBtimErEn      : std_logic;
signal  StartBitErEn    : std_logic;
signal  TrBoxEn         : std_logic;
signal  TrTXEn          : std_logic;
signal  TrRXEn          : std_logic;
signal  TrDebugEn       : std_logic;
signal  TrTXPEn         : std_logic;
signal  TrRXPEn         : std_logic;
signal  TrTXPStEn       : std_logic;
signal  TrRXPStEn       : std_logic;
signal  TrTXNAKEn       : std_logic;
signal  TrRXNAKEn       : std_logic;
signal  TrSCIREQ        : std_logic;
signal  TrDackREn       : std_logic;
signal  TrSCANMEn       : std_logic;
signal  TrSENSE         : std_logic;
signal  TrSCICLKEn      : std_logic;
signal  TxDataAvlblSync : std_logic; 	
signal  TxDataAvlbl     : std_logic; 	
signal  TrRSyTXPC       : std_logic_vector(3 downto 0);
signal  TrRSyRXPC       : std_logic_vector(3 downto 0);
signal  TrRSyCTRL       : std_logic_vector(2 downto 0);
signal  TrRSyAT         : std_logic_vector(15 downto 0);
signal  TrRSyDT         : std_logic_vector(15 downto 0);
signal  TrTXRSyBLKG     : std_logic_vector(7 downto 0);
signal  TrTXRSyCHG      : std_logic_vector(7 downto 0);
signal  TrRSyCKICC      : std_logic_vector(15 downto 0);
signal  TrRSyBAUD       : std_logic_vector(15 downto 0);
signal  TrRSyVALUE      : std_logic_vector(7 downto 0);
signal  TrRXRSyCHG      : std_logic_vector(7 downto 0);
signal  TrRXRSyBLKG     : std_logic_vector(7 downto 0);
signal  TrRSyJit        : std_logic_vector(15 downto 0);
signal  TrRSyJitPat     : std_logic_vector(9 downto 0);
signal  TXPtimError     : std_logic;
signal  TXPtimWdError   : std_logic;
signal  TXPError        : std_logic;
signal  RXPError        : std_logic;
signal  RXCtimError     : std_logic;
signal  RXBtimError     : std_logic;
signal  TrTXPCnt        : std_logic_vector(2 downto 0);
signal  SCITrDMAWr      : std_logic;
signal  SCITDMACR       : std_logic_vector(1 downto 0);
signal  SCITXDMACLRStag2 : std_logic;
signal  SCIRXDMACLRStag2 : std_logic;
signal  SCANMODE        : std_logic;
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

SCICLK <= iSCICLK;

uSciTrApbif : SciTrApbif 
port map (
          PCLK              => PCLK, 
          PRESETn           => PRESETn, 
          PSELT             => PSELT, 
          PENABLE           => PENABLE, 
          PWRITE            => PWRITE, 
          PADDR             => PADDR, 
          PWDATA            => PWDATA, 
          RxFRdData         => RxFRdData, 
          SCITrCR           => SCITrCR, 
          SCITrFiLCR        => SCITrFiLCR, 
          SCITrCTRL         => SCITrCTRL, 
          SCITrTXPC         => SCITrTXPC, 
          SCITrRXPC         => SCITrRXPC, 
          SCITrTFF          => SCITrTFF, 
          SCITrTFE          => SCITrTFE, 
          SCITrTFR          => SCITrTFR, 
          SCITrRFF          => SCITrRFF, 
          SCITrRFE          => SCITrRFE, 
          SCITrRFR          => SCITrRFR, 
          SCIDEACACK        => SCIDEACACK,
          SCITrAT           => SCITrAT, 
          SCITrDT           => SCITrDT, 
          SCITrTXBLKG       => SCITrTXBLKG, 
          SCITrTXCHG        => SCITrTXCHG, 
          SCITrCKICC        => SCITrCKICC, 
          SCITrBAUD         => SCITrBAUD, 
          SCITrVALUE        => SCITrVALUE, 
          SCITrRXCHG        => SCITrRXCHG, 
          SCITrRXBLKG       => SCITrRXBLKG, 
          SCITrRFCK         => SCITrRFCK, 
          SCITrWV           => SCITrWV, 
          SCITrJit          => SCITrJit, 
          SCITrJitPat       => SCITrJitPat, 
          PCLKOn            => PCLKOn, 
          REFCLKOn          => REFCLKOn,
          SCICARDININTR     => SCICARDININTR, 
          SCICARDOUTINTR    => SCICARDOUTINTR, 
          SCICARDUPINTR     => SCICARDUPINTR, 
          SCICARDDNINTR     => SCICARDDNINTR, 
          SCITXERRINTR      => SCITXERRINTR, 
          SCIATRSTOUTINTR   => SCIATRSTOUTINTR, 
          SCIATRDTOUTINTR   => SCIATRDTOUTINTR, 
          SCIBLKTOUTINTR    => SCIBLKTOUTINTR, 
          SCICHTOUTINTR     => SCICHTOUTINTR, 
          SCITXTIDEINTR     => SCITXTIDEINTR, 
          SCIRXTIDEINTR     => SCIRXTIDEINTR, 
          SCIRTOUTINTR      => SCIRTOUTINTR, 
          SCIRORINTR        => SCIRORINTR,
          SCICLKSTPINTR     => SCICLKSTPINTR,
          SCICLKACTINTR     => SCICLKACTINTR,
          SCIINTR           => SCIINTR, 
          SCITXDMASREQ      => SCITXDMASREQ,
          SCITXDMABREQ      => SCITXDMABREQ,
          SCIRXDMASREQ      => SCIRXDMASREQ,
          SCIRXDMABREQ      => SCIRXDMABREQ,
          SCITrDATAWrEn     => SCITrDATAWrEn, 
          SCITrCRWrEn       => SCITrCRWrEn, 
          SCITrFiLCRWrEn    => SCITrFiLCRWrEn, 
          SCITrTXPCWrEn     => SCITrTXPCWrEn, 
          SCITrRXPCWrEn     => SCITrRXPCWrEn, 
          SCITrCTRLWrEn     => SCITrCTRLWrEn, 
          SCITrATWrEn       => SCITrATWrEn, 
          SCITrDTWrEn       => SCITrDTWrEn, 
          SCITrTXBLKGWrEn   => SCITrTXBLKGWrEn, 
          SCITrTXCHGWrEn    => SCITrTXCHGWrEn, 
          SCITrCKICCWrEn    => SCITrCKICCWrEn, 
          SCITrBAUDWrEn     => SCITrBAUDWrEn, 
          SCITrVALUEWrEn    => SCITrVALUEWrEn, 
          SCITrRXCHGWrEn    => SCITrRXCHGWrEn, 
          SCITrRXBLKGWrEn   => SCITrRXBLKGWrEn, 
          SCITrRFCKWrEn     => SCITrRFCKWrEn, 
          SCITrWVWrEn       => SCITrWVWrEn, 
          SCITrJitWrEn      => SCITrJitWrEn, 
          SCITrJitPatWrEn   => SCITrJitPatWrEn, 
          SCITrRFCNTLWrEn   => SCITrRFCNTLWrEn, 
          RxFRdPtrInc       => RxFRdPtrInc, 
          PWDATAIn          => PWDATAIn, 
          PRDATA            => PRDATA,
          SCITrDMAWr        => SCITrDMAWr
         );

uSciTrRegBlk : SciTrRegBlk 
port map (
          PCLK              => PCLK,           
          PRESETn           => PRESETn,           
          SCITrCRWrEn       => SCITrCRWrEn,    
          SCITrFiLCRWrEn    => SCITrFiLCRWrEn, 
          SCITrTXPCWrEn     => SCITrTXPCWrEn,  
          SCITrRXPCWrEn     => SCITrRXPCWrEn,  
          SCITrCTRLWrEn     => SCITrCTRLWrEn,  
          SCITrATWrEn       => SCITrATWrEn,    
          SCITrDTWrEn       => SCITrDTWrEn,    
          SCITrTXBLKGWrEn   => SCITrTXBLKGWrEn,  
          SCITrTXCHGWrEn    => SCITrTXCHGWrEn,   
          SCITrCKICCWrEn    => SCITrCKICCWrEn, 
          SCITrBAUDWrEn     => SCITrBAUDWrEn, 
          SCITrVALUEWrEn    => SCITrVALUEWrEn, 
          SCITrRXCHGWrEn    => SCITrRXCHGWrEn,   
          SCITrRXBLKGWrEn   => SCITrRXBLKGWrEn,  
          SCITrRFCKWrEn     => SCITrRFCKWrEn,  
          SCITrWVWrEn       => SCITrWVWrEn,  
          SCITrJitWrEn      => SCITrJitWrEn,  
          SCITrJitPatWrEn   => SCITrJitPatWrEn,  
          SCITrRFCNTLWrEn   => SCITrRFCNTLWrEn,  
          SCITrDMAWr        => SCITrDMAWr,
          SCITXDMACLRStag2  => SCITXDMACLRStag2,
          SCIRXDMACLRStag2  => SCIRXDMACLRStag2,
          PWDATAIn          => PWDATAIn,
          
          SCITrCR           => SCITrCR,        
          SCITrFiLCR        => SCITrFiLCR,     
          SCITrTXPC         => SCITrTXPC,      
          SCITrRXPC         => SCITrRXPC,      
          SCITrCTRL         => SCITrCTRL,      
          SCITrAT           => SCITrAT,        
          SCITrDT           => SCITrDT,        
          SCITrTXBLKG       => SCITrTXBLKG,      
          SCITrTXCHG        => SCITrTXCHG,       
          SCITrCKICC        => SCITrCKICC,     
          SCITrBAUD         => SCITrBAUD,      
          SCITrVALUE        => SCITrVALUE,     
          SCITrRXCHG        => SCITrRXCHG,       
          SCITrRFCK         => SCITrRFCK,      
          SCITrWV           => SCITrWV,      
          SCITrJit          => SCITrJit,      
          SCITrJitPat       => SCITrJitPat,      
          SCITrRFCNTL       => SCITrRFCNTL,      
          TrCRUpdate        => TrCRUpdate,     
          TrFiLCRUpdate     => TrFiLCRUpdate,  
          TrTXPCUpdate      => TrTXPCUpdate,   
          TrRXPCUpdate      => TrRXPCUpdate,   
          TrCTRLUpdate      => TrCTRLUpdate,   
          TrATUpdate        => TrATUpdate,     
          TrDTUpdate        => TrDTUpdate,     
          TrTXBGUpdate      => TrTXBGUpdate,   
          TrTXCGUpdate      => TrTXCGUpdate,    
          TrCKICUpdate      => TrCKICUpdate,  
          TrBAUDUpdate      => TrBAUDUpdate,   
          TrVALUpdate       => TrVALUpdate, 
          TrRXCGUpdate      => TrRXCGUpdate,    
          TrRXBGUpdate      => TrRXBGUpdate,   
          TrJitUpdate       => TrJitUpdate,   
          TrJitPUpdate      => TrJitPUpdate,
          SCITDMACR         => SCITDMACR
         );

uSciTrRegBlkUpd : SciTrRegBlkUpd 
port map (
          SCICLK            => iSCICLK, 
          PRESETn           => PRESETn, 
          TrCRUpdSync       => TrCRUpdSync, 
          TrTXPCUpdSync     => TrTXPCUpdSync, 
          TrRXPCUpdSync     => TrRXPCUpdSync, 
          TrCTRLUpdSync     => TrCTRLUpdSync, 
          TrATUpdSync       => TrATUpdSync, 
          TrDTUpdSync       => TrDTUpdSync, 
          TrTXBLKGUpdSync   => TrTXBLKGUpdSync, 
          TrTXCHGUpdSync    => TrTXCHGUpdSync, 
          TrCKICCUpdSync    => TrCKICCUpdSync, 
          TrBAUDUpdSync     => TrBAUDUpdSync, 
          TrVALUEUpdSync    => TrVALUEUpdSync, 
          TrRXCHGUpdSync    => TrRXCHGUpdSync, 
          TrRXBLKGUpdSync   => TrRXBLKGUpdSync, 
          TrJitUpdSync      => TrJitUpdSync, 
          TrJitPatUpdSync   => TrJitPatUpdSync, 
          SCITrCR           => SCITrCR, 
          SCITrTXPC         => SCITrTXPC, 
          SCITrRXPC         => SCITrRXPC, 
          SCITrCTRL         => SCITrCTRL, 
          SCITrAT           => SCITrAT, 
          SCITrDT           => SCITrDT, 
          SCITrTXBLKG       => SCITrTXBLKG, 
          SCITrTXCHG        => SCITrTXCHG, 
          SCITrCKICC        => SCITrCKICC, 
          SCITrBAUD         => SCITrBAUD, 
          SCITrVALUE        => SCITrVALUE, 
          SCITrRXCHG        => SCITrRXCHG, 
          SCITrRXBLKG       => SCITrRXBLKG, 
          SCITrJit          => SCITrJit, 
          SCITrJitPat       => SCITrJitPat, 
          SCICLKErEn        => SCICLKErEn,
          TXPtimErEn        => TXPtimErEn,
          TXPErEn           => TXPErEn,
          TXPtimWdErEn      => TXPtimWdErEn,
          RXPErEn           => RXPErEn,
          RXCtimErEn        => RXCtimErEn,
          RXBtimErEn        => RXBtimErEn,
          StartBitErEn      => StartBitErEn,
          TrBoxEn           => TrBoxEn,   
          TrTXEn            => TrTXEn,    
          TrRXEn            => TrRXEn,    
          TrDebugEn         => TrDebugEn, 
          TrCDETEn          => SCIDETECT,  
          TrTXPEn           => TrTXPEn,   
          TrRXPEn           => TrRXPEn,   
          TrTXPStEn         => TrTXPStEn,
          TrRXPStEn         => TrRXPStEn,
          TrTXNAKEn         => TrTXNAKEn,
          TrRXNAKEn         => TrRXNAKEn,
          SCIDEACREQ        => SCIDEACREQ,
          TrDackREn         => TrDackREn, 
          SCANMODE          => SCANMODE, 
          nSCIRST           => nSCIRST, 
          TrSENSE           => TrSENSE, 
          TrSCICLKEn        => TrSCICLKEn, 
          TrRSyTXPC         => TrRSyTXPC, 
          TrRSyRXPC         => TrRSyRXPC, 
          TrRSyAT           => TrRSyAT, 
          TrRSyDT           => TrRSyDT, 
          TrTXRSyBLKG       => TrTXRSyBLKG, 
          TrTXRSyCHG        => TrTXRSyCHG, 
          TrRSyCKICC        => TrRSyCKICC, 
          TrRSyBAUD         => TrRSyBAUD, 
          TrRSyVALUE        => TrRSyVALUE, 
          TrRXRSyCHG        => TrRXRSyCHG, 
          TrRXRSyBLKG       => TrRXRSyBLKG, 
          TrRSyJit          => TrRSyJit, 
          TrRSyJitPat       => TrRSyJitPat 
         );

uSciTrSynctoRFCLK : SciTrSynctoRFCLK 
port map (
          SCICLK          => iSCICLK, 
          PRESETn         => PRESETn, 
          TxDataAvlblSync => TxDataAvlblSync,	
          TxDataAvlbl     => TxDataAvlbl,	
          TrCRUpdate      => TrCRUpdate, 
          TrTXPCUpdate    => TrTXPCUpdate, 
          TrRXPCUpdate    => TrRXPCUpdate, 
          TrCTRLUpdate    => TrCTRLUpdate, 
          TrATUpdate      => TrATUpdate, 
          TrDTUpdate      => TrDTUpdate, 
          TrTXBGUpdate    => TrTXBGUpdate, 
          TrTXCGUpdate    => TrTXCGUpdate, 
          TrCKICUpdate    => TrCKICUpdate, 
          TrBAUDUpdate    => TrBAUDUpdate, 
          TrVALUpdate     => TrVALUpdate, 
          TrRXCGUpdate    => TrRXCGUpdate, 
          TrRXBGUpdate    => TrRXBGUpdate, 
          TrJitUpdate     => TrJitUpdate, 
          TrJitPUpdate    => TrJitPUpdate, 
          TrCRUpdSync     => TrCRUpdSync, 
          TrTXPCUpdSync   => TrTXPCUpdSync, 
          TrRXPCUpdSync   => TrRXPCUpdSync, 
          TrCTRLUpdSync   => TrCTRLUpdSync, 
          TrATUpdSync     => TrATUpdSync, 
          TrDTUpdSync     => TrDTUpdSync, 
          TrTXBLKGUpdSync => TrTXBLKGUpdSync, 
          TrTXCHGUpdSync  => TrTXCHGUpdSync, 
          TrCKICCUpdSync  => TrCKICCUpdSync, 
          TrBAUDUpdSync   => TrBAUDUpdSync, 
          TrVALUEUpdSync  => TrVALUEUpdSync, 
          TrRXCHGUpdSync  => TrRXCHGUpdSync, 
          TrRXBLKGUpdSync => TrRXBLKGUpdSync, 
          TrJitUpdSync    => TrJitUpdSync, 
          TrJitPatUpdSync => TrJitPatUpdSync 
         );

uSciTrSynctoPCLK : SciTrSynctoPCLK 
port map (
          TxFRdPtrInc     => TxFRdPtrInc, 
          RxFWr           => RxFWr,
          PCLK            => PCLK,
          PRESETn         => PRESETn,
          TxFRdPtrIncSync => TxFRdPtrIncSync,
          RxFWrSync       =>  RxFWrSync
         );

uSciTrTxFIFO : SciTrTxFIFO 
port map (
          PCLK	          => PCLK,	
          PRESETn         => PRESETn,	
          SCIDRWr         => SCITrDATAWrEn,	
          TxFRdPtrIncSync => TxFRdPtrIncSync,	
          PWDATAIn        => PWDATAIn(7 downto 0),
          TxSRLevel       => SCITrFiLCR(3 downto 0),
          SciTrTFR        => SciTrTFR,
          TxDataAvlbl     => TxDataAvlbl,
          SCITrTFF	  => SCITrTFF,	
          SCITrTFE        => SCITrTFE,
          TxFRdData	  => TxFRdData	
         );


uSciTrRxFIFO : SciTrRxFIFO 
port map (
          PCLK            => PCLK,	
          PRESETn         => PRESETn,	
          RxFWrSync       => RxFWrSync,
          RxFRdPtrInc     => RxFRdPtrInc,	
          RxSRLevel       => SCITrFiLCR(7 downto 4),
          RxFWrData       => RxFWrData,
          SciTrRFR        => SciTrRFR, 	
          SCITrRFE	  => SCITrRFE,	
          SCITrRFF	  => SCITrRFF,	
          RxFRdData       => RxFRdData	
         );

uSciTrREFCLKGen : SciTrREFCLKGen
port map (
          PCLK            => PCLK, 
          PRESETn         => PRESETn,
          SCICLK          => iSCICLK,
          PCLKOn          => PCLKOn,
          REFCLKOn        => REFCLKOn,
          SCITrRFCK       => SCITrRFCK,
          SCICLKOUT       => SCICLKOUT,
          SCITrCKICC      => SCITrCKICC,
          SCITrRFCNTL     => SCITrRFCNTL,
          TrSCICLKEn      => TrSCICLKEn
         );
 

uSciTXCntl : SciTXCntl
port map (
          SCICLK          => iSCICLK,  
          PRESETn         => PRESETn,
          TrTxEnSync      => TrTxEn,
          TrTxPEnSync     => TrTxPEn,
          TrTXPStSync     => TrTXPStEn,
          TrTXNAKSync     => TrTXNAKEn,
          TrSENSE         => TrSENSE,
          TrRSyTXPC       => TrRSyTxPC,
          TrRsyCHG        => TrTXRSyCHG,
          TrRsyBLKG       => TrTXRSyBLKG,
          TrRsyJit        =>  TrRsyJit,
          TrRsyJitPat     => TrRsyJitPat,
          TrRSyBAUD       => TrRSyBAUD,
          TrRSyVALUE      => TrRSyVALUE,
          TXDataAvlblSync => TXDataAvlblSync,
          TXShiftData     => TxFRdData, 
          TXFRdPtrInc     => TXFRdPtrInc,
          SCIDATAOUT      => TXSCIDATAOUT,
          SCIDATAIN       => TXSCIDATAIN,
          TXPtimError     => TXPtimError,
          TXPtimWdError   => TXPtimWdError,
          TXPError        => TXPError
         );
 
uSciTrRXCntl : SciTrRXCntl
port map (
          SCICLK          => iSCICLK,
          PRESETn         => PRESETn,
          TrRXEnSync      => TrRXEn, 
          TrRXPEnSync     => TrRXPEn,
          TrRXPStSync     => TrRXPStEn,
          TrRsyRXPC       => TrRsyRXPC,
          TrRsyCHG        => TrRXRSyCHG,
          TrRsyBLKG       => TrRXRSyBLKG,
          SCIDATAIN       => RXSCIDATAIN,
          SCIDATAOUT      => RXSCIDATAOUT,
          TrRXNAKSync     => TrRXNAKEn,
          TrSENSE         => TrSENSE,
          TrRSyBAUD       => TrRSyBAUD, 
          TrRSyVALUE      => TrRSyVALUE,
          RXPError        => RXPError,
          RXCtimError     => RXCtimError,
          RXBtimError     => RXBtimError,
          StartBitError   => StartBitError,
          RXShiftData     => RXFWrData,
          RXFWr           => RxFWr
         );

uSciTrMux : SciTrMux 
port map (
          SCICLK          => iSCICLK, 
          PRESETn         => PRESETn,
          TrTXEn          => TrTXEn,
          TrRXEn          => TrRXEn,
          SCIDATAIN       => SCIDATAIN,
          TXSCIDATAIN     => TXSCIDATAIN, 
          RXSCIDATAIN     => RXSCIDATAIN,
          TXSCIDATAOUT    => TXSCIDATAOUT,
          RXSCIDATAOUT    => RXSCIDATAOUT,
          SCIDATAOUT      => SCIDATAOUT
         );
 
uSciTrTimCheck :  SciTrTimCheck
port map (
          SCICLK          => iSCICLK,
          PRESETn         => PRESETn,
          SCIDATAOUT      => SCIDATAIN,  
          SCICLKIN        => SCICLKIN,
          DeBugOn         => TrDebugEn,
          SCITrRFCK       => SCITrRFCK,
          SCITrWV         => SCITrWV,
          SCITrCKICC      => SCITrCKICC,
          SCICLKErEn      => SCICLKErEn,
          TXPtimErEn      => TXPtimErEn,
          TXPErEn         => TXPErEn,
          TXPtimWdErEn    => TXPtimWdErEn,
          RXPErEn         => RXPErEn,
          RXCtimErEn      => RXCtimErEn,
          RXBtimErEn      => RXBtimErEn,
          StartBitErEn    => StartBitErEn,
          TXPtimError     => TXPtimError,  
          TXPtimWdError   => TXPtimWdError,
          TXPError        => TXPError,
          RXPError        => RXPError,
          RXCtimError     => RXCtimError,
          RXBtimError     => RXBtimError,
          StartBitError   => StartBitError
         );

  uSciTrDMA : SciTrDMA
  port map (

    PCLK                => PCLK,
    PRESETn             => PRESETn,
    SCITXDMACLRStag1	=> SCITDMACR(1),
    SCIRXDMACLRStag1	=> SCITDMACR(0),
    SCITXDMACLR         => SCITXDMACLR,
    SCIRXDMACLR         => SCIRXDMACLR,
    SCITXDMACLRStag2	=> SCITXDMACLRStag2,
    SCIRXDMACLRStag2	=> SCIRXDMACLRStag2
    );
  

end structural;

