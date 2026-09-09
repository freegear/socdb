--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: up_int.vhd Micro Processor Interface
--
-- Revision: $Name: REV9911b $
--
-- Description:
--  Synthesizable VHDL description implementing the USB Serial Interface Engine
--  (SEI) Micro Porcessor Interface.
--
-- NOTE: Should make design so that it can use sync processor interface and
--  async processor interface. For sync interface the vusb will generate
--  the clock for the processor. The other mode is the async interface
--  that will can provide the logic to do this external to the core.
--  add this to the design.
--
--  The control data bus interface defines a comine interface to the SIE.
--  This allows designers to modify the micro processor interface and still
--  maintain a common known interface to the SIE.
--
-- Control Data Bus Definitions:
--
--  cdb_in(40)     : out_data01_pid - This bit is represents the DATA PID
--                   received during a SETUP or Rx Data Packet. If 0 we are
--                   receiving a DATA0 PID, if 1 we are receving a DATA1
--                   PID. This value is written back to memory in the BDT
--                   control byte (bit 6).
--  cdb_in(39:36)  : bdt_wrt_pid - These 4 bits represent the current
--                   token pid value. It is valid when a TOK_DNE is
--                   active.
--  cdb_in(35:25)  : frame_num - These 11 bits represent the last frame
--                   number that was received via a SOF packet. It is
--                   valid after SOF_TOK has gone active.
--  cdb_in(24:21)  : current_endpt - These four bits represent the current
--                   endpoint that the USB is using. This value will be
--                   stored by the up_int in the stat_rg when tok_dne_set=1.
--  cdb_in(20)     : tx_datpkt_proc - This bit indicates that the usb_sie is
--                   processing a tx data packet.
--  cdb_in(19)     : out_token_proc - This bit indicates that the usb_sie is
--                   processing a rx data packet.
--  cdb_in(18:17)  : sie_dma_req - These two bits define the type of DMA
--                   request that the SIE is requesting. The bits are
--                   defined as:
--
--                    17 16 | Type of DMA request
--                   -------+--------------------------------------
--                     0  1 | BDT read DMA request (i.e. 4 bytes)
--                     1  0 | BDT write DMA request (i.e. 4 bytes)
--
--                   NOTE: The SIE will only activate one of the request
--                   bits at a time.
--
--  cdb_in(16)     : dma_early_req - This signal is used to have the DMA
--                   request the bus early. No bus cycles are performed
--                   with this request signal on the bus is requested.
--                   This is useful in design when the bus_gnt latency
--                   could exceed xxx ns, (zzz sie clks).
--  cdb_in(15)     : bts_err_set - This signal when active will set the
--                   BTS_ERR interrupt in the error status register
--                   (err_stat_rg).
--  cdb_in(14)     : own_err_set - This signal when active will set the
--                   OWN_ERR interrupt in the error status register
--                   (err_stat_rg).
--  cdb_in(13)     : dma_err_set - This signal when active will set the
--                   DMA_ERR interrupt in the error status register
--                   (err_stat_rg).
--  cdb_in(12)     : bto_err_set - This signal when active will set the
--                   BTO_ERR interrupt in the error status register
--                   (err_stat_rg).
--  cdb_in(11)     : dfn8_err_set - This signal when active will set the
--                   DF8N_ERR interrupt in the error status register
--                   (err_stat_rg).
--  cdb_in(10)     : crc16_err_set - This signal when active will set the
--                   CRC16_ERR interrupt in the error status register
--                   (err_stat_rg).
--  cdb_in(9)      : crc5_err_set - This signal when active will set the
--                   CRC5_ERR interrupt in the error status register
--                   (err_stat_rg).
--  cdb_in(8)      : pid_err_set - This signal when active will set the
--                   PID_ERR interrupt in the error status register
--                   (err_stat_rg).
--  cdb_in(7:6)    : RSVD
--  cdb_in(5)      : resume_set - This signal when active will set the
--                   RESUME interrupt in the interrupt status register
--                   (istat_rg).
--  cdb_in(4)      : sleep_set - This signal when active will set the
--                   SLEEP interrupt in the interrupt status register
--                   (istat_rg).
--  cdb_in(3)      : tok_dne_set - This signal when active will set the
--                   TOK_DNE interrupt in the interrupt status register
--                   (istat_rg).
--  cdb_in(2)      : sof_tok_set - This signal when active will set the
--                   SOF_TOK interrupt in the interrupt status register
--                   (istat_rg).
--  cdb_in(1)      : error_set - This signal when active will set the
--                   ERROR interrupt in the interrupt status register
--                   (istat_rg).
--  cdb_in(0)      : usb_rst_set - This signal when active will set the
--                   USB_RST interrupt in the interrupt status register
--                   (istat_rg).
--
--  cdb_out(23:17) : addr(6:0) - This is the USB address that the usb_sie
--                   will compare with token packets.
--  cdb_out(16)    : byte_count_eq - This bit informs the usb_sie that
--                   the DMA engine has reached a terminal byte count.
--                   Data transmission should terminate when all remaining
--                   data has been read from the Tx FIFO.
--  cdb_out(15)    : odd_rst - reset the PING/PONG odd bits.
--  cdb_out(14:13) : RSVD
--  cdb_out(12:8)  : ep_ctl - Endpoint control bits.
--
--                12           11         10         9         8
--          +------------+-----------+----------+----------+---------+
--          | ep_ctl_dis | ep_out_en | ep_in_en | ep_stall | ep_hshk |
--          +------------+-----------+----------+----------+---------+
--
--  cdb_out(7:2)   : bdt(7:2) - These signals are the first byte of
--                   the BDT. They contain the following control bits:
--
--                      7       6          5       4      3     2
--                   +-----+---------+----------+------+-----+------+
--                   | own | data0/1 | vusb_own | ninc | dts | rsvd |
--                   +-----+---------+----------+------+-----+------+
--
--  cdb_out(1)     : bdt_valid - When this bit is active high it indicates
--                   that the BDT control bits are valid.
--  cdb_out(0)     : usb_en - This is the USB enable signal from the control
--                   register.
--
-- Block Diagram:
--
-- Processor
-- Interface
--  Signals +----------+
--          |up_int.vhd|
--  ------->+          |
--          |          |
--  <-------+          | cdb_in
--          |          +--------->
--  ------->+          |
--          |          | cdb_out
--  <-------+          +<---------
--          |          |
--  <-------+          |
--          |          |
--  ------->+          |
--          |          |
--          +----------+
--
-- Synchronous Processor Interface Write Timing:
--
--        Write data load ---+
--                           |
--                           v
--        ____      ____      ____      ____
--   clk /    \____/    \____/    \____/    \___
--
--       ___________ _________ _________________
-- addri ___________X_________X_________________
--                   _________
--   cei ___________/         \_________________
--                   _________
--   wei ___________/         \_________________
--
--   rei _______________________________________
--       ___________ _________ _________________
-- datai ___________X_________X_________________
--
--         Minimal Processor Interface Write Timing
--
-- This diagram depects the fastest that the micro processor could
-- perform writes to the VUSB generic uP interface.
--
--
-- Synchronous Processor Interface Read Timing:
--
--        Read data valid ---+
--                           |
--                           v
--        ____      ____      ____      ____
--   clk /    \____/    \____/    \____/    \___
--
--       ___________ _________ _________________
-- addri ___________X_________X_________________
--                   _________
--   cei ___________/         \_________________
--
--   wei _______________________________________
--                   _________
--   rei ___________/         \_________________
--                          ____________________
-- datao XXXXXXXXXXXXXXXXXXX____________________
--
--         Minimal Processor Interface Read Timing
--
-- This diagram depects the fastest that the micro processor could
-- perform read to the VUSB generic uP interface.
--
-- DMA Interface Write Timing:
--
--          __    __    __    __    __    __    __    __    __    __    __    _
--     clk /  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/
--                 _________________________________________
-- bus_req _______/                                         \__________________
--                      _________________________________________
-- bus_gnt ____________/                                         \_____________
--                                   _____ _____ _____ _____
--   addro XXXXXXXXXXXXXXXXXXXXXXXXXX_____X_____X_____X_____XXXXXXXXXXXXXXXXXXX
--                                    _______________________
--     ceo __________________________/                       \_________________
--                                    _______________________
--     weo __________________________/                       \_________________
--
--     reo ____________________________________________________________________
--                                   _____ _____ _____ _____
--   datao XXXXXXXXXXXXXXXXXXXXXXXXXX_____X_____X_____X_____XXXXXXXXXXXXXXXXXXX
--
--         Ready in valid ---------------+-----+-----+-----+
--                                       |     |     |     |
--                                       v     v     v     v
--                                      ____________________
--    rdyi XXXXXXXXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXX
--
--                    Minimal Processor DMA Write Timing
--
-- This diagram depects the fastest that the DMA controller could perform
-- writes to memory. This diagram shows the DMA controller writing four bytes
-- to memory. DMA data sizes of 1 or 4 byte(s) are possible.
--
-- DMA Interface Read Timing:
--
--          __    __    __    __    __    __    __    __    __    __    __    _
--     clk /  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/
--                 _________________________________________
-- bus_req _______/                                         \__________________
--                      _________________________________________
-- bus_gnt ____________/                                         \_____________
--                                   _____ _____ _____ _____
--   addro XXXXXXXXXXXXXXXXXXXXXXXXXX_____X_____X_____X_____XXXXXXXXXXXXXXXXXXX
--                                    _______________________
--     ceo __________________________/                       \_________________
--
--     weo ____________________________________________________________________
--                                    _______________________
--     reo __________________________/                       \_________________
--
--         Data in valid ----------------+-----+-----+-----+
--                                       |     |     |     |
--                                       v     v     v     v
--                                   _____ _____ _____ _____
--   datai XXXXXXXXXXXXXXXXXXXXXXXXXX_____X_____X_____X_____XXXXXXXXXXXXXXXXXXX
--
--         Ready in valid ---------------+-----+-----+-----+
--                                       |     |     |     |
--                                       v     v     v     v
--                                      ____________________
--    rdyi XXXXXXXXXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXX
--
--                    Minimal Processor DMA Read Timing
--
-- This diagram depects the fastest that the DMA controller could perform
-- reads from memory. This diagram shows the DMA controller reading four bytes
-- from memory. DMA data sizes of 1 or 4 byte(s) are possible.
--
--------------------------------------------------------------------------------
-- This product is licensed to:
-- ÇÑÈ«¼· of ÅÂÀÎ½Ã½ºÅÛ
-- for use at site(s):
-- tsi
--------------------------------------------------------------------------------
-- Revision History
-- $Log: up_int.vhd,v $
-- Revision 1.55  2000/02/14 18:37:23  chris
-- Changed bdt_wrt_pid so that a copy of the current token pid registered
-- when the DMA BDT write request is asserted will be written back into
-- BDT byte 0.
--
-- Revision 1.54  2000/01/03 16:24:27  chris
-- Changed host_wo_hub from a generic to a bit in Endpt0 control register.
-- Move host mode retry disable bit in Endpt0 control register.
--
-- Revision 1.53  1999/11/10 15:25:21  gregg
-- Removed ^M's
--
-- Revision 1.52  1999/11/09 14:17:18  mark
-- ulogicified source - no functional changes
--
-- Revision 1.51  1999/11/01 22:00:32  scott
-- Added port for bridge to flush the write buffer
--
-- Revision 1.50  1999/10/13 20:41:04  chris
-- Filled the hole in the register address space between 0x0b and 0x0f,
-- so the uProcessor interface will not return X's in simulation.
--
-- Revision 1.49  1999/09/10 20:33:31  chris
-- Added host retry disable control bit to enpt0 register.
-- Changed low speed enable to low speed request.
-- Changed current token to BDT write PID for host mode update of the
-- BDT PID field with the received handshake PID.
--
-- Revision 1.48  1999/06/23 20:25:45  chris
-- Added usb_en output to allow software to control device connect events.
-- Fixed bus request logic for low speed operation.
--
-- Revision 1.47  1998/11/20 15:22:34  chris
-- Changed synopsys comment placement so it would survive translation to verilog.
--
-- Revision 1.46  1998/11/17 21:46:51  chris
-- Fixed vasync comment on elr_rst_rg process.
--
-- Revision 1.45  1998/11/17 16:07:33  chris
-- Added status FIFO full to the owns equation so, the SIE will wait for an available status FIFO location.
--
-- Revision 1.44  1998/11/13 20:53:52  chris
-- Fixed token busy.
--
-- Revision 1.43  1998/11/09 19:05:39  chris
-- Added term to clear dma_rd_en when a rxd_token is being processed.
--
-- Revision 1.42  1998/11/06 17:55:42  gregg
-- Added resume support for device and host controller modes
--
-- Revision 1.41  1998/11/05 14:50:01  chris
-- Allow clearing of all interrupt bit regardless of Host Mode enable.
--
-- Revision 1.40  1998/10/19 15:44:47  chris
-- Added hardware dequeuing and protocol stall support.
--
-- Revision 1.39  1998/08/31 14:17:20  chris
-- Added code to suppress the token done interrupt and BDT write,
-- but flush any remaining data at the end of packet if the KEEP bit is set.
--
-- Revision 1.38  1998/07/23 09:57:02  chris
-- Added acknoledge for token and req and clr.
--
-- Revision 1.37  1998/06/15 22:06:49  chris
--  Added syntax for Async or Sync reset inference.
--
-- Revision 1.36  1998/05/29 17:08:48  chris
-- Syntax error.
--
-- Revision 1.35  1998/05/29 16:09:49  chris
-- Added software cancelation of host tokens.
--
-- Revision 1.34  1998/05/06 17:56:39  chris
-- Fixed err_enb_rg masking function.
-- Fixed clearing of hc_stall bit in int_stat_rg.
--
-- Revision 1.33  1998/04/24 00:58:37  gregg
-- Added Synopsys reset attributes
--
-- Revision 1.32  1998/03/26 21:15:15  chris
-- Fixed Attach interrupt clearing.
--
-- Revision 1.31  1998/03/13 21:22:03  chris
-- Added revision name.
--
-- Revision 1.30  1998/02/24 15:16:19  chris
-- Enabled and debugged host mode operations.
--
-- Revision 1.29  1998/02/18 14:33:54  gregg
-- Fixed wait-state problem in DMA_BYTE state
--
-- Revision 1.28  1998/01/19 22:55:35  chris
-- Changed endpoint register definition and register address map.
--
-- Revision 1.27  1997/11/20 14:29:59  chris
-- Fixed doe generation logic and removed delay from bus grant.
--
-- Revision 1.26  1997/10/31 21:03:47  chris
-- *** empty log message ***
--
-- Revision 1.25  1997/10/16 12:45:05  chris
-- Removed <Control-M> characters from line ends.
--
-- Revision 1.24  1997/08/28 17:53:57  gregg
-- Added dmadatai for synchronous data transfers
--
-- Revision 1.23  1997/08/25 20:11:38  gregg
-- Added additional error checking and fixed fifo problem with
-- 1 aditional byte remaining in receive fifo
--
-- Revision 1.22  1997/05/13 21:45:22  gregg
-- Enabled additional endpoint registers
--
-- Revision 1.21  1997/05/12 19:57:03  gregg
-- Fix we_n problem when only writting first two bytes of BDT
--
-- Revision 1.20  1997/05/12 03:11:13  gregg
-- Added new endpoint control register formats
--
-- Revision 1.19  1997/05/08 00:02:30  gregg
-- Re-ordered Control/Data bus bit definitions
--
-- Revision 1.18  1997/05/05 16:47:52  chris
-- Moved read back register from sie.vhd
--
-- Revision 1.17  1997/04/24 22:46:42  chris
-- Created registered term for dma_pstate_eq_dma_byte.
--
-- Revision 1.16  1997/03/17 20:35:17  eric
-- reset the ODD bits when software says to.
--
-- Revision 1.15  1997/03/12 19:48:05  gregg
-- Fixed bus control signals to output enable timing problem
--
-- Revision 1.14  1997/03/08 03:23:16  gregg
-- Added dma_early_req to reduce bus request latency
--
-- Revision 1.13  1997/03/07 20:09:57  gregg
-- Added error_set
--
-- Revision 1.12  1997/03/07 04:07:02  gregg
-- Added cdb signals for error status interrupts
--
-- Revision 1.11  1997/03/05 17:20:33  gregg
-- Fixed DMA engine to correctly support stalled endpoints
-- Added NINC support to address increment
--
-- Revision 1.10  1997/03/05 03:27:59  gregg
-- Removed usb package file
--
-- Revision 1.9  1997/03/05 02:20:59  gregg
-- Do not change DATA01 on Tx Data Packets
--
-- Revision 1.8  1997/03/05 01:46:04  gregg
-- Added status fifo
--
-- Revision 1.7  1997/03/04 18:15:42  gregg
-- Fixed BDT DATA01 writeback problem on SETUP and RX DATA PACKETS
--
-- Revision 1.6  1997/03/04 14:17:07  gregg
-- Added CRC16 and fixed bitstuff on Tx Data Packets
--
-- Revision 1.5  1997/03/03 18:56:23  gregg
-- Added Tx Data Packet
--
-- Revision 1.4  1997/03/03 12:52:23  gregg
-- Added Tx FIFO and improved DMA support
--
-- Revision 1.3  1997/02/27 02:08:28  gregg
-- Added Rx FIFO interface and DMA support
--
-- Revision 1.2  1997/02/21 14:42:28  gregg
-- OUT and SETUP coded.
--
-- Revision 1.1  1997/02/06 12:34:02  chris
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- use ieee.std_logic_arith.all;
use work.cfg_usb.all; -- VUSB synthesis and simulation configuration constants.

