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
-- File name            : mac_1g.vhd
-- File contents        : Entity MAC_1G
--                        Architecture STR of MAC_1G
-- Purpose              : Top level structure of MAC_1G
--
-- Destination library  : MAC_1G_LIB
-- Dependencies         : MAC_1G_LIB.UTILITY
--                        IEEE.STD_LOGIC_1164
--
-- Design Engineer      : T.K.
-- Quality Engineer     : M.B.
-- Version              : 2.02E00
-- Last modification    : 2004-08-16
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
-- 2.02.E00   :
-- 2004.02.20 : B.W. - enabling flow control mode changed
--                     * fce port added in in FCR and FCT component
-- 2004.04.02 : T.K. - cs collision seen functionality fixed (F200.06.cs)
--*******************************************************************--

library IEEE;
  use IEEE.STD_LOGIC_1164.all;

library MAC_1G_LIB;
  use MAC_1G_LIB.UTILITY_MAC_1G.all;

--*******************************************************************--
  entity MAC_1G is
    generic (
              -- CSR interface data bus width
              CSRWIDTH   : INTEGER := 32;   -- 8|16|32
              -- Data interface data bus width
              DATAWIDTH  : INTEGER := 32;   -- 8|16|32
              -- Data interface address bus width
              DATADEPTH  : INTEGER := 32;   -- 8-32
              -- Transmit FIFO depth
              TFIFODEPTH : INTEGER := 9;    -- 6-16
              -- Receive FIFO depth
              RFIFODEPTH : INTEGER := 9;    -- 6-16
              -- Transmit frame cache depth
              TCDEPTH    : INTEGER := 1;    -- 1...
              -- Receive frame cache depth
              RCDEPTH    : INTEGER := 2     -- 1...
    );
    port (
    
      ------------------------- clocks / resets -----------------------
      -- dma interface clock
      clkdma    : in  STD_LOGIC;
      -- csr interface clock
      clkcsr    : in  STD_LOGIC;
      -- reset
      rst       : in  STD_LOGIC;
      -- transmit clock
      clkt      : in  STD_LOGIC;
      -- receive clock
      clkr      : in  STD_LOGIC;
      -- gigabit mode selection output
      gbo       : out STD_LOGIC;
      
      ---------------------------- interrupt --------------------------
      int       : out STD_LOGIC;
      
      -------------------------- clock control ------------------------
      -- transmit process stopped
      tps       : out STD_LOGIC;
      -- receive process stopped
      rps       : out STD_LOGIC;
      
      -------------------------- csr interface ------------------------
      -- request
      csrreq    : in  STD_LOGIC;
      -- read/ not write selection
      csrrw     : in  STD_LOGIC;
      -- byte enable
      csrbe     : in  STD_LOGIC_VECTOR(CSRWIDTH/8-1 downto 0);
      -- data input
      csrdatai  : in  STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
      -- address
      csraddr   : in  STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
      -- acknowledge
      csrack    : out STD_LOGIC;
      -- data output
      csrdatao  : out STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
      
      ----------------------- host data interface ---------------------
      -- acknowledge
      dataack    : in  STD_LOGIC;
      -- request registered
      datareq    : out STD_LOGIC; 
      -- request combinatorial
      datareqc   : out STD_LOGIC; 
      -- read / not write selection
      datarw     : out STD_LOGIC;
      -- end of burst
      dataeob    : out STD_LOGIC;  
      -- end of burst combinatorial
      dataeobc   : out STD_LOGIC;
      -- data input
      datai      : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      -- address
      dataaddr   : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
      -- data output
      datao      : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      
      ---------------- transmit dual port ram interface ---------------
      -- read data
      trdata     : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      -- write enable
      twe        : out STD_LOGIC;
      -- write address
      twaddr     : out STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
      -- read address
      traddr     : out STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
      -- write data
      twdata     : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      
      ------------------ receive dual port ram interface --------------
      -- read data
      rrdata     : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      -- write enable
      rwe        : out STD_LOGIC;
      -- write address
      rwaddr     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
      -- read address
      rraddr     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
      -- write data
      rwdata     : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      
      ------------------ address filtering ram interface --------------
      -- read data
      frdata     : in  STD_LOGIC_VECTOR(15 downto 0);
      -- write enable
      fwe        : out STD_LOGIC;
      -- write address
      fwaddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
      -- read address
      fraddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
      -- write data
      fwdata     : out STD_LOGIC_VECTOR(15 downto 0);
      
      -------------------- external address filtering -----------------
      -- match input
      match      : in  STD_LOGIC;
      -- match valid
      matchval   : in  STD_LOGIC;
      -- match enable
      matchen    : out STD_LOGIC;
      -- match data
      matchdata  : out STD_LOGIC_VECTOR(47 downto 0);
      
      -------------------- serial micro-wire interface ----------------
      -- serial data input
      sdi        : in  STD_LOGIC;
      -- serial clock
      sclk       : out STD_LOGIC;
      -- serial chip select
      scs        : out STD_LOGIC;
      -- serial data output
      sdo        : out STD_LOGIC;
      
      ------------------------ statistical counters -------------------
      -- single receive SC clear
      sscclrr    : out STD_LOGIC;        
      -- single transmit SC clear
      sscclrt    : out STD_LOGIC;        
      -- address for statistical transmit counter
      scadr      : out STD_LOGIC_VECTOR(3 downto 0);
      -- address for statistical receive counter
      scadt      : out STD_LOGIC_VECTOR(4 downto 0);
      -- receive statistical counter read data 
      scdr       : in  STD_LOGIC_VECTOR(31 downto 0);
      -- transmit statistical counter read data 
      scdt       : in  STD_LOGIC_VECTOR(31 downto 0);

      ------------- DP RAM receive counters interface -----------------
      -- read ram data for receive counters
      dir        : in  STD_LOGIC_VECTOR(31 downto 0);
      -- write enable for receive counters
      ramwer     : out STD_LOGIC;
      -- ram address for receive counters
      ar         : out STD_LOGIC_VECTOR(3 downto 0);
      -- ram data to be written for receive counters
      dor        : out STD_LOGIC_VECTOR(31 downto 0);

      ------------ DP RAM transmit counters interface -----------------
      -- read ram data for transmit counters
      dit        : in  STD_LOGIC_VECTOR(31 downto 0);
      -- write enable for transmit counters
      ramwet     : out STD_LOGIC;
      -- ram address for transmit counters
      at         : out STD_LOGIC_VECTOR(4 downto 0);
      -- ram data to be written for transmit counters
      dot        : out STD_LOGIC_VECTOR(31 downto 0);

      --------------------------- mii interface -----------------------
      -- receive error
      rxer       : in  STD_LOGIC;
      -- receive data valid
      rxdv       : in  STD_LOGIC;
      -- collision detected
      col        : in  STD_LOGIC;
      -- carrier sense
      crs        : in  STD_LOGIC;
      -- receive data
      rxd        : in  STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
      -- transmit enable
      txen       : out STD_LOGIC;
      -- transmit error
      txer       : out STD_LOGIC;
      -- transmit data
      txd        : out STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
      -- management clock
      mdc        : out STD_LOGIC;
      -- management data input
      mdi        : in  STD_LOGIC;
      -- management data output
      mdo        : out STD_LOGIC;
      -- management output enable
      mden       : out STD_LOGIC
    );
  end MAC_1G;

