--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : Uart.vhd.rca
--  File Revision          : 1.30
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--  ----------------------------------------------------------------------------
--  
--  
--  
-- -----------------------------------------------------------------------------
--  Purpose          : This block is the top level of the Uart.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity Uart is
  port (
        PCLK	      : in  std_logic;      -- APB Bus Clock
        UARTCLK	      : in  std_logic;      -- Main UART Clock
        PRESETn	      : in  std_logic;      -- AMBA Bus reset
        nUARTRST      : in  std_logic;      -- UART Reset        
        PSEL	      : in  std_logic;      -- APB Peripheral select
        PENABLE	      : in  std_logic;      -- APB Peripheral enable
        PWRITE	      : in  std_logic;      -- APB Peripheral write
        PADDR	      : in  std_logic_vector(11 downto 2);
	                                    -- APB Addr bus
        PWDATA	      : in  std_logic_vector(15 downto 0);
	                                    -- APB write databus       
        UARTRXD	      : in  std_logic;      -- UART Receive input
        SIRIN	      : in  std_logic;      -- SiR receive input
        nUARTCTS      : in  std_logic;      -- Modem CTS
        nUARTDCD      : in  std_logic;      -- Modem DCD
        nUARTDSR      : in  std_logic;      -- Modem DSR
        nUARTRI	      : in  std_logic;      -- Modem RI
        UARTTXDMACLR  : in  std_logic;      -- Transmit DMA Clear
        UARTRXDMACLR  : in  std_logic;      -- Receive DMA Clear
        
        PRDATA	      : out std_logic_vector(15 downto 0);
	                                    -- Read databus
        UARTTXD	      : out std_logic;      -- UART Transmit line
        nSIROUT	      : out std_logic;      -- SiR Transmit line
        UARTMSINTR    : out std_logic;      -- Modem status interrupt
        UARTRXINTR    : out std_logic;      -- UART Receive interrupt
        UARTTXINTR    : out std_logic;      -- UART Transmit interrupt
        UARTRTINTR    : out std_logic;      -- Receive Timeout interrupt
        UARTEINTR     : out std_logic;      -- Combined Error interrupt
        UARTINTR      : out std_logic;      -- Combined interrupt
        nUARTOut2     : out std_logic;      -- Modem Out2
        nUARTOut1     : out std_logic;      -- Modem Out1
        nUARTRTS      : out std_logic;      -- Modem RTS
        nUARTDTR      : out std_logic;      -- Modem DTR
        UARTTXDMASREQ : out std_logic;      -- Transmit DMA single request
        UARTTXDMABREQ : out std_logic;      -- Transmit DMA burst request
        UARTRXDMASREQ : out std_logic;      -- Receive DMA single request
        UARTRXDMABREQ : out std_logic;      -- Receive DMA burst request

        -- Scan test dummy signals; not connected until scan insertion 
        SCANENABLE     : in  std_logic;     -- Test Mode input 
        SCANINPCLK     : in  std_logic;     -- Scan chain input 
        SCANINUCLK     : in  std_logic;     -- Scan chain input 
        SCANOUTPCLK    : out std_logic;     -- Scan chain output 
        SCANOUTUCLK    : out std_logic      -- Scan chain output 

        );
end Uart;

