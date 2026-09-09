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
--  File Name              : UartRegBlock.vhd.rca
--  File Revision          : 1.16
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

entity UartRegBlock is
  port (
        PCLK            : in  std_logic;      -- APB Bus Clock
        PRESETn         : in  std_logic;      -- AMBA Bus reset
        
        RXFRdPtrInc     : in  std_logic;      -- RX FIFO Read pointer Incr.
        PWDATAIn        : in  std_logic_vector(15 downto 0);
	                                      -- Data bus
        RXFRdData       : in  std_logic_vector(10 downto 8);
	                                      -- RX Stat bits
        
        UARTECRWrEn     : in  std_logic;      -- Write Enable for UARTECR
        UARTLCRHnewWrEn : in  std_logic;      -- Write Enable for LCRH_new   
        UARTILPRWrEn    : in  std_logic;      -- Write Enable for ILPR
        UARTCRnewWrEn   : in  std_logic;      -- Write Enable for UARTCR_new
        UARTICRWrEn     : in  std_logic;      -- Write Enable for UARTICR
        UARTIBRDWrEn    : in  std_logic;      -- Write Enable for UARTIBRD
        UARTFBRDWrEn    : in  std_logic;      -- Write Enable for UARTFBRD
        UARTIFLSWrEn    : in  std_logic;      -- Write Enable for UARTIFLS
        UARTIMSCWrEn    : in  std_logic;      -- Write Enable for UARTIMSC
        UARTDMACRWrEn   : in  std_logic;      -- Write Enable for UARTDMACR
        
        UARTOEIClr      : in  std_logic;      -- Overrun Error Int. Clr
        UARTRTRIS       : in  std_logic;      -- Receive Timeout Interrupt
        UARTRISerrSync  : in  std_logic_vector(2 downto 0);
                                              -- Raw error interrupts
        UARTRISmodSync  : in  std_logic_vector(3 downto 0);
                                              -- Raw modem interrupt status     
        UARTTXIClr      : in  std_logic;      -- UARTICR Tx int. Clr
        UARTRXIClr      : in  std_logic;      -- UARTICR Rx int. Clr
        
        LCRUpdate       : out std_logic;      -- LCR update trigger
        ILPRUpdate      : out std_logic;      -- ILPR update trigger
        FBRDUpdate      : out std_logic;      -- FBRD update trigger
       
        UARTICR         : out std_logic_vector(10 downto 0);
	                                      -- For Interrupt Clears
        RXSTATUS        : out std_logic_vector(2 downto 0);
	                                      -- RX Stat bits
        UARTLCRH        : out std_logic_vector(7 downto 0);
                                              -- 1st buffer
        UARTLCRM        : out std_logic_vector(7 downto 0);
	                                      -- 1st buffer
        UARTLCRL        : out std_logic_vector(7 downto 0);
                                              -- 1st buffer
        UARTILPR        : out std_logic_vector(7 downto 0);
	                                      -- 1st buffer
        UARTCR          : out std_logic_vector(15 downto 0);
	                                      -- CR bits       
        UARTIFLS        : out std_logic_vector(5 downto 0);
	                                      -- IFLS bits       
        UARTDMACR       : out std_logic_vector(2 downto 0);
	                                      -- DMACR bits
        UARTFBRD        : out std_logic_vector(5 downto 0);
                                              -- FBRD bits
        UARTIMSC        : out std_logic_vector(10 downto 0)
                                              -- modem mask bits
        );
end UartRegBlock;