--*******************************************************************--
architecture STR of MAC_1G is

  -------------------------- internal reset ---------------------------
  -- software reset
  signal rstsoft  : STD_LOGIC;
  -- transmit reset
  signal rsttc    : STD_LOGIC;
  -- receive reset
  signal rstrc    : STD_LOGIC;
  -- dma reset
  signal rstdma   : STD_LOGIC;
  -- csr reset
  signal rstcsr   : STD_LOGIC;
  -- fcr reset
  signal rstfcr   : STD_LOGIC;
  -- fct reset
  signal rstfct   : STD_LOGIC;
  -- bp reset
  signal rstbp    : STD_LOGIC;
  
  ------------------------- csr configuration -------------------------
  -- programmable burst length
  signal pbl      : STD_LOGIC_VECTOR(5 downto 0);
  -- add crc disable
  signal ac       : STD_LOGIC;
  -- disable padding
  signal dpd      : STD_LOGIC;
  -- descriptor skip length
  signal dsl      : STD_LOGIC_VECTOR(4 downto 0);
  -- transmit pool demand
  signal tpoll    : STD_LOGIC;
  -- transmit descriptors base address
  signal tdbad    : STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
  -- store and forward mode
  signal sf       : STD_LOGIC;
  -- transmit treshold mode
  signal tm       : STD_LOGIC_VECTOR(2 downto 0);
  -- full duplex
  signal fd       : STD_LOGIC;
  -- big/little endian for data buffers
  signal ble      : STD_LOGIC;
  -- descriptor byte ordering
  signal dbo      : STD_LOGIC;
    -- receive all
  signal ra        : STD_LOGIC;
  -- pass all multicast
  signal pm        : STD_LOGIC;
  -- promiscous mode
  signal pr        : STD_LOGIC;
  -- pass bad frames
  signal pb        : STD_LOGIC;
  -- inverse filtering mode
  signal rif       : STD_LOGIC;
  -- hash only filtering mode
  signal ho        : STD_LOGIC;
  -- hash/perfect filtering mode
  signal hp        : STD_LOGIC;
  -- receive poll demand
  signal rpoll    : STD_LOGIC;
  -- receive poll acknowledge
  signal rpollack : STD_LOGIC;
  -- receive descriptors base address
  signal rdbad    : STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
  -- gigabit mode selection
  signal gb       : STD_LOGIC;
  
  ------------------- csr status data -----------------------
  -- fetching transmit descriptor
  signal tdes     : STD_LOGIC;
  -- fetching transmit buffer
  signal tbuf     : STD_LOGIC;
  -- processing setup frame
  signal tset     : STD_LOGIC;
  -- writing transmit descriptor status
  signal tstat    : STD_LOGIC;
  -- transmit descriptor unavailable
  signal tu       : STD_LOGIC;
  -- filtering type
  signal ft       : STD_LOGIC_VECTOR(1 downto 0);
  -- fetching receive descriptor
  signal rdes     : STD_LOGIC;
  -- writing receive descriptor status
  signal rstat    : STD_LOGIC;
  -- receive descriptor unavailable
  signal ru       : STD_LOGIC;
  -- receive completition
  signal rcomp    : STD_LOGIC;
  -- receive completition acknowledge
  signal rcompack : STD_LOGIC;
  -- transmit completition
  signal tcomp    : STD_LOGIC;
  -- transmit completition acknowledge
  signal tcompack : STD_LOGIC;

  -------------------------------- dma --------------------------------
  -- dma priority scheme
  signal priority : STD_LOGIC_VECTOR(1 downto 0);
  -- transmit request
  signal treq     : STD_LOGIC;
  -- transmit write selection
  signal twrite   : STD_LOGIC;
  -- transmit transfer count
  signal tcnt     : STD_LOGIC_VECTOR(FIFODEPTH_MAX-1 downto 0);
  -- transmit start address
  signal taddr    : STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
  -- transmit data input
  signal tdatai   : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  -- transmit single transfer acknowledge
  signal tack     : STD_LOGIC;
  -- transmit end of burst
  signal teob     : STD_LOGIC;
  -- transmit data output
  signal tdatao   : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  -- receive request
  signal rreq     : STD_LOGIC;
  -- receive write selection
  signal rwrite   : STD_LOGIC;
  -- receive transfer count
  signal rcnt     : STD_LOGIC_VECTOR(FIFODEPTH_MAX-1 downto 0);
  -- receive start address
  signal raddr    : STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
  -- receive data input
  signal rdatai   : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  -- receive single transfer acknowledge
  signal rack     : STD_LOGIC;
  -- receive end of burst
  signal reob     : STD_LOGIC;
  -- receive data output
  signal rdatao   : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  -- internal data interface address
  signal idataaddr : STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
  
  --------------------------- transmit FIFO ---------------------------
  -- transmit fifo not full
  signal tfifonf    : STD_LOGIC;
  -- transmit frame cache not full
  signal tfifocnf   : STD_LOGIC;
  -- transmit fifo valid
  signal tfifoval   : STD_LOGIC;
  -- transmit write enable
  signal tfifowe    : STD_LOGIC;
  -- transmit end of frame
  signal tfifoeof   : STD_LOGIC;
  -- transmit last byte enable
  signal tfifobe    : STD_LOGIC_VECTOR(DATAWIDTH/8-1 downto 0);
  -- transmit data output
  signal tfifodata  : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  -- transmit fifo level
  signal tfifolev   : STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
  -- transmit fifo read address grey coded
  signal tradg      : STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
  
  ------------------------ transmit frame cache -----------------------
  -- early transmit interrupt acknowledge
  signal etiack    : STD_LOGIC;
  -- early transmit interrupt request
  signal etireq    : STD_LOGIC;
  -- transmit cache not empty
  signal tcsne     : STD_LOGIC;
  -- transmit cache read enable
  signal tcachere  : STD_LOGIC;
  -- interrupt on completition input
  signal ic        : STD_LOGIC;
  -- interrupt on completition input
  signal ici       : STD_LOGIC;
  -- add carry disable input
  signal aci       : STD_LOGIC;
  -- disable padding input
  signal dpdi      : STD_LOGIC;
  -- loss of carrier output
  signal lo_o      : STD_LOGIC;
  -- no carrier output
  signal nc_o      : STD_LOGIC;
  -- late collision output
  signal lc_o      : STD_LOGIC;
  -- excessive collision output
  signal ec_o      : STD_LOGIC;
  -- deferred output
  signal de_o      : STD_LOGIC;
  -- underrun error output
  signal ur_o      : STD_LOGIC;
  -- collision count output
  signal cc_o      : STD_LOGIC_VECTOR(3 downto 0);
  -- broadcast frame output
  signal tbf_o     : STD_LOGIC;
  -- multicast frame output
  signal tmf_o     : STD_LOGIC;
  -- transmit octets number output
  signal toc_o     : STD_LOGIC_VECTOR(13 downto 0);
  -- loss of carrier input
  signal lo_i      : STD_LOGIC;
  -- no carrier input
  signal nc_i      : STD_LOGIC;
  -- late collision input
  signal lc_i      : STD_LOGIC;
  -- excessive collision input
  signal ec_i      : STD_LOGIC;
  -- deferred input
  signal de_i      : STD_LOGIC;
  -- underrun error input
  signal ur_i      : STD_LOGIC;
  -- collision count input
  signal cc_i      : STD_LOGIC_VECTOR(3 downto 0);
  -- broadcast frame input
  signal tbf_i     : STD_LOGIC;
  -- multicast frame input
  signal tmf_i     : STD_LOGIC;
  -- transmit octets number input
  signal toc_i     : STD_LOGIC_VECTOR(13 downto 0);
  
  ------------------ transmit linked list management ------------------
  -- transmit poll acknowldge
  signal tpollack : STD_LOGIC;
  -- transmit descriptor base address changed
  signal tdbadc   : STD_LOGIC;
  -- frame status address output
  signal statado  : STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
  -- frame status address input
  signal statadi  : STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
  
  ------------------------- transmit control --------------------------
  -- start of frame request
  signal sofreq    : STD_LOGIC;
  -- end of frame request
  signal eofreq    : STD_LOGIC;
  -- last byte enable
  signal be        : STD_LOGIC_VECTOR(DATAWIDTH/8-1 downto 0);
  -- end of frame fifo address
  signal eofad     : STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
  -- transmit fifo write address grey coded
  signal twadg     : STD_LOGIC_VECTOR(TFIFODEPTH-1 downto 0);
  -- transmit interrupt request
  signal tireq     : STD_LOGIC;
  -- transmit interrupt acknowledge
  signal tiack     : STD_LOGIC;
  -- collision window passed
  signal winp      : STD_LOGIC;
  
  ----------------------- half duplex procedures ----------------------
  -- collision detected
  signal coll      : STD_LOGIC;
  -- carrier sense
  signal carrier   : STD_LOGIC;
  -- backoff in progress
  signal bkoff     : STD_LOGIC;
  -- transmission pending
  signal tpend     : STD_LOGIC;
  -- transmission in progress
  signal tprog     : STD_LOGIC;
  -- preamble transmission in progress
  signal preamble  : STD_LOGIC;
  -- crc remainder of the frame
  signal crc       : STD_LOGIC_VECTOR(9 downto 0);
  
  -------------------------- transmit timers --------------------------
  -- transmit timer request
  signal tcsreq    : STD_LOGIC;
  -- transmit timer acknowledge
  signal tcsack    : STD_LOGIC;
  
  --------------------- transmit process management -------------------
  -- stop transmit process
  signal stopt     : STD_LOGIC;
  -- tc component stopped
  signal stoptc    : STD_LOGIC;
  -- tfifo component stopped
  signal stoptfifo : STD_LOGIC;
  -- tlsm component stopped
  signal stoptlsm  : STD_LOGIC;
  
  -------------------------- receive fifo -----------------------------
  -- fifo read address grey coded
  signal rradg     : STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
  -- fifo write address grey coded
  signal rwadg     : STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
  -- fifo read enable
  signal rfifore   : STD_LOGIC;
  -- fifo level
  signal rflev     : STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
  -- fifo data
  signal rfifodata : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  -- cache read enable
  signal rcachere  : STD_LOGIC;
  -- cache not empty
  signal rcachene  : STD_LOGIC;
  -- cache not full
  signal rcachenf  : STD_LOGIC;
  -- internal write receive data
  signal irwdata   : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  -- internal receieve write enable
  signal irwe      : STD_LOGIC;
              
              
  ------------------------- receive control ---------------------------
  -- interrupt acknowledge from csr
  signal riack     : STD_LOGIC;
  -- receive enable
  signal ren       : STD_LOGIC;
  -- receive interrupt request
  signal rireq     : STD_LOGIC;
  -- filtering fail
  signal ff        : STD_LOGIC;
  -- runt frame
  signal rf        : STD_LOGIC;
  -- multicast frame
  signal rmf       : STD_LOGIC;
  -- broadcast frame
  signal rbf        : STD_LOGIC;
  -- dribbling bit
  signal db        : STD_LOGIC;
  -- mii error
  signal re        : STD_LOGIC;
  -- crc error
  signal ce        : STD_LOGIC;
  -- too long
  signal tl        : STD_LOGIC;
  -- frame type
  signal ftp       : STD_LOGIC;
  -- fifo overflow
  signal ov        : STD_LOGIC;
  -- collision seen
  signal cs        : STD_LOGIC;
  -- length of frame
  signal length    : STD_LOGIC_VECTOR(13 downto 0);
  -- receive in progress
  signal rprog     : STD_LOGIC;
  -- rc poll
  signal rcpoll    : STD_LOGIC;
  
  ------------------------ receive frame cache ------------------------
  -- filtering fail
  signal ff_o      : STD_LOGIC;
  -- runt frame
  signal rf_o      : STD_LOGIC;
  -- multicast frame
  signal rmf_o     : STD_LOGIC;
  -- broadcast frame
  signal rbf_o     : STD_LOGIC;
  -- frame too long
  signal tl_o     : STD_LOGIC;
  -- report on mii error
  signal re_o     : STD_LOGIC;
  -- dribbling bit
  signal db_o     : STD_LOGIC;
  -- crc error
  signal ce_o     : STD_LOGIC;
  -- fifo overflow
  signal ov_o     : STD_LOGIC;
  -- collision seen
  signal cs_o     : STD_LOGIC;
  -- frame length
  signal fl_o     : STD_LOGIC_VECTOR(13 downto 0);
  
  ------------------- receive linked list management ------------------
  -- receive descriptor base address changed
  signal rdbadc   : STD_LOGIC;
  -- early receive interrupt request
  signal erireq   : STD_LOGIC;
  -- early receive interrupt acknowledge
  signal eriack   : STD_LOGIC;
  -- fetching receive buffer
  signal rbuf     : STD_LOGIC;

  ------------------- statistical counters ----------------
  -- clear fifo overflow counter acknowledge
  signal foclack   : STD_LOGIC;
  -- clear missed frames counter acknowledge
  signal mfclack   : STD_LOGIC;
  -- fifo overflow counter overflow
  signal oco       : STD_LOGIC;
  -- missed frames counter overflow
  signal mfo       : STD_LOGIC;
  -- fifo overflow counter grey coded
  signal focg      : STD_LOGIC_VECTOR(10 downto 0);
  -- missed frames counter grey coded
  signal mfcg      : STD_LOGIC_VECTOR(15 downto 0);
  -- clear fifo overflow counter request
  signal focl      : STD_LOGIC;
  -- clear missed frames counter
  signal mfcl      : STD_LOGIC;
  --------------- blocking statistical counters -------------
  -- statistical counters blocking acknowledge
  signal ackb      : STD_LOGIC;
  -- block statictical counters
  signal scblock   : STD_LOGIC;        
  --------------- clearing statistical counters -------------
  -- clear statistical counters
  signal clrscreq  : STD_LOGIC;
  -- clear statistical counters acknowledge (after clearing) 
  signal clrscack  : STD_LOGIC;
  
  --------------------- receive process management --------------------
  -- stop receive process
  signal stopr     : STD_LOGIC;
  -- rc component stopped
  signal stoprc    : STD_LOGIC;
  -- rfifo component stopped
  signal stoprfifo : STD_LOGIC;
  -- rlsm component stopped
  signal stoprlsm  : STD_LOGIC;
  
  -------------------------- receive timers ---------------------------
  -- cycle size acknowledge
  signal rcsack    : STD_LOGIC;
  -- cycle size request
  signal rcsreq    : STD_LOGIC;
  
--  -- MIISM module --
--  -- MIISM control register data input --
--  signal miismreginput   : STD_LOGIC_VECTOR (31 downto 0);
--  -- MIISM control register data write --
--  signal miismregwrite   : STD_LOGIC; 
--  -- MIISM control register data output --
--  signal miismregoutput  : STD_LOGIC_VECTOR (31 downto 0);   

  -- receiving pause frame 
  signal pfr_i     : STD_LOGIC;
  -- transmitting pause frame 
  signal pft_i     : STD_LOGIC;
  
  
  --------------------------- flow control ----------------------------
  -- mii transmit enable --
  signal txen_i           : STD_LOGIC;
  -- half duplex fifo full signal --
  signal fifofull         : STD_LOGIC;
  -- back pressure transmit enable --
  signal txenbp           : STD_LOGIC;
  -- flow control enable
  signal fce              : STD_LOGIC;
  -- back pressure enable
  signal bpe              : STD_LOGIC;
  -- transmit pause enable
  signal tpe              : STD_LOGIC;
  -- transmit unpause enable
  signal tue              : STD_LOGIC;
  -- receive pause enable
  signal rpe              : STD_LOGIC;