architecture structural of Uart is
-- -----------------------------------------------------------------------------
-- 
--                                Uart
--                                ====
-- 
-- -----------------------------------------------------------------------------
-- 
--  Overview
--  ========
-- 
--    This block is the top level of the UART. This block instantiates the 
-- functional sub-blocks in the UART.
--  The module UartRevAnd used as a place-holder cell to mark the
-- Revision of the Uart. It contains a 2 input AND gate. The 2 input
-- pins are tied-off at the top level of the hierarchy. These "TieOffs"
-- can be identified during layout and re-wired to "VDD" or "VSS"
-- if needed.  
-- -----------------------------------------------------------------------------   
-- UART Transmitter
  signal PWDATAIn	  : std_logic_vector(15 downto 0); 
  signal UARTTCRWrEn	  : std_logic; 
  signal UARTLCRHnewWrEn  : std_logic;
  signal UARTCRnewWrEn	  : std_logic;
  signal UARTICRWrEn	  : std_logic;
  signal UARTIBRDWrEn	  : std_logic;
  signal UARTFBRDWrEn	  : std_logic;
  signal UARTTDRWrEn	  : std_logic;
  signal UARTIMSCWrEn	  : std_logic;
  signal UARTTDRrd	  : std_logic;
  signal RXFRdPtrInc	  : std_logic; 
  signal UARTECRWrEn	  : std_logic; 
  signal UARTDRWrEn	  : std_logic; 
  signal UARTRXDint	  : std_logic; 
  signal SIRINint	  : std_logic;
  signal UARTLCRH	  : std_logic_vector(7 downto 0);
  signal UARTLCRM	  : std_logic_vector(7 downto 0); 
  signal UARTLCRL	  : std_logic_vector(7 downto 0);
  signal UARTFBRD         : std_logic_vector(5 downto 0);
  signal RXFIFOData	  : std_logic_vector(10 downto 0); 
  signal DataStp	  : std_logic; 
  signal LCRUpdateSync	  : std_logic; 
  signal ILPRUpdateSync	  : std_logic; 
  signal FBRDUpdateSync	  : std_logic; 
  signal Baud16	          : std_logic; 
  signal UARTRXDSync	  : std_logic; 
  signal RXFE	          : std_logic; 
  signal RXFESync	  : std_logic; 
  signal RXFWrDone	  : std_logic; 
  signal RXFWrDoneSync	  : std_logic; 
  signal RXD	          : std_logic; 
  signal RXFWr	          : std_logic; 
  signal RXFWrSync	  : std_logic; 
  signal RXFF	          : std_logic; 
  signal OverrunDet	  : std_logic;
  signal LCRH	          : std_logic_vector(6 downto 1);
  signal TXFRdPtrIncSync  : std_logic; 
  signal TXFRdPtrInc	  : std_logic; 
  signal RdPtrIncDone	  : std_logic; 
  signal RdPtrIncDoneSync : std_logic; 
  signal TXShiftData      : std_logic_vector(7 downto 0); 
  signal TXFF	          : std_logic; 
  signal TXFE	          : std_logic; 
  signal Abort	          : std_logic; 
  signal AbortSync	  : std_logic; 
  signal TXDataAvlbl	  : std_logic; 
  signal nDCDSyncUARTCLK  : std_logic; 
  signal nDSRSyncUARTCLK  : std_logic; 
  signal nCTSSyncUARTCLK  : std_logic; 
  signal nRISyncUARTCLK	  : std_logic;
  signal DCDIMSync	  : std_logic; 
  signal DSRIMSync	  : std_logic; 
  signal CTSIMSync	  : std_logic; 
  signal RIIMSync	  : std_logic; 
  signal RTIMSync	  : std_logic; 
  signal FEIMSync	  : std_logic; 
  signal PEIMSync	  : std_logic; 
  signal BEIMSync	  : std_logic; 
  signal IrLPBaud16	  : std_logic; 
  signal UARTENSync	  : std_logic;
  signal TXESync	  : std_logic;
  signal RXESync	  : std_logic;
  signal SIRLPSync	  : std_logic; 
  signal SIRINSync        : std_logic; 
  signal TXD	          : std_logic; 
  signal MSINTR 	  : std_logic; 
  signal RXFRdData	  : std_logic_vector(11 downto 0); 
  signal nUARTDSRint	  : std_logic; 
  signal nUARTCTSint	  : std_logic; 
  signal nUARTDCDint	  : std_logic; 
  signal nUARTRIint	  : std_logic;
  signal RXSTATUS	  : std_logic_vector(2 downto 0); 
  signal UARTILPRWrEn	  : std_logic; 
  signal SIRENSync  	  : std_logic; 
  signal TXBUSY	          : std_logic; 
  signal TXDataAvlblSync  : std_logic; 
  signal RXBUSY	          : std_logic; 
  signal nDCDSyncPCLK	  : std_logic; 
  signal nDSRSyncPCLK	  : std_logic; 
  signal nCTSSyncPCLK	  : std_logic; 
  signal nRISyncPCLK	  : std_logic;
  signal UARTTCR  	  : std_logic_vector(2 downto 0); 
  signal TXBUSYSync	  : std_logic; 
  signal BUSY	          : std_logic; 
  signal UARTRTICSync	  : std_logic; 
  signal UARTFEICSync	  : std_logic; 
  signal UARTPEICSync	  : std_logic; 
  signal UARTBEICSync	  : std_logic; 
  signal UARTDCDICSync	  : std_logic; 
  signal UARTDSRICSync	  : std_logic; 
  signal UARTCTSICSync	  : std_logic; 
  signal UARTRIICSync	  : std_logic; 
  signal UARTICR	  : std_logic_vector(10 downto 0); 
  signal UARTILPR	  : std_logic_vector(7 downto 0); 
  signal ILPRUpdate	  : std_logic; 
  signal LCRUpdate	  : std_logic; 
  signal FBRDUpdate	  : std_logic; 
  signal UARTCR	          : std_logic_vector(15 downto 0);
  signal UARTTXDint	  : std_logic; 
  signal iUARTTXD	  : std_logic; 
  signal nSIROUTint	  : std_logic;
  signal inSIROUT	  : std_logic;
  signal inUARTOut2 	  : std_logic;
  signal nUARTOut2int 	  : std_logic;
  signal nUARTOut1int	  : std_logic;
  signal inUARTOut1	  : std_logic;
  signal nUARTRTSint	  : std_logic;
  signal inUARTRTS	  : std_logic;
  signal nUARTDTRint	  : std_logic;
  signal inUARTDTR	  : std_logic;
  signal UARTLCRHInt      : std_logic_vector(6 downto 0);
  signal TXFIFOData       : std_logic_vector(7 downto 0);
  signal TestTXFInc       : std_logic;
  signal UARTIFLSWrEn     : std_logic;
  signal UARTIFLS         : std_logic_vector(5 downto 0);
  signal UARTOEIClr       : std_logic;
  signal CharTxComp       : std_logic;
  signal CharRxComp       : std_logic;
  signal StopBaudCnt      : std_logic;
  signal RXEnable         : std_logic;
  signal UartRXCntlState  : std_logic_vector(2 downto 0);
  signal UARTIMSC         : std_logic_vector(10 downto 0);
  signal UARTRISmodSync   : std_logic_vector(3 downto 0); 
  signal UARTMISmodSync   : std_logic_vector(3 downto 0); 
  signal UARTRISmod       : std_logic_vector(3 downto 0); 
  signal UARTMISmod       : std_logic_vector(3 downto 0); 
  signal UARTRISerrSync   : std_logic_vector(2 downto 0); 
  signal UARTMISerrSync   : std_logic_vector(2 downto 0); 
  signal UARTRISerr       : std_logic_vector(2 downto 0); 
  signal UARTMISerr       : std_logic_vector(2 downto 0); 
  signal UARTEINTRfbp     : std_logic;
  signal UARTTXRIS        : std_logic; 
  signal UARTTXMIS        : std_logic; 
  signal EINTR            : std_logic; 
  signal UARTREINTR       : std_logic; 
  signal UARTTXIClr       : std_logic; 
  signal UARTRXRIS        : std_logic; 
  signal UARTRXMIS        : std_logic; 
  signal UARTRTRIS        : std_logic; 
  signal RTINTR           : std_logic; 
  signal UARTRXIClr       : std_logic;
  signal UARTOERIS        : std_logic; 
  signal UARTOEMIS        : std_logic;
  signal RXFGTE1Full      : std_logic;
  signal RXIntLevel       : std_logic;  
  signal TXFLTE15Full     : std_logic;
  signal TXIntLevel       : std_logic;  
  signal UARTDMACRWrEn    : std_logic;
  signal UARTDMACR        : std_logic_vector(2 downto 0);
  signal inUARTRTScr      : std_logic;
  signal TieOff1          : std_logic_vector(3 downto 0);
  signal TieOff2          : std_logic_vector(3 downto 0);
  signal Revision         : std_logic_vector(3 downto 0);
  signal IntUARTTXDMACLR  : std_logic;
  signal IntUARTRXDMACLR  : std_logic;
  signal UARTTXDMACLRSync : std_logic;
  signal UARTRXDMACLRSync : std_logic;
  signal IntTXDMASREQ     : std_logic;
  signal IntTXDMABREQ     : std_logic;
  signal IntRXDMASREQ     : std_logic;
  signal IntRXDMABREQ     : std_logic;
  signal IntMSINTR        : std_logic;
  signal IntUARTRXMIS     : std_logic;
  signal IntUARTTXMIS     : std_logic;
  signal IntUARTRTRIS     : std_logic;
  signal IntUARTEINTR     : std_logic;
  signal IntUARTINTR      : std_logic;
  signal UARTITIPWrEn     : std_logic;
  signal UARTITOPWrEn     : std_logic;
  signal TXDMASREQ        : std_logic;
  signal TXDMABREQ        : std_logic;
  signal RXDMASREQ        : std_logic;
  signal RXDMABREQ        : std_logic;
  signal UARTMSINT        : std_logic;
  signal UARTINT          : std_logic;
  signal CTSEnSyncUCLK    : std_logic;
  signal UARTITOP         : std_logic_vector(5 downto 0);
  signal Zerobaud         : std_logic;
  signal CharTxCompSync   : std_logic;
  signal BRKSync          : std_logic;
    
  component UartRegBlock 
    port (
          PCLK            : in  std_logic;
          PRESETn         : in  std_logic;
        
          RXFRdPtrInc     : in  std_logic;
          PWDATAIn        : in  std_logic_vector(15 downto 0);
          RXFRdData       : in  std_logic_vector(10 downto 8);
        
          UARTECRWrEn     : in  std_logic; 
          UARTLCRHnewWrEn : in  std_logic; 
          UARTILPRWrEn    : in  std_logic; 
          UARTCRnewWrEn   : in  std_logic; 
          UARTICRWrEn     : in  std_logic;
          UARTIBRDWrEn    : in  std_logic;
          UARTFBRDWrEn    : in  std_logic;
          UARTIFLSWrEn    : in  std_logic;
          UARTIMSCWrEn    : in  std_logic;
          UARTDMACRWrEn   : in  std_logic;
        
          UARTOEIClr      : in  std_logic;
          UARTRTRIS       : in  std_logic;
          UARTRISerrSync  : in  std_logic_vector(2 downto 0);
          UARTRISmodSync  : in  std_logic_vector(3 downto 0);
          UARTTXIClr      : in  std_logic;  
          UARTRXIClr      : in  std_logic;   
        
          LCRUpdate       : out std_logic; 
          ILPRUpdate      : out std_logic; 
          FBRDUpdate      : out std_logic; 
       
          UARTICR         : out std_logic_vector(10 downto 0);
          RXSTATUS        : out std_logic_vector(2 downto 0);
          UARTLCRH        : out std_logic_vector(7 downto 0);
          UARTLCRM        : out std_logic_vector(7 downto 0);
          UARTLCRL        : out std_logic_vector(7 downto 0);
          UARTILPR        : out std_logic_vector(7 downto 0);
          UARTCR          : out std_logic_vector(15 downto 0);
          UARTIFLS        : out std_logic_vector(5 downto 0);
          UARTDMACR       : out std_logic_vector(2 downto 0);
          UARTFBRD        : out std_logic_vector(5 downto 0);
          UARTIMSC        : out std_logic_vector(10 downto 0)
          );
  end component;


  component UartApbif 
    port (
          PCLK            : in  std_logic;  
          PRESETn         : in  std_logic; 
        
          PSEL            : in  std_logic; 
          PWRITE          : in  std_logic; 
          PENABLE         : in  std_logic; 
          PADDR           : in  std_logic_vector(11 downto 2);
          PWDATA          : in  std_logic_vector(15 downto 0);
        
          RXFF            : in  std_logic; 
          TXFF            : in  std_logic; 
          RXFE            : in  std_logic; 
          TXFE            : in  std_logic; 
          BUSY            : in  std_logic; 

          UARTTXRIS       : in  std_logic; 
          UARTTXMIS       : in  std_logic; 
          UARTRXRIS       : in  std_logic; 
          UARTRXMIS       : in  std_logic; 
          UARTOERIS       : in  std_logic; 
          UARTOEMIS       : in  std_logic; 
          UARTRTRIS       : in  std_logic; 
          UARTRISmodSync  : in  std_logic_vector(3 downto 0);
          UARTRISerrSync  : in  std_logic_vector(2 downto 0);
          UARTMISerrSync  : in  std_logic_vector(2 downto 0);
          UARTMISmodSync  : in  std_logic_vector(3 downto 0);

          SIRIN           : in  std_logic; 
          UARTRXD         : in  std_logic; 

          RXFRdData       : in  std_logic_vector(11 downto 0);
          TXFIFOData      : in  std_logic_vector(7 downto 0);
          RXSTATUS        : in  std_logic_vector(2 downto 0);
          Revision        : in  std_logic_vector(3 downto 0);
          OverrunDet      : in  std_logic;   
          TESTFIFO        : in  std_logic;   

          UARTLCRH        : in  std_logic_vector(7 downto 0);
          UARTLCRM        : in  std_logic_vector(7 downto 0);
          UARTLCRL        : in  std_logic_vector(7 downto 0);
          UARTFBRD        : in  std_logic_vector(5 downto 0);
          UARTCR          : in  std_logic_vector(15 downto 0);
          UARTILPR        : in  std_logic_vector(7 downto 0);
          UARTTCR         : in  std_logic_vector(2 downto 0);
          UARTIFLS        : in  std_logic_vector(5 downto 0);
          UARTIMSC        : in  std_logic_vector(10 downto 0);
          UARTDMACR       : in  std_logic_vector(2 downto 0);
          UARTITOP        : in  std_logic_vector(5 downto 0);
          nDCDSyncPCLK    : in  std_logic;  
          nDSRSyncPCLK    : in  std_logic;  
          nCTSSyncPCLK    : in  std_logic;  
          nRISyncPCLK     : in  std_logic;
          nUARTDCD        : in  std_logic;
          nUARTDSR        : in  std_logic;
          nUARTCTS        : in  std_logic;
          nUARTRI	  : in  std_logic;         

          UARTTXDMACLR    : in  std_logic; 
          UARTRXDMACLR    : in  std_logic; 
        
          IntTXDMASREQ    : in  std_logic; 
          IntTXDMABREQ    : in  std_logic; 
          IntRXDMASREQ    : in  std_logic; 
          IntRXDMABREQ    : in  std_logic; 
          IntMSINTR       : in  std_logic; 
          IntUARTRXMIS    : in  std_logic; 
          IntUARTTXMIS    : in  std_logic; 
          IntUARTRTRIS    : in  std_logic; 
          IntUARTEINTR    : in  std_logic; 
          IntUARTINTR     : in  std_logic; 
        
          UARTDRWrEn      : out std_logic; 
          UARTECRWrEn     : out std_logic; 
          UARTLCRHnewWrEn : out std_logic; 
          PWDATAIn        : out std_logic_vector(15 downto 0);
          PRDATA          : out std_logic_vector(15 downto 0);
         
          UARTREINTR      : out std_logic; 
          RXFRdPtrInc     : out std_logic; 
        
          UARTCRnewWrEn   : out std_logic; 
          UARTICRWrEn     : out std_logic; 
          UARTILPRWrEn    : out std_logic; 
          UARTTDRWrEn     : out std_logic; 
          UARTIBRDWrEn    : out std_logic; 
          UARTFBRDWrEn    : out std_logic; 
          UARTIFLSWrEn    : out std_logic; 
          UARTIMSCWrEn    : out std_logic; 
          UARTDMACRWrEn   : out std_logic; 
          UARTTDRrd       : out std_logic; 
          UARTTCRWrEn     : out std_logic; 
          UARTITIPWrEn    : out std_logic; 
          UARTITOPWrEn    : out std_logic  
          );
  end component;


  component UartSynctoPCLK 
    port (
          PCLK             : in  std_logic; 
          PRESETn          : in  std_logic; 
        
          TXBUSY           : in  std_logic; 
          TXFRdPtrInc      : in  std_logic; 
          RXFWr            : in  std_logic; 
          Abort            : in  std_logic; 
          DataStp          : in  std_logic; 
        
          nDCD             : in  std_logic; 
          nDSR             : in  std_logic; 
          nCTS             : in  std_logic; 
          nRI              : in  std_logic; 
          UARTRISmod       : in  std_logic_vector(3 downto 0);
          UARTMISmod       : in  std_logic_vector(3 downto 0);
          UARTRISerr       : in  std_logic_vector(2 downto 0);
          UARTMISerr       : in  std_logic_vector(2 downto 0);
          
          IntUARTTXDMACLR  : in  std_logic; 
          IntUARTRXDMACLR  : in  std_logic; 
          
          CharTxComp       : in  std_logic;   
        
          TXBUSYSync       : out std_logic;
          TXFRdPtrIncSync  : out std_logic;
          RXFWrSync        : out std_logic;
          AbortSync        : out std_logic;
        
          nDCDSyncPCLK     : out std_logic;
          nDSRSyncPCLK     : out std_logic;
          nCTSSyncPCLK     : out std_logic;
          nRISyncPCLK      : out std_logic;
          UARTRTRIS        : out std_logic;
          UARTRISmodSync   : out std_logic_vector(3 downto 0);
          UARTMISmodSync   : out std_logic_vector(3 downto 0);
          UARTRISerrSync   : out std_logic_vector(2 downto 0);
          UARTMISerrSync   : out std_logic_vector(2 downto 0);

          UARTTXDMACLRSync : out std_logic;
          UARTRXDMACLRSync : out std_logic;
          
          CharTxCompSync   : out  std_logic   
          
          );
  end component;


  component UartSynctoUCLK 
    port (
          UARTCLK          : in  std_logic; 
          nUARTRST         : in  std_logic; 
        
          BRK              : in  std_logic; 
          SIRLP            : in  std_logic; 
          SIREN            : in  std_logic; 
          UARTEN           : in  std_logic; 
          TXE              : in  std_logic; 
          RXE              : in  std_logic; 
          TXDataAvlbl      : in  std_logic; 
          RXFE             : in  std_logic; 
          CTSEn            : in  std_logic; 
          LCRUpdate        : in  std_logic; 
          ILPRUpdate       : in  std_logic; 
          FBRDUpdate       : in  std_logic; 
          UARTRXD          : in  std_logic; 
          SIRIN            : in  std_logic; 
          RXFWrDone        : in  std_logic; 
          RdPtrIncDone     : in  std_logic; 
        
          DCDIM            : in  std_logic; 
          DSRIM            : in  std_logic; 
          CTSIM            : in  std_logic; 
          RIIM             : in  std_logic; 
          RTIM             : in  std_logic; 
          FEIM             : in  std_logic; 
          PEIM             : in  std_logic; 
          BEIM             : in  std_logic; 
            
          nDCD             : in  std_logic; 
          nDSR             : in  std_logic; 
          nCTS             : in  std_logic; 
          nRI              : in  std_logic; 
          UARTDCDIC        : in  std_logic; 
          UARTDSRIC        : in  std_logic; 
          UARTCTSIC        : in  std_logic; 
          UARTRIIC         : in  std_logic; 
          UARTFEIC         : in  std_logic; 
          UARTPEIC         : in  std_logic; 
          UARTBEIC         : in  std_logic; 
          UARTRTIC         : in  std_logic; 
        
          SIRLPSync        : out std_logic; 
          SIRENSync        : out std_logic; 
          UARTENSync       : out std_logic; 
          TXESync          : out std_logic; 
          RXESync          : out std_logic; 
          TXDataAvlblSync  : out std_logic; 
          RXFESync         : out std_logic; 
          CTSEnSyncUCLK    : out std_logic; 
          LCRUpdateSync    : out std_logic; 
          ILPRUpdateSync   : out std_logic; 
          FBRDUpdateSync   : out std_logic; 
          UARTRXDSync      : out std_logic; 
          SIRINSync        : out std_logic; 
          RXFWrDoneSync    : out std_logic; 
          RdPtrIncDoneSync : out std_logic; 
        
          DCDIMSync        : out std_logic; 
          DSRIMSync        : out std_logic; 
          CTSIMSync        : out std_logic; 
          RIIMSync         : out std_logic; 
          RTIMSync         : out std_logic; 
          FEIMSync         : out std_logic; 
          PEIMSync         : out std_logic; 
          BEIMSync         : out std_logic; 
        
          nDCDSyncUARTCLK  : out std_logic; 
          nDSRSyncUARTCLK  : out std_logic; 
          nCTSSyncUARTCLK  : out std_logic; 
          nRISyncUARTCLK   : out std_logic; 
          UARTDCDICSync    : out std_logic; 
          UARTDSRICSync    : out std_logic; 
          UARTCTSICSync    : out std_logic; 
          UARTRIICSync     : out std_logic; 
          UARTFEICSync     : out std_logic; 
          UARTPEICSync     : out std_logic; 
          UARTBEICSync     : out std_logic; 
          UARTRTICSync     : out std_logic;  
          BRKSync          : out std_logic
          );
  end component;


  component UartModem 
    port (
          UARTCLK         : in  std_logic; 
          nUARTRST        : in  std_logic; 
        
          SIRENSync       : in  std_logic; 
        
          nDCDSyncUARTCLK : in  std_logic;
          nDSRSyncUARTCLK : in  std_logic;
          nCTSSyncUARTCLK : in  std_logic;
          nRISyncUARTCLK  : in  std_logic;
        
          UARTDCDICSync   : in  std_logic;
          UARTDSRICSync   : in  std_logic;
          UARTCTSICSync   : in  std_logic;
          UARTRIICSync    : in  std_logic;
        
          DCDIMSync       : in  std_logic;
          DSRIMSync       : in  std_logic;
          CTSIMSync       : in  std_logic;
          RIIMSync        : in  std_logic;
        
          UARTMSINT       : out std_logic;
          UARTRISmod      : out std_logic_vector(3 downto 0);
          UARTMISmod      : out std_logic_vector(3 downto 0)
          );
  end component;


  component UartTest 
    port (
          PCLK            : in  std_logic;
          PRESETn         : in  std_logic;
        
          LBE             : in  std_logic;

        
          UARTTCRWrEn     : in  std_logic; 
          UARTITIPWrEn    : in  std_logic; 
          UARTITOPWrEn    : in  std_logic; 
          UARTTDRrd       : in  std_logic; 
        
          PWDATAIn        : in  std_logic_vector(15 downto 0);
          UARTRXD         : in  std_logic; 
          SIRIN           : in  std_logic; 
          UARTTXDint      : in  std_logic; 
          nSIROUTint      : in  std_logic; 
        
          nUARTCTS        : in  std_logic; 
          nUARTDSR        : in  std_logic; 
          nUARTDCD        : in  std_logic; 
          nUARTRI         : in  std_logic; 
          nUARTRTSint     : in  std_logic; 
          nUARTDTRint     : in  std_logic; 
          nUARTOut2int    : in  std_logic; 
          nUARTOut1int    : in  std_logic; 
        
          UARTTXDMACLR    : in  std_logic; 
          UARTRXDMACLR    : in  std_logic; 
          TXDMASREQ       : in  std_logic; 
          TXDMABREQ       : in  std_logic; 
          RXDMASREQ       : in  std_logic; 
          RXDMABREQ       : in  std_logic; 
        
          MSINTR          : in  std_logic; 
          UARTRXMIS       : in  std_logic; 
          UARTTXMIS       : in  std_logic; 
          RTINTR          : in  std_logic; 
          EINTR           : in  std_logic; 
          UARTINT         : in  std_logic; 
        
          UARTRXDint      : out std_logic; 
          SIRINint        : out std_logic; 
          UARTTCR         : out std_logic_vector(2 downto 0);
          UARTITOP        : out std_logic_vector(5 downto 0);
          TestTXFInc      : out std_logic; 
        
          nUARTDSRint     : out std_logic; 
          nUARTCTSint     : out std_logic; 
          nUARTDCDint     : out std_logic; 
          nUARTRIint      : out std_logic; 
        
          IntUARTTXDMACLR : out std_logic; 
          IntUARTRXDMACLR : out std_logic; 
          IntTXDMASREQ    : out std_logic; 
          IntTXDMABREQ    : out std_logic; 
          IntRXDMASREQ    : out std_logic; 
          IntRXDMABREQ    : out std_logic; 
        
          IntMSINTR       : out std_logic; 
          IntUARTRXMIS    : out std_logic; 
          IntUARTTXMIS    : out std_logic; 
          IntUARTRTRIS    : out std_logic; 
          IntUARTEINTR    : out std_logic; 
          IntUARTINTR     : out std_logic; 
        
          nUARTOut2       : out std_logic; 
          nUARTOut1       : out std_logic; 
          nUARTRTS        : out std_logic; 
          nUARTDTR        : out std_logic; 
          nSIROUT         : out std_logic; 
          UARTTXD         : out std_logic  
          );
  end component;


  component UartReceive 
    port (
          UARTCLK         : in  std_logic; 
          nUARTRST        : in  std_logic; 
        
          UARTENSync      : in  std_logic;
          SIRENSync       : in  std_logic;
          RXESync         : in  std_logic;
          Baud16          : in  std_logic;
          WLEN	          : in  std_logic_vector(1 downto 0);
          STP2	          : in  std_logic; 
          EPS             : in  std_logic; 
          PEN             : in  std_logic; 
          SPS             : in  std_logic; 
          RXFWrDoneSync   : in  std_logic; 
          Zerobaud        : in  std_logic; 
          RXFESync        : in  std_logic; 
          RXD	          : in  std_logic; 
        
          RTIMSync        : in  std_logic; 
          FEIMSync        : in  std_logic; 
          PEIMSync        : in  std_logic; 
          BEIMSync        : in  std_logic; 
          UARTRTICSync    : in  std_logic; 
          UARTFEICSync    : in  std_logic; 
          UARTPEICSync    : in  std_logic; 
          UARTBEICSync    : in  std_logic; 
        
          RXFWr	          : out std_logic; 
          RXFIFOData      : out std_logic_vector(10 downto 0);
          DataStp         : out std_logic;
          RXBUSY	  : out std_logic;
          RXEnable        : out std_logic;
          UartRXCntlState : out std_logic_vector(2 downto 0);
          UARTRISerr      : out std_logic_vector(2 downto 0);
          UARTMISerr      : out std_logic_vector(2 downto 0);
          UARTEINTRfbp    : out std_logic; 
          CharRxComp      : out std_logic
          );
  end component;


  component UartRXFIFO 
    port (
          PCLK        : in  std_logic; 
          PRESETn     : in  std_logic;
        
          PWDATAIn    : in  std_logic_vector(11 downto 0);
          RXFWrSync   : in  std_logic;	
          RXFRdPtrInc : in  std_logic;  
          RXFIFOData  : in  std_logic_vector(10 downto 0);
          UARTECRWrEn : in  std_logic;	  
          UARTTDRWrEn : in  std_logic;	 
          FEN	      : in  std_logic;	
          RTSEn       : in  std_logic;  
          TESTFIFO    : in  std_logic;	
          nUARTRTScr  : in  std_logic;  
        
          RXIFLSEL    : in  std_logic_vector(2 downto 0);
          UARTRXIC    : in  std_logic; 
          UARTOEIC    : in  std_logic;  
          RXIM        : in  std_logic;  
          OEIM        : in  std_logic;  
        
          RXFRdData   : out std_logic_vector(11 downto 0);
          RXFWrDone   : out std_logic;  
          RXFE	      : out std_logic;	  
          RXFF	      : out std_logic;	 
          OverrunDet  : out std_logic;	 
          nUARTRTSint : out std_logic;   
          RXFGTE1Full : out std_logic;   
          RXIntLevel  : out std_logic;   
        
          UARTRXIClr  : out std_logic;  
          UARTOEIClr  : out std_logic;  
          UARTRXRIS   : out std_logic;  
          UARTRXMIS   : out std_logic;  
          UARTOERIS   : out std_logic;  
          UARTOEMIS   : out std_logic   
          );
  end component;


  component UartTXFIFO 
    port (
          PCLK    	  : in  std_logic; 
          PRESETn	  : in  std_logic;
        
          PWDATAIn	  : in  std_logic_vector(7 downto 0);
          UARTEN    	  : in  std_logic; 
          TXE	          : in  std_logic; 
          TXFRdPtrIncSync : in  std_logic;
          FEN	          : in  std_logic;
          BRK	          : in  std_logic;
          AbortSync	  : in  std_logic;
        
          UARTDRWrEn	  : in  std_logic;
          TestTXFInc      : in  std_logic;
          TXBUSYSync	  : in  std_logic;
          TESTFIFO        : in  std_logic;
          CharTxCompSync  : in  std_logic;
        
          UARTTXIC        : in  std_logic;
          TXIM            : in  std_logic;
          TXIFLSEL	  : in  std_logic_vector(2 downto 0);
        
          TXShiftData	  : out std_logic_vector(7 downto 0);
          TXFF	          : out std_logic;
          TXFE	          : out std_logic;
          TXDataAvlbl	  : out std_logic;
          RdPtrIncDone	  : out std_logic;
          BUSY	          : out std_logic;
          TXFIFOData      : out std_logic_vector(7 downto 0);
          TXFLTE15Full    : out std_logic;  
          TXIntLevel      : out std_logic; 
        
          UARTTXIClr      : out std_logic;
          UARTTXRIS	  : out std_logic;
          UARTTXMIS	  : out std_logic 
         );
  end component;


  component UartIrDA 
    port (
          UARTCLK     : in  std_logic; 
          nUARTRST    : in  std_logic; 
        
          Baud16      : in  std_logic; 
          IrLPBaud16  : in  std_logic; 
          SIRLPSync   : in  std_logic; 
          SIRENSync   : in  std_logic; 
          SIRTEST     : in  std_logic; 
        
          StopBaudCnt : in  std_logic; 
          TXBUSY      : in  std_logic; 
          RXBUSY      : in  std_logic; 
        
          TXD         : in  std_logic; 
          SIRINSync   : in  std_logic; 
          UARTRXDSync : in  std_logic; 
        
          UARTTXDint  : out std_logic; 
          RXD         : out std_logic; 
          nSIROUTint  : out std_logic
          );
  end component;


  component UartBaudCntr 
    port (
          UARTCLK        : in  std_logic; 
          nUARTRST       : in  std_logic; 
        
          LCRUpdateSync  : in  std_logic; 
          ILPRUpdateSync : in  std_logic; 
          FBRDUpdateSync : in  std_logic;

          SIRENSync      : in  std_logic; 
          SIRLPSync      : in  std_logic;
          CharTxComp     : in  std_logic;
          CharRxComp     : in  std_logic;
        
          StopBaudCnt    : in  std_logic;
          FracValue      : in  std_logic_vector(5 downto 0);
        
          UARTLCRHInt    : in  std_logic_vector(6 downto 0);
          UARTLCRM       : in  std_logic_vector(7 downto 0);
          UARTLCRL       : in  std_logic_vector(7 downto 0);
          UARTILPR       : in  std_logic_vector(7 downto 0);
        
          Baud16         : out std_logic;
          IrLPBaud16     : out std_logic;
          LCRH           : out std_logic_vector(6 downto 1);
          Abort          : out std_logic;
          Zerobaud       : out std_logic  
          );
  end component;


  component UartTXCntl 
    port (
          UARTCLK          : in  std_logic;
          nUARTRST         : in  std_logic;
          
          RXEnable         : in  std_logic;
          UartRXCntlState  : in  std_logic_vector(2 downto 0);
          CTSEn            : in  std_logic;
        
          nCTSSyncUARTCLK  : in  std_logic; 
          Baud16           : in  std_logic; 
          TXDataAvlblSync  : in  std_logic; 
          RdPtrIncDoneSync : in  std_logic; 
          UARTENSync       : in  std_logic; 
          TXESync          : in  std_logic; 
        
          TXShiftData      : in  std_logic_vector(7 downto 0);
          WLEN             : in  std_logic_vector(1 downto 0);
          STP2             : in  std_logic; 
          PEN              : in  std_logic; 
          EPS              : in  std_logic; 
          BRK              : in  std_logic; 
          Zerobaud         : in  std_logic; 
          SPS              : in  std_logic; 
        
          TXFRdPtrInc      : out std_logic; 
          TXD              : out std_logic; 
          TXBUSY           : out std_logic; 
          StopBaudCnt      : out std_logic; 
          CharTxComp       : out std_logic 
          );
  end component;
  

  component UartDMA 
    port (
          PCLK             : in  std_logic;
          PRESETn          : in  std_logic;
        
          UARTEN           : in  std_logic;
          TXDMAE           : in  std_logic;
          RXDMAE           : in  std_logic;
          DMAONERR         : in  std_logic;
          TXE              : in  std_logic;
          RXE              : in  std_logic;
          FEN              : in  std_logic;
          
          TESTFIFO         : in  std_logic;
          TXIntLevel       : in  std_logic;
          RXIntLevel       : in  std_logic;
          TXFLTE15Full     : in  std_logic;
          RXFGTE1Full      : in  std_logic;
          UARTTXDMACLRSync : in  std_logic;
          UARTRXDMACLRSync : in  std_logic;
          UARTREINTR       : in  std_logic;
        
          TXDMASREQ        : out std_logic;
          TXDMABREQ        : out std_logic;
          RXDMASREQ        : out std_logic;
          RXDMABREQ        : out std_logic 
          );
  end component;

