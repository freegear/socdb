--*******************************************************************--
-- Copyright (c) 2001-2004  Evatronix SA                             --
--*******************************************************************--
-- Please review the terms of the license agreement before using     --
-- this file. If you are not an authorized user, please destroy this --
-- source code file and notify Evatronix SA immediately that you     --
-- inadvertently received an unauthorized copy.                      --
--*******************************************************************--

-----------------------------------------------------------------------
-- Project name         : MAC-1G
-- Project description  : Gigabit Ethernet Media Access Controller
--
-- File name            : utility_mac_1g.vhd
-- File contents        : Package UTILITY_MAC_1G
-- Purpose              : Constants for MAC_1G
--
-- Destination library  : MAC_1G_LIB 
-- Dependencies         : IEEE.STD_LOGIC_1164
--
-- Design Engineer      : T.K.
-- Quality Engineer     : M.B.
-- Version              : 2.02E02
-- Last modification    : 2004-08-16
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:          
-- 2.02.00    :
-- 2003.12.04 : L.C. - MIISMBT FSM definition added
--              L.C. - FC register definitons added (CSR16-CSR20)
--              L.C. - FC FSMs definitions added
-- 2004.01.10 : B.W. - SC register definitons added (CSR21-CSR22)
--              B.W. - Statistical counters internal addresses added
--*******************************************************************--