--  -- fifo usage level
--  signal flev        : STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
  -- treshold level 1
  signal tresh1           : STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
  -- treshold level 2
  signal tresh2           : STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
  -- cache usage level
  signal clev             : STD_LOGIC_VECTOR(RCDEPTH-1 downto 0);
  -- treshold level 3
  signal tresh3           : STD_LOGIC_VECTOR(RCDEPTH-1 downto 0);
  -- treshold level 4
  signal tresh4           : STD_LOGIC_VECTOR(RCDEPTH-1 downto 0);
  -- fifo almost full
  signal faf              : STD_LOGIC;
  -- fifo almost empty
  signal fae              : STD_LOGIC;
  -- cache almost full
  signal caf              : STD_LOGIC;
  -- cache almost empty
  signal cae              : STD_LOGIC;
  -- mac address
  signal macaddr          : STD_LOGIC_VECTOR(47 downto 0);
  -- pause time value
  signal pausetime        : STD_LOGIC_VECTOR(15 downto 0);
  -- pause frame data read
  signal ctrlre           : STD_LOGIC;
  -- trasmiter idle
  signal tsmidle          : STD_LOGIC;
  -- pause data
  signal ctrldata         : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  -- host transmit paused
  signal htp              : STD_LOGIC;
  -- pause request
  signal pausereq         : STD_LOGIC;
  -- pause request send --
  signal prs              : STD_LOGIC;
  
  --------------------------- mii management---------------------------
  -- MIISM control register data input --
  signal miismreginput   : STD_LOGIC_VECTOR (31 downto 0);
  -- MIISM control register data write --
  signal miismregwrite   : STD_LOGIC; 
  -- MIISM control register data output --
  signal miismregoutput  : STD_LOGIC_VECTOR (31 downto 0);   

  ----------------------- statistical countetrs -----------------------
  -- Tx control pause counter request
  signal txctrlpause_req        : STD_LOGIC;
  -- Rx control pause counter request
  signal rxctrlpause_req        : STD_LOGIC;
  -- Rx control bad opcode counter request
  signal rxctrlbadop_req        : STD_LOGIC;
  -- Tx control pause counter acknowledge
  signal txctrlpause_ack        : STD_LOGIC;
  -- Rx control pause counter acknowledge
  signal rxctrlpause_ack        : STD_LOGIC;
  -- Rx control bad opcode counter acknowledge
  signal rxctrlbadop_ack        : STD_LOGIC;
  -- Rx control bad opcode counter acknowledge
  signal rxctrlbadop           : STD_LOGIC;
  
  ----------------------- statistical countetrs -----------------------
  -- leave old MIISM not connected --
  -- unconnected sofware driven mii managemnt mdc signal --
  signal noconnect_mdc   : STD_LOGIC;
  -- unconnected sofware driven mii managemnt mdi signal --
  signal noconnect_mdi   : STD_LOGIC;
  -- unconnected sofware driven mii managemnt mdo signal --
  signal noconnect_mdo   : STD_LOGIC;
  -- unconnected sofwarde driven mii managemnt mden signal --
  signal noconnect_mden  : STD_LOGIC;
  
  ---------------------------------------------------------------------
  -- Direct Memory Access
  ---------------------------------------------------------------------
  component DMA
    generic(
            -- Data interface data bus width
            DATAWIDTH : INTEGER := 32; -- 8|16|32|64
            -- Data interface address bus width
            DATADEPTH : INTEGER := 32
    );
    port (  
            ---------------------- Common ports -----------------------
            -- global clock
            clk       : in  STD_LOGIC;
            -- hardware reset
            rst       : in  STD_LOGIC;
            
            ---------------------- Configuration ----------------------
            -- channel priority
            priority  : in  STD_LOGIC_VECTOR(1 downto 0);
            -- big / little endian selection
            ble       : in  STD_LOGIC;
            -- descriptor byte ordering
            dbo       : in  STD_LOGIC;
            -- fetching receive descriptor
            rdes      : in  STD_LOGIC;
            -- fetching receive buffer
            rbuf      : in  STD_LOGIC;
            -- writing receive descriptor status
            rstat     : in  STD_LOGIC;
            -- fetching transmit descriptor
            tdes      : in  STD_LOGIC;
            -- fetching transmit buffer
            tbuf      : in  STD_LOGIC;
            -- writing transmit descriptor status
            tstat     : in  STD_LOGIC;
            
            --------------------- Data interface ----------------------
            -- data acknowledge
            dataack   : in  STD_LOGIC;
            -- data input bus
            datai     : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- data request
            datareq   : out STD_LOGIC;
            -- data request combiantorial
            datareqc  : out STD_LOGIC;
            -- data read / not write
            datarw    : out STD_LOGIC;
            -- data end of burst
            dataeob   : out STD_LOGIC;
            -- data end of burst combinatorial
            dataeobc  : out STD_LOGIC;
            -- data output bus
            datao     : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- data address
            dataaddr  : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- internal data address
            idataaddr : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            
            --------------------- Channel 1 ---------------------------
            -- request
            req1      : in  STD_LOGIC;
            -- write selection
            write1    : in  STD_LOGIC;
            -- transfer count
            tcnt1     : in  STD_LOGIC_VECTOR(FIFODEPTH_MAX-1 downto 0);
            -- start address
            addr1     : in  STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- data input
            datai1    : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- single transfer acknowledge
            ack1      : out STD_LOGIC;
            -- end of burst
            eob1      : out STD_LOGIC;
            -- data output
            datao1    : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            
            --------------------- Channel 2 ---------------------------
            -- request
            req2      : in  STD_LOGIC;
            -- write selection
            write2    : in  STD_LOGIC;
            -- transfer count
            tcnt2     : in  STD_LOGIC_VECTOR(FIFODEPTH_MAX-1 downto 0);
            -- start address
            addr2     : in  STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- data input
            datai2    : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- single transfer acknowledge
            ack2      : out STD_LOGIC;
            -- end of burst
            eob2      : out STD_LOGIC;
            -- data output
            datao2    : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0)
    );
  end component;

  ---------------------------------------------------------------------
  -- Backoff and deferring
  ---------------------------------------------------------------------
  component BD
    port (    
            ------------------------- common --------------------------
            -- transmit clock
            clk       : in  STD_LOGIC;
            -- reset
            rst       : in  STD_LOGIC;
            -- gigabit mode selection
            gb        : in  STD_LOGIC;
            
            ---------------------- mii interface ----------------------
            -- mii collision
            col       : in  STD_LOGIC;
            -- mii carrier sense
            crs       : in  STD_LOGIC;
            
            -------------------- csr configuration --------------------
            -- full duplex mode
            fdp       : in  STD_LOGIC;
            
            ---------------------- transmit status --------------------
            -- transmit in progress
            tprog     : in  STD_LOGIC;
            -- preamble transmission in progress
            preamble  : in  STD_LOGIC;
            -- transmit pending
            tpend     : in  STD_LOGIC;
            -- collision window passed
            winp      : out STD_LOGIC;
            -- transmit interrupt acknowledge
            tiack     : in  STD_LOGIC;
            -- collision detected
            coll      : out STD_LOGIC;
            -- carrier sense
            carrier   : out STD_LOGIC;
            -- backoff in progress
            bkoff     : out STD_LOGIC;
            -- late collission
            lc        : out STD_LOGIC;
            -- loss of carrier
            lo        : out STD_LOGIC;
            -- no carrier
            nc        : out STD_LOGIC;
            -- excessive collisions
            ec        : out STD_LOGIC;
            -- collision counter
            cc        : out STD_LOGIC_VECTOR(3 downto 0);
            
            -- crc remainder of the frame
            crc       : in  STD_LOGIC_VECTOR(9 downto 0)
    );
  end component;

  ---------------------------------------------------------------------
  -- Transmit FIFO
  ---------------------------------------------------------------------
  component TFIFO
    generic(
            -- Data interface data bus width
            DATAWIDTH  : INTEGER := 32; -- 8|16|32|64
            -- Data interface address bus width
            DATADEPTH  : INTEGER := 32;
            -- Depth of the transmit and receive FIFO memories
            FIFODEPTH  : INTEGER := 9;
            -- Depth of the frame cache for transmit FIFO
            CACHEDEPTH : INTEGER := 1
    );
    port (  
            ---------------------- Common ports -----------------------
            -- global clock
            clk       : in  STD_LOGIC;
            -- hardware reset
            rst       : in  STD_LOGIC;
            
            ------------------------- DP RAM --------------------------
            -- ram write enable
            ramwe    : out STD_LOGIC;
            -- ram address
            ramaddr  : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            -- ram data
            ramdata  : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            
            -------------------------- TLSM ----------------------------
            -- fifo write enable
            fifowe   : in  STD_LOGIC;
            -- fifo end of frame
            fifoeof  : in  STD_LOGIC;
            -- fifo last byte enable
            fifobe   : in  STD_LOGIC_VECTOR(DATAWIDTH/8-1 downto 0);
            -- fifo data
            fifodata : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- fifo not full
            fifonf   : out STD_LOGIC;
            -- frame cache not full
            fifocnf  : out STD_LOGIC;
            -- fifo valid
            fifoval  : out STD_LOGIC;
            -- fifo level
            flev     : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            
            ------------------ frame configuration cache --------------
            -- interrupt on completition
            ici       : in  STD_LOGIC;
            -- disabled padding
            dpdi      : in  STD_LOGIC;
            -- add crc disable
            aci       : in  STD_LOGIC;
            -- frame status address (for TLSM only)
            statadi   : in  STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            
            --------------------- frame status cache ------------------
            -- cache read enable
            cachere   : in  STD_LOGIC;
            -- multicast frame
            mfo       : out STD_LOGIC;              
            -- broadcast frame
            bfo       : out STD_LOGIC;              
            -- deferred
            deo       : out STD_LOGIC;
            -- late collission
            lco       : out STD_LOGIC;
            -- loss of carrier
            loo       : out STD_LOGIC;
            -- no carrier
            nco       : out STD_LOGIC;
            -- excessive collisions
            eco       : out STD_LOGIC;
            -- cache not empty
            csne      : out STD_LOGIC;
            -- interrupt on completition
            ico       : out STD_LOGIC;
            -- underrun
            uro       : out STD_LOGIC;
            -- collision count
            cco       : out STD_LOGIC_VECTOR(3 downto 0);
            -- number of transmitted octets
            toco      : out STD_LOGIC_VECTOR(13 downto 0);                          
            -- frame status address (for TLSM only)
            statado   : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            
            
            ------------------------ TC control ------------------------
            -- start of frame request
            sofreq    : out STD_LOGIC;
            -- end of frame request
            eofreq    : out STD_LOGIC;
            -- disabled padding
            dpdo      : out STD_LOGIC;
            -- add crc disable
            aco       : out STD_LOGIC;
            -- last byte enable
            beo       : out STD_LOGIC_VECTOR(DATAWIDTH/8-1 downto 0);
            -- end of frame fifo address
            eofad     : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            -- fifo write address grey coded
            wadg      : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            
            ------------------------- TC status -----------------------
            -- transmit interrupt
            tireq     : in  STD_LOGIC;
            -- collision window passed
            winp      : in  STD_LOGIC;
            -- multicast frame
            mfi       : in  STD_LOGIC;              
            -- broadcast frame
            bfi       : in  STD_LOGIC;              
            -- deferred
            dei       : in  STD_LOGIC;
            -- late collission
            lci       : in  STD_LOGIC;
            -- loss of carrier
            loi       : in  STD_LOGIC;
            -- no carrier
            nci       : in  STD_LOGIC;
            -- excessive collisions
            eci       : in  STD_LOGIC;
            -- underrun
            uri       : in  STD_LOGIC;
            -- collision count
            cci       : in  STD_LOGIC_VECTOR(3 downto 0);
            -- number of transmitted octets
            toci      : in  STD_LOGIC_VECTOR(13 downto 0);
            -- fifo read address grey coded
            radg      : in  STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            -- transmit interrupt acknowledge
            tiack     : out STD_LOGIC;
            
            ------------------ CSR configuration data -----------------
            -- store and forward mode
            sf        : in  STD_LOGIC;
            -- full duplex mode
            fdp       : in  STD_LOGIC;
            -- treshold mode
            tm        : in  STD_LOGIC_VECTOR(2 downto 0);
            -- programmable burst length
            pbl       : in  STD_LOGIC_VECTOR(5 downto 0);
            
            ----------------------- CSR status ------------------------
            -- early transmit interrupt acknowledge
            etiack    : in  STD_LOGIC;
            -- early transmit interrupt request
            etireq    : out STD_LOGIC;
            
            --------------------- power management --------------------
            -- stop transmit process input
            stopi    : in  STD_LOGIC;
            -- stop transmit process output
            stopo    : out STD_LOGIC
    );
  end component;
  
  ---------------------------------------------------------------------
  -- Transmit linked List Management
  ---------------------------------------------------------------------
  component TLSM
    generic(
            -- Data interface data bus width
            DATAWIDTH : INTEGER := 32; -- 8|16|32|64
            -- Data interface address bus width
            DATADEPTH : INTEGER := 32;
            -- Depth of the FIFO memory
            FIFODEPTH : INTEGER := 9
    );
    port (  
            ---------------------- common ports -----------------------
            -- global clock
            clk       : in  STD_LOGIC;
            -- hardware reset
            rst       : in  STD_LOGIC;
            
            ----------------- transmit FIFO control -------------------
            -- fifo not full
            fifonf    : in  STD_LOGIC;
            -- frame cache not full
            fifocnf   : in  STD_LOGIC;
            -- fifo valid
            fifoval   : in  STD_LOGIC;
            -- fifo level
            fifolev   : in  STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            -- write enable
            fifowe    : out STD_LOGIC;
            -- end of frame
            fifoeof   : out STD_LOGIC;
            -- last byte enable
            fifobe    : out STD_LOGIC_VECTOR(DATAWIDTH/8-1 downto 0);
            -- data output
            fifodata  : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            
            ----------------- transmit configuration ------------------
            -- interrupt on completition
            ic        : out STD_LOGIC;
            -- add crc disable
            ac        : out STD_LOGIC;
            -- disable padding
            dpd       : out STD_LOGIC;
            -- frame status address (for TLSM use only)
            statado   : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            
            ------------------- transmit status -----------------------
            -- cache not empty
            csne      : in  STD_LOGIC;
            -- loss of carrier
            lo        : in  STD_LOGIC;
            -- no carrier
            nc        : in  STD_LOGIC;
            -- late collision
            lc        : in  STD_LOGIC;
            -- excessive collision
            ec        : in  STD_LOGIC;
            -- deferred
            de        : in  STD_LOGIC;
            -- underrun error
            ur        : in  STD_LOGIC;
            -- collision count
            cc        : in  STD_LOGIC_VECTOR(3 downto 0);
            -- frame status address (for TLSM only)
            statadi   : in  STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- cache read enable
            cachere   : out STD_LOGIC;
            
            -------------------------- dma ----------------------------
            -- single transfer acknowledge
            dmaack    : in  STD_LOGIC;
            -- end of burst
            dmaeob    : in  STD_LOGIC;
            -- data input
            dmadatai  : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- current burst address
            dmaaddr   : in  STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- request
            dmareq    : out STD_LOGIC;
            -- write selection
            dmawr     : out STD_LOGIC;
            -- transfer count
            dmacnt    : out STD_LOGIC_VECTOR(FIFODEPTH_MAX-1 downto 0);
            -- start address
            dmaaddro  : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- data output
            dmadatao  : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            
            --------------------- address DP RAM ----------------------
            -- address ram write enable
            fwe       : out STD_LOGIC;
            -- address ram data
            fdata     : out STD_LOGIC_VECTOR(ADDRWIDTH-1 downto 0);
            -- address ram address
            faddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
            
            
            ------------------ csr configuration data -----------------
            -- descriptor skip length
            dsl      : in  STD_LOGIC_VECTOR(4 downto 0);
            -- probrammable burst length
            pbl      : in  STD_LOGIC_VECTOR(5 downto 0);
            -- poll demand
            poll     : in  STD_LOGIC;
            -- descriptor base address changed
            dbadc    : in  STD_LOGIC;
            -- descriptors base address
            dbad     : in  STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- poll acknowledge
            pollack  : out STD_LOGIC;
            
            ------------------- csr status data -----------------------
            -- transmit completition acknowledge
            tcompack  : in  STD_LOGIC;
            -- transmit completition
            tcomp     : out STD_LOGIC;
            -- fetching transmit descriptor
            des       : out STD_LOGIC;
            -- fetching transmit buffer
            fbuf      : out STD_LOGIC;
            -- writing transmit descriptor status
            stat      : out STD_LOGIC;
            -- setup frame processing
            setp      : out STD_LOGIC;
            -- transmit descriptor unavailable
            tu        : out STD_LOGIC;
            -- filtering type
            ft        : out STD_LOGIC_VECTOR(1 downto 0);
            
            --------------------- power management --------------------
            -- stop transmit process input
            stopi     : in  STD_LOGIC;
            -- stop transmit process output
            stopo     : out STD_LOGIC
    );
  end component;

  ---------------------------------------------------------------------
  -- Transmit controller
  ---------------------------------------------------------------------
  component TC
    generic (
              -- Depth of the transmit FIFO memory
              FIFODEPTH : INTEGER := 9;
              -- Depth of the internal data path
              DATAWIDTH : INTEGER := 32 -- 8|16|32
    );
    port (    
              -------------------- common signals ---------------------
              -- transmit clock
              clk       : in  STD_LOGIC;
              -- reset
              rst       : in  STD_LOGIC;
              -- gigabit mode selection
              gb        : in  STD_LOGIC;
              
              ------------------------- mii ---------------------------
              -- mii transmit data valid
              txen      : out STD_LOGIC;
              -- mii transmit error
              txer      : out STD_LOGIC;
              -- mii transmit data
              txd       : out STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
              
              ----------------------- DP RAM --------------------------
              -- transmit ram data
              ramdata   : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
              -- transmit ram address
              ramaddr   : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
              
              -------------------- FIFO control -----------------------
              -- fifo write address grey coded
              wadg      : in  STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
              -- fifo read address grey coded
              radg      : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
              
              ------------------- transmit control --------------------
              -- disabled padding
              dpd       : in  STD_LOGIC;
              -- add crc disable
              ac        : in  STD_LOGIC;
              -- start of frame request
              sofreq    : in  STD_LOGIC;
              -- end of frame request
              eofreq    : in  STD_LOGIC;
              -- interrupt acknowledge
              tiack     : in  STD_LOGIC;
              -- last byte enable
              lastbe    : in  STD_LOGIC_VECTOR(DATAWIDTH/8-1 downto 0);
              -- end of frame address
              eofadg    : in  STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
              -- interrupt request
              tireq     : out STD_LOGIC;
              -- fifo underrun
              ur        : out STD_LOGIC;
              -- deferred
              de        : out STD_LOGIC;
              
              ----------------------- flow control --------------------
              -- host transmition paused
              htp     : in  STD_LOGIC;
              -- transmit control frame
              ctrl      : in  STD_LOGIC;
              -- control frame data
              ctrldata  : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
              -- control frame read enable
              ctrlre    : out STD_LOGIC;
              -- transmitter idle
              tsmidle   : out STD_LOGIC;
              
              ------------------- statistical counters ----------------
              -- multicast frame
              mf        : out STD_LOGIC;              
              -- broadcast frame
              bf        : out STD_LOGIC;              
              -- number of transmitted octets
              toc        : out STD_LOGIC_VECTOR(13 downto 0);

              ------------------ half duplex procedures ---------------
              -- collision detected
              coll      : in  STD_LOGIC;
              -- carrier sense
              carrier   : in  STD_LOGIC;
              -- backoff in progress
              bkoff     : in  STD_LOGIC;
              -- transmission pending
              tpend     : out STD_LOGIC;
              -- transmission in progress
              tprog     : out STD_LOGIC;
              -- preamble transmission in progress
              preamble  : out STD_LOGIC;
              -- crc remainder of the frame for random number gen
              crco      : out STD_LOGIC_VECTOR(9 downto 0);
              
              ---------------------- power management -----------------
              -- stop input
              stopi     : in  STD_LOGIC;
              -- stop output
              stopo     : out STD_LOGIC;
              
              ------------------------- timers ------------------------
              -- cycle size acknowledge
              tcsack    : in  STD_LOGIC;
              -- cycle size request
              tcsreq    : out STD_LOGIC
    );
  end component;

  ---------------------------------------------------------------------
  -- Control and Status Registers
  ---------------------------------------------------------------------
  component CSR
    generic(
            -- CSR interface data bus width
            CSRWIDTH   : INTEGER := 32; -- 8|16|32|64
            -- Data interface data bus width
            DATAWIDTH  : INTEGER := 32; -- 8|16|32|64
            -- Data interface address width
            DATADEPTH  : INTEGER := 32; -- 8-32
            -- receive fifo depth
            RFIFODEPTH : INTEGER := 9;
            -- receive cache depth
            RCDEPTH    : INTEGER := 2
    );
    port (
            -------------------------- common -------------------------
            -- clock
            clk       : in  STD_LOGIC;
            -- reset
            rst       : in  STD_LOGIC;
            -- interrupt
            int       : out STD_LOGIC;
            -- gigabit mode selection
            gb        : out STD_LOGIC;
            
            ----------------------- csr interface ---------------------
            -- csr bus request
            csrreq    : in  STD_LOGIC;
            -- csr read / not write
            csrrw     : in  STD_LOGIC;
            -- csr byte enable
            csrbe     : in  STD_LOGIC_VECTOR(CSRWIDTH/8-1 downto 0);
            -- csr address bus
            csraddr   : in  STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
            -- csr data input bus
            csrdatai  : in  STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
            -- csr acknowledge
            csrack    : out STD_LOGIC;
            -- csr data output bus
            csrdatao  : out STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
            
            ---------------------- reset control ----------------------
            -- software reset output
            rstsofto  : out STD_LOGIC;
            
            ----------------------------- tc --------------------------
            -- transmit in progress
            tprog     : in  STD_LOGIC;
            -- interrupt request
            tireq     : in  STD_LOGIC;
            -- transmit underflow
            unf       : in  STD_LOGIC;
            -- transmit cycle size request
            tcsreq    : in  STD_LOGIC;
            -- interrupt acknowledge
            tiack     : out STD_LOGIC;
            -- transmit cycle size acknowledge
            tcsack    : out STD_LOGIC;
            -- full duplex mode
            fd        : out STD_LOGIC;
            
            --------------------------- tfifo -------------------------
            -- interrupt on completition
            ic        : in  STD_LOGIC;
            -- early transmit interrupt
            etireq    : in  STD_LOGIC;
            -- early transmit interrupt acknowledge
            etiack    : out STD_LOGIC;
            -- treshold mode
            tm        : out STD_LOGIC_VECTOR(2 downto 0);
            -- store and forward mode
            sf        : out STD_LOGIC;
            
            --------------------------- tlsm --------------------------
            -- setup frame processing
            tset      : in  STD_LOGIC;
            -- fetching transmit descriptor
            tdes      : in  STD_LOGIC;
            -- fetching transmit buffer
            tbuf      : in  STD_LOGIC;
            -- writing transmit descriptor status
            tstat     : in  STD_LOGIC;
            -- transmit buffer unavailable
            tu        : in  STD_LOGIC;
            -- transmit poll acknowledge
            tpollack  : in  STD_LOGIC;
            -- filtering type
            ft        : in  STD_LOGIC_VECTOR(1 downto 0);
            -- transmit poll demand
            tpoll     : out STD_LOGIC;
            -- transmit descriptor base address changed
            tdbadc    : out STD_LOGIC;
            -- transmit descriptor base address
            tdbad     : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            
            --------------------------- rc ----------------------------
            -- receive cycle size request
            rcsreq    : in  STD_LOGIC;
            -- receive in progress
            rprog     : in  STD_LOGIC;
            -- receive cycle size acknowledge
            rcsack    : out STD_LOGIC;
            -- receive enable
            ren       : out STD_LOGIC;
            -- receive all
            ra        : out STD_LOGIC;
            -- pass all multicast
            pm        : out STD_LOGIC;
            -- promiscous mode
            pr        : out STD_LOGIC;
            -- pas bad frames
            pb        : out STD_LOGIC;
            -- inverse filtering
            rif       : out STD_LOGIC;
            -- hash only filtering
            ho        : out STD_LOGIC;
            -- hash/perfect filtering
            hp        : out STD_LOGIC;
            
            ------------------- statistical counters ------------------
            -- clear fifo overflow counter acknowledge
            foclack   : in  STD_LOGIC;
            -- clear missed frames counter acknowledge
            mfclack   : in  STD_LOGIC;
            -- fifo overflow counter overflow
            oco       : in  STD_LOGIC;
            -- missed frames counter overflow
            mfo       : in  STD_LOGIC;
            -- fifo overflow counter grey coded
            focg      : in  STD_LOGIC_VECTOR(10 downto 0);
            -- missed frames counter grey coded
            mfcg      : in  STD_LOGIC_VECTOR(15 downto 0);
            -- clear fifo overflow counter request
            focl      : out STD_LOGIC;
            -- clear missed frames counter
            mfcl      : out STD_LOGIC;
            -- clear statistical counters
            clrscreq  : out STD_LOGIC;
            -- clear statistical counters acknowledge (after clearing) 
            clrscack  : in  STD_LOGIC;
            -- single receive SC clear
            sscclrr   : out STD_LOGIC;        
            -- single transmit SC clear
            sscclrt   : out STD_LOGIC;        
            -- statistical counters blocking acknowledge
            ackb      : in  STD_LOGIC;
            -- block statictical counters
            scblock   : out STD_LOGIC;        
            -- address for statistical transmit counter
            scadr     : out STD_LOGIC_VECTOR(3 downto 0);
            -- address for statistical receive counter
            scadt     : out STD_LOGIC_VECTOR(4 downto 0);
            -- receive statistical counter read data 
            scdr      : in  STD_LOGIC_VECTOR(31 downto 0);
            -- transmit statistical counter read data 
            scdt      : in  STD_LOGIC_VECTOR(31 downto 0);
            
            ----------------------------- rlsm ------------------------
            -- receive interrupt request
            rireq     : in  STD_LOGIC;
            -- early receive interrupt
            erireq    : in  STD_LOGIC;
            -- receive buffer unavailable
            ru        : in  STD_LOGIC;
            -- receive pool acknowledge
            rpollack  : in  STD_LOGIC;
            -- fetching receive descriptor
            rdes      : in  STD_LOGIC;
            -- fetching receive buffer
            rbuf      : in  STD_LOGIC;
            -- writing receive descriptor status
            rstat     : in  STD_LOGIC;
            -- receive interrupt acknowledge
            riack     : out STD_LOGIC;
            -- early receive interrupt acknowledge
            eriack    : out STD_LOGIC;
            -- receive pool demand
            rpoll     : out STD_LOGIC;
            -- receive descriptor base address changed
            rdbadc    : out STD_LOGIC;
            -- receive descriptor base address
            rdbad     : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            
            ---------------------------- dma --------------------------
            -- big / little endian selection
            ble       : out STD_LOGIC;
            -- descriptor byte ordering
            dbo       : out STD_LOGIC;
            -- transmit/receive priority
            priority  : out STD_LOGIC_VECTOR(1 downto 0);
            -- programmable burst length
            pbl       : out STD_LOGIC_VECTOR(5 downto 0);
            -- descriptor skip length
            dsl       : out STD_LOGIC_VECTOR(4 downto 0);
            
            ---------------- transmit power management ----------------
            -- tc component stopped
            stoptc     : in  STD_LOGIC;
            -- tlsm component stopped
            stoptlsm   : in  STD_LOGIC;
            -- tfifo component stopped
            stoptfifo  : in  STD_LOGIC;
            -- stop transmit request
            stopt      : out STD_LOGIC;
            -- transmit process stopped
            tps        : out STD_LOGIC;
            
            ---------------- transmit power management ----------------
            -- rc component stopped
            stoprc     : in  STD_LOGIC;
            -- rlsm component stopped
            stoprlsm   : in  STD_LOGIC;
            -- rfifo component stopped
            stoprfifo  : in  STD_LOGIC;
            -- stop receive request
            stopr      : out STD_LOGIC;
            -- receive process stopped
            rps        : out STD_LOGIC;
            
            ------------------------ flow control ---------------------
            -- transmit controller paused
            htp        : in  STD_LOGIC;
            -- pause request send
            prs        : in  STD_LOGIC;
            -- full-duplex flow control enable
            fce        : out STD_LOGIC;
            -- half-duplex flow control enable
            bpe        : out STD_LOGIC;
            -- transmit pause enable
            tpe        : out STD_LOGIC;
            -- transmit unpause enable
            tue        : out STD_LOGIC;
            -- receive pause enable
            rpe        : out STD_LOGIC;
            -- mac address
            macaddr    : out STD_LOGIC_VECTOR(47 downto 0);
            -- pause time
            pausetime  : out STD_LOGIC_VECTOR(15 downto 0);
            -- treshold level 1
            tresh1     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
            -- treshold level 2
            tresh2     : out STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
            -- treshold level 3
            tresh3     : out STD_LOGIC_VECTOR(RCDEPTH-1 downto 0);
            -- treshold level 4
            tresh4     : out STD_LOGIC_VECTOR(RCDEPTH-1 downto 0);
            
            -------------- serial micro-wire rom interface ------------
            -- rom data input
            sdi       : in  STD_LOGIC;
            -- rom clock
            sclk      : out STD_LOGIC;
            -- rom chip select
            scs       : out STD_LOGIC;
            -- rom data output
            sdo       : out STD_LOGIC;
            
            ----------------------- mii management --------------------
            -- mii management data input
            mdi       : in  STD_LOGIC;
            -- mii management clock
            mdc       : out STD_LOGIC;
            -- mii management data output
            mdo       : out STD_LOGIC;
            -- mii management tristate enable
            mden      : out STD_LOGIC;        
            -- MIISM register input signal --
            miismreginput  : out  STD_LOGIC_VECTOR (31 downto 0);
            -- MIISM register write signal --
            miismregwrite  : out  STD_LOGIC;
            -- MIISM register output signal --
            miismregoutput : in STD_LOGIC_VECTOR (31 downto 0)

    );
  end component;

  ---------------------------------------------------------------------
  -- Receive Controller
  ---------------------------------------------------------------------
  component RC
    generic (
              -- Depth of the FIFO
              FIFODEPTH : INTEGER := 9;
              -- Depth of the internal data path
              DATAWIDTH : INTEGER := 32 -- 8|16|32
    );
    port (
              ------------------------ common -------------------------
              -- clock
              clk       : in  STD_LOGIC;
              -- reset
              rst       : in  STD_LOGIC;
              -- gigabit mode selection
              gb        : in  STD_LOGIC;
              
              -------------------------- mii --------------------------
              -- collision detect
              col       : in  STD_LOGIC;
              -- mii data valid
              rxdv      : in  STD_LOGIC;
              -- mii error
              rxer      : in  STD_LOGIC;
              -- mii received data
              rxd       : in  STD_LOGIC_VECTOR(MIIWIDTH-1 downto 0);
              
              ------------------------ DP RAM -------------------------
              -- receive ram write enable
              ramwe     : out STD_LOGIC;
              -- receive ram write address
              ramaddr   : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
              -- receive ram write data
              ramdata   : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
              
              --------------------- filtering RAM ---------------------
              -- filtering ram data
              fdata     : in  STD_LOGIC_VECTOR(ADDRWIDTH-1 downto 0);
              -- filtering ram address
              faddr     : out STD_LOGIC_VECTOR(ADDRDEPTH-1 downto 0);
              
              ---------------------- fifo control ---------------------
              -- frame cache not full
              cachenf : in  STD_LOGIC;
              -- fifo read address grey coded
              radg    : in  STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
              -- fifo write address grey coded
              wadg    : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
              -- receive in progress
              rprog   : out STD_LOGIC;
              -- rc poll
              rcpoll  : out STD_LOGIC;
              
              
              -------------------- receive control --------------------
              -- interrupt acknowledge
              riack     : in  STD_LOGIC;
              -- receive enable
              ren       : in  STD_LOGIC;
              -- receive all
              ra        : in  STD_LOGIC;
              -- pass all multicast
              pm        : in  STD_LOGIC;
              -- promiscous mode
              pr        : in  STD_LOGIC;
              -- pass bad frames
              pb        : in  STD_LOGIC;
              -- inverse filtering mode
              rif       : in  STD_LOGIC;
              -- hash only filtering mode
              ho        : in  STD_LOGIC;
              -- hash/perfect filtering mode
              hp        : in  STD_LOGIC;
              -- interrupt request
              rireq     : out STD_LOGIC;
              -- filtering fail
              ff        : out STD_LOGIC;
              -- runt frame
              rf        : out STD_LOGIC;
              -- multicast frame
              mf        : out STD_LOGIC;
              -- broadcast frame
              bf        : out STD_LOGIC;
              -- dribbling bit
              db        : out STD_LOGIC;
              -- mii error
              re        : out STD_LOGIC;
              -- crc error
              ce        : out STD_LOGIC;
              -- too long
              tl        : out STD_LOGIC;
              -- frame type
              ftp       : out STD_LOGIC;
              -- fifo overflow
              ov        : out STD_LOGIC;
              -- collision seen
              cs        : out STD_LOGIC;
              -- length of frame
              length    : out STD_LOGIC_VECTOR(13 downto 0);
              
              ---------------- external address filtering -------------
              -- match input
              match      : in  STD_LOGIC;
              -- match valid
              matchval   : in  STD_LOGIC;
              -- match enable
              matchen    : out STD_LOGIC;
              -- match data
              matchdata  : out STD_LOGIC_VECTOR(47 downto 0);
              
              ------------------- statistical counters ----------------
              -- clear fifo overflow counter request
              focl      : in  STD_LOGIC;
              -- clear fifo overflow counter acknowledge
              foclack   : out STD_LOGIC;
              -- fifo overflow counter overflow
              oco       : out STD_LOGIC;
              -- fifo overflow counter grey coded
              focg      : out STD_LOGIC_VECTOR(10 downto 0);
              -- clear missed frames counter
              mfcl      : in  STD_LOGIC;
              -- clear missed frames counter acknowledge
              mfclack   : out STD_LOGIC;
              -- missed frames counter overflow
              mfo       : out STD_LOGIC;
              -- missed frames counter grey coded
              mfcg      : out STD_LOGIC_VECTOR(15 downto 0);
              
              ---------------------- power management -----------------
              -- stop input
              stopi     : in  STD_LOGIC;
              -- stop output
              stopo     : out STD_LOGIC;
              
              ------------------------ timers -------------------------
              -- cycle size acknowledge
              rcsack    : in  STD_LOGIC;
              -- cycle size request
              rcsreq    : out STD_LOGIC;

              ---------------------- flowcontrol ----------------------
              -- no space in fifo --
              fifofull  : out STD_LOGIC

    );
  end component;
  
  ---------------------------------------------------------------------
  -- Receive FIFO Controller
  ---------------------------------------------------------------------
  component RFIFO
    generic(
            -- Data interface data bus width
            DATAWIDTH  : INTEGER := 32; -- 8|16|32|64
            -- Data interface address bus width
            DATADEPTH  : INTEGER := 32;
            -- Depth of the FIFO memory
            FIFODEPTH  : INTEGER := 9;
            -- Depth of the frame cache for FIFO
            CACHEDEPTH : INTEGER := 2
    );
    port (  
            -------------------------- common -------------------------
            -- global clock
            clk       : in  STD_LOGIC;
            -- hardware reset
            rst       : in  STD_LOGIC;
            
            ------------------------- DP RAM --------------------------
            -- ram data
            ramdata  : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- ram address
            ramaddr  : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            
            -------------------------- RLSM ---------------------------
            -- fifo read enable
            fifore   : in  STD_LOGIC;
            -- filtering fail
            ffo      : out STD_LOGIC;
            -- runt frame
            rfo      : out STD_LOGIC;
            -- multicast frame
            mfo      : out STD_LOGIC;
            -- broadcast frame
            bfo      : out STD_LOGIC;
            -- frame too long
            tlo      : out STD_LOGIC;
            -- report on mii error
            reo      : out STD_LOGIC;
            -- dribbling bit
            dbo      : out STD_LOGIC;
            -- crc error
            ceo      : out STD_LOGIC;
            -- fifo overflow
            ovo      : out STD_LOGIC;
            -- collision seen
            cso      : out STD_LOGIC;
            -- frame length
            flo      : out STD_LOGIC_VECTOR(13 downto 0);
            -- fifo level
            flev     : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            -- fifo data
            fifodata : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            
            --------------------- frame status cache ------------------
            -- cache read enable
            cachere   : in  STD_LOGIC;
            -- cache not empty
            cachene   : out STD_LOGIC;
            
            ------------------------ RC control ------------------------
            -- frame status cache not full
            cachenf   : out STD_LOGIC;
            -- fifo read address grey coded
            radg      : out STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            -- frame cache level
            clev      : out STD_LOGIC_VECTOR(CACHEDEPTH-1 downto 0);
            
            ------------------------- RC status -----------------------
            -- interrupt request
            rireq     : in  STD_LOGIC;
            -- filtering fail
            ffi       : in  STD_LOGIC;
            -- runt frame
            rfi       : in  STD_LOGIC;
            -- multicast frame
            mfi       : in  STD_LOGIC;
            -- broadcast frame
            bfi       : in  STD_LOGIC;
            -- frame too long
            tli       : in  STD_LOGIC;
            -- report on mii/gmii error
            rei       : in  STD_LOGIC;
            -- dribbling bit
            dbi       : in  STD_LOGIC;
            -- crc error
            cei       : in  STD_LOGIC;
            -- fifo overflow
            ovi       : in  STD_LOGIC;
            -- collision seen
            csi       : in  STD_LOGIC;
            -- frame length
            fli       : in  STD_LOGIC_VECTOR(13 downto 0);
            -- fifo write address grey coded
            wadg      : in  STD_LOGIC_VECTOR(FIFODEPTH-1 downto 0);
            -- interrupt acknowledge
            riack     : out STD_LOGIC;
            
            --------------------- power management --------------------
            -- stop receive process input
            stopi    : in  STD_LOGIC;
            -- stop receive process output
            stopo    : out STD_LOGIC
    );
  end component;

  ---------------------------------------------------------------------
  -- Receive linked list management
  ---------------------------------------------------------------------
  component RLSM
    generic(
            -- Data interface data bus width
            DATAWIDTH : INTEGER := 32; -- 8|16|32|64
            -- Data interface address bus width
            DATADEPTH : INTEGER := 32;
            -- Depth of FIFO memory
            FIFODEPTH : INTEGER := 9
    );
    port (  
            ------------------------ common ---------------------------
            -- global clock
            clk       : in  STD_LOGIC;
            -- hardware reset
            rst       : in  STD_LOGIC;
            
            ------------------------- fifo ----------------------------
            -- fifo data
            fifodata  : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- fifo read enable
            fifore    : out STD_LOGIC;
            -- status cache read enable
            cachere   : out STD_LOGIC;
            
            -------------------------- dma ----------------------------
            -- single transfer acknowledge
            dmaack    : in  STD_LOGIC;
            -- end of burst
            dmaeob    : in  STD_LOGIC;
            -- data input
            dmadatai  : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- current burst address
            dmaaddr   : in  STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- request
            dmareq    : out STD_LOGIC;
            -- write selection
            dmawr     : out STD_LOGIC;
            -- transfer count
            dmacnt    : out STD_LOGIC_VECTOR(FIFODEPTH_MAX-1 downto 0);
            -- start address
            dmaaddro  : out STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- data output
            dmadatao  : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            
            --------------------- receive status ----------------------
            -- receive in progress
            rprog     : in  STD_LOGIC;
            -- rc poll
            rcpoll    : in  STD_LOGIC;
            -- frame cache not empty
            fifocne   : in  STD_LOGIC;
            -- filtering fail
            ff        : in  STD_LOGIC;
            -- runt frame
            rf        : in  STD_LOGIC;
            -- multicast frame
            mf        : in  STD_LOGIC;
            -- dribbling bit
            db        : in  STD_LOGIC;
            -- mii error
            re        : in  STD_LOGIC;
            -- crc error
            ce        : in  STD_LOGIC;
            -- frame too long
            tl        : in  STD_LOGIC;
            -- frame type
            ftp       : in  STD_LOGIC;
            -- fifo overflow
            ov        : in  STD_LOGIC;
            -- collision seen
            cs        : in  STD_LOGIC;
            -- length of frame
            length    : in  STD_LOGIC_VECTOR(13 downto 0);
            
            -------------------- csr configuration --------------------
            -- programmable burst length
            pbl       : in  STD_LOGIC_VECTOR(5 downto 0);
            -- descriptor skip length
            dsl       : in  STD_LOGIC_VECTOR(4 downto 0);
            -- receive poll demand
            rpoll     : in  STD_LOGIC;
            -- receive descriptor base address changed
            rdbadc    : in  STD_LOGIC;
            -- receive descriptors base address
            rdbad     : in  STD_LOGIC_VECTOR(DATADEPTH-1 downto 0);
            -- receive poll acknowledge
            rpollack  : out STD_LOGIC;
            
            ------------------------ csr status -----------------------
            -- receive completition acknowledge
            rcompack  : in  STD_LOGIC;
            -- buffer completition acknowledge
            bufack    : in  STD_LOGIC;
            -- fetching descriptor
            des       : out STD_LOGIC;
            -- fetching buffer
            fbuf      : out STD_LOGIC;
            -- writing descriptor status
            stat      : out STD_LOGIC;
            -- descriptor unavailable
            ru        : out STD_LOGIC;
            -- receive completition
            rcomp     : out STD_LOGIC;
            -- buffer completition
            bufcomp   : out STD_LOGIC;
            
            --------------------- power management --------------------
            -- stop receive process input
            stopi    : in  STD_LOGIC;
            -- stop receive process output
            stopo    : out STD_LOGIC
    );
  end component;
  
  ---------------------------------------------------------------------
  -- Reset controller
  ---------------------------------------------------------------------
  component RSTC
    port (
            ------------------------ clocks ---------------------------
            -- dma clock
            clkdma      : in  STD_LOGIC;
            -- csr clock
            clkcsr      : in  STD_LOGIC;
            -- transmit clock
            clkt        : in  STD_LOGIC;
            -- receive clock
            clkr        : in  STD_LOGIC;
            
            ------------------------- reset ---------------------------
            -- reset input
            rst         : in  STD_LOGIC;
            -- software reset
            rstsoft     : in  STD_LOGIC;
            -- flow control enable  --
            fce         : in  STD_LOGIC;      
            -- transmit reset
            rsttc       : out STD_LOGIC;
            -- receive reset
            rstrc       : out STD_LOGIC;
            -- dma reset output
            rstdma      : out STD_LOGIC;
            -- csr reset output
            rstcsr      : out STD_LOGIC;
            -- flow control reset in clkt domain --
            rstfct    : out STD_LOGIC;
            -- flow control reset in clkr domain --
            rstfcr    : out STD_LOGIC;
            -- back pressure reset --
            rstbp    : out STD_LOGIC   
            
    );
  end component;
 
  ---------------------------------------------------------------------
  -- MII Serial Management 
  ---------------------------------------------------------------------
  component MIISM  
    generic (
      CSRWIDTH  : INTEGER := 32
      );    
    port (
      -- global clock - HC synchronized --
      clk                     : in  STD_LOGIC;
      -- hardware reset --
      rst                     : in  STD_LOGIC;
      
      -- MIISM register input signal --
      miismreginput           : in  STD_LOGIC_VECTOR (31 downto 0);
      -- MIISM register write signal --
      miismregwrite           : in  STD_LOGIC;
      
      -- MIISM register output signal --
      miismregoutput          : out STD_LOGIC_VECTOR (31 downto 0);
      
      -- Management Data Clock --
      mdclk                   : out STD_LOGIC;
      -- Managment Data Output --
      mdioout                 : out STD_LOGIC;
      -- Managment Data High Impedance --
      mdioz                   : out STD_LOGIC;
      -- Managment Data Input --
      mdioin                  : in  STD_LOGIC
    );                      
  end component;

  ---------------------------------------------------------------------
  -- Statistical Counters    
  ---------------------------------------------------------------------
  component SC
    port (  
            ---------------------- Common ports -----------------------
            -- dma clock
            clk       : in  STD_LOGIC;
            -- dma clock domain reset
            rst       : in  STD_LOGIC;
            
            -------------------- CSR status signals -------------------
            --full duplex signal
            fdp       : in  STD_LOGIC;
            -- statistical counters blocking
            bsc       : in  STD_LOGIC;
            -- receive counters blocking acknowledge
            ackb      : out STD_LOGIC;
            
            --------------- clearing statistical counters -------------
            -- clear statistical counters
            clrscreq  : in  STD_LOGIC;
            -- clear statistical counters acknowledge (after clearing) 
            clrscack  : out STD_LOGIC;

            --------------- DP RAM receive counters -------------------
            -- read ram data for receive counters
            dir       : in  STD_LOGIC_VECTOR(31 downto 0);
            -- write enable for receive counters
            ramwer    : out STD_LOGIC;
            -- ram address for receive counters
            ar        : out STD_LOGIC_VECTOR(3 downto 0);
            -- ram data to be written for receive counters
            dor       : out STD_LOGIC_VECTOR(31 downto 0);

            --------------- DP RAM transmit counters ------------------
            -- read ram data for transmit counters
            dit       : in  STD_LOGIC_VECTOR(31 downto 0);
            -- write enable for transmit counters
            ramwet    : out STD_LOGIC;
            -- ram address for transmit counters
            at        : out STD_LOGIC_VECTOR(4 downto 0);
            -- ram data to be written for transmit counters
            dot       : out STD_LOGIC_VECTOR(31 downto 0);
                        
            ------------------- rx status signals ---------------------
            -- write received frame status data 
            wsr       : in  STD_LOGIC;
            -- received frame length
            flr       : in  STD_LOGIC_VECTOR(13 downto 0);
            -- multicast frame
            mfr       : in  STD_LOGIC;
            -- broadcast frame
            bfr       : in  STD_LOGIC;
            -- too long frame
            tl        : in  STD_LOGIC;
            -- runt frame
            rf        : in  STD_LOGIC; 
            -- alignement error
            ae        : in  STD_LOGIC; 
            -- crc error
            ce        : in  STD_LOGIC; 
            -- pause frame
            pfr       : in  STD_LOGIC;

            ------------------- tx status signals ---------------------
            -- write transmitted frame status data 
            wst       : in  STD_LOGIC;
            -- received frame length
            flt       : in  STD_LOGIC_VECTOR(13 downto 0);
            -- multicast frame
            mft       : in  STD_LOGIC;
            -- broadcast frame
            bft       : in  STD_LOGIC;
            -- colission number
            cn        : in  STD_LOGIC_VECTOR(3 downto 0);
            -- deffered frame
            df        : in  STD_LOGIC;
            -- loss of carrier
            cl        : in  STD_LOGIC;
            -- no carrier
            nc        : in  STD_LOGIC;
            -- late collision
            lc        : in  STD_LOGIC;
            -- excessive collisions
            ec        : in  STD_LOGIC;
            -- underrun fifo
            ur        : in STD_LOGIC;
            -- pause frame
            pft       : in  STD_LOGIC
  );
  end component; --SC
  
  -------------------------------------------------
  --  Flow control in receive clk domain
  -------------------------------------------------

  component FCR 
    generic (
            -- Data interface data bus width --
            DATAWIDTH : INTEGER := 32;  
            -- depth of receive FIFO memory --
            RFIFODEPTH   : INTEGER := 9;
            -- receive cache depth
            RCDEPTH  : INTEGER := 5
            );
    port (
            -- receive clock --
            clkr                    : in  STD_LOGIC; 
            -- flow control reset in rc domain
            rstfcr                  : in  STD_LOGIC;
            -- incoming data stream --
            irwdata                 : in  STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- data stream write signal --
            irwe                    : in  STD_LOGIC;  
            -- receive progress --
            rcpoll                  : in  STD_LOGIC;
            -- dribbling bit error
            db                      : in  STD_LOGIC;
            -- mii error error
            re                      : in  STD_LOGIC;
            -- crc error
            ce                      : in  STD_LOGIC;
            -- too long error
            tl                      : in  STD_LOGIC;
            -- fifo overflow error
            ov                      : in  STD_LOGIC;
            -- ri request
            rireq                   : in  STD_LOGIC; 
            -- hardware address --
            macaddr                 : in  STD_LOGIC_VECTOR(47 downto 0);  
            -- receive pause frames enable
            rpe                     : in  STD_LOGIC;
            -- full duplex --
            fd                      : in  STD_LOGIC;
            -- gigabit mode --
            gb                      : in  STD_LOGIC;
            -- flow control enable --
            fce                     : in  STD_LOGIC;
            -- host transmition paused --
            htp                     : out STD_LOGIC;
            -- fifo usage level --
            flev                    : in  STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
            -- fifo usage pause treshold level --
            fptl                    : in  STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
            -- fifo usage restart treshold level --
            frtl                    : in  STD_LOGIC_VECTOR(RFIFODEPTH-1 downto 0);
            -- cache usage level --
            clev                    : in  STD_LOGIC_VECTOR(RCDEPTH-1 downto 0);
            -- cache usage pause treshold level --
            cptl                    : in  STD_LOGIC_VECTOR(RCDEPTH-1 downto 0);
            -- cache usage restart treshold level --
            crtl                    : in  STD_LOGIC_VECTOR(RCDEPTH-1 downto 0);
            -- fifo almost full
            faf                     : out STD_LOGIC;
            -- fifo almost empty
            fae                     : out STD_LOGIC;
            -- cache almost full
            caf                     : out STD_LOGIC;
            -- cache almost empty
            cae                     : out STD_LOGIC;
            -- rx control pause counter inc ack
            rxctrlpause_ack         : in  STD_LOGIC;
            -- rx control bad opcode counter inc ack
            rxctrlbadop_ack         : in  STD_LOGIC;
            -- rx control pause counter inc req
            rxctrlpause_req         : out STD_LOGIC;
            -- rx control bad opcode counter inc req
            rxctrlbadop_req         : out STD_LOGIC  
            );    
    end component;

  -------------------------------------------------
  --  Flow control in transmit clk domain
  -------------------------------------------------
  component FCT 
  generic (     
        -- Data interface data bus width --
        DATAWIDTH    : INTEGER := 32
          );
  port (        
            -- transmit clock 
            clkt                    : in  STD_LOGIC; 
            -- flow control reset in tc domain
            rstfct                  : in  STD_LOGIC; 
            -- hardware address --
            macaddr                 : in  STD_LOGIC_VECTOR(47 downto 0);
            -- pause time --
            pausetime               : in  STD_LOGIC_VECTOR(15 downto 0);
            -- transmit pause frames enable
            tpe                     : in  STD_LOGIC;
            -- transmit unpause frames enable
            tue                     : in  STD_LOGIC;
            -- full duplex 
            fd                      : in  STD_LOGIC;
            -- gigabit mode 
            gb                      : in  STD_LOGIC;
            -- flow control enable --
            fce                     : in  STD_LOGIC;
            -- fifo almost full
            faf                     : in  STD_LOGIC;
            -- fifo almost empty
            fae                     : in  STD_LOGIC;
            -- cache almost full
            caf                     : in  STD_LOGIC;
            -- cache almost empty
            cae                     : in  STD_LOGIC;   
            -- control read enable --
            ctrlre                  : in  STD_LOGIC;
            -- transmitter idle
            tsmidle                 : in  STD_LOGIC;
            -- control data --
            ctrldata                : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
            -- pause request --
            pausereq                : out STD_LOGIC; 
            -- pause request send --
            prs                     : out STD_LOGIC;
            -- tx control pause counter inc ack
            txctrlpause_ack         : in  STD_LOGIC;
            -- tx control pause counter inc req
            txctrlpause_req         : out STD_LOGIC
              );
  end component;  
  
  -------------------------------------------------
  --  Flow control - statistical counters driver --
  -------------------------------------------------
  component FCSTAT
  port (                                                                       
              -- clk --
              clkdma                 :  in STD_LOGIC;
              -- reset --
              rstdma                 :  in STD_LOGIC;
              -- Tx control pause counter request
              txctrlpause_req        :  in STD_LOGIC;
              -- Rx control pause counter request
              rxctrlpause_req        :  in STD_LOGIC;
              -- Rx control bad opcode counter request
              rxctrlbadop_req        :  in STD_LOGIC;
              -- Tx control pause counter acknowledge
              txctrlpause_ack        : out STD_LOGIC;
              -- Rx control pause counter acknowledge
              rxctrlpause_ack        : out STD_LOGIC;
              -- Rx control bad opcode counter acknowledge
              rxctrlbadop_ack        : out STD_LOGIC;
              -- Tx control pause counter acknowledge
              txctrlpause            : out STD_LOGIC;
              -- Rx control pause counter acknowledge
              rxctrlpause            : out STD_LOGIC;
              -- Rx control bad opcode counter acknowledge
              rxctrlbadop            : out STD_LOGIC
             );
  end component;
  
  
  -------------------------------------------------
  --  Back pressure
  -------------------------------------------------
  
  component BP
  port(
            -- transmit clock
            clkt                   : in  STD_LOGIC;
            -- reset
            rstbp                   : in  STD_LOGIC; 
            -- full duplex mode ---
            fd                      : in  STD_LOGIC;
            -- back pressure enable --
            bpe                     : in  STD_LOGIC;
            -- transmit enable --
            rxdv                    : in  STD_LOGIC;
            -- fifo full
            fifofull                : in  STD_LOGIC;
            -- receive cache not full
            rcachenf                : in  STD_LOGIC; 
            -- back pressure transmit enable --
            txenbp                  : out STD_LOGIC
            );
  end component;