entity up_int is
  port (-- Generic uProcessor Interface signals
        addri      : in  std_ulogic_vector( 4 downto 0); -- Address Bus
        addro      : out std_ulogic_vector(15 downto 0); -- Address Bus
        dmadatai   : in  std_ulogic_vector(7 downto 0); -- DMA Data Bus In
        datai      : in  std_ulogic_vector(7 downto 0); -- Data Bus In
        datao      : out std_ulogic_vector(7 downto 0); -- Data Bus Out
        doe        : out std_ulogic;  -- Data Bus Output Enable
        cei        : in  std_ulogic;  -- Chip Enable Input
        ceo        : out std_ulogic;  -- Chip Enable Output
        wei        : in  std_ulogic;  -- Write Enable Input
        weo        : out std_ulogic;  -- Write Enable Output
        rei        : in  std_ulogic;  -- Read Enable Input
        reo        : out std_ulogic;  -- Read Enable Output
        rdyi       : in  std_ulogic;  -- Ready Input
        rdyo       : out std_ulogic;  -- Ready Output
        bus_req    : out std_ulogic;  -- Bus Request
        bus_gnt    : in  std_ulogic;  -- Bus Grant
        bmoe       : out std_ulogic;  -- Bus Master Signals Output Enable
        bsoe       : out std_ulogic;  -- Bus Slave Signals Output Enable
        int        : out std_ulogic;  -- Interrupt
        reset      : in  std_ulogic;  -- Reset
        clk        : in  std_ulogic;  -- Clock
        dma_wrt_bdt_o : out std_ulogic;  -- DMA Write BDT Output
        dma_rd_bdt_o  : out std_ulogic;  -- DMA read BDT (4 bytes)
        dma_wrt_bdt_b0 : out std_ulogic;  -- _really_ writing BDT byte 0 now
        -- Control/Data bus interface
        cdb_in     : in  std_ulogic_vector(45 downto 0); -- Control/Data bus in
        cdb_out    : out std_ulogic_vector(43 downto 0); -- Control/Data bus out
        rcv        : in  std_ulogic; -- USB data input
        se0        : in  std_ulogic; -- USB single ended zero
        host_mode_en : out std_ulogic; -- embedded host controller enable
        low_speed_req : out std_ulogic; -- set USB communication to low speed
        host_wo_hub  : out std_ulogic;   -- set USB communication to low speed
        usb_en     : out std_ulogic;   -- USB pull up enable
        -- FIFO interfaces
        rx_empty   : in  std_ulogic;  -- Rx FIFO empty
        rx_valid_1 : in  std_ulogic;  -- Rx FIFO byte from the bottom
        rx_rdata   : in  std_ulogic_vector(7 downto 0);  -- Rx FIFO read data
        rx_re      : out std_ulogic;  -- Rx FIFO read enable
        rx_valid   : in  std_ulogic;  -- Rx FIFO has valid data in it
        tx_full    : in  std_ulogic;  -- Tx FIFO full
        tx_full_1  : in  std_ulogic;  -- Tx FIFO is almost full (1 byte free)
        tx_wdata   : out std_ulogic_vector(7 downto 0);  -- Tx FIFO write data
        tx_we      : out std_ulogic;  -- Tx FIFO write enable
        tx_valid   : in  std_ulogic); -- Tx FIFO has valid data in it
end up_int;

architecture synth of up_int is

component fifo8xn
  PORT(clk  : IN  std_ulogic;    -- everything clocks on rising edge
       reset    : IN  std_ulogic;    -- reset active high
       load : IN  std_ulogic;    -- write a byte
       unload   : IN  std_ulogic;    -- read a byte
       full : OUT std_ulogic;    -- 1=FIFO is full
       full_1   : OUT std_ulogic;    -- 1=FIFO is almost full (1 byte free)
       empty    : OUT std_ulogic;    -- 1=FIFO is empty
       out_valid: OUT std_ulogic;    -- 1=DATA_OUT has valid data in it
       out_val_1: OUT std_ulogic;    -- 1=OUT_VALID 1 byte from the bottom
       data_in  : IN  std_ulogic_vector(7 DOWNTO 0); -- data bus in
       data_out : OUT std_ulogic_vector(7 DOWNTO 0)); -- data bus in
end component;

-- DMA state enumeration types
type dma_states is (DMA_IDLE, DMA_GNT, DMA_BDT0, DMA_BDT1,
                    DMA_BDT2, DMA_BDT3, DMA_BYTE);

-- Define address constants
constant c00h   : std_ulogic_vector(4 downto 0) := "00000";
constant c01h   : std_ulogic_vector(4 downto 0) := "00001";
constant c02h   : std_ulogic_vector(4 downto 0) := "00010";
constant c03h   : std_ulogic_vector(4 downto 0) := "00011";
constant c04h   : std_ulogic_vector(4 downto 0) := "00100";
constant c05h   : std_ulogic_vector(4 downto 0) := "00101";
constant c06h   : std_ulogic_vector(4 downto 0) := "00110";
constant c07h   : std_ulogic_vector(4 downto 0) := "00111";
constant c08h   : std_ulogic_vector(4 downto 0) := "01000";
constant c09h   : std_ulogic_vector(4 downto 0) := "01001";
constant c0ah   : std_ulogic_vector(4 downto 0) := "01010";
constant c0bh   : std_ulogic_vector(4 downto 0) := "01011";
constant c0ch   : std_ulogic_vector(4 downto 0) := "01100";
constant c0dh   : std_ulogic_vector(4 downto 0) := "01101";
constant c0eh   : std_ulogic_vector(4 downto 0) := "01110";
constant c0fh   : std_ulogic_vector(4 downto 0) := "01111";
constant c10h   : std_ulogic_vector(4 downto 0) := "10000";
constant c11h   : std_ulogic_vector(4 downto 0) := "10001";
constant c12h   : std_ulogic_vector(4 downto 0) := "10010";
constant c13h   : std_ulogic_vector(4 downto 0) := "10011";
constant c14h   : std_ulogic_vector(4 downto 0) := "10100";
constant c15h   : std_ulogic_vector(4 downto 0) := "10101";
constant c16h   : std_ulogic_vector(4 downto 0) := "10110";
constant c17h   : std_ulogic_vector(4 downto 0) := "10111";
constant c18h   : std_ulogic_vector(4 downto 0) := "11000";
constant c19h   : std_ulogic_vector(4 downto 0) := "11001";
constant c1ah   : std_ulogic_vector(4 downto 0) := "11010";
constant c1bh   : std_ulogic_vector(4 downto 0) := "11011";
constant c1ch   : std_ulogic_vector(4 downto 0) := "11100";
constant c1dh   : std_ulogic_vector(4 downto 0) := "11101";
constant c1eh   : std_ulogic_vector(4 downto 0) := "11110";
constant c1fh   : std_ulogic_vector(4 downto 0) := "11111";

-- These two constants control the number of endpoints the up_int will
-- implement.
-- constant EN_EP_CTL_4_7  : std_ulogic; -- Enables endpoints 4-7
-- constant EN_EP_CTL_8_15 : std_ulogic; -- Enables endpoints 8-15
-- see cfg_usb for values.

-- Requires the sync_set/reset attribute to insure no Xes in simulation
-- The following line is used when translating to Verilog...
-- synopsys sync_set_reset "reset"

attribute sync_set_reset : string;  -- Required for Synopsys
attribute sync_set_reset of reset : signal is "true";  -- Required for synopsys

signal addro_d  : std_ulogic_vector(15 downto 0); -- Address bus data
signal byte_count_eq : std_ulogic; -- DMA byte count equals saved byte count

--     7        6       5       4        3         2        1        0
-- +-------+--------+--------+-------+---------+---------+-------+---------+
-- | STALL | ATTACH | RESUME | SLEEP | TOK_DNE | SOF_TOK | ERROR | USB_RST |
-- +-------+--------+--------+-------+---------+---------+-------+---------+
--
signal usb_rst     : std_ulogic;  -- USB reset interrupt
signal usb_rst_set : std_ulogic;  -- USB reset interrupt set
signal usb_rst_clr : std_ulogic;  -- USB reset interrupt clear
signal error       : std_ulogic;  -- Error interrupt
signal error_set   : std_ulogic;  -- Error interrupt set
signal error_clr   : std_ulogic;  -- Error interrupt clear
signal sof_tok     : std_ulogic;  -- SOF token interrupt
signal sof_tok_set : std_ulogic;  -- SOF token interrupt set
signal sof_tok_clr : std_ulogic;  -- SOF token interrupt clear
signal tok_dne     : std_ulogic;  -- Token done interrupt
signal tok_dne_set : std_ulogic;  -- Token done interrupt set
signal tok_dne_clr : std_ulogic;  -- Token done interrupt clear
signal sleep       : std_ulogic;  -- Sleep interrupt
signal sleep_set   : std_ulogic;  -- Sleep interrupt set
signal sleep_clr   : std_ulogic;  -- Sleep interrupt clear
signal resume      : std_ulogic;  -- Resume interrupt
signal resume_set  : std_ulogic;  -- Resume interrupt set
signal resume_clr  : std_ulogic;  -- Resume interrupt clear
signal stall_int      : std_ulogic; -- stall register
signal stall_int_clr  : std_ulogic; -- stall interrupt reset
signal stall_int_d    : std_ulogic; -- stall register input
signal stall_int_q    : std_ulogic; -- stall register output
signal stall_int_set  : std_ulogic; -- stall interrupt pulse

--      7         6         5         4       3       2       1       0
-- +---------+---------+---------+---------+------+-------+------+---------+
-- | BTS_ERR | OWN_ERR | DMA_ERR | BTO_ERR | DFN8 | CRC16 | CRC5 | PID_ERR |
-- +---------+---------+---------+---------+------+-------+------+---------+
--
signal pid_err       : std_ulogic; -- PID error interrupt
signal pid_err_set   : std_ulogic; -- PID error interrupt set
signal pid_err_clr   : std_ulogic; -- PID error interrupt clear
signal crc5_err      : std_ulogic; -- CRC5 error interrupt
signal crc5_err_set  : std_ulogic; -- CRC5 error interrupt set
signal crc5_err_clr  : std_ulogic; -- CRC5 error interrupt clear
signal crc16_err     : std_ulogic; -- CRC16 error interrupt
signal crc16_err_set : std_ulogic; -- CRC16 error interrupt set
signal crc16_err_clr : std_ulogic; -- CRC16 error interrupt clear
signal dfn8_err      : std_ulogic; -- Data field not 8-bits error interrupt
signal dfn8_err_set  : std_ulogic; -- Data field not 8-bits error interrupt set
signal dfn8_err_clr  : std_ulogic; -- Data field not 8-bits error interrupt clear
signal bto_err       : std_ulogic; -- Bus timeout error interrupt
signal bto_err_set   : std_ulogic; -- Bus timeout error interrupt set
signal bto_err_clr   : std_ulogic; -- Bus timeout error interrupt clear
signal dma_err       : std_ulogic; -- DMA timeout error interrupt
signal dma_err_set   : std_ulogic; -- DMA timeout error interrupt set
signal dma_err_clr   : std_ulogic; -- DMA timeout error interrupt clear
signal dma_overrun   : std_ulogic; -- DMA exhausted the buffer space
signal own_err       : std_ulogic; -- Own timeout error interrupt
signal own_err_set   : std_ulogic; -- Own timeout error interrupt set
signal own_err_clr   : std_ulogic; -- Own timeout error interrupt clear
signal bts_err       : std_ulogic; -- Bit stuff error interrupt
signal bts_err_set   : std_ulogic; -- Bit stuff error interrupt set
signal bts_err_clr   : std_ulogic; -- Bit stuff error interrupt clear

signal bus_req_d     : std_ulogic; -- Bus request data
signal bmoe_d        : std_ulogic; -- Bus master signals output enable data

-- VUSB Registers
signal int_stat_rg : std_ulogic_vector(7 downto 0); -- Interrupt status register
signal int_enb_rg  : std_ulogic_vector(7 downto 0); -- Interrupt enable register
signal err_stat_rg : std_ulogic_vector(7 downto 0); -- Error status register
signal err_enb_rg  : std_ulogic_vector(7 downto 0); -- Error enable register
signal stat_rg     : std_ulogic_vector(7 downto 0); -- Status register
signal ctl_rg      : std_ulogic_vector(4 downto 0); -- Control register
signal ctl_rg_out  : std_ulogic_vector(7 downto 0); -- Control register read back
signal usb_en_int  : std_ulogic; -- Control register bit 0
signal odd_rst     : std_ulogic; -- Control register bit 1
signal addr_rg     : std_ulogic_vector(7 downto 0); -- Address register
signal bdt_page_rg : std_ulogic_vector(7 downto 0); -- BDT page register
signal frm_numl_rg : std_ulogic_vector(7 downto 0); -- Frame number low register
signal frm_numh_rg : std_ulogic_vector(7 downto 0); -- Frame number high register
signal endpt0_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register0
signal endpt1_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register1
signal endpt2_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register2
signal endpt3_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register3
signal endpt4_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register4
signal endpt5_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register5
signal endpt6_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register6
signal endpt7_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register7
signal endpt8_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register8
signal endpt9_rg   : std_ulogic_vector(4 downto 0); -- Endpoint control register9
signal endpt10_rg  : std_ulogic_vector(4 downto 0); -- Endpoint control register10
signal endpt11_rg  : std_ulogic_vector(4 downto 0); -- Endpoint control register11
signal endpt12_rg  : std_ulogic_vector(4 downto 0); -- Endpoint control register12
signal endpt13_rg  : std_ulogic_vector(4 downto 0); -- Endpoint control register13
signal endpt14_rg  : std_ulogic_vector(4 downto 0); -- Endpoint control register14
signal endpt15_rg  : std_ulogic_vector(4 downto 0); -- Endpoint control register15

signal endpt_ctl   : std_ulogic_vector(4 downto 0); -- Current Endpoint control mux
signal endpt_stall      : std_ulogic;               -- Current endpoint stall bit
signal endpt_stall_clr  : std_ulogic;               -- Endpoint stall clear
signal endpt_stall_set  : std_ulogic;               -- Endpoint stall set

-- Endpoint in odd address
signal endpt_txd_odd     : std_ulogic; -- Endpoint in odd address bit
signal endpt0_txd_odd    : std_ulogic; -- Endpoint0 in odd
signal endpt1_txd_odd    : std_ulogic; -- Endpoint1 in odd
signal endpt2_txd_odd    : std_ulogic; -- Endpoint2 in odd
signal endpt3_txd_odd    : std_ulogic; -- Endpoint3 in odd
signal endpt4_txd_odd    : std_ulogic; -- Endpoint4 in odd
signal endpt5_txd_odd    : std_ulogic; -- Endpoint5 in odd
signal endpt6_txd_odd    : std_ulogic; -- Endpoint6 in odd
signal endpt7_txd_odd    : std_ulogic; -- Endpoint7 in odd
signal endpt8_txd_odd    : std_ulogic; -- Endpoint8 in odd
signal endpt9_txd_odd    : std_ulogic; -- Endpoint9 in odd
signal endpt10_txd_odd   : std_ulogic; -- Endpoint10 in odd
signal endpt11_txd_odd   : std_ulogic; -- Endpoint11 in odd
signal endpt12_txd_odd   : std_ulogic; -- Endpoint12 in odd
signal endpt13_txd_odd   : std_ulogic; -- Endpoint13 in odd
signal endpt14_txd_odd   : std_ulogic; -- Endpoint14 in odd
signal endpt15_txd_odd   : std_ulogic; -- Endpoint15 in odd