--------------------------------------------------------------------------------
-- Purpose     : This block contains the normal mode registers for
-- the Uart.
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartRegBlock
--                   ============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This block contains the normal mode registers for the UART. Write data from
-- the PWDATAIn bus is clocked in when the appropriate write enable signal is
-- asserted. 
--  This block contains the first buffer in the 2-buffer synchronisation 
-- mechanism for the LCR. It also contains the first buffer for the
-- 2-buffer synchronisation mechanism for the ILPR.
--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartRegBlock  is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------
  signal iUARTLCRH        : std_logic_vector(7 downto 0);  
  -- 1st stage buffer for UARTLCRH. 

  signal NextLCRH         : std_logic_vector(7 downto 0); 
  -- D-input of iUARTLCRH

  signal iUARTLCRM        : std_logic_vector(7 downto 0);  
  -- 1st stage buffer for UARTLCRM

  signal NextLCRM         : std_logic_vector(7 downto 0);  
  -- D-input of iUARTLCRM

  signal iUARTLCRL        : std_logic_vector(7 downto 0);  
  -- 1st stage buffer for UARTLCRL

  signal NextLCRL         : std_logic_vector(7 downto 0);  
  -- D-input of iUARTLCRL

  signal iLCRUpdate       : std_logic;
  -- Internal copy of Update trigger for LCR registers

  signal NextLCRUpdate    : std_logic;
  -- D-input of iUpdateLCR

  signal iFBRDUpdate       : std_logic;
  -- Internal copy of Update trigger for FBRD register

  signal NextFBRDUpdate    : std_logic;
  -- D-input of iFBRDUpdate

  signal NextUARTFBRD     : std_logic_vector(5 downto 0);
  -- D-input of iUARTFBRD
  
  signal  iUARTFBRD       : std_logic_vector(5 downto 0);
  -- Internal copy of UARTFBRD
  
  signal iRXSTATUS        : std_logic_vector(2 downto 0);
  -- Receive Status bits

  signal NextRXSTATUS     : std_logic_vector(2 downto 0); 
  -- D-input of iRXSTATUS

  signal iUARTILPR        : std_logic_vector(7 downto 0);
  -- 1st stage buffer for UARTILPR

  signal NextILPR         : std_logic_vector(7 downto 0);
  -- D-input of iUARTILPR

  signal iILPRUpdate      : std_logic;
  -- Internal copy of update trigger for the UARTILPR register

  signal NextILPRUpdate   : std_logic;
  -- D-input of iUpdateILPR

  signal iUARTCR          : std_logic_vector(15 downto 0);
  -- UARTCR  

  signal NextUARTCR       : std_logic_vector(15 downto 0);
  -- D-input of UARTCR

  signal iUARTIFLS        : std_logic_vector(5 downto 0);
  -- UARTIFLS

  signal NextUARTIFLS     : std_logic_vector(5 downto 0);
  -- D-input of UARTIFLS
  
  signal iUARTDMACR       : std_logic_vector(2 downto 0);
  -- UARTDMACR

  signal NextUARTDMACR    : std_logic_vector(2 downto 0);
  -- D-input of UARTDMACR
  
  signal iUARTOEIC        : std_logic;
  -- UARTOEIC  (UARTICR(10))
  
  signal iUARTBEIC        : std_logic;
  -- UARTBEIC  (UARTICR(9))
  
  signal iUARTPEIC        : std_logic;
  -- UARTBEIC  (UARTICR(8))
  
  signal iUARTFEIC        : std_logic;
  -- UARTFEIC  (UARTICR(7))

  signal iUARTRTIC        : std_logic;
  -- UARTRTIC  (UARTICR(6))

  signal iUARTTXIC        : std_logic;
  -- UARTTXIC  (UARTICR(5))
  
  signal iUARTRXIC        : std_logic;
  -- UARTRXIC  (UARTICR(4))

  signal iUARTDCDIC       : std_logic;
  -- UARTDCDIC (UARTICR(2)

  signal iUARTDSRIC       : std_logic;
  -- UARTDSRIC (UARTICR(3)

  signal iUARTCTSIC       : std_logic;
  -- UARTCTSIC (UARTICR(1)

  signal iUARTRIIC        : std_logic;
  -- UARTRIIC (UARTICR(0)

  signal NextUARTOEIC     : std_logic;
  -- D-input of UARTOEIC

  signal NextUARTBEIC     : std_logic;
  -- D-input of UARTBEIC

  signal NextUARTPEIC     : std_logic;
  -- D-input of UARTPEIC

  signal NextUARTFEIC     : std_logic;
  -- D-input of UARTFEIC

  signal NextUARTRTIC     : std_logic;
  -- D-input of UARTRTIC

  signal NextUARTDCDIC    : std_logic;
  -- D-input of UARTDCDIC
  
  signal NextUARTDSRIC    : std_logic;
  -- D-input of UARTDSRIC
  
  signal NextUARTCTSIC    : std_logic;
  -- D-input of UARTCTSIC
  
  signal NextUARTRIIC     : std_logic;
  -- D-input of UARTRIIC
  
  signal NextUARTTXIC     : std_logic;
  -- D-input of UARTTXIC
  
  signal NextUARTRXIC     : std_logic;
  -- D-input of UARTRXIC

  
--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------
  
begin

-------------------------------------------------------------------------------
-- Copy the upper 3 bits of data read from the Receive FIFO into the RXSTATUS
-- register. 
-------------------------------------------------------------------------------
  p_RFStatComb : process(RXFRdPtrInc,UARTECRWrEn,RXFRdData,iRXSTATUS) 
  begin
    NextRXSTATUS   <= iRXSTATUS;
    if(UARTECRWrEn = '1') then
      NextRXSTATUS <= (others => '0');
    elsif(RXFRdPtrInc = '1') then
      NextRXSTATUS <= RXFRdData;
    end if;
  end process p_RFStatComb;

-------------------------------------------------------------------------------
-- Sequential process for Receive FIFO status. 
-------------------------------------------------------------------------------
  p_RFStatSeq : process(PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iRXSTATUS   <= (others => '0');
    elsif(PCLK'event and PCLK = '1') then
        iRXSTATUS <= NextRXSTATUS;
    end if;
  end process p_RFStatSeq;

-------------------------------------------------------------------------------
-- Combinational process for 1st stage buffers for LCR. When the respective
-- write enable input is asserted, copy the contents of the PWDATAIn bus into
-- the corresponding 1st stage buffer.
-------------------------------------------------------------------------------
  p_LCRComb: process(PWDATAIn,
                     iUARTLCRH,iUARTLCRM,iUARTLCRL, UARTIBRDWrEn,UARTLCRHnewWrEn ) 
  begin
    NextLCRH     <= iUARTLCRH;
    NextLCRM     <= iUARTLCRM;
    NextLCRL     <= iUARTLCRL;

    if(UARTLCRHnewWrEn = '1' ) then
      NextLCRH   <= PWDATAIn(7 downto 0);
    end if;

    if (UARTIBRDWrEn = '1') then
      NextLCRM   <= PWDATAIn(15 downto 8);
    else
      NextLCRM   <= iUARTLCRM;
    end if;

    if(UARTIBRDWrEn = '1') then
      NextLCRL   <= PWDATAIn(7 downto 0);
    end if;
  end process p_LCRComb;
  
-------------------------------------------------------------------------------
-- Sequential process for first stage buffers for LCR 
-------------------------------------------------------------------------------
  p_LCRSeq : process(PCLK, PRESETn) 
  begin
    if(PRESETn = '0') then
      iUARTLCRH      <= (others => '0');
      iUARTLCRM      <= (others => '0');
      iUARTLCRL      <= (others => '0');
    elsif(PCLK'event and PCLK = '1') then
        iUARTLCRH    <= NextLCRH;
        iUARTLCRM    <= NextLCRM;
        iUARTLCRL    <= NextLCRL;
    end if;
  end process p_LCRSeq;

-------------------------------------------------------------------------------
-- The iLCRUpdate signal toggles with every write into UARTLCRH.
-------------------------------------------------------------------------------
  p_UpdtLCRComb : process (iLCRUpdate,UARTLCRHnewWrEn)
  begin
    NextLCRUpdate <= iLCRUpdate;
    if (UARTLCRHnewWrEn = '1' ) then
      NextLCRUpdate <= not(iLCRUpdate);
    end if;
  end process p_UpdtLCRComb;

-------------------------------------------------------------------------------
-- Sequential process for iLCRUpdate.
-------------------------------------------------------------------------------
  p_UpdtLCRSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      iLCRUpdate   <= '0';
    elsif (PCLK'event and PCLK = '1') then
        iLCRUpdate <= NextLCRUpdate;
    end if;
  end process p_UpdtLCRSeq;


-------------------------------------------------------------------------------
-- The iFBRDUpdate signal toggles with every write into UARTFBRD.
-------------------------------------------------------------------------------
  p_UpdtFBRDComb : process (iFBRDUpdate, UARTFBRDWrEn)
  begin
    NextFBRDUpdate <= iFBRDUpdate;
    if (UARTFBRDWrEn = '1') then
      NextFBRDUpdate <= not(iFBRDUpdate);
    end if;
  end process p_UpdtFBRDComb;

-------------------------------------------------------------------------------
-- Sequential process for iFBRDUpdate.
-------------------------------------------------------------------------------
  p_UpdtFBRDSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      iFBRDUpdate   <= '0';
    elsif (PCLK'event and PCLK = '1') then
        iFBRDUpdate <= NextFBRDUpdate;
    end if;
  end process p_UpdtFBRDSeq;


---------------------------------------------------------------------
-- Clock PWDATAIn into UARTFBRD when UARTFBRDWrEn is asserted.
---------------------------------------------------------------------

  p_FBRDComb : process(UARTFBRDWrEn,iUARTFBRD,PWDATAIn) 
  begin
    NextUARTFBRD   <= iUARTFBRD;
    
    if(UARTFBRDWrEn = '1') then
      NextUARTFBRD <= PWDATAIn(5 downto 0);
    end if;
  end process p_FBRDComb;


---------------------------------------------------------------------
-- Sequential process for UARTFBRD
---------------------------------------------------------------------
  p_FBRDSeq :  process(PCLK, PRESETn) 
  begin
    if(PRESETn = '0') then
      iUARTFBRD   <= "000000";
    elsif(PCLK'event and PCLK = '1') then
        iUARTFBRD <= NextUARTFBRD;
    end if;
  end process p_FBRDSeq;

-------------------------------------------------------------------------------
-- Clock in PWDATAIn into ILPR when UARTILPRWrEn is asserted.
-------------------------------------------------------------------------------
  p_ILPRComb : process (UARTILPRWrEn, iUARTILPR, PWDATAIn)
  begin
    NextILPR   <= iUARTILPR;
    if(UARTILPRWrEn = '1') then
      NextILPR <= PWDATAIn(7 downto 0);
    end if;
  end process p_ILPRComb;

-------------------------------------------------------------------------------
-- Sequential process for ILPR first stage buffer
-------------------------------------------------------------------------------
  p_ILPSeq : process(PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTILPR    <= (others => '0');
    elsif(PCLK'event and PCLK = '1') then
        iUARTILPR  <= NextILPR;
    end if;
  end process p_ILPSeq;

-------------------------------------------------------------------------------
-- The iILPRUpdate signal toggles with every write to the UARTILPR register.
-------------------------------------------------------------------------------
  p_UpdtILPRComb : process (iILPRUpdate, UARTILPRWrEn)
  begin
    NextILPRUpdate   <= iILPRUpdate;
    if (UARTILPRWrEn = '1') then
      NextILPRUpdate <= not(iILPRUpdate);
    end if;
  end process p_UpdtILPRComb;

-------------------------------------------------------------------------------
-- Sequential process for iILPRUpdate
-------------------------------------------------------------------------------
  p_UpdtILPRSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      iILPRUpdate   <= '0';
    elsif (PCLK'event and PCLK = '1') then
        iILPRUpdate <= NextILPRUpdate;
    end if;
  end process p_UpdtILPRSeq;

-------------------------------------------------------------------------------
-- Clock PWDATAIn into UARTCR when UARTCRWrEn is asserted. 
-------------------------------------------------------------------------------
  p_CRComb : process(UARTCRnewWrEn,iUARTCR,PWDATAIn) 
  begin
    NextUARTCR   <= iUARTCR;
    
    if (UARTCRnewWrEn = '1' ) then
      NextUARTCR <= PWDATAIn(15 downto 0);
    else
      NextUARTCR <= iUARTCR;
    end if;
  end process p_CRComb;


-------------------------------------------------------------------------------
-- Sequential process for UARTCR
-------------------------------------------------------------------------------
  p_CRSeq :  process(PCLK, PRESETn) 
  begin
    if(PRESETn = '0') then
      iUARTCR   <= (9 downto 8 => '1', others => '0');
      
    elsif(PCLK'event and PCLK = '1') then
        iUARTCR <= NextUARTCR;
    end if;
  end process p_CRSeq;



---------------------------------------------------------------------
-- Clock PWDATAIn into UARTIFLS when UARTIFLSWrEn is asserted.
---------------------------------------------------------------------

  p_IFLSComb : process(UARTIFLSWrEn,iUARTIFLS,PWDATAIn) 
  begin
    NextUARTIFLS   <= iUARTIFLS;
    
    if(UARTIFLSWrEn = '1') then
      NextUARTIFLS <= PWDATAIn(5 downto 0);
    end if;
  end process p_IFLSComb;


---------------------------------------------------------------------
-- Sequential process for UARTIFLS
---------------------------------------------------------------------
  p_IFLSSeq :  process(PCLK, PRESETn) 
  begin
    if(PRESETn = '0') then
      iUARTIFLS   <= "010010";   
    elsif(PCLK'event and PCLK = '1') then
        iUARTIFLS <= NextUARTIFLS;
    end if;
  end process p_IFLSSeq;

  
---------------------------------------------------------------------
-- Clock PWDATAIn into UARTDMACR when UARTDMACRWrEn is asserted.
---------------------------------------------------------------------

  p_DMACRComb : process(UARTDMACRWrEn,iUARTDMACR,PWDATAIn) 
  begin
    NextUARTDMACR   <= iUARTDMACR;
    
    if(UARTDMACRWrEn = '1') then
      NextUARTDMACR <= PWDATAIn(2 downto 0);
    end if;
  end process p_DMACRComb;


---------------------------------------------------------------------
-- Sequential process for UARTDMACR
---------------------------------------------------------------------
  p_DMACRSeq :  process(PCLK, PRESETn) 
  begin
    if(PRESETn = '0') then
      iUARTDMACR   <= "000";
    elsif(PCLK'event and PCLK = '1') then
        iUARTDMACR <= NextUARTDMACR;
    end if;
  end process p_DMACRSeq;


---------------------------------------------------------------------
-- UARTICR Register : Overrun Error
---------------------------------------------------------------------
  p_OEINTComb : process (UARTICRWrEn, iUARTOEIC,UARTOEIClr, PWDATAIn) 
  begin
    NextUARTOEIC   <= iUARTOEIC;

    if(UARTICRWrEn = '1') then
      NextUARTOEIC <= PWDATAIn(10);
    elsif(UARTOEIClr = '1') then
      NextUARTOEIC <= '0';
    end if;
  end process p_OEINTComb;

  p_OEINTSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTOEIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTOEIC <= NextUARTOEIC;
    end if;
  end process p_OEINTSeq;

  ---------------------------------------------------------------------
-- UARTICR Register : Break Error
---------------------------------------------------------------------
  p_BEINTComb : process (UARTICRWrEn, iUARTBEIC, UARTRISerrSync, PWDATAIn) 
  begin
    NextUARTBEIC   <= iUARTBEIC;

    if(UARTICRWrEn = '1') then
      NextUARTBEIC <= PWDATAIn(9);
    elsif(UARTRISerrSync(2) = '0') then
      NextUARTBEIC <= '0';
    end if;
  end process p_BEINTComb;

  p_BEINTSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTBEIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTBEIC <= NextUARTBEIC;
    end if;
  end process p_BEINTSeq;

  
---------------------------------------------------------------------
-- UARTICR Register : Parity Error
---------------------------------------------------------------------
  p_PEINTComb : process (UARTICRWrEn, iUARTPEIC, UARTRISerrSync, PWDATAIn) 
  begin
    NextUARTPEIC   <= iUARTPEIC;

    if(UARTICRWrEn = '1') then
      NextUARTPEIC <= PWDATAIn(8);
    elsif(UARTRISerrSync(1) = '0') then
      NextUARTPEIC <= '0';
    end if;
  end process p_PEINTComb;

  p_PEINTSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTPEIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTPEIC <= NextUARTPEIC;
    end if;
  end process p_PEINTSeq;

  

---------------------------------------------------------------------
-- UARTICR Register : Framing Error
---------------------------------------------------------------------
  p_FEINTComb : process (UARTICRWrEn, iUARTFEIC, UARTRISerrSync, PWDATAIn) 
  begin
    NextUARTFEIC   <= iUARTFEIC;

    if(UARTICRWrEn = '1') then
      NextUARTFEIC <= PWDATAIn(7);
    elsif(UARTRISerrSync(0) = '0') then
      NextUARTFEIC <= '0';
    end if;
  end process p_FEINTComb;

  p_FEINTSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTFEIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTFEIC <= NextUARTFEIC;
    end if;
  end process p_FEINTSeq;



---------------------------------------------------------------------
-- UARTICR Register : Receive Timeout
---------------------------------------------------------------------

  p_RTINTComb : process (UARTICRWrEn, iUARTRTIC, UARTRTRIS, PWDATAIn) 
  begin
    NextUARTRTIC   <= iUARTRTIC;

    if(UARTICRWrEn = '1') then
      NextUARTRTIC <= PWDATAIn(6);
    elsif(UARTRTRIS = '0') then
      NextUARTRTIC <= '0';
    end if;
  end process p_RTINTComb;

  p_RTINTSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTRTIC <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTRTIC <= NextUARTRTIC;
    end if;
  end process p_RTINTSeq;
  

  -------------------------------------------------------------------
  -- UARTICR Register : Rx Interrupt
  -------------------------------------------------------------------
  p_RXINTComb : process (UARTICRWrEn, iUARTRXIC, UARTRXIClr, PWDATAIn)
  begin
    NextUARTRXIC   <= iUARTRXIC;

    if(UARTICRWrEn = '1') then
      NextUARTRXIC <= PWDATAIn(4);
    elsif(UARTRXIClr = '1') then
      NextUARTRXIC <= '0';
    end if;  
  end process p_RXINTComb;

  p_RXINTSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTRXIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTRXIC <= NextUARTRXIC;
    end if;
  end process p_RXINTSeq;
  
  -------------------------------------------------------------------
  -- UARTICR Register : Tx Interrupt
  -------------------------------------------------------------------
  
  p_TXINTComb : process (UARTICRWrEn, iUARTTXIC, UARTTXIClr, PWDATAIn)
  begin
    NextUARTTXIC   <= iUARTTXIC;

    if(UARTICRWrEn = '1') then
      NextUARTTXIC <= PWDATAIn(5);
    elsif(UARTTXIClr = '1') then
      NextUARTTXIC <= '0';
    end if;  
  end process p_TXINTComb;

  p_TXINTSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTTXIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTTXIC <= NextUARTTXIC;
    end if;
  end process p_TXINTSeq;


-------------------------------------------------------------------
-- UARTICR Register : Modem DSR Line
-------------------------------------------------------------------
 
  p_DSRComb : process (UARTICRWrEn, iUARTDSRIC, UARTRISmodSync, PWDATAIn) 
  begin
    NextUARTDSRIC   <= iUARTDSRIC;

    if(UARTICRWrEn = '1') then
      NextUARTDSRIC <= PWDATAIn(3);
    elsif(UARTRISmodSync(3) = '0') then
      NextUARTDSRIC <= '0';
    end if;
  end process p_DSRComb;

  p_DSRSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTDSRIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTDSRIC <= NextUARTDSRIC;
    end if;
  end process p_DSRSeq;

  -------------------------------------------------------------------
  -- UARTICR Register : Modem DCD Line
  -------------------------------------------------------------------
  
  p_DCDComb : process (UARTICRWrEn, iUARTDCDIC, UARTRISmodSync, PWDATAIn) 
  begin
    NextUARTDCDIC   <= iUARTDCDIC;

    if(UARTICRWrEn = '1') then
      NextUARTDCDIC <= PWDATAIn(2);
    elsif(UARTRISmodSync(2) = '0') then
      NextUARTDCDIC <= '0';
    end if;
  end process p_DCDComb;

  p_DCDSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTDCDIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTDCDIC <= NextUARTDCDIC;
    end if;
  end process p_DCDSeq;



  -------------------------------------------------------------------
  -- UARTICR Register : Modem CTS Line
  -------------------------------------------------------------------
  
  p_CTSComb : process (UARTICRWrEn, iUARTCTSIC, UARTRISmodSync, PWDATAIn) 
  begin
    NextUARTCTSIC   <= iUARTCTSIC;

    if(UARTICRWrEn = '1') then
      NextUARTCTSIC <= PWDATAIn(1);
    elsif(UARTRISmodSync(1) = '0') then
      NextUARTCTSIC <= '0';
    end if;
  end process p_CTSComb;

  p_CTSSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTCTSIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTCTSIC <= NextUARTCTSIC;
    end if;
  end process p_CTSSeq;

  -------------------------------------------------------------------
  -- UARTICR Register : Modem RI Line
  -------------------------------------------------------------------

  p_RIComb : process (UARTICRWrEn, iUARTRIIC, UARTRISmodSync, PWDATAIn) 
  begin
    NextUARTRIIC   <= iUARTRIIC;

    if(UARTICRWrEn = '1') then
      NextUARTRIIC <= PWDATAIn(0);
    elsif(UARTRISmodSync(0) = '0') then
      NextUARTRIIC <= '0';
    end if;
  end process p_RIComb;

  p_RISeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      iUARTRIIC   <= '0';
    elsif(PCLK'event and PCLK = '1') then
        iUARTRIIC <= NextUARTRIIC;
    end if;
  end process p_RISeq;

  UARTICR(10) <= iUARTOEIC; 
  UARTICR(9)  <= iUARTBEIC; 
  UARTICR(8)  <= iUARTPEIC; 
  UARTICR(7)  <= iUARTFEIC; 
  UARTICR(6)  <= iUARTRTIC; 
  UARTICR(5)  <= iUARTTXIC;
  UARTICR(4)  <= iUARTRXIC;
  UARTICR(3)  <= iUARTDSRIC;
  UARTICR(2)  <= iUARTDCDIC;
  UARTICR(1)  <= iUARTCTSIC;
  UARTICR(0)  <= iUARTRIIC;
  
  -------------------------------------------------------------------
  -- UARTIMSC Register
  -------------------------------------------------------------------
  p_Mask : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      UARTIMSC   <= "00000000000";
    elsif (PCLK'event and PCLK = '1') then
      if(UARTIMSCWrEn = '1') then
        UARTIMSC <= PWDATAIn(10 downto 0);
      end if;
    end if;     
  end process p_Mask;
  
  
-------------------------------------------------------------------------------
-- Connect local copies to outputs
-------------------------------------------------------------------------------
  RXSTATUS   <= iRXSTATUS;

  UARTLCRH   <= iUARTLCRH;
  UARTLCRM   <= iUARTLCRM;
  UARTLCRL   <= iUARTLCRL;
  
  UARTFBRD   <= iUARTFBRD;
  
  UARTCR     <= iUARTCR;

  UARTILPR   <= iUARTILPR;

  LCRUpdate  <= iLCRUpdate;
  ILPRUpdate <= iILPRUpdate;
  FBRDUpdate <= iFBRDUpdate;

  UARTIFLS   <= iUARTIFLS;
  UARTDMACR  <= iUARTDMACR;
  
end synth;

--========================== End of UartRegBlock =============================--