component UartInterrupt
  port (
        DataStp      : in  std_logic;  
        UARTMSINT    : in  std_logic;  
        UARTEINTRfbp : in  std_logic;  
        UARTTXMIS    : in  std_logic;  
        UARTRXMIS    : in  std_logic; 
        UARTOEMIS    : in  std_logic; 

        UARTRTIC     : in  std_logic;    
        UARTDSRIC    : in  std_logic;    
        UARTDCDIC    : in  std_logic;    
        UARTCTSIC    : in  std_logic;    
        UARTRIIC     : in  std_logic;    
        UARTOEIC     : in  std_logic;    
        UARTBEIC     : in  std_logic;    
        UARTPEIC     : in  std_logic;    
        UARTFEIC     : in  std_logic;    
        
        RTINTR       : out std_logic;    
        MSINTR       : out std_logic;    
        EINTR        : out std_logic;    
        UARTINT      : out std_logic     
       );
end component;

  


  component UartRevAnd
  port (
        TieOff1          : in    std_logic;
        TieOff2          : in    std_logic;
        
        Revision         : out   std_logic
       );
end component;

  


begin
  UARTMSINTR    <= IntMSINTR; 
  UARTTXD       <= iUARTTXD; 
  nSIROUT       <= inSIROUT;
  
  -- Assign internal versions of DTR, RTS, UARTOut1, UARTOut2
  nUARTOut2int  <= not UARTCR(13);
  nUARTOut1int  <= not UARTCR(12);
  inUARTRTScr   <= not UARTCR(11);
  nUARTDTRint   <= not UARTCR(10);

  

  -- Assign outputs from internal signals
  nUARTOut2     <= inUARTOut2;
  nUARTOut1     <= inUARTOut1;
  nUARTRTS      <= inUARTRTS;
  nUARTDTR      <= inUARTDTR;
  UARTRTINTR    <= IntUARTRTRIS; 
  UARTTXINTR    <= IntUARTTXMIS;
  UARTRXINTR    <= IntUARTRXMIS;
  UARTEINTR     <= IntUARTEINTR;
  UARTINTR      <= IntUARTINTR;
  UARTTXDMASREQ <= IntTXDMASREQ;
  UARTTXDMABREQ <= IntTXDMABREQ;
  UARTRXDMASREQ <= IntRXDMASREQ;
  UARTRXDMABREQ <= IntRXDMABREQ;