--  -------------------------------------------------
--  -- MII Serial Management
--  ------------------------------------------------- 
--  component MIISM  
--    generic (
--      CSRWIDTH  : INTEGER := 32
--      );    
--    port (
--      -- global clock - HC synchronized --
--      clk                     : in  STD_LOGIC;
--      -- hardware reset --
--      rst                     : in  STD_LOGIC;
--      
--      -- MIISM register input signal --
--      miismreginput           : in  STD_LOGIC_VECTOR (31 downto 0);
--      -- MIISM register write signal --
--      miismregwrite           : in  STD_LOGIC;
--      
--      -- MIISM register output signal --
--      miismregoutput          : out STD_LOGIC_VECTOR (31 downto 0);
--      
--      -- Management Data Clock --
--      mdclk                   : out STD_LOGIC;
--      -- Managment Data Output --
--      mdioout                 : out STD_LOGIC;
--      -- Managment Data High Impedance --
--      mdioz                   : out STD_LOGIC;
--      -- Managment Data Input --
--      mdioin                  : in  STD_LOGIC  
--    );                      
--  end component;-- MIISM;
  
  
begin

  ---------------------------------------------------------------------
  -- Direct Memory Access Controller
  ---------------------------------------------------------------------
  U_DMA : DMA
    generic map(
            DATAWIDTH   => DATAWIDTH,
            DATADEPTH   => DATADEPTH
    )
    port map(  
            ------------------------- common --------------------------
            clk         => clkdma,
            rst         => rstdma,
            
            ---------------------- configuration ----------------------
            priority    => priority,
            ble         => ble,
            dbo         => dbo,
            rdes        => rdes,
            rbuf        => rbuf,
            rstat       => rstat,
            tdes        => tdes,
            tbuf        => tbuf,
            tstat       => tstat,
            
            ---------------------- data interface ---------------------
            dataack     => dataack,
            datai       => datai,
            datareq     => datareq,
            datareqc    => datareqc,
            datarw      => datarw,
            dataeob     => dataeob,
            dataeobc    => dataeobc,
            datao       => datao,
            dataaddr    => dataaddr,
            idataaddr   => idataaddr,
            
            ------------------------- channel 1 -----------------------
            req1        => treq,
            write1      => twrite,
            tcnt1       => tcnt,
            addr1       => taddr,
            datai1      => tdatao,
            ack1        => tack,
            eob1        => teob,
            datao1      => tdatai,
            
            ------------------------- channel 2 -----------------------
            req2        => rreq,
            write2      => rwrite,
            tcnt2       => rcnt,
            addr2       => raddr,
            datai2      => rdatao,
            ack2        => rack,
            eob2        => reob,
            datao2      => rdatai
    );

  ---------------------------------------------------------------------
  -- Transmit linked List Management
  ---------------------------------------------------------------------
  U_TLSM : TLSM
    generic map (
            DATAWIDTH  => DATAWIDTH,
            DATADEPTH  => DATADEPTH,
            FIFODEPTH  => TFIFODEPTH
    )
    port map(  
            ---------------------- common ports -----------------------
            clk        => clkdma,
            rst        => rstdma,
            
            ----------------- transmit FIFO control -------------------
            fifonf     => tfifonf,
            fifocnf    => tfifocnf,
            fifoval    => tfifoval,
            fifowe     => tfifowe,
            fifoeof    => tfifoeof,
            fifobe     => tfifobe,
            fifodata   => tfifodata,
            fifolev    => tfifolev,
            
            ----------------- transmit configuration ------------------
            ic         => ici,
            ac         => aci,
            dpd        => dpdi,
            statado    => statadi,
            
            -------------------- transmit status ----------------------
            csne       => tcsne,
            lo         => lo_i,
            nc         => nc_i,
            lc         => lc_i,
            ec         => ec_i,
            de         => de_i,
            ur         => ur_i,
            cc         => cc_i,
            cachere    => tcachere,
            statadi    => statado,
            
            --------------------------- dma ---------------------------
            dmaack     => tack,
            dmaeob     => teob,
            dmadatai   => tdatai,
            dmaaddr    => idataaddr,
            dmareq     => treq,
            dmawr      => twrite,
            dmacnt     => tcnt,
            dmaaddro   => taddr,
            dmadatao   => tdatao,
            
            --------------------- address DP RAM ----------------------
            fwe        => fwe,
            fdata      => fwdata,
            faddr      => fwaddr,
            
            ------------------ csr configuration data -----------------
            dsl        => dsl,
            pbl        => pbl,
            poll       => tpoll,
            dbadc      => tdbadc,
            dbad       => tdbad,
            pollack    => tpollack,
            
            --------------------- csr status data ---------------------
            tcompack   => tcompack,
            tcomp      => tcomp,
            des        => tdes,
            fbuf       => tbuf,
            stat       => tstat,
            setp       => tset,
            tu         => tu,
            ft         => ft,
            
            --------------------- power management --------------------
            stopi      => stopt,
            stopo      => stoptlsm
    );

  ---------------------------------------------------------------------
  -- Transmit FIFO
  ---------------------------------------------------------------------
  U_TFIFO : TFIFO
    generic map (
            DATAWIDTH  => DATAWIDTH,
            DATADEPTH  => DATADEPTH,
            FIFODEPTH  => TFIFODEPTH,
            CACHEDEPTH => TCDEPTH
    )
    port map (  
            ------------------------- Common --------------------------
            clk       => clkdma,
            rst       => rstdma,
            
            ------------------------- DP RAM --------------------------
            ramwe     => twe,
            ramaddr   => twaddr,
            ramdata   => twdata,
            
            -------------------------- tlsm ---------------------------
            fifowe    => tfifowe,
            fifoeof   => tfifoeof,
            fifobe    => tfifobe,
            fifodata  => tfifodata,
            fifonf    => tfifonf,
            fifocnf   => tfifocnf,
            fifoval   => tfifoval,
            flev      => tfifolev,
            
            ------------------ frame configuration cache --------------
            ici       => ici,
            dpdi      => dpdi,
            aci       => aci,
            statadi   => statadi,
            
            --------------------- frame status cache ------------------
            cachere   => tcachere,
            mfo       => tmf_i,
            bfo       => tbf_i,
            deo       => de_i,
            lco       => lc_i,
            loo       => lo_i,
            nco       => nc_i,
            eco       => ec_i,
            ico       => ic,
            uro       => ur_i,
            csne      => tcsne,
            cco       => cc_i,
            toco      => toc_i,
            statado   => statado,
            
            ------------------------ tc control -----------------------
            sofreq    => sofreq,
            eofreq    => eofreq,
            dpdo      => dpd,
            aco       => ac,
            beo       => be,
            eofad     => eofad,
            wadg      => twadg,
            
            ------------------------- tc status -----------------------
            tireq     => tireq,
            winp      => winp,
            mfi       => tmf_o,
            bfi       => tbf_o,
            dei       => de_o,
            lci       => lc_o,
            loi       => lo_o,
            nci       => nc_o,
            eci       => ec_o,
            toci      => toc_o,
            uri       => ur_o,
            cci       => cc_o,
            radg      => tradg,
            tiack     => tiack,
            
            ------------------ CSR configuration data -----------------
            sf        => sf,
            fdp       => fd,
            tm        => tm,
            pbl       => pbl,
            
            ----------------------- CSR status ------------------------
            etiack    => etiack,
            etireq    => etireq,
            
            --------------------- power management --------------------
            stopi     => stopt,
            stopo     => stoptfifo
    );
  
  ---------------------------------------------------------------------
  -- Transmit controller
  ---------------------------------------------------------------------
  U_TC : TC
    generic map(
              FIFODEPTH => TFIFODEPTH,
              DATAWIDTH => DATAWIDTH
    )
    port map(
              ------------------------ common -------------------------
              clk       => clkt,
              rst       => rsttc,
              gb        => gb,
              
              -------------------------- mii --------------------------
              txen      => txen_i,
              txer      => txer,
              txd       => txd,
              
              ------------------------ DP RAM -------------------------
              ramdata   => trdata,
              ramaddr   => traddr,
              
              ---------------------- fifo control ---------------------
              wadg      => twadg,
              radg      => tradg,
              
              -------------------- transmit control -------------------
              dpd       => dpd,
              ac        => ac,
              sofreq    => sofreq,
              eofreq    => eofreq,
              tiack     => tiack,
              lastbe    => be,
              eofadg    => eofad,
              tireq     => tireq,
              ur        => ur_o,
              de        => de_o,
              
              ------------------ half duplex procedures ---------------
              coll      => coll,
              carrier   => carrier,
              bkoff     => bkoff,
              tpend     => tpend,
              tprog     => tprog,
              preamble  => preamble,
              crco      => crc,
              
              ----------------------- flow control --------------------
              htp       => htp,
              ctrl      => pausereq,
              ctrldata  => ctrldata,
              ctrlre    => ctrlre,
              tsmidle   => tsmidle,   
              
              ------------------- statistical counters ----------------
              mf        => tmf_o,
              bf        => tbf_o,
              toc       => toc_o,
              
              ---------------------- power management -----------------
              stopi     => stopt,
              stopo     => stoptc,
              
              ------------------------- timers ------------------------
              tcsack    => tcsack,
              tcsreq    => tcsreq
    );