-- Endpoint out odd address
signal endpt_rxd_odd     : std_ulogic; -- Endpoint out odd address bit
signal endpt0_rxd_odd    : std_ulogic; -- Endpoint0 out odd
signal endpt1_rxd_odd    : std_ulogic; -- Endpoint1 out odd
signal endpt2_rxd_odd    : std_ulogic; -- Endpoint2 out odd
signal endpt3_rxd_odd    : std_ulogic; -- Endpoint3 out odd
signal endpt4_rxd_odd    : std_ulogic; -- Endpoint4 out odd
signal endpt5_rxd_odd    : std_ulogic; -- Endpoint5 out odd
signal endpt6_rxd_odd    : std_ulogic; -- Endpoint6 out odd
signal endpt7_rxd_odd    : std_ulogic; -- Endpoint7 out odd
signal endpt8_rxd_odd    : std_ulogic; -- Endpoint8 out odd
signal endpt9_rxd_odd    : std_ulogic; -- Endpoint9 out odd
signal endpt10_rxd_odd   : std_ulogic; -- Endpoint10 out odd
signal endpt11_rxd_odd   : std_ulogic; -- Endpoint11 out odd
signal endpt12_rxd_odd   : std_ulogic; -- Endpoint12 out odd
signal endpt13_rxd_odd   : std_ulogic; -- Endpoint13 out odd
signal endpt14_rxd_odd   : std_ulogic; -- Endpoint14 out odd
signal endpt15_rxd_odd   : std_ulogic; -- Endpoint15 out odd

signal ep_ctl0     : std_ulogic_vector(4 downto 0); -- Endpoint control0
signal ep_ctl1     : std_ulogic_vector(4 downto 0); -- Endpoint control1
signal ep_ctl2     : std_ulogic_vector(4 downto 0); -- Endpoint control2
signal ep_ctl3     : std_ulogic_vector(4 downto 0); -- Endpoint control3
signal ep_ctl4     : std_ulogic_vector(4 downto 0); -- Endpoint control4
signal ep_ctl5     : std_ulogic_vector(4 downto 0); -- Endpoint control5
signal ep_ctl6     : std_ulogic_vector(4 downto 0); -- Endpoint control6
signal ep_ctl7     : std_ulogic_vector(4 downto 0); -- Endpoint control7
signal ep_ctl8     : std_ulogic_vector(4 downto 0); -- Endpoint control8
signal ep_ctl9     : std_ulogic_vector(4 downto 0); -- Endpoint control9
signal ep_ctl10    : std_ulogic_vector(4 downto 0); -- Endpoint control10
signal ep_ctl11    : std_ulogic_vector(4 downto 0); -- Endpoint control11
signal ep_ctl12    : std_ulogic_vector(4 downto 0); -- Endpoint control12
signal ep_ctl13    : std_ulogic_vector(4 downto 0); -- Endpoint control13
signal ep_ctl14    : std_ulogic_vector(4 downto 0); -- Endpoint control14
signal ep_ctl15    : std_ulogic_vector(4 downto 0); -- Endpoint control15

signal wrt_data    : std_ulogic_vector(7 downto 0); -- Write data
signal txd_token   : std_ulogic;  -- Current token is in
signal odd_bdt    : std_ulogic;  -- Current BDT is odd
signal current_endpt : std_ulogic_vector(3 downto 0);  -- Current endpoint

-- VUSB register load enables
signal int_stat_ld : std_ulogic; -- Interrupt status register load enable
signal int_enb_ld  : std_ulogic; -- Interrupt enable register load enable
signal err_stat_ld : std_ulogic; -- Error status register load enable
signal err_enb_ld  : std_ulogic; -- Error enable register load enable
--signal stat_ld     : std_ulogic; -- Status register load enable
signal ctl_ld      : std_ulogic; -- Control register load enable
signal addr_ld     : std_ulogic; -- Address register load enable
signal bdt_page_ld : std_ulogic; -- BDT page register load enable
signal tokens_ld   : std_ulogic; -- Host mode token register load enable
signal sof_thldl_ld: std_ulogic; -- SOF Threshold Register low load enable
signal sof_thldh_ld: std_ulogic; -- SOF Threshold Register high load enable
signal endpt0_ld   : std_ulogic; -- Endpoint control register0 load enable
signal endpt1_ld   : std_ulogic; -- Endpoint control register1 load enable
signal endpt2_ld   : std_ulogic; -- Endpoint control register2 load enable
signal endpt3_ld   : std_ulogic; -- Endpoint control register3 load enable
signal endpt4_ld   : std_ulogic; -- Endpoint control register4 load enable
signal endpt5_ld   : std_ulogic; -- Endpoint control register5 load enable
signal endpt6_ld   : std_ulogic; -- Endpoint control register6 load enable
signal endpt7_ld   : std_ulogic; -- Endpoint control register7 load enable
signal endpt8_ld   : std_ulogic; -- Endpoint control register8 load enable
signal endpt9_ld   : std_ulogic; -- Endpoint control register9 load enable
signal endpt10_ld  : std_ulogic; -- Endpoint control register10 load enable
signal endpt11_ld  : std_ulogic; -- Endpoint control register11 load enable
signal endpt12_ld  : std_ulogic; -- Endpoint control register12 load enable
signal endpt13_ld  : std_ulogic; -- Endpoint control register13 load enable
signal endpt14_ld  : std_ulogic; -- Endpoint control register14 load enable
signal endpt15_ld  : std_ulogic; -- Endpoint control register15 load enable

signal irdyo      : std_ulogic;  -- Internal ready out

signal rx_data    : std_ulogic_vector(7 downto 0);  -- Receive data
signal rx_tag     : std_ulogic; -- Receive data tag
signal dma_datao  : std_ulogic_vector(7 downto 0);  -- Select DMA data out
signal rd_datao   : std_ulogic_vector(7 downto 0);  -- Select read data out
signal rd_datao_rg: std_ulogic_vector(7 downto 0);  -- Select read data register
signal rd_data    : std_ulogic_vector(7 downto 0);  -- Read data
signal rd_data_rg : std_ulogic_vector(7 downto 0);  -- Read data register
signal tx_data    : std_ulogic_vector(7 downto 0);  -- Transmit data
signal tx_tag     : std_ulogic; -- Transmit data tag
       -- target mode transmit suspend / host mode token busy dual use signal
signal txdsuspend_tokbusy     : std_ulogic; -- register
signal txdsuspend_tokbusy_clr : std_ulogic; -- clear from usb_sie
signal txdsuspend_tokbusy_set : std_ulogic; -- set from usb_sie
-- Define signals used for embedded host control.
signal hc_en         : std_ulogic; -- embedded host controller functions are
                                  -- implemented and turned on
signal hc_en_byte    : std_ulogic_vector(7 downto 0); -- a vector of hc_en bits
signal host_mode_int : std_ulogic; -- embedded host controller enable
signal hc_attach     : std_ulogic; -- attach / detach register
signal hc_attach_clr : std_ulogic; -- attach / detach interrupt reset
signal hc_attach_d   : std_ulogic; -- attach / detach register input
signal hc_attach_q   : std_ulogic; -- attach / detach register output
signal hc_attach_set : std_ulogic; -- attach / detach interrupt pulse
signal hc_rst_req    : std_ulogic; -- host USB reset request
signal host_wo_hub_int : std_ulogic;-- host without hub control
signal host_wo_hub_q   : std_ulogic;-- host without hub control
signal hc_retry_disable   : std_ulogic;-- host retry disabled to SIE
signal hc_retry_disable_q : std_ulogic;-- host retry disabled to SIE
signal hc_sof_thld_ld : std_ulogic; -- SOF Threshold Register load enable
signal hc_sof_thld_q  : std_ulogic_vector(7 downto 0); -- SOF Threshold Register
signal hc_sof_thld_rg : std_ulogic_vector(7 downto 0); -- gated output
signal hc_token_ack  : std_ulogic; -- USB token transaction req/clr acknowledge
signal hc_token_busy : std_ulogic; -- USB token transaction in progress
signal hc_token_clr_q: std_ulogic;
signal hc_token_clr  : std_ulogic;
signal hc_token_endpt: std_ulogic_vector(3 downto 0);
signal hc_token_ld   : std_ulogic; -- token register load enable
signal hc_token_pid  : std_ulogic_vector(3 downto 0);
signal hc_token_req_q: std_ulogic; -- USB token transaction request
signal hc_token_req  : std_ulogic; -- USB token transaction request
signal hc_token_q    : std_ulogic_vector(7 downto 0); -- Host mode token register
signal hc_token_rg   : std_ulogic_vector(7 downto 0); -- gated output

-- Define buffer description table registers
signal bdt_rg0    : std_ulogic_vector(7 downto 0);  -- BDT register0
signal bdt_rg1    : std_ulogic_vector(7 downto 0);  -- BDT register1
signal bdt_rg2    : std_ulogic_vector(7 downto 0);  -- BDT register2
signal bdt_rg3    : std_ulogic_vector(7 downto 0);  -- BDT register3
signal bdt_ld0    : std_ulogic;  -- BDT register0 load enable
signal bdt_ld1    : std_ulogic;  -- BDT register1 load enable
signal bdt_ld2    : std_ulogic;  -- BDT register2 load enable
signal bdt_ld3    : std_ulogic;  -- BDT register3 load enable
signal bdt_valid  : std_ulogic;  -- BDT registers contain a valid BDT
signal out_data01_pid : std_ulogic; -- Out data01 pid register

--signal token_pid_d : std_ulogic_vector(3 downto 0); -- Token pid data
--signal token_pid   : std_ulogic_vector(3 downto 0); -- Token pid
signal bdt_wrt_pid : std_ulogic_vector(3 downto 0); -- Current token
signal bdt_wrt_pid_d : std_ulogic_vector(3 downto 0); -- Register input
signal bdt_wrt_pid_f : std_ulogic_vector(3 downto 0); -- Registered Current token

-- Alias signal for BDT
signal dma_addr   : std_ulogic_vector(15 downto 0);  -- DMA address
signal byte_cnt   : std_ulogic_vector(9 downto 0);   -- DMA byte count
signal byte_cnt_save : std_ulogic_vector(9 downto 0); -- DMA byte count save
signal bdt_ctl    : std_ulogic_vector(5 downto 0);   -- BDT control bits
signal own        : std_ulogic;  -- BDT own bit (0=up, 1=SIE)
--signal stall      : std_ulogic;  -- BDT stall control bit
signal keep       : std_ulogic;  -- BDT keep control bit (0=normal, 1=keep bdt)
signal ninc       : std_ulogic;  -- BDT ninc control bit (0=inc, 1=no inc)

signal stat_valid_1 : std_ulogic; -- Status FIFO byte from the bottom
signal stat_empty   : std_ulogic; -- Status FIFO empty
signal stat_full    : std_ulogic; -- Status FIFO full
--signal stat_full_1  : std_ulogic; -- Status FIFO is almost full (1 byte free)
signal stat_rdata   : std_ulogic_vector(7 downto 0); -- Status FIFO read data
signal stat_re      : std_ulogic; -- Status FIFO read enable
signal stat_reset   : std_ulogic; -- Status FIFO reset
signal stat_valid   : std_ulogic; -- Status FIFO has valid data in it
signal stat_wdata   : std_ulogic_vector(7 downto 0); -- Status FIFO write data
signal stat_we      : std_ulogic; -- Status FIFO write enable

signal tx_datpkt_proc  : std_ulogic; -- Tx Data Packet process
signal out_token_proc : std_ulogic; -- Rx Data Packet process
signal resume_req     : std_ulogic; -- Assert resume signaling request

--------------------------------------------------------------------------------
-- Define DMA engine signals
--------------------------------------------------------------------------------
-- Define state enumeration type
signal dma_nstate : dma_states; -- DMA state machine next state bits
signal dma_pstate : dma_states; -- DMA state machine present state bits
signal dma_pstate_eq_dma_byte : std_ulogic; -- DMA state machine is in DMA_BYTE
                                           -- state
signal dma_early_req  : std_ulogic; -- DMA early req
signal dma_req        : std_ulogic; -- DMA request
signal dma_req_clr    : std_ulogic; -- DMA request clear enable
signal dma_rd_bdt_d   : std_ulogic; -- DMA read BDT (4 bytes) data
signal dma_rd_bdt     : std_ulogic; -- DMA read BDT (4 bytes)
signal dma_rd_byte_d  : std_ulogic; -- DMA read byte data
signal dma_rd_byte    : std_ulogic; -- DMA read byte
signal dma_rd_en      : std_ulogic; -- DMA read byte data enable
signal dma_rd_en_d    : std_ulogic; -- DMA read byte data enable data
signal dma_valid_flush: std_ulogic; -- flush any valid data remaining in the Rx FIFO
signal dma_wrt_bdt_d  : std_ulogic; -- DMA write BDT (4 bytes) data
signal dma_wrt_bdt    : std_ulogic; -- DMA write BDT (4 bytes)
signal dma_wrt_byte_d : std_ulogic; -- DMA write byte data
signal dma_wrt_byte   : std_ulogic; -- DMA write byte
signal dma_wrt_en     : std_ulogic; -- DMA write byte data enable
signal dma_wrt_en_d   : std_ulogic; -- DMA write byte data enable data

signal sie_dma_req    : std_ulogic_vector(3 downto 0); -- SIE DMA requests

signal dma_active     : std_ulogic; -- DMA actively in progress
signal dma_active_d   : std_ulogic; -- DMA actively in progress data
signal load_en        : std_ulogic; -- Load enable, holds control signals if wait states
signal weo_lcl        : std_ulogic; -- Local copy of the write enable output
signal reo_lcl        : std_ulogic; -- Local copy of the read enable output
signal rx_re_elr      : std_ulogic; -- Local Rx FIFO read enable
signal tx_we_lcl      : std_ulogic; -- Local Tx FIFO write enable

signal byte_cnt_dec   : std_ulogic; -- Enable byte count decrement
signal byte_cnt_inc_en : std_ulogic; -- Enable byte count increment enable
signal byte_cnt_inc   : std_ulogic; -- Enable byte count increment
signal dma_addr_inc   : std_ulogic; -- Enable DMA address increment
signal bdt_addr3      : std_ulogic; -- BDT address bit3
signal bdt_addr2      : std_ulogic; -- BDT address bit2
signal bdt_addr1      : std_ulogic; -- BDT address bit1
signal bdt_addr0      : std_ulogic; -- BDT address bit0
signal stop_dma_gjr       : std_ulogic; -- Stop DMA operation

begin

-- host controller enable is used to enable the embedded host perations of the
-- core.   When IMPLEMENT_EMBEDED_HOST is '0' this signal causes the bulk of the
-- logic associated with the embedded host functions to be optimized out.
hc_en <= IMPLEMENT_EMBEDED_HOST and host_mode_int;
hc_en_byte  <= hc_en & hc_en & hc_en & hc_en & hc_en & hc_en & hc_en & hc_en;
host_mode_en <= host_mode_int;
usb_en <= usb_en_int;                   -- usb enable output used to
                                        -- turn on the speed bias resitors.

low_speed_req <= addr_rg(7); -- This signal causes the SIE to invert the and
                             -- DPLL to invert the signaling of the J and K bus
                             -- states for low speed signalling.


-- DMA Write BDT Output
dma_wrt_bdt_o <= dma_wrt_bdt; -- Buffer output

-- DMA Read BDT Output
dma_rd_bdt_o <= dma_rd_bdt; -- Buffer output

-- Assign control/data bus signal here. This allows the control data bus
-- formats to be changed easily and in only one place in the file.
--
-- Format control/data bus in
--
--
--  cdb_in(45)    : txd_token - the current token requires a tx data packet.
txd_token <= cdb_in(45);
--  cdb_in(44)    : stall_set - Set signal for the stalled endpoint interrupt
endpt_stall_clr <= cdb_in(44);
--  cdb_in(43)    : stall_set - Set signal for the stalled endpoint interrupt
endpt_stall_set <= cdb_in(43);
--  cdb_in(42:41) : clear and set signals for the dual use register
--                    txd_suspend   - Transmit data packets are suspended on
--                                    the target until the uProcessor resets
--                                    the suspend ctl.
--                    hc_token_busy - The token statemachine has not completed
--                                    the last host token transaction.

txdsuspend_tokbusy_clr <= cdb_in(42);
txdsuspend_tokbusy_set <= cdb_in(41);
--  cdb_in(40)    : out_data01_pid - This bit is represents the DATA PID
--                   received during a SETUP or Rx Data Packet. If 0 we are
--                   receiving a DATA0 PID, if 1 we are receving a DATA1
--                   PID. This value is written back to memory in the BDT
--                   control byte (bit 6).
-- cdb_in(40)     : out_data01_pid - This bit is represents the DATA PID
--                  received during a SETUP or Rx Data Packet. If 0 we are
--                  receiving a DATA0 PID, if 1 we are receving a DATA1
--                  PID. This value is written back to memory in the BDT
--                  control byte (bit 6).
--
out_data01_pid <= cdb_in(40);

