/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- VHDL translation of package (except components) 'vusb_hs_pkg'

*******************************************************************************/
// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_pkg.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Design constants used throughout vusb_hs.
// 
// ------------------------------------------------------------------------------
//  ChipIdea Microelectronica - IPCS                                             
//  TECMAIA, Rua Eng. Frederico Ulrich, n 2650                                   
//  4470-920 MOREIRA MAIA                                                        
//  Portugal                                                                     
//  Tel: +351 229471010                                                          
//  Fax: +351 229471011                                                          
//  e_mail: chipidea@chipidea.com                                                
// ------------------------------------------------------------------------------
//  ISO 9001:2000 - Certified Company                                            
//  (C) 2005 Copyright Chipidea(R)                                               
//  Chipidea(R) - Microelectronica, S.A. reserves the right to make changes to   
//  the information contained herein without notice. No liability shall be       
//  incurred as a result of its use or application.                              
// ------------------------------------------------------------------------------
//  Last modification   :                                                        
//  $Date: 2006-08-09 19:14:11 +0100 (Wed, 09 Aug 2006) $                                                                       
//  $Revision: 169 $                                                                   
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Identification Register Address Map
//    --> See Bit Definitions In Spec. <--
// ---------------------------------------------------------------------------
parameter ID = 8'b 00000101; 
parameter ID_INV = 8'b 11111010; 
parameter ID_REVISION = 8'b 01000010; //  REV4.2.XXXXXX
parameter ADDR_ID = 7'b 0000000; //  000
parameter ADDR_HWGENERAL = 7'b 0000001; //  004
parameter ADDR_HWHOST = 7'b 0000010; //  008
parameter ADDR_HWDEVICE = 7'b 0000011; //  00C
parameter ADDR_HWTXBUF = 7'b 0000100; //  010
parameter ADDR_HWRXBUF = 7'b 0000101; //  014
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Static Hardware Configuration of the TXFIFO (optional add/on)
// ---------------------------------------------------------------------------
parameter ADDR_TXFIFO_SEL0 = 7'b 0010000; // 040
parameter ADDR_TXFIFO_SEL0I = 16; 
parameter ADDR_TXFIFO_SEL1 = 7'b 0010001; // 044
parameter ADDR_TXFIFO_SEL2 = 7'b 0010010; // 048
parameter ADDR_TXFIFO_SEL3 = 7'b 0010011; // 04C
parameter ADDR_TXFIFO_SEL4 = 7'b 0010100; // 050
parameter ADDR_TXFIFO_SEL5 = 7'b 0010101; // 054
parameter ADDR_TXFIFO_SEL6 = 7'b 0010110; // 058
parameter ADDR_TXFIFO_SEL7 = 7'b 0010111; // 05C
parameter ADDR_TXFIFO_SEL8 = 7'b 0011000; // 060
parameter ADDR_TXFIFO_SEL9 = 7'b 0011001; // 064
parameter ADDR_TXFIFO_SEL10 = 7'b 0011010; // 068
parameter ADDR_TXFIFO_SEL11 = 7'b 0011011; // 06C
parameter ADDR_TXFIFO_SEL12 = 7'b 0011100; // 070
parameter ADDR_TXFIFO_SEL13 = 7'b 0011101; // 074
parameter ADDR_TXFIFO_SEL14 = 7'b 0011110; // 078
parameter ADDR_TXFIFO_SEL15 = 7'b 0011111; // 07C
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: General Purpose Timers
// ---------------------------------------------------------------------------
parameter ADDR_TIMER0_LD = 7'b 0100000; // 080;
parameter ADDR_TIMER0_CTRL = 7'b 0100001; // 084;
parameter ADDR_TIMER1_LD = 7'b 0100010; // 088;
parameter ADDR_TIMER1_CTRL = 7'b 0100011; // 08C;
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: System bus configuration register
// ---------------------------------------------------------------------------
parameter ADDR_SBUSCFG = 7'b 0100100; // 90
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Microprocessor Address Map (Debug Registers)
// ---------------------------------------------------------------------------
parameter ADDR_EPPRIMEBREAK = 7'b 0111100; // 0F4 -- Endpoint Buffer Control - Prime Break(Read Only)
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Microprocessor Address Map (Capability Registers)
//    --> See Bit Definitions In Spec. <--
// ---------------------------------------------------------------------------
//  universal capability address map
parameter ADDR_CAPLENGTH = 7'b 1000000; //  100
//  host;host/device capability address map 
parameter ADDRH_HCIVERSION = 7'b 1000000; //  100
parameter ADDRH_HCSPARAMS = 7'b 1000001; //  104
parameter ADDRH_HCCPARAMS = 7'b 1000010; //  108
parameter ADDRH_DCIVERSION = 7'b 1001000; //  120
parameter ADDRH_DCCPARAMS = 7'b 1001001; //  124
//  device only capability address map
parameter ADDRD_HCSPARAMS = ADDRH_HCSPARAMS; 
parameter ADDRD_DCIVERSION = ADDRH_DCIVERSION; 
parameter ADDRD_DCCPARAMS = ADDRH_DCCPARAMS; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Microprocessor Address Map (Control Registers)
//    --> See Bit Definitions In Spec. <--
// ---------------------------------------------------------------------------
//  host;host/device address map
parameter ADDR_USBCMD = 7'b 1010000; // 140 
parameter ADDR_USBSTS = 7'b 1010001; // 144
parameter ADDR_USBINTR = 7'b 1010010; // 148
parameter ADDR_FRINDEX = 7'b 1010011; // 14C
parameter ADDRH_PLISTBASE = 7'b 1010101; // 154
parameter ADDRH_ALISTBASE = 7'b 1010110; // 158
parameter ADDRH_TT_STS = 7'b 1010111; // 15C
parameter ADDR_BURST_SIZE = 7'b 1011000; // 160
parameter ADDRH_TX_FILLTUNING = 7'b 1011001; // 164
parameter ADDRH_TX_TT_FILLTUNING = 7'b 1011010; // 168
parameter ADDR_ULPI = 7'b 1011100; // 170
parameter ADDR_CONFIGFLAG = 7'b 1100000; // 180
parameter ADDR_PORT0 = 7'b 1100001; // 184
parameter ADDR_PORT1 = 7'b 1100010; // 188
parameter ADDR_PORT2 = 7'b 1100011; // 18C
parameter ADDR_PORT3 = 7'b 1100100; // 190
parameter ADDR_PORT4 = 7'b 1100101; // 194
parameter ADDR_PORT5 = 7'b 1100110; // 198
parameter ADDR_PORT6 = 7'b 1100111; // 19C
parameter ADDR_PORT7 = 7'b 1101000; // 1A0
parameter ADDR_OTG = 7'b 1101001; // 1A4
parameter ADDR_MODE = 7'b 1101010; // 1A8
//  device only address map
parameter ADDRD_DEVADDR = 7'b 1010101; // 154
parameter ADDRD_EPLISTBASE = 7'b 1010110; // 158
parameter ADDR_VFRAME = 7'b 1011101; // 174 -- Virtual Frame 
parameter ADDR_EPNAK = 7'b 1011110; // 178 -- Endpoint Nak Detect
parameter ADDR_EPNAKEN = 7'b 1011111; // 17C -- Endpoint Nak Detect Enable
parameter ADDR_EPSSTATUS = 7'b 1101011; // 1AC -- Endpoint Setup Acknowledge
parameter ADDR_EPPRIME = 7'b 1101100; // 1B0 -- Endpoint Buffer Control - Prime
parameter ADDR_EPFLUSH = 7'b 1101101; // 1B4 -- Endpoint Buffer Control - Flush
parameter ADDR_EPSTATUS = 7'b 1101110; // 1B8 -- Endpoint Buffer Control - Status
parameter ADDR_EPCOMPLETE = 7'b 1101111; // 1BC -- Endpoint Buffer Control - Complete
parameter ADDR_ENDPTCTRL0 = 7'b 1110000; // 1C0 -- Endpoint Control* address 0
parameter ADDR_ENDPTCTRL1 = 7'b 1110001; // 1C4 -- Endpoint Control* address 1
parameter ADDR_ENDPTCTRL2 = 7'b 1110010; // 1C8 -- Endpoint Control* address 2
parameter ADDR_ENDPTCTRL3 = 7'b 1110011; // 1CC -- Endpoint Control* address 3
parameter ADDR_ENDPTCTRL4 = 7'b 1110100; // 1D0 -- Endpoint Control* address 4
parameter ADDR_ENDPTCTRL5 = 7'b 1110101; // 1D4 -- Endpoint Control* address 5
parameter ADDR_ENDPTCTRL6 = 7'b 1110110; // 1D8 -- Endpoint Control* address 6
parameter ADDR_ENDPTCTRL7 = 7'b 1110111; // 1DC -- Endpoint Control* address 7
parameter ADDR_ENDPTCTRL8 = 7'b 1111000; // 1E0 -- Endpoint Control* address 8
parameter ADDR_ENDPTCTRL9 = 7'b 1111001; // 1E4 -- Endpoint Control* address 9
parameter ADDR_ENDPTCTRL10 = 7'b 1111010; // 1E8 -- Endpoint Control* address 10
parameter ADDR_ENDPTCTRL11 = 7'b 1111011; // 1EC -- Endpoint Control* address 11
parameter ADDR_ENDPTCTRL12 = 7'b 1111100; // 1F0 -- Endpoint Control* address 12
parameter ADDR_ENDPTCTRL13 = 7'b 1111101; // 1F4 -- Endpoint Control* address 13
parameter ADDR_ENDPTCTRL14 = 7'b 1111110; // 1F8 -- Endpoint Control* address 14
parameter ADDR_ENDPTCTRL15 = 7'b 1111111; // 1FC -- Endpoint Control* address 15
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Test Register Address Map (for test purposes only)
//    --> Bit Definitions Are NOT In Spec. <--
//    --> Bit Definitions Below <--
// ---------------------------------------------------------------------------
//  bit 0 & 1 - traffic management task
//  00 - idle (or other)
//  01 - tx prime
//  10 - rx packet movement
//  11 - tx packet movement
//  bit 2 - setup bit received (R/WC)
parameter ADDR_TEST_DMA = 7'b 1001100; //  130
//  07:00 - inter-packet nak counter
//  09:08 - inter-packet mask mode
//  15:12 - sof arrival time status
parameter ADDR_TEST_PE = 7'b 1001101; //  134
//  0 - interrupt test bit
parameter ADDR_TEST_UP_INT = 7'b 1001110; //  138
// --------------------------------------------------------------------------
//  vusb_hs_pkg: Burst length counter width
//    --> Do not change this constant - internal use only.
// --------------------------------------------------------------------------
parameter MEM_BURST_LEN_CNT_WIDTH_BYTE = 10; 
parameter MEM_BURST_LEN_CNT_WIDTH_WORD = MEM_BURST_LEN_CNT_WIDTH_BYTE - 2'b 10; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Allow programable bursts.
//    --> Do not change this constant - internal use only.
// ---------------------------------------------------------------------------
parameter PROG_BURST_SIZE = 1; 
//  vusb_hs_pkg: Width of host pre-fill burst counter (non-EHCI)
//    --> Do not change this constant - internal use only.; max 8
// --------------------------------------------------------------------------
parameter HOST_FIFO_FILL_LEVEL_WIDTH = 6; 
//  vusb_hs_pkg: Width of host overhead adder (non-EHCI)
//    --> Do not change this constant - internal use only.; max 8
// --------------------------------------------------------------------------
parameter HOST_SCHED_OVERHEAD_WIDTH = 7; 
parameter HOST_SCHED_OVERHEAD_WIDTH_TT = 5; 
//  vusb_hs_pkg: Width of host scheduler health register (non-EHCI)
//    --> Do not change this constant - internal use only.; max 8
// --------------------------------------------------------------------------
parameter HOST_SCHED_BACKOFF_HEALTH_WIDTH = 5; 
parameter HOST_SCHED_BACKOFF_HEALTH_WIDTH_TT = 5; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: RX/TX Buffer Tag Fields
//    --> FIFO protocol in TAG are in 
// ---------------------------------------------------------------------------
parameter TAG_HOST_START = 4'b 0000; //  TX FIFO
parameter TAG_HOST_CMPLT = 4'b 0011; //  RX FIFO
parameter TAG_DEV_TX_ISO_STAT = 4'b 0100; //  RX FIFO
parameter TAG_DEV_RX_ISO_STAT = 4'b 0101; //  RX FIFO
parameter TAG_DEV_RX_SETUP_START = 4'b 0110; //  RX FIFO
parameter TAG_DEV_DATA_START = 4'b 0111; //  RX FIFO
parameter TAG_TX_EMPTY = 4'b 0111; //  TX FIFO
parameter TAG_TX_CMPLT = 4'b 1000; //  RX FIFO
parameter TAG_RX_CMPLT = 4'b 1001; //  RX FIFO
parameter TAG_EOP = 4'b 1010; //  TX FIFO
parameter TAG_0BYTES = 4'b 1011; //  TX,RX FIFO
parameter TAG_1BYTE = 4'b 1100; //  TX,RX FIFO
parameter TAG_2BYTES = 4'b 1101; //  TX,RX FIFO
parameter TAG_3BYTES = 4'b 1110; //  TX,RX FIFO
parameter TAG_4BYTES = 4'b 1111; //  TX,RX FIFO
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: End Point Prime Commands
//   --> prime protocol documented in VUSB_HS Engineering Doc (Internal Spec.) <--
// ---------------------------------------------------------------------------
//  flush buffer (if tx) and clear prime [and next prime]
parameter EP_CMD_FLUSH = 3'b 001; 
//  set endpoint prime (non-iso)
parameter EP_CMD_INC = 3'b 010; 
//  set one packet for next iso
parameter EP_CMD_SET1 = 3'b 101; 
//  set two packets for next iso
parameter EP_CMD_SET2 = 3'b 110; 
//  set three packets for next iso
parameter EP_CMD_SET3 = 3'b 111; 
//  After any packet is received, futher non-setup transactions are disabled
//  until the packet can be properly retired to memory.  The PE sets
//  the global prime mask bit upon receipt of any non-setup packet.  This
//  command is used to re-enable the global prime mask bit.  The global
//  prime mask bit is cleared on reset.
parameter EP_ALL_CMD_CLR_MASK = 3'b 100; 
//  After each setup packet, the correspoinding endpoint setup enable is cleared by the PE.
//  This command is used to set the setup enable bit for an endpoint.  After reset, the
//  endpoint setup enable bits are set to enable mode.
parameter EPS_CMD_SET = 3'b 011; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: USB 2.0 PIDs
// ---------------------------------------------------------------------------
parameter PID_OUT = 4'b 0001; //  Address + endpoint # host-to-function transaction
parameter PID_IN = 4'b 1001; //  Address + endpoint # function-to-host transaction
parameter PID_SOF = 4'b 0101; //  Start of frame marker and frame number
parameter PID_SETUP = 4'b 1101; //  Address + EP# host-to-func trans for setup to a control pipe
parameter PID_DATA0 = 4'b 0011; //  Data packet even
parameter PID_DATA1 = 4'b 1011; //  Data packet odd
parameter PID_DATA2 = 4'b 0111; //  Data packet high-speed, high-BW, isochronous
parameter PID_MDATA = 4'b 1111; //  Data packet for split or high-speed, high-BW, isochronous
parameter PID_ACK = 4'b 0010; //  Receiver accepts err-free packet
parameter PID_NAK = 4'b 1010; //  Cannot accept or transmit data
parameter PID_STALL = 4'b 1110; //  EP halted or control pipe request not supported
parameter PID_NYET = 4'b 0110; //  No response from receiver
parameter PID_PRE = 4'b 1100; //  Host issued preamble to enable LS
parameter PID_ERR = 4'b 1100; //  Split transaction errror handshake
parameter PID_SPLIT = 4'b 1000; //  HS split transaction token
parameter PID_PING = 4'b 0100; //  HS flow control probe for bulk/control EP
parameter PID_NONE = 4'b 0000; //  reserved pid number
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Watermark Pipeline Constant
// ---------------------------------------------------------------------------
//  This constant should NOT be changed.  This constant defines the how far
//  below(or above) the second mark is to the first.  The first water marks
//  (up1,down1) are one burst size from the limit of the fifos.  The WM_PIPELINE
//  defines the second water mark such that filling/emptying during the burst operation
//  to empty or fill can chain together.  In order for a chained operation to occur,
//  the decision to chain the bursts must be made several clock cycles before
//  the effect of the burst operation on the first watermark is known.  This
//  constant defines that number of clocks (pipeline stages).
// 
//     Decision Made (PIPE) Last Word Of Burst (PIPE) Water Mark 1 Updated
parameter WM_PIPELINE = 2; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: DMA Data Movement Request Commands
// ---------------------------------------------------------------------------
parameter BUS_REQ_IDLE = 3'b 000; 
parameter BUS_REQ_READ = 3'b 001; 
parameter BUS_REQ_WRITE = 3'b 010; 
parameter BUS_REQ_READ_TX = 3'b 011; 
parameter BUS_REQ_WRITE_RX = 3'b 100; 
parameter BUS_REQ_READ_TT_TX = 3'b 101; 
parameter BUS_REQ_WRITE_TT_RX = 3'b 110; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: EHCI Data Constants
// ---------------------------------------------------------------------------
parameter EHCI_PID_OUT = 2'b 00; 
parameter EHCI_PID_IN = 2'b 01; 
parameter EHCI_PID_SETUP = 2'b 10; 
parameter EHCI_SPEED_FS = 2'b 00; 
parameter EHCI_SPEED_LS = 2'b 01; 
parameter EHCI_SPEED_HS = 2'b 10; 
parameter EHCI_SPEED_DISCON = 2'b 11; //  used in the portctrl
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Host Report between Protocol Engine and DMA
// ---------------------------------------------------------------------------
parameter REPORT_HST_ACK = 4'b 0000; 
parameter REPORT_HST_NAK = 4'b 0001; 
parameter REPORT_HST_STALL = 4'b 0010; 
parameter REPORT_HST_NYET = 4'b 0011; 
parameter REPORT_HST_ERR = 4'b 0100; 
parameter REPORT_HST_OK = 4'b 0101; 
parameter REPORT_HST_INV_RESP = 4'b 0110; //  invalid/no response
parameter REPORT_HST_MIS_ERR = 4'b 0111; //  pid mismatch
parameter REPORT_HST_CRC_ERR = 4'b 1000; //  crc/bs
parameter REPORT_HST_FIFO_ERR = 4'b 1001; //  overruns/underruns
parameter REPORT_HST_MMIS_ERR = 4'b 1010; //  expecting specific pid and received mdata
parameter REPORT_HST_DATA0 = 4'b 1011; //  data0 received on ISO packet
parameter REPORT_HST_DATA1 = 4'b 1100; //  data1 received on ISO packet
parameter REPORT_HST_DATA2 = 4'b 1101; //  data2 received on ISO packet
parameter REPORT_HST_TX_FLUSH = 4'b 1110; //  fifo flushed; packet not sent
parameter REPORT_HST_BABBLE = 1'b 1; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: PE TX FIFO Command Bus
// 
//    Command Bus From Host/Device S/M to Data Path Logic
// 
// ---------------------------------------------------------------------------
parameter PE_DP_TXFIFO_IDLE = 3'b 000; 
parameter PE_DP_TXFIFO_READ_NONE = 3'b 001; 
parameter PE_DP_TXFIFO_READ_NOW = 3'b 010; 
parameter PE_DP_TXFIFO_READ_NO_EOP = 3'b 011; 
parameter PE_DP_TXFIFO_READ_RDY_NO_EOP = 3'b 100; 
parameter PE_DP_TXFIFO_READ_EOP = 3'b 101; 
parameter PE_DP_TXFIFO_READ_EARLY = 3'b 110; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: PE RX FIFO Command Bus
// ---------------------------------------------------------------------------
parameter PE_DP_RXFIFO_IDLE = 3'b 000; 
parameter PE_DP_RXFIFO_WRITE_NONE = 3'b 001; 
parameter PE_DP_RXFIFO_WRITE_DIRECT = 3'b 010; 
parameter PE_DP_RXFIFO_CRC = 3'b 011; 
parameter PE_DP_RXFIFO_MOVE_LOWBYTE = 3'b 100; 
parameter PE_DP_RXFIFO_MOVE_HIGHBYTE = 3'b 101; 
parameter PE_DP_RXFIFO_MOVE_DATA = 3'b 110; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: PE TX PORT Command Bus
// ---------------------------------------------------------------------------
parameter PE_DP_TXPORT_IDLE = 4'b 0000; 
parameter PE_DP_TXPORT_DATADIRECT8 = 4'b 0001; 
parameter PE_DP_TXPORT_DATADIRECT16 = 4'b 0010; 
parameter PE_DP_TXPORT_DATADIRECT16_LAST = 4'b 0011; 
parameter PE_DP_TXPORT_MOVE_BEGIN = 4'b 0101; 
parameter PE_DP_TXPORT_MOVE_BEGIN_0 = 4'b 0110; 
parameter PE_DP_TXPORT_MOVE_MIDDLE = 4'b 0111; 
parameter PE_DP_TXPORT_MOVE_LAST_BYTE = 4'b 1000; 
parameter PE_DP_TXPORT_MOVE_LAST_WORD = 4'b 1001; 
parameter PE_DP_TXPORT_MOVE_END_EVEN = 4'b 1010; 
parameter PE_DP_TXPORT_MOVE_END_ODD = 4'b 1011; 
parameter PE_DP_TXPORT_MOVE_FORCE_EOP_ERR_BIT_STUFF = 4'b 1100; 
parameter PE_DP_TXPORT_MOVE_FORCE_EOP_ERR_CRC1 = 4'b 1101; 
parameter PE_DP_TXPORT_MOVE_FORCE_EOP_ERR_CRC2 = 4'b 1111; 
parameter PE_DP_TXPORT_HOLD = 4'b 1110; 
parameter PE_DP_TXPORT_TESTPKT = 4'b 0100; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Test Mode Definitions (7.1.20)
// ---------------------------------------------------------------------------
parameter TEST_MODE_DISABLED = 4'b 0000; 
parameter TEST_MODE_J_STATE = 4'b 0001; 
parameter TEST_MODE_K_STATE = 4'b 0010; 
parameter TEST_MODE_SE0_NAK = 4'b 0011; 
parameter TEST_MODE_PACKET = 4'b 0100; 
parameter TEST_MODE_FORCE_HS = 4'b 0101; 
parameter TEST_MODE_FORCE_FS = 4'b 0110; 
parameter TEST_MODE_FORCE_LS = 4'b 0111; 
parameter TEST_MODE_CARKIT = 4'b 1100; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Port State Definitions
// ---------------------------------------------------------------------------
parameter PORT_DISABLED = 4'b 0000; 
parameter PORT_DISCONNECTED = 4'b 0001; 
parameter PORT_RESET = 4'b 0011; 
parameter PORT_DRIVE_CHIRP_J = 4'b 0010; 
parameter PORT_DRIVE_CHIRP_K = 4'b 0110; 
parameter PORT_RESET_WAIT = 4'b 0111; 
parameter PORT_NORMAL_OP = 4'b 0101; 
parameter PORT_SUSPEND = 4'b 0100; 
parameter PORT_RESUME_DETECT = 4'b 1100; 
parameter PORT_RESUME_DRIVE = 4'b 1101; 
parameter PORT_RESUME_WAIT = 4'b 1001; 
parameter PORT_TEST_MODE = 4'b 1000; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Phy Selection Definitions
// ---------------------------------------------------------------------------
parameter PHY_SEL_UTMI = 2'b 00; 
parameter PHY_SEL_RESERVED = 2'b 01; 
parameter PHY_SEL_ULPI = 2'b 10; 
parameter PHY_SEL_SERIAL = 2'b 11; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Initiator Bus Type Info.
// ---------------------------------------------------------------------------
parameter BUS_TYPE_INFO_WIDTH = 4; 
parameter BUS_TYPE_INFO_UNDEF = 4'b 0000; //  N/A
parameter BUS_TYPE_INFO_DATA = 4'b 0001; //  RX/TX streaming data
parameter BUS_TYPE_INFO_DATA_PRE = 4'b 0010; //  TX data pre-buffer
parameter BUS_TYPE_INFO_DATA_POST = 4'b 0011; //  TX data post-buffer (double buffering)
parameter BUS_TYPE_INFO_DATA_TT = 4'b 0101; //  RX/TX TT streaming data
parameter BUS_TYPE_INFO_DATA_TT_PRE = 4'b 0110; //  TX TT data pre-buffer
parameter BUS_TYPE_INFO_DTD = 4'b 0111; //  device TD
parameter BUS_TYPE_INFO_DQH = 4'b 1000; //  device QH
parameter BUS_TYPE_INFO_QTD = 4'b 1010; //  host qTD
parameter BUS_TYPE_INFO_QH = 4'b 1011; //  host QH
parameter BUS_TYPE_INFO_ITD = 4'b 1100; //  host iTD
parameter BUS_TYPE_INFO_SITD = 4'b 1101; //  host siTD
parameter BUS_TYPE_INFO_FSTN = 4'b 1110; //  host FSTN
parameter BUS_TYPE_INFO_LP = 4'b 1111; //  host link pointer
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Interpacket delay constants (min) !!! DO NOT CHANGE !!!
//    Note: used in each characterization block ; may add/subtract
//          offset within each char. block to account for PHY issues
// ---------------------------------------------------------------------------
//  TX2TX:HS = 88 < TT < 192 : HS bit times = 6<.<12 clks @ 30MHz
//  TX2TX:HS after SOF ; add 8 clocks for downstream hub & long eop.
//  TX2TX:FS = 2.5 bit times delay = 2.5 clks @ 30MHz = 6   clks
//  TX2TX:LS = 2.5 bit times delay = 20 clks @ 30MHz  = 50  clks
//  RX2TX:FS = 2.5 bit times delay = 2.5 clks @ 30MHz = 6   clks
//  RX2TX:LS = 2.5 bit times delay = 20 clks @ 30MHz  = 50 clks
//  note1: don't start counting until tx_done is asserted
//         ** tx_done is asserted when SE0 (EOP) is observed going away.
//  note2: on rx2tx it is possible to recevie the final byte while a lengthy part of the EOP remains
parameter IP_DELAY_PRELOAD_HS_30MHZ = 6; 
parameter IP_DELAY_PRELOAD_HS_60MHZ = 12; 
parameter IP_DELAY_PRELOAD_SOF_HS_30MHZ = 10; 
parameter IP_DELAY_PRELOAD_SOF_HS_60MHZ = 20; 
parameter IP_DELAY_PRELOAD_FS_30MHZ = 6; 
parameter IP_DELAY_PRELOAD_FS_60MHZ = 12; 
parameter IP_DELAY_PRELOAD_LS_30MHZ = 50; 
parameter IP_DELAY_PRELOAD_LS_60MHZ = 100; 
parameter IP_DELAY_COUNTER_WIDTH = 7; 
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: BTO Time Constants !!! DO NOT CHANGE !!!
//    Note: used in each characterization block ; may add/subtract
//          offset within each char. block to account for PHY issues
// --------------------------------------------------------------------------
//  HS
//    TxEndDelay (phy)    :  40 HS bit times
//    bus turnaround time : 192 HS bit times
//    RxStartDelay (phy)  :  64 HS bit times
//  2.7 us (0.68 us + 3 * 0.68 [margin])
parameter BTO_TIME_HS_60MHZ = 27 * 6; 
parameter BTO_TIME_HS_30MHZ = 27 * 3; 
//  ~6.0us (3.0us + 3.0 [margin])
parameter BTO_TIME_HS_HOST_60MHZ = 6 * 
      60; 