-- BD disable comment
    -------------------------------------------------------------------
    -- Backoff and deferring procedures
    -------------------------------------------------------------------
    U_BD : BD
      port map(
                clk       => clkt,
                rst       => rsttc,
                gb        => gb,
                col       => col,
                crs       => crs,
                fdp       => fd,
                tprog     => tprog,
                preamble  => preamble,
                tpend     => tpend,
                winp      => winp,
                tiack     => tiack,
                coll      => coll,
                carrier   => carrier,
                bkoff     => bkoff,
                lc        => lc_o,
                lo        => lo_o,
                nc        => nc_o,
                ec        => ec_o,
                cc        => cc_o,
                crc       => crc
      );
-- BD disable comment

-- BD disable uncomment
--  
--  -------------------------------------------------------------------
--  -- deferring disabled
--  -------------------------------------------------------------------
--  defer_drv:
--    defer <= '0';
--  
--  -------------------------------------------------------------------
--  -- backoff disabled
--  -------------------------------------------------------------------
--  bkoff_drv:
--    bkoff <= '0';
--  
--  -------------------------------------------------------------------
--  -- retry transmission disabled
--  -------------------------------------------------------------------
--  retry_drv:
--    retry <= '0';
--  
--  -------------------------------------------------------------------
--  -- collision detection disabled
--  -------------------------------------------------------------------
--  coll_drv:
--    coll  <= '0';
--  
--  -------------------------------------------------------------------
--  -- late collision detection disabled
--  -------------------------------------------------------------------
--  lc_drv:
--    lc_o  <= '0';
--  
--  -------------------------------------------------------------------
--  -- loss of carrier detection disabled
--  -------------------------------------------------------------------
--  lo_drv:
--    lo_o  <= '0';
--  
--  -------------------------------------------------------------------
--  -- no carrier detection disabled
--  -------------------------------------------------------------------
--  nc_drv:
--    nc_o  <= '0';
--  
--  -------------------------------------------------------------------
--  -- excessive collision detection disabled
--  -------------------------------------------------------------------
--  ec_drv:
--    ec_o  <= '0';
--  
--  -------------------------------------------------------------------
--  -- collision counter disabled
--  -------------------------------------------------------------------
--  cc_drv:
--    cc_o  <= (others=>'0');
-- BD disable uncomment
      
    
      
    -------------------------------------------------------------------
    -- Receive Controller
    -------------------------------------------------------------------
    U_RC : RC
      generic map(
              FIFODEPTH => RFIFODEPTH,
              DATAWIDTH => DATAWIDTH
      )
      port map(
              ------------------------ common -------------------------
              clk       => clkr,
              rst       => rstrc,
              gb        => gb,
              
              -------------------------- mii --------------------------
              col       => col,
              rxdv      => rxdv,
              rxer      => rxer,
              rxd       => rxd,
              
              ------------------------ dp ram -------------------------
              ramwe     => irwe,
              ramaddr   => rwaddr,
              ramdata   => irwdata,
              
              --------------------- filtering RAM ---------------------
              fdata     => frdata,
              faddr     => fraddr,
              
              ---------------------- fifo control ---------------------
              cachenf   => rcachenf,
              radg      => rradg,
              wadg      => rwadg,
              rprog     => rprog,
              rcpoll    => rcpoll,
              
              -------------------- receive control --------------------
              riack     => riack,
              ren       => ren,
              ra        => ra,
              pm        => pm,
              pr        => pr,
              pb        => pb,
              rif       => rif,
              ho        => ho,
              hp        => hp,
              rireq     => rireq,
              ff        => ff,
              rf        => rf,
              mf        => rmf,
              bf        => rbf,
              db        => db,
              re        => re,
              ce        => ce,
              tl        => tl,
              ftp       => ftp,
              ov        => ov,
              cs        => cs,
              length    => length,
              
              ---------------- external address filtering -------------
              match     => match,
              matchval  => matchval,
              matchen   => matchen,
              matchdata => matchdata,
              
              ------------------- statistical counters ----------------
              focl      => focl,
              foclack   => foclack,
              oco       => oco,
              focg      => focg,
              mfcl      => mfcl,
              mfclack   => mfclack,
              mfo       => mfo,
              mfcg      => mfcg,
              
              --------------------- power management ------------------
              stopi     => stopr,
              stopo     => stoprc,
              
              ------------------------- timers ------------------------
              rcsack    => rcsack,
              rcsreq    => rcsreq,

            
            ------------------------flow control --------------------
            fifofull  => fifofull
   );

    -------------------------------------------------------------------
    -- Receive FIFO Controller
    -------------------------------------------------------------------
    U_RFIFO : RFIFO
    generic map(
            DATAWIDTH  => DATAWIDTH,
            DATADEPTH  => DATADEPTH,
            FIFODEPTH  => RFIFODEPTH,
            CACHEDEPTH => RCDEPTH
    )
    port map(
            ------------------------- common --------------------------
            clk       => clkdma,
            rst       => rstdma,
            
            ------------------------- dp ram --------------------------
            ramdata   => rrdata,
            ramaddr   => rraddr,
            
            -------------------------- rlsm ---------------------------
            fifore    => rfifore,
            ffo       => ff_o,
            rfo       => rf_o,
            mfo       => rmf_o,
            bfo       => rbf_o,
            tlo       => tl_o,
            reo       => re_o,
            dbo       => db_o,
            ceo       => ce_o,
            ovo       => ov_o,
            cso       => cs_o,
            flo       => fl_o,
            fifodata  => rfifodata,
            
            --------------------- frame status cache ------------------
            cachere   => rcachere,
            cachene   => rcachene,
            
            ------------------------ rc control -----------------------
            cachenf   => rcachenf,
            radg      => rradg,
            clev      => clev,
            flev      => rflev,
            
            ------------------------- rc status -----------------------
            rireq     => rireq,
            ffi       => ff,
            rfi       => rf,
            mfi       => rmf,
            bfi       => rbf,
            tli       => tl,
            rei       => re,
            dbi       => db,
            cei       => ce,
            ovi       => ov,
            csi       => cs,
            fli       => length,
            wadg      => rwadg,
            riack     => riack,
            
            --------------------- power management --------------------
            stopi     => stopr,
            stopo     => stoprfifo
    );
    
    -------------------------------------------------------------------
    -- Receive linked list management
    -------------------------------------------------------------------
    U_RLSM : RLSM
    generic map(
            DATAWIDTH => DATAWIDTH,
            DATADEPTH => DATADEPTH,
            FIFODEPTH => RFIFODEPTH
    )
    port map(  
            ------------------------ common ---------------------------
            clk       => clkdma,
            rst       => rstdma,
            
            ------------------------- fifo ----------------------------
            fifodata  => rfifodata,
            fifore    => rfifore,
            cachere   => rcachere,
            
            -------------------------- dma ----------------------------
            dmaack    => rack,
            dmaeob    => reob,
            dmadatai  => rdatai,
            dmaaddr   => idataaddr,
            dmareq    => rreq,
            dmawr     => rwrite,
            dmacnt    => rcnt,
            dmaaddro  => raddr,
            dmadatao  => rdatao,
            
            --------------------- receive status ----------------------
            rprog     => rprog,
            rcpoll    => rcpoll,
            fifocne   => rcachene,
            ff        => ff_o,
            rf        => rf_o,
            mf        => rmf_o,
            db        => db_o,
            re        => re_o,
            ce        => ce_o,
            tl        => tl_o,
            ftp       => ftp,
            ov        => ov_o,
            cs        => cs_o,
            length    => fl_o,

            -------------------- csr configuration --------------------
            pbl       => pbl,
            dsl       => dsl,
            rpoll     => rpoll,
            rdbadc    => rdbadc,
            rdbad     => rdbad,
            rpollack  => rpollack,
            
            ------------------------ csr status -----------------------
            bufack    => eriack,
            rcompack  => rcompack,
            des       => rdes,
            fbuf      => rbuf,
            stat      => rstat,
            ru        => ru,
            rcomp     => rcomp,
            bufcomp   => erireq,
            
            --------------------- power management --------------------
            stopi     => stopr,
            stopo     => stoprlsm
    );
    
    -------------------------------------------------------------------
    -- Control and Status Registers
    -------------------------------------------------------------------
    U_CSR : CSR
    generic map(
            CSRWIDTH   => CSRWIDTH,
            DATAWIDTH  => DATAWIDTH,
            DATADEPTH  => DATADEPTH,
            RFIFODEPTH => RFIFODEPTH,
            RCDEPTH    => RCDEPTH
    )
    port map(
            -------------------------- common -------------------------
            clk       => clkcsr,
            rst       => rstcsr,
            int       => int,
            gb        => gb,
            
            ----------------------- reset control ---------------------
            rstsofto  => rstsoft,
            
            ----------------------- csr interface ---------------------
            csrreq    => csrreq,
            csrrw     => csrrw,
            csrbe     => csrbe,
            csraddr   => csraddr,
            csrdatai  => csrdatai,
            csrack    => csrack,
            csrdatao  => csrdatao,
            
            ----------------------------- tc --------------------------
            tprog     => tprog,
            tireq     => tcomp,
            unf       => ur_i,
            tiack     => tcompack,
            tcsreq    => tcsreq,
            tcsack    => tcsack,
            fd        => fd,
            
            --------------------------- tfifo -------------------------
            ic        => ic,
            etireq    => etireq,
            etiack    => etiack,
            tm        => tm,
            sf        => sf,
            
            --------------------------- tlsm --------------------------
            tset      => tset,
            tdes      => tdes,
            tbuf      => tbuf,
            tstat     => tstat,
            tu        => tu,
            tpollack  => tpollack,
            ft        => ft,
            tpoll     => tpoll,
            tdbadc    => tdbadc,
            tdbad     => tdbad,
            
            --------------------------- rc ----------------------------
            rireq     => rcomp,
            rcsreq    => rcsreq,
            rprog     => rprog,
            riack     => rcompack,
            rcsack    => rcsack,
            ren       => ren,
            ra        => ra,
            pm        => pm,
            pr        => pr,
            pb        => pb,
            rif       => rif,
            ho        => ho,
            hp        => hp,

            ------------------- statistical counters ------------------
            foclack   => foclack,
            mfclack   => mfclack,
            oco       => oco,
            mfo       => mfo,
            focg      => focg,
            mfcg      => mfcg,
            focl      => focl,
            mfcl      => mfcl,
            clrscreq  => clrscreq,
            clrscack  => clrscack,
            sscclrr   => sscclrr,
            sscclrt   => sscclrt,
            ackb      => ackb,
            scblock   => scblock,
            scadr     => scadr,
            scadt     => scadt,
            scdr      => scdr,
            scdt      => scdt,
            
            ---------------------------- rlsm -------------------------
            erireq    => erireq,
            ru        => ru,
            rpollack  => rpollack,
            rdes      => rdes,
            rbuf      => rbuf,
            rstat     => rstat,
            eriack    => eriack,
            rpoll     => rpoll,
            rdbadc    => rdbadc,
            rdbad     => rdbad,
            
            ---------------------------- dma --------------------------
            ble       => ble,
            dbo       => dbo,
            priority  => priority,
            pbl       => pbl,
            dsl       => dsl,
            
            ---------------- transmit power management ----------------
            stoptc    => stoptc,
            stoptlsm  => stoptlsm,
            stoptfifo => stoptfifo,
            stopt     => stopt,
            tps       => tps,
            
            ---------------- transmit power management ----------------
            stoprc    => stoprc,
            stoprlsm  => stoprlsm,
            stoprfifo => stoprfifo,
            stopr     => stopr,
            rps       => rps,
            
            -------------- serial micro-wire rom interface ------------
            sdi       => sdi,
            sclk      => sclk,
            scs       => scs,
            sdo       => sdo,
            
            ---------------- flow control ---------------------
            htp       => htp,
            prs       => prs,
            fce       => fce,
            bpe       => bpe,
            tpe       => tpe,
            tue       => tue,
            rpe       => rpe,
            macaddr   => macaddr,
            pausetime => pausetime,
            tresh1    => tresh1,
            tresh2    => tresh2,
            tresh3    => tresh3,
            tresh4    => tresh4,

            --------------------- mii management --------------------- 
            -- software mii - not connetcetd --
            mdi       => noconnect_mdi,
            mdc       => noconnect_mdc,
            mdo       => noconnect_mdo,
            mden      => noconnect_mden,
            -- NEW - connected --
            miismreginput  => miismreginput,
            miismregwrite  => miismregwrite,
            miismregoutput => miismregoutput
    );

  ---------------------------------------------------------------------
  -- Reset controller
  ---------------------------------------------------------------------
  U_RSTC : RSTC
    port map (
            ------------------------ clocks ---------------------------
            clkdma      => clkdma,
            clkcsr      => clkcsr,
            clkt        => clkt,
            clkr        => clkr,
            
            ------------------------- reset ---------------------------
            rst         => rst,
            rstsoft     => rstsoft,
            fce         => fce,
            rsttc       => rsttc,
            rstrc       => rstrc,
            rstdma      => rstdma,
            rstcsr      => rstcsr,
            rstfcr      => rstfcr,
            rstfct      => rstfct,
            rstbp       => rstbp
    );

  ---------------------------------------------------------------------
  -- MII Serial Management
  ---------------------------------------------------------------------            
    U_MIISM:MIISM  
          generic map(
            CSRWIDTH   => CSRWIDTH )
          port map (  
            clk             => clkcsr, 
            rst             => rstcsr,
            miismreginput   => miismreginput,
            miismregwrite   => miismregwrite,
            miismregoutput  => miismregoutput,
            mdclk           => mdc,
            mdioout         => mdo,
            mdioz           => mden,
            mdioin          => mdi
    );
  
  ---------------------------------------------------------------------
  -- Flow control in clkr domain
  ---------------------------------------------------------------------
  U_FCR : FCR
    generic map (
            DATAWIDTH   => DATAWIDTH, 
            RFIFODEPTH  => RFIFODEPTH,
            RCDEPTH     => RCDEPTH
    )
    port map (
            clkr        => clkr,
            rstfcr      => rstfcr,
            irwdata     => irwdata,
            irwe        => irwe,
            rcpoll      => rcpoll,
            db          => db,
            re          => re,
            ce          => ce,
            tl          => tl, 
            ov          => ov,
            rireq       => rireq, 
            macaddr     => macaddr, 
            rpe         => rpe,
            fd          => fd,
            gb          => gb,
            fce         => fce,
            htp         => htp,
            flev        => rflev,
            fptl        => tresh2,
            frtl        => tresh1,
            clev        => clev,
            cptl        => tresh4,
            crtl        => tresh3, 
            faf         => faf,
            fae         => fae,
            caf         => caf,
            cae         => cae,
            rxctrlpause_ack => rxctrlpause_ack,
            rxctrlbadop_ack => rxctrlbadop_ack,
            rxctrlpause_req => rxctrlpause_req,
            rxctrlbadop_req => rxctrlbadop_req
            
    );    
   
  ---------------------------------------------------------------------
  -- Flow control in clkt domain
  ---------------------------------------------------------------------
  U_FCT : FCT
    generic map(
            DATAWIDTH   => DATAWIDTH )
    port map (
            clkt        => clkt,
            rstfct      => rstfct,
            macaddr     => macaddr,
            pausetime   => pausetime,
            tpe         => tpe,
            tue         => tue,      
            fd          => fd,
            gb          => gb,
            fce         => fce,
            faf         => faf,
            fae         => fae,
            caf         => caf,
            cae         => cae,
            ctrlre      => ctrlre,
            tsmidle     => tsmidle,
            ctrldata    => ctrldata,
            pausereq    => pausereq,
            prs         => prs,
            txctrlpause_ack => txctrlpause_ack,
            txctrlpause_req => txctrlpause_req
            );    

  ---------------------------------------------------------------------
  -- Flow control - statistical counters driver
  ---------------------------------------------------------------------
  
      U_FCSTAT: FCSTAT
      port map (                                                                       
            clkdma           => clkdma,
            rstdma           => rstdma,
            txctrlpause_req  => txctrlpause_req,
            rxctrlpause_req  => rxctrlpause_req,
            rxctrlbadop_req  => rxctrlbadop_req,
            txctrlpause_ack  => txctrlpause_ack,
            rxctrlpause_ack  => rxctrlpause_ack,
            rxctrlbadop_ack  => rxctrlbadop_ack,
            txctrlpause      => pft_i,
            rxctrlpause      => pfr_i,
            rxctrlbadop      => rxctrlbadop 
            );

  ---------------------------------------------------------------------
  -- Back pressure
  ---------------------------------------------------------------------
    
      U_BP : BP
      port map(
            clkt              => clkt,
            rstbp             => rstbp, 
            fd                => fd,
            bpe               => bpe,
            rxdv              => rxdv,
            fifofull          => fifofull,
            rcachenf          => rcachenf,
            txenbp            => txenbp
            );

   txen_drv: 
    txen <= txen_i or txenbp;
    
  ---------------------------------------------------------------------
  -- Statistical Counters    
  ---------------------------------------------------------------------
  U_SC : SC
    port map(  
            ---------------------- Common ports -----------------------
            clk       => clkdma,
            rst       => rstdma,
            
            -------------------- CSR status signals -------------------
            fdp       => fd,
            bsc       => scblock,
            ackb      => ackb,
            
            --------------- clearing statistical counters -------------
            clrscreq  => clrscreq,
            clrscack  => clrscack,
                        
            --------------- DP RAM receive counters -------------------
            dir       => dir,
            ramwer    => ramwer,
            ar        => ar,
            dor       => dor,

            --------------- DP RAM transmit counters ------------------
            dit       => dit,
            ramwet    => ramwet,
            at        => at,
            dot       => dot,
                        
            ------------------- rx status signals ---------------------
            wsr       => rcachere,
            flr       => fl_o,
            mfr       => rmf_o,
            bfr       => rbf_o,
            tl        => tl_o,
            rf        => rf_o,
            ae        => db_o,
            ce        => ce_o,
            pfr       => pfr_i,

            ------------------- tx status signals ---------------------
            wst       => tcachere,
            flt       => toc_i,
            mft       => tmf_i,
            bft       => tbf_i,
            cn        => cc_i, 
            df        => de_i, 
            cl        => lo_i, 
            nc        => nc_i, 
            lc        => lc_i, 
            ec        => ec_i, 
            ur        => ur_i, 
            pft       => pft_i
  );

--  pfr_i     <= '0';
--  pft_i     <= '0';


  ---------------------------------------------------------------------
  -- gigabit mode selection
  -- redirection
  ---------------------------------------------------------------------
  gbo_drv:
    gbo <= gb;
  
  ---------------------------------------------------------------------
  -- receive dp ram write enable
  -- registered output
  ---------------------------------------------------------------------
  rwe_drv:
    rwe <= irwe;
  
  ---------------------------------------------------------------------
  -- receive dp ram write data
  -- registered output
  ---------------------------------------------------------------------
  rwdata_drv:
  rwdata <= irwdata;
  
  ---------------------------------------------------------------------
  -- unused software miism
  ---------------------------------------------------------------------
  noconnect_mdi_drv:
    noconnect_mdi <= '0';
  
end STR;
--*******************************************************************--