--  cdb_in(39:36)  : bdt_wrt_pid - These 4 bits represent the current
--                   token pid value. It is valid when a TOK_DNE is
--                   active.
--
--token_pid_d <= cdb_in(39 downto 36);
bdt_wrt_pid <= cdb_in(39 downto 36);

--  cdb_in(35:25)  : frame_num - These 11 bits represent the last frame
--                   number that was received via a SOF packet. It is
--                   valid after SOF_TOK has gone active.
--
-- Frame number high register
frm_numh_rg <= "00000" & cdb_in(35 downto 33);
-- Frame number low register
frm_numl_rg <= cdb_in(32 downto 25);

--  cdb_in(24:21)  : endpt - These four bits represent the current endpoint
--                   that the USB is using. This value will be stored by
--                   the up_int in the stat_rg when tok_dne_set=1.
--
current_endpt <= cdb_in(24 downto 21);

--  cdb_in(20)       : tx_datpkt_proc - This bit indicates that the usb_sie is
--                     processing a tx data packet.
--
tx_datpkt_proc <= cdb_in(20);

--  cdb_in(19)       : out_token_proc - This bit indicates that the usb_sie is
--                     processing a rx data packet.
--
out_token_proc <= cdb_in(19);

--  cdb_in(18:17)  : sie_dma_req - These two bits define the type of DMA
--                       request that the SIE is requesting. The bits are
--                       defined as:
--
--                        17 16 | Type of DMA request
--                       -------+--------------------------------------
--                         0  1 | BDT read DMA request (i.e. 4 bytes)
--                         1  0 | BDT write DMA request (i.e. 4 bytes)
--
--                       NOTE: The SIE will only activate one of the request
--                       bits at a time.
--
sie_dma_req(3 downto 2)  <= cdb_in(18 downto 17);

--  cdb_in(16)     : dma_early_req - This signal is used to have the DMA
--                   request the bus early. No bus cycles are performed
--                   with this request signal on the bus is requested.
--                   This is useful in design when the bus_gnt latency
--                   could exceed xxx ns, (zzz sie clks).
--
dma_early_req <= cdb_in(16);

--  cdb_in(15)     : bts_err_set - This signal when active will set the
--                   BTS_ERR interrupt in the error status register
--                   (err_stat_rg).
--
bts_err_set <= cdb_in(15);

--  cdb_in(14)     : own_err_set - This signal when active will set the
--                   OWN_ERR interrupt in the error status register
--                   (err_stat_rg).
--
own_err_set <= cdb_in(14);

--  cdb_in(13)     : dma_err_set - This signal when active will set the
--                   DMA_ERR interrupt in the error status register
--                   (err_stat_rg).
--
dma_err_set <= cdb_in(13);

--  cdb_in(12)     : bto_err_set - This signal when active will set the
--                   BTO_ERR interrupt in the error status register
--                   (err_stat_rg).
--
bto_err_set <= cdb_in(12);

--  cdb_in(11)     : dfn8_err_set - This signal when active will set the
--                   DF8N_ERR interrupt in the error status register
--                   (err_stat_rg).
--
dfn8_err_set <= cdb_in(11);

--  cdb_in(10)     : crc16_err_set - This signal when active will set the
--                   CRC16_ERR interrupt in the error status register
--                   (err_stat_rg).
--
crc16_err_set <= cdb_in(10);

--  cdb_in(9)      : crc5_err_set - This signal when active will set the
--                   CRC5_ERR interrupt in the error status register
--                   (err_stat_rg).
--
crc5_err_set <= cdb_in(9);

--  cdb_in(8)      : pid_err_set - This signal when active will set the
--                   PID_ERR interrupt in the error status register
--                   (err_stat_rg).
--
pid_err_set <= cdb_in(8);

--  cdb_in(7)      : stall_int_set - a stall handshake has been sent. This signal will
--                   cause stall bit in the interrupt status register to be set.
--
stall_int_set <= cdb_in(7);

--  cdb_in(6)      : attach_set - This siganal when active will set the USB
--                   attach/detach interrupt in the interrupt status register.
hc_attach_set <= cdb_in(6);   --  not currently implemented

--  cdb_in(5)      : resume_set - This signal when active will set the
--                   RESUME interrupt in the interrupt status register
--                   (istat_rg).
--
resume_set <= cdb_in(5);

--  cdb_in(4)      : sleep_set - This signal when active will set the
--                   SLEEP interrupt in the interrupt status register
--                   (istat_rg).
--
sleep_set <= cdb_in(4);

--  cdb_in(3)      : tok_dne_set - This signal when active will set the
--                   TOK_DNE interrupt in the interrupt status register
--                   (istat_rg).
--
tok_dne_set <= cdb_in(3);

--  cdb_in(2)      : sof_tok_set - This signal when active will set the
--                   SOF_TOK interrupt in the interrupt status register
--                   (istat_rg).
--
sof_tok_set <= cdb_in(2);

--  cdb_in(1)      : error_set - This signal when active will set the
--                   ERROR interrupt in the interrupt status register
--                   (istat_rg).
--
--  cdb_in(0)      : usb_rst_set - This signal when active will set the
--                   USB_RST interrupt in the interrupt status register
--                   (istat_rg).
--
usb_rst_set <= cdb_in(0);


--------------------------------------------------------------------------------
--
-- Assign control outputs
--
--  cdb_out(43)  : hc_retry_disable - disable the automatic retry of host transfer
--                failures.
cdb_out(43) <= hc_retry_disable;


--  cdb_out(42)  : resume_req - This signal causes the SIE to generate the resume
--                 signalling on the USB bus in device or embedded host mode. When
--                 operating in embedded host mode the resume signalling is 
--                 terminated with a LS EOP.
cdb_out(42)        <= resume_req;

--  cdb_out(41)  : hc_rst_req - This signal causes the SIE to generate the reset
--               signalling on the USB bus in embedded host mode.
cdb_out(41)       <= hc_rst_req;

--  cdb_out(40)  : txdsuspend_tokbusy dual use register output
--                    txd_suspend   - Transmit data packets are suspended on
--                                    the target until the uProcessor resets
--                                    the suspend ctl.
--                    hc_token_busy - The token statemachine has not completed
--                                    the last host token transaction.
cdb_out(40)      <= txdsuspend_tokbusy;

-- cdb_out(39:32): hc_sof_thld - SOF threshold: count of USB byte times
--                   before the next SOF at which to discontinue Host
--                   transactions.
cdb_out(39 downto 32)  <= hc_sof_thld_rg;

--  cdb_out(31:28)  : usb_token_pid - This is the PID used in host mode token packets.
cdb_out(31 downto 28)  <= hc_token_pid;
hc_token_pid <= hc_token_rg(7 downto 4);

--  cdb_out(27:24)  : usb_token_endpt - This is the Enpoint number  used in host mode
--               token packets.
cdb_out(27 downto 24)   <= hc_token_endpt ;
hc_token_endpt <= hc_token_rg(3 downto 0);

--  cdb_out(23:17) : addr(6:0) - This is the USB address that the usb_sie
--                   will compare with token packets.
--
cdb_out(23 downto 17) <= addr_rg(6 downto 0);

--  cdb_out(16)    : byte_count_eq - This bit informs the usb_sie that
--                   the DMA engine has reached a terminal byte count.
--                   Data transmission should terminate when all remaining
--                   data has been read from the Tx FIFO.
--
cdb_out(16) <= byte_count_eq;

--  cdb_out(15)     : odd_rst - reset the PING/PONG odd bits.
--
--cdb_out(15) <= odd_rst;   -- reset BDT ODD PING/PING bits when 1.
cdb_out(15) <= '0';   -- reset BDT ODD PING/PING bits when 1.

--  cdb_out(14:12)  : reserved
--
cdb_out(14 downto 13) <= "00";
--  cdb_out(12:8)   : endpt_ctl - Endpoint control bits.
--
--                12           11         10         9         8
--          +------------+-----------+----------+----------+---------+
--          | ep_ctl_dis | ep_out_en | ep_in_en | ep_stall | ep_hshk |
--          +------------+-----------+----------+----------+---------+

cdb_out(12 downto 8) <= endpt_ctl;

-- The current endpoint signal is a 16:1 mux that will select the
-- endpoint control register  based on our current endpoint.
with current_endpt select
  endpt_ctl <=
    ep_ctl0  when "0000",
    ep_ctl1  when "0001",
    ep_ctl2  when "0010",
    ep_ctl3  when "0011",
    ep_ctl4  when "0100",
    ep_ctl5  when "0101",
    ep_ctl6  when "0110",
    ep_ctl7  when "0111",
    ep_ctl8  when "1000",
    ep_ctl9  when "1001",
    ep_ctl10 when "1010",
    ep_ctl11 when "1011",
    ep_ctl12 when "1100",
    ep_ctl13 when "1101",
    ep_ctl14 when "1110",
    ep_ctl15 when "1111",
    "XXXXX" when others;

endpt_stall <= endpt_ctl(1);

--  cdb_out(7:2)   : bdt(7:2) - These signals are the first byte of
--                       the BDT. They contain the following control bits:
--
--                          7       6          5       4      3     2
--                       +-----+---------+----------+------+-----+------+
--                       | own | data0/1 | vusb_own | ninc | dts | stall|
--                       +-----+---------+----------+------+-----+------+
--
cdb_out(7 downto 2) <= own & bdt_rg0(6 downto 2);

--  cdb_out(1)    : bdt_valid - When this bit is active high it indicates
--                      that the BDT control bits are valid.
--
cdb_out(1) <= bdt_valid;

--  cdb_out(0)    : usb_en - This is the USB enable signal from the control
--                      register.
--
cdb_out(0) <= usb_en_int;

--------------------------------------------------------------------------------
-- Implements interrupt logic
--------------------------------------------------------------------------------

-- Interrupt request
-- This signal is active (high) whenever a bit in the int_stat_rg is set and
-- the corresponding enable bit in the int_enb_rg is set.
int <= ((int_stat_rg(7) and int_enb_rg(7)) or -- RSVD interrupt
        (int_stat_rg(6) and int_enb_rg(6)) or -- RSVD interrupt
        (int_stat_rg(5) and int_enb_rg(5)) or -- RESUME interrupt
        (int_stat_rg(4) and int_enb_rg(4)) or -- SLEEP interrupt
        (int_stat_rg(3) and int_enb_rg(3)) or -- TOK_DNE interrupt
        (int_stat_rg(2) and int_enb_rg(2)) or -- SOF_TOK interrupt
        (int_stat_rg(1) and int_enb_rg(1)) or -- ERROR interrupt
        (int_stat_rg(0) and int_enb_rg(0)));  -- USB_RST interrupt

-- Data Bus Output Enable
-- Enable data bus output enable when not in DMA mode and performing a slave read.
-- Or when DMA mode is active and performing a write to memory.
doe <= (not dma_active and cei and rei) or weo_lcl;

weo <= weo_lcl;  -- assign the write enable output with the local copy

reo <= reo_lcl;  -- assign the read enable output with the local copy

-- Bus Slave Signals Output Enable
-- Enable bus slave output enable when chip enable and read enable both active.
bsoe <= not dma_active and cei and rei;

-- Ready Output
rdyo <= '1'; -- Buffer output

-- Address output mux
-- There are three address sources Tx_page address source is used compute
-- what address the Tx BDT resides at in memory. Rx_page address does just
-- the same for the Rx BDT. And the last source is the address contained in
-- the BDT, where all the Tx data will be read from or where the Rx data
-- will be written to.
addro <=
  bdt_page_rg & current_endpt & bdt_addr3 & bdt_addr2 & bdt_addr1 & bdt_addr0 when
    (dma_pstate_eq_dma_byte = '0') else -- Select Tx_page address source
  dma_addr when
    (dma_pstate_eq_dma_byte = '1') else -- Select BDT address source
  "XXXXXXXXXXXXXXXX";

-- Data output
-- The read data is output on datao to make sure that read data
-- does not change during a processor write.
datao <= rd_data; -- Buffer output

-- Read data mux
-- This logic implements the read data select mux. The two data sources are
-- the DMA read data or the internal registers with read capability.
dout_mx: rd_data <=
  rd_datao     when dma_active = '0' else -- Select read data out
  dma_datao    when dma_active = '1' else -- Select DMA data out
  "XXXXXXXX";

-- Processor read mux
-- Select read data based on address in.
with addri(4 downto 0) select
  rd_datao <=
    int_stat_rg when c00h, -- Interrupt status register
    int_enb_rg  when c01h, -- Interrupt enable register
    err_stat_rg when c02h, -- Error status register
    err_enb_rg  when c03h, -- Error enable register
    stat_rdata  when c04h, -- Status register
    ctl_rg_out  when c05h, -- Control register
    addr_rg     when c06h, -- Address register
    bdt_page_rg when c07h, -- BDT Page register
    frm_numl_rg when c08h, -- Frame number low register
    frm_numh_rg when c09h, -- Frame number high register
    hc_token_rg when c0ah, -- Token register
    hc_sof_thld_rg    when c0bh, -- SOF threshold register
    hc_sof_thld_rg    when c0ch, -- RSVD aliases to SOF threshold register
    hc_sof_thld_rg    when c0dh, -- RSVD aliases to SOF threshold register
    hc_sof_thld_rg    when c0eh, -- RSVD aliases to SOF threshold register
    hc_sof_thld_rg    when c0fh, -- RSVD aliases to SOF threshold register
    host_wo_hub_int & hc_retry_disable & '0' &
            ep_ctl0  when c10h, -- Endpoint control register0
    "000" & ep_ctl1  when c11h, -- Endpoint control register1
    "000" & ep_ctl2  when c12h, -- Endpoint control register2
    "000" & ep_ctl3  when c13h, -- Endpoint control register3
    "000" & ep_ctl4  when c14h, -- Endpoint control register4
    "000" & ep_ctl5  when c15h, -- Endpoint control register5
    "000" & ep_ctl6  when c16h, -- Endpoint control register6
    "000" & ep_ctl7  when c17h, -- Endpoint control register7
    "000" & ep_ctl8  when c18h, -- Endpoint control register8
    "000" & ep_ctl9  when c19h, -- Endpoint control register9
    "000" & ep_ctl10 when c1ah, -- Endpoint control register10
    "000" & ep_ctl11 when c1bh, -- Endpoint control register11
    "000" & ep_ctl12 when c1ch, -- Endpoint control register12
    "000" & ep_ctl13 when c1dh, -- Endpoint control register13
    "000" & ep_ctl14 when c1eh, -- Endpoint control register14
    "000" & ep_ctl15 when c1fh, -- Endpoint control register15
    "XXXXXXXX" when others;

-- BDT own bit (0=up, 1=SIE)
-- This signal is only valid if the own bit=1 and we have a valid BDT.
own <= bdt_rg0(7) and bdt_valid AND NOT stat_full;

-- BDT ninc control bit
-- keep=1 causes the dma channel not to update the BDT, so the owns bit remains
-- set after the completion of a transfer ussually used with ninc.
keep <= bdt_rg0(5);
-- ninc=1 disable address increment, ninc=0 enable address increment
ninc <= bdt_rg0(4);

-- Buffer description table register0
bdt_rg0 <= bdt_ctl & byte_cnt(9 downto 8);

-- Buffer description table register1
bdt_rg1 <= byte_cnt(7 downto 0);

--    7      6       5      4      3     2     1:0
-- +-----+--------+------+------+-----+------+-----+
-- | OWN | DATA01 | KEEP | NINC | DTS | RSVD | BCH |
-- +-----+--------+------+------+-----+------+-----+
--
-- DMA data out mux
dma_dmx: dma_datao <=
  -- OWN=1 when KEEP=1 else 0
  (bdt_rg0(7) and bdt_rg0(5)) &
  -- DATA01=out_data01_pid if out or setup token else it is bdt_rg(6)
  ((out_data01_pid and not bdt_addr3) or
--  (bdt_rg0(6) and bdt_addr3)) & token_pid & bdt_rg0(1 downto 0)
  (bdt_rg0(6) and bdt_addr3)) & bdt_wrt_pid_f & bdt_rg0(1 downto 0)
            when dma_pstate = DMA_BDT0 else
  -- Output buffer descriptor table byte0
  bdt_rg1   when dma_pstate = DMA_BDT1 else
  -- Output buffer descriptor table byte1
  bdt_rg2   when dma_pstate = DMA_BDT2 else
  -- Output buffer descriptor table byte2
  bdt_rg3   when dma_pstate = DMA_BDT3 else
  -- Output buffer descriptor table byte3
  rx_rdata  when dma_pstate = DMA_BYTE else
  -- Output Rx data
  "XXXXXXXX";