parameter BTO_TIME_HS_HOST_30MHZ = 6 * 30; 
//  FS
//    bus time-out (max)       : 18  FS bit times
//    bus time-out (margin)    : 6   FS bit times
//    RxStartDelay (phy)       : 8   FS bit times (sync. to rx_active will stop BTO counter)
//    assorted pipeline delays : 8   FS bit times (w/ margin)
//  ~3.33us
parameter BTO_TIME_FS_60MHZ = 34 * 6; 
parameter BTO_TIME_FS_30MHZ = 34 * 3; 
//  LS
//    bus time-out (max)       : 18  LS bit times
//    bus time-out (margin)    : 6   LS bit times
//    RxStartDelay (phy)       : 8   LS bit times (sync. to rx_active will stop BTO counter)
//    assorted pipeline delays : 2   LS bit times (w/ margin)
//  ~22.7 us
parameter BTO_TIME_LS_60MHZ = 23 * 
      60; 
parameter BTO_TIME_LS_30MHZ = 23 * 30; 
parameter BTO_COUNTER_WIDTH = 11; //  11 bits
// ---------------------------------------------------------------------------
//  vusb_hs_pkg: Special Testing Modifiers !!! DO NOT CHANGE !!!
// --------------------------------------------------------------------------
// 
//  This constant programs a read only bit in the identification registers
//  to indicate if the test bench software is to test the device at limited
//  bandwidth.  Bandwidth starved design occurs when the system bus wait
//  states/arbitration and/or the system clock don't permit the required bandwidth
//  to the VUSB_HS core.  This can occur in FPGA prototypes where the system
//  environment (clock rate, bus wait states, arbitration, etc) are not significant.
// 
//  Note: Fielding a system that must operate in a bandwidth starved mode
//        requires special consideration when configuring packet sizes in the
//        device controller driver.  Contact support for details if this mode
//        of operation is required.
//  
//    0 = normal bandwidth testing
//    1 = bandwidth starved testing [not recommended]
parameter VUSB_HS_BANDWIDTH_TESTING = 0; //  [0,1]
//  Disables the check in the responder that won't allow the simulation to run
//  with clock config 1 or 3 in conjunction with 16-bit phy interface
parameter RESP_DISABLE_CCFG1_DATA16_CHECK = 1'b 0; 
//  Virtual Frame Enable Constant Set to zero to eliminate Vframe Logic
parameter VFRAME_ENABLE = 1'b 0; 