-- ---------------------------------------------------------------------
-- Assign the Revision number
-- ---------------------------------------------------------------------
  TieOff1       <= "0010";
  TieOff2       <= "1111";

  

  
-- Register block for normal mode registers
  uUartRegBlock : UartRegBlock
  port map (
            PCLK            => PCLK,
            PRESETn         => PRESETn,
        
            RXFRdPtrInc     => RXFRdPtrInc,
            PWDATAIn        => PWDATAIn,
            RXFRdData       => RXFRdData(10 downto 8),
        
            UARTECRWrEn     => UARTECRWrEn, 
            UARTLCRHnewWrEn => UARTLCRHnewWrEn, 
            UARTILPRWrEn    => UARTILPRWrEn, 
            UARTCRnewWrEn   => UARTCRnewWrEn, 
            UARTICRWrEn     => UARTICRWrEn,
            UARTIBRDWrEn    => UARTIBRDWrEn,
            UARTFBRDWrEn    => UARTFBRDWrEn,
            UARTIFLSWrEn    => UARTIFLSWrEn,
            UARTIMSCWrEn    => UARTIMSCWrEn,
            UARTDMACRWrEn   => UARTDMACRWrEn,
        
            UARTOEIClr      => UARTOEIClr,
            UARTRTRIS       => UARTRTRIS,
            UARTRISerrSync  => UARTRISerrSync,
            UARTRISmodSync  => UARTRISmodSync,
            UARTTXIClr      => UARTTXIClr,  
            UARTRXIClr      => UARTRXIClr,   
        
            LCRUpdate       => LCRUpdate, 
            ILPRUpdate      => ILPRUpdate, 
            FBRDUpdate      => FBRDUpdate,
            
            UARTICR         => UARTICR,
            RXSTATUS        => RXSTATUS,
            UARTLCRH        => UARTLCRH,
            UARTLCRM        => UARTLCRM,
            UARTLCRL        => UARTLCRL,
            UARTILPR        => UARTILPR,
            UARTCR          => UARTCR,
            UARTIFLS        => UARTIFLS,
            UARTDMACR       => UARTDMACR,
            UARTFBRD        => UARTFBRD,
            UARTIMSC        => UARTIMSC
            );
  