-- Decode register load enables
-- Each load enable decodes the chip enable signal, address bits 3:0 are
-- compared to a fixed constant, and write enable must be active.
-- Interrupt status register load enable
int_stat_ld <= '1' when reset = '1' or (addri(4 downto 0) = c00h and
                        cei = '1' and wei = '1') else '0';

-- Interrupt enable register load enable
int_enb_ld <= '1' when reset = '1' or (addri(4 downto 0) = c01h and
                       cei = '1' and wei = '1') else '0';

-- Error status register load enable
err_stat_ld <= '1' when reset = '1' or (addri(4 downto 0) = c02h and
                        cei = '1' and wei = '1') else '0';

-- Error enable register load enable
err_enb_ld <= '1' when reset = '1' or (addri(4 downto 0) = c03h and
                       cei = '1' and wei = '1') else '0';

---- Status register load enable
--stat_ld <= '1' when reset = '1' or (addri(4 downto 0) = c04h and
--                    cei = '1' and wei = '1') else '0';
--
-- Control register load enable
ctl_ld <= '1' when reset = '1' or (addri(4 downto 0) = c05h and
                   cei = '1' and wei = '1') else '0';

-- Address register load enable
addr_ld <= '1' when reset = '1' or (addri(4 downto 0) = c06h and
                    cei = '1' and wei = '1') else '0';

-- BDT page register load enable
bdt_page_ld <= '1' when reset = '1' or (addri(4 downto 0) = c07h and
                        cei = '1' and wei = '1') else '0';

-- Embedded host token register load enable
hc_token_ld <= '1' when hc_en = '1' and (reset = '1' or
                       (addri(4 downto 0) = c0ah and
                        cei = '1' and wei = '1')) else '0';
-- Embedded host SOF threshold register load enable
hc_sof_thld_ld <= '1' when hc_en = '1' and (reset = '1' or
                       (addri(4 downto 0) = c0bh and
                        cei = '1' and wei = '1')) else '0';