library IEEE;
  use IEEE.STD_LOGIC_1164.all;

  --*****************************************************************--
  package UTILITY_MAC_1G is
  
    -------------------------------------------------------------------
    -- 802.3 parameters
    -------------------------------------------------------------------
    -- interframe space 1 interval = 60 bit times
    constant IFS1_TIME   : STD_LOGIC_VECTOR(3 downto 0)
                             := "1110";
    -- interframe space 2 interval = 36 bit times
    constant IFS2_TIME   : STD_LOGIC_VECTOR(3 downto 0)
                             := "1000";
    -- slot time for fast ethernet mode =  512 bit times
    constant SLOT_TIME   : STD_LOGIC_VECTOR(8 downto 0)
                             := "001111111";
    -- slot time for gigabit ethernet mode =  4096 bit times
    constant SLOT_G_TIME : STD_LOGIC_VECTOR(8 downto 0)
                             := "111111111";
    -- maximum number of retransmission attempts = 16
    constant ATT_MAX     : STD_LOGIC_VECTOR(4 downto 0)
                             := "10000";
    -- proper crc remainder value = 0xc704dd7b
    constant CRCVAL      : STD_LOGIC_VECTOR(31 downto 0)
                             := "11000111000001001101110101111011";
    -- minimum frame size = 64
    constant MIN_FRAME   : STD_LOGIC_VECTOR(6 downto 0)
                             := "1000000";
    -- maximum ethernet frame length field value = 1500
    constant MAX_SIZE    : STD_LOGIC_VECTOR(15 downto 0)
                             := "0000010111011100";
    -- maximum frame size
    constant MAX_FRAME   : STD_LOGIC_VECTOR(13 downto 0)
                             := "00010111101111"; -- 1519
  
    --_________________________________________________________________
    -- Control and Status Register summary
    --_________________________________________________________________
    -- Register | ID  |      RV       | Description
    --_________________________________________________________________
    -- CSR0     | 00h | fe000000h     | Bus mode
    -- CSR1     | 08h | ffffffffh     | Transmit pool demand
    -- CSR2     | 10h | ffffffffh     | Teceive pool demand
    -- CSR3     | 18h | ffffffffh     | Receive list base address
    -- CSR4     | 20h | ffffffffh     | Rransmit list base address
    -- CSR5     | 28h | f0000000h     | Status
    -- CSR6     | 30h | 32000040h     | Operation mode
    -- CSR7     | 38h | f3fe0000h     | Interrupt enable
    -- CSR8     | 40h | e0000000h     | Missed frames and overflow cnt
    -- CSR9     | 48h | fff483ffh     | Serial ROM 
    -- CSR10    | 50h | 000000000     | MII Management 
    -- CSR11    | 58h | fffe0000h     | Timer and interrupt mitigation
    -- CSR16    | 80h | 00000000h     | FC : mac address lower bits
    -- CSR17    | 88h | 00000000h     | FC : mac address higher bits
    -- CSR18    | 90h | 00000000h     | FC : time & treshold settings
    -- CSR19    | 98h | 00000000h     | FC : fifo treshold settings
    -- CSR20    | A0h | 00000000h     | FC : status & control bits
    -- CSR21    | A8h | 00000000h     | SC: Count Access
    -- CSR22    | B0h | 00000000h     | SC: Count Data
    --_________________________________________________________________
      
    -------------------------------------------------------------------
    -- Special Function Register locations and reset values
    -------------------------------------------------------------------
    
    -- CSR0     : 00h : fe000000h     : Bus mode
    constant CSR0_ID  : STD_LOGIC_VECTOR(5 downto 0) := "000000";
    -- CSR0 reset value
    constant CSR0_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111110000000000000000000000000";
    
    -- CSR1     : 08h : ffffffffh     : Transmit pool demand
    constant CSR1_ID  : STD_LOGIC_VECTOR(5 downto 0) := "000010";
    -- CSR1 reset value
    constant CSR1_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111111111111111111111";
    
    -- CSR2     : 10h : ffffffffh     : Receive pool demand
    constant CSR2_ID  : STD_LOGIC_VECTOR(5 downto 0) := "000100";
    -- CSR2 reset value
    constant CSR2_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111111111111111111111";
    
    -- CSR3     : 18h : ffffffffh     : Receive list base address
    constant CSR3_ID  : STD_LOGIC_VECTOR(5 downto 0) := "000110";
    -- CSR3 reset value
    constant CSR3_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111111111111111111111";
    
    -- CSR4     : 20h : ffffffffh     : Transmit list base address
    constant CSR4_ID  : STD_LOGIC_VECTOR(5 downto 0) := "001000";
    -- CSR4 reset value
    constant CSR4_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111111111111111111111";
    
    -- CSR5     : 28h : f0000000h     : Status
    constant CSR5_ID  : STD_LOGIC_VECTOR(5 downto 0) := "001010";
    -- CSR5 reset value
    constant CSR5_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11110000000000000000000000000000";
    
    -- CSR6     : 30h : 32000040h     : Operation mode
    constant CSR6_ID  : STD_LOGIC_VECTOR(5 downto 0) := "001100";
    -- CSR6 reset value
    constant CSR6_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00110010000000000000000001000000";
    
    -- CSR7     : 38h : f3fe0000h     : Interrupt enable
    constant CSR7_ID  : STD_LOGIC_VECTOR(5 downto 0) := "001110";
    -- CSR7 reset value
    constant CSR7_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11110011111111100000000000000000";
    
    -- CSR8     : 40h : e0000000h     : Missed frames and overflow cnt
    constant CSR8_ID  : STD_LOGIC_VECTOR(5 downto 0) := "010000";
    -- CSR8 reset value
    constant CSR8_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11100000000000000000000000000000";
    
    -- CSR9     : 48h : fff483ffh     : Serial ROM
    constant CSR9_ID  : STD_LOGIC_VECTOR(5 downto 0) := "010010";
    -- CSR9 reset value
    constant CSR9_RV  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111101001000001111111111";
    
    -- CSR10    : 50h : 00000000h     : MII Management 
    constant CSR10_ID : STD_LOGIC_VECTOR(5 downto 0) := "010100";
    -- CSR10 reset value
    constant CSR10_RV : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    
    -- CSR11    : 58h : fffe0000h     : Timer and interrupt mitigation
    constant CSR11_ID : STD_LOGIC_VECTOR(5 downto 0) := "010110";
    -- CSR11 reset value
    constant CSR11_RV : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111100000000000000000";
    -- CSR16    : 00h : 00000000h     : FC : mac address lower bits
    constant CSR16_ID : STD_LOGIC_VECTOR(5 downto 0) := "100000";
    -- CSR16 reset value
    constant CSR16_RV : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    
    -- CSR17    : 80h : 00000000h     : FC : mac address higher bits
    constant CSR17_ID : STD_LOGIC_VECTOR(5 downto 0) := "100010";
    -- CSR17 reset value
    constant CSR17_RV : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    
    -- CSR18    : 88h : 00000000h     : FC : time & treshold settings
    constant CSR18_ID : STD_LOGIC_VECTOR(5 downto 0) := "100100";
    -- CSR18 reset value
    constant CSR18_RV : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    
    -- CSR19    : 90h : 00000000h     : FC : fifo treshold settings
    constant CSR19_ID : STD_LOGIC_VECTOR(5 downto 0) := "100110";
    -- CSR19 reset value
    constant CSR19_RV : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    
    -- CSR20    : 98h : 00000000h     : FC : status & control bits
    constant CSR20_ID : STD_LOGIC_VECTOR(5 downto 0) := "101000";
    -- CSR20 reset value
    constant CSR20_RV : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00110000000000000000000000000000";
    
    -- CSR21    : A8h : 00000000h     : SC mode settings
    constant CSR21_ID : STD_LOGIC_VECTOR(5 downto 0) := "101010";
    -- CSR21 reset value
    constant CSR21_RV : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000001000001100000000";
    
    -- CSR22    : B0h : 00000000h     : SC read value
    constant CSR22_ID : STD_LOGIC_VECTOR(5 downto 0) := "101100";
    -- CSR22 reset value
    constant CSR22_RV : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    
    -- TDES0
    constant TDES0_RV : STD_LOGIC_VECTOR(31 downto 0)
                      := "00000000000000000000000000000000";
    
    -- SET0
    constant SET0_RV : STD_LOGIC_VECTOR(31 downto 0)
                      := "00000000000000000000000000000000";
    
    -- RDES0
    constant RDES0_RV : STD_LOGIC_VECTOR(31 downto 0)
                      := "00000000000000000000000000000000";
    
    -------------------------------------------------------------------
    -- Internal interface parameters
    -------------------------------------------------------------------
    -- CSR interface address width
    constant CSRDEPTH      : INTEGER := 8;
    -- Filtering RAM address width
    constant ADDRDEPTH     : INTEGER := 6;
    -- Filtering RAM data width
    constant ADDRWIDTH     : INTEGER := 16;
    -- Maximum FIFO depth
    constant FIFODEPTH_MAX : INTEGER := 15;
    -- Maximum Data interface address width
    constant DATADEPTH_MAX : INTEGER := 32;
    -- Maximum Data interface width
    constant DATAWIDTH_MAX : INTEGER := 32;
    -- MII width
    constant MIIWIDTH      : INTEGER := 8;
    
    
    -------------------------------------------------------------------
    -- Filtering modes
    -------------------------------------------------------------------
    -- Perfect filering mode
    constant FT_PERFECT : STD_LOGIC_VECTOR(1 downto 0) := "00";
    -- Hash filering mode
    constant FT_HASH    : STD_LOGIC_VECTOR(1 downto 0) := "01";
    -- Inverse filering mode
    constant FT_INVERSE : STD_LOGIC_VECTOR(1 downto 0) := "10";
    -- Hash only filering mode
    constant FT_HONLY   : STD_LOGIC_VECTOR(1 downto 0) := "11";
    
    -------------------------------------------------------------------
    -- Phisical address position in setup frame
    -------------------------------------------------------------------
    constant PERF1_ADDR  : STD_LOGIC_VECTOR(5 downto 0) := "100111";
    
    -------------------------------------------------------------------
    -- Ethernet frame fields
    -------------------------------------------------------------------
    -- jam field pattern
    constant JAM_PATTERN : STD_LOGIC_VECTOR(63 downto 0)
 := "1010101010101010101010101010101010101010101010101010101010101010";
    -- preamble field pattern
    constant PRE_PATTERN : STD_LOGIC_VECTOR(63 downto 0)
 := "0101010101010101010101010101010101010101010101010101010101010101";
    -- start of frame delimiter pattern
    constant SFD_PATTERN : STD_LOGIC_VECTOR(63 downto 0)
 := "1101010111010101110101011101010111010101110101011101010111010101";
    -- padding field pattern
    constant PAD_PATTERN : STD_LOGIC_VECTOR(63 downto 0)
 := "0000000000000000000000000000000000000000000000000000000000000000";
    -- carrier extension pattern
    constant EXT_PATTERN : STD_LOGIC_VECTOR(63 downto 0)
 := "0000111100001111000011110000111100001111000011110000111100001111";
    
    -------------------------------------------------------------------
    -- Receive statistical counters internal addresses
    -------------------------------------------------------------------
    -- Number of successfully received frames
    constant RxFrmOK       : STD_LOGIC_VECTOR(5 downto 0)
                           :="000000";
    -- Number of successfully received bytes
    constant RxOctOK       : STD_LOGIC_VECTOR(5 downto 0)
                           :="000001";
    -- Number of successfully received unicast frames
    constant RxUniOK       : STD_LOGIC_VECTOR(5 downto 0)
                           :="000010";
    -- Number of successfully received multicast frames
    constant RxMultiOK     : STD_LOGIC_VECTOR(5 downto 0)
                           :="000011";
    -- Number of successfully received broadcast frames
    constant RxBroadOK     : STD_LOGIC_VECTOR(5 downto 0)
                           :="000100";
    -- Number of received 'too long' frames
    constant RxTooLong     : STD_LOGIC_VECTOR(5 downto 0)
                           :="000101";
    -- Number of successfully received frames of length : 1024 - 1518
    constant Rx1024to1518  : STD_LOGIC_VECTOR(5 downto 0)
                           :="000110";
    -- Number of successfully received frames of length : 512 - 1023
    constant Rx512to1023   : STD_LOGIC_VECTOR(5 downto 0)
                           :="000111";
    -- Number of successfully received frames of length : 256 - 511
    constant Rx256to511    : STD_LOGIC_VECTOR(5 downto 0)
                           :="001000";
    -- Number of successfully received frames of length : 128 - 255
    constant Rx128to255    : STD_LOGIC_VECTOR(5 downto 0)
                           :="001001";
    -- Number of successfully received frames of length : 65 - 127
    constant Rx65to127     : STD_LOGIC_VECTOR(5 downto 0)
                           :="001010";
    -- Number of successfully received frames of length : 64
    constant Rx64          : STD_LOGIC_VECTOR(5 downto 0)
                           :="001011";
    -- Number of received frames of length :              <= 63
    constant Rx63orLess    : STD_LOGIC_VECTOR(5 downto 0)
                           :="001100";
    -- Number of successfully received 'pause' frames
    constant RxPause       : STD_LOGIC_VECTOR(5 downto 0)
                           :="001101";
    -- Number of received frames with alignment error
    constant RxAlignErr    : STD_LOGIC_VECTOR(5 downto 0)
                           :="001110";
    -- Number of received frames with FCS error
    constant RxFCSErr      : STD_LOGIC_VECTOR(5 downto 0)
                           :="001111";
     
    -------------------------------------------------------------------
    -- Transmit statistical counters internal addresses
    -------------------------------------------------------------------
    -- Number of successfully transmitted frames
    constant TxFrmOK       : STD_LOGIC_VECTOR(5 downto 0)
                           :="100000";
    -- Number of successfully transmitted bytes
    constant TxOctOK       : STD_LOGIC_VECTOR(5 downto 0)
                           :="100001";
    -- Number of successfully transmitted unicast frames
    constant TxUniOK       : STD_LOGIC_VECTOR(5 downto 0)
                           :="100010";
    -- Number of successfully transmitted multicast frames
    constant TxMultiOK     : STD_LOGIC_VECTOR(5 downto 0)
                           :="100011";
    -- Number of successfully transmitted broadcast frames
    constant TxBroadOK     : STD_LOGIC_VECTOR(5 downto 0)
                           :="100100";
    -- Number of successfully transmitted frames after 0 collision
    constant Coll0         : STD_LOGIC_VECTOR(5 downto 0)
                           :="100101";
    -- Number of successfully transmitted frames after 1 collision
    constant Coll1         : STD_LOGIC_VECTOR(5 downto 0)
                           :="100110";
    -- Number of successfully transmitted frames after 2 collisions
    constant Coll2         : STD_LOGIC_VECTOR(5 downto 0)
                           :="100111";
    -- Number of successfully transmitted frames after 3 collisions
    constant Coll3         : STD_LOGIC_VECTOR(5 downto 0)
                           :="101000";
    -- Number of successfully transmitted frames after 4 collisions
    constant Coll4         : STD_LOGIC_VECTOR(5 downto 0)
                           :="101001";
    -- Number of successfully transmitted frames after 5 collisions
    constant Coll5         : STD_LOGIC_VECTOR(5 downto 0)
                           :="101010";
    -- Number of successfully transmitted frames after 6 collisions
    constant Coll6         : STD_LOGIC_VECTOR(5 downto 0)
                           :="101011";
    -- Number of successfully transmitted frames after 7 collisions
    constant Coll7         : STD_LOGIC_VECTOR(5 downto 0)
                           :="101100";
    -- Number of successfully transmitted frames after 8 collisions
    constant Coll8         : STD_LOGIC_VECTOR(5 downto 0)
                           :="101101";
    -- Number of successfully transmitted frames after 9 collisions
    constant Coll9         : STD_LOGIC_VECTOR(5 downto 0)
                           :="101110";
    -- Number of successfully transmitted frames after 10 collisions
    constant Coll10        : STD_LOGIC_VECTOR(5 downto 0)
                           :="101111";
    -- Number of successfully transmitted frames after 11 collisions
    constant Coll11        : STD_LOGIC_VECTOR(5 downto 0)
                           :="110000";
    -- Number of successfully transmitted frames after 12 collisions
    constant Coll12        : STD_LOGIC_VECTOR(5 downto 0)
                           :="110001";
    -- Number of successfully transmitted frames after 13 collisions
    constant Coll13        : STD_LOGIC_VECTOR(5 downto 0)
                           :="110010";
    -- Number of successfully transmitted frames after 14 collisions
    constant Coll14        : STD_LOGIC_VECTOR(5 downto 0)
                           :="110011";
    -- Number of successfully transmitted frames after 15 collisions
    constant Coll15        : STD_LOGIC_VECTOR(5 downto 0)
                           :="110100";
    -- Number of frames that experinced 16 in-window collsions
    constant Coll16        : STD_LOGIC_VECTOR(5 downto 0)
                           :="110101";
    -- Number of successfully transmitted deffered frames
    constant TxDefer       : STD_LOGIC_VECTOR(5 downto 0)
                           :="110110";
    -- Number of successfully transmitted 'pause' frames
    constant TxPause       : STD_LOGIC_VECTOR(5 downto 0)
                           :="110111";
    -- Number of transmitted frames that experienced late collision
    constant TxLCErr       : STD_LOGIC_VECTOR(5 downto 0)
                           :="111000";
    -- Number of frames that underrun error
    constant TxMACErr      : STD_LOGIC_VECTOR(5 downto 0)
                           :="111001";
    -- Number of frames that experienced 'no carrier sense' or 
    -- dropped carrier sense during transmission
    constant TxCSErr       : STD_LOGIC_VECTOR(5 downto 0)
                           :="111010";
    
    ---------------------------------------------------------------------
    -- Flow control
    ---------------------------------------------------------------------
  
    -- Control frames broadcast address = 01-80-C2-00-00-01 --
    constant CNTL_BROADCAST_ADDR  : STD_LOGIC_VECTOR(47 downto 0)
      := "000000011000000011000010000000000000000000000001";
    -- Ethernet Control frames lenght/type filed content = 88-08 --
    constant CNTL_TYPE            : STD_LOGIC_VECTOR(15 downto 0)
      := "1000100000001000";
    -- PAUSE opcode for Ethernet Control frame = 00-01 --
    constant CNTL_PAUSE_OPCODE    : STD_LOGIC_VECTOR(15 downto 0)
      := "0000000000000001";

    -------------------------------------------------------------------
    -- Enumeration types
    -------------------------------------------------------------------
    
    -- DMA state machine
    type DMASMT is (
                  DSM_IDLE,
                  DSM_CH1,
                  DSM_CH2
    );
    
    -- process state machine type
    type PSMT is (
                  PSM_RUN,
                  PSM_SUSPEND,
                  PSM_STOP
    );
    
    -- linked list state machine
    type LSMT is (
                  LSM_IDLE,
                  LSM_DES0P, -- des0 prefetching
                  LSM_DES0,  -- des0 fetching
                  LSM_DES1,  -- des1 fetching
                  LSM_DES2,  -- des2 fetching
                  LSM_DES3,  -- des3 fetching
                  LSM_BUF1,  -- buffer 1 fetching
                  LSM_BUF2,  -- buffer 2 fetching
                  LSM_STAT,  -- descriptor status storing
                  LSM_FSTAT, -- frame status storing
                  LSM_NXT    -- next descriptor's address computing
    );
                
    -- descriptor's control state machine
    type CSMT is (
                  CSM_IDLE,
                  CSM_F,     -- first descriptor
                  CSM_I,     -- intermediate descriptor
                  CSM_L,     -- last descriptor
                  CSM_FL,    -- first and last descriptor
                  CSM_SET,   -- setup frame descriptor
                  CSM_BAD    -- invalid descriptor
    );
  
    -- master interface state machine
    type MSMT is (
                  MSM_IDLE,
                  MSM_REQ,
                  MSM_BURST
    );
  
    -- receive state machine
    type RCSMT is (             
                  RSM_IDLE,
                  RSM_SFD,
                  RSM_DEST,
                  RSM_SOURCE,
                  RSM_LENGTH,
                  RSM_INFO,
                  RSM_SUCC,
                  RSM_INT,
                  RSM_INT1,
                  RSM_BAD    -- flushing received frame from fifo
    );
  
    -- address filtering state machine
    type FSMT is (
                  FSM_IDLE,
                  FSM_PERF1, -- checking single physical address
                  FSM_PERF16,-- checking 16 addresses
                  FSM_HASH,  -- hash fitering
                  FSM_MATCH, -- address match
                  FSM_FAIL   -- address failed
    );
  
    -- deffering state machine
    type DSMT is (
                  DSM_WAIT,  -- end of IFS, waiting for pending frame
                  DSM_IFS1,  -- calculating interframe space time 1
                  DSM_IFS2   -- calculating interframe space time 2
    );
  
    -- transmit state machine
    type TCSMT is (  
                  TSM_IDLE, 
                  TSM_PREA, 
                  TSM_SFD, 
                  TSM_INFO,
                  TSM_PAD,
                  TSM_CRC,
                  TSM_BURST,
                  TSM_JAM,
                  TSM_FLUSH,
                  TSM_INT,
                  TSM_FCW1,
                  TSM_FCW2
    );         
                
    -- miism controller state machine --
    type MIISMCT is (
                  MIISMC_RESET,
                  MIISMC_WAIT,
                  MIISMC_SYNC,
                  MIISMC_READ,
                  MIISMC_WRITE
    );  

    -- miism buffer state machine -- 
    type MIISMBT is (
                  MIISMB_RESET,
                  MIISMB_WAIT,
                  MIISMB_PREAMBLE1_LOAD,
                  MIISMB_PREAMBLE1,
                  MIISMB_PREAMBLE2_LOAD,
                  MIISMB_PREAMBLE2,
                  MIISMB_START_LOAD,
                  MIISMB_START,
                  MIISMB_WRITE_COMMAND_LOAD,
                  MIISMB_WRITE_COMMAND,
                  MIISMB_WRITE_DATA_LOAD,
                  MIISMB_WRITE_DATA,
                  MIISMB_WRITE_DATA_END,
                  MIISMB_WRITE_RESET,
                  MIISMB_READ_COMMAND_LOAD,
                  MIISMB_READ_COMMAND,
                  MIISMB_READ_DATA_LOAD,
                  MIISMB_READ_DATA,
                  MIISMB_READ_DATA_CAPTURE,
                  MIISMB_READ_DATA_WAIT,
                  MIISMB_READ_WAIT,
                  MIISMB_READ_RESET
    );

    -- state machine for pause frame recognition mechanizm --
    type PFRT is (
             PFR_RESET,
             PFR_WAIT,
             PFR_1ST,
             PFR_2ND,
             PFR_3RD,
             PFR_CATCH,
             PFR_REL,
             PFR_TIMER_RELOAD,
             PFR_FCR_UNUSED
    );
             
    -- state machine for pause state controller --
    type PSCT is (
             PSC_RESET,
             PSC_WAIT,
             PSC_GENERATEPAUSE,
             PSC_LOADTIMER,
             PSC_PAUSESTATE,
             PSC_GENERATERESUME,
             PSC_HALFDUPLEX,
             PSC_TPFDISABLED
    );
            
    -- state machine for pause frame generator --
    type PFGT is (
             PFG_RESET,
             PFG_WAIT,
             PFG_1ST,
             PFG_2ND,
             PFG_PAUSE,
             PFG_RESUME,
             PFG_PADDINGWAIT,
             PFG_TRANSMITIONCOMPLETED
    );
    
  end UTILITY_MAC_1G;
--*******************************************************************--