-- This block provides the interface to the APB bus
  uUartApbif : UartApbif
  port map (
            PCLK            => PCLK,  
            PRESETn         => PRESETn, 
        
            PSEL            => PSEL, 
            PWRITE          => PWRITE, 
            PENABLE         => PENABLE, 
            PADDR           => PADDR,
            PWDATA          => PWDATA,
        
            RXFF            => RXFF, 
            TXFF            => TXFF, 
            RXFE            => RXFE, 
            TXFE            => TXFE, 
            BUSY            => BUSY, 

            UARTTXRIS       => UARTTXRIS, 
            UARTTXMIS       => UARTTXMIS, 
            UARTRXRIS       => UARTRXRIS, 
            UARTRXMIS       => UARTRXMIS, 
            UARTOERIS       => UARTOERIS, 
            UARTOEMIS       => UARTOEMIS, 
            UARTRTRIS       => UARTRTRIS, 
            UARTRISmodSync  => UARTRISmodSync,
            UARTRISerrSync  => UARTRISerrSync,
            UARTMISerrSync  => UARTMISerrSync,
            UARTMISmodSync  => UARTMISmodSync,

            SIRIN           => SIRINint, 
            UARTRXD         => UARTRXDint, 

            RXFRdData       => RXFRdData,
            TXFIFOData      => TXFIFOData,
            RXSTATUS        => RXSTATUS,
            Revision        => Revision,
            OverrunDet      => OverrunDet,   
            TESTFIFO        => UARTTCR(1),   

            UARTLCRH        => UARTLCRH,
            UARTLCRM        => UARTLCRM,
            UARTLCRL        => UARTLCRL,
            UARTFBRD        => UARTFBRD,
            UARTCR          => UARTCR,
            UARTILPR        => UARTILPR,
            UARTTCR         => UARTTCR,
            UARTIFLS        => UARTIFLS,
            UARTIMSC        => UARTIMSC,
            UARTDMACR       => UARTDMACR,
            UARTITOP        => UARTITOP,
            nDCDSyncPCLK    => nDCDSyncPCLK,  
            nDSRSyncPCLK    => nDSRSyncPCLK,  
            nCTSSyncPCLK    => nCTSSyncPCLK,  
            nRISyncPCLK     => nRISyncPCLK,
            nUARTDCD        => nUARTDCD,
            nUARTDSR        => nUARTDSR,
            nUARTCTS        => nUARTCTS,
            nUARTRI         => nUARTRI,
            
            UARTTXDMACLR    => IntUARTTXDMACLR, 
            UARTRXDMACLR    => IntUARTRXDMACLR, 
        
            IntTXDMASREQ    => IntTXDMASREQ, 
            IntTXDMABREQ    => IntTXDMABREQ, 
            IntRXDMASREQ    => IntRXDMASREQ, 
            IntRXDMABREQ    => IntRXDMABREQ, 
            IntMSINTR       => IntMSINTR, 
            IntUARTRXMIS    => IntUARTRXMIS, 
            IntUARTTXMIS    => IntUARTTXMIS, 
            IntUARTRTRIS    => IntUARTRTRIS, 
            IntUARTEINTR    => IntUARTEINTR, 
            IntUARTINTR     => IntUARTINTR, 
        
            UARTDRWrEn      => UARTDRWrEn, 
            UARTECRWrEn     => UARTECRWrEn, 
            UARTLCRHnewWrEn => UARTLCRHnewWrEn, 
            PWDATAIn        => PWDATAIn,
            PRDATA          => PRDATA,
         
            UARTREINTR      => UARTREINTR, 
            RXFRdPtrInc     => RXFRdPtrInc, 
        
            UARTCRnewWrEn   => UARTCRnewWrEn, 
            UARTICRWrEn     => UARTICRWrEn, 
            UARTILPRWrEn    => UARTILPRWrEn, 
            UARTTDRWrEn     => UARTTDRWrEn, 
            UARTIBRDWrEn    => UARTIBRDWrEn, 
            UARTFBRDWrEn    => UARTFBRDWrEn, 
            UARTIFLSWrEn    => UARTIFLSWrEn, 
            UARTIMSCWrEn    => UARTIMSCWrEn, 
            UARTDMACRWrEn   => UARTDMACRWrEn, 
            UARTTDRrd       => UARTTDRrd, 
            UARTTCRWrEn     => UARTTCRWrEn, 
            UARTITIPWrEn    => UARTITIPWrEn, 
            UARTITOPWrEn    => UARTITOPWrEn
            );
  