-- Endpoint control register0 load enable
endpt0_ld <= '1' when reset = '1' or (addri(4 downto 0) = c10h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register1 load enable
endpt1_ld <= '1' when reset = '1' or (addri(4 downto 0) = c11h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register2 load enable
endpt2_ld <= '1' when reset = '1' or (addri(4 downto 0) = c12h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register3 load enable
endpt3_ld <= '1' when reset = '1' or (addri(4 downto 0) = c13h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register4 load enable
endpt4_ld <= '1' when reset = '1' or (addri(4 downto 0) = c14h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register5 load enable
endpt5_ld <= '1' when reset = '1' or (addri(4 downto 0) = c15h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register6 load enable
endpt6_ld <= '1' when reset = '1' or (addri(4 downto 0) = c16h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register7 load enable
endpt7_ld <= '1' when reset = '1' or (addri(4 downto 0) = c17h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register8 load enable
endpt8_ld <= '1' when reset = '1' or (addri(4 downto 0) = c18h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register9 load enable
endpt9_ld <= '1' when reset = '1' or (addri(4 downto 0) = c19h and
                      cei = '1' and wei = '1') else '0';

-- Endpoint control register10 load enable
endpt10_ld <= '1' when reset = '1' or (addri(4 downto 0) = c1ah and
                       cei = '1' and wei = '1') else '0';

-- Endpoint control register11 load enable
endpt11_ld <= '1' when reset = '1' or (addri(4 downto 0) = c1bh and
                       cei = '1' and wei = '1') else '0';

-- Endpoint control register12 load enable
endpt12_ld <= '1' when reset = '1' or (addri(4 downto 0) = c1ch and
                       cei = '1' and wei = '1') else '0';

-- Endpoint control register13 load enable
endpt13_ld <= '1' when reset = '1' or (addri(4 downto 0) = c1dh and
                       cei = '1' and wei = '1') else '0';

-- Endpoint control register14 load enable
endpt14_ld <= '1' when reset = '1' or (addri(4 downto 0) = c1eh and
                       cei = '1' and wei = '1') else '0';

-- Endpoint control register15 load enable
endpt15_ld <= '1' when reset = '1' or (addri(4 downto 0) = c1fh and
                       cei = '1' and wei = '1') else '0';

-- BDT register0 load enable
bdt_ld0 <= '1' when dma_pstate = DMA_BDT0 and dma_rd_bdt = '1' else
           '0';

-- BDT register1 load enable
bdt_ld1 <= '1' when dma_pstate = DMA_BDT1 and dma_rd_bdt = '1' else
           '0';

-- BDT register2 load enable
bdt_ld2 <= '1' when dma_pstate = DMA_BDT2 and dma_rd_bdt = '1' else
           '0';

-- BDT register3 load enable
bdt_ld3 <= '1' when dma_pstate = DMA_BDT3 and dma_rd_bdt = '1' else
           '0';

-- Write data
-- We mask datai with not reset here to clear all registers during reset.
wrt_data <= datai and (not reset & not reset & not reset & not reset &
                   not reset & not reset & not reset & not reset);

-----------------------------------------------------------------------------
-- Interrupt control signals
-----------------------------------------------------------------------------
-- Interrupt bits are set by cdb_in signals.
-- Interrupt bits are cleared by writing the respective register with a '1'.

--     7        6       5       4        3         2        1        0
-- +-------+--------+--------+-------+---------+---------+-------+---------+
-- | STALL | ATTACH | RESUME | SLEEP | TOK_DNE | SOF_TOK | ERROR | USB_RST |
-- +-------+--------+--------+-------+---------+---------+-------+---------+


-- Stall interrupt clear
stall_int_clr <= '1' when int_stat_ld = '1' and wrt_data(7) = '1'
                     else '0';
-- Stall register D-input
stall_int_d <= stall_int_set or -- set term
              (stall_int and not stall_int_clr); -- hold

-- Attach/Detach interrupt clear
hc_attach_clr <= '1' when int_stat_ld = '1' and wrt_data(6) = '1'
                     else '0';
-- Attach/Detach register D-input
hc_attach_d <= (hc_en and hc_attach_set) or
               (hc_en and hc_attach and not hc_attach_clr);

-- Resume interrupt clear
resume_clr <= '1' when int_stat_ld = '1' and wrt_data(5) = '1' else
              '0';

-- Sleep interrupt clear
sleep_clr <= '1' when int_stat_ld = '1' and wrt_data(4) = '1' else
             '0';

-- TOK_DNE interrupt clear
tok_dne_clr <= '1' when int_stat_ld = '1' and wrt_data(3) = '1' else
               '0';

-- SOF_TOK interrupt clear
sof_tok_clr <= '1' when int_stat_ld = '1' and wrt_data(2) = '1' else
               '0';

-- Error interrupt clear
error_clr <= '1' when int_stat_ld = '1' and wrt_data(1) = '1' else
             '0';

-- USB_RST interrupt clear
usb_rst_clr <= '1' when int_stat_ld = '1' and wrt_data(0) = '1' else
               '0';

--      7         6         5         4       3       2       1       0
-- +---------+---------+---------+---------+------+-------+------+---------+
-- | BTS_ERR | OWN_ERR | DMA_ERR | BTO_ERR | DFN8 | CRC16 | CRC5 | PID_ERR |
-- +---------+---------+---------+---------+------+-------+------+---------+

-- Bit stuff error interrupt clear
bts_err_clr <= '1' when err_stat_ld = '1' and wrt_data(7) = '1' else
               '0';

-- Own timeout error interrupt clear
own_err_clr <= '1' when err_stat_ld = '1' and wrt_data(6) = '1' else
               '0';

-- DMA timeout error interrupt clear
dma_err_clr <= '1' when err_stat_ld = '1' and wrt_data(5) = '1' else
               '0';

-- Bus timeout error interrupt clear
bto_err_clr <= '1' when err_stat_ld = '1' and wrt_data(4) = '1' else
               '0';

-- Data field not 8-bits error interrupt clear
dfn8_err_clr <= '1' when err_stat_ld = '1' and wrt_data(3) = '1' else
                '0';

-- CRC16 error interrupt clear
crc16_err_clr <= '1' when err_stat_ld = '1' and wrt_data(2) = '1' else
                 '0';

-- CRC5 error interrupt clear
crc5_err_clr <= '1' when err_stat_ld = '1' and wrt_data(1) = '1' else
                '0';

-- PID error interrupt clear
pid_err_clr <= '1' when err_stat_ld = '1' and wrt_data(0) = '1' else
               '0';

-- Implement interrupt status register (int_stat_rg)
--
--     7        6       5       4        3         2        1        0
-- +-------+--------+--------+-------+---------+---------+-------+---------+
-- | STALL | ATTACH | RESUME | SLEEP | TOK_DNE | SOF_TOK | ERROR | USB_RST |
-- +-------+--------+--------+-------+---------+---------+-------+---------+
--
int_stat_rg <= stall_int & hc_attach & resume & sleep &
               tok_dne  & sof_tok   & error  & usb_rst;

-- Implement error status register (err_stat_rg)
--
--      7         6         5         4       3       2       1       0
-- +---------+---------+---------+---------+------+-------+------+---------+
-- | BTS_ERR | OWN_ERR | DMA_ERR | BTO_ERR | DFN8 | CRC16 | CRC5 | PID_ERR |
-- +---------+---------+---------+---------+------+-------+------+---------+
--
err_stat_rg <= bts_err & own_err & dma_err & bto_err &
               dfn8_err & crc16_err & crc5_err & pid_err;

error_set <= '1' when (err_stat_rg and err_enb_rg) /= "00000000"
                 else '0';


-- Implements status register fifo
stat_fifo: fifo8xn
  port map (
    clk       => clk,          -- everything clocks on rising edge
    reset     => reset,        -- reset active high
    load      => stat_we,      -- write a byte
    unload    => stat_re,      -- read a byte
    full      => stat_full,    -- 1=FIFO is full
    full_1    => open,         -- 1=FIFO is almost full (1 byte free)
    empty     => stat_empty,   -- 1=FIFO is empty
    out_valid => stat_valid,   -- 1=DATA_OUT has valid data in it
    out_val_1 => open,         -- 1=OUT_VALID 1 byte from the bottom
    data_in   => stat_wdata,   -- data bus in
    data_out  => stat_rdata);  -- data bus in

-- FIFO reset
-- We reset the fifo if reset is active or we detect a USB reset.
--stat_reset <= reset or usb_rst_set;

-- Status fifo write data
stat_wdata <= current_endpt & txd_token & odd_bdt & "00";

-- Status FIFO read enable
stat_re <= tok_dne_clr;

-- Status FIFO write enable
stat_we <= tok_dne_set and not stat_full;

-- Tx FIFO write enable
tx_we <= tx_we_lcl and rdyi;

-- Rx FIFO read enable
rx_re <= rx_re_elr and rdyi;

-- Control register definitions
--   7     6        5          4         3             2       1         0
--+-----+-----+------------+-------+--------------+--------+---------+--------+
--| rcv | se0 | txd_suspend| reset | host_mode_en | resume | odd_rst | usb_en |
--|     |     | token_busy |       |              |        |         |        |
--+-----+-----+------------+-------+--------------+--------+---------+--------+
--
ctl_rg_out <= rcv & se0  & txdsuspend_tokbusy & ctl_rg;

--txdsuspend_tokbusy <= ctl_rg(5)
hc_rst_req    <= ctl_rg(4);
host_mode_int <= ctl_rg(3); -- internal version of host_mode_en.
resume_req    <= ctl_rg(2);
odd_rst       <= ctl_rg(1);
usb_en_int    <= ctl_rg(0);

--------------------------------------------------------------------------------
-- Implement microprocessor interface registers
--------------------------------------------------------------------------------
  -- indirectly reset registers
elr_rg: process (clk)
begin

if clk'event and clk = '1' then

  -- read data mux output
  rd_datao_rg <= rd_datao;

  -- Chip Enable Output
  ceo <= dma_active_d;

  -- Bus Master Signals Output Enable
  bmoe <= bmoe_d;

  -- Interrupt enable register
  if int_enb_ld = '1' then
    int_enb_rg <= wrt_data; -- Write interrupt enable register
  else
    int_enb_rg <= int_enb_rg; -- No change
  end if;

  -- Error enable register
  if err_enb_ld = '1' then
    err_enb_rg <= wrt_data; -- Write error enable register
  else
    err_enb_rg <= err_enb_rg; -- No change
  end if;

  -- Implements control register
  if ctl_ld = '1' then
    ctl_rg <= wrt_data(4 downto 0); -- Write control register
    txdsuspend_tokbusy <= wrt_data(5);
  else
    ctl_rg <= ctl_rg; -- No change
    if txdsuspend_tokbusy_clr = '1' then
      txdsuspend_tokbusy <= '0';
    elsif txdsuspend_tokbusy_set = '1' OR 
          hc_token_ld = '1' then
      txdsuspend_tokbusy <= '1';
    end if;
  end if;

  -- Implements address register
  if addr_ld = '1' then
    addr_rg <= wrt_data; -- Write address register
  else
    addr_rg <= addr_rg; -- No change
  end if;

  -- Implements BDT page register
  if bdt_page_ld = '1' then
    bdt_page_rg <= wrt_data; -- Write BDT page register
  else
    bdt_page_rg <= bdt_page_rg; -- No change
  end if;

  -- Implements embedded host controller host without hub bit of the endpoint
  -- 0 control register
  -- This register should be optimized away if IMPLEMENT_EMBEDDED_HOST is equal
  -- to '0'
  if hc_en = '0' then
    host_wo_hub_q <= '0'; -- Only impement for host
  elsif endpt0_ld = '1' then
    host_wo_hub_q <= wrt_data(7); -- Write the special bits EPCTL0
  end if;

  -- Implements embedded host controller host retry disable bit of the endpoint
  -- 0 control register
  -- This register should be optimized away if IMPLEMENT_EMBEDDED_HOST is equal
  -- to '0'
  if hc_en = '0' then
    hc_retry_disable_q <= '0'; -- Only impement for host
  elsif endpt0_ld = '1' then
    hc_retry_disable_q <= wrt_data(6); -- Write the special bits EPCTL0
  end if;

  -- Implements embedded host controller token register
  -- This register should be optimized away if IMPLEMENT_EMBEDDED_HOST is equal
  -- to '0'
  if hc_en = '0' then
    hc_token_q <= (Others => '0'); -- Only impement for host
  elsif hc_token_ld = '1' then
    hc_token_q <= wrt_data; -- Write BDT page register
  end if;

  -- Implements embedded host contoller SOF threshold register
  -- This register should be optimized away if IMPLEMENT_EMBEDDED_HOST is equal
  -- to '0'
  if hc_en = '0' then
    hc_sof_thld_q <= (Others => '0'); -- Only impement for host
  elsif hc_sof_thld_ld = '1' then
    hc_sof_thld_q <= wrt_data; -- Write BDT page register
  end if;

  -- Implements endpoint control register0
  --  Note: bit 6 and 7 of endpt0_rg is a host mode only bit search for hc_retry_disable
  --  in this file.
  if endpt0_ld = '1' then
    endpt0_rg <= wrt_data(4 downto 0); -- Write endpoint control register0
  elsif current_endpt = "0000" AND endpt_stall_set = '1' then
    endpt0_rg <= endpt0_rg(4 downto 2) & '1' & endpt0_rg(0);
  elsif current_endpt = "0000" AND endpt_stall_clr = '1' then
    endpt0_rg <= endpt0_rg(4 downto 2) & '0' & endpt0_rg(0);
  else
    endpt0_rg <= endpt0_rg; -- No change
  end if;

  -- Implements endpoint control register1
  if endpt1_ld = '1' then
    endpt1_rg <= wrt_data(4 downto 0); -- Write endpoint control register1
  elsif current_endpt = "0001" and endpt_stall_set = '1' then
    endpt1_rg <= endpt1_rg(4 DOWNTO 2) & '1' & endpt1_rg(0);
  elsif current_endpt = "0001" and endpt_stall_clr = '1' then
    endpt1_rg <= endpt1_rg(4 DOWNTO 2) & '0' & endpt1_rg(0);
  else
    endpt1_rg <= endpt1_rg; -- No change
  end if;

  -- Implements endpoint control register2
  if endpt2_ld = '1' then
    endpt2_rg <= wrt_data(4 downto 0); -- Write endpoint control register2
  elsif current_endpt = "0010" and endpt_stall_set = '1' then
    endpt2_rg <= endpt2_rg(4 DOWNTO 2) & '1' & endpt2_rg(0);
  elsif current_endpt = "0010" and endpt_stall_clr = '1' then
    endpt2_rg <= endpt2_rg(4 DOWNTO 2) & '0' & endpt2_rg(0);
  else
    endpt2_rg <= endpt2_rg; -- No change
  end if;

  -- Implements endpoint control register3
  if endpt3_ld = '1' then
    endpt3_rg <= wrt_data(4 downto 0); -- Write endpoint control register3
  elsif current_endpt = "0011" and endpt_stall_set = '1' then
    endpt3_rg <= endpt3_rg(4 DOWNTO 2) & '1' & endpt3_rg(0);
  elsif current_endpt = "0011" and endpt_stall_clr = '1' then
    endpt3_rg <= endpt3_rg(4 DOWNTO 2) & '0' & endpt3_rg(0);
  else
    endpt3_rg <= endpt3_rg; -- No change
  end if;

  -- Implements endpoint control register4
  if endpt4_ld = '1' then
    endpt4_rg <= wrt_data(4 downto 0); -- Write endpoint control register4
  elsif current_endpt = "0100" and endpt_stall_set = '1' then
    endpt4_rg <= endpt4_rg(4 DOWNTO 2) & '1' & endpt4_rg(0);
  elsif current_endpt = "0100" and endpt_stall_clr = '1' then
    endpt4_rg <= endpt4_rg(4 DOWNTO 2) & '0' & endpt4_rg(0);
  else
    endpt4_rg <= endpt4_rg; -- No change
  end if;

  -- Implements endpoint control register5
  if endpt5_ld = '1' then
    endpt5_rg <= wrt_data(4 downto 0); -- Write endpoint control register5
  elsif current_endpt = "0101" and endpt_stall_set = '1' then
    endpt5_rg <= endpt5_rg(4 DOWNTO 2) & '1' & endpt5_rg(0);
  elsif current_endpt = "0101" and endpt_stall_clr = '1' then
    endpt5_rg <= endpt5_rg(4 DOWNTO 2) & '0' & endpt5_rg(0);
  else
    endpt5_rg <= endpt5_rg; -- No change
  end if;

  -- Implements endpoint control register6
  if endpt6_ld = '1' then
    endpt6_rg <= wrt_data(4 downto 0); -- Write endpoint control register6
  elsif current_endpt = "0110" and endpt_stall_set = '1' then
    endpt6_rg <= endpt6_rg(4 DOWNTO 2) & '1' & endpt6_rg(0);
  elsif current_endpt = "0110" and endpt_stall_clr = '1' then
    endpt6_rg <= endpt6_rg(4 DOWNTO 2) & '0' & endpt6_rg(0);
  else
    endpt6_rg <= endpt6_rg; -- No change
  end if;

  -- Implements endpoint control register7
  if endpt7_ld = '1' then
    endpt7_rg <= wrt_data(4 downto 0); -- Write endpoint control register7
  elsif current_endpt = "0111" and endpt_stall_set = '1' then
    endpt7_rg <= endpt7_rg(4 DOWNTO 2) & '1' & endpt7_rg(0);
  elsif current_endpt = "0111" and endpt_stall_clr = '1' then
    endpt7_rg <= endpt7_rg(4 DOWNTO 2) & '0' & endpt7_rg(0);
  else
    endpt7_rg <= endpt7_rg; -- No change
  end if;

  -- Implements endpoint control register8
  if endpt8_ld = '1' then
    endpt8_rg <= wrt_data(4 downto 0); -- Write endpoint control register8
  elsif current_endpt = "1000" and endpt_stall_set = '1' then
    endpt8_rg <= endpt8_rg(4 DOWNTO 2) & '1' & endpt8_rg(0);
  elsif current_endpt = "1000" and endpt_stall_clr = '1' then
    endpt8_rg <= endpt8_rg(4 DOWNTO 2) & '0' & endpt8_rg(0);
  else
    endpt8_rg <= endpt8_rg; -- No change
  end if;

  -- Implements endpoint control register9
  if endpt9_ld = '1' then
    endpt9_rg <= wrt_data(4 downto 0); -- Write endpoint control register9
  elsif current_endpt = "1001" and endpt_stall_set = '1' then
    endpt9_rg <= endpt9_rg(4 DOWNTO 2) & '1' & endpt9_rg(0);
  elsif current_endpt = "1001" and endpt_stall_clr = '1' then
    endpt9_rg <= endpt9_rg(4 DOWNTO 2) & '0' & endpt9_rg(0);
  else
    endpt9_rg <= endpt9_rg; -- No change
  end if;

  -- Implements endpoint control register10
  if endpt10_ld = '1' then
    endpt10_rg <= wrt_data(4 downto 0); -- Write endpoint control register10
  elsif current_endpt = "1010" and endpt_stall_set = '1' then
    endpt10_rg <= endpt10_rg(4 DOWNTO 2) & '1' & endpt10_rg(0);
  elsif current_endpt = "1010" and endpt_stall_clr = '1' then
    endpt10_rg <= endpt10_rg(4 DOWNTO 2) & '0' & endpt10_rg(0);
  else
    endpt10_rg <= endpt10_rg; -- No change
  end if;

  -- Implements endpoint control register11
  if endpt11_ld = '1' then
    endpt11_rg <= wrt_data(4 downto 0); -- Write endpoint control register11
  elsif current_endpt = "1011" and endpt_stall_set = '1' then
    endpt11_rg <= endpt11_rg(4 DOWNTO 2) & '1' & endpt11_rg(0);
  elsif current_endpt = "1011" and endpt_stall_clr = '1' then
    endpt11_rg <= endpt11_rg(4 DOWNTO 2) & '0' & endpt11_rg(0);
  else
    endpt11_rg <= endpt11_rg; -- No change
  end if;

  -- Implements endpoint control register12
  if endpt12_ld = '1' then
    endpt12_rg <= wrt_data(4 downto 0); -- Write endpoint control register12
  elsif current_endpt = "1100" and endpt_stall_set = '1' then
    endpt12_rg <= endpt12_rg(4 DOWNTO 2) & '1' & endpt12_rg(0);
  elsif current_endpt = "1100" and endpt_stall_clr = '1' then
    endpt12_rg <= endpt12_rg(4 DOWNTO 2) & '0' & endpt12_rg(0);
  else
    endpt12_rg <= endpt12_rg; -- No change
  end if;

  -- Implements endpoint control register13
  if endpt13_ld = '1' then
    endpt13_rg <= wrt_data(4 downto 0); -- Write endpoint control register13
  elsif current_endpt = "1101" and endpt_stall_set = '1' then
    endpt13_rg <= endpt13_rg(4 DOWNTO 2) & '1' & endpt13_rg(0);
  elsif current_endpt = "1101" and endpt_stall_clr = '1' then
    endpt13_rg <= endpt13_rg(4 DOWNTO 2) & '0' & endpt13_rg(0);
  else
    endpt13_rg <= endpt13_rg; -- No change
  end if;

  -- Implements endpoint control register14
  if endpt14_ld = '1' then
    endpt14_rg <= wrt_data(4 downto 0); -- Write endpoint control register14
  elsif current_endpt = "1110" and endpt_stall_set = '1' then
    endpt14_rg <= endpt14_rg(4 DOWNTO 2) & '1' & endpt14_rg(0);
  elsif current_endpt = "1110" and endpt_stall_clr = '1' then
    endpt14_rg <= endpt14_rg(4 DOWNTO 2) & '0' & endpt14_rg(0);
  else
    endpt14_rg <= endpt14_rg; -- No change
  end if;

  -- Implements endpoint control register15
  if endpt15_ld = '1' then
    endpt15_rg <= wrt_data(4 downto 0); -- Write endpoint control register15
  elsif current_endpt = "1111" and endpt_stall_set = '1' then
    endpt15_rg <= endpt15_rg(4 DOWNTO 2) & '1' & endpt15_rg(0);
  elsif current_endpt = "1111" and endpt_stall_clr = '1' then
    endpt15_rg <= endpt15_rg(4 DOWNTO 2) & '0' & endpt15_rg(0);
  else
    endpt15_rg <= endpt15_rg; -- No change
  end if;

--  -- Implements token pid register
--  if tok_dne_set = '1' then
--    token_pid <= token_pid_d;
--  elsif current_endpt = "0000" and endpt_stall_set = '1'
--    token_pid <= token_pid; -- No change
--  end if;

  ------------------------------------------------------------------------------
  -- Implements the BDT registers
  --
  --    7       6          5       4      3     2     1:0
  -- +-----+---------+----------+------+-----+------+-----+
  -- | own | data0/1 | vusb_own | ninc | dts | rsvd | bch |
  -- +-----+---------+----------+------+-----+------+-----+
  -- |                         bcl                        |
  -- +-----+---------+----------+------+-----+------+-----+
  -- |                        addrl                       |
  -- +-----+---------+----------+------+-----+------+-----+
  -- |                        addrh                       |
  -- +-----+---------+----------+------+-----+------+-----+
  --
  ------------------------------------------------------------------------------
  -- Implements the BDT byte counter
  if bdt_ld1 = '1' or bdt_ld0 = '1' then
    if bdt_ld1 = '1' then
      -- Clear byte count low register
      byte_cnt(7 downto 0) <= "00000000";
    else
      -- Clear byte count high register bits 1:0
      byte_cnt(9 downto 8) <= "00";
    end if;
  elsif byte_cnt_inc = '1' then
    byte_cnt <= std_ulogic_vector(unsigned(byte_cnt) + 1); -- Inc counter
  else
    byte_cnt <= byte_cnt; -- No change
  end if;

  -- Implements the BDT byte counter save register
  if bdt_ld1 = '1' or bdt_ld0 = '1' then
    if bdt_ld1 = '1' then
      -- Load byte count save low register
      byte_cnt_save(7 downto 0) <= dmadatai(7 downto 0);
    else
      -- Load byte count save high register bits 1:0
      byte_cnt_save(9 downto 8) <= dmadatai(1 downto 0);
    end if;
  else
    byte_cnt_save <= byte_cnt_save; -- No change
  end if;

  -- Implements the BDT control bits
  if bdt_ld0 = '1' then
    bdt_ctl <= dmadatai(7 downto 2); -- BDT control bits
  else
    bdt_ctl <= bdt_ctl; -- No change
  end if;

  -- Implements the BDT DMA address pointer
  if bdt_ld2 = '1' or bdt_ld3 = '1' then
    if bdt_ld2 = '1' then
      dma_addr(7 downto 0) <= dmadatai(7 downto 0); -- DMA address low register
    else
      dma_addr(15 downto 8) <= dmadatai(7 downto 0); -- DMA address high register
    end if;
  elsif dma_addr_inc = '1' then
    dma_addr <= std_ulogic_vector(unsigned(dma_addr) + 1); -- Inc counter
  else
    dma_addr <= dma_addr; -- No change
  end if;

  -- Tx FIFO write enable
  if (dma_nstate = DMA_BYTE) then
    tx_we_lcl <= dma_rd_en;
  else
    tx_we_lcl <= '0';
  end if;

  -- Rx FIFO read enable local
  if (dma_nstate = DMA_BYTE) then
    rx_re_elr <= dma_wrt_en;
  else
    rx_re_elr <= '0';
  end if;
end if;
end process elr_rg;

  -- directly reset registers

elr_rst_rg: process (clk) --vsync_rst
--vasync_rst elr_rst_rg: process (clk,reset)
begin
--vasync_rst  if reset = '1' then
if clk'event and clk = '1' then --vsync_rst
  if reset = '1' then --vsync_rst
    weo_lcl <= '0'; -- Reset
    reo_lcl <= '0'; -- Reset
    bts_err <= '0'; -- Reset BTS_ERR
    own_err <= '0'; -- Reset OWN_ERR
    dma_err <= '0'; -- Reset DMA_ERR
    bto_err <= '0'; -- Reset BTO_ERR
    dfn8_err <= '0'; -- Reset DFN8_ERR
    crc16_err <= '0'; -- Reset CRC16_ERR
    crc5_err <= '0'; -- Reset CRC5_ERR
    pid_err <= '0'; -- Reset PID_ERR
    pid_err <= '0'; -- Reset PID_ERR
    stall_int <= '0'; -- Reset Stall
    hc_attach_q <= '0'; -- Reset Atach
    resume <= '0'; -- Reset RESUME
    sleep <= '0'; -- Reset SLEEP
    tok_dne <= '0'; -- Reset TOK_DNE
    sof_tok <= '0'; -- Reset SOF_TOK
    error <= '0'; -- Reset ERROR
    usb_rst <= '0'; -- Reset USB_RST
    bdt_rg2 <= "00000000";
    bdt_rg3 <= "00000000";
    bdt_valid <= '0'; -- Reset BDT valid bit on bdt read of write request
  else --vsync_rst
--vasync_rst   elsif clk'event and clk = '1' then

-- Write Enable Output
    if load_en = '1' then
      weo_lcl <= dma_active_d and (dma_wrt_bdt or dma_wrt_byte);
    else
      weo_lcl <= weo_lcl; -- No change
    end if;

    -- Read Enable Output
    if load_en = '1' then
      reo_lcl <= dma_active_d and (dma_rd_bdt or dma_rd_byte);
    else
      reo_lcl <= reo_lcl;
    end if;

    -- Implements BTS_ERR interrupt flip flop
    if bts_err_set = '1' then
      bts_err <= '1'; -- Set BTS_ERR
    elsif bts_err_clr ='1' then
      bts_err <= '0'; -- Reset BTS_ERR
    else
      bts_err <= bts_err; -- No change
    end if;

    -- Implements OWN_ERR interrupt flip flop
    if own_err_set = '1' then
      own_err <= '1'; -- Set OWN_ERR
    elsif own_err_clr ='1' then
      own_err <= '0'; -- Reset OWN_ERR
    else
      own_err <= own_err; -- No change
    end if;

    -- Implements DMA timeout error interrupt flip flop
    if dma_err_set = '1' OR dma_overrun = '1' then
      dma_err <= '1'; -- Set DMA_ERR
    elsif dma_err_clr ='1' then
      dma_err <= '0'; -- Reset DMA_ERR
    else
      dma_err <= dma_err; -- No change
    end if;

    -- Implements bus timeout error interrupt flip flop
    if bto_err_set = '1' then
      bto_err <= '1'; -- Set BTO_ERR
    elsif bto_err_clr ='1' then
      bto_err <= '0'; -- Reset BTO_ERR
    else
      bto_err <= bto_err; -- No change
    end if;

    -- Implements data field not 8-bits error interrupt flip flop
    if dfn8_err_set = '1' then
      dfn8_err <= '1'; -- Set DFN8_ERR
    elsif dfn8_err_clr ='1' then
      dfn8_err <= '0'; -- Reset DFN8_ERR
    else
      dfn8_err <= dfn8_err; -- No change
    end if;

    -- Implements CRC16_ERR interrupt flip flop
    if crc16_err_set = '1' then
      crc16_err <= '1'; -- Set CRC16_ERR
    elsif crc16_err_clr ='1' then
      crc16_err <= '0'; -- Reset CRC16_ERR
    else
      crc16_err <= crc16_err; -- No change
    end if;

    -- Implements CRC5_ERR interrupt flip flop
    if crc5_err_set = '1' then
      crc5_err <= '1'; -- Set CRC5_ERR
    elsif crc5_err_clr ='1' then
      crc5_err <= '0'; -- Reset CRC5_ERR
    else
      crc5_err <= crc5_err; -- No change
    end if;

    -- Implements PID_ERR interrupt flip flop
    if pid_err_set = '1' then
      pid_err <= '1'; -- Set PID_ERR
    elsif pid_err_clr ='1' then
      pid_err <= '0'; -- Reset PID_ERR
    else
      pid_err <= pid_err; -- No change
    end if;

    -- Implements Stall interrupt flip flop
    stall_int <= stall_int_d; --

    -- Implements Attach interrupt flip flop
    hc_attach_q <= hc_attach_d and hc_en; --

    hc_token_clr_q <= (ctl_ld AND hc_en AND wrt_data(4)) OR  -- when you write the a 1 to
                                         -- the ctl_rg token busy bit a request to cancel
                                         -- the current token is issued.
                      (hc_token_clr AND NOT hc_token_ack); -- hold till acknowledged

    hc_token_req_q <= hc_token_ld OR   -- when you write the token register it is a
                                        -- request to start a embedded host token
                                        -- transacton.
                      (hc_token_req AND NOT hc_token_ack); -- hold till acknowledged


    -- Implements RESUME interrupt flip flop
    if resume_set = '1' then
      resume <= '1'; -- Set RESUME
    elsif resume_clr ='1' then
      resume <= '0'; -- Reset RESUME
    else
      resume <= resume; -- No change
    end if;

    -- Implements SLEEP interrupt flip flop
    if sleep_set = '1' then
      sleep <= '1'; -- Set SLEEP
    elsif sleep_clr ='1' then
      sleep <= '0'; -- Reset SLEEP
    else
      sleep <= sleep; -- No change
    end if;

    -- Implements TOK_DNE interrupt flip flop
    if tok_dne_clr ='1' then
      tok_dne <= '0'; -- Reset TOK_DNE
    elsif tok_dne_set = '1' or stat_valid = '1' then
      tok_dne <= '1'; -- Set TOK_DNE
    else
      tok_dne <= tok_dne; -- No change
    end if;

    -- Implements SOF_TOK interrupt flip flop
    if sof_tok_set = '1' then
      sof_tok <= '1'; -- Set SOF_TOK
    elsif sof_tok_clr ='1' then
      sof_tok <= '0'; -- Reset SOF_TOK
    else
      sof_tok <= sof_tok; -- No change
    end if;

    -- Implements ERROR interrupt flip flop
    if error_set = '1' then
      error <= '1'; -- Set ERROR
    elsif error_clr ='1' then
      error <= '0'; -- Reset ERROR
    else
      error <= error; -- No change
    end if;

    -- Implements USB_RST interrupt flip flop
    if usb_rst_set = '1' then
      usb_rst <= '1'; -- Set USB_RST
    elsif usb_rst_clr ='1' then
      usb_rst <= '0'; -- Reset USB_RST
    else
      usb_rst <= usb_rst; -- No change
    end if;

    -- Buffer description table register2
    if bdt_ld2 = '1' then
      bdt_rg2 <= dmadatai(7 downto 0); -- Write BDT register2
    else
      bdt_rg2 <= bdt_rg2;
    end if;

    -- Buffer description table register3
    if bdt_ld3 = '1' then
      bdt_rg3 <= dmadatai(7 downto 0); -- Write BDT register3
    else
      bdt_rg3 <= bdt_rg3;
    end if;

    -- Implements BDT valid bit
    if sie_dma_req(3) = '1' or sie_dma_req(2) = '1' then
      bdt_valid <= '0'; -- Reset BDT valid bit on bdt read of write request
    elsif bdt_ld0 = '1' AND rdyi = '1' then
      bdt_valid <= '1'; -- Set BDT valid bit when own is read
    else
      bdt_valid <= bdt_valid; -- No change
    end if;
  end if; -- reset  --vsync_rst
end if; -- clk / reset
end process elr_rst_rg;
--------------------------------------------------------------------------------
-- gate the register outputs with the configuratoin constants, so that they
-- will optimized out during synthesis if not needed.
--------------------------------------------------------------------------------
ep_ctl15 <=
            (EN_EP_CTL_8_15 and endpt15_rg(4)) &
            (EN_EP_CTL_8_15 and endpt15_rg(3)) &
            (EN_EP_CTL_8_15 and endpt15_rg(2)) &
            (EN_EP_CTL_8_15 and endpt15_rg(1)) &
            (EN_EP_CTL_8_15 and endpt15_rg(0));
ep_ctl14 <=
            (EN_EP_CTL_8_15 and endpt14_rg(4)) &
            (EN_EP_CTL_8_15 and endpt14_rg(3)) &
            (EN_EP_CTL_8_15 and endpt14_rg(2)) &
            (EN_EP_CTL_8_15 and endpt14_rg(1)) &
            (EN_EP_CTL_8_15 and endpt14_rg(0));

ep_ctl13 <=
            (EN_EP_CTL_8_15 and endpt13_rg(4)) &
            (EN_EP_CTL_8_15 and endpt13_rg(3)) &
            (EN_EP_CTL_8_15 and endpt13_rg(2)) &
            (EN_EP_CTL_8_15 and endpt13_rg(1)) &
            (EN_EP_CTL_8_15 and endpt13_rg(0));

ep_ctl12 <=
            (EN_EP_CTL_8_15 and endpt12_rg(4)) &
            (EN_EP_CTL_8_15 and endpt12_rg(3)) &
            (EN_EP_CTL_8_15 and endpt12_rg(2)) &
            (EN_EP_CTL_8_15 and endpt12_rg(1)) &
            (EN_EP_CTL_8_15 and endpt12_rg(0));

ep_ctl11 <=
            (EN_EP_CTL_8_15 and endpt11_rg(4)) &
            (EN_EP_CTL_8_15 and endpt11_rg(3)) &
            (EN_EP_CTL_8_15 and endpt11_rg(2)) &
            (EN_EP_CTL_8_15 and endpt11_rg(1)) &
            (EN_EP_CTL_8_15 and endpt11_rg(0));

ep_ctl10 <=
            (EN_EP_CTL_8_15 and endpt10_rg(4)) &
            (EN_EP_CTL_8_15 and endpt10_rg(3)) &
            (EN_EP_CTL_8_15 and endpt10_rg(2)) &
            (EN_EP_CTL_8_15 and endpt10_rg(1)) &
            (EN_EP_CTL_8_15 and endpt10_rg(0));

ep_ctl9 <=
           (EN_EP_CTL_8_15 and endpt9_rg(4)) &
           (EN_EP_CTL_8_15 and endpt9_rg(3)) &
           (EN_EP_CTL_8_15 and endpt9_rg(2)) &
           (EN_EP_CTL_8_15 and endpt9_rg(1)) &
           (EN_EP_CTL_8_15 and endpt9_rg(0));

ep_ctl8 <=
           (EN_EP_CTL_8_15 and endpt8_rg(4)) &
           (EN_EP_CTL_8_15 and endpt8_rg(3)) &
           (EN_EP_CTL_8_15 and endpt8_rg(2)) &
           (EN_EP_CTL_8_15 and endpt8_rg(1)) &
           (EN_EP_CTL_8_15 and endpt8_rg(0));

ep_ctl7 <=
           (EN_EP_CTL_4_7 and endpt7_rg(4)) &
           (EN_EP_CTL_4_7 and endpt7_rg(3)) &
           (EN_EP_CTL_4_7 and endpt7_rg(2)) &
           (EN_EP_CTL_4_7 and endpt7_rg(1)) &
           (EN_EP_CTL_4_7 and endpt7_rg(0));

ep_ctl6 <=
           (EN_EP_CTL_4_7 and endpt6_rg(4)) &
           (EN_EP_CTL_4_7 and endpt6_rg(3)) &
           (EN_EP_CTL_4_7 and endpt6_rg(2)) &
           (EN_EP_CTL_4_7 and endpt6_rg(1)) &
           (EN_EP_CTL_4_7 and endpt6_rg(0));

ep_ctl5 <=
           (EN_EP_CTL_4_7 and endpt5_rg(4)) &
           (EN_EP_CTL_4_7 and endpt5_rg(3)) &
           (EN_EP_CTL_4_7 and endpt5_rg(2)) &
           (EN_EP_CTL_4_7 and endpt5_rg(1)) &
           (EN_EP_CTL_4_7 and endpt5_rg(0));

ep_ctl4 <=
           (EN_EP_CTL_4_7 and endpt4_rg(4)) &
           (EN_EP_CTL_4_7 and endpt4_rg(3)) &
           (EN_EP_CTL_4_7 and endpt4_rg(2)) &
           (EN_EP_CTL_4_7 and endpt4_rg(1)) &
           (EN_EP_CTL_4_7 and endpt4_rg(0));

ep_ctl3 <= endpt3_rg;

ep_ctl2 <= endpt2_rg;

ep_ctl1 <= endpt1_rg;

ep_ctl0 <= endpt0_rg;

hc_token_rg <= hc_token_q and hc_en_byte;
hc_token_clr <= hc_token_clr_q and hc_en;
hc_token_req <= hc_token_req_q and hc_en;
host_wo_hub_int <= host_wo_hub_q and hc_en;
host_wo_hub <= host_wo_hub_int;
hc_retry_disable <= hc_retry_disable_q and hc_en;

-- host only i
hc_sof_thld_rg <= hc_sof_thld_q and hc_en_byte;

hc_attach  <= hc_attach_q and hc_en;    --
--------------------------------------------------------------------------------
-- DMA Controller Logic
--------------------------------------------------------------------------------

-- Stop DMA operation
stop_dma_gjr <= (not rx_valid_1 and not dma_rd_en) or
            ((byte_count_eq or tx_full_1) and dma_rd_en) ;

-- DMA request is true anytime one of the bits in the DMA command register
-- bits are set.
dma_req <= dma_wrt_bdt or dma_rd_bdt or dma_wrt_byte or dma_rd_byte;

-- DMA read byte
dma_rd_byte <=
  '1' when dma_rd_en = '1' and own = '1' and endpt_stall = '0' and
           byte_count_eq = '0' and (tx_full = '0' and tx_full_1 = '0') else '0';

-- DMA write byte
dma_wrt_byte <=
  '1' when dma_wrt_en = '1' and endpt_stall = '0' and
           byte_count_eq = '0' and rx_empty = '0' and rx_valid = '1' and
	   ((rx_valid_1 = '1' and own = '1') OR dma_valid_flush = '1')
		   else
  '0';

-- DMA actively in progress
-- This signal is used to control DMA master output signals. We use
-- dma_nstate bits and then register these for a clean control signal.
dma_active_d <= '1' when (dma_nstate = DMA_BDT0 or dma_nstate = DMA_BDT1 or
                          dma_nstate = DMA_BDT2 or dma_nstate = DMA_BDT3 or
                          dma_nstate = DMA_BYTE) else
        '0';

-- Bus Request data
bus_req_d <= '1' when (dma_nstate = DMA_GNT or dma_nstate = DMA_BDT0 or
                       dma_nstate = DMA_BDT1 or dma_nstate = DMA_BDT2 or
                       dma_nstate = DMA_BDT3 or dma_nstate = DMA_BYTE or
                       dma_pstate = DMA_BDT1 or dma_pstate = DMA_BDT3 or
                       dma_pstate = DMA_BYTE) else
             '0';

-- Bus master signals output enable data
bmoe_d <= '1' when (dma_nstate = DMA_BDT0 or dma_nstate = DMA_BDT1 or
                    dma_nstate = DMA_BDT2 or dma_nstate = DMA_BDT3 or
                    dma_nstate = DMA_BYTE or
                    dma_pstate = DMA_BDT1 or dma_pstate = DMA_BDT3 or
                    dma_pstate = DMA_BYTE) else
          '0';

-- Enable byte count decrement
byte_cnt_dec <= '0';

-- Enable byte count increment
byte_cnt_inc <= '1' when byte_cnt_inc_en = '1' and byte_count_eq = '0' else
        '0';

-- Detect DMA buffer overrun errors note the the data is not written to
-- memory, so the bufffer is not technically overrun, but rather the end of the
-- packet is dropped because there was insufficient buffer space allocated.
dma_overrun <= byte_cnt_inc_en and byte_count_eq; -- We should increment the
                                                  -- byte count, but the buffer
                                                  -- space is exhausted.

-- Enable DMA address increment
dma_addr_inc <= '1' when dma_pstate = DMA_BYTE and ninc = '0' and rdyi = '1' else
        '0';

-- DMA byte count equals saved byte count
-- This signal is active when the saved byte count equals the actual byte count
-- indicating that we have read/written all data from/to memory.
byte_count_eq <= '1' when (byte_cnt = byte_cnt_save) else '0';

-- DMA read byte data enable data
-- This signal is set when we request the BDT read for a tx data packet. It
-- will remain set until we request the BDT to be written back to memory,
-- or we read the BDT and own=0, or we have a reset.
--dma_rd_en_d <= '0' when reset = '1' or sie_dma_req(3) = '1' or
dma_rd_en_d <= '0' when reset = '1' or
                 (dma_req_clr = '1' and dma_wrt_bdt = '1') or
                 (bdt_ld1 = '1' and (bdt_rg0(7) = '0' or
                 (bdt_rg0(7) = '1' and endpt_stall = '1'))) else
               txd_token when sie_dma_req(2) = '1' else -- set on a txd bdt read
               dma_rd_en;

-- DMA write byte data enable data
-- This signal is set when we request the BDT read for a rx data packet. It
-- will remain set until the BDT is written back to memory, or
-- we read the BDT and own=0, or we have a reset.
dma_wrt_en_d <= '0' when reset = '1' or
            (dma_req_clr = '1' and dma_wrt_bdt = '1') or
            (bdt_ld1 = '1' and (bdt_rg0(7) = '0' or
            (bdt_rg0(7) = '1' and endpt_stall = '1'))) else
                '1' when txd_token = '0' and sie_dma_req(2) = '1' else
            dma_wrt_en;

-- DMA read BDT (4 bytes) data
dma_rd_bdt_d <= '0' when reset = '1' or dma_req_clr = '1' else
                '1' when sie_dma_req(2) = '1' else
            dma_rd_bdt;

-- DMA write BDT (4 bytes) data
dma_wrt_bdt_d <= '0' when reset = '1' or dma_req_clr = '1' else
                 '1' when sie_dma_req(3) = '1' AND NOT keep = '1' else
             dma_wrt_bdt;

-- PID value register is captured on the assertion of dma_bdt_wrt
bdt_wrt_pid_d <= bdt_wrt_pid when sie_dma_req(3) = '1' else
                 bdt_wrt_pid_f;

--------------------------------------------------------------------------------
-- Implement DMA Engine Registers
--------------------------------------------------------------------------------
dma_regs: process (clk)
begin
if clk'event and clk = '1' then
  -- Bus Request
  -- This signal is used to control DMA bus request signal. We use
  -- dma_nstate bits and then register these for a clean control signal.
  bus_req <= bus_req_d;

  -- DMA actively in progress
  -- This signal is used to control DMA master output signals. We use
  -- dma_nstate bits and then register these for a clean control signal.
  dma_active <= dma_active_d;

  -- DMA read byte data enable
  dma_rd_en <= dma_rd_en_d;

  -- DMA write byte data enable
  dma_wrt_en <= dma_wrt_en_d;

  -- DMA read BDT (4 bytes)
  dma_rd_bdt <= dma_rd_bdt_d;

  -- DMA write BDT (4 bytes)
  dma_wrt_bdt <= dma_wrt_bdt_d;

  -- PID value register is captured on the assertion of dma_bdt_wrt
  bdt_wrt_pid_f <= bdt_wrt_pid_d;

  -- BDT address bit3
  if dma_rd_bdt = '1' then
    bdt_addr3 <= txd_token;
  else
    bdt_addr3 <= bdt_addr3;
  end if;

  -- BDT address bit2
  if dma_rd_bdt = '1' then
    bdt_addr2 <= odd_bdt;
  else
    bdt_addr2 <= bdt_addr2;
  end if;

  -- BDT address bit1
  if (dma_nstate = DMA_BDT2) or (dma_nstate = DMA_BDT3) then
    bdt_addr1 <= '1';
  else
    bdt_addr1 <= '0';
  end if;

  -- BDT address bit0
  if (dma_nstate = DMA_BDT1) or (dma_nstate = DMA_BDT3) then
    bdt_addr0 <= '1';
  else
    bdt_addr0 <= '0';
  end if;
  -- if transitioning into the BDT0 state during a BDT write cycle
  if (dma_wrt_bdt = '1' and
      dma_nstate = DMA_BDT0 and
      dma_pstate /= DMA_BDT0) then
    dma_wrt_bdt_b0 <= '1';
  else
    dma_wrt_bdt_b0 <= '0';
  end if;
end if; -- clk / reset
end process dma_regs;

--vasync_rst dma_rst_regs: process (clk,reset)
dma_rst_regs: process (clk) --vsync_rst
begin
--vasync_rst  if reset = '1' then
if clk'event and clk = '1' then --vsync_rst
  if reset = '1' then --vsync_rst
    dma_pstate <= DMA_IDLE; -- Goto to reset state
    dma_pstate_eq_dma_byte <= '0';
    dma_valid_flush <= '0';  -- flush any valid data remaining in the Rx FIFO
    endpt0_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt1_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt2_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt3_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt4_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt5_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt6_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt7_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt8_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt9_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt10_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt11_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt12_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt13_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt14_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt15_txd_odd <= '0'; -- Code reset like this for Synopsys
    endpt0_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt1_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt2_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt3_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt4_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt5_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt6_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt7_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt8_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt9_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt10_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt11_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt12_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt13_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt14_rxd_odd <= '0'; -- Code reset like this for Synopsys
    endpt15_rxd_odd <= '0'; -- Code reset like this for Synopsys

  else --vsync_rst
--vasync_rst   elsif clk'event and clk = '1' then

    -- Register data DMA present state bits
      dma_pstate <= dma_nstate; -- Else update pstate

      if dma_nstate = DMA_BYTE then
        dma_pstate_eq_dma_byte <= '1';
      else
        dma_pstate_eq_dma_byte <= '0';
      end if;

    -- Implements the Rx FIFO flush bit which is used when the BDT is not going
    -- to written to force a DMA cycle if there is valid data remaining in the
    -- RX FIFO when the BDT would have otherwise been written.
    IF sie_dma_req(3) = '1' AND keep = '1' then   -- On BDT write request with keep
      dma_valid_flush <= rx_valid OR NOT rx_empty;-- flush any valid data remaining
    elsif rx_valid = '0' then               -- in the Rx FIFO
      dma_valid_flush <= '0';       -- no more data to flush.
    end if;


    -- Implement endpoint odd address enable bits
    if odd_rst = '1' then
      endpt0_txd_odd <= '0'; -- Reset endpoint0 in odd
    elsif current_endpt = "0000" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt0_txd_odd <= not endpt0_txd_odd; -- Toggle endpoint0 in odd
    else
      endpt0_txd_odd <= endpt0_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt1_txd_odd <= '0'; -- Reset endpoint1 in odd
    elsif current_endpt = "0001" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt1_txd_odd <= not endpt1_txd_odd; -- Toggle endpoint1 in odd
    else
      endpt1_txd_odd <= endpt1_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt2_txd_odd <= '0'; -- Reset endpoint2 in odd
    elsif current_endpt = "0010" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt2_txd_odd <= not endpt2_txd_odd; -- Toggle endpoint2 in odd
    else
      endpt2_txd_odd <= endpt2_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt3_txd_odd <= '0'; -- Reset endpoint3 in odd
    elsif current_endpt = "0011" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt3_txd_odd <= not endpt3_txd_odd; -- Toggle endpoint3 in odd
    else
      endpt3_txd_odd <= endpt3_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt4_txd_odd <= '0'; -- Reset endpoint4 in odd
    elsif current_endpt = "0100" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt4_txd_odd <= not endpt4_txd_odd; -- Toggle endpoint4 in odd
    else
      endpt4_txd_odd <= endpt4_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt5_txd_odd <= '0'; -- Reset endpoint5 in odd
    elsif current_endpt = "0101" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt5_txd_odd <= not endpt5_txd_odd; -- Toggle endpoint5 in odd
    else
      endpt5_txd_odd <= endpt5_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt6_txd_odd <= '0'; -- Reset endpoint6 in odd
    elsif current_endpt = "0110" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt6_txd_odd <= not endpt6_txd_odd; -- Toggle endpoint6 in odd
    else
      endpt6_txd_odd <= endpt6_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt7_txd_odd <= '0'; -- Reset endpoint7 in odd
    elsif current_endpt = "0111" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt7_txd_odd <= not endpt7_txd_odd; -- Toggle endpoint7 in odd
    else
      endpt7_txd_odd <= endpt7_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt8_txd_odd <= '0'; -- Reset endpoint8 in odd
    elsif current_endpt = "1000" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt8_txd_odd <= not endpt8_txd_odd; -- Toggle endpoint8 in odd
    else
      endpt8_txd_odd <= endpt8_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt9_txd_odd <= '0'; -- Reset endpoint9 in odd
    elsif current_endpt = "1001" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt9_txd_odd <= not endpt9_txd_odd; -- Toggle endpoint9 in odd
    else
      endpt9_txd_odd <= endpt9_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt10_txd_odd <= '0'; -- Reset endpoint10 in odd
    elsif current_endpt = "1010" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt10_txd_odd <= not endpt10_txd_odd; -- Toggle endpoint10 in odd
    else
      endpt10_txd_odd <= endpt10_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt11_txd_odd <= '0'; -- Reset endpoint11 in odd
    elsif current_endpt = "1011" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt11_txd_odd <= not endpt11_txd_odd; -- Toggle endpoint11 in odd
    else
      endpt11_txd_odd <= endpt11_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt12_txd_odd <= '0'; -- Reset endpoint12 in odd
    elsif current_endpt = "1100" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt12_txd_odd <= not endpt12_txd_odd; -- Toggle endpoint12 in odd
    else
      endpt12_txd_odd <= endpt12_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt13_txd_odd <= '0'; -- Reset endpoint13 in odd
    elsif current_endpt = "1101" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt13_txd_odd <= not endpt13_txd_odd; -- Toggle endpoint13 in odd
    else
      endpt13_txd_odd <= endpt13_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt14_txd_odd <= '0'; -- Reset endpoint14 in odd
    elsif current_endpt = "1110" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt14_txd_odd <= not endpt14_txd_odd; -- Toggle endpoint14 in odd
    else
      endpt14_txd_odd <= endpt14_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt15_txd_odd <= '0'; -- Reset endpoint15 in odd
    elsif current_endpt = "1111" and tx_datpkt_proc = '1' and tok_dne_set = '1' then
      endpt15_txd_odd <= not endpt15_txd_odd; -- Toggle endpoint15 in odd
    else
      endpt15_txd_odd <= endpt15_txd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt0_rxd_odd <= '0'; -- Reset endpoint0 out odd
    elsif current_endpt = "0000" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt0_rxd_odd <= not endpt0_rxd_odd; -- Toggle endpoint0 out odd
    else
      endpt0_rxd_odd <= endpt0_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt1_rxd_odd <= '0'; -- Reset endpoint1 out odd
    elsif current_endpt = "0001" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt1_rxd_odd <= not endpt1_rxd_odd; -- Toggle endpoint1 out odd
    else
      endpt1_rxd_odd <= endpt1_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt2_rxd_odd <= '0'; -- Reset endpoint2 out odd
    elsif current_endpt = "0010" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt2_rxd_odd <= not endpt2_rxd_odd; -- Toggle endpoint2 out odd
    else
      endpt2_rxd_odd <= endpt2_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt3_rxd_odd <= '0'; -- Reset endpoint3 out odd
    elsif current_endpt = "0011" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt3_rxd_odd <= not endpt3_rxd_odd; -- Toggle endpoint3 out odd
    else
      endpt3_rxd_odd <= endpt3_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt4_rxd_odd <= '0'; -- Reset endpoint4 out odd
    elsif current_endpt = "0100" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt4_rxd_odd <= not endpt4_rxd_odd; -- Toggle endpoint4 out odd
    else
      endpt4_rxd_odd <= endpt4_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt5_rxd_odd <= '0'; -- Reset endpoint5 out odd
    elsif current_endpt = "0101" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt5_rxd_odd <= not endpt5_rxd_odd; -- Toggle endpoint5 out odd
    else
      endpt5_rxd_odd <= endpt5_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt6_rxd_odd <= '0'; -- Reset endpoint6 out odd
    elsif current_endpt = "0110" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt6_rxd_odd <= not endpt6_rxd_odd; -- Toggle endpoint6 out odd
    else
      endpt6_rxd_odd <= endpt6_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt7_rxd_odd <= '0'; -- Reset endpoint7 out odd
    elsif current_endpt = "0111" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt7_rxd_odd <= not endpt7_rxd_odd; -- Toggle endpoint7 out odd
    else
      endpt7_rxd_odd <= endpt7_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt8_rxd_odd <= '0'; -- Reset endpoint8 out odd
    elsif current_endpt = "1000" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt8_rxd_odd <= not endpt8_rxd_odd; -- Toggle endpoint8 out odd
    else
      endpt8_rxd_odd <= endpt8_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt9_rxd_odd <= '0'; -- Reset endpoint9 out odd
    elsif current_endpt = "1001" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt9_rxd_odd <= not endpt9_rxd_odd; -- Toggle endpoint9 out odd
    else
      endpt9_rxd_odd <= endpt9_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt10_rxd_odd <= '0'; -- Reset endpoint10 out odd
    elsif current_endpt = "1010" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt10_rxd_odd <= not endpt10_rxd_odd; -- Toggle endpoint10 out odd
    else
      endpt10_rxd_odd <= endpt10_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt11_rxd_odd <= '0'; -- Reset endpoint11 out odd
    elsif current_endpt = "1011" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt11_rxd_odd <= not endpt11_rxd_odd; -- Toggle endpoint11 out odd
    else
      endpt11_rxd_odd <= endpt11_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt12_rxd_odd <= '0'; -- Reset endpoint12 out odd
    elsif current_endpt = "1100" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt12_rxd_odd <= not endpt12_rxd_odd; -- Toggle endpoint12 out odd
    else
      endpt12_rxd_odd <= endpt12_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt13_rxd_odd <= '0'; -- Reset endpoint13 out odd
    elsif current_endpt = "1101" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt13_rxd_odd <= not endpt13_rxd_odd; -- Toggle endpoint13 out odd
    else
      endpt13_rxd_odd <= endpt13_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt14_rxd_odd <= '0'; -- Reset endpoint14 out odd
    elsif current_endpt = "1110" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt14_rxd_odd <= not endpt14_rxd_odd; -- Toggle endpoint14 out odd
    else
      endpt14_rxd_odd <= endpt14_rxd_odd; -- No change
    end if;

    if odd_rst = '1' then
      endpt15_rxd_odd <= '0'; -- Reset endpoint15 out odd
    elsif current_endpt = "1111" and out_token_proc = '1' and tok_dne_set = '1' then
      endpt15_rxd_odd <= not endpt15_rxd_odd; -- Toggle endpoint15 out odd
    else
      endpt15_rxd_odd <= endpt15_rxd_odd; -- No change
    end if;
  end if; -- reset  --vsync_rst
end if; -- clk / reset

end process dma_rst_regs;


odd_bdt <= endpt_txd_odd when txd_token = '1' else
           endpt_rxd_odd;

with current_endpt select
  endpt_txd_odd <=
    endpt0_txd_odd  when "0000",
    endpt1_txd_odd  when "0001",
    endpt2_txd_odd  when "0010",
    endpt3_txd_odd  when "0011",
    endpt4_txd_odd  when "0100",
    endpt5_txd_odd  when "0101",
    endpt6_txd_odd  when "0110",
    endpt7_txd_odd  when "0111",
    endpt8_txd_odd  when "1000",
    endpt9_txd_odd  when "1001",
    endpt10_txd_odd when "1010",
    endpt11_txd_odd when "1011",
    endpt12_txd_odd when "1100",
    endpt13_txd_odd when "1101",
    endpt14_txd_odd when "1110",
    endpt15_txd_odd when "1111",
    'X' when others;

with current_endpt select
  endpt_rxd_odd <=
    endpt0_rxd_odd  when "0000",
    endpt1_rxd_odd  when "0001",
    endpt2_rxd_odd  when "0010",
    endpt3_rxd_odd  when "0011",
    endpt4_rxd_odd  when "0100",
    endpt5_rxd_odd  when "0101",
    endpt6_rxd_odd  when "0110",
    endpt7_rxd_odd  when "0111",
    endpt8_rxd_odd  when "1000",
    endpt9_rxd_odd  when "1001",
    endpt10_rxd_odd when "1010",
    endpt11_rxd_odd when "1011",
    endpt12_rxd_odd when "1100",
    endpt13_rxd_odd when "1101",
    endpt14_rxd_odd when "1110",
    endpt15_rxd_odd when "1111",
    'X' when others;

--  -- BDT address bit1
--  bdt_addr1 <= '1' when (dma_nstate = DMA_BDT2) or (dma_nstate = DMA_BDT3) else
--               '0';
--
--  -- BDT address bit0
--  bdt_addr0 <= '1' when (dma_nstate = DMA_BDT1) or (dma_nstate = DMA_BDT3) else
--               '0';

-----------------------------------------------------------------------------
--
--     Process: dma_nsl       -- DMA state machine next state logic
--
--  Parameters: dma_pstate    -- DMA state machine present state bits
--              dma_early_req -- DMA early req
--              dma_req       -- DMA request
--              dma_rd_byte   -- DMA read byte
--              dma_wrt_byte  -- DMA write byte
--              dma_rd_bdt    -- DMA read BDT (4 bytes)
--              dma_wrt_bdt   -- DMA write BDT (4 bytes)
--              rdyi          -- Ready Input
--              bus_gnt       -- Bus Grant
--              rx_empty      -- Rx FIFO empty
--              stop_dma_gjr  -- Stop DMA
--
-- Description: This process implements next state logic for the DMA state
--  machine.
--
-- State Diagram: TBD
--
-----------------------------------------------------------------------------

dma_nsl: process (dma_pstate, dma_early_req, dma_req, dma_rd_byte,
                  dma_wrt_byte, dma_rd_bdt, dma_wrt_bdt, rdyi, bus_gnt,
                  stop_dma_gjr, dma_rd_en, dma_wrt_en, rx_valid, rx_valid_1)

begin

  -- Default outputs
  dma_req_clr <= '0'; -- DMA request clear enable
  byte_cnt_inc_en <= '0'; -- Enable byte count increment enable
  load_en <= '1'; -- Always load, unless wait states are inserted

  case dma_pstate is

    when DMA_IDLE => -- If present state is DMA idle
      -- DMA request or early DMA request and we do not have bus?
      if (dma_req = '1' or dma_early_req = '1') and bus_gnt = '0' then
        dma_nstate <= DMA_GNT; -- Goto DMA grant state
      else
        dma_nstate <= DMA_IDLE; -- Stay here
      end if;

    when DMA_GNT => -- If present state is DMA grant
      -- Bus grant delayed 1 clock active?
      if bus_gnt = '1' and dma_req = '1' then

        -- Read or write DMA BDT bytes
        if dma_rd_bdt = '1' or (dma_wrt_bdt = '1' and
        (dma_rd_en = '1' or (dma_wrt_en = '1' and rx_valid = '0'))) then
          dma_nstate <= DMA_BDT0; -- Goto DMA byte0 state
        else -- DMA 1 bytes
          dma_nstate <= DMA_BYTE; -- Else goto DMA byte state
          byte_cnt_inc_en <= '1'; -- Enable byte count increment enable
        end if;

      elsif dma_early_req = '1' or dma_req = '1' then
        dma_nstate <= DMA_GNT; -- Stay here as long as dma early request active

      else
        dma_nstate <= DMA_IDLE; -- No dma request or no grant return to idle

      end if;

    when DMA_BDT0 => -- If present state is DMA byte0
      if rdyi = '1' then -- If ready active
        dma_nstate <= DMA_BDT1; -- Goto DMA byte1 state
      else
        dma_nstate <= DMA_BDT0; -- Else stay here
      end if;

    when DMA_BDT1 => -- If present state is DMA byte1
      if rdyi = '1' then -- If ready active
        -- If we are reading BDT or 4 byte BDT is enabled
        if dma_rd_bdt = '1' or EN_BDT_4_BYTE_WRITE = '1' then
          dma_nstate <= DMA_BDT2; -- Goto DMA byte2 state
        else -- We are writing BDT
          dma_req_clr <= '1'; -- DMA request clear enable
          dma_nstate <= DMA_IDLE; -- Goto DMA idle state
        end if;
      else
        dma_nstate <= DMA_BDT1; -- Else stay here
      end if;

    when DMA_BDT2 => -- If present state is DMA byte2
      if rdyi = '1' then -- If ready active
        dma_nstate <= DMA_BDT3; -- Goto DMA byte3 state
      else
        dma_nstate <= DMA_BDT2; -- Else stay here
      end if;

    when DMA_BDT3 => -- If present state is DMA byte3
      if rdyi = '1' then -- If ready active
        dma_req_clr <= '1'; -- DMA request clear enable
        if dma_rd_byte = '1' then -- If DMA read enable active
          dma_nstate <= DMA_BYTE; -- Goto DMA byte state
          byte_cnt_inc_en <= '1'; -- Enable byte count increment enable
        else
          dma_nstate <= DMA_IDLE; -- Goto DMA idle state
        end if;
      else
        dma_nstate <= DMA_BDT3; -- Else stay here
      end if;

    when DMA_BYTE => -- If present state is DMA byte
      if rdyi = '1' then -- If ready active
        if dma_wrt_bdt = '1' and rx_valid = '1' and rx_valid_1 = '0' then
          dma_nstate <= DMA_BDT0; -- Goto DMA BDT0 state
        elsif stop_dma_gjr = '1' then -- If ready active
          dma_nstate <= DMA_IDLE; -- Goto DMA idle state
        else
          dma_nstate <= DMA_BYTE; -- Else stay here
          byte_cnt_inc_en <= '1'; -- Enable byte count increment enable
        end if;
      else
        dma_nstate <= DMA_BYTE; -- Else stay here
        load_en <= '0'; -- Wait state hold control signals
      end if;

    when OTHERS => -- Default
      dma_nstate <= DMA_IDLE; -- Goto to idle

  end case;

end process dma_nsl;

end synth;