-- Synchronisers for signals crossing into PCLK domain
  uUartSynctoPCLK : UartSynctoPCLK
  port map (
            PCLK             => PCLK, 
            PRESETn          => PRESETn, 
        
            TXBUSY           => TXBUSY, 
            TXFRdPtrInc      => TXFRdPtrInc, 
            RXFWr            => RXFWr, 
            Abort            => Abort, 
            DataStp          => DataStp, 
        
            nDCD             => nUARTDCDint, 
            nDSR             => nUARTDSRint, 
            nCTS             => nUARTCTSint, 
            nRI              => nUARTRIint, 
            UARTRISmod       => UARTRISmod,
            UARTMISmod       => UARTMISmod,
            UARTRISerr       => UARTRISerr,
            UARTMISerr       => UARTMISerr,

            IntUARTTXDMACLR  => IntUARTTXDMACLR,
            IntUARTRXDMACLR  => IntUARTRXDMACLR,
            CharTxComp       => CharTxComp,
            
            TXBUSYSync       => TXBUSYSync,
            TXFRdPtrIncSync  => TXFRdPtrIncSync,
            RXFWrSync        => RXFWrSync,
            AbortSync        => AbortSync,
        
            nDCDSyncPCLK     => nDCDSyncPCLK,
            nDSRSyncPCLK     => nDSRSyncPCLK,
            nCTSSyncPCLK     => nCTSSyncPCLK,
            nRISyncPCLK      => nRISyncPCLK,
            UARTRTRIS        => UARTRTRIS,
            UARTRISmodSync   => UARTRISmodSync,
            UARTMISmodSync   => UARTMISmodSync,
            UARTRISerrSync   => UARTRISerrSync,
            UARTMISerrSync   => UARTMISerrSync,
 
            UARTTXDMACLRSync => UARTTXDMACLRSync,
            UARTRXDMACLRSync => UARTRXDMACLRSync,
            CharTxCompSync   => CharTxCompSync
           );
  

  -- Synchronisers for signals crossing into UARTCLK domain
  uUartSynctoUCLK : UartSynctoUCLK
  port map (
            UARTCLK          => UARTCLK, 
            nUARTRST         => nUARTRST, 
            
            BRK              => UARTLCRH(0), 
            SIRLP            => UARTCR(2), 
            SIREN            => UARTCR(1), 
            UARTEN           => UARTCR(0), 
            TXE              => UARTCR(8), 
            RXE              => UARTCR(9), 
            TXDataAvlbl      => TXDataAvlbl, 
            RXFE             => RXFE, 
            CTSEn            => UARTCR(15), 
            LCRUpdate        => LCRUpdate, 
            ILPRUpdate       => ILPRUpdate, 
            FBRDUpdate       => FBRDUpdate, 
            UARTRXD          => UARTRXDint, 
            SIRIN            => SIRINint, 
            RXFWrDone        => RXFWrDone, 
            RdPtrIncDone     => RdPtrIncDone, 
            
            DCDIM            => UARTIMSC(2), 
            DSRIM            => UARTIMSC(3), 
            CTSIM            => UARTIMSC(1), 
            RIIM             => UARTIMSC(0), 
            RTIM             => UARTIMSC(6), 
            FEIM             => UARTIMSC(7), 
            PEIM             => UARTIMSC(8), 
            BEIM             => UARTIMSC(9), 
            
            nDCD             => nUARTDCDint, 
            nDSR             => nUARTDSRint, 
            nCTS             => nUARTCTSint, 
            nRI              => nUARTRIint, 
            UARTDCDIC        => UARTICR(2), 
            UARTDSRIC        => UARTICR(3), 
            UARTCTSIC        => UARTICR(1), 
            UARTRIIC         => UARTICR(0), 
            UARTFEIC         => UARTICR(7), 
            UARTPEIC         => UARTICR(8), 
            UARTBEIC         => UARTICR(9), 
            UARTRTIC         => UARTICR(6), 
        
            SIRLPSync        => SIRLPSync, 
            SIRENSync        => SIRENSync, 
            UARTENSync       => UARTENSync, 
            TXESync          => TXESync, 
            RXESync          => RXESync, 
            TXDataAvlblSync  => TXDataAvlblSync, 
            RXFESync         => RXFESync, 
            CTSEnSyncUCLK    => CTSEnSyncUCLK, 
            LCRUpdateSync    => LCRUpdateSync, 
            ILPRUpdateSync   => ILPRUpdateSync, 
            FBRDUpdateSync   => FBRDUpdateSync,
            UARTRXDSync      => UARTRXDSync, 
            SIRINSync        => SIRINSync, 
            RXFWrDoneSync    => RXFWrDoneSync, 
            RdPtrIncDoneSync => RdPtrIncDoneSync, 
        
            DCDIMSync        => DCDIMSync, 
            DSRIMSync        => DSRIMSync, 
            CTSIMSync        => CTSIMSync, 
            RIIMSync         => RIIMSync, 
            RTIMSync         => RTIMSync, 
            FEIMSync         => FEIMSync, 
            PEIMSync         => PEIMSync, 
            BEIMSync         => BEIMSync, 
        
            nDCDSyncUARTCLK  => nDCDSyncUARTCLK, 
            nDSRSyncUARTCLK  => nDSRSyncUARTCLK, 
            nCTSSyncUARTCLK  => nCTSSyncUARTCLK, 
            nRISyncUARTCLK   => nRISyncUARTCLK, 
            UARTDCDICSync    => UARTDCDICSync, 
            UARTDSRICSync    => UARTDSRICSync, 
            UARTCTSICSync    => UARTCTSICSync, 
            UARTRIICSync     => UARTRIICSync, 
            UARTFEICSync     => UARTFEICSync, 
            UARTPEICSync     => UARTPEICSync, 
            UARTBEICSync     => UARTBEICSync, 
            UARTRTICSync     => UARTRTICSync,
            BRKSync          => BRKSync
            );
  
-- Modem interrupt generation block
  uUartModem : UartModem
  port map (
            UARTCLK         => UARTCLK, 
            nUARTRST        => nUARTRST, 
        
            SIRENSync       => SIRENSync, 
        
            nDCDSyncUARTCLK => nDCDSyncUARTCLK,
            nDSRSyncUARTCLK => nDSRSyncUARTCLK,
            nCTSSyncUARTCLK => nCTSSyncUARTCLK,
            nRISyncUARTCLK  => nRISyncUARTCLK,
        
            UARTDCDICSync   => UARTDCDICSync,
            UARTDSRICSync   => UARTDSRICSync,
            UARTCTSICSync   => UARTCTSICSync,
            UARTRIICSync    => UARTRIICSync,
        
            DCDIMSync       => DCDIMSync,
            DSRIMSync       => DSRIMSync,
            CTSIMSync       => CTSIMSync,
            RIIMSync        => RIIMSync,
            
            UARTMSINT       => UARTMSINT,
            UARTRISmod      => UARTRISmod,
            UARTMISmod      => UARTMISmod
            );
  

-- UART Test logic
  uUartTest : UartTest
  port map (
            PCLK            => PCLK,
            PRESETn         => PRESETn,
        
            LBE             => UARTCR(7),
        
            UARTTCRWrEn     => UARTTCRWrEn, 
            UARTITIPWrEn    => UARTITIPWrEn, 
            UARTITOPWrEn    => UARTITOPWrEn, 
            UARTTDRrd       => UARTTDRrd, 
        
            PWDATAIn        => PWDATAIn(15 downto 0),
            UARTRXD         => UARTRXD, 
            SIRIN           => SIRIN, 
            UARTTXDint      => UARTTXDint, 
            nSIROUTint      => nSIROUTint, 
        
            nUARTCTS        => nUARTCTS, 
            nUARTDSR        => nUARTDSR, 
            nUARTDCD        => nUARTDCD, 
            nUARTRI         => nUARTRI, 
            nUARTRTSint     => nUARTRTSint, 
            nUARTDTRint     => nUARTDTRint, 
            nUARTOut2int    => nUARTOut2int, 
            nUARTOut1int    => nUARTOut1int, 
        
            UARTTXDMACLR    => UARTTXDMACLR, 
            UARTRXDMACLR    => UARTRXDMACLR, 
            TXDMASREQ       => TXDMASREQ, 
            TXDMABREQ       => TXDMABREQ, 
            RXDMASREQ       => RXDMASREQ, 
            RXDMABREQ       => RXDMABREQ, 
        
            MSINTR          => MSINTR, 
            UARTRXMIS       => UARTRXMIS, 
            UARTTXMIS       => UARTTXMIS, 
            RTINTR          => RTINTR, 
            EINTR           => EINTR, 
            UARTINT         => UARTINT, 
        
            UARTRXDint      => UARTRXDint, 
            SIRINint        => SIRINint, 
            UARTTCR         => UARTTCR,
            UARTITOP        => UARTITOP,
            TestTXFInc      => TestTXFInc, 
        
            nUARTDSRint     => nUARTDSRint, 
            nUARTCTSint     => nUARTCTSint, 
            nUARTDCDint     => nUARTDCDint, 
            nUARTRIint      => nUARTRIint, 
        
            IntUARTTXDMACLR => IntUARTTXDMACLR, 
            IntUARTRXDMACLR => IntUARTRXDMACLR, 
            IntTXDMASREQ    => IntTXDMASREQ, 
            IntTXDMABREQ    => IntTXDMABREQ, 
            IntRXDMASREQ    => IntRXDMASREQ, 
            IntRXDMABREQ    => IntRXDMABREQ, 
        
            IntMSINTR       => IntMSINTR, 
            IntUARTRXMIS    => IntUARTRXMIS, 
            IntUARTTXMIS    => IntUARTTXMIS, 
            IntUARTRTRIS    => IntUARTRTRIS, 
            IntUARTEINTR    => IntUARTEINTR, 
            IntUARTINTR     => IntUARTINTR, 
        
            nUARTOut2       => inUARTOut2, 
            nUARTOut1       => inUARTOut1, 
            nUARTRTS        => inUARTRTS, 
            nUARTDTR        => inUARTDTR, 
            nSIROUT         => inSIROUT, 
            UARTTXD         => iUARTTXD
            );
  

-- UART Receiver
  uUartReceive : UartReceive
  port map (
            UARTCLK         => UARTCLK, 
            nUARTRST        => nUARTRST, 
        
            UARTENSync      => UARTENSync, 
            SIRENSync       => SIRENSync,
            RXESync         => RXESync,
            Baud16          => Baud16,
            WLEN	    => LCRH(5 downto 4),
            STP2            => LCRH(3), 
            EPS             => LCRH(2), 
            PEN             => LCRH(1), 
            SPS             => LCRH(6), 
            RXFWrDoneSync   => RXFWrDoneSync, 
            Zerobaud        => Zerobaud, 
            RXFESync        => RXFESync, 
            RXD	            => RXD, 
        
            RTIMSync        => RTIMSync, 
            FEIMSync        => FEIMSync, 
            PEIMSync        => PEIMSync, 
            BEIMSync        => BEIMSync, 
            UARTRTICSync    => UARTRTICSync, 
            UARTFEICSync    => UARTFEICSync, 
            UARTPEICSync    => UARTPEICSync, 
            UARTBEICSync    => UARTBEICSync, 
        
            RXFWr	    => RXFWr, 
            RXFIFOData      => RXFIFOData,
            DataStp         => DataStp,
            RXBUSY	    => RXBUSY,
            RXEnable        => RXEnable,
            UartRXCntlState => UartRXCntlState,
            UARTRISerr      => UARTRISerr,
            UARTMISerr      => UARTMISerr,
            UARTEINTRfbp    => UARTEINTRfbp, 
            CharRxComp      => CharRxComp
            );
  
  
-- Receive FIFO
  uUartRXFIFO : UartRXFIFO
  port map (
            PCLK        => PCLK, 
            PRESETn     => PRESETn,
        
            PWDATAIn    => PWDATAIn(11 downto 0),
            RXFWrSync   => RXFWrSync,	
            RXFRdPtrInc => RXFRdPtrInc,  
            RXFIFOData  => RXFIFOData,
            UARTECRWrEn => UARTECRWrEn,	  
            UARTTDRWrEn => UARTTDRWrEn,	 
            FEN	        => UARTLCRH(4),	
            RTSEn       => UARTCR(14),  
            TESTFIFO    => UARTTCR(1),	
            nUARTRTScr  => inUARTRTScr,  
        
            RXIFLSEL    => UARTIFLS(5 downto 3),
            UARTRXIC    => UARTICR(4), 
            UARTOEIC    => UARTICR(10),  
            RXIM        => UARTIMSC(4),  
            OEIM        => UARTIMSC(10),  
        
            RXFRdData   => RXFRdData,
            RXFWrDone   => RXFWrDone,  
            RXFE        => RXFE,	  
            RXFF        => RXFF,	 
            OverrunDet  => OverrunDet,	 
            nUARTRTSint => nUARTRTSint,   
            RXFGTE1Full => RXFGTE1Full,   
            RXIntLevel  => RXIntLevel,   
        
            UARTRXIClr  => UARTRXIClr,  
            UARTOEIClr  => UARTOEIClr,  
            UARTRXRIS   => UARTRXRIS,  
            UARTRXMIS   => UARTRXMIS,  
            UARTOERIS   => UARTOERIS,  
            UARTOEMIS   => UARTOEMIS
            );
  

-- Transmit FIFO
  uUartTXFIFO : UartTXFIFO
  port map (
            PCLK    	    => PCLK, 
            PRESETn	    => PRESETn,
        
            PWDATAIn	    => PWDATAIn(7 downto 0),
            UARTEN    	    => UARTCR(0), 
            TXE	            => UARTCR(8), 
            TXFRdPtrIncSync => TXFRdPtrIncSync,
            FEN	            => UARTLCRH(4),
            BRK             => UARTLCRH(0),
            AbortSync	    => AbortSync,
            
            UARTDRWrEn	    => UARTDRWrEn,
            TestTXFInc      => TestTXFInc,
            TXBUSYSync	    => TXBUSYSync,
            TESTFIFO        => UARTTCR(1),
            CharTxCompSync  => CharTxCompSync,
        
            UARTTXIC        => UARTICR(5),
            TXIM            => UARTIMSC(5),
            TXIFLSEL	    => UARTIFLS(2 downto 0),
        
            TXShiftData	    => TXShiftData,
            TXFF	    => TXFF,
            TXFE	    => TXFE,
            TXDataAvlbl	    => TXDataAvlbl,
            RdPtrIncDone    => RdPtrIncDone,
            BUSY	    => BUSY,
            TXFIFOData      => TXFIFOData,
            TXFLTE15Full    => TXFLTE15Full,  
            TXIntLevel      => TXIntLevel, 
        
            UARTTXIClr      => UARTTXIClr,
            UARTTXRIS	    => UARTTXRIS,
            UARTTXMIS	    => UARTTXMIS
            );
  

-- IrDA encoder/decoder
  uUartIrDA : UartIrDA
  port map (
            UARTCLK     => UARTCLK, 
            nUARTRST    => nUARTRST, 
        
            Baud16      => Baud16, 
            IrLPBaud16  => IrLPBaud16, 
            SIRLPSync   => SIRLPSync, 
            SIRENSync   => SIRENSync, 
            SIRTEST     => UARTTCR(2), 
        
            StopBaudCnt => StopBaudCnt, 
            TXBUSY      => TXBUSY, 
            RXBUSY      => RXBUSY, 
        
            TXD         => TXD, 
            SIRINSync   => SIRINSync, 
            UARTRXDSync => UARTRXDSync, 
            
            UARTTXDint  => UARTTXDint, 
            RXD         => RXD, 
            nSIROUTint  => nSIROUTint
            );
  

-- Baud rate generator
  uUartBaudCntr : UartBaudCntr
  port map (
            UARTCLK        => UARTCLK, 
            nUARTRST       => nUARTRST, 
        
            LCRUpdateSync  => LCRUpdateSync, 
            ILPRUpdateSync => ILPRUpdateSync, 
            FBRDUpdateSync => FBRDUpdateSync,

            SIRENSync      => SIRENSync, 
            SIRLPSync      => SIRLPSync,
            CharTxComp     => CharTxComp,
            CharRxComp     => CharRxComp,
      
            StopBaudCnt    => StopBaudCnt,
            FracValue      => UARTFBRD(5 downto 0),
        
            UARTLCRHInt    => UARTLCRHInt,
            UARTLCRM       => UARTLCRM,
            UARTLCRL       => UARTLCRL,
            UARTILPR       => UARTILPR,
        
            Baud16         => Baud16,
            IrLPBaud16     => IrLPBaud16,
            LCRH           => LCRH,
            Abort          => Abort,
            Zerobaud       => Zerobaud
            );
    
  UARTLCRHInt <= UARTLCRH(7 downto 5) & UARTLCRH(3 downto 0);

  

-- UART Transmitter
  uUartTXCntl : UartTXCntl
  port map (
            UARTCLK          => UARTCLK,
            nUARTRST         => nUARTRST,
          
            RXEnable         => RXEnable,
            UartRXCntlState  => UartRXCntlState,
            CTSEn            => CTSEnSyncUCLK,
        
            nCTSSyncUARTCLK  => nCTSSyncUARTCLK, 
            Baud16           => Baud16, 
            TXDataAvlblSync  => TXDataAvlblSync, 
            RdPtrIncDoneSync => RdPtrIncDoneSync, 
            UARTENSync       => UARTENSync, 
            TXESync          => TXESync, 
            
            TXShiftData      => TXShiftData,
            WLEN             => LCRH(5 downto 4),
            STP2             => LCRH(3), 
            PEN              => LCRH(1), 
            EPS              => LCRH(2), 
            BRK              => BRKSync, 
            Zerobaud         => Zerobaud, 
            SPS              => LCRH(6), 
        
            TXFRdPtrInc      => TXFRdPtrInc, 
            TXD              => TXD, 
            TXBUSY           => TXBUSY, 
            StopBaudCnt      => StopBaudCnt, 
            CharTxComp       => CharTxComp 
            );
  
  
 -- DMA Interface
  uUartDMA : UartDMA
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
        
            UARTEN           => UARTCR(0),
            TXDMAE           => UARTDMACR(1),
            RXDMAE           => UARTDMACR(0),
            DMAONERR         => UARTDMACR(2),
            TXE              => UARTCR(8),
            RXE              => UARTCR(9),
            FEN              => UARTLCRH(4),
          
            TESTFIFO         => UARTTCR(1),
            TXIntLevel       => TXIntLevel,
            RXIntLevel       => RXIntLevel,
            TXFLTE15Full     => TXFLTE15Full,
            RXFGTE1Full      => RXFGTE1Full,
            UARTTXDMACLRSync => UARTTXDMACLRSync,
            UARTRXDMACLRSync => UARTRXDMACLRSync,
            UARTREINTR       => UARTREINTR,
        
            TXDMASREQ        => TXDMASREQ,
            TXDMABREQ        => TXDMABREQ,
            RXDMASREQ        => RXDMASREQ,
            RXDMABREQ        => RXDMABREQ
            );
  
-- Interrupt block
  uUartInterrupt : UartInterrupt
  port map (
            DataStp      => DataStp,  
            UARTMSINT    => UARTMSINT,  
            UARTEINTRfbp => UARTEINTRfbp,  
            UARTTXMIS    => UARTTXMIS,  
            UARTRXMIS    => UARTRXMIS, 
            UARTOEMIS    => UARTOEMIS, 

            UARTRTIC     => UARTICR(6),    
            UARTDSRIC    => UARTICR(3),    
            UARTDCDIC    => UARTICR(2),    
            UARTCTSIC    => UARTICR(1),    
            UARTRIIC     => UARTICR(0),    
            UARTOEIC     => UARTICR(10),    
            UARTBEIC     => UARTICR(9),    
            UARTPEIC     => UARTICR(8),    
            UARTFEIC     => UARTICR(7),    
        
            RTINTR       => RTINTR,    
            MSINTR       => MSINTR,    
            EINTR        => EINTR,    
            UARTINT      => UARTINT
            );
  
  
 -- ---------------------------------------------------------------------
-- 1st instantiation of UartRevAnd
-- ---------------------------------------------------------------------
u0UartRevAnd : UartRevAnd
  port map (
            TieOff1          => TieOff1(0),
            TieOff2          => TieOff2(0),
            
            Revision         => Revision(0)
           );

-- ---------------------------------------------------------------------
-- 2nd instantiation of UartRevAnd
-- ---------------------------------------------------------------------
u1UartRevAnd : UartRevAnd
  port map (
            TieOff1          => TieOff1(1),
            TieOff2          => TieOff2(1),
            
            Revision         => Revision(1)
           );

-- ---------------------------------------------------------------------
-- 3rd instantiation of UartRevAnd
-- ---------------------------------------------------------------------
u2UartRevAnd : UartRevAnd
  port map (
            TieOff1          => TieOff1(2),
            TieOff2          => TieOff2(2),
            
            Revision         => Revision(2)
           );

-- ---------------------------------------------------------------------
-- 4th instantiation of UartRevAnd
-- ---------------------------------------------------------------------
u3UartRevAnd : UartRevAnd
  port map (
            TieOff1          => TieOff1(3),
            TieOff2          => TieOff2(3),
            
            Revision         => Revision(3)
           );

end structural;
